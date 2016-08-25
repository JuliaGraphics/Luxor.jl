#!/usr/bin/env julia

using Luxor, Colors

function test_ellipse(fname)
  pagewidth, pageheight = 1200, 1400
  Drawing(pagewidth, pageheight, fname)
  origin() # move 0/0 to center
  background("ivory")
  setopacity(0.5)
  setline(0.3)

  pagetiles = PageTiler(pagewidth, pageheight, 4, 5, margin=50)
  for (xpos, ypos, n) in pagetiles
    randomhue()
    ellipse(xpos, ypos, rand(50:pagetiles.tilewidth), rand(50:pagetiles.tileheight), :strokepreserve)
    clip()
    for i in 1:10
      ellipse(Point(xpos, ypos), rand(50:pagetiles.tilewidth), rand(50:pagetiles.tileheight), :fill)
      randomhue()
      ellipse(xpos, ypos, rand(50:pagetiles.tilewidth), rand(50:pagetiles.tileheight), :stroke)
    end
    fill()
    sethue("black")
    ellipse(xpos, ypos, 5, 5, :fill)
    clipreset()
  end

  finish()
  println("ellipse-test saved in $(fname)")
end

fname = "/tmp/ellipse-test1.pdf"
test_ellipse(fname)
