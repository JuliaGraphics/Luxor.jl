#!/usr/bin/env julia
using Luxor, Colors
fname = "/tmp/arc-twopoints.pdf"
Drawing(1200, 1200, fname)
origin()
background("white")
sethue("magenta")
setopacity(0.6)
setline(2)
tiles = Tiler(1200, 1200, 8, 8)
for (pos, n) in tiles
  _, pt2, pt3 = ngon(pos, rand(10:tiles.tilewidth/2), 3, rand(0:pi/12:2pi), vertices=true)
  sethue("black")
  if n % 4 == 0
    pt3 *= 1.1 # test for points not on arc
  end
  map(pt -> circle(pt, 4, :fill), [pos, pt3])
  sethue("red")
  circle(pt2, 3, :fill)
  randomhue()
  arc2r(pos, pt2, pt3, :stroke)
end
finish()
println("finished test: output in $(fname)")
