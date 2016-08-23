#!/usr/bin/env julia

using Luxor, Colors

function get_path(str)
  p = textpath(str)
  o = getpathflat()
  sethue("grey70")
  text(str)
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
            #bezier control lines
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
    sethue("blue")
    fontface("Aachen")
    fontsize(80)
    setline(0.5)
    setopacity(.7)
    get_path("Luxor")
    finish()
    println("finished test: output in $(fname)")
end

get_path_test("/tmp/get-path-test.pdf")
