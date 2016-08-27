#!/usr/bin/env julia

using Luxor, Colors

function test_axes(x, y, rot, w)
    gsave()
    translate(x, y)
    rotate(rot)
    box(0, 0, w, w, :clip)
    axes()
    clipreset()
    grestore()
end

fname = "/tmp/axes-test.pdf"
width, height = 2000, 2000
Drawing(width, height, fname)
origin()
background("ivory")
pagetiles = PageTiler(width, height, 5, 5, margin=50)
for (xpos, ypos, n) in pagetiles
  test_axes(xpos, ypos, rand() * 2pi, pagetiles.tilewidth)
end

finish()
println("finished test: output in $(fname)")
