#!/usr/bin/env julia

using Luxor, Colors

function test_pie(fname)
  pagewidth, pageheight = 1200, 1400
  Drawing(pagewidth, pageheight, fname)
  origin() # move 0/0 to center
  background("ivory")
  setopacity(0.8)
  setline(0.4)

  pagetiles = PageTiler(pagewidth, pageheight, 4, 5, margin=50)
  for (xpos, ypos, n) in pagetiles
    randomhue()
    fromA, toA = rand() * 2pi, rand() * 2pi
    fromA_str, toA_str = string(convert(Int, round(rad2deg(fromA), 0))),
                         string(convert(Int, round(rad2deg(toA), 0)))
    pie(xpos, ypos, 60, fromA, toA, :fill)
    sethue("black")
    text(string(fromA_str, "°/", toA_str, "°"), xpos, ypos)
  end
  finish()
  println("pie-test saved in $(fname)")
end

fname = "/tmp/pie-test1.pdf"
test_pie(fname)
