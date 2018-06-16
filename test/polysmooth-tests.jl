#!/usr/bin/env julia -

using Luxor

using Test

function star_test(fname)
    Drawing(1600, 1600, fname)
    origin()
    background("white")
    setopacity(0.5)
    sethue("grey40")
    fontsize(4)
    setline(0.5)
    tiles = Tiler(1600, 1600, 10, 10, margin=50)
    for (pos, n) in tiles
           randomsides = rand(3:8)
           randomratio = rand(2:8)/10
           randomsmoothing = rand(5:20)
           p = star(pos, tiles.tilewidth/2 - 10, randomsides, randomratio, 0, vertices=true)
           prettypoly(p, close=true, :stroke)
           polysmooth(p, randomsmoothing, :fill, debug=true)
     end
    @test finish() == true
    println("...finished test: output in $(fname)")
end

function random_test(fname)
    Drawing(1600, 1600, fname)
    origin()
    background("white")
    setopacity(0.5)
    sethue("black")
    fontsize(4)
    setline(0.25)
    tiles = Tiler(1600, 1600, 5, 5, margin=50)
    for (pos, n) in tiles
       randomsides = rand(3:8)
       randomratio = 0.5 * rand()
       randomsmoothradius = rand(5:20)
       p = randompointarray(pos.x - tiles.tilewidth/2 - 10, pos.y - tiles.tilewidth/2, pos.x + tiles.tilewidth/2, pos.y + tiles.tilewidth/2, 10)
       p = polysortbydistance(p, pos)
       p = simplify(p, 5)
       sethue("red")
       prettypoly(p, close=true, :stroke)
       randomhue()
       polysmooth(p, randomsmoothradius, :fill, debug=true)
       sethue("red")
    end
    @test finish() == true
    println("...finished test: output in $(fname)")
end

star_test("polysmooth-stars.pdf")
random_test("polysmooth-random.pdf")
