#!/usr/bin/env julia

using Luxor, Colors

fname = "/tmp/sector-test.pdf"
Drawing(1500, 1500, fname) # points/pixels, 2000 points is 70.56cm × 70.56cm

setline(1)
setopacity(0.8)
origin()
background("black")

for inner in 0:20:600
    for a in 0:pi/12:2pi
        randomhue()
        sector(inner, inner + 20, a, a + pi/12, :fill)
        sethue("black")
        sector(inner, inner + 20, a, a + pi/12, :stroke)
    end
end

finish()
println("finished test: output in $(fname)")
