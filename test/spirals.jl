#!/usr/bin/env julia

using Luxor

if VERSION >= v"0.5.0-dev+7720"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

function test_spirals(fname)
    Drawing(2000, 2000, fname)
    origin()
    setopacity(0.5)
    setline(2)
    for i in 0:pi/6:2pi
        rotate(i)
        randomhue()
        v1 = spiral(10, log(golden)/(pi/2), log=true, stepby=pi/5, period=4pi, vertices=true)
        poly(v1, :fill)
        for i in 1:length(v1) - 3
            poly([v1[i], v1[i+1], v1[i+2]], :fill)
        end
    end
    for i in 0:pi/6:2pi
        rotate(i)
        v2 = spiral(30, 1, log=false, stepby=pi/10, period=4pi, vertices=true)
        poly(v2, :stroke)
        rand(Bool) ? sethue("white") : sethue("black")
        for i in 1:length(v2) - 3
            poly([v2[i], v2[i+1], v2[i+2]], :fill)
        end
    end
    @test finish() == true
end

fname = "spirals.pdf"
test_spirals(fname)
println("...finished test: output in $(fname)")
