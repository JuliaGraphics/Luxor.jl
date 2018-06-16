#!/usr/bin/env julia

using Luxor

using Test

function test_arc_two_points(fname)
    # paper size C
    Drawing("C", fname)
    origin()
    background(Colors.RGB(1, 1, 1))
    sethue("magenta")
    setopacity(0.6)
    setline(2)
    tiles = Tiler(1200, 1200, 8, 8, margin=20)
    for (pos, n) in tiles
        _, pt2, pt3 = ngon(pos, rand(10:tiles.tilewidth/2), 3, rand(0:pi/12:2pi), vertices = true)
        if n % 4 == 0
            pt3 *= 1.1 # test for points not on arc
        end
        randomhue()
        setdash("solid")
        if n % 2 == 0
            sethue("blue")
            arc2r(pos, pt2, pt3, :stroke)
        else
            sethue("cyan")
            carc2r(pos, pt2, pt3, :stroke)
        end
        sethue("magenta")
        arrow(pos, pt2)
        circle(pos, 2, :fill)
        circle(pt2, 3, :fill)
        # the point that may not be on the arc:
        sethue("grey30")
        setdash("dash")
        line(pos, pt3, :stroke)
        circle(pt3, 4, :fill)
    end
    @test finish() == true
end

fname = "arc-twopoints.pdf"
test_arc_two_points(fname)
println("...finished test: output in $(fname)")
