#!/usr/bin/env julia

using Luxor, Random

using Test

function test_epitrochoid(fname)
    Drawing(1400, 1400, fname)
    origin()
    background("grey20")
    sethue("antiquewhite")
    setopacity(0.8)
    tiles = Tiler(1200, 1200, 6, 6)
    for (pos, n) in tiles
        gsave()
        setline(.5)
        translate(pos)

        R = 20; r = n; d = 20
        sethue("antiquewhite")
        poly(epitrochoid(R, n, d, :stroke, stepby=pi/300, vertices=true), :stroke, close=true)
        text(string("R = $(R), r = $(r), d = $(d)"), halign=:center, O.x, O.y+tiles.tileheight/2)

        # test perimeterlength
        ptslist = epitrochoid(R, n, d, :stroke, stepby=pi/300, vertices=true)
        polyperimeter(ptslist)

        R = 20; r = 12; d = 5
        sethue("orange")
        (R == r) && (r += 1)
        p = epitrochoid(R, r, d, :none, stepby=pi/305, vertices=true)
        polydistances(p)
        text(string("R = $(R), r = $(r), d = $(d)"), halign=:center, O.x, O.y+tiles.tileheight/2 + 10)
        poly(p, :stroke, close=true)

        # testing portions of polys
        sethue("magenta")
        portion = rand()
        poly(polyportion(p, portion), :stroke, close=false)
        text(string("portion ", round(portion, digits=2)), halign=:center, O.x, O.y+tiles.tileheight/2 + 30)

        sethue("cyan")
        setline(0.3)
        poly(offsetpoly(p, 5), :stroke, close=true)
        text("offset 15", halign=:center, O.x, O.y+tiles.tileheight/2 + 20)

        grestore()
    end
    @test finish() == true
end

Random.seed!(42)

fname = "epitrochoid-test.pdf"
test_epitrochoid(fname)
println("...finished test: output in $(fname)")
