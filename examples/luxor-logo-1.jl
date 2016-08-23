#!/usr/bin/env julia

using Luxor, Colors, ColorSchemes

width = 400  # pts
height = 400 # pts
Drawing(width, height, "/tmp/luxor-logo.pdf")

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
colscheme = loadcolorscheme("solarcolors")
spiral(colscheme)
fontsize(40)
sethue("black")
fontface("Elephant-Regular")
textcentred("Luxor", 0, 130)
finish()
preview()
