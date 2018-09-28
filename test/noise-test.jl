#!/usr/bin/env julia

using Luxor, Test, Colors

function noisetest(fname)
    Drawing(800, 800, fname)
    background("skyblue")
    origin()

    seednoise(rand(1:12, 512))
    Luxor.initnoise()

    @test noise(0, 0, 0) == 0.5

    tiles = Tiler(800, 800, 150, 150)
    for k in 1:2:10
        for (pos, n) in tiles
            f, d = .01, k
            ns = noise(pos.x * 0.006, pos.y * 0.006, detail=3, persistence=.15)
            sethue(ns, ns, 1)
            box(pos, tiles.tilewidth, tiles.tileheight, :fill)
        end
    end
    @test finish() == true
end

fname = "noise-test.png"
noisetest(fname)
println("...finished noise test: output in $(fname)")
