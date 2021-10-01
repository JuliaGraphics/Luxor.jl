#!/usr/bin/env julia

using Luxor, Test, Random

Random.seed!(42)

w, h = 600, 600

fname = "polycross-test.png"
Drawing(w, h, fname)
background("white")
origin()
setline(0.5)
for i in 100:-1:1
    rotate(0.01)
    polycross(O, 250, 4, i/100, 0, :stroke)
end

@test finish() == true
println("...finished test: output in $(fname)")
