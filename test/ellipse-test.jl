#!/usr/bin/env julia

using Luxor

using Base.Test



function test_ellipse(fname)
  pagewidth, pageheight = 1200, 1400
  Drawing(pagewidth, pageheight, fname)
  origin() # move 0/0 to center
  background("ivory")
  setopacity(0.5)
  setline(0.3)

  pagetiles = Partition(pagewidth, pageheight, 200, 200)
  for (pos, n) in pagetiles
    randomhue()
    ellipse(pos, rand(50:pagetiles.tilewidth), rand(50:pagetiles.tileheight), :strokepreserve)
    clip()
    for i in 1:10
      ellipse(pos, rand(50:pagetiles.tilewidth), rand(50:pagetiles.tileheight), :fill)
      randomhue()
      ellipse(pos, Point(pos.x + rand(50:pagetiles.tilewidth), pos.y), rand(50:pagetiles.tileheight), :stroke)
    end
    setline(5)
    sethue("black")
    fillstroke()
    ellipse(pos, 5, 5, :fill)
    clipreset()
  end
  @test finish() == true
end

fname = "ellipse-test1.pdf"
test_ellipse(fname)
println("...finished test: output in $(fname)")
