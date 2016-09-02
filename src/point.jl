import Base: +, -, *, /, .*, ./, ^, !=, <, >, ==, .<, .>, .>=, .<=, norm

export Point, randompoint, randompointarray
"""
The Point type holds two coordinates. Currently it's immutable, so remember not try to
change the values of the x and y values directly.
"""
immutable Point
   x::Float64
   y::Float64
end

+(z::Number, p1::Point)              = Point(p1.x + z, p1.y + z)
+(p1::Point, z::Number)              = Point(p1.x + z, p1.y + z)
+(p1::Point, p2::Point)              = Point(p1.x  +p2.x, p1.y + p2.y)
-(p1::Point, p2::Point)              = Point(p1.x - p2.x, p1.y - p2.y)
-(p::Point)                          = Point(-p.x, -p.y)
-(z::Number, p1::Point)              = Point(p1.x - z, p1.y - z)
-(p1::Point, z::Number)              = Point(p1.x - z, p1.y - z)
*(k::Number, p2::Point)              = Point(k * p2.x, k * p2.y)
*(p2::Point, k::Number)              = Point(k * p2.x, k * p2.y)
/(p2::Point, k::Number)              = Point(p2.x/k, p2.y/k)
.*(k::Number, p2::Point)             = Point(k * p2.x, k * p2.y)
.*(p2::Point, k::Number)             = Point(k * p2.x, k * p2.y)
.*(p1::Point, p2::Point)             = Point(p1.x * p2.x, p1.y * p2.y)
./(p2::Point, k::Number)             = Point(p2.x/k, p2.y/k)
^(p::Point, e::Integer)              = Point(p.x^e, p.y^e)
^(p::Point, e::Float64)              = Point(p.x^e, p.y^e)
inner(p1::Point, p2::Point)          = p1.x * p2.x + p1.y * p2.y

# comparisons (perform lexicographically)

isequal(p1::Point, p2::Point)         = ( p1.x == p2.x && p1.y == p2.y )
isless(p1::Point, p2::Point)          = ( p1.x < p2.x || (p1.x == p2.x && p1.y < p2.y) )
!=(p1::Point, p2::Point)              = !isequal(p1, p2)
<(p1::Point, p2::Point)               = isless(p1,p2)
>(p1::Point, p2::Point)               = p2 < p1
==(p1::Point, p2::Point)              = isequal(p1, p2)
.<(p1::Point, p2::Point)              = p1 < p2
.>(p1::Point, p2::Point)              = p2 < p1
.>=(p1::Point, p2::Point)             = p1 <= p2
.<=(p1::Point, p2::Point)             = p2 <= p1
cmp(p1::Point, p2::Point)             = p1<p2 ? -1 : p2  <p1 ? 1 : 0

function randomordinate(low, high)
    low + rand() * abs(high - low)
end

"""
Return a random point somewhere inside the rectangle defined by the four coordinates:

    randompoint(lowx, lowy, highx, highy)

"""
function randompoint(lowx, lowy, highx, highy)
    Point(randomordinate(lowx, highx), randomordinate(lowy, highy))
end

"""
Return a random point somewhere inside the rectangle defined by the two points:

    randompoint(lowpt, highpt)
"""
function randompoint(lowpt, highpt)
    Point(randomordinate(lowpt.x, highpt.x), randomordinate(lowpt.y, highpt.y))
end

"""
Return an array of `n` random points somewhere inside the rectangle defined by the four coordinates:

    randompointarray(lowx, lowy, highx, highy, n)
"""
function randompointarray(lowx, lowy, highx, highy, n)
    array = Point[]
    for i in 1:n
        push!(array, randompoint(lowx, lowy, highx, highy))
    end
    array
end

"""
Return an array of `n` random points somewhere inside the rectangle defined by two points:

    randompointarray(lowpt, highpt, n)
"""
function randompointarray(lowpt, highpt, n)
    array = Point[]
    for i in 1:n
        push!(array, randompoint(lowpt, highpt))
    end
    array
end
"""
norm of two points. Two argument form.

    norm(p1::Point, p2::Point)
"""
function norm(p1::Point, p2::Point)
    norm([p1.x, p1.y] - [p2.x, p2.y])
end

"""
Find the distance between a point `p` and a line between two points `a` and `b`.

    point_line_distance(p::Point, a::Point, b::Point)

"""
function point_line_distance(p::Point, a::Point, b::Point)
    # area of triangle
    area = abs(0.5 * (a.x * b.y + b.x * p.y + p.x * a.y - b.x * a.y - p.x * b.y - a.x * p.y))
    # length of the bottom edge
    dx = a.x - b.x
    dy = a.y - b.y
    bottom = sqrt(dx * dx + dy * dy)
    return area / bottom
end

"""
Find the midpoint between two points.

    midpoint(p1, p2)
"""
midpoint(p1::Point, p2::Point) = Point((p1.x + p2.x) / 2., (p1.y + p2.y) / 2.)

"""
Find midpoint between the first two elements of an array of points.

    midpoint(a)
"""
midpoint(pt::Array) = midpoint(pt[1], pt[2])

"""
Find intersection of two lines `p1`-`p2` and `p3`-`p4`

    intersection(p1, p2, p3, p4)

This returns a tuple: `(false, 0)` or `(true, Point)`.
"""
function intersection(p1, p2, p3, p4)
    flag = false
    ip = 0
    s1 = p2 - p1
    s2 = p4 - p3
    u = p1 - p3
    ip = 1 / (-s2.x * s1.y + s1.x * s2.y)
    s = (-s1.y * u.x + s1.x * u.y) * ip
    t = ( s2.x * u.y - s2.y * u.x) * ip
    if (s >= 0) && (s <= 1) && (t >= 0) && (t <= 1)
        if isapprox(ip, 0, atol=0.1)
            ip = p1 + (s1 * t)
            flag = true
        end
    end
    return (flag, ip)
end

# end
