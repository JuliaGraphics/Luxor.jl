#!/usr/bin/env julia

using Luxor, Colors
width, height = 2000, 2000
fname = "/tmp/subpath-clip-image.pdf"
Drawing(width, height, fname)

origin()

background("ivory")

sethue("black")
setline(15)

image = readpng("../examples/sector-test.png")
w = image.width
h = image.height

# clip to a circle
circle(0, 0, 500, :clip)
placeimage(image, -w/2, -h/2, .1)
clipreset()

# all these graphics will make the clipping mask:

b = false
for i in 3:15
    randomhue()
    poly(ngonv(0, 0, 50 + (i * 35), i, pi/2), :path, reversepath=b)
    if i < 15
        newsubpath()
    end
    b  = !b
end

# clip them
clippreserve()

# draw image 'through' clipping mask
placeimage(image, -w/2, -h/2)

clipreset()

finish()
println("finished test: output in $(fname)")
