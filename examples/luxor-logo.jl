#!/usr/bin/env julia

using Luxor, Colors, ColorSchemes

width = 225  # pts
height = 225 # pts
Drawing(width, height, "/tmp/logo.pdf")

function spiral(colscheme)
  circle(0, 0, 90, :clip)
  for theta in pi/2 - pi/8:pi/8: (19 * pi)/8
    sethue(colorscheme(colscheme, rescale(theta, pi/2, (19 * pi)/8, 0, 1)))
    gsave()
    rotate(theta)
    move(5,0)
    curve(Point(40, 40), Point(50, -40), Point(80, 30))
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
colschememirror = vcat(colscheme, reverse(colscheme))
spiral(colschememirror)
finish()
preview()
