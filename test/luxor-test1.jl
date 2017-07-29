#!/usr/bin/env julia

using Luxor

using Base.Test



function draw_luxor_demo(fname, flag)
    Drawing("A2landscape", fname)

    origin() # move 0/0 to center
    background("purple")

    setopacity(0.7)     # opacity from 0 to 1
    sethue(0.3,0.7,0.9) # sethue sets the color but doesn't change the opacity
    setline(20)         # line width
    # graphics functions use :fill, :stroke, :fillstroke, :clip, or leave blank
    rect(-400,-400,800,800, :fill)
    srand(42)
    randomhue()
    circle(0, 0, 460, :stroke)

    # clip the following graphics to a circle positioned above the x axis
    circle(0,-200,400,:clip)
    sethue("gold")
    setopacity(0.7)
    setline(10)

    # simple line drawing
    for i in 0:pi/36:2pi - pi/36
        move(0, 0)
        line(cos(i) * 600, sin(i) * 600)
        strokepath()
        move(cos(i) * 300, sin(i) * 300)
        rline(0, 5)
        rline(5, 0)
        rline(0, -5)
        rline(-5, 0)
        rmove(10, 0)
        rline(-10, 0)
        strokepath()
    end

    # finish clipping
    clipreset()

    # here using Mac OS X fonts
    fontsize(20)
    setcolor"turquoise"
    fontface("Optima-ExtraBlack")
    textwidth = textextents("Luxor")[5]
    # move the text by half the width
    flag ? textcentered("Luxor centered", 0, 300) :  textcentred("Luxor centred", 0, 300)
    # check that using a Point instead of x,y works
    pnt = Point(0, 330)
    flag ? textcentered("Centered", pnt) :  textcentred("Centred", pnt)

    textright("Right", 0, 360)
    textright("Right Point", Point(0, 390))

    # Check that this just takes default (:baseline)
    text("Invalid valign", Point(0, 420), valign=:foobar)

    # text on curve
    fontsize(18)
    fontface("Avenir-Black")

    textcurve("THIS IS TEXT ON A CURVE " ^ 14, 0, 550, O)
    @test finish() == true

    # Test that calling finish() twice doesn't segfault.
    @test finish() == false
end

# Try both synonyms of textcentered/textcentred
fname = "luxor-test1.png"
draw_luxor_demo(fname, false)
println("...basic test: output in $(fname)")
fname = "luxor-test2.png"
draw_luxor_demo(fname, true)
println("...finished basic test: output in $(fname)")
