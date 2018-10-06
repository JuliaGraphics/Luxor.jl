#!/usr/bin/env julia

using Luxor

using Random
Random.seed!(42)

using Test


function multitest(w, h)
    tiles = Tiler(w, h, 5, 5)
    setopacity(0.95)
    for (pos, n) in tiles
        gsave()
        translate(pos)
        bandthickness = rand(10:tiles.tileheight/4)
        ang = rand(pi/12:pi/12:pi/2)
        for l in 10:bandthickness:tiles.tileheight/2 - bandthickness/2
            for a in 0:ang:2pi
                randomhue()
                if n % 3 == 0
                    sector(l, l + bandthickness/2, a, a + pi/8, 5, :stroke)
                else
                    sector(l, l + bandthickness/2, a, a + pi/8, 5, :fill)
                end
            end
        end
        text("thickness $bandthickness | angle $(rad2deg(ang))", O)
        grestore()
    end
end

function multitest1(w, h)
    tiles = Tiler(w, h, 5, 5)
    setopacity(0.5)
    for (pos, n) in tiles
        gsave()
        translate(pos)
        cornerradius = rand(5:14)
        endangle = deg2rad(45/n)
        sector(60, 90, 0, endangle, cornerradius, :fillstroke)
        text("corner $cornerradius angle $(rad2deg(endangle))")
        grestore()
    end
end

function run_sectorround_test(fname)
    Drawing(2000, 2000, fname)
    origin()
    tiles = Tiler(2000, 2000, 2, 1)
    gsave()
    translate(tiles[1][1])
    multitest(2000, 1000)
    grestore()
    gsave()
    translate(tiles[2][1])
    multitest1(2000, 1000)
    grestore()
    @test finish() == true
    println("...finished test: output in $(fname)")
end

run_sectorround_test("sector-rounded.pdf")
