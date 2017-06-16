#!/usr/bin/env julia

using Luxor

if VERSION >= v"0.5.0-dev+7720"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

function image_testing(fname)
    width, height = 4000, 4000
    margin = 500
    Drawing(width, height, fname)
    origin()
    background("grey25")
    setline(5)
    sethue("green")
    image = readpng(dirname(@__FILE__) * "/stackoverflow.png")
    w = image.width
    h = image.height
    pagetiles = Tiler(width, height, 7, 9)
    tw = pagetiles.tilewidth/2
    for (pos, n) in pagetiles
        circle(pos, tw, :stroke)
        circle(pos, tw, :clip)
        gsave()
        translate(pos)
        scale(25, 25)
        rotate(rand(0.0:pi/8:2pi))
        placeimage(image, O, centered=true)
        grestore()
        clipreset()
    end
    @test finish() == true
end

fname = "test-image.png"
image_testing(fname)
println("...finished test: output in $(fname)")
