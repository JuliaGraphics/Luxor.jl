#!/usr/bin/env julia

using Luxor

using Base.Test

function test_axes(x, y, rot, w)
    gsave()
    translate(x, y)
    rotate(rot)
    box(0, 0, w, w, :clip)
    axes()
    clipreset()
    grestore()
end

fname = "axes-test.pdf"
width, height = 2000, 2000
Drawing(width, height, fname)
origin(1000, 1000)
background("ivory")
pagetiles = Tiler(width, height, 5, 5, margin=50)
for (pos, n) in pagetiles
  test_axes(pos.x, pos.y, rand() * 2pi, pagetiles.tilewidth)
end

@test finish() == true
println("...finished test: output in $(fname)")
