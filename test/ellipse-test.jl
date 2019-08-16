#!/usr/bin/env julia

using Luxor

using Test

using Random
Random.seed!(42)

function test_ellipse(fname)
    pagewidth, pageheight = 1200, 1400
    Drawing(pagewidth, pageheight, fname)
    origin() # move 0/0 to center
    background("ivory")
    setopacity(0.5)
    setline(0.3)

    @test_throws ErrorException Partition(0, pageheight, 200, 200)
    @test_throws ErrorException Partition(pagewidth, 0, 200, 200)

    pagetiles = Partition(pagewidth, pageheight, 200, 200)
    for (pos, n) in pagetiles
        randomhue()
        ellipse(pos, rand(50:pagetiles.tilewidth), rand(50:pagetiles.tileheight), :strokepreserve)
        clip()
        for i in 1:10
            ellipse(pos, rand(50:pagetiles.tilewidth), rand(50:pagetiles.tileheight), :fill)
            randomhue()
            ellipse(pos, Point(pos.x + rand(50:pagetiles.tilewidth), pos.y), rand(50:pagetiles.tileheight), :stroke)
        end
        setline(1)
        sethue("black")
        fillstroke()
        ellipse(pos, 5, 5, :fill)
        clipreset()
        # test three point version
        circle.((pos - (50, 0), pos + (50, 0), pos + (0, 2n)), 4, :fill)
        ellipse(pos - (50, 0), pos + (50, 0), pos + (0, 2n), :stroke)
    end
    @test finish() == true
    end

fname = "ellipse-test1.pdf"
test_ellipse(fname)
println("...finished test: output in $(fname)")
