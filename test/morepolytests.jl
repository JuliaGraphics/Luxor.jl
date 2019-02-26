#!/usr/bin/env julia

using Luxor, Colors, Test, Random
Random.seed!(42)

Drawing(800, 800, "morepolytests.png")
origin()
background("white")

@testset "collinear points tests" begin
    pgon = box(BoundingBox(), vertices=true)
    @test length(pgon) == 4

    pgon = polysample(pgon, 12)
    @test length(pgon) == 12

    pgon1 = polyremovecollinearpoints(pgon)
    @test length(pgon1) == 4

    pgon = [Point(x, 0) for x in -250:1.4:250]
    pgon1 = polyremovecollinearpoints(pgon)
    # they've all gone!
    @test length(pgon1) == 0
    pgon = [Point(0, y) for y in -250:1.4:250]
    pgon1 = polyremovecollinearpoints(pgon)
    # they've all gone!
    @test length(pgon1) == 0

    badpgon = Point[O, O + (10, 0)]
    l = length(polyremovecollinearpoints(badpgon))
    @test l == 0

    badpgon = Point[O]
    l = length(polyremovecollinearpoints(badpgon))
    @test l == 0

end

@testset "clockwise tests" begin
    pgon = box(BoundingBox(), vertices=true)
    @test ispolyclockwise(pgon) == true
    pgon1 = reverse(pgon)
    @test ispolyclockwise(pgon1) == false

    pgon = star(O, 100, 21, 0.1, vertices=true)
    @test ispolyclockwise(pgon) == true
    pgon1 = reverse(pgon)
    @test ispolyclockwise(pgon1) == false

    pgon = [polar(100, θ) for θ in 0:π/12:2π]
    @test ispolyclockwise(pgon) == true
    pgon1 = reverse(pgon)
    @test ispolyclockwise(pgon1) == false

    pgon = [Point(x, 0) for x in -250:20:250]
    # move last point lower, makes it clockwise
    pgon[end] += (0, 50)
    @test ispolyclockwise(pgon) == true
    # move it back
    pgon[end] -= (0, 50)
    #  what should a straight line really be, clockwise or not?
    # looks like it's not clockwise
    @test ispolyclockwise(pgon) == false
    @test ispolyclockwise([O, O + (10, 0)]) == false
end

@testset "polyorientation tests" begin
    # clockwise
    orientations = Float64[]
    for i in 1.0:-0.1:0.1
        pgon = box(BoundingBox() * i, vertices=true)
        # polyarea and polyorientation are basically the same, but
        # the latter is doubled and carries sign
        @test polyarea(pgon) == polyorientation(pgon)/2
        push!(orientations, polyorientation(pgon))
    end
    # each polyorientation is area, and should all be clockwise...
    @test all(isequal(25600.00), diff(diff(orientations)))
    # not clockwise
    orientations = Float64[]
    for i in 1.0:-0.1:0.1
        pgon = reverse(box(BoundingBox() * i, vertices=true))
        @test polyarea(pgon) == -polyorientation(pgon)/2
        push!(orientations, polyorientation(pgon))
    end
    @test all(isequal(-25600.00), diff(diff(orientations)))

    # I don't like these, but we've never defined what a polygon _should_ be:
    badpgon = Point[O, O + (10, 0)]
    @test iszero(polyorientation(badpgon))
    @test !ispolyclockwise(badpgon)

    badpgon = Point[O, O + (0, 10)]
    @test iszero(polyorientation(badpgon))
    @test !ispolyclockwise(badpgon)

    badpgon = Point[O, O + (0, 0)]
    @test iszero(polyorientation(badpgon))
    @test !ispolyclockwise(badpgon)

    badpgon = Point[O, O]
    @test iszero(polyorientation(badpgon))
    @test !ispolyclockwise(badpgon)

    badpgon = Point[O]
    @test iszero(polyorientation(badpgon))
    @test !ispolyclockwise(badpgon)
end

@testset "point inside triangle tests" begin
    goodtriangle = Point[O, Point(100, 100), Point(-100, 100)]
    # ispointinsidetriangle() accepts points on the borders
    @test ispointinsidetriangle(O, goodtriangle)
    @test ispointinsidetriangle(Point(100, 100), goodtriangle)
    @test ispointinsidetriangle(Point(50, 100), goodtriangle)
    @test ispointinsidetriangle(Point(0, 100), goodtriangle)
    @test ispointinsidetriangle(Point(-100, 100), goodtriangle)
    @test ispointinsidetriangle(Point(0.00000000001, 0), goodtriangle)
    @test !ispointinsidetriangle(Point(-0.000000001, 0), goodtriangle)

    @test ispointinsidetriangle(Point(50, 50), goodtriangle)
    @test ispointinsidetriangle(Point(10e9, 50), goodtriangle)

    bigtriangle = Point[O, Point(10e9, 0), Point(-10e9, 10e9)]
    @test ispointinsidetriangle(Point(10e4, 10e4), bigtriangle)
    #shouldn't be able to fool this with an anticlockwise triangle
    @test ispointinsidetriangle(Point(10e4, 10e4), reverse(bigtriangle))

    badtriangle = Point[O, Point(100, 0), Point(200, 0)]
    # apparently this is OK... ;|
    @test ispointinsidetriangle(O, badtriangle)

    # perhaps we should catch these not-triangles better than throwing BoundsError
    badtriangle = Point[O, Point(100, 0)]
    @test_throws BoundsError ispointinsidetriangle(O, badtriangle)

    badtriangle = Point[O]
    @test_throws BoundsError ispointinsidetriangle(O, badtriangle)
end


@testset "polyselfintersections tests" begin

    # no selfintersections yet
    goodpoly  = [Point(100cos(θ), 100sin(θ)) for θ in 0:π/12:2π-π/12]
    psi = polyselfintersections(goodpoly, findfirst=false)
    @test length(psi) == 0

    # make it selfintersect
    goodpoly[end] = Point(-150, 150)
    goodpoly[4] = Point(0, -150)
    psi = polyselfintersections(goodpoly)
    @test length(psi) == 16 # loads, doublecounted, that's why

    # check the results
    flag, ip = intersectionlines(psi[1][1], psi[1][2], psi[1][3], psi[1][4])
    @test flag
    @test isapprox(ip, Point(22.9594915033906, -96.97732560024204))

    psi = polyselfintersections(goodpoly, findfirst=true)
    @test length(psi) == 1 # just found the first one

    psi = polyselfintersections(star(O, 200, 12, 0.1, vertices=true), findfirst=true)
    @test length(psi) == 0 # there aren't any

end

@testset "polytriangulate tests" begin
    pgon = star(O, 200, 12, 0.7, vertices=true)

    sethue("black")
    poly(pgon, :stroke, close=true)

    triangles = polytriangulate!(copy(pgon))

    for t in triangles
        randomhue()
        poly(t, :fill)
    end

    # area of all the little triangles should add up to area of big pgon
    @test isapprox(sum(polyarea.(triangles)), polyarea(pgon))

    @test length(triangles) == 22

    pgon = box(BoundingBox(), vertices=true)
    triangles = polytriangulate!(copy(pgon))

    # areas should add up to area of big pgon
    @test isapprox(sum(polyarea.(triangles)), polyarea(pgon))

    @test length(triangles) == 2
end

@test finish() == true
