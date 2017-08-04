#!/usr/bin/env julia

using Luxor

using Base.Test

function cropmarkstest(fname)
    Drawing(1300, 1300, fname)
    origin()
    background("ivory")
    sethue("grey80")
    box(O, 1200, 1200, :fill)
    tiles = Tiler(1100, 1100, 6, 6, margin=60)
    for (pos, n) in tiles
        gsave()
        translate(pos)
        randomhue()
        setopacity(rand())
        box(O, tiles.tilewidth - 25, tiles.tileheight - 25, :fill)
        cropmarks(O, tiles.tilewidth - 25, tiles.tileheight - 25)
        grestore()
    end
    cropmarks(O, 1200, 1200)
    @test finish() == true
end

fname = "cropmarkstest.pdf"
cropmarkstest(fname)
println("...finished test: output in $(fname)")
