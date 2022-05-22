struct BoxmapTile
    x::Float64
    y::Float64
    w::Float64
    h::Float64
end


"""
    buildrow(A, x, y, w, h)

Make a row of tiles from A.
"""
function buildrow(A, x, y, w, h)
    covered = sum(A)
    width = covered/h
    tiles = BoxmapTile[]
    for value in A
        push!(tiles, BoxmapTile(x, y, width, value/width))
        y += value/width
    end
    return tiles
end

"""
    buildcolumn(A, x, y, w, h)

Make a column of tiles from A.
"""
function buildcolumn(A, x, y, w, h)
    covered = sum(A)
    height = covered/w
    tiles = BoxmapTile[]
    for value in A
        push!(tiles, BoxmapTile(x, y, value/height, height))
        x += value/height
    end
    return tiles
end

"""
    layout(A, x, y, w, h)

From A, make a row of tiles (if wider than tall) or a column of tiles (if taller than wide).
"""
function layout(A, x, y, w, h)
    if w >= h
        return buildrow(A, x, y, w, h)
    else
        return buildcolumn(A, x, y, w, h)
    end
end

function rowlayoutleftover(A, x, y, w, h)
    covered = sum(A)
    width = covered/h
    layoutleftoverx = x + width
    layoutleftoverw = w - width
    return layoutleftoverx, y, layoutleftoverw, h
end

function columnlayoutleftover(A, x, y, w, h)
    covered = sum(A)
    height = covered/w
    layoutleftovery = y + height
    layoutleftoverh = h - height
    return x, layoutleftovery, w, layoutleftoverh
end

function layoutleftover(A, x, y, w, h)
    if w >= h
        return rowlayoutleftover(A, x, y, w, h)
    else
        return columnlayoutleftover(A, x, y, w, h)
    end
end

"""
    highestaspectratio()

Find the highest aspect ratio of a list of rectangles, given the length
of the side along which they are to be laid out.
"""
function highestaspectratio(A, x, y, w, h)
    return maximum([max(tile.w/tile.h, tile.h/tile.w) for tile in layout(A, x, y, w, h)])
end

function buildboxmap(A, x, y, w, h)
    length(A) == 0 && return []
    length(A) == 1 && return layout(A, x, y, w, h)
    i = 1
    while i < length(A) &&
        (highestaspectratio(A[1:i], x, y, w, h) >= highestaspectratio(A[1:i+1], x, y, w, h))
        i += 1
    end
    layoutleftoverx, layoutleftovery, layoutleftoverw, layoutleftoverh = layoutleftover(A[1:i], x, y, w, h)
    return append!(layout(A[1:i], x, y, w, h), buildboxmap(A[i+1:end], layoutleftoverx, layoutleftovery, layoutleftoverw, layoutleftoverh))
end

"""
    boxmap(A::Array, pt, w, h)

Build a box map of the values in `A` with one corner at `pt` and width `w` and
height `h`. There are `length(A)` boxes. The areas of the boxes are proportional
to the original values, scaled as necessary.

The return value is an array of BoxmapTiles. For example:

```
[BoxmapTile(0.0, 0.0, 10.0, 20.0)
 BoxmapTile(10.0, 0.0, 10.0, 13.3333)
 BoxmapTile(10.0, 13.3333, 10.0, 6.66667)]
```

with each tile containing `(x, y, w, h)`. `box()` and `BoundingBox()` can work with
BoxmapTiles as well.

# Example

```
using Luxor
@svg begin
    fontsize(16)
    fontface("HelveticaBold")
    pt = Point(-200, -200)
    a = rand(10:200, 15)
    tiles = boxmap(a, Point(-200, -200), 400, 400)
    for (n, t) in enumerate(tiles)
        randomhue()
        bb = BoundingBox(t)
        box(bb - 2, :stroke)
        box(bb - 5, :fill)
        sethue("white")
        text(string(n), midpoint(bb[1], bb[2]), halign=:center)
    end
end 400 400 "boxmap.svg"
```
"""
function boxmap(A::Array, pt::Point, w, h)
    # algorithm basically from Bruls, Huizing, van Wijk, "Squarified Treemaps"
    # without the silly name
    !all(n -> n > 0, A) && error("all values must be positive")
    sort!(A, rev=true)
    totalvalue = sum(A)
    totalarea = w * h
    normalizedA = A .* (totalarea/totalvalue)
    return buildboxmap(normalizedA, pt.x, pt.y, w, h)
end

"""
    box(tile::BoxmapTile, action::Symbol=:none; vertices=false)
    box(tile::BoxmapTile, action=:none, vertices=false)

Use a Boxmaptile to make or draw a rectangular box. Use `vertices=true` to obtain
the coordinates.

Create boxmaps using `boxmap()`.
"""
function box(tile::BoxmapTile, action::Symbol; vertices=false)
    if vertices
        return [Point(tile.x,           tile.y + tile.h),
                Point(tile.x,           tile.y),
                Point(tile.x + tile.w,  tile.y),
                Point(tile.x + tile.w,  tile.y + tile.h)]
    end
    rect(tile.x, tile.y, tile.w, tile.h, action)
end

box(tile::BoxmapTile; action=:none, vertices=false) =
     box(tile, action, vertices=vertices)

"""
    BoundingBox(tile::BoxmapTile)

Return a BoundingBox of a BoxmapTile (as created with `boxmap()`).
"""
function BoundingBox(tile::BoxmapTile)
    lcorner = Point(tile.x, tile.y)
    ocorner = Point(lcorner.x + tile.w, lcorner.y + tile.h)
    return BoundingBox(lcorner, ocorner)
end
