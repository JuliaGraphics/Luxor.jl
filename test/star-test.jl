#!/usr/bin/env julia

using Luxor, Colors
width, height = 2000, 2000

fname = "/tmp/star.pdf"

Drawing(width, height, fname)

origin()

background("grey10")

setopacity(0.85)

setline(0.4)

for i in 1:5
    randomhue()
    star(
        rand(-1000:1000),  # xcenter
        rand(-1000:1000),  # ycenter
        rand(20:30),       # outer radius
        rand(4:10),        # number of points
        rand() * 2,        # ratio of inner to outer
        2pi * rand(),      # orientation
        :fillstroke)
end

# stars with star-shaped holes in

for i in 1:50
    randomhue()
    x = rand(-1000:1000)
    y = rand(-1000:1000)
    # outer path
    star(
        x,                 # xcenter
        y,                 # ycenter
        100,               # outer radius
        rand(4:8),         # number of points
        rand(),            # ratio of inner to outer
        2pi * rand(),      # orientation
        :path)

    newsubpath()

    # inner path
    star(
        x,                 # xcenter
        y,                 # ycenter
        50,                # outer radius
        rand(3:5),         # number of points
        rand(),            # ratio of inner to outer
        2pi * rand(),      # orientation
        :path,
        reversepath=true)

    fillstroke()

end

finish()
println("finished test: output in $(fname)")
