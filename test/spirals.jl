#!/usr/bin/env julia

using Luxor

using Test

using Random
Random.seed!(42)

function test_spirals(fname)
    Drawing(2000, 2000, fname)
    origin()
    setopacity(0.5)
    setline(2)
    for i in 0:pi/6:2pi
        rotate(i)
        randomhue()
        v1 = spiral(10, log(Base.MathConstants.golden)/(pi/2), log=true, stepby=pi/5, period=4pi, vertices=true)
        poly(v1, :fill)
        for j in 1:length(v1) - 3
            poly([v1[j], v1[j+1], v1[j+2]], :fill)
        end
    end
    for i in 0:pi/6:2pi
        rotate(i)
        v2 = spiral(30, 1, log=false, stepby=pi/10, period=4pi, vertices=true)
        poly(v2, :stroke)
        rand(Bool) ? sethue("white") : sethue("black")
        for j in 1:length(v2) - 3
            poly([v2[j], v2[j+1], v2[j+2]], :fill)
        end
    end
    @test finish() == true
end

fname = "spirals.pdf"
test_spirals(fname)
println("...finished test: output in $(fname)")
