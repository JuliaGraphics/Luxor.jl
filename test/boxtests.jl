#!/usr/bin/env julia

using Luxor

using Base.Test



function test_circles(fname)
    pagewidth, pageheight = 1200, 1400

    Drawing(pagewidth, pageheight, fname)
    origin() # move 0/0 to center
    background("ivory")
    setopacity(0.5)
    gsave()
    t = Tiler(1000, 1000, 20, 20)
    for (pos, n) in t
        randomhue()
        box(pos, rand(5:50), rand(5:50), rand(5:55), :fillpreserve)
        randomhue()
        rotate(2pi * rand())
        strokepath()
        # p = pathtopoly()
        # for pl in p
        #     prettypoly(pl, :fill, () -> circle(O, 1, :fill))
        # end
    end

    grestore()

    sethue("black") # hide
    setline(4)
    box(O, 200, 150, 10, :stroke)

    for (pos, n) in t
        randomhue()

        polysmooth(box(O, 200, 150, vertices=true), 10, :stroke)

        box(pos, rand(5:50), rand(5:50), rand(5:15), :path)
        randomhue()
        strokepath()
        p = pathtopoly()
        for pl in p
            prettypoly(pl, :fill, () -> circle(O, 5, :stroke))
        end
    end

    @test finish() == true
    println("...finished boxtest, saved in $(fname)")
end

fname = "box-test.png"
test_circles(fname)
