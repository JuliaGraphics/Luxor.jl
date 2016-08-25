#!/usr/bin/env julia

using Luxor, Colors

fname = "/tmp/holes.pdf"
Drawing(1200, 1200, fname)

origin()
background("black")

pagetiles = PageTiler(1200, 1200, 17, 19, margin=50)
for (x, y, n) in pagetiles
  randomhue()
  rad = pagetiles.tilewidth
  ngon(x, y, rad/2, rand(5:12), 0, :path)
  newsubpath()
  ngon(x, y, rand(1:rad/3), rand(5:12), 0, :path, reversepath=true)
  fillstroke()
end

finish()
println("finished test: output in $(fname)")
