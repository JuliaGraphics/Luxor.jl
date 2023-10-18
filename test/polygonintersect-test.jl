using Luxor, Test, Random
Random.seed!(42)

function polygon_intersection_test(fname)
    Drawing(2000, 2000, fname)
    origin()
    background("white")
    sethue("magenta")
    setline(2)
    fontsize(4)
    tiles = Tiler(2000, 2000, 5, 5)
    for (pos, n) in tiles
        @layer begin
            randomhue()
            translate(pos)
            p1 = randompointarray(BoundingBox(box(O, tiles.tilewidth, tiles.tileheight, vertices = true))..., 3)
            p2 = randompointarray(BoundingBox(box(O, tiles.tilewidth, tiles.tileheight, vertices = true))..., 3)

            sethue("grey50")
            poly(p1, close = true, :stroke)
            poly(p2, close = true, :stroke)

            pint = polyintersect(p1, p2)

            sethue("purple")
            setopacity(0.5)
            if length(pint) > 0
                for p in pint
                    prettypoly(p, :fill)
                end
            end
        end
    end
    @test finish() == true
    preview()
end

function polygon_intersection_test_2(fname)
    Drawing(2000, 2000, fname)
    origin()
    background("white")
    sethue("magenta")
    setline(4)
    setlinejoin("round")
    fontsize(4)
    tiles = Tiler(2000, 2000, 5, 5)
    for (pos, n) in tiles
        @layer begin
            translate(pos)
            p1 = star(O + (rand(-40:40), rand(-40:40)), 170, rand(3:6), rand(0.2:0.1:0.9), vertices = true)
            p2 = ngon(O + (rand(-40:40), rand(-40:40)), 120, rand(3:9), rand() * 2π, vertices = true)

            @layer begin
                setopacity(0.3)
                sethue("red")
                poly(p1, close = true, :fill)
                sethue("blue")
                poly(p2, close = true, :fill)
            end

            pint = polyintersect(p1, p2)

            sethue("black")
            for p in pint
                prettypoly(p, :stroke, close = true)
            end
        end
    end
    @test finish() == true
end

fname = "polygon_intersection_test.png"
polygon_intersection_test(fname)
println("...finished test: output in $(fname)")

fname = "polygon_intersection_test_2.png"
polygon_intersection_test_2(fname)
println("...finished test: output in $(fname)")
