#!/usr/bin/env julia

using Luxor

CAIRO_PATH_MOVE_TO = 0
CAIRO_PATH_LINE_TO = 1
CAIRO_PATH_CURVE_TO = 2
CAIRO_PATH_CLOSE_PATH = 3

using Test

using Random
Random.seed!(42)

function get_path(str)
    sethue("blue")
    setopacity(.7)
    setline(0.5)
    p = textpath(str)
    o = getpath()
    strokepath()
    sethue("red")
    x, y = 0, 0
    for e in o
        if e.element_type == CAIRO_PATH_MOVE_TO
            (x, y) = e.points
            move(x, y)
        elseif e.element_type == CAIRO_PATH_LINE_TO
            (x, y) = e.points
            # straight lines
            line(x, y)
            strokepath()
            circle(x, y, 1, :stroke)
        elseif e.element_type == CAIRO_PATH_CURVE_TO
            (x1, y1, x2, y2, x3, y3) = e.points
            # show bezier control lines
            circle(x1, y1, 1, :stroke)
            circle(x2, y2, 1, :stroke)
            circle(x3, y3, 1, :stroke)
            move(x, y)
            # Use point interface, to make sure that is also tested
            curve(Point(x1, y1), Point(x2, y2), Point(x3, y3))
            strokepath()
            (x, y) = (x3, y3) # update current point
        elseif e.element_type == CAIRO_PATH_CLOSE_PATH
            closepath()
        else
            error("unknown CairoPathEntry " * repr(e.element_type))
            error("unknown CairoPathEntry " * repr(e.points))
        end
    end
end

function get_path_test(fname)
    Drawing(500, 500, fname)
    origin()
    @layer begin
        fontsize(24)
        fontface("Times-Italic")
        setline(0.5)
        translate(-100, -100)
        for theta in range(0, length=20, stop=2π)
            @layer begin
                rotate(theta)
                translate(30, 0)
                sethue("red")
                textoutlines("Luxor", O, :fill, halign=:left, valign=:baseline)
                sethue("blue")
                textoutlines("Luxor", O, :stroke, halign=:left, valign=:baseline)
            end
        end
    end
    fontsize(80)
    get_path("Luxor")
    sethue("magenta")
    @test finish() == true
    println("...finished test: output in $(fname)")
end
get_path_test("get-path-test.pdf")
