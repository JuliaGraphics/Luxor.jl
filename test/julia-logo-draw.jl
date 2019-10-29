#!/usr/bin/env julia

using Luxor

using Test

using Random
Random.seed!(42)

function spirals()
    gsave()
    scale(.3)
    r = 200
    setcolor("gray")
    for i in 0:pi/8:2pi
        gsave()
        translate(r * cos(i), r * sin(i))
        rotate(i)
        julialogo()
        grestore()
    end
    grestore()
    juliacircles(20)
end

function expandingspirals()
    gsave()
    scale(.3)
    r = 200
    for i in pi:pi/12:6pi
        gsave()
        translate(i/3 * r * cos(i), i/3 * r * sin(i))
        scale(0.8)
        rotate(i)
        julialogo()
        grestore()
    end
    grestore()
end

function dropshadow()
    steps=20
    # white-gray ramp
    gramp = range(colorant"white", stop=colorant"gray60", length=steps)
    gsave()
    r = 200
    sethue("purple")
    rect(O, 5, 10, :stroke)
    setopacity(0.1)
    for i in 1:steps
        translate(-0.6, -0.5)
        julialogo(bodycolor=gramp[i], color=false)
    end
    julialogo()
    grestore()
end

function colorgrid()
    #cols = colormap("RdBu", 5; mid=0.5, logscale=false)
    #cols = sequential_palette(rand(10:360), 5, b=0.1)
    cols = distinguishable_colors(25)
    gsave()

    pagetiles = Tiler(500, 400, 5, 5)
    for (pos, n) in pagetiles
      gsave()
      setcolor(color(cols[n]))
      translate(pos)
      scale(0.3)
      julialogo(color=false)
      grestore()
    end

    grestore()
end

function boxes_and_rectangles(pt::Point)
    for i in 1:20
        randomhue()
        poly(box(pt + i, 10i, 10i, vertices=true), :stroke, close=true)
    end
    for i in 40:10:150
        randomhue()
        translate(i, 0)
        poly(squircle(O, 30, 30, vertices=true), :stroke)
    end
end

function draw_julia_logos(fname)
    Drawing(1600, 1600, fname)
    origin()
    background("white")

    translate(-500, -200)
    spirals()

    translate(750, 0)
    expandingspirals()

    translate(-1000, 500)
    dropshadow()

    translate(800, 50)
    colorgrid()

    translate(-700, 300)
    boxes_and_rectangles(O)

    @test finish() == true
    println("...finished test: output in $(fname)")
end

draw_julia_logos("julia-logo-draw.png")
