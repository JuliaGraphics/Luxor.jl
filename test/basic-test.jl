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

@testset "concatenate" begin

    finish()

    
    d1 = Drawing(200,100,:svg)
    origin()
    circle(O,60,:fill)
    finish()

    d2 = Drawing(200,200,:svg)
    rect(O,200,200,:fill)
    finish()
    @test typeof(hcat(d1,d2; hpad=10, valign=:top, clip = true)) <: Drawing
    @test typeof(hcat(d1,d2; hpad=10, valign=:middle, clip = false)) <: Drawing
    @test typeof(hcat(d1,d2; hpad=10, valign=:bottom, clip = true)) <: Drawing

    @test typeof(vcat(d1,d2; vpad=10, halign=:left, clip = true)) <: Drawing
    @test typeof(vcat(d1,d2; vpad=10, halign=:center, clip = false)) <: Drawing
    @test typeof(vcat(d1,d2; vpad=10, halign=:right, clip = true)) <: Drawing

end

println("...finished basic-test")
