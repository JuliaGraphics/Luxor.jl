#!/usr/bin/env julia

using Luxor, Colors

fname = "/tmp/holes.pdf"
Drawing(1200, 1200, fname)

origin()
background("black")

for i in 1:50
    randomhue()
    x, y = rand(-500:500, 2)
    rad = rand(50:80)
    ngon(x, y, rad, rand(5:12), 0, :path)
    newsubpath()
    ngon(x, y, rad - 30, rand(5:12), 0, :path, reversepath=true)
    fillstroke()
end

finish()
println("finished test: output in $(fname)")
