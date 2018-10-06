#!/usr/bin/env julia

using Luxor

using Test

using Random
Random.seed!(42)

function rule_test(fname)
    Drawing(2000, 2000, fname)
    origin()
    setline(0.15)

    for x in 10 .^ range(0, stop=3, length=200) # good bye logspace
        rule(Point(0 + x, 0), pi/2, boundingbox=BoundingBox() * x/9)
        rule(Point(0 - x, 0), pi/2, boundingbox=BoundingBox() * x/9)
        rotate(0.05)
    end
    for y in 10 .^ range(0, stop=3, length=200) # you served us well
        rule(Point(0, 0 + y), 0, boundingbox=BoundingBox() * y/9)
        rule(Point(0, 0 - y), 0, boundingbox=BoundingBox() * y/9)
        rotate(0.05)
    end
    @test finish() == true
    println("...finished test: output in $(fname)")
end

rule_test("rules.pdf")
