#!/usr/bin/env julia

using Luxor, Test, Colors

function noisetest(fname)
    Drawing(800, 800, fname)
    background("skyblue")
    origin()

    n1 = Noise()
    @test noise(n1, 42, 42) == 0.637142847175

    n2 = Noise(seed=12)
    @test noise(n2, 42, 42) == 0.40644951822500003

    n3 = Noise(initnoise())
    @test length(n3.table) == 256

    noise1 = Noise(seed=2)
    tiles = Tiler(800, 800, 150, 150)
    for k in 1:2:10
        for (pos, n) in tiles
            f, d = .01, k
            ns = noise(noise1, pos.x, pos.y, frequency=f, depth=d)
            setcolor(ns, ns, 1, ns)
            box(pos, tiles.tilewidth, tiles.tileheight, :fill)
        end
    end
    @test finish() == true
end

fname = "noise-test.png"
noisetest(fname)
println("...finished noise test: output in $(fname)")
