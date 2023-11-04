#!/usr/bin/env julia

using Luxor

using Test

using Random

Random.seed!(42)

function test_bboxes_2(fname)
    pagewidth, pageheight = 800, 800
    Drawing(pagewidth, pageheight, fname)
    origin() # move 0/0 to center
    background("rebeccapurple")
    for i in 30:-0.5:2
        rotate(pi/12i^1.2)
        sethue(rescale(i, 30, 2, 0, 1), rand(), .7)
        bb = BoundingBox() * 0.7  - 5i
        circle.([
            boxtopleft(bb),
            boxtopcenter(bb),
            boxtopright(bb),
            boxmiddleleft(bb),
            boxmiddlecenter(bb),
            boxmiddleright(bb),
            boxbottomleft(bb),
            boxbottomcenter(bb),
            boxbottomright(bb)
        ], i^1.25, :fill)
    end
    @test finish() == true
    println("...finished bounding box point test, saved in $(fname)")
end

fname = "bounding-box-point-test.png"

test_bboxes_2(fname)
