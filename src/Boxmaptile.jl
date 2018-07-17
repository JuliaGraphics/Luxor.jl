struct BoxmapTile
    x::Float64
    y::Float64
    w::Float64
    h::Float64
end

"""
    buildrow(A, x, y, w, h)

make a set of tiles in a row
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

make a set of tiles in a column
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

call buildrow or buildcolumn
"""
function layout(A, x, y, w, h)
    if w >= h
        return buildrow(A, x, y, w, h)
    else
        return buildcolumn(A, x, y, w, h)
    end
end

function leftoverrow(A, x, y, w, h)
    covered = sum(A)
    width = covered/h
    leftoverx = x + width
    leftoverw = w - width
    return leftoverx, y, leftoverw, h
end

function leftovercol(A, x, y, w, h)
    covered = sum(A)
    height = covered/w
    leftovery = y + height
    leftoverh = h - height
    return x, leftovery, w, leftoverh
end

function leftover(A, x, y, w, h)
    if w >= h
        return leftoverrow(A, x, y, w, h)
    else
        return leftovercol(A, x, y, w, h)
    end
end

"""
    worst()

Find the highest aspect ratio of a list of rectangles, given the length
of the side along which they are to be laid out.
"""
function worst(A, x, y, w, h)
    return maximum([max(tile.w/tile.h, tile.h/tile.w) for tile in layout(A, x, y, w, h)])
end

function buildboxmap(A, x, y, w, h)
    length(A) == 0 && return []
    length(A) == 1 && return layout(A, x, y, w, h)
    i = 1
    while i < length(A) &&
        (worst(A[1:i], x, y, w, h) >= worst(A[1:i+1], x, y, w, h))
        i += 1
    end
    leftoverx, leftovery, leftoverw, leftoverh = leftover(A[1:i], x, y, w, h)
    return append!(layout(A[1:i], x, y, w, h), buildboxmap(A[i+1:end], leftoverx, leftovery, leftoverw, leftoverh))
end

"""
    boxmap(A, pt, w, h)

Build a box map with one corner at `pt` and width `w` and height `h`. There are
`length(A)` boxes. The areas of the boxes are proportional to the original
values, scaled as necessary.

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
end 400 400 "/tmp/boxmap.svg"
```
"""
function boxmap(A, pt::Point, w, h)
    !all(n -> n > 0, A) && error("all values must be positive")
    sort!(A, rev=true)
    totalvalue = sum(A)
    totalarea = w * h
    normalizedA = A .* (totalarea/totalvalue)
    return buildboxmap(normalizedA, pt.x, pt.y, w, h)
end

"""
    box(tile::BoxmapTile, action::Symbol=:nothing; vertices=false)

Use a Boxmaptile to make or draw a rectangular box. Use `vertices=true` to obtain
the coordinates.

Create boxmaps using `boxmap()`.
"""
function box(tile::BoxmapTile, action::Symbol=:nothing; vertices=false)
    if vertices
        return [Point(tile.x,           tile.y + tile.h),
                Point(tile.x,           tile.y),
                Point(tile.x + tile.w,  tile.y),
                Point(tile.x + tile.w,  tile.y + tile.h)]
    end
    rect(tile.x, tile.y, tile.w, tile.h, action)
end

"""
    BoundingBox(tile::BoxmapTile)

Return a BoundingBox of a BoxmapTile (as created with `boxmap()`).
"""
function BoundingBox(tile::BoxmapTile)
    lcorner = Point(tile.x, tile.y)
    ocorner = Point(lcorner.x + tile.w, lcorner.y + tile.h)
    return BoundingBox(lcorner, ocorner)
end
