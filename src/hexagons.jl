# algorithms from https://www.redblobgames.com/grids/hexagons/
# first adapted by GiovineItalia/Hexagons.jl
# then further tweaked for Julia v1 compatibility, Luxor use, etc.
"""
    Hexagon

To create a hexagon, use one of the types:

- HexagonOffsetOddR q r origin w h
- HexagonOffsetEvenR q r origin w h
- HexagonAxial q r origin w h
- HexagonCubic q r s origin w h

Functions:

- hextile(hex::Hexagon) - calculate the six vertices
- hexcenter(hex::Hexagon) - center
- hexring(n::Int, hex::Hexagon) - array of hexagons surrounding hex
- hexspiral(hex::Hexagon, n) - arry of hexagons in spiral
- hexneighbors(hex::Hexagon) - array of neighbors of hexagon
"""
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

s:: third index

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

HexagonAxial(q, r) = HexagonAxial(q, r, Point(0, 0), 10.0, 10.0)
HexagonAxial(q, r, o::Point) = HexagonAxial(q, r, o, 10.0, 10.0)
HexagonAxial(q, r, w) = HexagonAxial(q, r, Point(0, 0), w, w)
HexagonAxial(q, r, o::Point, w) = HexagonAxial(q, r, o, w, w)
HexagonAxial(q, r, w, h) = HexagonAxial(q, r, Point(0, 0), w, h)

HexagonCubic(x, y, z) = HexagonCubic(x, y, z, Point(0, 0), 10.0, 10.0)
HexagonCubic(x, y, z, o::Point) = HexagonCubic(x, y, z, o, 10.0, 10.0)
HexagonCubic(x, y, z, w) = HexagonCubic(x, y, z, Point(0, 0), w, w)
HexagonCubic(x, y, z, o::Point, w) = HexagonCubic(x, y, z, o, w, w)
HexagonCubic(x, y, z, w, h) = HexagonCubic(x, y, z, Point(0, 0), w, h)

HexagonOffsetOddR(q, r) = HexagonOffsetOddR(q, r, Point(0, 0), 10.0, 10.0)
HexagonOffsetOddR(q, r, o::Point) = HexagonOffsetOddR(q, r, o::Point, 10.0, 10.0)
HexagonOffsetOddR(q, r, w) = HexagonOffsetOddR(q, r, Point(0, 0), w, w)
HexagonOffsetOddR(q, r, o::Point, w) = HexagonOffsetOddR(q, r, o::Point, w, w)
HexagonOffsetOddR(q, r, w, h) = HexagonOffsetOddR(q, r, Point(0, 0), w, h)

HexagonOffsetEvenR(q, r) = HexagonOffsetEvenR(q, r, Point(0, 0), 10.0, 10.0)
HexagonOffsetEvenR(q, r, o::Point) = HexagonOffsetEvenR(q, r, o::Point, 10.0, 10.0)
HexagonOffsetEvenR(q, r, w) = HexagonOffsetEvenR(q, r, Point(0, 0), w, w)
HexagonOffsetEvenR(q, r, o::Point, w) = HexagonOffsetEvenR(q, r, o::Point, w, w)
HexagonOffsetEvenR(q, r, w, h) = HexagonOffsetEvenR(q, r, Point(0, 0), w, h)

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

"""
    hexneighbors(hex::Hexagon) 

Return the neighbors of `hex`.

## Example

```
julia> h = HexagonOffsetEvenR(0, 0, 70.0)

julia> hexneighbors(h)
HexagonNeighborIterator(HexagonCubic(0, 0, 0, Point(0.0, 0.0), 70.0, 70.0))

julia> collect(hexneighbors(h))
6-element Vector{Any}:
HexagonCubic(1, -1, 0, Point(0.0, 0.0), 70.0, 70.0)
HexagonCubic(1, 0, -1, Point(0.0, 0.0), 70.0, 70.0)
HexagonCubic(0, 1, -1, Point(0.0, 0.0), 70.0, 70.0)
HexagonCubic(-1, 1, 0, Point(0.0, 0.0), 70.0, 70.0)
HexagonCubic(-1, 0, 1, Point(0.0, 0.0), 70.0, 70.0)
HexagonCubic(0, -1, 1, Point(0.0, 0.0), 70.0, 70.0)
```
"""
hexneighbors(hex::Hexagon) = HexagonNeighborIterator(convert(HexagonCubic, hex))

Base.length(::HexagonNeighborIterator) = 6

function Base.iterate(it::HexagonNeighborIterator, state = 1)
    state > 6 && return nothing
    dq = CUBIC_HEX_NEIGHBOR_OFFSETS[state, 1]
    dr = CUBIC_HEX_NEIGHBOR_OFFSETS[state, 2]
    ds = CUBIC_HEX_NEIGHBOR_OFFSETS[state, 3]
    hexneighbor = HexagonCubic(it.hex.q + dq, it.hex.r + dr, it.hex.s + ds, it.hex.origin, it.hex.width, it.hex.height)
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

"""
    hexdiagonals(hex::Hexagon)

Return the six hexagons that lie on the diagonals to `hex`.
"""
hexdiagonals(hex::Hexagon) = HexagonDiagonalIterator(convert(HexagonCubic, hex))

Base.length(::HexagonDiagonalIterator) = 6

function Base.iterate(it::HexagonDiagonalIterator, state = 1)
    state > 6 && return nothing
    dq = CUBIC_HEX_DIAGONAL_OFFSETS[state, 1]
    dr = CUBIC_HEX_DIAGONAL_OFFSETS[state, 2]
    ds = CUBIC_HEX_DIAGONAL_OFFSETS[state, 3]
    diagonal = HexagonCubic(it.hex.q + dq, it.hex.r + dr, it.hex.s + ds, it.hex.origin, it.hex.width, it.hex.height)
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

"""
    hexagons_within(n::Int, hex::Hexagon)

Return all the hexagons within index distance `n` of `hex`. If `n` is 0, only
the `hex` itself is returned. If `n` is 1, `hex` and the six hexagons one index
away are returned. If `n` is 2, 19 hexagons surrounding `hex` are returned.
"""
function hexagons_within(n::Int, hex::Hexagon)
    cubic_hex = convert(HexagonCubic, hex)
    HexagonDistanceIterator(cubic_hex, n)
end

hexagons_within(hex::Hexagon, n::Int) = hexagons_within(n, hex)

Base.length(it::HexagonDistanceIterator) = it.n * (it.n + 1) * 3 + 1

function Base.iterate(it::HexagonDistanceIterator, state = (-it.n, 0))
    q, r = state
    q > it.n && return nothing
    s = -q - r
    hex = HexagonCubic(q, r, s, it.hex.origin, it.hex.width, it.hex.height)
    r += 1
    if r > min(it.n, it.n - q)
        q += 1
        r = max(-it.n, -it.n - q)
    end
    return hex, (q, r)
end

function Base.collect(it::HexagonDistanceIterator)
    collect(HexagonCubic, it)
end

struct HexagonRingIterator
    hex::HexagonCubic
    n::Int
end

"""
    hexring(n::Int, hex::Hexagon)

Return the ring of hexagons that surround `hex`. If `n` is 1, the hexagons
immediately surrounding `hex` are returned.
"""
function hexring(n::Int, hex::Hexagon)
    cubic_hex = convert(HexagonCubic, hex)
    HexagonRingIterator(cubic_hex, n)
end

hexring(hex::Hexagon, n::Int) = hexring(n, hex)

Base.length(it::HexagonRingIterator) = it.n * 6

function Base.iterate(it::HexagonRingIterator, state::(Tuple{Int,HexagonCubic}) = (1, hexneighbor(it.hex, 5, it.n)))
    hex_i, cur_hex = state
    hex_i > length(it) && return nothing
    ring_part = div(hex_i - 1, it.n) + 1
    next_hex = hexneighbor(cur_hex, ring_part)
    cur_hex, (hex_i + 1, next_hex)
end

function Base.collect(it::HexagonRingIterator)
    collect(HexagonCubic, it)
end

"""
    hexspiral(hex, n)

Return an array of hexagons to spiral around a central hexagon forming `n` rings.
"""
function hexspiral(hex, nrings)
    result = Hexagon[]
    ringn = 0
    while ringn < nrings
        ringn += 1
        hexes = collect(hexring(hex, ringn))
        # circshift!(hexes, 1) doesn't work on < v1.7 
        # replace with circshift! one day
        push!(hexes, popfirst!(hexes))
        append!(result, hexes)
    end
    return result
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

function hexneighbor(hex::HexagonCubic, direction::Int, distance::Int = 1)
    dq = CUBIC_HEX_NEIGHBOR_OFFSETS[direction, 1] * distance
    dr = CUBIC_HEX_NEIGHBOR_OFFSETS[direction, 2] * distance
    ds = CUBIC_HEX_NEIGHBOR_OFFSETS[direction, 3] * distance
    HexagonCubic(hex.q + dq, hex.r + dr, hex.s + ds, hex.origin, hex.width, hex.height)
end

"""
    hexcube_linedraw(hexa::Hexagon, hexb::Hexagon)

Find and return the hexagons that lie (mostly) on a straight line between `hexa` and `hexb`. If you filled/stroked them appropriately, you'd get a jagged line.
"""
function hexcube_linedraw(a::Hexagon, b::Hexagon)
    hexa = convert(HexagonCubic, a)
    hexb = convert(HexagonCubic, b)
    o = hexa.origin
    w = hexa.width
    h = hexa.height
    N = distance(hexa, hexb)
    dx, dy, dz = hexb.q - hexa.q, hexb.r - hexa.r, hexb.s - hexa.s
    ax, ay, az = hexa.q + 1e-6, hexa.r + 1e-6, hexa.s - 2e-6
    map(i -> hexnearest_cubic(ax + i * dx, ay + i * dy, az + i * dz, o, w, h), 0:(1 / N):1)
end

"""
     hexnearest_cubic(x::Real, y::Real, z::Real, origin, width, height)

Find the nearest hexagon in cubic coordinates, ie as
`q`, `r`, `s` integer indices, given (x, y, z) as Real numbers, with the hexagonal grid centered at `origin`, and with tiles of `width`/`height`.
"""
function hexnearest_cubic(x::Real, y::Real, z::Real, origin, width, height)
    rx, ry, rz = round(Integer, x), round(Integer, y), round(Integer, z)
    x_diff, y_diff, z_diff = abs(rx - x), abs(ry - y), abs(rz - z)

    if x_diff > y_diff && x_diff > z_diff
        rx = -ry - rz
    elseif y_diff > z_diff
        ry = -rx - rz
    else
        rz = -rx - ry
    end
    HexagonCubic(rx, ry, rz, origin, width, height)
end

"""
    hexcube_round(x, y, origin, width = 10.0, height = 10.0)

Return the hexagon containing the point x, y, on the hexagonal grid centered at `origin`, and with tiles of `width`/`height`

point in Cartesian space can be mapped to the index of the hexagon that contains it.
"""
function hexcube_round(x, y, origin = Point(0, 0), width = 10.0, height = 10.0)
    x /= width
    y /= height
    q = sqrt(3) / 3 * x - y / 3
    r = 2 * y / 3
    h = hexnearest_cubic(q, -q - r, r, origin, width, height)
    return h
end
