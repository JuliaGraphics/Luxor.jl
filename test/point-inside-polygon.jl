#!/Applications/Julia-0.3.9.app/Contents/Resources/julia/bin/julia

# test point inside polygon
# all the random points should be inside the polygons

using Luxor

function ngon_poly(x, y, radius, sides::Int64, orientation=0, action=:nothing; close=true)
    [Point(x+cos(orientation + n * (2 * pi)/sides) * radius,
           y+sin(orientation + n * (2 * pi)/sides) * radius) for n in 1:sides]
end

function bounding_b(x, y, o)
    return [Point(x-o, y-o), Point(x-o, y+o), Point(x+o, y+o), Point(x+o, y-o)]
end

Drawing(1200, 1200, "/tmp/test.pdf")

origin()

background(Color.color("grey20"))

polys = [ngon_poly(x, y, 60, 5, pi/2) for x in -500:150:500, y in -500:150:500]

for pol in polys
    randomhue()
    poly(pol, :fill)
end

# test whether random points are inside any of the polygons
for i in 1:5000
    pt = randompoint(-600, -600, 600, 600)
    for pol in polys
        bp = bounding_b(pt.x, pt.y, 5)
        # check that all four corners of bounding box are inside polygon
        # slow but...
        if isinside(bp[1], pol) && isinside(bp[2], pol) && isinside(bp[3], pol) && isinside(bp[4], pol)
            randomhue()
            circle(pt.x, pt.y, 5, :fill)
        end
    end
end

finish()

preview()
