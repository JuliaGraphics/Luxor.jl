#!/usr/bin/env julia

using Luxor, Test, Random

Random.seed!(7)

function findanddrawsometangentialcircles(c1center, c1radius, c2center, c2radius)
    for requiredradius in 1:150
        res = circletangent2circles(requiredradius, c1center, c1radius, c2center, c2radius)
        setopacity(0.5)
        if first(res) == 1
            circle(res[2], requiredradius, :stroke)
        elseif first(res) == 2
            circle(res[2], requiredradius, :stroke)
            circle(res[3], requiredradius, :stroke)
        elseif first(res) == 0
            sethue("red")
            circle(c1center, 5, :fill)
            circle(c2center, 5, :fill)
        end
    end
end

function test_circletangents(fname)
    pagewidth, pageheight = 1200, 1400
    Drawing(pagewidth, pageheight, fname)
    origin() # move 0/0 to center
    background("ivory")
    setline(0.5)
    tiles = Tiler(1200, 1400, 5, 5)
    for (pos, n) in tiles
        @layer begin
            translate(pos)
            circle1 = (O + Point(rand(-20:20), rand(-20:20)), rand(20:40))
            circle2 = (O + Point(rand(-20:20), rand(-20:20)), rand(20:40))
            sethue("black")
            setopacity(0.5)
            circle(circle1..., :fill)
            circle(circle2..., :fill)
            setopacity(1.0)
            circle(circle1..., :stroke)
            circle(circle2..., :stroke)
            sethue("purple")
            findanddrawsometangentialcircles(circle1[1], circle1[2], circle2[1], circle2[2])
        end
    end

    @test finish() == true
    println("...finished circle tangent test, saved in $(fname)")
end

fname = "circletangent-test.pdf"

test_circletangents(fname)
