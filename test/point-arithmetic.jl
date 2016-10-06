#!/usr/bin/env julia

using Luxor, Base.Test

function general_tests()
    pt1 = Point(rand() * 4, rand() * 4)
    @test -pt1 == Point(-pt1.x, -pt1.y)

    # is point/4 inside a box
    @test isinside(pt1 ./ 4, box(O, 10, 10, vertices=true))

    # is point not in every corner of box
    @test all(Point(1, 1) .< box(O, 10, 10, vertices=true)) == false

    # is point outside every corner of box
    @test all(Point(10, 10)  .> box(O, 10, 10, vertices=true)) == true

    @test .>=(Point(5, 5),  Point(5, 5))
    @test .>=(Point(5, 5),  Point(5, 5))
    @test perpendicular(Point(10, 5)) == Point(5.0, -10.0)
    @test perpendicular(Point(-10, -5)) == Point(-5.0,10.0)
    @test crossproduct(Point(2, 3), Point(3, 2)) == -5.0
    @test crossproduct(Point(-20, 30), Point(60, 20)) < 2000
end

function point_arithmetic_test(fname, npoints=20)
    Drawing(1200, 1200, fname)
    origin()
    scale(0.5, 0.5)
    setline(2.5)
    background("white")
    setopacity(0.7)
    fontsize(25)
    randompoints = randompointarray(Point(-600, -600), Point(600, 600), npoints)

    # +
    pl1 = map(pt -> pt + 2, randompoints)
    pl1a = map(pt -> 2 + pt, randompoints)

    # -
    pl2 = map(pt -> pt - 2, randompoints)
    pl2a = map(pt -> 2 - pt, randompoints)

    # *
    pl3 = map(pt -> pt * rand(), randompoints)
    pl3a = map(pt -> rand() * pt, randompoints)

    # /
    pl4 = map(pt -> pt / rand(), randompoints)

    # .*
    pl5 = 1.012 .* randompoints
    pl5a = randompoints .* 1.012
    pl5b = [1.03, 0.97, -1.05] .* randompoints[1:3]

    # ./
    pl6 = randompoints[1:3] ./ [1.03, 0.97, -1.05]
    pl6a =  [1.03, 0.97, -1.05] .* randompoints[1:3]

    # ^
    pl7 = map(pt -> ^(pt/2, 2), randompoints)

    # ^ FAILS
    # pl8 = map(pt -> ^(pt, 1.2), randompoints)

    for p in zip(pl1, pl1a, pl2, pl2a, pl3, pl3a, pl4, pl5, pl5a, pl5b, pl6, pl6a, pl7)
        randomhue()
        map(pt -> circle(pt, 3, :fill), p)
        poly(collect(p), :stroke)
    end

    # comparisons

    testfunctions = [isequal, isless, <, >, ==]
    for f in testfunctions
        randomhue()
        for i in 1:length(randompoints)-1
            if f(randompoints[i], randompoints[i+1])
                circle(randompoints[i], i * 1.2, :stroke)
                circle(randompoints[i+1], i * 1.3, :stroke)
            end
        end
    end

    testfunctions = [.<, .>, .>=, .<=]
    for f in testfunctions
        randomhue()
            if f(randompoints[1:npoints], randompoints[npoints:-1:1]) == true
                ellipse(randompoints[i], i * 2, i * 4, :stroke)
            end
    end

    for i in 1:length(randompoints)-1
        v = cmp(randompoints[i], randompoints[i+1])
        text(string(v), randompoints[i])
    end

    for i in 1:length(randompoints)-1
        n = norm(randompoints[i], randompoints[i+1])
        text(string(n), randompoints[i])
    end

    map(pt -> circle(pt, 6, :stroke), [midpoint(randompoints), randompoints[1], randompoints[2]])

    if all(randompoints .== randompoints)
        text("the points compare elementwise")
    else
        error("elementwise comparison failed")
    end

    if any(randompoints .!= randompoints)
        error("elementwise comparison failed")
    else
        text("the points really do compare elementwise", O + 15)
    end

    finish()

    println("finished test: output in $(fname)")
end

general_tests()
point_arithmetic_test("/tmp/point-arithmetic.pdf", 100)
