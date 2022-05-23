#!/usr/bin/env julia

# testing isinside(), is point inside polygon
# all the random points are drawn only if they're inside one of the polygons

using Luxor

using Test

using Random
Random.seed!(42)

function ngon_poly(x, y, radius, sides::Int, orientation=0, action=:none; close=true)
    [Point(x+cos(orientation + n * 2pi/sides) * radius,
    y+sin(orientation + n * 2pi/sides) * radius) for n in 1:sides]
end

function bounding_b(x, y, o)
    return [Point(x-o, y-o), Point(x-o, y+o), Point(x+o, y+o), Point(x+o, y-o)]
end

function point_inside_polygon(fname)
    Drawing(1200, 1200, fname)
    origin()
    background("grey20")
    polys = [ngon_poly(x, y, 60, 5, pi/2) for x in -500:150:500, y in -500:150:500]
    for pol in polys
        randomhue()
        poly(pol, :fill)
    end
    # test whether random points are inside any of the polygons
    for i in 1:5000
        pt = randompoint(-600, -600, 600, 600)
        for pol in polys
            randomsize = rand(4:12)
            bp = bounding_b(pt.x, pt.y, randomsize)
            # check that all four corners of a 5x5 bounding box are inside this polygon
            # slow but this is Julia so it's still quick...
            if isinside(bp[1], pol) && isinside(bp[2], pol) && isinside(bp[3], pol) && isinside(bp[4], pol)
                randomhue()
                circle(pt.x, pt.y, randomsize, :fill)
            end
        end
    end

    @test finish() == true
    println("...finished test: output in $(fname)")


preview()


end

point_inside_polygon("point-inside-polygon.png")
