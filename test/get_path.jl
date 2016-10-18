#!/usr/bin/env julia

using Luxor, Base.Test

function get_path(str)
    sethue("blue")
    setopacity(.7)
    setline(0.5)
    p = textpath(str)
    o = getpath()
    stroke()
    sethue("red")
    x, y = 0, 0
    for e in o
        if e.element_type == Cairo.CAIRO_PATH_MOVE_TO
            (x, y) = e.points
            move(x, y)
        elseif e.element_type == Cairo.CAIRO_PATH_LINE_TO
            (x, y) = e.points
            # straight lines
            line(x, y)
            stroke()
            circle(x, y, 1, :stroke)
        elseif e.element_type == Cairo.CAIRO_PATH_CURVE_TO
            (x1, y1, x2, y2, x3, y3) = e.points
            # show bezier control lines
            circle(x1, y1, 1, :stroke)
            circle(x2, y2, 1, :stroke)
            circle(x3, y3, 1, :stroke)
            move(x, y)
            curve(x1, y1, x2, y2, x3, y3)
            stroke()
            (x, y) = (x3, y3) # update current point
        elseif e.element_type == Cairo.CAIRO_PATH_CLOSE_PATH
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
    fontsize(80)
    get_path("Luxor")
    @test finish() == true
    println("...finished test: output in $(fname)")
end

get_path_test("get-path-test.pdf")
