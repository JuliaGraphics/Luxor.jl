#!/usr/bin/env julia

using Luxor

using Test

function test_lux_bb(;cent = O)
    bx = BoundingBox(box(O + cent, 100, 100, :none))
    box(bx, :stroke)
    for i in 1:10
        pt = randompoint((1.5bx)...)
        pt2 = pointcrossesboundingbox(pt, bx)
        sethue("grey50")
        arrow(O, pt)
        sethue("red")
        circle(pt2, 3, :stroke)
    end
    snapshot()
end

function test_pointcrossesbouningbox(fname)
    Drawing(400,200,:rec)
    background("brown")
    origin(100,100)
    test_lux_bb()
    translate(200,0)
    test_lux_bb(;cent = (-45, -25))
    #@test
    snapshot(;fname)
    println("...finished point crosses bounding box test, saved in $(fname)")
end

fname = "point-crosses-bounding-box-test.png"

test_pointcrossesbouningbox(fname)
