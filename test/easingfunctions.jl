#!/usr/bin/env julia

using Luxor

using Test

using Random
Random.seed!(42)

function draweasingfunction(f, pos, w, h)
    @layer begin
        translate(pos)
        setline(0.5)
        box(O, w, h, :stroke)
        for i in 0:0.005:1.0
            circle(Point(-w/2, h/2) + Point(w * i, -f(i, 0, h, 1)), 1, :fill)
        end
        text(string(f), Point(w/2 - 20, h/2 - 20), halign=:right)
    end
end

function testeasingfunctions(fname)
    Drawing(1200, 1200, fname)
    background("white")
    origin()

    t = Tiler(1200, 1200, 5, 5)
    margin=5

    for (pos, n) in t
        sethue("black")
        n > length(Luxor.easingfunctions) && continue
        draweasingfunction(Luxor.easingfunctions[n], pos, t.tilewidth-margin, t.tileheight-margin)
    end

    @test finish() == true
end

fname = "easingfunctions.pdf"
testeasingfunctions(fname)
println("...finished test: output in $(fname)")
