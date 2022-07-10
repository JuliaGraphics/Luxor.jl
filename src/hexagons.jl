# algorithms from https://www.redblobgames.com/grids/hexagons/
# first adapted by GiovineItalia/Hexagons.jl
# then further tweaked for Luxor use

abstract type Hexagon end

"""
    HexagonOffsetOddR

odd rows shifted right
"""
struct HexagonOffsetOddR <: Hexagon
    q::Int64
    r::Int64
    origin::Point
    width::Float64
    height::Float64
end

"""
    HexagonOffsetEvenR

even rows shifted right
"""
struct HexagonOffsetEvenR <: Hexagon
    q::Int64
    r::Int64
    origin::Point
    width::Float64
    height::Float64
end

"""
    HexagonAxial

Two axes

q:: first index
r:: second index
origin::Point
width:: of tile
height:: of tile
"""
struct HexagonAxial <: Hexagon
    q::Int64
    r::Int64
    origin::Point
    width::Float64
    height::Float64
end

"""
    HexagonCubic

Three axes

q:: first index
r:: second index
origin::Point
width:: of tile
height:: of tile
"""
struct HexagonCubic <: Hexagon
    q::Int64
    r::Int64
    s::Int64
    origin::Point
    width::Float64
    height::Float64
end

# """
#     hexagon(q::Int64, r::Int64, s::Int64)

# calls HexagonCubic(q, r, s, Point(0, 0), 10.0, 10.0)
# """
# hexagon(q::Int64, r::Int64, s::Int64) = HexagonCubic(q, r, s, Point(0, 0), 10.0, 10.0)

# """
#     hexagon(q::Int64, r::Int64)

# calls HexagonAxial(q, r, Point(0, 0), 10.0, 10.0)
# """
# hexagon(q::Int64, r::Int64) = HexagonAxial(q, r, Point(0, 0), 10.0, 10.0)

HexagonAxial(q, r) = HexagonAxial(q, r, Point(0, 0), 10.0, 10.0)
HexagonAxial(q, r, w) = HexagonAxial(q, r, Point(0, 0), w, w)

HexagonCubic(x, y, z) = HexagonCubic(x, y, z, Point(0, 0), 10.0, 10.0)
HexagonCubic(x, y, z, w) = HexagonCubic(x, y, z, Point(0, 0), w, w)

HexagonOffsetOddR(q, r) = HexagonOffsetOddR(q, r, Point(0, 0), 10.0, 10.0)
HexagonOffsetOddR(q, r, w) = HexagonOffsetOddR(q, r, Point(0, 0), w, w)
HexagonOffsetEvenR(q, r) = HexagonOffsetEvenR(q, r, Point(0, 0), 10.0, 10.0)
HexagonOffsetEvenR(q, r, w) = HexagonOffsetEvenR(q, r, Point(0, 0), w, w)

function Base.convert(::Type{HexagonAxial}, hex::HexagonCubic)
    HexagonAxial(hex.q, hex.s, hex.origin, hex.width, hex.height)
end

function Base.convert(::Type{HexagonAxial}, hex::HexagonOffsetOddR)
    convert(HexagonAxial, convert(HexagonCubic, hex))
end

function Base.convert(::Type{HexagonAxial}, hex::HexagonOffsetEvenR)
    convert(HexagonAxial, convert(HexagonCubic, hex))
end

function Base.convert(::Type{HexagonCubic}, hex::HexagonAxial)
    HexagonCubic(hex.q, -hex.q - hex.r, hex.r, hex.origin, hex.width, hex.height)
end

function Base.convert(::Type{HexagonCubic}, hex::HexagonOffsetOddR)
    q = hex.q - (hex.r >> 1)
    s = hex.r
    r = -q - s
    HexagonCubic(q, r, s, hex.origin, hex.width, hex.height)
end

function Base.convert(::Type{HexagonCubic}, hex::HexagonOffsetEvenR)
    q = hex.q - (hex.r >> 1) - Int(isodd(hex.r)) # ?
    s = hex.r
    r = -q - s
    HexagonCubic(q, r, s, hex.origin, hex.width, hex.height)
end

function Base.convert(::Type{HexagonOffsetOddR}, hex::HexagonCubic)
    q = hex.q + (hex.s >> 1)
    r = hex.s
    HexagonOffsetOddR(q, r, hex.origin, hex.width, hex.height)
end

function Base.convert(::Type{HexagonOffsetOddR}, hex::HexagonAxial)
    convert(HexagonOffsetOddR, convert(HexagonCubic, hex))
end

function Base.convert(::Type{HexagonOffsetEvenR}, hex::HexagonCubic)
    q = hex.q + (hex.s >> 1) + Int(isodd(hex.s))
    r = hex.s
    HexagonOffsetEvenR(q, r, hex.origin, hex.width, hex.height)
end

function Base.convert(::Type{HexagonOffsetEvenR}, hex::HexagonAxial)
    convert(HexagonOffsetEvenR, convert(HexagonCubic, hex))
end

struct HexagonNeighborIterator
    hex::HexagonCubic
end

const CUBIC_HEX_NEIGHBOR_OFFSETS = [
    1 -1 0
    1 0 -1
    0 1 -1
    -1 1 0
    -1 0 1
    0 -1 1
]

hexneighbors(hex::Hexagon) = HexagonNeighborIterator(convert(HexagonCubic, hex))

Base.length(::HexagonNeighborIterator) = 6

function Base.iterate(it::HexagonNeighborIterator, state = 1)
    state > 6 && return nothing
    dx = CUBIC_HEX_NEIGHBOR_OFFSETS[state, 1]
    dy = CUBIC_HEX_NEIGHBOR_OFFSETS[state, 2]
    dz = CUBIC_HEX_NEIGHBOR_OFFSETS[state, 3]
    hexneighbor = HexagonCubic(it.hex.x + dx, it.hex.y + dy, it.hex.z + dz)
    return (hexneighbor, state + 1)
end

struct HexagonDiagonalIterator
    hex::HexagonCubic
end

const CUBIC_HEX_DIAGONAL_OFFSETS = [
    +2 -1 -1
    +1 +1 -2
    -1 +2 -1
    -2 +1 +1
    -1 -1 +2
    +1 -2 +1
]

hexdiagonals(hex::Hexagon) = HexagonDiagonalIterator(convert(HexagonCubic, hex))

Base.length(::HexagonDiagonalIterator) = 6

function Base.iterate(it::HexagonDiagonalIterator, state = 1)
    state > 6 && return nothing
    dx = CUBIC_HEX_DIAGONAL_OFFSETS[state, 1]
    dy = CUBIC_HEX_DIAGONAL_OFFSETS[state, 2]
    dz = CUBIC_HEX_DIAGONAL_OFFSETS[state, 3]
    diagonal = HexagonCubic(it.hex.x + dx, it.hex.y + dy, it.hex.z + dz)
    return (diagonal, state + 1)
end

struct HexagonVertexIterator
    x_center::Float64
    y_center::Float64
    xsize::Float64
    ysize::Float64

    function HexagonVertexIterator(x, y, xsize = 10.0, ysize = 10.0)
        new(Float64(x),
            Float64(y),
            Float64(xsize),
            Float64(ysize))
    end

    function HexagonVertexIterator(hex::Hexagon,
        xsize = hex.width,
        ysize = hex.height,
        xoff = hex.origin.x,
        yoff = hex.origin.y)
        c = hexcenter(hex)
        new(Float64(c[1]),
            Float64(c[2]),
            xsize,
            ysize)
    end
end

"""
     hextile(hex::Hexagon)

Calculate the six vertices of the hexagon `hex` and return them in an array of Points.
"""
function hextile(hex::Hexagon)
    c = hexcenter(hex)
    pgon = Point[]
    for vtx in HexagonVertexIterator(c.x, c.y, hex.width, hex.height)
        push!(pgon, Point(vtx[1], vtx[2]))
    end
    return pgon
end

Base.length(::HexagonVertexIterator) = 6

function Base.iterate(it::HexagonVertexIterator, state = 1)
    state > 6 && return nothing
    theta = 2 * pi / 6 * (state - 1 + 0.5)
    x_i = it.x_center + it.xsize * cos(theta)
    y_i = it.y_center + it.ysize * sin(theta)
    return ((x_i, y_i), state + 1)
end

struct HexagonDistanceIterator
    hex::HexagonCubic
    n::Int
end

function hexagons_within(n::Int, hex::Hexagon = hexagon(0, 0))
    cubic_hex = convert(HexagonCubic, hex)
    HexagonDistanceIterator(hex, n)
end

hexagons_within(hex::Hexagon, n::Int) = hexagons_within(n, hex)

Base.length(it::HexagonDistanceIterator) = it.n * (it.n + 1) * 3 + 1

function Base.iterate(it::HexagonDistanceIterator, state = (-it.n, 0))
    q, y = state
    q > it.n && return nothing
    s = -q - y
    hex = HexagonCubic(q, y, z)
    y += 1
    if y > min(it.n, it.n - q)
        q += 1
        y = max(-it.n, -it.n - q)
    end
    return hex, (q, y)
end

function Base.collect(it::HexagonDistanceIterator)
    collect(HexagonCubic, it)
end

struct HexagonRingIterator
    hex::HexagonCubic
    n::Int
end

function hexring(n::Int, hex::Hexagon = hexagon(0, 0))
    cubic_hex = convert(HexagonCubic, hex)
    HexagonRingIterator(cubic_hex, n)
end

hexring(hex::Hexagon, n::Int) = hexring(n, hex)

Base.length(it::HexagonRingIterator) = it.n * 6

function Base.iterate(it::HexagonRingIterator,
    state::(Tuple{Int,HexagonCubic}) = (1, hexneighbor(it.hex, 5, it.n)))
    hex_i, cur_hex = state
    hex_i > length(it) && return nothing
    ring_part = div(hex_i - 1, it.n) + 1
    next_hex = hexneighbor(cur_hex, ring_part)
    cur_hex, (hex_i + 1, next_hex)
end

function Base.collect(it::HexagonRingIterator)
    collect(HexagonCubic, it)
end

# Iterator over all hexes within a certain distance

struct HexagonSpiralIterator
    hex::HexagonCubic
    n::Int
end

struct HexagonSpiralIteratorState
    hexring_i::Int
    hexring_it::HexagonRingIterator
    hexring_it_i::Int
    hexring_it_hex::HexagonCubic
end

function hexspiral(n::Int, hex::Hexagon = hexagon(0, 0))
    cubic_hex = convert(HexagonCubic, hex)
    HexagonSpiralIterator(cubic_hex, n)
end
hexspiral(hex::Hexagon, n::Int) = hexspiral(n, hex)

Base.length(it::HexagonSpiralIterator) = it.n * (it.n + 1) * 3

# The state of a HexagonSpiralIterator consists of
# 1. an Int, the index of the current ring
# 2. a HexagonRingIterator and its state to keep track 
# of the current position in the ring.

function Base.iterate(it::HexagonSpiralIterator)
    first_ring = hexring(it.hex, 1)
    iterate(it, HexagonSpiralIteratorState(1, first_ring, start(first_ring)...))
end

function Base.iterate(it::HexagonSpiralIterator, state::HexagonSpiralIteratorState)
    state.hexring_i > it.n && return nothing
    # Get current state
    hexring_i, hexring_it, hexring_it_i, hexring_it_hex =
        state.hexring_i, state.hexring_it, state.hexring_it_i, state.hexring_it_hex
    # Update state of inner iterator
    hexring_it_hex, (hexring_it_i, hexring_it_hex_next) =
        next(hexring_it, (hexring_it_i, hexring_it_hex))
    # Check if inner iterator is done, and update if necessary
    if done(hexring_it, (hexring_it_i, hexring_it_hex_next))
        hexring_i += 1
        hexring_it = ring(it.hex, hexring_i)
        hexring_it_i, hexring_it_hex_next = start(hexring_it)
    end

    hexring_it_hex, HexagonSpiralIteratorState(hexring_i, hexring_it,
        hexring_it_i, hexring_it_hex_next)
end

function Base.collect(it::HexagonSpiralIterator)
    collect(HexagonCubic, it)
end

"""
    distance(h1::Hexagon, h2::Hexagon)

Find distance between hexagons h1 and h2.
"""
function Luxor.distance(a::Hexagon, b::Hexagon)
    hexa = convert(HexagonCubic, a)
    hexb = convert(HexagonCubic, b)
    max(abs(hexa.q - hexb.q),
        abs(hexa.r - hexb.r),
        abs(hexa.s - hexb.s))
end

"""
    hexcenter(hex::Hexagon)

Find the center of the `hex` hexagon. Returns a Point.
"""
function hexcenter(hex::Hexagon)
    xsize = hex.width
    ysize = hex.height
    xoff = hex.origin.x
    yoff = hex.origin.y
    axh = convert(HexagonAxial, hex)
    return Point(xoff + xsize * sqrt(3) * (axh.q + axh.r / 2), yoff + ysize * (3 / 2) * axh.r)
end

# TODO: Split up in two functions for performance (distance)?
function hexneighbor(hex::HexagonCubic, direction::Int, distance::Int = 1)
    dx = CUBIC_HEX_NEIGHBOR_OFFSETS[direction, 1] * distance
    dy = CUBIC_HEX_NEIGHBOR_OFFSETS[direction, 2] * distance
    dz = CUBIC_HEX_NEIGHBOR_OFFSETS[direction, 3] * distance
    HexagonCubic(hex.x + dx, hex.y + dy, hex.z + dz)
end

function hexcube_linedraw(a::Hexagon, b::Hexagon)
    hexa = convert(HexagonCubic, a)
    hexb = convert(HexagonCubic, b)
    N = distance(hexa, hexb)
    dx, dy, dz = hexb.q - hexa.q, hexb.r - hexa.r, hexb.s - hexa.s
    ax, ay, az = hexa.q + 1e-6, hexa.r + 1e-6, hexa.s - 2e-6
    map(i -> hexnearest_cubic(ax + i * dx, ay + i * dy, az + i * dz), 0:(1 / N):1)
end

"""
    hexnearest_cubic(x::Real, y::Real, z::Real)

Find the nearest hexagon in cubic coordinates.
"""
function hexnearest_cubic(x::Real, y::Real, z::Real)
    rx, ry, rz = round(Integer, x), round(Integer, y), round(Integer, z)
    x_diff, y_diff, z_diff = abs(rx - x), abs(ry - y), abs(rz - z)

    if x_diff > y_diff && x_diff > z_diff
        rx = -ry - rz
    elseif y_diff > z_diff
        ry = -rx - rz
    else
        rz = -rx - ry
    end
    HexagonCubic(rx, ry, rz, Point(0, 0), 10.0, 10.0)
end

"""
    hexcube_round(x, y, xsize = 10.0, ysize = 10.0)

Return the index (in cubic coordinates) of the hexagon containing the
point x, y.

A point in Cartesian space can be mapped to the index of the hexagon that contains it.
"""
function hexcube_round(x, y, xsize = 10.0, ysize = 10.0)
    x /= xsize
    y /= ysize
    q = sqrt(3) / 3 * x - y / 3
    r = 2 * y / 3
    h = hexnearest_cubic(q, -q - r, r)
    return h
end