#!/usr/bin/env julia

using Luxor, Colors

"""
Draw a curved arc centered at `centerpos` starting at `startangle` and ending at `endangle`
with an arrowhead at the end. Angles are measured clockwise from the positive x-axis.

    arrow(centerpos::Point, radius, startangle, endangle; arrowheadlength=10, arrowheadangle=pi/8)

"""
function arrow(centerpos::Point, radius, startangle, endangle; arrowheadlength=10, arrowheadangle=pi/8)
  # shorten the length so that lines
  # stop before we get to the arrow
  # thus wide shafts won't stick out through the tip of the arrow.
#TODO this still has numerous small errors,so the algor and magic numbers need fixing

  if startangle > endangle
      startangle, endangle = endangle, startangle
  end
  # don't bother with them if theyre too small
  if isapprox(startangle, endangle, rtol = 0.1)
    return
  end
  startpoint = Point(radius * cos(startangle), radius * sin(startangle))
  endpoint   = Point(radius * cos(endangle), radius * sin(endangle))
  arclength = radius * mod2pi(endangle - startangle)
  arrowheadlength1 = cos(arrowheadangle) * arrowheadlength

  ratio = arrowheadlength1/arclength
  newendangle = endangle - (ratio/5 * endangle) ###################################
  gsave()
  translate(centerpos)
  newpath()
  move(radius * cos(startangle), radius * sin(startangle))
  arc(0, 0, radius, startangle, newendangle, :stroke)
  closepath()

  # well that's the simple bit, now to draw an arrowhead
  # this is the angle of the end of the arc
  shaftangle = mod2pi(-pi/2 + atan2(0 - endpoint.y, 0 - endpoint.x))
  arrowheadtopsideangle = shaftangle + pi + arrowheadangle
  topx = endpoint.x + cos(arrowheadtopsideangle) * arrowheadlength
  topy = endpoint.y + sin(arrowheadtopsideangle) * arrowheadlength
  arrowheadbottomsideangle = shaftangle + pi - arrowheadangle
  botx = endpoint.x + cos(arrowheadbottomsideangle) * arrowheadlength
  boty = endpoint.y + sin(arrowheadbottomsideangle) * arrowheadlength
  poly([Point(topx,topy), Point(endpoint.x, endpoint.y), Point(botx,boty)], :fill)
  grestore()
end

function test_arrows(fname)
  pagewidth, pageheight = 2000, 2000
  Drawing(pagewidth, pageheight, fname)
  origin() # move 0/0 to center
  background("ivory")
  setopacity(0.8)
  setline(2)

  pagetiles = PageTiler(pagewidth, pageheight, 4, 4, margin=50)
  for (xpos, ypos, n) in pagetiles
    sethue("black")
    for a in 50:10:pagetiles.tilewidth/2
      randomhue()
      s = rand(0:pi/12:2pi)
      p = rand(0:pi/12:2pi)
      arrow(Point(xpos, ypos), a, s, p)
    end
  end

  finish()
  println("arrows-test saved in $(fname)")
  preview()
end

fname = "/tmp/arrows-test2.pdf"
test_arrows(fname)
