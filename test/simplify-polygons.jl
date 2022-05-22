#!/usr/bin/env julia

# test polygon simplification

using Luxor

using Test

using Random
Random.seed!(42)

function sinecurves()
    gsave()
    translate(100, 100)
    setline(0.25)
    sethue(0, 0, 0)
    x_vals = collect(0:pi/180: 40pi)
    # generate array of Points
    plist = [Point(d * 2pi , -sin(d) * cos(20 * d) * 8 * sin(d/10)) for d in x_vals]
    prettypoly(plist, :stroke, () -> (gsave(); randomhue(); circle(O, 0.5, :stroke); grestore()))
    text("original " * string(length(plist)) * " vertices" , 0, -15)
    for detail in [0.01, 0.05, 0.1, 0.2, 0.5, 0.75, 1.0, 2.0]
        translate(0, 50)
        simplified = simplify(plist, detail)
        prettypoly(simplified, :stroke, () -> (gsave(); randomhue(); circle(O, 0.5, :stroke); grestore()))
        text("detail  $(detail), " * string(length(simplified)) * " vertices" , 0, -15)
    end
    grestore()
end

function test(pagewidth, pageheight)
    translate(100, pageheight/2)
    g = GridRect(O, 0, 60)
    setline(0.25)
    sethue(0, 0, 0)
    x_vals = collect(0:pi/100: 4pi)
    polyline = [Point(d * 20pi, 5 * -sin(d) * cos(12 * d) * 8 * sin(d/10)) for d in x_vals]
    poly(polyline, :stroke)
    prettypoly(polyline)
    text("original " * string(length(polyline)) * " vertices" , 0, -30)
    for detail in [0.01, 0.05, 0.075, 0.1, 0.2, 0.5, 0.75, 1.0, 2.0]
        gsave()
        translate(nextgridpoint(g))
        polysimple = simplify(polyline, detail)
        prettypoly(polysimple, :stroke, () -> (gsave(); randomhue(); circle(O, 2, :stroke); grestore()))
        text(" detail ($detail), " * string(length(polysimple)) * " vertices" , 0, -20)
        grestore()
    end
end

function simplify_poly(fname)
    pagewidth  = 1190.0 # points
    pageheight = 1684.0 # points
    Drawing(pagewidth, pageheight, fname)
    sinecurves()
    test(pagewidth, pageheight)
    @test finish() == true
    println("...finished test: output in $(fname)")
end

function simplify_square()
    poly = Point[Point(-1.0, 0.0), Point(-1.0, -1.0), Point(0.0, -1.0), Point(1.0, -1.0), Point(1.0, 0.0), Point(1.0, 1.0), Point(0.0, 1.0), Point(-1.0, 1.0)]

    poly = simplify(poly, 0.01)
    @test poly == Point[Point(-1.0, 0.0), Point(-1.0, -1.0), Point(1.0, -1.0), Point(1.0, 1.0), Point(-1.0, 1.0)]
end

simplify_poly("simplify-poly.pdf")

simplify_square()
