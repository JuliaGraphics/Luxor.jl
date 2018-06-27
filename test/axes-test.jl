#!/usr/bin/env julia

using Luxor

using Test

function test_rulers(x, y, rot, w)
    gsave()
    translate(x, y)
    rotate(rot)
    box(0, 0, w, w, :clip)
    rulers()
    clipreset()
    grestore()
end

fname = "rulers-test.pdf"
width, height = 2000, 2000
Drawing(width, height, fname)
origin(1200, 1200)
background("ivory")
pagetiles = Tiler(width, height, 5, 5, margin=10)
for (pos, n) in pagetiles
  test_rulers(pos.x, pos.y, rand() * 2pi, pagetiles.tilewidth)
end

@test finish() == true
println("...finished test: output in $(fname)")
