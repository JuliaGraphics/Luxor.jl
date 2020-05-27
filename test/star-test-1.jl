#!/usr/bin/env julia

using Luxor

using Test

using Random
Random.seed!(42)

w, h = 600, 600

fname = "stars.png"
Drawing(w, h, fname)
origin()
cols = [RGB(rand(3)...) for i in 1:50]
background("grey20")
x = -w/2
for y in 100 * randn(h, 1)
    setcolor(cols[rand(1:end)])
    # star(x::Real, y::Real, radius::Real, npoints::Int=5, ratio::Real=0.5, orientation=0, action=:none; vertices = false, reversepath=false)
    star(x, y, 10, rand(4:7), rand(3:7)/10, 0, :fill)
    global x += 2
end
@test finish() == true
println("...finished test: output in $(fname)")
