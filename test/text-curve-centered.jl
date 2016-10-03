#!/usr/bin/env julia

using Luxor # hide
Drawing(400, 350, "/tmp/figures-text-curve-centered.png") # hide
origin() # hide
background("ivory") # hide
rotate(pi/8)
fontsize(24)
fontface("Georgia")
sethue("gray20")
setline(3)

circle(O, 130, :stroke)
circle(O, 135, :stroke)
circle(O, 125, :fill)
sethue("gray85")
circle(O, 85, :fill)

textcurvecentered("•LUXOR•", (3pi)/2, 100, O, clockwise=true, baselineshift = -4)
textcurvecentered("•VECTOR  GRAPHICS•", pi/2, 100, O, clockwise=false, letter_spacing=2, baselineshift = -15)

sethue("gray50")
map(pt -> star(pt, 40, 3, 0.5, -pi/2, :fill), ngon(O, 40, 3, 0, vertices=true))

sethue("gray95")
circle(O.x + 30, O.y - 55, 15, :fill)

sethue("ivory")
setline(0.1)
setdash("dotdotdashed")
for i in 1:500
    line(randompoint(Point(-200, -350), Point(200, 350)),
         randompoint(Point(-200, -350), Point(200, 350)),
         :stroke)
end
finish()
