#!/usr/bin/env julia

using Luxor, Colors

function test_arrows(fname)
  pagewidth, pageheight = 2000, 2000
  Drawing(pagewidth, pageheight, fname)
  origin() # move 0/0 to center
  background("ivory")
  setopacity(0.8)
  setline(2)

  pagetiles = Tiler(pagewidth, pageheight, 4, 4, margin=50)
  for (pos, n) in pagetiles
    sethue("black")
    for a in 50:10:pagetiles.tilewidth/2
      randomhue()
      s = rand(0:pi/12:2pi)
      p = rand(0:pi/12:2pi)
      arrow(pos, a, s, p)
    end
  end

  finish()
  println("arrows-test saved in $(fname)")
  preview()
end

fname = "/tmp/arrows-test2.pdf"
test_arrows(fname)
