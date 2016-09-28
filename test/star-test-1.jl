#!/usr/bin/env julia

using Luxor
w, h = 600, 600

fname = "/tmp/stars.png"
Drawing(w, h, fname)
origin()
cols = [RGB(rand(3)...) for i in 1:50]
background("grey20")
x = -w/2
for y in 100 * randn(h, 1)
    setcolor(cols[rand(1:end)])
    # star(x::Real, y::Real, radius::Real, npoints::Int64=5, ratio::Real=0.5, orientation=0, action=:nothing; vertices = false, reversepath=false)
    star(x, y, 10, rand(4:7), rand(3:7)/10, 0, :fill)
    x += 2
end
finish()
println("finished test: output in $(fname)")
