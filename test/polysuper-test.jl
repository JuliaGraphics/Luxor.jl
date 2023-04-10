using Luxor

using Test

using Random

Random.seed!(42)

params = (
    (3, 4.5, 10, 10),
    (4, 12, 15, 15),
    (7, 10, 6, 6),
    (5, 4, 4, 4),
    (5, 2, 7, 7),
    (5, 2, 13, 13),
    (4, 1, 1, 1),
    (4, 1, 7, 8),
    (6, 1, 7, 8),
    (2, 2, 2, 2),
    (1, 0.5, 0.5, 0.5),
    (2, 0.5, 0.5, 0.5),
    (5, 1, 1, 1),
    (3, 0.5, 0.5, 0.5),
    (2, 1, 1, 1),
    (7, 3, 4, 17),
    (2, 1, 4, 8),
    (6, 1, 4, 8),
    (7, 2, 8, 4),
    (4, 0.5, 0.5, 4),
    (8, 0.5, 0.5, 8),
    (16, 0.5, 0.5, 16),
    (3, 30, 15, 15),
    (4, 30, 15, 15))

function test_polysuper(fname)
    Drawing(1200, 1200, fname)
    origin()
    background("black")
    tiles = Tiler(1200, 1200, 6, 4)
    for (pos, n) in tiles
        n > length(params) && break
        @layer begin
            randomhue()
            translate(pos)
            m, n1, n2, n3 = params[n]
            radius = 100
            v = polysuper(pos, m = m, n1 = n1, n2 = n2, n3 = n3, action = :path, radius = radius, vertices = true)
            bbx = 1.5 * BoundingBox(v)
            x, y = boxdiagonal(bbx), boxdiagonal(BoundingBox(box(tiles, n)))
            scale(y / x) # scale to fit
            polysuper(m = m, n1 = n1, n2 = n2, n3 = n3, action = :path, radius = radius)
            newsubpath()
            polysuper(m = m, n1 = n1, n2 = n2, n3 = n3, action = :path, radius = radius / 2, reversepath = true)
            fillpath()
            @layer begin
                scale(x/y) # reset scale to 1:1 for text
                translate(0, -tiles.tileheight/2)
                sethue("gold")
                fontsize(12)
                text(string(params[n]), halign=:center)
            end
        end
    end
    @test finish() == true
end

fname = "test-polysuper.png"
test_polysuper(fname)
println("...finished test: output in $(fname)")
