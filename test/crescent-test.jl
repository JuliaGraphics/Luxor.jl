using Luxor, Test

function crescent_tests(fname)
    Drawing(800, 800, fname)
    origin()
    background("midnightblue")

    tiles = Tiler(800, 800, 6, 6)
    for (pos, n) in tiles
        pts = crescent(pos, rescale(n, 36, 1, -tiles.tilewidth/2, tiles.tilewidth/2), tiles.tilewidth/2, vertices=true)
        sethue("antiquewhite")
        poly(pts, :fill)
        sethue("purple")
        crescent(pos, 15 , pos + (20, 0), 20, :stroke)
    end

    # test for null crescent, no intersections
    pts = crescent(O, 10, O, 10, vertices=true)
    @test pts == nothing
    @test finish() == true
    println("...finished test: output in $(fname)")
end

crescent_tests("crescent-tests.svg")
