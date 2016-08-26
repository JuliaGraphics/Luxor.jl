#!/usr/bin/env julia

using Luxor, Colors

"""
Draw a curved arc centered at `centerpos` starting at `startangle` and ending at `endangle`
with an arrowhead at the end. Angles are measured clockwise from the positive x-axis.

    arrow(centerpos::Point, radius, startangle, endangle; arrowheadlength=10, arrowheadangle=pi/8)

"""
function arrow(centerpos::Point, radius, startangle, endangle; arrowheadlength=10, arrowheadangle=pi/8)
  # length of arrowhead is sin(arrowheadangle) * arrowheadlength

  # shorten the length so that lines
  # stop before we get to the arrow
  # thus wide shafts won't stick out through the tip of the arrow.

  startpoint = Point(radius * cos(startangle), radius * sin(startangle))
  endpoint   = Point(radius * cos(endangle), radius * sin(endangle))

  #
  arclength = radius * mod2pi(endangle - startangle)
  arrowheadlength1 = cos(arrowheadangle) * arrowheadlength

  ratio = arrowheadlength1/arclength

  newendangle = endangle - (ratio/3 * endangle)

  endpoint   = Point(radius * cos(endangle), radius * sin(endangle))

  gsave()
  translate(centerpos)
  newpath()
  move(radius * cos(startangle), radius * sin(startangle))
  arc(0, 0, radius, startangle, newendangle, :stroke)
  closepath()

  # well that's the simple bit, now to draw an arrowhead
  # In this case (x,y) will be the center, and (sx,sy) will be
  # the end point on the arc. The atan2 returns the angle of the line tangent to the arc at (sx,sy).
  # draw the arrowhead
  shaftangle = mod2pi(-pi/2 + atan2(0 - endpoint.y, 0 - endpoint.x))
  text(string(convert(Int, round(rad2deg(shaftangle)))), endpoint.x, endpoint.y)
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
  pagewidth, pageheight = 1200, 1400
  Drawing(pagewidth, pageheight, fname)
  origin() # move 0/0 to center
  background("ivory")
  setopacity(0.8)
  setline(1)

  pagetiles = PageTiler(pagewidth, pageheight, 2, 2, margin=50)
  for (xpos, ypos, n) in pagetiles
    sethue("black")
    for a in 0:pi/6:2pi-pi/6
      randomhue()
      s = rand(0:pi/12:2pi)
      arrow(Point(xpos, ypos), rand(20:200), s, s + rand(pi/12:pi/12:pi))
    end
  end

  finish()
  println("arrows-test saved in $(fname)")
  preview()
end

fname = "/tmp/arrows-test2.pdf"
test_arrows(fname)
