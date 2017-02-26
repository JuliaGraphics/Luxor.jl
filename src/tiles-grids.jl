"""
    tiles = Tiler(areawidth, areaheight, nrows, ncols, margin=20)

A Tiler is an iterator that, for each iteration, returns a tuple of:

- the `x`/`y` point of the center of each tile in a set of tiles that divide up a
  rectangular space such as a page into rows and columns (relative to current 0/0)

- the number of the tile

`areawidth` and `areaheight` are the dimensions of the area to be tiled, `nrows`/`ncols`
are the number of rows and columns required, and `margin` is applied to all four
edges of the area before the function calculates the tile sizes required.

    tiles = Tiler(1000, 800, 4, 5, margin=20)
    for (pos, n) in tiles
        # the point pos is the center of the tile
    end

You can access the calculated tile width and height like this:

    tiles = Tiler(1000, 800, 4, 5, margin=20)
    for (pos, n) in tiles
        ellipse(pos.x, pos.y, tiles.tilewidth, tiles.tileheight, :fill)
    end
"""
type Tiler
    areawidth::Real
    areaheight::Real
    tilewidth::Real
    tileheight::Real
    nrows::Int
    ncols::Int
    margin::Real
    function Tiler(areawidth, areaheight, nrows::Int, ncols::Int; margin=10)
        tilewidth  = (areawidth - 2margin)/ncols
        tileheight = (areaheight - 2margin)/nrows
        new(areawidth, areaheight, tilewidth, tileheight, nrows, ncols, margin)
    end
end

function Base.start(pt::Tiler)
    # return the initial state
    x = -(pt.areawidth/2)  + pt.margin + (pt.tilewidth/2)
    y = -(pt.areaheight/2) + pt.margin + (pt.tileheight/2)
    return (Point(x, y), 1)
end

function Base.next(pt::Tiler, state)
    # Returns the item and the next state
    # state[1] is the Point
    x = state[1].x
    y = state[1].y
    # state[2] is the tilenumber
    tilenumber = state[2]
    x1 = x + pt.tilewidth
    y1 = y
    if x1 > (pt.areawidth/2) - pt.margin
        y1 += pt.tileheight
        x1 = -(pt.areawidth/2) + pt.margin + (pt.tilewidth/2)
    end
    return ((Point(x, y), tilenumber), (Point(x1, y1), tilenumber + 1))
end

function Base.done(pt::Tiler, state)
    # Tests if there are any items remaining
    state[2] > (pt.nrows * pt.ncols)
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

"""
    GridRect(startpoint, xspacing, yspacing, width, height)
    
Define a rectangular grid, to start at `startpoint` and proceed along the x-axis in 
steps of `xspacing`, then along the y-axis in steps of `yspacing`. 

    Grid(startpoint, xspacing=100.0, yspacing=100.0, width=1200.0, height=1200.0)

For a column, set the `xspacing` to 0:

    grid = Grid(O, 0, 40)

To get points from the grid, use `nextgridpoint(g::Grid)`.

When you run out of grid points, you'll wrap round and start again.
"""
type GridRect
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

doc"""
    GridHex(startpoint, radius, width=1200.0, height=1200.0)

Define a hexagonal grid, to start at `startpoint` and proceed along the x-axis and 
then along the y-axis, `radius` is the radius of a circle that encloses each hexagon.
The distance in `x` between the centers of successive hexagons is:

```math
\frac{\sqrt{(3)} radius}{2}
```

To get the next point from the grid, use `nextgridpoint(g::Grid)`.

When you run out of grid points, you'll wrap round and start again.
"""
type GridHex
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
    if g.currentpoint.x > g.width # next row
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
