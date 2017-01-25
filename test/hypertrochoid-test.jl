#!/usr/bin/env julia

using Luxor

if VERSION >= v"0.5.0-dev+7720"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

function test_hypotrochoid(fname)
    Drawing(1200, 1200, fname)
    origin()
    background("grey20")
    sethue("antiquewhite")
    setline(.5)
    tiles = Tiler(1200, 1200, 6, 6)
    for (pos, n) in tiles
        gsave()
        translate(pos)
        R = 45; r = n; d = 20
        sethue("antiquewhite")
        hypotrochoid(R, n, d, :stroke, stepby=pi/300)
        text(string("R = $(2n), r = $(r), d = $(d)"), halign=:center, O.x, O.y+tiles.tileheight/2)
        R = 2n; r = 12; d = 5
        sethue("orange")
        hypotrochoid(R, r, d, :stroke, stepby=pi/300)
        grestore()
    end
    @test finish() == true
end

fname = "hypertrochoid-test.pdf"
test_hypotrochoid(fname)
println("...finished test: output in $(fname)")
