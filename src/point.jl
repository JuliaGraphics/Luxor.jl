import Base: +, -, *, /, ^, !=, <, >, ==, norm
import Base: isequal, isless, isapprox, cmp, dot, size, getindex

"""
The Point type holds two coordinates. Currently it's immutable, so remember not try to
change the values of the x and y values directly.
"""

immutable Point
   x::Float64
   y::Float64
end

"""
O is a shortcut for the current origin, `0/0`
"""
const O = Point(0, 0)

# basics
+(z::Number, p1::Point)              = Point(p1.x + z,    p1.y + z)
+(p1::Point, z::Number)              = Point(p1.x + z,    p1.y + z)
+(p1::Point, p2::Point)              = Point(p1.x + p2.x, p1.y + p2.y)
-(p1::Point, p2::Point)              = Point(p1.x - p2.x, p1.y - p2.y)
-(p::Point)                          = Point(-p.x,        -p.y)
-(z::Number, p1::Point)              = Point(p1.x - z,    p1.y - z)
-(p1::Point, z::Number)              = Point(p1.x - z,    p1.y - z)
*(k::Number, p2::Point)              = Point(k * p2.x,    k * p2.y)
*(p2::Point, k::Number)              = Point(k * p2.x,    k * p2.y)
/(p2::Point, k::Number)              = Point(p2.x/k,      p2.y/k)
*(p1::Point, p2::Point)              = Point(p1.x * p2.x, p1.y * p2.y)
^(p::Point, e::Integer)              = Point(p.x^e,       p.y^e)
^(p::Point, e::Float64)              = Point(p.x^e,       p.y^e)

# some refinements
# modifying points with tuples
+(p1::Point, shift::NTuple{2, Real}) = Point(p1.x + shift[1], p1.y + shift[2])
-(p1::Point, shift::NTuple{2, Real}) = Point(p1.x - shift[1], p1.y - shift[2])
*(p1::Point, shift::NTuple{2, Real}) = Point(p1.x * shift[1], p1.y * shift[2])
/(p1::Point, shift::NTuple{2, Real}) = Point(p1.x / shift[1], p1.y / shift[2])

# for broadcasting
Base.size(::Point) = 2
Base.getindex(p::Point, i) = [p.x, p.y][i]

function dot(a::Point, b::Point)
    return dot([a.x, a.y], [b.x, b.y])
end

# comparisons

isequal(p1::Point, p2::Point)         = isapprox(p1.x, p2.x, atol=0.00000001) && (isapprox(p1.y, p2.y, atol=0.00000001))
isapprox(p1::Point, p2::Point)        = isapprox(p1.x, p2.x, atol=0.00000001) && (isapprox(p1.y, p2.y, atol=0.00000001))
isless(p1::Point, p2::Point)          = (p1.x < p2.x || (isapprox(p1.x, p2.x) && p1.y < p2.y))
!=(p1::Point, p2::Point)              = !isequal(p1, p2)
<(p1::Point, p2::Point)               = isless(p1,p2)
>(p1::Point, p2::Point)               = p2 < p1
==(p1::Point, p2::Point)              = isequal(p1, p2)

# These have been replaced in v0.6 with broadcasting syntax
# fix from https://github.com/JuliaLang/Compat.jl/issues/308
if VERSION < v"0.6.0-dev.1632" # julia#17623
    include_string("""
    import Base: .*, ./, .<, .>, .>=, .<=
    .*(k::Number, p2::Point)              = Point(k * p2.x,    k * p2.y)
    .*(p2::Point, k::Number)              = Point(k * p2.x,    k * p2.y)
    ./(p2::Point, k::Number)              = Point(p2.x/k,      p2.y/k)
    .<(p1::Point, p2::Point)              = p1 < p2
    .>(p1::Point, p2::Point)              = p2 < p1
    .<=(p1::Point, p2::Point)             = p1 <= p2
    .>=(p1::Point, p2::Point)             = p2 <= p1
    """, string(@__FILE__, ':', @__LINE__))
end

cmp(p1::Point, p2::Point)             = (p1 < p2) ? -1 : (p2 < p1) ? 1 : 0

"""
    norm(p1::Point, p2::Point)

Find the norm of two points (two argument form).
"""
function norm(p1::Point, p2::Point)
    norm([p1.x, p1.y] - [p2.x, p2.y])
end

"""
    pointlinedistance(p::Point, a::Point, b::Point)

Find the distance between a point `p` and a line between two points `a` and `b`.
"""
function pointlinedistance(p::Point, a::Point, b::Point)
    # area of triangle
    area = abs(0.5 * (a.x * b.y + b.x * p.y + p.x * a.y - b.x * a.y - p.x * b.y - a.x * p.y))
    # length of the bottom edge
    dx = a.x - b.x
    dy = a.y - b.y
    bottom = hypot(dx, dy)
    return area / bottom
end

"""
    getnearestpointonline(pt1::Point, pt2::Point, startpt::Point)

Given a line from `pt1` to `pt2`, and `startpt` is the start of a perpendicular heading
to meet the line, at what point does it hit the line?
"""
function getnearestpointonline(pt1::Point, pt2::Point, startpt::Point)
    # first convert line to normalized unit vector
    dx = pt2.x - pt1.x
    dy = pt2.y - pt1.y
    mag = hypot(dx, dy)
    dx /= mag
    dy /= mag

    # translate the point and get the dot product
    lambda = (dx * (startpt.x - pt1.x)) + (dy * (startpt.y - pt1.y))
    return Point((dx * lambda) + pt1.x, (dy * lambda) + pt1.y)
end

"""
    midpoint(p1, p2)

Find the midpoint between two points.
"""
midpoint(p1::Point, p2::Point) = Point((p1.x + p2.x) / 2.0, (p1.y + p2.y) / 2.0)

"""
    midpoint(a)

Find midpoint between the first two elements of an array of points.
"""
midpoint(pt::AbstractArray) = midpoint(pt[1], pt[2])

"""
    between(p1::Point, p2::Point, x)
    between((p1::Point, p2::Point), x)

Find the point between point `p1` and point `p2` for `x`, where `x` is typically between 0
and 1, so these two should be equivalent:

    between(p1, p2, 0.5)

and

    midpoint(p1, p2)
"""
function between(p1::Point, p2::Point, x)
    return p1 + (x * (p2 - p1))
end

function between(couple::NTuple{2, Point}, x)
    p1, p2 = couple
    return p1 + (x * (p2 - p1))
end

"""
    perpendicular(p::Point)

Returns point `Point(p.y, -p.x)`.
"""
function perpendicular(p::Point)
    return Point(p.y, -p.x)
end

"""
    crossproduct(p1::Point, p2::Point)

This is the *perp dot product*, really, not the crossproduct proper (which is 3D):

    dot(p1, perpendicular(p2))
"""
function crossproduct(p1::Point, p2::Point)
    return dot(p1, perpendicular(p2))
end

function randomordinate(low, high)
    low + rand() * abs(high - low)
end

"""
    randompoint(lowpt, highpt)

Return a random point somewhere inside the rectangle defined by the two points.
"""
function randompoint(lowpt, highpt)
  Point(randomordinate(lowpt.x, highpt.x), randomordinate(lowpt.y, highpt.y))
end

"""
    randompoint(lowx, lowy, highx, highy)

Return a random point somewhere inside a rectangle defined by the four values.
"""
function randompoint(lowx, lowy, highx, highy)
    Point(randomordinate(lowx, highx), randomordinate(lowy, highy))
end

"""
    randompointarray(lowpt, highpt, n)

Return an array of `n` random points somewhere inside the rectangle defined by two points.
"""
function randompointarray(lowpt, highpt, n)
  array = Point[]
  for i in 1:n
    push!(array, randompoint(lowpt, highpt))
  end
  array
end

"""
    randompointarray(lowx, lowy, highx, highy, n)

Return an array of `n` random points somewhere inside the rectangle defined by the four
coordinates.
"""
function randompointarray(lowx, lowy, highx, highy, n)
    array = Point[]
    for i in 1:n
        push!(array, randompoint(lowx, lowy, highx, highy))
    end
    array
end
"""
    ispointonline(pt::Point, pt1::Point, pt2::Point;
        extended = false,
        atol = 10E-5)

Return `true` if the point `pt` lies on a straight line between `pt1` and `pt2`.

If `extended` is false (the default) the point must lie on the line segment between
`pt1` and `pt2`. If `extended` is true, the point lies on the line if extended in
either direction.
"""
function ispointonline(pt::Point, pt1::Point, pt2::Point;
        atol=10E-5,
        extended=false)
    dxc = pt.x - pt1.x
    dyc = pt.y - pt1.y
    dxl = pt2.x - pt1.x
    dyl = pt2.y - pt1.y
    cpr = (dxc * dyl) - (dyc * dxl)

    # point not on line
    if !isapprox(cpr, 0.0, atol=atol)
        return false
    end

    # point somewhere on extended line
    if extended == true
        return true
    end

    # point on the line
    if (abs(dxl) >= abs(dyl))
        return dxl > 0 ?
            pt1.x <= pt.x && pt.x <= pt2.x :
            pt2.x <= pt.x && pt.x <= pt1.x
    else
        return dyl > 0 ?
            pt1.y <= pt.y && pt.y <= pt2.y :
            pt2.y <= pt.y && pt.y <= pt1.y
    end
end

"""
    intersection(p1::Point, p2::Point, p3::Point, p4::Point;
        commonendpoints = false,
        crossingonly = false,
        collinearintersect = false)

Find intersection of two lines `p1`-`p2` and `p3`-`p4`

This returns a tuple: `(boolean, point(x, y))`.

Keyword options and default values:

    crossingonly = false

If `crossingonly = true`, lines must actually cross. The function returns
`(false, intersectionpoint)` if the lines don't actually cross, but would eventually
intersect at `intersectionpoint` if continued beyond their current endpoints.

If `false`, the function returns `(true, Point(x, y))` if the lines intersect somewhere
eventually at `intersectionpoint`.

    commonendpoints = false

If `commonendpoints= true`, will return `(false, Point(0, 0))` if the lines share a common
end point (because that's not so much an intersection, more a meeting).

Function returns `(false, Point(0, 0))` if the lines are undefined.

If you want collinear points to be considered to intersect, set `collinearintersect` to
`true`, although it defaults to `false`.
"""
function intersection(A::Point, B::Point, C::Point, D::Point;
        commonendpoints = false,
        crossingonly = false,
        collinearintersect = false
        )
    # false if either line is undefined
    if (A == B) || (C == D)
        return (false, Point(0, 0))
    end

    # false if the lines share a common end point
    if commonendpoints
        if (A == C) || (B == C) || (A == D) || (B == D)
            return (false, Point(0, 0))
        end
    end

    # Cramer's ?
    A1 = (A.y - B.y)
    B1 = (B.x - A.x)
    C1 = (A.x * B.y - B.x * A.y)

    L1 = (A1, B1, -C1)

    A2 = (C.y - D.y)
    B2 = (D.x - C.x)
    C2 = (C.x * D.y - D.x * C.y)

    L2 = (A2, B2, -C2)

    d  = L1[1] * L2[2] - L1[2] * L2[1]
    dx = L1[3] * L2[2] - L1[2] * L2[3]
    dy = L1[1] * L2[3] - L1[3] * L2[1]

    # if you ask me collinear points don't really intersect
    if (C1 == C2) && (collinearintersect == false)
        return (false, Point(0, 0))
    end

    if d != 0
        pt = Point(dx/d, dy/d)
        if crossingonly == true
            if ispointonline(pt, A, B) && ispointonline(pt, C, D)
               return (true, pt)
            else
               return (false, pt)
            end
        else
            if ispointonline(pt, A, B, extended=true) && ispointonline(pt, C, D, extended=true)
                return (true, pt)
            else
               return (false, pt)
            end
        end
    else
        return (false, Point(0, 0))
    end
end

"""
    slope(pointA::Point, pointB::Point)

Find angle of a line starting at `pointA` and ending at `pointB`.

Return a value between 0 and 2pi. Value will be relative to the current axes.

    slope(O, Point(0, 100)) |> rad2deg # y is positive down the page
    90.0

    slope(Point(0, 100), O) |> rad2deg
    270.0

"""
function slope(pointA, pointB)
    return mod2pi(atan2(pointB.y - pointA.y, pointB.x - pointA.x))
end

function intersection_line_circle(p1::Point, p2::Point, cpoint::Point, r)
    a = (p2.x - p1.x)^2 + (p2.y - p1.y)^2
    b = 2.0 * ((p2.x - p1.x) * (p1.x - cpoint.x) +
               (p2.y - p1.y) * (p1.y - cpoint.y))
    c = ((cpoint.x)^2 + (cpoint.y)^2 + (p1.x)^2 + (p1.y)^2 - 2.0 *
        (cpoint.x * p1.x + cpoint.y * p1.y) - r^2)
    i = b^2 - 4.0 * a * c
    if i < 0.0
        number_of_intersections = 0
        intpoint1 = O
        intpoint2 = O
    elseif isapprox(i, 0.0)
        number_of_intersections = 1
        mu = -b / (2.0 * a)
        intpoint1 = Point(p1.x + mu * (p2.x - p1.x), p1.y + mu * (p2.y - p1.y))
        intpoint2 = O
    elseif i > 0.0
        number_of_intersections = 2
        # first intersection
        mu = (-b + sqrt(i)) / (2.0 * a)
        intpoint1 = Point(p1.x + mu * (p2.x - p1.x),
                     p1.y + mu * (p2.y - p1.y))
        # second intersection
        mu = (-b - sqrt(i)) / (2.0 * a)
        intpoint2 = Point(p1.x + mu * (p2.x - p1.x), p1.y + mu * (p2.y - p1.y))
    end
    return number_of_intersections, intpoint1, intpoint2
end

"""
    intersectionlinecircle(p1::Point, p2::Point, cpoint::Point, r)

Find the intersection points of a line (extended through points `p1` and `p2`) and a circle.

Return a tuple of `(n, pt1, pt2)`

where

- `n` is the number of intersections, `0`, `1`, or `2`
- `pt1` is first intersection point, or `Point(0, 0)` if none
- `pt2` is the second intersection point, or `Point(0, 0)` if none

The calculated intersection points won't necessarily lie on the line segment between `p1` and `p2`.
"""
intersectionlinecircle(p1::Point, p2::Point, cpoint::Point, r) =
    intersection_line_circle(p1, p2, cpoint, r)

"""
    @polar (p)

Convert a tuple of two numbers to a Point of x, y Cartesian coordinates.

    @polar (10, pi/4)
    @polar [10, pi/4]

produces

    Luxor.Point(7.0710678118654755,7.071067811865475)
"""
macro polar(p)
    quote
      Point($(esc(p))[1] * cos($(esc(p))[2]), $(esc(p))[1] * sin($(esc(p))[2]))
    end
end

"""
    polar(r, theta)

Convert point in polar form (radius and angle) to a Point.

    polar(10, pi/4)

produces

    Luxor.Point(7.071067811865475,7.0710678118654755)
"""
polar(r, theta) = Point(r * cos(theta), r * sin(theta))

"""
    bboxesintersect(acorner1::Point, acorner2::Point, bcorner1::Point, bcorner2::Point)

Return true if the two bounding boxes defined by acorner1:acorner2 and bcorner1:bcorner2 intersect.

Each pair of points is assumed to define the two opposite corners of a bounding box.

"""
function bboxesintersect(acorner1::Point, acorner2::Point, bcorner1::Point, bcorner2::Point)
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
