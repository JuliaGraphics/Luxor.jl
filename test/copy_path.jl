#!/usr/bin/env julia

using Luxor

function draw_path(path::Array)
    # path is array of CairoPathEntry Array{CairoPathEntry,1}
    for e in path
        if e.element_type == Cairo.CAIRO_PATH_MOVE_TO
            (x, y) = e.points
            move(x,y)
        elseif e.element_type == Cairo.CAIRO_PATH_LINE_TO
            (x, y) = e.points
            # straight lines
            line(x, y)
        elseif e.element_type == Cairo.CAIRO_PATH_CURVE_TO
            (x1, y1, x2, y2, x3, y3) = e.points
            #bezier control lines
            curve(x1, y1, x2, y2, x3, y3)
            (x, y) = (x3, y3) # update current point
        elseif e.element_type == Cairo.CAIRO_PATH_CLOSE_PATH
            closepath()
        else
            error("unknown CairoPathEntry " * repr(e.element_type))
            error("unknown CairoPathEntry " * repr(e.points))
        end
    end
end

# draw the bezier handles and control points
# todo: control colors and line thicknesses
function show_beziers(path, dotsize = 5; labels=false)
    gsave()
    setline(0.2)
    sethue(0, .4, 0.4)
    counter=1 # for labelling each point
    fontsize(2)
    fontface("Menlo")
    # last point of path might be a moveto, presumably the advance values for the next text

    if path[end].element_type == 0
        pop!(path)
    end

    for e in path
        if e.element_type == Cairo.CAIRO_PATH_MOVE_TO
            (x, y) = e.points
            move(x,y)
            setopacity(0.9)
            circle(x, y, dotsize, :fill)
            labels && text(string(counter), x, y + 2)
            counter += 1
        elseif e.element_type == Cairo.CAIRO_PATH_LINE_TO
            (x, y) = e.points
            # straight lines
            gsave()
                sethue(0.4, 0.5, 0.3)
                circle(x, y, dotsize, :fill)
                labels && text(string(counter), x, y + 2)
            grestore()
            counter += 1
        elseif e.element_type == Cairo.CAIRO_PATH_CURVE_TO
            #bezier control lines
            (x1, y1, x2, y2, x3, y3) = e.points
            gsave()
                sethue(0.6, 0.6, 0.6)
                circle(x1, y1, dotsize, :fill)
                move(x1, y1)
                line(x1, y1)
                stroke()
                labels && text(string(counter), x1, y1 + 2)
                counter += 1
                move(x2, y2)
                line(x3, y3)
                stroke()
                labels && text(string(counter), x2, y2 + 2)
                counter += 1
                # bezier handles, make control points slightly smaller
                circle(x1, y1, dotsize - 0.25, :fill)
                circle(x2, y2, dotsize - 0.25, :fill)
                circle(x3, y3, dotsize, :fill)
                labels && text(string(counter), x3, y3 + 2)
            grestore()
            counter += 1
            (x, y) = (x3, y3) # update current point
        elseif e.element_type == Cairo.CAIRO_PATH_CLOSE_PATH
            closepath()
        else
            error("unknown CairoPathEntry " * repr(e.element_type))
            error("unknown CairoPathEntry " * repr(e.points))
        end
    end
    grestore()
end

function show_glyph(s::AbstractString, x, y)
# draw glyph s anchored at position x/y
    gsave()
        setopacity(0.5)
        sethue(1, 0, .5)
        translate(x, y)
        circle(0, 0, 1, :fill)
        textpath(s)

        opath = Cairo.convert_cairo_path_data(Cairo.copy_path(currentdrawing.cr))

        x1,y1= opath[1].points

        gsave()
            sethue(1, 0.5, 1)
            circle(x1, y1, 1, :fill)
        grestore()

        sethue(0.7, .7, .7)
        draw_path(opath)
        Luxor.fill()
        show_beziers(opath, .5, labels=true)
        # draw boxes and text extents
        xbearing, ybearing, width, height, xadvance, yadvance = textextents(s)
        # baseline, height
        setline(0.1)
        sethue(0, 0.6, 0)
        move(xbearing, 0)
        rline(width, 0)
        move(xbearing, -height)
        rline(width, 0)
        move(xbearing, -height)
        rline(width, 0)
        move(xbearing, -height)
        rline(width, 0)
        stroke()
        # extents: width & height
        sethue(0.2, 0.6, 0.8)
        rect(xbearing, ybearing, width, height, :stroke)

        # bearings
        move(0, 0)
        rline(xbearing, ybearing)
        stroke()

        # next location for text
        sethue(0, 0, 0.75)
        circle(xadvance, yadvance, 1, :fill)
    grestore()
end

tic()
fname = "/tmp/test-copy-path.pdf"
Drawing(1200, 1200, fname)

fontsize(200)
fontface("GothamBook")
show_glyph("G", 300, 500)

#fontface("ArialMT")
#show_glyph("G", 500, 500)

#fontface("Helvetica")
#show_glyph("G", 700, 500)

finish()
println("finished test: output in $(fname)"
toc()
