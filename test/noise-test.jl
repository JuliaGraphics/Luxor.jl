using Luxor, Test, Colors, Random

Random.seed!(42)

function noisetest(fname)
    Drawing(800, 800, fname)
    background("chartreuse4")
    origin()

    initnoise(rand(1:12))

    @test 0.0 < noise(.5) <= 1.0
    @test 0.0 < noise(0.1, 0.5) <= 1.0
    @test 0.0 < noise(0.1, 0.1, -0.1) <= 1.0
    @test 0.0 < noise(0.5, 2.0, -2.0, 0.1) <= 1.0

    freq = 0.02
    tiles = Tiler(800, 800, 150, 150)
    for k in 1:2:10
        for (pos, n) in tiles
            f, d = .01, k
            ns = noise(pos.x * freq, pos.y * freq, detail=3, persistence=.3)
            ns1 = noise(ns, detail = 3, persistence=2)
            ns2 = noise(pos.x * freq, pos.y * freq, ns, detail = 2)
            ns3 = noise(pos.x * freq, pos.y * freq, ns2)
            setopacity(ns3)
            sethue(LCHab(80ns, 100 * ns1, 360 * ns2))
            box(pos, tiles.tilewidth, tiles.tileheight, :fill)
        end
    end
    @test finish() == true
end

fname = "noise-test.png"
noisetest(fname)
println("...finished noise test: output in $(fname)")
