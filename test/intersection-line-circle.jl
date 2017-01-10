#!/usr/bin/env julia

using Luxor

if VERSION >= v"0.5.0-dev+7720"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

function test_intersections(fname)
    Drawing(2000, 2000, fname)
    origin()
    sethue("black")
    setline(2)
    setopacity(0.95)

    tiles = Tiler(2000, 2000, 5, 5)

    for (pos, n) in tiles
        gsave()
        translate(pos)
        box(O, tiles.tilewidth, tiles.tileheight, :clip)
        p1 = Point(rand(-tiles.tilewidth/2:tiles.tilewidth/2), rand(-tiles.tileheight/2:tiles.tilewidth/2))
        p2 = Point(rand(-tiles.tilewidth/2:tiles.tilewidth/2), rand(-tiles.tileheight/2:tiles.tilewidth/2))
        p3 = Point(rand(-tiles.tilewidth/2:tiles.tilewidth/2), rand(-tiles.tileheight/2:tiles.tilewidth/2))
        map(pt -> circle(pt, 2, :fill), [p1, p2, p3])

        gsave()
        randomhue()
        rad = rand(20:tiles.tilewidth/3)
        circle(p2, rad, :fill)
        sethue("black")
        line(p1, p3, :stroke)

        sethue("green")
        setdash("dot")
        setline(0.5)
        line(between(p1, p3, -5), between(p1, p3, 5), :stroke)
        grestore()

        sethue("red")
        n, int1, int2 = intersection_line_circle(p1, p3, p2, rad)
        if n == 1
            circle(int1, 10, :fill)
        elseif n == 2
            circle(int1, 10, :fill)
            circle(int2, 10, :fill)
        end
        sethue("black")
        text("$n intersection(s)")
        box(O, tiles.tilewidth, tiles.tileheight, :stroke)
        grestore()
    end
    l1 = Luxor.Point(-100.0,-100.0)
    l2 = Luxor.Point(300.0,200.0)
    cpoint = Point(0, 0)
    @test intersection_line_circle(l1, l2, cpoint, 15)[1] == 0
    @test intersection_line_circle(l1, l2, cpoint, 20)[1] == 1
    @test intersection_line_circle(l1, l2, cpoint, 25)[1] == 2
    @test finish() == true
end

test_intersections("intersection_line_circle_test.pdf")
println("...finished test: output in $(fname)")
