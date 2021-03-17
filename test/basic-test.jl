using Luxor, Test, Random


# test empty drawings

Drawing()
[Drawing() for x in 1:10]
[Drawing(x, x) for x in 1:10]
Drawing(NaN, NaN, :rec)
[Drawing(x, x, :rec) for x in 1:10]
[Drawing(x, x, :image) for x in 1:10]


p = Point(1, 2)
x, y = p

@test x == 1.0
@test y == 2.0

bb = BoundingBox(p, 2p)

rp = rand(bb)

@test rp in bb

@testset "center3pts" begin
    @test center3pts(Point(1,1), Point(3,1), Point(2,0)) == (Point(2.0, 1.0), 1.0)
    Random.seed!(42)
    p1 = Point(rand(), rand())
    p2 = Point(rand(), rand())
    p3 = Point(rand(), rand())
    c, r = center3pts(p1, p2, p3)
    @test distance(p1, c) ≈ distance(p2, c) ≈ distance(p2, c)
end

println("...finished basic-test")
