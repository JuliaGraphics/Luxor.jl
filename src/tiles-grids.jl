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

```
tiles = Tiler(1000, 800, 4, 5, margin=20)
for (pos, n) in tiles
    # the point pos is the center of the tile
end
```

You can access the calculated tile width and height like this:

```
tiles = Tiler(1000, 800, 4, 5, margin=20)
for (pos, n) in tiles
    ellipse(pos.x, pos.y, tiles.tilewidth, tiles.tileheight, :fill)
end
```

It's sometimes useful to know which row and column you're currently on.
`tiles.currentrow` and `tiles.currentcol` should have that information for you.

To use a Tiler to make grid points:

```
first.(collect(Tiler(800, 800, 4, 4))
```

which returns an array of points that are the center points of the grid.
"""
mutable struct Tiler
    areawidth::Real
    areaheight::Real
    tilewidth::Real
    tileheight::Real
    nrows::Int
    ncols::Int
    currentrow::Int
    currentcol::Int
    margin::Real
    function Tiler(areawidth, areaheight, nrows::Int, ncols::Int; margin=10)
        tilewidth  = (areawidth - 2margin)/ncols
        tileheight = (areaheight - 2margin)/nrows
        currentrow=1
        currentcol=1
        new(areawidth, areaheight, tilewidth, tileheight, nrows, ncols, currentrow, currentcol, margin)
    end
end

function Base.iterate(pt::Tiler)
    x = -(pt.areawidth/2)  + pt.margin + (pt.tilewidth/2)
    y = -(pt.areaheight/2) + pt.margin + (pt.tileheight/2)
    tilenumber = 1
    x1 = x + pt.tilewidth
    y1 = y
    if x1 > (pt.areawidth/2) - pt.margin
        y1 += pt.tileheight
        x1 = -(pt.areawidth/2) + pt.margin + (pt.tilewidth/2)
    end
    pt.currentrow, pt.currentcol = (div(tilenumber-1, pt.ncols)+1, mod1(tilenumber, pt.ncols))
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
    if x1 > (pt.areawidth/2) - pt.margin
        y1 += pt.tileheight
        x1 = -(pt.areawidth/2) + pt.margin + (pt.tilewidth/2)
    end
    pt.currentrow, pt.currentcol = (div(tilenumber-1, pt.ncols)+1, mod1(tilenumber, pt.ncols))
    return ((Point(x, y), tilenumber), (Point(x1, y1), tilenumber + 1))
end

function Base.length(pt::Tiler)
    pt.nrows * pt.ncols
end

function Base.getindex(pt::Tiler, i::Int)
    1 <= i <= pt.ncols *  pt.nrows || throw(BoundsError(pt, i))
    xcoord = -pt.areawidth/2  + pt.margin + mod1(i, pt.ncols) * pt.tilewidth  - pt.tilewidth/2
    ycoord = -pt.areaheight/2 + pt.margin + (div(i - 1,  pt.ncols) * pt.tileheight) + pt.tileheight/2
    return (Point(xcoord, ycoord), i)
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

    julia> grid = GridRect(O, 0, 40);
    julia> nextgridpoint(grid)
    Luxor.Point(0.0, 0.0)

    julia> nextgridpoint(grid)
    Luxor.Point(0.0, 40.0)

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
    function GridRect(startpoint, xspacing, yspacing, width=1200.0, height=1200.0)
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

``\\frac{\\sqrt{(3)} radius}{2}``

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
    function GridHex(startpoint, radius, width=1200.0, height=1200.0)
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
            g.currentpoint = Point(g.startpoint.x + (sqrt(3) * g.radius)/2, g.currentpoint.y + (3/2) * g.radius)
        else
            g.currentpoint = Point(g.startpoint.x, g.currentpoint.y + (3/2) * g.radius)
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


    tiles = Partition(1200, 1200, 30, 30)
    for (pos, n) in tiles
        # the point pos is the center of the tile
    end

You can access the calculated tile width and height like this:

    tiles = Partition(1200, 1200, 30, 30)
    for (pos, n) in tiles
        ellipse(pos.x, pos.y, tiles.tilewidth, tiles.tileheight, :fill)
    end

It's sometimes useful to know which row and column you're currently on:

    tiles.currentrow
    tiles.currentcol

should have that information for you.

Unless the tilewidth and tileheight are exact multiples of the area width and height, you'll
see a border at the right and bottom where the tiles won't fit.
"""
mutable struct Partition
    areawidth::Real
    areaheight::Real
    tilewidth::Real
    tileheight::Real
    nrows::Int
    ncols::Int
    currentrow::Int
    currentcol::Int
    function Partition(areawidth, areaheight, tilewidth, tileheight)
        ncols = areawidth  / tilewidth  |> floor |> Integer
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
    x = -(pt.areawidth/2)  + (pt.tilewidth/2)
    y = -(pt.areaheight/2) + (pt.tileheight/2)
    tilenumber = 1
    x1 = x + pt.tilewidth
    y1 = y
    if (x1 + pt.tilewidth/2) > (pt.areawidth/2)
        y1 += pt.tileheight
        x1 = -(pt.areawidth/2) + (pt.tilewidth/2)
    end
    pt.currentrow, pt.currentcol = (div(tilenumber-1, pt.ncols)+1, mod1(tilenumber, pt.ncols))
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
    if (x1 + pt.tilewidth/2) > (pt.areawidth/2)
        y1 += pt.tileheight
        x1 = -(pt.areawidth/2) + (pt.tilewidth/2)
    end
    pt.currentrow, pt.currentcol = (div(tilenumber-1, pt.ncols)+1, mod1(tilenumber, pt.ncols))
    return ((Point(x, y), tilenumber), (Point(x1, y1), tilenumber + 1))
end

function Base.length(pt::Partition)
    pt.nrows * pt.ncols
end

function Base.getindex(pt::Partition, i::Int)
    1 <= i <= pt.ncols *  pt.nrows || throw(BoundsError(pt, i))
    xcoord = -pt.areawidth/2  + mod1(i, pt.ncols) * pt.tilewidth  - pt.tilewidth/2
    ycoord = -pt.areaheight/2 + (div(i - 1,  pt.ncols) * pt.tileheight) + pt.tileheight/2
    return (Point(xcoord, ycoord), i)
end
