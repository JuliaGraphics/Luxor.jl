#!/usr/bin/env julia

using Luxor, Test, Random

Random.seed!(42)

function test_styles(fname)
    pagewidth, pageheight = 1200, 1400
    Drawing(pagewidth, pageheight, fname)
    background("antiquewhite")
    ds = Style()
    dark = Style(colorant"orange")
    jm = Style(colorant"green", "JuliaMono-Black", 20)
    applystyle(ds)
    box(O, 140, 140, :fill)
    applystyle(dark)
    box(O, 40, 240, :fill)
    text("hello world")
    applystyle(jm)
    text("hello world again", O + (20, 30))
    @test finish() == true
    println("...finished styles test, saved in $(fname)")
end
println("start test")
fname = "styles-test.png"
test_styles(fname)
