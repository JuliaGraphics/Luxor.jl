#!/usr/bin/env julia

using Luxor

using Test

using Random
Random.seed!(42)

function poly_fit(fname)
    currentwidth = 2400 # pts
    currentheight = 2400 # pts
    Drawing(currentwidth, currentheight, fname)

    origin()
    background("white")

    fontsize(20)
    setopacity(0.7)
    tiles = Tiler(2400, 2400, 5, 5, margin=20)
    setline(1)
    for (pos, n) in tiles
        @layer  begin
            translate(pos)
            randomhue()
            box(O, -tiles.tilewidth, tiles.tilewidth, :fill)
            pts = [Point(x, rand(-tiles.tilewidth/3:tiles.tilewidth/3)) for x in -tiles.tileheight/2:30:tiles.tileheight/2]
            begin
                for (i, pt) in enumerate(pts)
                    sethue("red")
                    circle(pt, 6, :fill)
                    sethue("black")
                    text(string(i), pt)
                end
            end
            poly(polyfit(pts, rand(30:130)), :stroke)
        end
    end
    @test finish() == true
end

fname = "polyfit.pdf"
poly_fit(fname)
