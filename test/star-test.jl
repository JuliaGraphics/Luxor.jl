#!/usr/bin/env julia

using Luxor

using Test

function star_test_1(fname)
    width, height = 2000, 2000
    Drawing(width, height, fname)
    origin()
    background("grey10")
    setopacity(0.85)
    setline(0.4)
    # stars with star-shaped holes in
    pagetiles = Tiler(width, height, 4, 5, margin=50)
    for (pos, n) in pagetiles
        randomhue()
        # outer path
        star(
            pos.x,                    # xcenter
            pos.y,                    # ycenter
            pagetiles.tilewidth/2,  # outer radius
            rand(4:8),            # number of points
            rand(),               # ratio of inner to outer
            2pi * rand(),         # orientation
            :path)
        newsubpath()
        # inner path
        star(
            pos.x,                    # xcenter
            pos.y,                    # ycenter
            pagetiles.tilewidth/2,  # outer radius
            rand(3:5),            # number of points
            rand(),               # ratio of inner to outer
            2pi * rand(),         # orientation
            :path,
            reversepath=true)
        fillstroke()
    end
    @test finish() == true
end

fname = "star.pdf"
star_test_1(fname)
println("...finished test: output in $(fname)")
