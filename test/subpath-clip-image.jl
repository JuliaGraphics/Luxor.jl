#!/usr/bin/env julia

using Luxor

using Base.Test



function subpath_clipping(fname)
    width, height = 1000, 1000
    Drawing(width, height, fname)
    origin()
    background("ivory")
    sethue("black")
    image = readpng(dirname(@__FILE__) * "/stackoverflow.png")
    w = image.width
    h = image.height
    # all these graphics will make up the clipping mask:
    # reversepath makes holes in the path
    b = false
    for i in 3:15
        randomhue()
        poly(ngon(0, 0, 50 + (i * 30), i, pi/2, vertices=true), :path, reversepath=b)
        if i < 15
            newsubpath()
        end
        b  = !b
    end
    # clip them
    clippreserve()
    # draw image 'through' clipping mask
    scale(40, 40)
    placeimage(image, Point(-w/2, -h/2), 1)
    clipreset()
    @test finish() == true
end

fname = "subpath-clip-image.pdf"
subpath_clipping(fname)
println("...finished test: output in $(fname)")
