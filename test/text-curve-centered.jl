#!/usr/bin/env julia

using Luxor

if VERSION >= v"0.5.0-dev+7720"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

function hipster(fname)
    Drawing(400, 350, fname) # hide
    origin() # hide
    rotate(pi/8)

    circle(O, 135, :clip)
    sethue("antiquewhite2")
    paint()

    sethue("gray20")
    setline(3)
    circle(O, 130, :stroke)
    circle(O, 135, :stroke)
    circle(O, 125, :fill)

    sethue("antiquewhite2")
    circle(O, 85, :fill)

    sethue("wheat")
    fontsize(24)
    fontface("Helvetica-Bold")
    textcurvecentered("• LUXOR •", (3pi)/2, 100, O, clockwise=true, baselineshift = -4)
    textcurvecentered("• VECTOR GRAPHICS •", pi/2, 100, O, clockwise=false, letter_spacing=2, baselineshift = -15)

    sethue("gray20")
    map(pt -> star(pt, 40, 3, 0.5, -pi/2, :fill), ngon(O, 40, 3, 0, vertices=true))
    circle(O.x + 30, O.y - 55, 15, :fill)

    sethue("antiquewhite2")
    setline(0.2)
    setdash("dotdotdashed")
    for i in 1:500
        line(randompoint(Point(-200, -350), Point(200, 350)),
             randompoint(Point(-200, -350), Point(200, 350)),
             :stroke)
    end
    @test finish() == true
end

fname = "text-curve-centered.png"
hipster(fname)
println("...finished test: output in $(fname)")
