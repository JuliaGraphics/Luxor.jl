#!/usr/bin/env julia

using Luxor

using Test

function test_lux_bb(;cent = O)
    bx = BoundingBox(box(O + cent, 200, 200, :none))
    box(bx, :stroke)
    for i in 0:14
        pt = if i < 4
            sethue("yellow")
            ang = i * π / 2
            O + 40 .* (cos(ang), sin(ang))
        else
            sethue("grey50")
            randompoint((1.5bx)...)
        end
        arrow(O, pt)
        pt2 = pointcrossesboundingbox(pt, bx)
        circle(pt2, 3, :stroke)
    end
    snapshot()
end

function test_pointcrossesboundingbox(fname)
    Drawing(800,400,:rec)
    background("brown")
    origin(200,200)
    test_lux_bb()
    translate(400,0)
    test_lux_bb(;cent = (-45, -25))
    snapshot(;fname)
    println("...finished point crosses bounding box test, saved in $(fname)")
end

fname = "point-crosses-bounding-box-test.png"

test_pointcrossesboundingbox(fname)
