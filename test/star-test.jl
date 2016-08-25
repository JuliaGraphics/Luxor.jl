#!/usr/bin/env julia

using Luxor, Colors
width, height = 2000, 2000
fname = "/tmp/star.pdf"
Drawing(width, height, fname)
origin()
background("grey10")
setopacity(0.85)
setline(0.4)

# stars with star-shaped holes in
pagetiles = PageTiler(width, height, 4, 5, margin=50)
for (x, y, n) in pagetiles
    randomhue()
    # outer path
    star(
        x,                    # xcenter
        y,                    # ycenter
        pagetiles.tilewidth/2,  # outer radius
        rand(4:8),            # number of points
        rand(),               # ratio of inner to outer
        2pi * rand(),         # orientation
        :path)
    newsubpath()
    # inner path
    star(
        x,                    # xcenter
        y,                    # ycenter
        pagetiles.tilewidth/2,  # outer radius
        rand(3:5),            # number of points
        rand(),               # ratio of inner to outer
        2pi * rand(),         # orientation
        :path,
        reversepath=true)

    fillstroke()
end

finish()
println("finished test: output in $(fname)")
