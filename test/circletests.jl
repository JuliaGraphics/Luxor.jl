#!/usr/bin/env julia

using Luxor

using Base.Test



function testareaintersection()
    c1 = (O, 150)
    c2 = (O + (100, 0), 150)
    cia = intersection2circles(c1..., c2...)
    @test isapprox(cia, 41251.0, atol=0.1)
end

function test_circles(fname)
    pagewidth, pageheight = 1200, 1400
    Drawing(pagewidth, pageheight, fname)
    origin() # move 0/0 to center
    background("ivory")
    setopacity(0.8)
    setline(0.4)
    fontsize(2)
    gsave()
    translate(0, -pageheight/2)
    pagetiles = Tiler(pagewidth, pageheight, 20, 20, margin=50)
    rad = 40
    for (pos, n) in pagetiles
        diameter = rand(10:50)
        secondpos = Point(pos.x + diameter, pos.y)
        sethue("black")
        circle(pos, 1, :fill)
        circle(secondpos, 1, :fill)
        randomhue()
        circle(pos, secondpos, :fill)
    end
    grestore()

    gsave()
    translate(0, pageheight/2)
    pagetiles = Tiler(pagewidth, pageheight, 20, 20, margin=50)
    rad = 40
    for (p1, n) in pagetiles
        p2, p3 = Point(p1.x + rand(-15:15), p1.y + rand(-15:15)), Point(p1.x + rand(-15:15), p1.y + rand(-15:15))
        cpoint, rad = center3pts(p1, p2, p3) # returns (0/0, 0) if points are collinear
        randomcolor()
        if rad > 0
            circle(cpoint, rad, :stroke)
            sethue("black")
            circle(p1, 1, :fill)
            circle(p2,  1, :fill)
            circle(p3,  1, :fill)
            p4 = getnearestpointonline(p1, p2, cpoint)
            line(p1, p2, :stroke)
            line(cpoint, p4, :stroke)
            text(string(round(pointlinedistance(cpoint, p1, p2), 1)), cpoint)
        end
        setopacity(0.8)
    end
    grestore()

    @test finish() == true
    println("...finished circletest, saved in $(fname)")
end

testareaintersection()

fname = "circle-test.pdf"

test_circles(fname)
