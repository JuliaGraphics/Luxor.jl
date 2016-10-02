#!/usr/bin/env julia

using Luxor, Colors

include("julia-logo.jl") # the julia logo coordinates

function draw_logo_clip(x, y)
    foregroundcolors = diverging_palette(rand(0:360), rand(0:360), 200, s = 0.99, b=0.8)
    gsave()
    translate(x-100, y)
    julialogo(false, true) # use julia logo as clipping mask
    clip()
    for i in 1:500
        sethue(foregroundcolors[rand(1:end)])
        circle(rand(-50:350), rand(0:300), 15, :fill)
    end
    #  to test clippreserve(), draw a path, and it is intersected with clip region (julia logo)
    # then filled with solid red
    gsave()
        circle(O, 200, :path)
        clippreserve()
        setcolor("red")
        fill()
    grestore()
    clipreset()
    grestore()
end

function clipping_test(fname)
    Drawing(500, 500, fname)
    origin()
    background("white")
    setopacity(.4)
    foregroundcolors = diverging_palette(rand(0:360), rand(0:360), 200, s = 0.99, b=0.8)
    draw_logo_clip(0, 0)
    finish()
    println("finished test: output in $(fname)")
end

clipping_test("/tmp/clipping-tests.png")
