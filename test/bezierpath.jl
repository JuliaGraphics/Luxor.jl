#!/usr/bin/env julia

using Luxor

if VERSION >= v"0.5.0-dev+7720"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

function bezierpathtest(fname)
    srand(3)
    currentwidth = 1200
    currentheight = 1200
    Drawing(currentwidth, currentheight, fname)
    origin()
    background(setgray(0.8)...)
    tiles = Tiler(currentwidth, currentheight, 4, 4, margin=20)
    for (pos, n) in tiles
        @layer begin
            translate(pos)
            pts = randompointarray(Point(-tiles.tilewidth/2, -tiles.tilewidth/2), Point(tiles.tilewidth/2, tiles.tilewidth/2), rand(3:5))
            setopacity(0.7)
            sethue("black")
            prettypoly(pts, :stroke, close=true)
            randomhue()
            drawbezierpath(makebezierpath(pts, smoothing=rand(0:0.1:1)), :fill)
        end
    end
    @test finish() == true
end

fname = "bezierpath.png"
bezierpathtest(fname)
println("...finished test: output in $(fname)")
