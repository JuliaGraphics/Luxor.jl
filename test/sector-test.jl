#!/usr/bin/env julia

using Luxor

if VERSION >= v"0.5.0-dev+7720"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

fname = "sector-test.pdf"
Drawing(1500, 1500, fname) # points/pixels, 2000 points is 70.56cm × 70.56cm

setline(1)
setopacity(0.8)
origin()
background("black")

# normal
for inner in 0:20:600
    for a in 0:pi/12:2pi
        randomhue()
        sector(O, inner, inner + 20, a, a + pi/12, :fill) 
        sethue("black")
        sector(inner, inner + 20, a, a + pi/12, :stroke)
    end
end

# rounded
setopacity(0.75)
for i in 1:10
    gsave()
    translate(rand(-500:500), rand(-500:500))
    for inner in 90:30:210
        for a in 0:pi/12:2pi
            randomhue()
            sector(O, inner, inner + 20, a, a + pi/12, 15, :fill)
            sethue("black")
            sector(inner, inner + 20, a, a + pi/12, 10, :stroke)
        end
    end
    grestore()
end

@test finish() == true
println("...finished test: output in $(fname)")
