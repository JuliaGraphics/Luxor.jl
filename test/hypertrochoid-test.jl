#!/usr/bin/env julia

using Luxor, Random

using Test

using Random
Random.seed!(42)

function test_hypotrochoid(fname)
    Drawing(1400, 1400, fname)
    origin()
    background("grey20")
    sethue("antiquewhite")
    setopacity(0.8)
    tiles = Tiler(1200, 1200, 6, 6)
    for (pos, n) in tiles
        gsave()
        setline(1.5)
        translate(pos)

        R = 45; r = n; d = 20
        sethue("antiquewhite")
        poly(hypotrochoid(R, n, d, :stroke, stepby=pi/300, vertices=true), :stroke, close=true)
        text(string("R = $(R), r = $(r), d = $(d)"), halign=:center, O.x, O.y+tiles.tileheight/2)

        # test perimeterlength
        ptslist = hypotrochoid(R, n, d, :stroke, stepby=pi/300, vertices=true)
        polyperimeter(ptslist)

        R = 2n; r = 12; d = 5
        sethue("orange")
        (R == r) && (r += 1)
        p = hypotrochoid(R, r, d, :none, stepby=pi/305, vertices=true)
        polydistances(p) # just testing
        poly(p, :stroke, close=true)
        text(string("R = $(R), r = $(r), d = $(d)"), halign=:center, O.x, O.y+tiles.tileheight/2 + 10)

        # testing portions of polys
        portion = rand()
        setline(.25)
        sethue("magenta")
        section = polyportion(p, portion)
        poly(section, :stroke, close=false)
        sethue("green")
        circle(section[end], 2, :stroke)
        poly(polyremainder(p, portion), :stroke, close=false)

        text(string("portion ", round(portion, digits=2)), halign=:center, O.x, O.y+tiles.tileheight/2 + 30)

        sethue("cyan")
        setline(0.3)
        poly(offsetpoly(p, 15), :stroke, close=true)
        text("offset 15", halign=:center, O.x, O.y+tiles.tileheight/2 + 20)

        grestore()
    end
    @test finish() == true
end

using Random

Random.seed!(42)

fname = "hypotrochoid-test.pdf"
test_hypotrochoid(fname)
println("...finished test: output in $(fname)")
