#!/usr/bin/env julia

using Luxor, Random

using Test

function test_bboxes(fname)
    pagewidth, pageheight = 1200, 1400

    Drawing(pagewidth, pageheight, fname)
    origin() # move 0/0 to center
    background("ivory")
    setline(40)
    sethue("blue")
    box(BoundingBox(), :stroke)

    sethue("red")
    box(BoundingBox() * 0.9, :stroke)

    sethue("green")
    box(BoundingBox(centered=false) * 0.9, :stroke)

    sethue("purple")
    setopacity(0.5)
    fontsize(100)
    box(BoundingBox("purple"), :fill)
    sethue("white")
    text("purple")


    # combine and intersections
    box1 = BoundingBox()/3 - (200, 200)
    box2 = BoundingBox()/4 - (300, 300)
    box3 = box1 + box2
    box4 = intersectboundingboxes(box1, box2)
    sethue("black")
    setline(2)
    box.([box1, box2, box3, box4], :stroke)

    sethue("pink")
    box(box1, :fill)

    sethue("yellow")
    box(box2, :fill)

    sethue("purple")
    box(box3, :fill)

    sethue("green")
    box(box4, :fill)

    @test isapprox(boxaspectratio(box1), 1.1666, atol = 0.01)
    @test isapprox(boxdiagonal(box1), 614.63629, atol = 0.01)

    # get vertices
    bv = box(box1, vertices=true)
    @test isapprox(bv[1].y, -433.33333, atol = 0.01)


    # contains
    for i in 1:1000
        pt = Point(rand(-1000:1000), rand(-1000:1000))
        if isinside(pt, box4)
            sethue("red")
            circle(pt, 15, :fill)
            sethue("black")
            circle(pt, 1, :fill)
        elseif isinside(pt, box2)
            sethue("white")
            circle(pt, 20, :fill)
            sethue("black")
            circle(pt, 1, :fill)
        elseif isinside(pt, box1)
            sethue("black")
            circle(pt, 5, :stroke)
        end
    end

    # poly
    s = star(O, 300, 7, 0.5, 0, vertices=true)
    box5 = BoundingBox(s)
    poly(s, :stroke, close=true)
    prettypoly(box5, :stroke, close=true, vertexlabels=(n,t) -> label(string(n)))
    @test finish() == true
    println("...finished bounding box test, saved in $(fname)")
end

srand(42)

fname = "bounding-box-test.png"

test_bboxes(fname)
