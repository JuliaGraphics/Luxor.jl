#!/usr/bin/env julia

# test polygon simplification

using Luxor

if VERSION >= v"0.5.0-dev+7720"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

function circles(points)
    gsave()
    sethue(1.0,0,0)
    for p in points
        circle(p.x, p.y, .4, :fill) # show vertex locations
    end
    grestore()
end

function sinecurves()
    gsave()
    translate(100, 100)
    setline(0.25)
    sethue(0,0,0)
    x_vals = collect(0:pi/180: 20pi)
    # generate array of Points
    plist = [Point(d * 2pi , -sin(d) * cos(12 * d) * 8 * sin(d/10)) for d in x_vals]
    poly(plist, :stroke) # draw original
    circles(plist)
    text("original " * string(length(plist)) * " vertices" , 0, -15)
    for detail in [0.01, 0.05, 0.1, 0.2, 0.5, 0.75, 1.0, 2.0]
        translate(0, 50)
        simplified = simplify(plist, detail)
        poly(simplified, :stroke)
        circles(simplified)
        text("detail  $(detail), " * string(length(simplified)) * " vertices" , 0, -15)
    end
    grestore()
end

function test(pagewidth, pageheight)
    gsave()
    translate(100, pageheight/2)
    setline(0.25)
    sethue(0,0,0)
    x_vals = collect(0:pi/100: 4pi)
    polyline = [Point(d * 20pi, 5 * -sin(d) * cos(12 * d) * 8 * sin(d/10)) for d in x_vals]
    poly(polyline, :stroke)
    circles(polyline)
    text("original " * string(length(polyline)) * " vertices" , 0, -30)
    for detail in [0.01, 0.05, 0.075, 0.1, 0.2, 0.5, 0.75, 1.0, 2.0]
        translate(0, 60)
        polysimple = simplify(polyline, detail)
        poly(polysimple, :stroke)
        circles(polysimple)
        text(" detail ($detail), " * string(length(polysimple)) * " vertices" , 0, -30)
    end
    grestore()
end

function simplify_poly(fname)
    pagewidth  = 1190.0 # points
    pageheight = 1684.0 # points
    Drawing(pagewidth, pageheight, fname)
    sinecurves()
    test(pagewidth, pageheight)
    @test finish() == true
    println("...finished test: output in $(fname)")
end

simplify_poly("simplify-poly.pdf")
