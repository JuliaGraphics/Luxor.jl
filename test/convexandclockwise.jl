using Luxor, Test

function polyconvextest()

    Drawing(100, 100, :png)
    origin()

    # polygons are convex
    for i in 3:16
        @test ispolyconvex(ngon(O, 100, i, vertices=true)) == true
    end

    # 4+ pointed stars aren't convex
    # 3 pointed star is effectively a triangle
    for i in 4:16
        @test ispolyconvex(star(O, 100, i, 0.5, 0, vertices=true)) == false
    end

    pts = [Point(x, 0) for x in 0:100]
    @test ispolyconvex(pts) == true

    @test finish() == true
end

function polyclockwisetest()

    Drawing(100, 100, :png)
    origin()

    # polygons are clockwise
    for i in 3:16
        @test ispolyclockwise(ngon(O, 100, i, vertices=true)) == true
    end
    # stars are too
    for i in 3:16
        @test ispolyclockwise(star(O, 100, i, 0.5, 0, vertices=true)) == true
    end

    pts = [Point(x, 0) for x in 0:100]
    @test ispolyclockwise(pts) == false

    pts = [Point(10cos(x), 10sin(x)) for x in 0:100]
    @test ispolyclockwise(pts) == true

    @test finish() == true
end

polyconvextest()
polyclockwisetest()

println("...finished convex and clockwise tests")
