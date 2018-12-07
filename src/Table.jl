mutable struct Table
    rowheights::Array{T, 1} where T <: Real
    colwidths::Array{T, 1} where T <: Real
    nrows::Int
    ncols::Int
    currentrow::Int
    currentcol::Int
    leftmargin::Real
    topmargin::Real
    center::Point
end

"""
    t = Table(nrows, ncols)
    t = Table(nrows, ncols, colwidth, rowheight)
    t = Table(rowheights, columnwidths)

Tables are centered at `O`, but you can supply a point after the specifications.

    t = Table(nrows, ncols, centerpoint)
    t = Table(nrows, ncols, colwidth, rowheight, centerpoint)
    t = Table(rowheights, columnwidths, centerpoint)

Examples

Simple tables

    t = Table(4, 3) # 4 rows and 3 cols, default is 100w, 50 h
    t = Table(4, 3, 80, 30)   # 4 rows of 30pts high, 3 cols of 80pts wide
    t = Table(4, 3, (80, 30)) # same
    t = Table((4, 3), (80, 30)) # same

Specify row heights and column widths instead of quantities:

    t = Table([60, 40, 100], 50) # 3 different height rows, 1 column 50 wide
    t = Table([60, 40, 100], [100, 60, 40]) # 3 rows, 3 columns
    t = Table(fill(30, (10)), [50, 50, 50]) # 10 rows 30 high, 3 columns 10 wide
    t = Table(50, [60, 60, 60]) # just 1 row (50 high), 3 columns 60 wide
    t = Table([50], [50]) # just 1 row, 1 column, both 50 units wide
    t = Table(50, 50, 10, 5) # 50 rows, 50 columns, 10 units wide, 5 units high
    t = Table([6, 11, 16, 21, 26, 31, 36, 41, 46], [6, 11, 16, 21, 26, 31, 36, 41, 46])
    t = Table(15:5:55, vcat(5:2:15, 15:-2:5))
     #  table has 108 cells, with:
     #  row heights: 15 20 25 30 35 40 45 50 55
     #  col widths:  5 7 9 11 13 15 15 13 11 9 7 5
    t = Table(vcat(5:10:60, 60:-10:5), vcat(5:10:60, 60:-10:5))
    t = Table(vcat(5:10:60, 60:-10:5), 50) # 1 column 50 units wide
    t = Table(vcat(5:10:60, 60:-10:5), 1:5:50)

A Table is an iterator that, for each iteration, returns a tuple of:

- the `x`/`y` point of the center of cells arranged in rows and columns (relative to current 0/0)

- the number of the cell (left to right, then top to bottom)

`nrows`/`ncols` are the number of rows and columns required.

It's sometimes useful to know which row and column you're currently on while iterating:

```
t.currentrow
t.currentcol
```

and row heights and column widths are available in:

```
t.rowheights
t.colwidths
```

`box(t::Table, r, c)` can be used to fill table cells:

```
@svg begin
    for (pt, n) in (t = Table(8, 3, 30, 15))
        randomhue()
        box(t, t.currentrow, t.currentcol, :fill)
        sethue("white")
        text(string(n), pt)
    end
end
```

or without iteration, using cellnumber:

```
@svg begin
    t = Table(8, 3, 30, 15)
    for n in eachindex(t)
        randomhue()
        box(t, n, :fill)
        sethue("white")
        text(string(n), t[n])
    end
end
```

To use a Table to make grid points:

```
julia> first.(collect(Table(10, 6)))
60-element Array{Luxor.Point,1}:
 Luxor.Point(-10.0, -18.0)
 Luxor.Point(-6.0, -18.0)
 Luxor.Point(-2.0, -18.0)
 ⋮
 Luxor.Point(2.0, 18.0)
 Luxor.Point(6.0, 18.0)
 Luxor.Point(10.0, 18.0)
```

which returns an array of points that are the center points of the cells in the table.
"""
function Table(nrows::Int, ncols::Int, cellwidth, cellheight, center=O)
    currentrow = 1
    currentcol = 1
    rowheights = fill(cellheight, nrows)
    colwidths  = fill(cellwidth, ncols)
    leftmargin = center.x - sum(colwidths)/2
    topmargin  = center.y - sum(rowheights)/2
    Table(rowheights, colwidths, nrows, ncols, currentrow, currentcol, leftmargin, topmargin, center)
end

# simple: nrows, ncols, (width, height)
Table(nrows::Int, ncols::Int, wh::NTuple{2, T}, center=O) where T <: Real =
    Table(nrows, ncols, wh[1], wh[2], center)

# simple: (nrows, ncols)
Table(rc::NTuple{2, T}, center=O) where T <: Int =
    Table(rc[1], rc[2], center)

# simple: (nrows, ncols), (width, height)
Table(rc::NTuple{2, T1}, wh::NTuple{2, T2}, center=O) where T1 <: Int where T2 <: Real =
    Table(rc[1], rc[2], wh[1], wh[2], center)

# simple: nrows, ncols using default of 100w 50 h
function Table(nrows::Int, ncols::Int, center=O)
    cellwidth  = 100
    cellheight = 50
    Table(nrows, ncols, cellwidth, cellheight, center)
end

# row heights in array, column widths in array
function Table(rowheights::Array{T1, 1}, colwidths::Array{T2, 1}, center=O) where T1 <: Real where T2 <: Real
    rowheights = collect(Iterators.flatten(rowheights))
    colwidths =  collect(Iterators.flatten(colwidths))
    nrows = length(rowheights)
    ncols = length(colwidths)
    currentrow = 1
    currentcol = 1
    leftmargin = center.x - sum(colwidths)/2
    topmargin  = center.y - sum(rowheights)/2
    Table(rowheights, colwidths, nrows, ncols, currentrow, currentcol, leftmargin, topmargin, center)
end

# row heights in array, a single column width
Table(rowheights::Array{T1, 1}, colwidth::T2, center=O) where T1 <: Real where T2 <: Real =
    Table(rowheights, [colwidth], center)

# a single row height, column widths in an array
Table(row_height::T1, colwidths::Array{T2, 1}, center=O) where T1 <: Real where T2 <: Real =
    Table([row_height], colwidths, center)

# a range of row heights, a range of column widths
Table(rowheights::AbstractRange{T1}, colwidths::AbstractRange{T2}, center=O) where T1 <: Real where T2 <: Real =
    Table(collect(rowheights), collect(colwidths), center)

# an array of row heights, a range of column widths
Table(rowheights::Array{T1, 1}, colwidths::AbstractRange{T2}, center=O) where T1 <: Real where T2 <: Real =
    Table(rowheights, collect(colwidths), center)

# a range of row heights, an array of column widths
Table(rowheights::AbstractRange{T1}, colwidths::Array{T2, 1}, center=O) where T1 <: Real where T2 <: Real =
    Table(collect(rowheights), colwidths, center)

# interfaces

function Base.iterate(t::Table)
    x = t.leftmargin + (t.colwidths[1]/2)
    y = t.topmargin  + (t.rowheights[1]/2)
    cellnumber = 2
    t.currentrow = min(div(cellnumber - 1, t.ncols) + 1, 1)
    t.currentcol = mod1(cellnumber, t.ncols)
    x1 = t.leftmargin + sum(t.colwidths[1:t.currentcol - 1]) + t.colwidths[t.currentcol]/2
    y1 = t.topmargin  + sum(t.rowheights[1:t.currentrow - 1]) + t.rowheights[t.currentrow]/2
    nextpoint = Point(x1, y1)
    return ((Point(x, y), 1), (nextpoint, 2))
end

function Base.iterate(t::Table, state)
    if state[2] > t.nrows * t.ncols
        return
    end
    # state[1] is the Point
    x = state[1].x
    y = state[1].y
    # state[2] is the cellnumber
    cellnumber = state[2]
    # next pos
    t.currentrow = div(cellnumber - 1, t.ncols) + 1
    t.currentcol = mod1(cellnumber, t.ncols)
    x1 = t.leftmargin + sum(t.colwidths[1:t.currentcol - 1]) + t.colwidths[t.currentcol]/2
    y1 = t.topmargin  + sum(t.rowheights[1:t.currentrow - 1]) + t.rowheights[t.currentrow]/2
    nextpoint = Point(x1, y1)
    return ((nextpoint, cellnumber), (nextpoint, cellnumber + 1))
end

function Base.size(t::Table)
    return (t.nrows, t.ncols)
end

function Base.length(t::Table)
    t.nrows * t.ncols
end

Base.lastindex(t::Table) = length(t)

Base.eltype(::Type{Table}) = Tuple

function Base.getindex(t::Table, i::Int)
    1 <= i <= t.ncols * t.nrows || throw(BoundsError(t, i))
    currentrow = div(i - 1, t.ncols) + 1
    currentcol = mod1(i, t.ncols)
    x1 = t.leftmargin + sum(t.colwidths[1:currentcol - 1]) + t.colwidths[currentcol]/2
    y1 = t.topmargin  + sum(t.rowheights[1:currentrow - 1]) + t.rowheights[currentrow]/2
    return  Point(x1, y1)
end

# t[r, c] -> Luxor.Point(0.0, -192.5)
function Base.getindex(t::Table, r::Int, c::Int)
    r <= t.nrows || throw(BoundsError(t, r))
    c <= t.ncols || throw(BoundsError(t, c))
    x1 = t.leftmargin + sum(t.colwidths[1:c - 1]) + t.colwidths[c]/2
    y1 = t.topmargin  + sum(t.rowheights[1:r - 1]) + t.rowheights[r]/2
    return  Point(x1, y1)
end

Base.getindex(t::Table, I) = [t[i] for i in I]

# get row:    t[1, :]
Base.getindex(t::Table, r::Int64, ::Colon) = [t[r, n] for n in 1:t.ncols]

# get column: t[:, 3]
Base.getindex(t::Table, ::Colon, c::Int64) = [t[n, c] for n in 1:t.nrows]

# box extensions
"""
    box(t::Table, r::Int, c::Int, action::Symbol=:nothing)

Draw a box in table `t` at row `r` and column `c`.
"""
function box(t::Table, r::Int, c::Int, action::Symbol=:nothing)
    cellw, cellh = t.colwidths[c], t.rowheights[r]
    box(t[r, c], cellw, cellh, action)
end

"""
    box(t::Table, cellnumber::Int, action::Symbol=:nothing; vertices=false)

Draw box `cellnumber` in table `t`.
"""
function box(t::Table, cellnumber::Int, action::Symbol=:nothing; vertices=false)
    r = div(cellnumber - 1, t.ncols) + 1
    c = mod1(cellnumber, t.ncols)

    cellw, cellh = t.colwidths[c], t.rowheights[r]
    box(t[r, c], cellw, cellh, action; vertices=vertices)
end

"""
    highlightcells(t::Table, cellnumbers, action::Symbol=:stroke;
            color::Colorant=colorant"red",
            offset = 0)

Highlight (draw or fill) one or more cells of table `t`. `cellnumbers` is a range,
array, or an array of row/column tuples.

    highlightcells(t, 1:10, :fill, color=colorant"blue")
    highlightcells(t, vcat(1:5, 150), :stroke, color=colorant"magenta")
    highlightcells(t, [(4, 5), (3, 6)])
"""
function highlightcells(t::Table, cellnumbers, action::Symbol=:stroke;
        color::Colorant=colorant"red",
        offset = 0)
    sethue(color)
    for cell in cellnumbers
        if isa(cell, Tuple)
            row, col = cell
            box(t[row, col], t.colwidths[col] + offset, t.rowheights[row] + offset, action)
        else
            ci = CartesianIndices((t.ncols, t.nrows))[cell]
            col = ci.I[1]
            row = ci.I[2]
            box(t[cell], t.colwidths[col] + offset, t.rowheights[row] + offset, action)
        end
    end
end
