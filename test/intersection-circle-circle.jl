#!/usr/bin/env

using Luxor

if VERSION >= v"0.5.0-dev+7720"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

function test_circle_intersections(fname)
    Drawing(2000, 2000, fname)
    origin()
    setopacity(0.995)
    setline(0.1)
    tiles = Tiler(2000, 2000, 5, 5)
    setmode("darken")
    for (pos, n) in tiles
            @layer begin
                translate(pos)
                circle1 = (O, rand(30:tiles.tilewidth/3))
                circle2 = (O + (rand(40:70), rand(-20:20)), rand(40:tiles.tilewidth/3))
                flag, C, D = intersectioncirclecircle(circle1[1], circle1[2], circle2[1], circle2[2])
                if flag
                    sethue("slategray3")
                    circle(circle1..., :fill)
                    sethue("orange3")
                    circle(circle2..., :fill)
                    sethue("black")
                    circle(circle1..., :stroke)
                    circle(circle2..., :stroke)
                    sethue("red")
                    circle.([C, D], 4, :fill)
                else
                    sethue("black")
                    circle.([circle1[1], circle2[1]], [circle1[2], circle2[2]], :stroke)
                end
            end
    end
    @test finish() == true
end

fname = "intersection_circle_circle_test.png"
test_circle_intersections(fname)
println("...finished test: output in $(fname)")
