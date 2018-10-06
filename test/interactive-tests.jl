#!/usr/bin/env julia

# this test isn't run by Pkg.test

# it can be run to test Juno/Jupyter integration...

using Luxor

using Test

using Random
Random.seed!(42)

function draw_hypotrochoids()
    background("grey10")
    sethue("antiquewhite")
    setopacity(0.8)
    tiles = Tiler(1200, 1200, 6, 6)
    for (pos, n) in tiles
        gsave()
        setline(.5)
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
end

function test_hypotrochoid_at_png()
    @png begin
        draw_hypotrochoids()
    end 1200 1200
end
function test_hypotrochoid_at_svg()
    @svg begin
        draw_hypotrochoids()
    end 1200 1200
end
function test_hypotrochoid_at_pdf()
    @pdf begin
        draw_hypotrochoids()
    end 1200 1200
end

Random.seed!(42)

test_hypotrochoid_at_png() ; println("output PNG")
test_hypotrochoid_at_svg() ; println("output SVG")
test_hypotrochoid_at_pdf() ; println("output PDF")


#testing @manipulate

using Interact

function makecircle(r)
    d = Drawing(300, 300, :svg)
    sethue("black")
    setline(0.1)
    origin()
    hypotrochoid(150, r, 35, :stroke)
    finish()
    return d
end

@manipulate for r in 5:150
    makecircle(r)
end
