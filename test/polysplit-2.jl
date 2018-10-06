#!/usr/bin/env julia

using Luxor

using Test

using Random
Random.seed!(42)

function poly_split_2(fname)
    Drawing(2500, 2500, fname)
    background(1, .8, .1)
    origin()
    setopacity(0.7)
    fontsize(2)
    sethue("black")
    s = squircle(O, 600, 600, vertices=true)
    s = box(O, 60, 60, vertices=true)
    setline(2)
    tiles = Tiler(2500, 2500, 6, 6, margin=25)
    for (pos, n) in tiles
        gsave()
        s = squircle(O, tiles.tileheight/2 - 10, tiles.tileheight/2 - 10, vertices=true)
        translate(pos)
        pt1 = Point(O.x + rand(-120:120), -tiles.tileheight/2)
        pt2 = Point(O.x + rand(-120:120), tiles.tileheight/2)
        setdash("dot")
        move(pt1)
        rline(pt2 - pt1)
        strokepath()
        setdash("solid")
        poly1, poly2 = polysplit(s, pt1, pt2)
        randomhue()
        prettypoly(poly1, :fill, close=true)
        randomhue()
        translate(5, 0)
        prettypoly(poly2, :fill, close=true)
        grestore()
    end
    @test finish() == true
end

fname = "polysplit-2.pdf"
poly_split_2(fname)
println("...finished test: output in $(fname)")
