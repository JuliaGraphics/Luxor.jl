"""
    tiles = Tiler(areawidth, areaheight, nrows, ncols, margin=20)

A Tiler is an iterator that, for each iteration, returns a tuple of:

  - the `x`/`y` point of the center of each tile in a set of tiles that divide up a
    rectangular space such as a page into rows and columns (relative to current 0/0)

  - the number of the tile

`areawidth` and `areaheight` are the dimensions of the area to be tiled, `nrows`/`ncols`
are the number of rows and columns required, and `margin` is applied to all four
edges of the area before the function calculates the tile sizes required.

Tiler and Partition are similar:

  - Partition lets you specify the width and height of a cell

  - Tiler lets you specify how many rows and columns of cells you want, and a margin:

```julia
tiles = Tiler(1000, 800, 4, 5, margin=20)
for (pos, n) in tiles
    # the point pos is the center of the tile
end
```

You can access the calculated tile width and height like this:

```julia
tiles = Tiler(1000, 800, 4, 5, margin=20)
for (pos, n) in tiles
    ellipse(pos.x, pos.y, tiles.tilewidth, tiles.tileheight, :fill)
end
```

It's sometimes useful to know which row and column you're currently on.
`tiles.currentrow` and `tiles.currentcol` should have that information for you.

To use a Tiler to make grid points:

```julia
first.(collect(Tiler(800, 800, 4, 4)))
```

which returns an array of points that are the center points of the grid.
"""
mutable struct Tiler
    areawidth::Union{Float64, Int}
    areaheight::Union{Float64, Int}
    tilewidth::Union{Float64, Int}
    tileheight::Union{Float64, Int}
    nrows::Int
    ncols::Int
    currentrow::Int
    currentcol::Int
    margin::Union{Float64,Int}
    function Tiler(areawidth, areaheight, nrows::Int, ncols::Int; margin = 10.0)
        tilewidth = (areawidth - 2margin) / ncols
        tileheight = (areaheight - 2margin) / nrows
        currentrow = 1
        currentcol = 1
        new(areawidth, areaheight, tilewidth, tileheight, nrows, ncols, currentrow, currentcol, margin)
    end
end

function Base.iterate(pt::Tiler)
    x = -(pt.areawidth / 2) + pt.margin + (pt.tilewidth / 2)
    y = -(pt.areaheight / 2) + pt.margin + (pt.tileheight / 2)
    tilenumber = 1
    x1 = x + pt.tilewidth
    y1 = y
    if x1 > (pt.areawidth / 2) - pt.margin
        y1 += pt.tileheight
        x1 = -(pt.areawidth / 2) + pt.margin + (pt.tilewidth / 2)
    end
    pt.currentrow, pt.currentcol = (div(tilenumber - 1, pt.ncols) + 1, mod1(tilenumber, pt.ncols))
    return ((Point(x, y), tilenumber), (Point(x1, y1), tilenumber + 1))
end

function Base.iterate(pt::Tiler, state)
    if state[2] > (pt.nrows * pt.ncols)
        return
    end
    x = state[1].x
    y = state[1].y
    tilenumber = state[2]
    x1 = x + pt.tilewidth
    y1 = y
    if x1 > (pt.areawidth / 2) - pt.margin
        y1 += pt.tileheight
        x1 = -(pt.areawidth / 2) + pt.margin + (pt.tilewidth / 2)
    end
    pt.currentrow, pt.currentcol = (div(tilenumber - 1, pt.ncols) + 1, mod1(tilenumber, pt.ncols))
    return ((Point(x, y), tilenumber), (Point(x1, y1), tilenumber + 1))
end

function Base.length(pt::Tiler)
    pt.nrows * pt.ncols
end

function Base.getindex(pt::Tiler, i::Int)
    1 <= i <= pt.ncols * pt.nrows || throw(BoundsError(pt, i))
    xcoord = -pt.areawidth / 2 + pt.margin + mod1(i, pt.ncols) * pt.tilewidth - pt.tilewidth / 2
    ycoord = -pt.areaheight / 2 + pt.margin + (div(i - 1, pt.ncols) * pt.tileheight) + pt.tileheight / 2
    return (Point(xcoord, ycoord), i)
end

function Base.getindex(t::Tiler, r::Int, c::Int)
    n = ((r - 1) * t.ncols) + c
    return first(t[n])
end

function Base.size(pt::Tiler)
    return (pt.nrows, pt.ncols)
end

Base.lastindex(pt::Tiler) = length(pt)
Base.firstindex(pt::Tiler) = 1

Base.eltype(::Type{Tiler}) = Tuple

Base.getindex(pt::Tiler, I) = [pt[i] for i in I]

"""
    GridRect(startpoint, xspacing, yspacing, width, height)

Define a rectangular grid, to start at `startpoint` and proceed along the x-axis in
steps of `xspacing`, then along the y-axis in steps of `yspacing`.

    GridRect(startpoint, xspacing=100.0, yspacing=100.0, width=1200.0, height=1200.0)

For a column, set the `xspacing` to 0:

    grid = GridRect(O, 0, 40)

To get points from the grid, use `nextgridpoint(g::Grid)`.
```julia
julia> grid = GridRect(O, 0, 40);

julia> nextgridpoint(grid)
Point(0.0, 0.0)

julia> nextgridpoint(grid)
Point(0.0, 40.0)
```

When you run out of grid points, you'll wrap round and start again.
"""
mutable struct GridRect
    startpoint::Point
    currentpoint::Point
    xspacing::Float64
    yspacing::Float64
    width::Float64
    height::Float64
    rownumber::Int
    colnumber::Int
    function GridRect(startpoint, xspacing, yspacing, width = 1200.0, height = 1200.0)
        rownumber = 1
        colnumber = 0
        # find the "previous" point, so that the first call gets the real first point
        xspacing == 0 ? sp = startpoint.y - yspacing : sp = startpoint.y
        currentpoint = Point(startpoint.x - xspacing, sp)
        new(startpoint, currentpoint, xspacing, yspacing, width, height, rownumber, colnumber)
    end
end

"""
    GridHex(startpoint, radius, width=1200.0, height=1200.0)

Define a hexagonal grid, to start at `startpoint` and proceed along the x-axis and
then along the y-axis, `radius` is the radius of a circle that encloses each hexagon.
The distance in `x` between the centers of successive hexagons is:

``\\frac{\\sqrt{(3)} \\text{radius}}{2}``

To get the next point from the grid, use `nextgridpoint(g::Grid)`.

When you run out of grid points, you'll wrap round and start again.
"""
mutable struct GridHex
    startpoint::Point
    radius::Float64
    currentpoint::Point
    width::Float64
    height::Float64
    rownumber::Int
    colnumber::Int
    function GridHex(startpoint, radius, width = 1200.0, height = 1200.0)
        rownumber = 1
        colnumber = 0
        # find the "previous" point, so that the first call gets the real first point
        currentpoint = Point(startpoint.x - (sqrt(3) * radius), startpoint.y)
        new(startpoint, radius, currentpoint, width, height, rownumber, colnumber)
    end
end

"""
    nextgridpoint(g::GridRect)

Returns the next available (or even the first) grid point of a grid.
"""
function nextgridpoint(g::GridRect)
    temp = Point(g.currentpoint.x + g.xspacing, g.currentpoint.y)
    if g.xspacing == 0
        g.rownumber += 1
        g.colnumber = 1
        g.currentpoint = Point(g.startpoint.x, temp.y + g.yspacing)
    else
        g.colnumber += 1
        g.currentpoint = temp
    end
    if abs(g.startpoint.x - temp.x) >= g.width # next row?
        g.rownumber += 1
        g.colnumber = 1
        g.currentpoint = Point(g.startpoint.x, temp.y + g.yspacing)
    end
    if g.currentpoint.y >= g.height   # finished, start again?
        g.rownumber = 1
        g.colnumber = 1
        g.currentpoint = Point(g.startpoint.x, g.startpoint.y)
    end
    return g.currentpoint
end

"""
    nextgridpoint(g::GridHex)

Returns the next available grid point of a hexagonal grid.
"""
function nextgridpoint(g::GridHex)
    g.currentpoint = Point(g.currentpoint.x + (g.radius * sqrt(3)), g.currentpoint.y)
    g.colnumber += 1
    if g.currentpoint.x >= g.width                 # next row
        g.rownumber += 1
        g.colnumber = 1
        if g.rownumber % 2 == 0
            g.currentpoint = Point(g.startpoint.x + (sqrt(3) * g.radius) / 2, g.currentpoint.y + (3 / 2) * g.radius)
        else
            g.currentpoint = Point(g.startpoint.x, g.currentpoint.y + (3 / 2) * g.radius)
        end
    end
    if g.currentpoint.y >= g.height     # finished?
        g.rownumber = 1                 # start again...
        g.colnumber = 1
        g.currentpoint = Point(g.startpoint.x, g.startpoint.y)
    end
    return g.currentpoint
end

"""
    p = Partition(areawidth, areaheight, tilewidth, tileheight)

A Partition is an iterator that, for each iteration, returns a tuple of:

  - the `x`/`y` point of the center of each tile in a set of tiles that divide up a
    rectangular space such as a page into rows and columns (relative to current 0/0)

  - the number of the tile

`areawidth` and `areaheight` are the dimensions of the area to be tiled,
`tilewidth`/`tileheight` are the dimensions of the tiles.

Tiler and Partition are similar:

  - Partition lets you specify the width and height of a cell

  - Tiler lets you specify how many rows and columns of cells you want, and a margin

    ```julia
    tiles = Partition(1200, 1200, 30, 30)
    for (pos, n) in tiles

        # the point pos is the center of the tile

    end
    ```

You can access the calculated tile width and height like this:

```julia
tiles = Partition(1200, 1200, 30, 30)
for (pos, n) in tiles
    ellipse(pos.x, pos.y, tiles.tilewidth, tiles.tileheight, :fill)
end
```

It's sometimes useful to know which row and column you're currently on:

    tiles.currentrow
    tiles.currentcol

should have that information for you.

Unless the tilewidth and tileheight are exact multiples of the area width and height, you'll
see a border at the right and bottom where the tiles won't fit.
"""
mutable struct Partition
    areawidth::Union{Float64, Int}
    areaheight::Union{Float64, Int}
    tilewidth::Union{Float64, Int}
    tileheight::Union{Float64, Int}
    nrows::Int
    ncols::Int
    currentrow::Int
    currentcol::Int
    function Partition(areawidth, areaheight, tilewidth, tileheight)
        ncols = areawidth / tilewidth |> floor |> Integer
        nrows = areaheight / tileheight |> floor |> Integer
        if ncols < 1 || nrows < 1
            throw(error("partition(): not enough space for tiles that size"))
        end
        currentrow = 1
        currentcol = 1
        new(areawidth, areaheight, tilewidth, tileheight, nrows, ncols, currentrow, currentcol)
    end
end

function Base.iterate(pt::Partition)
    x = -(pt.areawidth / 2) + (pt.tilewidth / 2)
    y = -(pt.areaheight / 2) + (pt.tileheight / 2)
    tilenumber = 1
    x1 = x + pt.tilewidth
    y1 = y
    if (x1 + pt.tilewidth / 2) > (pt.areawidth / 2)
        y1 += pt.tileheight
        x1 = -(pt.areawidth / 2) + (pt.tilewidth / 2)
    end
    pt.currentrow, pt.currentcol = (div(tilenumber - 1, pt.ncols) + 1, mod1(tilenumber, pt.ncols))
    return ((Point(x, y), tilenumber), (Point(x1, y1), tilenumber + 1))
end

function Base.iterate(pt::Partition, state)
    if state[2] > (pt.nrows * pt.ncols)
        return
    end
    x = state[1].x
    y = state[1].y
    tilenumber = state[2]
    x1 = x + pt.tilewidth
    y1 = y
    if (x1 + pt.tilewidth / 2) > (pt.areawidth / 2)
        y1 += pt.tileheight
        x1 = -(pt.areawidth / 2) + (pt.tilewidth / 2)
    end
    pt.currentrow, pt.currentcol = (div(tilenumber - 1, pt.ncols) + 1, mod1(tilenumber, pt.ncols))
    return ((Point(x, y), tilenumber), (Point(x1, y1), tilenumber + 1))
end

function Base.length(pt::Partition)
    pt.nrows * pt.ncols
end

function Base.getindex(pt::Partition, i::Int)
    1 <= i <= pt.ncols * pt.nrows || throw(BoundsError(pt, i))
    xcoord = -pt.areawidth / 2 + mod1(i, pt.ncols) * pt.tilewidth - pt.tilewidth / 2
    ycoord = -pt.areaheight / 2 + (div(i - 1, pt.ncols) * pt.tileheight) + pt.tileheight / 2
    return (Point(xcoord, ycoord), i)
end

"""
    box(tiles::Tiler, n::Integer; action=:none, vertices=false, reversepath=false)
    box(tiles::Tiler, n::Integer, action::Symbol=:none; vertices=false, reversepath=false)

Draw a box in tile `n` of tiles `tiles`.
"""
function box(tiles::Tiler, n::Integer;
    action = :none,
    vertices = false,
    reversepath = false)
    tilew, tileh = tiles.tilewidth, tiles.tileheight
    if vertices == true || action == :none
        box(first(tiles[n]), tilew, tileh, action = :none, vertices = true, reversepath = reversepath)
    else
        box(first(tiles[n]), tilew, tileh, action = action, vertices = false, reversepath = reversepath)
    end
end

box(tiles::Tiler, n::Integer, action::Symbol;
    vertices = false, reversepath = false) =
    box(tiles, n, action = action, vertices = vertices, reversepath = reversepath)

"""
    BoundingBox(t::Tiler, n)

Return the Bounding Box enclosing tile `n`.
"""
function BoundingBox(t::Tiler, n)
    BoundingBox(box(first.(t)[n], t.tilewidth, t.tileheight))
end

"""
    BoundingBox(t::Tiler, r, c)

Return the Bounding Box enclosing the tile at row `r` column `c`.
"""
function BoundingBox(t::Tiler, r, c)
    return BoundingBox(t, ((r - 1) * t.ncols) + c)
end

"""
    markcells(t::Union{Tiler, Table}, cells;
        action = :stroke,
        func = nothing)

Mark the cells of Tiler/Table `t` in the `cells`.

By default a box is drawn around the cell using the current settings and filled or stroked according to `action`.

You can supply a function for the `func` keyword that can do anything you want.
The function should accept four arguments, `position`, `width`, `height`, and
`number`.

## Example

This code draws 30 circles in 5 rows and 6 columns, numbered and colored
sequentially in four colors. `getcells()` obtains a selection of the cells
from the Tiler.

```julia
@draw begin
    fontsize(30)
    #t = Table(5, 6, 60, 60)
    t = Tiler(400, 400, 5, 6)
    markcells(t, getcells(t, 1:30),
        func = (pos, w, h, n) -> begin
            sethue(["red", "green", "blue", "purple"][mod1(n, end)])
            circle(pos, w / 2, :fill)
            sethue("white")
            text(string(n), pos, halign = :center, valign = :middle)
        end)
end
```
"""
function markcells(t::Union{Tiler,Table}, cells;
        action = :stroke,
        func = nothing)
    @layer begin
        for cell in cells
            pos, n = cell
            row, col = (1 + div(n - 1, t.ncols)), mod1(n, t.ncols)
            if t isa Table
                w = t.colwidths[col]
                h = t.rowheights[row]
            else
                w = t.tilewidth
                h = t.tileheight
            end
            if isnothing(func)
                # just draw a box with current settings
                box(pos, w, h, action)
            else
                func(pos, w, h, n)
            end
        end
    end
end

"""
    getcells(t, rows, columns)

Get the Tiler or Table cells in `t` corresponding to `rows` and `columns`.

- `t` is a Tiler or Table

- `rows` is an array or range of row numbers
- `cols` is an array or range of column numbers

Use `:` for "all rows" or "all columns".

Returns an array of Tuples, where each Tuple is `(Point, Number)`.

`markcells()` can use the result of this function to mark selected cells.

## Example

```julia
@draw begin
    chessboard = Tiler(600, 600, 8, 8)
    # odd rows odd columns
    s = getcells(chessboard, 1:2:12, 1:2:12)
    markcells(chessboard, s, action = :fill)
    # even rows even columns
    s = getcells(chessboard, 2:2:12, 2:2:12)
    markcells(chessboard, s, action = :fill)
end
```
"""
function getcells(t::Union{Table,Tiler}, rows, columns)
    result = Tuple[]
    for r in rows
        r < 1 && continue
        r > t.nrows && continue
        for c in columns
            c < 1 && continue
            c > t.ncols && continue
            n = ((r - 1) * t.ncols) + c
            push!(result, (t[r, c], n))
        end
    end
    return result
end

getcells(t::Table, ::Colon, ::Colon) = getcells(t, 1:(t.nrows), 1:(t.ncols))
getcells(t::Table, ::Colon, columns) = getcells(t, 1:(t.nrows), columns)
getcells(t::Table, rows, ::Colon) = getcells(t, rows, 1:(t.ncols))

getcells(t::Tiler, ::Colon, ::Colon) = getcells(t, 1:(t.nrows), 1:(t.ncols))
getcells(t::Tiler, ::Colon, columns) = getcells(t, 1:(t.nrows), columns)
getcells(t::Tiler, rows, ::Colon) = getcells(t, rows, 1:(t.ncols))

"""
    getcells(t, n::T) where T <: AbstractRange

Get the Tiler/Table cells with numbers in range `n`.

Returns an array of Tuples, where each Tuple is `(Point, Number)`.
"""
function getcells(t, n::T) where {T<:AbstractRange}
    result = Tuple[]
    for i in n
        append!(result, getcells(t, i))
    end
    return result
end

"""
    getcells(t, a::T) where T <: AbstractArray

Get the Tiler/Table cells with numbers in array `a`.

Returns an array of Tuples, where each Tuple is `(Point, Number)`.
"""
function getcells(t, a::T) where {T<:AbstractArray}
    result = Tuple[]
    for i in a
        append!(result, getcells(t, i))
    end
    return result
end

"""
    getcells(t, n::Int)

Get the cell `n` in Tiler or Table `t`.

Returns an array of Tuples, where each Tuple is `(Point, Number)`.

!!! note

    Luxor Tables and Tilers are numbered by row then column, rather than the usual Julia column-major numbering:

```
 1  2  3  4  5
 6  7  8  9 10
11 12 13 14 15
16 17 18 19 20
```
"""
getcells(t::Table, n::Int) = [(t[n], n)] # array of tuples
getcells(t::Tiler, n::Int) = [(t[n])] # array of tuples

"""
An EquilateralTriangleGrid is an iterator that makes a grid of equilateral
triangles with side length `side` positioned on a rectangular grid with `nrows`
and `ncols`.

The first triangle is centered at `startpoint` and points up if `up` is true.

Example

```julia
nrows = 5
ncols = 8
side = 150
eqtg = EquilateralTriangleGrid(O, side, nrows, ncols)

# now you can use the iterator to generate (and draw) triangles:
for tri in eqtg
    vertices, trianglenumber = tri
    randomhue()
    poly(vertices, :fill)
end
```
"""
mutable struct EquilateralTriangleGrid
    startpoint::Point
    side::Union{Float64,Int}
    nrows::Int64
    ncols::Int64
    currentrow::Int64
    currentcol::Int64
    up::Bool
    function EquilateralTriangleGrid(startpoint, side, nrows, ncols; up = true)
        if nrows < 1 || ncols < 1
            throw(error("EquilateralTriangleGrid: grid must have rows and columns, not $nrows rows, $ncols columns"))
        end
        currentrow = 1
        currentcol = 1
        new(startpoint, side, nrows, ncols, currentrow, currentcol, up)
    end
end

"""
    _equilateral_triangle(center::Point, side, dir=:up)

Return vertices of equilateral triangle, `center` is the centroid,
`side` is the side length, `dir` is `:up` for △ (or something else for ▽)
"""
function _equilateral_triangle(center::Point, side, dir = :up)
    h = (sqrt(3) * side) / 2
    if dir == :up
        return Point[
            Point(center.x - side / 2, center.y + h / 2),
            Point(center.x, center.y - h / 2),
            Point(center.x + side / 2, center.y + h / 2),
        ]
    else
        return Point[
            Point(center.x - side / 2, center.y - h / 2),
            Point(center.x + side / 2, center.y - h / 2),
            Point(center.x, center.y + h / 2),
        ]
    end
end

function Base.iterate(eqt::EquilateralTriangleGrid)
    eqt.currentrow, eqt.currentcol = 1, 1
    cellnumber = (eqt.currentrow - 1) * eqt.nrows + eqt.currentcol
    h = (sqrt(3) * eqt.side) / 2
    pointup = (isodd(eqt.currentrow) && isodd(eqt.currentcol)) || (iseven(eqt.currentrow) && iseven(eqt.currentcol)) ? eqt.up : !eqt.up
    # the first triangle
    cpt_c = Point(eqt.startpoint.x - eqt.side/2 + (eqt.side / 2 * eqt.currentcol), 
        eqt.startpoint.y -h + (h * eqt.currentrow))
    pts_c = _equilateral_triangle(cpt_c, eqt.side, pointup ? :up : :down)
    # next one
    cpt_n = Point(eqt.startpoint.x + (eqt.side / 2 * eqt.currentcol), eqt.startpoint.y + (h * eqt.currentrow))
    pts_n = _equilateral_triangle(cpt_n, eqt.side, pointup ? :down : :up)
    return ((pts_c, cellnumber), (pts_n, cellnumber + 1))
end

function Base.iterate(eqt::EquilateralTriangleGrid, state)
    cellnumber = state[2]
    if cellnumber > (eqt.nrows * eqt.ncols)
        return
    end
    eqt.currentcol += 1
    if eqt.currentcol > eqt.ncols
        eqt.currentcol = 1
        eqt.currentrow += 1
    end
    h = (sqrt(3) * eqt.side) / 2
    pointup = (isodd(eqt.currentrow) && isodd(eqt.currentcol)) || (iseven(eqt.currentrow) && iseven(eqt.currentcol)) ? eqt.up : !eqt.up
    cpt_c = Point(eqt.startpoint.x - eqt.side / 2 + (eqt.side / 2 * eqt.currentcol),
        eqt.startpoint.y - h + (h * eqt.currentrow))
    pts_c = _equilateral_triangle(cpt_c, eqt.side, pointup ? :up : :down)
    cpt_n = Point(eqt.startpoint.x + (eqt.side / 2 * eqt.currentcol), eqt.startpoint.y + (h * eqt.currentrow))
    pts_n = _equilateral_triangle(cpt_n, eqt.side, pointup ? :down : :up)
    return ((pts_c, cellnumber), (pts_n, cellnumber + 1))
end

function Base.length(eqt::EquilateralTriangleGrid)
    eqt.nrows * eqt.ncols
end

function Base.getindex(eqt::EquilateralTriangleGrid, i::Int)
    1 <= i <= eqt.ncols * eqt.nrows || throw(BoundsError(eqt, i))
    h = (sqrt(3) * eqt.side) / 2
    c = mod1(i, eqt.ncols)
    r = 1 + div(i - 1, eqt.ncols)
    pointup = (isodd(r) && isodd(c)) || (iseven(r) && iseven(c)) ? eqt.up : !eqt.up
    cpt_c = Point(eqt.startpoint.x + (eqt.side / 2 * c), eqt.startpoint.y + (h * r))
    pts_c = _equilateral_triangle(cpt_c, eqt.side, pointup ? :up : :down)
    return pts_c
end

function Base.size(eqt::EquilateralTriangleGrid)
    return (eqt.nrows, eqt.ncols)
end