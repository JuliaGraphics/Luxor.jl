import Base: +, -, *, /, .*, ./, ^, !=, <, >, ==, .<, .>, .>=, .<=, norm

export Point, randompoint, randompointarray

type Point
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

function randompoint(lowx, lowy, highx, highy)
    Point(randomordinate(lowx, highx), randomordinate(lowy, highy))
end

function randompointarray(lowx, lowy, highx, highy, n)
    array = Point[]
    for i in 1:n
        push!(array, randompoint(lowx, lowy, highx, highy))
    end
    array
end

# note the two argument form
function norm(p1::Point, p2::Point)
    norm([p1.x, p1.y] - [p2.x, p2.y])
end
