#!/usr/bin/env julia

using Luxor

function arrow_test(fname)
  pagewidth, pageheight = 2000, 2000
  Drawing(pagewidth, pageheight, fname)
  origin() # move 0/0 to center
  background("ivory")
  setopacity(0.8)
  setline(2)
  pagetiles = Tiler(pagewidth, pageheight, 40, 8, margin=50)
  for (pos, n) in pagetiles
    setlinecap()
    setlinejoin()
    randomhue()
    gsave()
    arrow(pos, Point(pos.x + 200, pos.y), linewidth=rand(1:20), arrowheadlength=rand(1:30), arrowheadangle=rand(pi/20:pi/12:pi/3))
    # same length as a non-arrow line?
    line(Point(pos.x, pos.y+10), Point(pos.x + 200, pos.y+10), :stroke)
    grestore()
  end
  finish()
  println("arrow-line-test saved in $(fname)")
end

srand(42)
fname = "/tmp/arrow-line-test.pdf"
arrow_test(fname)
