#!/usr/bin/env julia

using Luxor

if VERSION >= v"0.5.0-dev+7720"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

function general_tests()
    pt1 = Point(rand() * 4, rand() * 4)

    # arithmetic with tuples
    @test pt1 + (5, 8) == Point(pt1.x + 5, pt1.y + 8)
    @test pt1 * (5, 8) == Point(pt1.x * 5, pt1.y * 8)
    @test pt1 - (5, 8) == Point(pt1.x - 5, pt1.y - 8)
    @test pt1 / (5, 8) == Point(pt1.x / 5, pt1.y / 8)

    @test -pt1 == Point(-pt1.x, -pt1.y)

    # is point/4 inside a box
    @test isinside(pt1 ./ 4, box(O, 10, 10, vertices=true))

    # is point not in every corner of box
    @test all(Point(1, 1) .< box(O, 10, 10, vertices=true)) == false
    @test any(Point(0, 0) .< [Point(1, 1), Point(1, 2), Point(2, 3)]) == true
    # is point outside every corner of box
    @test all(Point(10, 10)  .> box(O, 10, 10, vertices=true)) == true

    @test .>=(Point(5, 5),  Point(5, 5))
    @test .>=(Point(5, 5),  Point(5, 5))
    @test perpendicular(Point(10, 5)) == Point(5.0, -10.0)
    @test perpendicular(Point(-10, -5)) == Point(-5.0,10.0)
    @test crossproduct(Point(2, 3), Point(3, 2)) == -5.0
    @test crossproduct(Point(-20, 30), Point(60, 20)) < 2000

    # shared end points
    # intersection of (A == C) || (B == C) || (A == D) || (B == D)
    pt1 = Point(5, 5)
    pt2 = Point(6, 5)
    @test pt1 + pt2 == Point(11.0,10.0)
    @test intersection(pt1, pt1, pt1, pt1)[1] == false
    @test intersection(pt1, pt2, pt1, pt2, crossingonly=true)[1] == false
    @test intersection(pt1, pt2, pt2, pt1)[1] == false
    pt3 = Point(6, 6)
    pt4 = Point(5, 6)
    @test intersection(pt1, pt2, pt3, pt4)[1] == false

    @test intersection(pt1, pt2, pt3, pt2, commonendpoints = false) == (true,Luxor.Point(6.0,5.0))
    @test intersection(pt1, pt2, pt3, pt2, commonendpoints = true) == (false,Luxor.Point(0.0,0.0))

    # not crossing
    pt1 = Point(5, 5)
    pt2 = Point(5, 5)
    pt3 = Point(5, 5)
    pt4 = Point(5, 5)
    @test intersection(shuffle([pt1, pt2, pt3, pt4])...)[1] == false

    # parallel
    pt1 = Point(5, 5)
    pt2 = Point(5, 6)
    pt3 = Point(6, 5)
    pt4 = Point(6, 6)
    @test intersection(pt1, pt2, pt3, pt4)[1] == false

    @test pt1 * pt2 == Luxor.Point(25.0, 30.0)
    @test pt1 ^ 2 == Luxor.Point(25.0, 25.0)
    @test pt1 ^ 3 == Luxor.Point(125.0,125.0)

    @test pt1 ^ 1.5 < pt1 ^ 1.6
    @test pt1 ^ 1.6 > pt1 ^ 1.5

    # test between interpolation
    @test isequal(midpoint(pt1, pt3), between(pt1, pt3, 0.5))
    @test isequal(between(pt1, pt3, 0.0), pt1)
    @test isequal(between(pt1, pt3, 1.0), pt3)

end

function point_arithmetic_test(fname, npoints=20)
    Drawing(1200, 1200, fname)
    background("white")
    sethue("thistle")
    box(polybbox(), :stroke)
    scale(0.5, 0.5)
    setline(2.5)
    setopacity(0.5)
    fontsize(8)
    origin()
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


    # issue #20615 now fixed in v0.6
    sethue("red")
    for p in zip(pl1, pl1a, pl2, pl2a, pl3, pl3a, pl4, pl5, pl5a, pl5b, pl6, pl6a, pl7)
       map(pt -> circle(pt, 3, :fill), p)
       poly(collect(p), :stroke)
    end

    # comparisons
    testfunctions = [isequal, isless, <, >, ==]
    sethue("green")
    for f in testfunctions
        for i in 1:length(randompoints)-1
            if f(randompoints[i], randompoints[i+1])
                circle(randompoints[i], 18, :fill)
                circle(randompoints[i+1], 7, :fill)
                text(string("$f"), randompoints[i] - 12)
            end
        end
    end

    if VERSION < v"0.6.0-"
        # .<(p1, p2)              = p1 < p2
        # .>(p1, p2)              = p2 < p1
        # .<=(p1, p2)             = p1 <= p2
        # .>=(p1, p2)             = p2 <= p1
        testfunctions = [.<, .>, .>=, .<=]
        sethue("blue")
        for f in testfunctions
            for i in 1:length(randompoints)-1
                if f(randompoints[1:npoints], randompoints[npoints:-1:1]) != true
                    ellipse(randompoints[i], 12, 23, :fill)
                    text(string("$f 4 & 5"), randompoints[i] + 6)
                end
            end
        end
    else
        # WARNING: .< is no longer a function object; use broadcast(<, ...) instead
        # WARNING: .> is no longer a function object; use broadcast(>, ...) instead
        # WARNING: .>= is no longer a function object; use broadcast(>=, ...) instead
        # WARNING: .<= is no longer a function object; use broadcast(<=, ...) instead
        testfunctions = [<, >, >=, <=]
        sethue("orange")
        for f in testfunctions
            for i in 1:length(randompoints)-1
                if f.(randompoints[1:npoints], randompoints[npoints:-1:1]) != true
                    ellipse(randompoints[i], 19, 32, :fill)
                    text(string("v6"), randompoints[i] - 6)
                end
            end
        end
    end

    sethue("purple")
    for i in 1:length(randompoints)-1
        v = cmp(randompoints[i], randompoints[i+1])
        text(string(round(v, 1)), randompoints[i] + 15)
    end

    sethue("cyan")
    for i in 1:length(randompoints)-1
        n = norm(randompoints[i], randompoints[i+1])
        text(string(round(n, 1)), randompoints[i])
    end

    sethue("magenta")
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

    @test finish() == true

    println("...finished test: output in $(fname)")
end

general_tests()
point_arithmetic_test("point-arithmetic.pdf", 100)
