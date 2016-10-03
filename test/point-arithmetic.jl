#!/usr/bin/env julia

using Luxor

function point_arithmetic_test(fname, npoints=20)
    Drawing(1200, 1200, fname)
    origin()
    scale(0.5, 0.5)
    setline(2.5)
    background("grey10")
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

    test = [isequal, isless, <, >, ==]
    for f in test
        randomhue()
        for i in 1:length(randompoints)-1
            if f(randompoints[i], randompoints[i+1])
                circle(randompoints[i], i * 2, :stroke)
                circle(randompoints[i+1], i * 3, :stroke)
            end
        end
    end

    test = [.<, .>, .>=, .<=]
    for f in test
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

    map(pt -> circle(pt, 50, :fill), [midpoint(randompoints), randompoints[1], randompoints[2]])

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

point_arithmetic_test("/tmp/point-arithmetic.pdf", 100)
