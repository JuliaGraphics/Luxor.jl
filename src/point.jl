import Base: +, -, *, /, ^, !=, <, >, ==
import Base: isequal, isless, isapprox, cmp, size, getindex, broadcastable

"""
The Point type holds two coordinates. It's immutable, you can't
change the values of the x and y values directly.
"""
struct Point
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

# convenience
Point((x, y)::Tuple{Real, Real}) = Point(x, y)

# for broadcasting
Base.size(::Point) = 2
Base.getindex(p::Point, i) = [p.x, p.y][i]

Base.broadcastable(x::Point) = Ref(x)

# for iteration
Base.eltype(::Point) = Float64
Base.iterate(p::Point, state = 1) = state > length(p) ? nothing : (p[state], state + 1)
Base.length(::Point) = 2


"""
    dotproduct(a::Point, b::Point)

Return the scalar dot product of the two points.
"""
function dotproduct(a::Point, b::Point)
    result = 0.0
    for i in [:x, :y]
        result += getfield(a, i) * getfield(b, i)
    end
    return result
end

# comparisons

isequal(p1::Point, p2::Point)         = isapprox(p1.x, p2.x, atol=0.00000001) && (isapprox(p1.y, p2.y, atol=0.00000001))
isapprox(p1::Point, p2::Point)        = isapprox(p1.x, p2.x, atol=0.00000001) && (isapprox(p1.y, p2.y, atol=0.00000001))
isless(p1::Point, p2::Point)          = (p1.x < p2.x || (isapprox(p1.x, p2.x) && p1.y < p2.y))
!=(p1::Point, p2::Point)              = !isequal(p1, p2)
<(p1::Point, p2::Point)               = isless(p1, p2)
>(p1::Point, p2::Point)               = p2 < p1
==(p1::Point, p2::Point)              = isequal(p1, p2)

cmp(p1::Point, p2::Point)             = (p1 < p2) ? -1 : (p2 < p1) ? 1 : 0

# a unique that works better on points?
# I think this uses ==
# TODO perhaps unique(x -> round(x, sigdigits=13), myarray) ?
# "any implementation of unique with a tolerance will have some odd behaviors" Steven GJohnson
function Base.unique(pts::Array{Point, 1})
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
    return sqrt(dx*dx + dy*dy)
end

"""
    pointlinedistance(p::Point, a::Point, b::Point)

Find the distance between a point `p` and a line between two points `a` and `b`.
"""
function pointlinedistance(p::Point, a::Point, b::Point)
  dx = b.x - a.x
  dy = b.y - a.y
  return abs(p.x * dy - p.y * dx + b.x * a.y - b.y * a.x) / hypot(dx, dy);
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

function between(couple::NTuple{2, Point}, x)
    p1, p2 = couple
    return p1 + (x * (p2 - p1))
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
        ux = -py/l
        uy = px/l
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
    ep1 = Point(-ip.y, ip.x)/2 + (p1 + p2)/2
    ep2 = Point(ip.y, -ip.x)/2 + (p1 + p2)/2
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

function randomordinate(low, high)
    if low > high
      low, high = high, low
    end
    return low + rand() * abs(high - low)
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
    slope(pointA::Point, pointB::Point)

Find angle of a line starting at `pointA` and ending at `pointB`.

Return a value between 0 and 2pi. Value will be relative to the current axes.

```
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

    Luxor.Point(7.0710678118654755, 7.071067811865475)
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

    Luxor.Point(7.071067811865475, 7.0710678118654755)
"""
polar(r, theta) = Point(r * cos(theta), r * sin(theta))

"""
    intersectionlines(p0, p1, p2, p3,
        crossingonly=false)

Find point where two lines intersect.

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

        d  = l1[1] * l2[2] - l1[2] * l2[1]
        dx = l1[3] * l2[2] - l1[2] * l2[3]
        dy = l1[1] * l2[3] - l1[3] * l2[1]

        if !iszero(d)
            resultip = pt = Point(dx/d, dy/d)
            if crossingonly == true
                if ispointonline(resultip, p0, p1) && ispointonline(resultip, p2, p3)
                    resultflag = true
                else
                    resultflag = false
                end
            else
                if ispointonline(resultip, p0, p1, extended=true) &&
                   ispointonline(resultip, p2, p3, extended=true)
                    resultflag = true
                else
                    resultflag = false
                end
            end
        else
            resultflag = false
            resultip =  Point(0, 0)
        end
    end
    return (resultflag, resultip)
end

"""
    pointinverse(A::Point, centerpoint::Point, rad)

Find `A′`, the inverse of a point A with respect to a circle `centerpoint`/`rad`, such that:

```
distance(centerpoint, A) * distance(centerpoint, A′) == rad^2
```

Return (true, A′) or (false, A).
"""
function pointinverse(A::Point, centerpoint, rad)
    A == centerpoint && throw(error("pointinverse(): point $A and centerpoint $centerpoint are the same"))
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

Return the current point.
"""
function currentpoint()
    x, y = Cairo.get_current_point(get_current_cr())
    return Point(x, y)
end

"""
    hascurrentpoint()

Return true if there is a current point. Obtain the current point
with `currentpoint()`.
"""
function hascurrentpoint()
    return Cairo.has_current_point(get_current_cr())
end

"""
    getworldposition(pt::Point = O;
        centered=true)

Return the world coordinates of `pt`.

The default coordinate system for Luxor/Cairo is that the top left corner is 0/0.
If you use `origin()`, everything moves to the center of the drawing, and this function
with the default `centered` option assumes an `origin()` function. If you choose
`centered=false`, the returned coordinates will be relative to the top left corner of
the drawing.

```
origin()
translate(120, 120)
@show currentpoint()      # => Point(0.0, 0.0)
@show getworldposition()  # => Point(120.0, 120.0)
```
"""
function getworldposition(pt::Point=O;
    centered=true)
    x, y = cairotojuliamatrix(getmatrix()) * [pt.x, pt.y, 1]
    return Point(x, y) - (centered ? (Luxor.current_width()/2.0, Luxor.current_height()/2.0) : (0 , 0))
end

"""
    anglethreepoints(p1::Point, p2::Point, p3::Point)

Find the angle between two lines formed by three points (eg
∠ or ⟨). The angle will be between 0 and π.

You can use `ispolyconvex()` to distinguish between the two
possible interprations of an angle.
"""
function anglethreepoints(p1::Point, p2::Point, p3::Point)
    v1 = p2 - p1 # line from p1 to p2
    v2 = p2 - p3
    d1 = sqrt(v1.x^2 + v1.y^2) # length v1
    d2 = sqrt(v2.x^2 + v2.y^2)
    if iszero(d1) || iszero(d2)
        return 0
    end
    result = dotproduct(v1, v2) / (d1 * d2)
    if -1 <= result <= 1
        return acos(result)
    else
        return 0
    end
end

anglethreepoints(pgon) = anglethreepoints(pgon[1], pgon[2], pgon[3])

"""
    ispolyconvex(pts)

Return true if polygon is convex.
"""
function ispolyconvex(pts)
    a = 0
    for n in eachindex(pts)
        a += π - anglethreepoints(pts[n], pts[mod1(n + 1, end)], pts[mod1(n + 2, end)])
    end
    return a <= 2π
end
