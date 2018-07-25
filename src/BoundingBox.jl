"""
The BoundingBox type holds two Points, `corner1` and `corner2`.

    BoundingBox(;centered=true) # the bounding box of the Drawing
    BoundingBox(s::String)      # the bounding box of a text string
    BoundingBox(pt::Array)      # the bounding box of a polygon
"""
mutable struct BoundingBox
   corner1::Point
   corner2::Point
end

function Base.show(io::IO, bbox::BoundingBox)
  print(io, " ⤡ ", bbox.corner1, " : ", bbox.corner2)
end

"""
BoundingBox()

Return a BoundingBox the same size and position as the current drawing, assuming
the origin (0//0) is at the center.

The `centered` option defaults to `true`, and assumes the drawing is currently
centered. If `false`, the function assumes that the origin is at the top left
of the drawing. So this function doesn't really work if the current matrix has
been modified (by `translate()`, `scale()`, `rotate()` etc.)
"""
function BoundingBox(;centered=true)
    if centered
        # ignore current matrix
        r = BoundingBox(
        Point(-currentdrawing.width/2, -currentdrawing.height/2),
        Point(currentdrawing.width/2, currentdrawing.height/2))
    else
        b = getmatrix()
        setmatrix([1.0, 0.0, 0.0, 1.0, 0.0, 0.0])
        r = BoundingBox(Point(0, 0), Point(currentdrawing.width, currentdrawing.height))
        setmatrix(b)
    end
    return r
end

"""
BoundingBox(pointlist::AbstractArray)

Return the BoundingBox of a polygon (array of points).
"""
function BoundingBox(pointlist::AbstractArray{Point, 1})
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
BoundingBox(str::String)

Return a BoundingBox that just encloses a text string, given the current font
selection.
"""
function BoundingBox(str::String)
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

Base.endof(bbox::BoundingBox) = 2

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

# if you add two bounding boxes, you get the biggest enclosing box
function +(bb1::BoundingBox, bb2::BoundingBox)
    pts = [bb1.corner1, bb1.corner2, bb2.corner1, bb2.corner2]
    lox, hix = sort!(pts, by = a -> a.x, lt  = (a, b) -> a < b)[[1, end]]
    loy, hiy = sort!(pts, by = a -> a.y, lt  = (a, b) -> a < b)[[1, end]]
    return BoundingBox(Point(lox.x, loy.y), Point(hix.x, hiy.y))
end

"""
    boxwidth(bb::BoundingBox)

Return the width of bounding box `bb`.
"""
boxwidth(bb::BoundingBox)       = abs(bb.corner1.x - bb.corner2.x)

"""
    boxheight(bb::BoundingBox)

Return the height of bounding box `bb`.
"""
boxheight(bb::BoundingBox)      = abs(bb.corner1.y - bb.corner2.y)

"""
    boxdiagonal(bb::BoundingBox)

Return the length of the diagonal of bounding box `bb`.
"""
boxdiagonal(bb::BoundingBox)    = hypot(boxwidth(bb), boxheight(bb))

"""
    boxaspectratio(bb::BoundingBox)

Return the aspect ratio (the height divided by the width) of bounding box `bb`.
"""
boxaspectratio(bb::BoundingBox) = boxheight(bb)/boxwidth(bb)

"""
    boxtop(bb::BoundingBox)

Return the top center point of bounding box `bb`.
"""
boxtop(bb::BoundingBox) = midpoint(bb.corner1, bb.corner2) - (0, boxheight(bb)/2)

"""
    boxbottom(bb::BoundingBox)

Return the top center point of bounding box `bb`.
"""
boxbottom(bb::BoundingBox) = midpoint(bb.corner1, bb.corner2) + (0, boxheight(bb)/2)

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
    box(bbox::BoundingBox, :action)

Make a box using the bounds in `bbox`.
"""
box(bbox::BoundingBox, action::Symbol=:nothing; kwargs...) =
    box(bbox.corner1, bbox.corner2, action; kwargs...)

"""
    poly(bbox::BoundingBox, :action; kwargs...)

Make a polygon around the BoundingBox in `bbox`.
"""
poly(bbox::BoundingBox, action::Symbol=:nothing; kwargs...) =
    poly(convert(Vector{Point}, bbox), action; kwargs...)

"""
    prettypoly(bbox::BoundingBox, :action; kwargs...)

Make a decorated polygon around the BoundingBox in `bbox`.
"""
prettypoly(bbox::BoundingBox, action::Symbol=:nothing; kwargs...) =
    prettypoly(convert(Vector{Point}, bbox), action; kwargs...)

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

"""
    boundingboxesintersect(bbox1::BoundingBox, bbox2::BoundingBox)

Return true if the two bounding boxes intersect.
"""
boundingboxesintersect(bbox1::BoundingBox, bbox2::BoundingBox) =
    boundingboxesintersect(bbox1.corner1, bbox1.corner2, bbox2.corner1, bbox2.corner2)

"""
    intersectionboundingboxes(bb1::BoundingBox, bb2::BoundingBox)

Returns a bounding box intersection.
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
isinside(p::Point, bb::BoundingBox) = (bb.corner1.x <= p.x <= bb.corner2.x) && (bb.corner1.y <= p.y <= bb.corner2.y)
