#!/usr/bin/env julia

using Luxor, Colors

using Test

using Random
Random.seed!(42)

function drawlogoclip(x, y)
    foregroundcolors = diverging_palette(rand(0:360), rand(0:360), 200, s = 0.99, b=0.8)
    gsave()
    translate(x-100, y)
    julialogo(action=:clip)
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
        fillpath()
    grestore()
    clipreset()
    grestore()
end

function clipping_test(fname)
    Drawing(500, 500, fname)
    origin()
    setopacity(.4)
    foregroundcolors = diverging_palette(rand(0:360), rand(0:360), 200, s = 0.99, b=0.8)
    drawlogoclip(0, 0)
    @test finish() == true
    println("...finished test: output in $(fname)")
end

clipping_test("clipping-tests.png")
