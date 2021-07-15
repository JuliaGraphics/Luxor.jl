using Luxor, Test, Random
Random.seed!(42)

function point_on_polygon_test(fname)

    Drawing(1200, 1200, fname)
    origin()
    background("grey20")
    polys = [ngon(Point(x, y), rand(20:100), rand(3:8), rand() * 2π, vertices=true) for x in -500:200:500, y in -500:200:500]
    for pol in polys
        randomhue()
        poly(pol, :fill)

        pt1 = rand(1:length(pol))
        pt2 = mod1(pt1 + 1, length(pol))

        # all these should lie on their polygons
        pt = between(pol[pt1], pol[pt2], rand())
        flag = ispointonpoly(pt, pol)
        if flag
            sethue("black")
            circle(pt, 10, :fill)
        else
            sethue("red")
            circle(pt, 20, :fill)
        end

        # move the point, then it shouldn't
        pt = pt + (0.01, 0.01)
        flag = ispointonpoly(pt, pol)
        if flag
            sethue("red")
            circle(pt, 6, :fill)
        else
            sethue("green")
            circle(pt, 20, :stroke)
        end

    end

    @test finish() == true
    println("...finished test: output in $(fname)")
end

point_on_polygon_test("point-on-polygon.png")
