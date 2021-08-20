"""
The BoundingBox type holds two Points, `corner1` and `corner2`.

    BoundingBox(;centered=true)     # the bounding box of the Drawing
    BoundingBox(s::AbstractString)  # the bounding box of a text string
    BoundingBox(pt::Array)          # the bounding box of a polygon

`BoundingBox(;centered=true)` returns a BoundingBox the same size and position as the current drawing, assuming
the origin (0, 0) is at the center.

The `centered` option defaults to `true`, and assumes the drawing is currently
centered. If `false`, the function assumes that the origin is at the top left
of the drawing. So this function doesn't really work if the current matrix has
been modified (by `translate()`, `scale()`, `rotate()` etc.)
"""
mutable struct BoundingBox
   corner1::Point
   corner2::Point
end

function Base.show(io::IO, bbox::BoundingBox)
  print(io, " ⤡ ", bbox.corner1, " : ", bbox.corner2)
end

function BoundingBox(;centered=true)
    if currentdrawing() == false
        # return a default bounding box of 600×600
        r = BoundingBox(Point(-300, -300), Point(300, 300))
    elseif centered
        # ignore current matrix
        r = BoundingBox(
            Point(-current_width()/2, -current_height()/2),
            Point(current_width()/2, current_height()/2))
    else
        b = getmatrix()
        setmatrix([1.0, 0.0, 0.0, 1.0, 0.0, 0.0])
        r = BoundingBox(Point(0, 0), Point(current_width(), current_height()))
        setmatrix(b)
    end
    return r
end

"""
    BoundingBox(pointlist::Array)

Return the BoundingBox of a polygon (array of points).
"""
function BoundingBox(pointlist::Array{Point, 1})
    lowx, lowy = pointlist[1].x, pointlist[1].y
    highx, highy = pointlist[end].x, pointlist[end].y
    for p in pointlist
        p.x < lowx  && (lowx  = p.x)
        p.y < lowy  && (lowy  = p.y)
        p.x > highx && (highx = p.x)
        p.y > highy && (highy = p.y)
    end
    return BoundingBox(Point(lowx, lowy), Point(highx, highy))
end

"""
    BoundingBox(str::AbstractString)

Return a BoundingBox that just encloses a text string, given the current font
selection. Uses the Toy text API (ie `text()`).
"""
function BoundingBox(str::AbstractString)
    xbearing, ybearing, width, height, xadvance, yadvance = textextents(str)
    lcorner = Point(xbearing, ybearing)
    ocorner = Point(lcorner.x + width, lcorner.y + height)
    return BoundingBox(lcorner, ocorner)
end

#state is either 1 or 2!
function Base.iterate(bbox::BoundingBox)
    return (bbox.corner1, 2)
end

function Base.iterate(bbox::BoundingBox, state)
    if state > 2
        return
    end
    state == 1 ? (bbox.corner1, state + 1) : state == 2 ? (bbox.corner2, state + 1) : error("this should never happen")
end

Base.last(bbox::BoundingBox) = bbox.corner2

Base.size(bbox::BoundingBox) = (2)

function Base.length(bbox::BoundingBox)
    return 2
end

unsafe_length(bbox::BoundingBox) = length(bbox)

Base.eltype(::Type{BoundingBox}) = Point

Base.lastindex(bbox::BoundingBox) = 2

function Base.getindex(bbox::BoundingBox, i::Int)
    if i == 1
        return bbox.corner1
    else
        return bbox.corner2
    end
end

Base.getindex(bbox::BoundingBox, i::Number) = bbox[convert(Int, i)]
Base.getindex(bbox::BoundingBox, I) = [bbox[i] for i in I]

function Base.setindex(bbox::BoundingBox, v::Point, i::Number)
    if i == 1
        return BoundingBox(v, bbox.corner2)
    else
        return BoundingBox(bbox.corner1, v)
    end
end

# basics
# adding a number to a box makes the box larger all round
+(z::Number, bb1::BoundingBox)              = BoundingBox(bb1.corner1 - z,          bb1.corner2 + z)
+(bb1::BoundingBox, z::Number)              = BoundingBox(bb1.corner1 - z,          bb1.corner2 + z)

# subtracting a number makes the box smaller all round
-(z::Number, bb1::BoundingBox)              = BoundingBox(bb1.corner1 + z,          bb1.corner2 - z)
-(bb1::BoundingBox, z::Number)              = BoundingBox(bb1.corner1 + z,          bb1.corner2 - z)

function (*)(bb::BoundingBox, s::Real)
    c = midpoint(bb...)
    newcorner1 = between(c, bb.corner1, s)
    newcorner2 = between(c, bb.corner2, s)
    return BoundingBox(newcorner1, newcorner2)
end

(*)(s::Real, bb::BoundingBox) = bb * s

function (/)(bb::BoundingBox, s::Real)
    c = midpoint(bb...)
    newcorner1 = between(c, bb.corner1, 1/s)
    newcorner2 = between(c, bb.corner2, 1/s)
    return BoundingBox(newcorner1, newcorner2)
end

(/)(s::Real, bb::BoundingBox) = bb / s

# modifying with tuples shifts the box in x and y
+(bb1::BoundingBox, shift::NTuple{2, Real}) = BoundingBox(
    Point(bb1.corner1.x + shift[1], bb1.corner1.y + shift[2]),
    Point(bb1.corner2.x + shift[1], bb1.corner2.y + shift[2]))

-(bb1::BoundingBox, shift::NTuple{2, Real}) = BoundingBox(
    Point(bb1.corner1.x - shift[1], bb1.corner1.y - shift[2]),
    Point(bb1.corner2.x - shift[1], bb1.corner2.y - shift[2]))

# also add/subtract a point to a bounding box shifts the box
    +(bb1::BoundingBox, pt::Point) = +(bb1::BoundingBox, (pt.x, pt.y))
    +(pt::Point, bb1::BoundingBox) = +(bb1, pt)
    -(bb1::BoundingBox, pt::Point) = -(bb1::BoundingBox, (pt.x, pt.y))
    -(pt::Point, bb1::BoundingBox) = -(bb1, pt)

# if you add two bounding boxes, you get the biggest enclosing box
function +(bb1::BoundingBox, bb2::BoundingBox)
    pts = [bb1.corner1, bb1.corner2, bb2.corner1, bb2.corner2]
    lox, hix = sort!(pts, by = a -> a.x, lt  = (a, b) -> a < b)[[1, end]]
    loy, hiy = sort!(pts, by = a -> a.y, lt  = (a, b) -> a < b)[[1, end]]
    return BoundingBox(Point(lox.x, loy.y), Point(hix.x, hiy.y))
end

"""
    boxwidth(bb::BoundingBox=BoundingBox())

Return the width of bounding box `bb`.
"""
boxwidth(bb::BoundingBox=BoundingBox())       = abs(bb.corner1.x - bb.corner2.x)

"""
    boxheight(bb::BoundingBox=BoundingBox())

Return the height of bounding box `bb`.
"""
boxheight(bb::BoundingBox=BoundingBox())      = abs(bb.corner1.y - bb.corner2.y)

"""
    boxdiagonal(bb::BoundingBox=BoundingBox())

Return the length of the diagonal of bounding box `bb`.
"""
boxdiagonal(bb::BoundingBox=BoundingBox())    = hypot(boxwidth(bb), boxheight(bb))

"""
    boxaspectratio(bb::BoundingBox=BoundingBox())

Return the aspect ratio (the height divided by the width) of bounding box `bb`.
"""
boxaspectratio(bb::BoundingBox=BoundingBox()) = boxheight(bb)/boxwidth(bb)

"""
    convert(Point, bbox::BoundingBox)

Convert a BoundingBox to a four-point clockwise polygon.

    convert(Vector{Point}, BoundingBox())
"""
function Base.convert(::Type{Vector{Point}}, bbox::BoundingBox)
    return [bbox.corner1,
            Point(bbox.corner2.x, bbox.corner1.y),
            bbox.corner2,
            Point(bbox.corner1.x, bbox.corner2.y)]
end

"""
    box(bbox::BoundingBox, :action;
            vertices=false)

Make a box using the bounds in `bbox`.

Use `vertices=true` to return an array of the four corner points: bottom left,
top left, top right, bottom right.
"""
function box(bbox::BoundingBox, action::Symbol=:none;
        vertices=false)
    if vertices || action == :none
        botleft  = Point(bbox.corner1.x, bbox.corner2.y)
        topleft  = bbox.corner1
        topright = Point(bbox.corner2.x, bbox.corner1.y)
        botright = bbox.corner2
        return [botleft, topleft, topright, botright]
    else
        box(bbox.corner1, bbox.corner2, action)
    end
end

"""
    poly(bbox::BoundingBox, :action; kwargs...)

Make a polygon around the BoundingBox in `bbox`.
"""
poly(bbox::BoundingBox, action::Symbol=:none; kwargs...) =
    poly(convert(Vector{Point}, bbox), action; kwargs...)

"""
    prettypoly(bbox::BoundingBox, :action; kwargs...)

Make a decorated polygon around the BoundingBox in `bbox`. The vertices are in
the order: bottom left, top left, top right, and bottom right.
"""
prettypoly(bbox::BoundingBox, action::Symbol=:none; kwargs...) =
    prettypoly(box(bbox, vertices=true), action; kwargs...)

"""
    boundingboxesintersect(bbox1::BoundingBox, bbox2::BoundingBox)
    boundingboxesintersect(acorner1::Point, acorner2::Point, bcorner1::Point, bcorner2::Point)

Return true if the two bounding boxes intersect.
"""
function boundingboxesintersect(acorner1::Point, acorner2::Point, bcorner1::Point, bcorner2::Point)
    minax, maxax = minmax(acorner1.x, acorner2.x)
    minay, maxay = minmax(acorner1.y, acorner2.y)

    minbx, maxbx = minmax(bcorner1.x, bcorner2.x)
    minby, maxby = minmax(bcorner1.y, bcorner2.y)

    maxax < minbx && return false
    maxbx < minax && return false

    maxay < minby && return false
    maxby < minay && return false
    return true # boxes overlap
end

boundingboxesintersect(bbox1::BoundingBox, bbox2::BoundingBox) =
    boundingboxesintersect(bbox1.corner1, bbox1.corner2, bbox2.corner1, bbox2.corner2)

"""
    intersectboundingboxes(bb1::BoundingBox, bb2::BoundingBox)

Return a BoundingBox that's an intersection of the two bounding boxes.
"""
function intersectboundingboxes(bb1::BoundingBox, bb2::BoundingBox)
    !boundingboxesintersect(bb1, bb2) && return BoundingBox(O, O)
    minax, maxax = minmax(bb1.corner1.x, bb1.corner2.x)
    minay, maxay = minmax(bb1.corner1.y, bb1.corner2.y)

    minbx, maxbx = minmax(bb2.corner1.x, bb2.corner2.x)
    minby, maxby = minmax(bb2.corner1.y, bb2.corner2.y)
    return BoundingBox(Point(max(minax, minbx),
                             max(minay, minby)),
                       Point(min(maxax, maxbx),
                             min(maxay, maxby)))
end

"""
    isinside(p::Point, bb:BoundingBox)

Returns `true` if `pt` is inside bounding box `bb`.
"""
isinside(p::Point, bb::BoundingBox) = (bb.corner1.x <= p.x <= bb.corner2.x) &&
    (bb.corner1.y <= p.y <= bb.corner2.y)

"""
    midpoint(bb::BoundingBox=BoundingBox())

Returns the point midway between the two points of the BoundingBox. This should
also be the center, unless I've been very stupid...
"""
midpoint(bb::BoundingBox=BoundingBox()) = midpoint(bb...)

"""
    between(bb::BoundingBox, x)

Find a point between the two corners of a BoundingBox corresponding to `x`,
where `x` is typically between 0 and 1.
"""
between(bb::BoundingBox, k=0.5) = between(bb[1], bb[2], k)

"""
    boxtopleft(bb::BoundingBox=BoundingBox())

Return the point at the top left of the BoundingBox `bb`, defaulting to the drawing extent.

```
■ ⋅ ⋅
⋅ ⋅ ⋅
⋅ ⋅ ⋅
```

"""
boxtopleft(bb::BoundingBox=BoundingBox())        = bb[1]

"""
    boxtopcenter(bb::BoundingBox=BoundingBox())

Return the point at the top center of the BoundingBox `bb`, defaulting to the drawing extent.
```
⋅ ■ ⋅
⋅ ⋅ ⋅
⋅ ⋅ ⋅
```

"""
boxtopcenter(bb::BoundingBox=BoundingBox()) = midpoint(bb.corner1, bb.corner2) - (0, boxheight(bb)/2)

"""
    boxtopright(bb::BoundingBox=BoundingBox())

Return the point at the top right of the BoundingBox `bb`, defaulting to the drawing extent.
```
⋅ ⋅ ■
⋅ ⋅ ⋅
⋅ ⋅ ⋅
```

"""
boxtopright(bb::BoundingBox=BoundingBox())       = Point(bb[2].x, bb[1].y)

"""
    boxmiddleleft(bb::BoundingBox=BoundingBox())

Return the point at the middle left of the BoundingBox `bb`, defaulting to the drawing extent.
```
⋅ ⋅ ⋅
■ ⋅ ⋅
⋅ ⋅ ⋅
```

"""
boxmiddleleft(bb::BoundingBox=BoundingBox())     = Point(bb[1].x, midpoint(bb[1], bb[2]).y)

"""
    boxmiddlecenter(bb::BoundingBox=BoundingBox())

Return the point at the center of the BoundingBox `bb`, defaulting to the drawing extent.
```
⋅ ⋅ ⋅
⋅ ■ ⋅
⋅ ⋅ ⋅
```
"""
boxmiddlecenter(bb::BoundingBox=BoundingBox())   = midpoint(bb[1], bb[2])

"""
    boxmiddleright(bb::BoundingBox=BoundingBox())

Return the point at the midde right of the BoundingBox `bb`, defaulting to the drawing extent.
```
⋅ ⋅ ⋅
⋅ ⋅ ■
⋅ ⋅ ⋅
```
"""
boxmiddleright(bb::BoundingBox=BoundingBox())    = Point(bb[2].x, midpoint(bb[1], bb[2]).y)

"""
    boxbottomleft(bb::BoundingBox=BoundingBox())

Return the point at the bottom left of the BoundingBox `bb`, defaulting to the drawing extent.
```
⋅ ⋅ ⋅
⋅ ⋅ ⋅
■ ⋅ ⋅
```
"""
boxbottomleft(bb::BoundingBox=BoundingBox())     = Point(bb[1].x, bb[2].y)

"""
    boxbottomcenter(bb::BoundingBox=BoundingBox())

Return the point at the bottom center of the BoundingBox `bb`, defaulting to the drawing extent.
```
⋅ ⋅ ⋅
⋅ ⋅ ⋅
⋅ ■ ⋅
```
"""
boxbottomcenter(bb::BoundingBox=BoundingBox())   = midpoint(bb.corner1, bb.corner2) + (0, boxheight(bb)/2)

"""
    boxbottomright(bb::BoundingBox=BoundingBox())

Return the point at the bottom right of the BoundingBox `bb`, defaulting to the drawing extent.
```
⋅ ⋅ ⋅
⋅ ⋅ ⋅
⋅ ⋅ ■
```
"""
boxbottomright(bb::BoundingBox=BoundingBox())    = bb[2]

# legacy defs will be deprecated
boxtop(bb::BoundingBox) = boxtopcenter(bb)
boxbottom(bb::BoundingBox) = boxbottomcenter(bb)

"""
    pointcrossesboundingbox(pt, bbox::BoundingBox)

Find and return the point where a line from the center of bounding box
`bbox` to point `pt` would, if continued, cross the edges of the box.
"""
function pointcrossesboundingbox(pt, bbox::BoundingBox)
    minpt, maxpt = extrema(bbox)
    mp = midpoint(minpt, maxpt)
    midX, midY = mp.x, mp.y

    m = (midY - pt.y) / (midX - pt.x)
    if pt.x <= midX # left
        min_Xy = m * (minpt.x - pt.x) + pt.y
        if minpt.y <= min_Xy && min_Xy <= maxpt.y
            return Point(minpt.x, min_Xy)
        end
    end
    if pt.x >= midX # right
        max_Xy = m * (maxpt.x - pt.x) + pt.y
        if minpt.y <= max_Xy && max_Xy <= maxpt.y
            return Point(maxpt.x, max_Xy)
        end
    end
    if pt.y <= midY # top
        min_Yx = (minpt.y - pt.y) / m + pt.x
        if minpt.x <= min_Yx && min_Yx <= maxpt.x
            return Point(min_Yx, minpt.y)
        end
    end
    if pt.y >= midY # bottom
        max_Yx = (maxpt.y - pt.y) / m + pt.x
        if minpt.x <= max_Yx && max_Yx <= maxpt.x
            return Point(max_Yx, maxpt.y)
        end
    end
    if pt.x == midX && pt.y == midY
        return Point(pt.x, pt.y)
    end
    error("oh dear, something has gone wrong but I don't know what")
end

"""
    rand(bbox::BoundingBox)
Return a random `Point` that lies inside `bbox`.
"""
Base.rand(bb::BoundingBox) = Point(
    (bb.corner2.x - bb.corner1.x) * rand() + bb.corner1.x,
    (bb.corner2.y - bb.corner1.y) * rand() + bb.corner1.y)

"""
    in(pt, bbox::BoundingBox)
Test whether `pt` is inside `bbox`.
"""
Base.in(pt::Point, bbox::BoundingBox) = isinside(pt, bbox::BoundingBox)
