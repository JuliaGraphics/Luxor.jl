import Base: +, -, *, /, ^, !=, <, >, ==
import Base: isequal, isless, isapprox, cmp, size, getindex, broadcastable

abstract type AbstractPoint end

"""
The Point type holds two coordinates. It's immutable, you can't
change the values of the x and y values directly.
"""
struct Point <: AbstractPoint
    x::Float64
    y::Float64
end

"""
`O` is a shortcut for the current origin, `0/0`
"""
const O = Point(0, 0)
Base.zero(::Type{Point}) = O
Base.zero(::Point) = O

# basics
+(p1::Point, p2::Point) = Point(p1.x + p2.x, p1.y + p2.y)
-(p1::Point, p2::Point) = Point(p1.x - p2.x, p1.y - p2.y)
-(p::Point) = Point(-p.x, -p.y)
*(k::Number, p2::Point) = Point(k * p2.x, k * p2.y)
*(p2::Point, k::Number) = Point(k * p2.x, k * p2.y)
/(p2::Point, k::Number) = Point(p2.x / k, p2.y / k)

# some refinements
# modifying points with tuples
+(p1::Point, shift::NTuple{2,Real}) = Point(p1.x + shift[1], p1.y + shift[2])
-(p1::Point, shift::NTuple{2,Real}) = Point(p1.x - shift[1], p1.y - shift[2])
*(p1::Point, shift::NTuple{2,Real}) = Point(p1.x * shift[1], p1.y * shift[2])
/(p1::Point, shift::NTuple{2,Real}) = Point(p1.x / shift[1], p1.y / shift[2])

# convenience
Point((x, y)::Tuple{Real,Real}) = Point(x, y)

# for broadcasting
# Base.size(::Point) = (2,)
Base.getindex(p::Point, i) = (p.x, p.y)[i]
Broadcast.broadcastable(x::Point) = Ref(x)

# for iteration
Base.eltype(::Type{Point}) = Float64
Base.iterate(p::Point, state = 1) = state > length(p) ? nothing : (p[state], state + 1)
Base.length(::Point) = 2

# matrix

"""
*(m::Matrix, pt::Point)

Transform a point `pt` by the 3×3 matrix `m`.

```julia-repl
julia> M = [2 0 0; 0 2 0; 0 0 1]
3×3 Matrix{Int64}:
 2  0  0
 0  2  0
 0  0  1

julia> M * Point(20, 20)
Point(40.0, 40.0)
```

To convert between Cairo matrices (6-element Vector{Float64}) to a 3×3 Matrix,
use `cairotojuliamatrix()` and `juliatocairomatrix()`.
"""
function Base.:*(m::AbstractMatrix, pt::Point)
    if size(m) != (3, 3)
        throw(error("matrix should be (3, 3), not $(size(m))"))
    end
    x, y, _ = m * [pt.x, pt.y, 1]
    return Point(x, y)
end

"""
    dotproduct(a::Point, b::Point)

Return the scalar dot product of the two points.
"""
function dotproduct(a::Point, b::Point)
    result = 0.0
    result += a.x * b.x
    result += a.y * b.y
    return result
end

"""
    determinant3(p1::Point, p2::Point, p3::Point)

Find the determinant of the 3×3 matrix:

```math
\\begin{bmatrix}
p1.x & p1.y & 1 \\\\
p2.x & p2.y & 1 \\\\
p3.x & p3.y & 1  \\\\
\\end{bmatrix}
```

If the value is 0.0, the points are collinear.
"""
function determinant3(p1::Point, p2::Point, p3::Point)
    (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y)
end

# comparisons

"""
isequal(p1::Point, p2::Point) =
    isapprox(p1.x, p2.x, atol = 0.00000001) &&
   (isapprox(p1.y, p2.y, atol = 0.00000001))

Compare points.
"""
isequal(p1::Point, p2::Point) =
    isapprox(p1.x, p2.x, atol = 0.00000001) && (isapprox(p1.y, p2.y, atol = 0.00000001))

# allow kwargs
"""
isapprox(p1::Point, p2::Point; atol = 1e-6, kwargs...)

Compare points.
"""
function Base.isapprox(p1::Point, p2::Point;
    atol = 1e-6, kwargs...)
    return isapprox(p1.x, p2.x, atol = atol, kwargs...) &&
           isapprox(p1.y, p2.y, atol = atol, kwargs...)
end

isless(p1::Point, p2::Point) = (p1.x < p2.x || (isapprox(p1.x, p2.x) && p1.y < p2.y))
<(p1::Point, p2::Point) = isless(p1, p2)
==(p1::Point, p2::Point) = isequal(p1, p2)

# a unique that works better on points?
# I think this uses ==
# TODO perhaps unique(x -> round(x, sigdigits=13), myarray) ?
# "any implementation of unique with a tolerance will have some odd behaviors" Steven GJohnson
function Base.unique(pts::Array{Point,1})
    apts = Point[]
    for pt in pts
        if pt ∉ apts
            push!(apts, pt)
        end
    end
    return apts
end

"""
    distance(p1::Point, p2::Point)

Find the distance between two points (two argument form).
"""
function distance(p1::Point, p2::Point)
    dx = p2.x - p1.x
    dy = p2.y - p1.y
    return sqrt(dx * dx + dy * dy)
end

"""
    pointlinedistance(p::Point, a::Point, b::Point)

Find the distance between a point `p` and a line between two points `a` and `b`.
"""
function pointlinedistance(p::Point, a::Point, b::Point)
    dx = b.x - a.x
    dy = b.y - a.y
    return abs(p.x * dy - p.y * dx + b.x * a.y - b.y * a.x) / hypot(dx, dy)
end

"""
    getnearestpointonline(pt1::Point, pt2::Point, startpt::Point)

Given a line passing through `pt1` and `pt2`, return the point where a line
starting at `startpt` would meet the line at right angles. The point may or may
not lie on the line between `pt1` and `pt2` - use `ispointonline()` to see if it does.

See aalso `perpendicular()`.
"""
function getnearestpointonline(pt1::Point, pt2::Point, startpt::Point)
    perpendicular(pt1, pt2, startpt)
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
midpoint(pt::Array) = midpoint(pt[1], pt[2])

"""
    between(p1::Point, p2::Point, x)
    between((p1::Point, p2::Point), x)

Find the point between point `p1` and point `p2` for `x`, where `x` is typically between 0
and 1. `between(p1, p2, 0.5)` is equivalent to `midpoint(p1, p2)`.
"""
function between(p1::Point, p2::Point, x)
    return p1 + (x * (p2 - p1))
end

function between(couple::NTuple{2,Point}, x)
    p1, p2 = couple
    return p1 + (x * (p2 - p1))
end

"""
    perpendicular(p1::Point, p2::Point, p3::Point)

Return a point on a line passing through `p1` and `p2` that
is perpendicular to `p3`.
"""
function perpendicular(p1::Point, p2::Point, p3::Point)
    v2 = p2 - p1
    return p1 + (dotproduct(p3 - p1, v2) / dotproduct(v2, v2)) * v2
end

"""
    perpendicular(p1, p2, k)

Return a point `p3` that is `k` units away from `p1`, such that a line `p1 p3`
is perpendicular to `p1 p2`.

Convention? to the right?
"""
function perpendicular(p1::Point, p2::Point, k)
    px = p2.x - p1.x
    py = p2.y - p1.y
    l = hypot(px, py)
    if l > 0.0
        ux = -py / l
        uy = px / l
        return Point(p1.x + (k * ux), p1.y + (k * uy))
    else
        error("these two points are the same")
    end
end

"""
    perpendicular(p1, p2)

Return two points `p3` and `p4` such that a line from `p3` to `p4` is perpendicular to a line
from `p1` to `p2`, the same length, and the lines intersect at their midpoints.
"""
function perpendicular(p1::Point, p2::Point)
    if isequal(p1, p2)
        throw(error("perpendicular(); no line, the two points are the same"))
    end
    ip = p2 - p1
    ep1 = Point(-ip.y, ip.x) / 2 + (p1 + p2) / 2
    ep2 = Point(ip.y, -ip.x) / 2 + (p1 + p2) / 2
    return (ep1, ep2)
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
"""
function crossproduct(p1::Point, p2::Point)
    return dotproduct(p1, perpendicular(p2))
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
    atol = 10E-5, extended = false)
    dxc = pt.x - pt1.x
    dyc = pt.y - pt1.y
    dxl = pt2.x - pt1.x
    dyl = pt2.y - pt1.y
    cpr = (dxc * dyl) - (dyc * dxl)

    # point not on line
    if !isapprox(cpr, 0.0, atol = atol)
        return false
    end

    # point somewhere on extended line
    if extended == true
        return true
    end

    # point on the line
    if (abs(dxl) >= abs(dyl))
        return dxl > 0 ? pt1.x <= pt.x+atol && pt.x <= pt2.x+atol : pt2.x <= pt.x+atol && pt.x <= pt1.x+atol
    else
        return dyl > 0 ? pt1.y <= pt.y+atol && pt.y <= pt2.y+atol : pt2.y <= pt.y+atol && pt.y <= pt1.y+atol
    end
end

"""
    ispointonpoly(pt::Point, pgon;
        atol=10E-5)

Return `true` if `pt` lies on the polygon `pgon.`
"""
function ispointonpoly(pt::Point, pgon::Array{Point,1};
    atol = 10E-5)
    @inbounds for i in 1:length(pgon)
        p1 = pgon[i]
        p2 = pgon[mod1(i + 1, end)]
        if ispointonline(pt, p1, p2, atol = atol)
            return true
        end
    end
    return false
end

"""
    slope(pointA::Point, pointB::Point)

Find angle of a line starting at `pointA` and ending at `pointB`.

Return a value between 0 and 2pi. Value will be relative to the current axes.

```julia
slope(O, Point(0, 100)) |> rad2deg # y is positive down the page
90.0

slope(Point(0, 100), O) |> rad2deg
270.0
```

The slope isn't the same as the gradient. A vertical line going up has a
slope of 3π/2.
"""
function slope(pointA, pointB)
    return mod2pi(atan(pointB.y - pointA.y, pointB.x - pointA.x))
end

function intersection_line_circle(p1::Point, p2::Point, cpoint::Point, r)
    a = (p2.x - p1.x)^2 + (p2.y - p1.y)^2
    b = 2.0 * ((p2.x - p1.x) * (p1.x - cpoint.x) + (p2.y - p1.y) * (p1.y - cpoint.y))
    c = (
        (cpoint.x)^2 + (cpoint.y)^2 + (p1.x)^2 + (p1.y)^2 -
        2.0 * (cpoint.x * p1.x + cpoint.y * p1.y) - r^2
    )
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
        intpoint1 = Point(p1.x + mu * (p2.x - p1.x), p1.y + mu * (p2.y - p1.y))
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
    @polar 10, pi/4

produces

    Luxor.Point(7.0710678118654755, 7.071067811865475)
"""
macro polar(p)
    quote
        Point($(esc(p))[1] * cos($(esc(p))[2]), $(esc(p))[1] * sin($(esc(p))[2]))
    end
end

"""
    polar(r, theta)

Convert a point specified in polar form (radius and angle) to a Point.

    polar(10, pi/4)

produces

    Luxor.Point(7.071067811865475, 7.0710678118654755)
"""
polar(r, theta) = Point(r * cos(theta), r * sin(theta))

"""
    intersectionlines(p0, p1, p2, p3;
        crossingonly=false)

Find the point where two lines intersect.

Return `(resultflag, resultip)`, where `resultflag` is a Boolean, and `resultip` is a Point.

If `crossingonly == true` the point of intersection must lie on both lines.

If `crossingonly == false` the point of intersection can be where the lines meet
if extended almost to 'infinity'.

Accordng to this function, collinear, overlapping, and parallel lines never
intersect. Ie, the line segments might be collinear but have no points in
common, or the lines segments might be collinear and have many points in
common, or the line segments might be collinear and one is entirely contained
within the other.

If the lines are collinear and share a point in common, that
is the intersection point.
"""
function intersectionlines(p0::Point, p1::Point, p2::Point, p3::Point;
    crossingonly = false)
    resultflag = false
    resultip = Point(0.0, 0.0)
    if p0 == p1 # no lines at all
    elseif p2 == p3
    elseif p0 == p2 && p1 == p3 # lines are the same
    elseif p0 == p3 && p1 == p2
    elseif p0 == p2 # common end points
        resultflag = true
        resultip = p0
    elseif p0 == p3
        resultflag = true
        resultip = p0
    elseif p1 == p2
        resultflag = true
        resultip = p1
    elseif p1 == p3
        resultflag = true
        resultip = p1
    else
        # Cramers rule
        a1 = p0.y - p1.y
        b1 = p1.x - p0.x
        c1 = p0.x * p1.y - p1.x * p0.y

        l1 = (a1, b1, -c1)

        a2 = p2.y - p3.y
        b2 = p3.x - p2.x
        c2 = p2.x * p3.y - p3.x * p2.y

        l2 = (a2, b2, -c2)

        d = l1[1] * l2[2] - l1[2] * l2[1]
        dx = l1[3] * l2[2] - l1[2] * l2[3]
        dy = l1[1] * l2[3] - l1[3] * l2[1]

        if !iszero(d)
            resultip = pt = Point(dx / d, dy / d)
            if crossingonly == true
                if ispointonline(resultip, p0, p1) && ispointonline(resultip, p2, p3)
                    resultflag = true
                else
                    resultflag = false
                end
            else
                if ispointonline(resultip, p0, p1, extended = true) &&
                   ispointonline(resultip, p2, p3, extended = true)
                    resultflag = true
                else
                    resultflag = false
                end
            end
        else
            resultflag = false
            resultip = Point(0, 0)
        end
    end
    return (resultflag, resultip)
end

"""
    pointinverse(A::Point, centerpoint::Point, rad)

Find `A′`, the inverse of a point A with respect to a circle `centerpoint`/`rad`, such that:

```julia
distance(centerpoint, A) * distance(centerpoint, A′) == rad^2
```

Return (true, A′) or (false, A).
"""
function pointinverse(A::Point, centerpoint, rad)
    A == centerpoint &&
        throw(error("pointinverse(): point $A and centerpoint $centerpoint are the same"))
    result = (false, A)
    n, C, pt2 = intersectionlinecircle(centerpoint, A, centerpoint, rad)
    if n > 0
        B = polar(rad, 0.7)                # arbitrary point on circle
        h = getnearestpointonline(B, C, A) # perp
        d = between(A, h, 2)               # reflection
        flag, A′ = intersectionlines(B, d, centerpoint, A, crossingonly = false)
        if flag == true
            result = (true, A′)
        end
    end
    return result
end

"""
    currentpoint()

Return the current point. This is the most recent point in the current path, as
defined by one of the path building functions such as `move()`, `line()`,
`curve()`, `arc()`, `rline()`, and `rmove()`.

To see if there is a current point, use `hascurrentpoint()`.
"""
function currentpoint()
    x, y = Cairo.get_current_point(_get_current_cr())
    return Point(x, y)
end

"""
    hascurrentpoint()

Return true if there is a current point. This is the most recent point in the
current path, as defined by one of the path building functions such as `move()`,
`line()`, `curve()`, `arc()`, `rline()`, and `rmove()`.

To obtain the current point, use `currentpoint()`.

There's no current point after `strokepath()` and `strokepath()` calls.
"""
function hascurrentpoint()
    return Cairo.has_current_point(_get_current_cr())
end

"""
    getworldposition(pt::Point = O;
        centered=true)

Return the world coordinates of `pt`.

The default coordinate system for Luxor drawings is that the top left corner is
0/0. If you use `origin()` (or the various `@-` macro shortcuts), everything
moves to the center of the drawing, and this function with the default
`centered` option assumes an `origin()` function. If you choose
`centered=false`, the returned coordinates will be relative to the top left
corner of the drawing.

```julia
origin()
translate(120, 120)
@show currentpoint()      # => Point(0.0, 0.0)
@show getworldposition()  # => Point(120.0, 120.0)
```
"""
function getworldposition(pt::Point = O;
    centered = true)
    x, y = cairotojuliamatrix(getmatrix()) * [pt.x, pt.y, 1]
    return Point(x, y) -
           (centered ? (Luxor._current_width() / 2.0, Luxor._current_height() / 2.0) : (0, 0))
end

"""
    anglethreepoints(p1::Point, p2::Point, p3::Point)

Find the angle formed by two lines defined by three points.

If the angle is less than π, the line heads to the left.
"""
function anglethreepoints(A::Point, B::Point, C::Point)
    v1 = B - A # line from A to B
    v2 = B - C
    d1 = sqrt(v1.x^2 + v1.y^2) # length v1
    d2 = sqrt(v2.x^2 + v2.y^2)
    if iszero(d1) || iszero(d2)
        return 0
    end
    result = dotproduct(v1, v2) / (d1 * d2)
    if -1 <= result <= 1
        # AB̂C is convex if (B − A)₉₀ · (C − B) < 0
        # v₉₀ is a vector rotated by 90° anti-clockwise
        convexity = dotproduct(-perpendicular(B - A), C - B)
        if convexity >= 0
            return acos(result)
        else
            return 2π - acos(result)
        end
    else
        return 0
    end
end

anglethreepoints(pgon) = anglethreepoints(pgon[1], pgon[2], pgon[3])

"""
    ispolyconvex(pts)

Return true if polygon is convex. This tests that every interior
angle is less than or equal to 180°.
"""
function ispolyconvex(pts)
    for n in eachindex(pts)
        angle = anglethreepoints(pts[n], pts[mod1(n + 1, end)], pts[mod1(n + 2, end)])
        if angle > π # angle > 180°
            return false
        end
    end
    return true
end

"""
    rotatepoint(targetpt::Point, originpt::Point, angle)

Rotate a target point around another point by an angle specified in radians.

Returns the new point.
"""
function rotatepoint(targetpt::Point, originpt::Point, angle)
    x1 = targetpt.x - originpt.x
    y1 = targetpt.y - originpt.y
    x2 = x1 * cos(angle) - y1 * sin(angle)
    y2 = x1 * sin(angle) + y1 * cos(angle)
    return Point(x2 + originpt.x, y2 + originpt.y)
end

"""
    rotatepoint(targetpt::Point, angle)

Rotate a target point around the current origin by an angle specified in radians.

Returns the new point.
"""
rotatepoint(targetpt::Point, angle) = rotatepoint(targetpt, O, angle)

"""
    ispointonleftofline(A::Point, B::Point, C::Point)

For a line passing through points A and B:

  - return true if point C is on the left of the line

  - return false if point C lies on the line
  - return false if point C is on the right of the line
"""
function ispointonleftofline(A::Point, B::Point, C::Point)
    z = ((B.x - A.x) * (C.y - A.y)) - ((B.y - A.y) * (C.x - A.x))
    if z > 10e-6
        return true
    elseif z < -10e-6
        return false
    else
        return false # point is on the line 
    end
end
