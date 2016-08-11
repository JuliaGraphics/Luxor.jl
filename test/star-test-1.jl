#!/usr/bin/env julia

using Luxor, Colors
w, h = 600, 600
Drawing(w, h, "/tmp/stars.png")
origin()
cols = [RGB(rand(3)...) for i in 1:50]
background("grey20")
x = -w/2
for y in 100 * randn(h, 1)
    setcolor(cols[rand(1:end)])
    star(x, y, 10, rand(4:7), rand(3:7)/10, 0, :fill)
    x += 2
end
finish()
preview()
