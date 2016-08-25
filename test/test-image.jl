#!/usr/bin/env julia

using Luxor

width, height = 4000, 4000
margin = 500

fname = "/tmp/cairo-image.pdf"
Drawing(width, height, fname)
origin()
background("grey25")

setline(5)
sethue("green")

image = readpng("../examples/julia-logo-mask.png")
w = image.width
h = image.height

pagetiles = PageTiler(width, height, 7, 9)
tw = pagetiles.tilewidth/2
for (x, y, n) in pagetiles
    circle(x, y, tw, :stroke)
    circle(x, y, tw, :clip)
    gsave()
    translate(x, y)
    scale(.95, .95)
    rotate(rand(0.0:pi/8:2pi))
    placeimage(image, -w/2, -h/2)
    grestore()
    clipreset()
end

finish()
println("finished test: output in $(fname)")
