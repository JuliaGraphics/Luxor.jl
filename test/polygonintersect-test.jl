using Luxor, Test, Random
Random.seed!(42)

function polygon_intersection_test(fname)
    Drawing(2000, 2000, fname)
    origin()
    background("white")
    sethue("magenta")
    setline(.2)
    fontsize(4)
    tiles = Tiler(2000, 2000, 5, 5)
    for (pos, n) in tiles
        @layer begin
            randomhue()
            translate(pos)
            setline(1)
            p1 = randompointarray(BoundingBox(box(O, tiles.tilewidth, tiles.tileheight, vertices=true))..., 3)
            p2 = randompointarray(BoundingBox(box(O, tiles.tilewidth, tiles.tileheight, vertices=true))..., 3)

            sethue("grey80")
            poly(p1, close=true, :stroke)
            poly(p2, close=true, :stroke)

            sethue("red")
            prettypoly(p1, close=false, :stroke, vertexlabels = (n, l) -> (text(string(n))))

            sethue("blue")
            prettypoly(p2, close=false, :stroke, vertexlabels = (n, l) -> (text(string(n))))

            pint = polyintersect(p1, p2)
            sethue("purple")
            setopacity(0.5)
            circle.(pint, 6, :fill)


            pint = polyintersect(p1, p2, closed=false)
            sethue("blue")
            setopacity(0.8)
            circle.(pint, 10, :stroke)
        end
    end
    @test finish() == true
end

fname = "polygon_intersection_test.png"
polygon_intersection_test(fname)
println("...finished test: output in $(fname)")
