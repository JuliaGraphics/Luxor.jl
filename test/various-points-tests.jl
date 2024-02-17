using Luxor, Test

function rotate_points_test(fname)
    Drawing(300, 300, fname)
    origin()
    background("black")
    pts = ngon(O, 120, 5, vertices=true)

    sethue("red")
    circle.(pts, 10, :stroke)

    # rotate each point by 2π
    pts1 = rotatepoint.(pts, Ref(O), 2π)

    sethue("blue")
    circle.(pts1, 20, :stroke)

    # they should be equal
    for pr in zip(pts, pts1)
        @test isapprox(first(pr), last(pr), atol=1.0e-12)
    end

    # now rotate each point by π
    pts2 = rotatepoint.(pts, Ref(O), π)
    sethue("green")
    circle.(pts2, 30, :stroke)

    # they should not be equal
    for pr in zip(pts, pts2)
        @test !isapprox(first(pr), last(pr))
    end
    @test finish() == true
    println("...finished test: output in $(fname)")
end

function tick_test(fname)

    Drawing(400, 400, fname)
    origin()
    background("antiquewhite")
    sethue("red")
    majorticks, minorticks = tickline(O - (100, 0), O + (100, 0), minor=1)

    @test length(majorticks) == 3
    @test length(minorticks) == 5

    @test majorticks[1] == Point(-100, 0)
    @test majorticks[2] == Point(0, 0)
    @test majorticks[3] == Point(100, 0)

    # all minor ticks should be 5.0 apart
    @test all(pt -> isapprox(pt, Point(50.0, 0.0)), diff(minorticks))

    translate(0, 100)

    majorticks, minorticks = tickline(O - (150, 0), O + (150, 0), major=10, minor=4, vertices=true)
    sethue("purple")
    setline(0.5)
    rule.(majorticks, π/2, boundingbox=BoundingBox(O - (200, 10), O + (200, 10)))
    rule.(minorticks, π/2, boundingbox=BoundingBox(O - (200, 5), O + (200, 5)))

    @test length(majorticks) == 12
    @test length(minorticks) == 56


    translate(0, 50)

    majorticks, minorticks = tickline(O - (150, 0), O + (150, 0), log = true, major=10, minor=4, vertices=true)

    sethue("black")
    setline(0.5)
    rule.(majorticks, -π/3, boundingbox=BoundingBox(O - (200, 10), O + (200, 10)))
    rule.(minorticks, -π/3, boundingbox=BoundingBox(O - (200, 5), O + (200, 5)))

    @test length(majorticks) == 12
    @test length(minorticks) == 56

    @test finish() == true
    println("...finished test: output in $(fname)")
end

rotate_points_test("rotatepoints.png")
tick_test("ticktest.png")
