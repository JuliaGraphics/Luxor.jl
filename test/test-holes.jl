#!/usr/bin/env julia

using Luxor, Base.Test

fname = "holes.pdf"
Drawing(1200, 1200, fname)

origin()
background("black")

pagetiles = Tiler(1200, 1200, 17, 19, margin=50)
for (pos, n) in pagetiles
  randomhue()
  rad = pagetiles.tilewidth
  ngon(pos, rad/2, rand(5:12), 0, :path)
  newsubpath()
  ngon(pos, rand(1:rad/3), rand(5:12), 0, :path, reversepath=true)
  fillstroke()
end

@test finish() == true
println("...finished test: output in $(fname)")
