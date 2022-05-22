#!/usr/bin/env julia

using Luxor

using Test

using Random
Random.seed!(42)

function boxmaptest(fname)
    Drawing(850, 850, fname)
    origin()
    background("ivory")

    # fibonacci
    tiles = boxmap([1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89], O - (400, 400), 800, 800)
    for (n, t) in enumerate(tiles)
    randomhue()

    #box(t, :fill) # box() would work, but BoundingBoxes are fun too

    bb = BoundingBox(t)
    sethue("black")
    box(bb - 2, :stroke)

    randomhue()
    box(bb - 4, :fill)

    # text labels
    sethue("white")
    # rescale text to fit better
    fontsize(boxwidth(bb) > boxheight(bb) ? boxheight(bb)/4 : boxwidth(bb)/4)
    text(string(sort([1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89], rev=true)[n]),
        midpoint(bb[1], bb[2]),
        halign=:center,
        valign=:middle)
    end

    @test finish() == true
end

fname = "boxmaptest.pdf"
boxmaptest(fname)
println("...finished test: output in $(fname)")
