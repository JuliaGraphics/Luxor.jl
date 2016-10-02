#!/usr/bin/env julia

using Luxor

function test_ellipse(fname)
  pagewidth, pageheight = 1200, 1400
  Drawing(pagewidth, pageheight, fname)
  origin() # move 0/0 to center
  background("ivory")
  setopacity(0.5)
  setline(0.3)

  pagetiles = Tiler(pagewidth, pageheight, 4, 5, margin=50)
  for (pos, n) in pagetiles
    randomhue()
    ellipse(pos, rand(50:pagetiles.tilewidth), rand(50:pagetiles.tileheight), :strokepreserve)
    clip()
    for i in 1:10
      ellipse(pos, rand(50:pagetiles.tilewidth), rand(50:pagetiles.tileheight), :fill)
      randomhue()
      ellipse(pos, rand(50:pagetiles.tilewidth), rand(50:pagetiles.tileheight), :stroke)
    end
    setline(5)
    sethue("black")
    stroke()
    fill()
    ellipse(pos, 5, 5, :fill)
    clipreset()
  end

  finish()
  println("ellipse-test saved in $(fname)")
end

fname = "/tmp/ellipse-test1.pdf"
test_ellipse(fname)
