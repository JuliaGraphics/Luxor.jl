#!/usr/bin/env julia

using Luxor, Colors, ColorSchemes

width = 300  # pts
height = 300 # pts
Drawing(width, height, "/tmp/luxor-logo.png")

function spiral(colscheme)
  circle(0, 0, 90, :clip)
  for theta in 0:pi/6:2pi
    sethue(colorscheme(colscheme, rescale(theta, 0, 2pi, 0, 1)))
    gsave()
    rotate(theta)
    move(5,0)
    curve(Point(60, 70), Point(80, -70), Point(120, 70))
    closepath()
    fill()
    grestore()
  end
  clipreset()
end

origin()
background("white")
scale(1.3, 1.3)
colscheme = loadcolorscheme("solarcolors")
spiral(colscheme)
finish()
preview()
