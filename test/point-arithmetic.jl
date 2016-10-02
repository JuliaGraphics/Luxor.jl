#!/usr/bin/env julia

using Luxor

function point_arithmetic_test(fname)
    npoints = 20
    Drawing(1200, 1200, fname)
    origin()
    scale(0.5, 0.5)
    setline(2.5)
    background("grey90")
    setopacity(0.5)
    randompoints = randompointarray(Point(-600, -600), Point(600, 600), npoints)

    # +
    pl1 = map(pt -> pt + 2, randompoints)
    # -
    pl2 = map(pt -> pt - 2, randompoints)
    # *
    pl3 = map(pt -> pt * rand(), randompoints)
    # /
    pl4 = map(pt -> pt / rand(), randompoints)

    # .*
    pl5 = 1.012 .* randompoints

    # ./
    pl6 = randompoints[1:3] ./ [1.03, 0.97, -1.05]

    # ^
    pl7 = map(pt -> ^(pt/2, 2), randompoints)

    # ^ FAILS!!!!!!!!
    # pl8 = map(pt -> ^(pt, 1.2), randompoints)

    for p in zip(pl1, pl2, pl3, pl4, pl5, pl6, pl7)
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

    finish()

    println("finished test: output in $(fname)")
end

point_arithmetic_test("/tmp/point-arithmetic.pdf")
