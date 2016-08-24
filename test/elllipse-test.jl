#!/usr/bin/env julia

using Luxor, Colors


function test_ellipse(fname)
  Drawing(1200, 1400, fname)
  origin() # move 0/0 to center
  background("ivory")
  setopacity(0.5)
  setline(0.3)
  for x in -500:100:500
    for y in -500:100:500
      randomhue()
      ellipse(x, y, rand(0:100), rand(0:100), :strokepreserve)
      clip()
      for i in 1:10
        ellipse(Point(x, y), rand(0:120), rand(0:120), :fill)
        randomhue()
        ellipse(x, y, rand(0:120), rand(0:120), :stroke)
      end
      fill()
      sethue("black")
      ellipse(x, y, 5, 5, :fill)
      clipreset()
    end
  end
  finish()
  println("ellipse-test saved in $(fname)")
end

fname = "/tmp/ellipse-test1.pdf"
test_ellipse(fname)
