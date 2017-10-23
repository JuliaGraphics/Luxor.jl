"""
   findbeziercontrolpoints(previouspt::Point, pt1::Point, pt2::Point, nextpt::Point; smooth_value=0.5)

Find the Bézier control points for a curve between `pt1` and `pt2`. We'll refer to the previous point before `pt1` and the next point after `pt2`.
"""
function findbeziercontrolpoints(previouspt::Point, pt1::Point, pt2::Point, nextpt::Point;
    smoothing=0.5)

    xc1  = (previouspt.x + pt1.x) / 2.0
    yc1 = (previouspt.y + pt1.y) / 2.0
    xc2 = (pt1.x + pt2.x) / 2.0
    yc2 = (pt1.y + pt2.y) / 2.0
    xc3 = (pt2.x + nextpt.x) / 2.0
    yc3 = (pt2.y + nextpt.y) / 2.0

    len1, len2, len3 = norm(previouspt, pt1), norm(pt2, pt1), norm(nextpt, pt2)

    k1 = len1 / (len1 + len2)
    k2 = len2 / (len2 + len3)

    xm1 = xc1 + (xc2 - xc1) * k1
    ym1 = yc1 + (yc2 - yc1) * k1

    xm2 = xc2 + (xc3 - xc2) * k2
    ym2 = yc2 + (yc3 - yc2) * k2

    ctrl1_x = xm1 + (xc2 - xm1) * smoothing + pt1.x - xm1
    ctrl1_y = ym1 + (yc2 - ym1) * smoothing + pt1.y - ym1

    ctrl2_x = xm2 + (xc2 - xm2) * smoothing + pt2.x - xm2
    ctrl2_y = ym2 + (yc2 - ym2) * smoothing + pt2.y - ym2

    return (Point(ctrl1_x, ctrl1_y),  Point(ctrl2_x, ctrl2_y))
end

"""
    makebezierpath(pgon::Array{Point, 1}; smoothing=1)

Return a Bézier path that follows a polygon (an array of points). The Bézier path is an
array of tuples; each tuple contains the four points that make up a segment of the
Bézier path.
"""
function makebezierpath(pgon::Array{Point, 1}; smoothing=1.0)
    lpg = length(pgon)
    newpath = NTuple{4,Luxor.Point}[]
    for i in 1:lpg
        cp1, cp2 = findbeziercontrolpoints(
                pgon[mod1(i - 1, lpg)],
                pgon[mod1(i,     lpg)],
                pgon[mod1(i + 1, lpg)],
                pgon[mod1(i + 2, lpg)], smoothing=smoothing)
        push!(newpath, (pgon[mod1(i, lpg)], cp1, cp2, pgon[mod1(i + 1, lpg)]))
    end
    return newpath
end

"""
    drawbezierpath(bezierpath, action=:none;
        close=true)

Draw a Bézier path, and apply the action, such as `:none`, `:stroke`, `:fill`, etc. By
default the path is closed.
"""
function drawbezierpath(bezierpath::Array{NTuple{4,Luxor.Point}}, action=:none; close=true)
    move(bezierpath[1][1])
    for i in 1:length(bezierpath) - 1
        c = bezierpath[i]
        curve(c[2], c[3], c[4])
    end
    if close == true
        c = bezierpath[end]
        curve(c[2], c[3], c[4])
    end
    do_action(action)
end

"""
    beziertopoly(bpseg::NTuple{4,Luxor.Point}; steps=10)

Convert a Bezier segment (a tuple of four points: anchor1, control1, control2, anchor2) to a polygon (an array of points).
"""
function beziertopoly(bpseg::NTuple{4,Luxor.Point}; steps=10)
    path = Point[]
    anchor1, control1, control2, anchor2 = bpseg
    x1 = anchor1.x
    y1 = anchor1.y
    x2 = control1.x
    y2 = control1.y
    x3 = control2.x
    y3 = control2.y
    x4 = anchor2.x
    y4 = anchor2.y

    dx1 = x2 - x1
    dy1 = y2 - y1
    dx2 = x3 - x2
    dy2 = y3 - y2
    dx3 = x4 - x3
    dy3 = y4 - y3

    subdiv_step  = 1.0 / (steps + 1)
    subdiv_step2 = subdiv_step * subdiv_step
    subdiv_step3 = subdiv_step * subdiv_step * subdiv_step

    pre1 = 3.0 * subdiv_step
    pre2 = 3.0 * subdiv_step2
    pre4 = 6.0 * subdiv_step2
    pre5 = 6.0 * subdiv_step3

    tmp1x = x1 - x2 * 2.0 + x3
    tmp1y = y1 - y2 * 2.0 + y3

    tmp2x = (x2 - x3) * 3.0 - x1 + x4
    tmp2y = (y2 - y3) * 3.0 - y1 + y4

    fx = x1
    fy = y1

    dfx = (x2 - x1) * pre1 + tmp1x * pre2 + tmp2x * subdiv_step3
    dfy = (y2 - y1) * pre1 + tmp1y * pre2 + tmp2y * subdiv_step3

    ddfx = tmp1x * pre4 + tmp2x * pre5
    ddfy = tmp1y * pre4 + tmp2y * pre5

    dddfx = tmp2x * pre5
    dddfy = tmp2y * pre5

    step = steps
    push!(path, Point(x1, y1))
    while step > 0
        fx   += dfx
        fy   += dfy
        dfx  += ddfx
        dfy  += ddfy
        ddfx += dddfx
        ddfy += dddfy
        push!(path, Point(fx, fy))
        step -= 1
    end
    # not sure whether we should do this:
    # push!(path, Point(x4, y4))
    return path
end

"""
    bezierpathtopoly(bezierpath::Array{NTuple{4,Luxor.Point}}; steps=10)

Convert a Bezier path (an array of Bezier segments, where each segment is a tuple of four points: anchor1, control1, control2, anchor2) to a polygon.

To make a Bezier path, use `makebezierpath()` on a polygon.

The `steps` optional keyword determines how many line sections are used for each path.
"""
function bezierpathtopoly(bezierpath::Array{NTuple{4,Luxor.Point}}; steps=10)
    resultpoly = Point[]
    for bp in bezierpath
        p = beziertopoly(bp, steps=steps)
        append!(resultpoly, p)
    end
    if resultpoly[1] == resultpoly[end]
        pop!(resultpoly)
    end
    return resultpoly
end

"""
    pathtobezierpaths()

Convert the current path (which may consist of one or more paths) to an array of
Bezier paths. Each Bezier path is, in turn, an array of path segments. Each path
segment is a tuple of four points. A straight line is converted to a Bezier segment
in which the control points are set to be the the same as the end points.

# Example

This code draws the Bezier segments and shows the control points as "handles", like
a vector-editing program might.

```
@svg begin
    fontface("MyanmarMN-Bold")
    st = "goo"
    thefontsize = 100
    fontsize(thefontsize)
    sethue("red")
    fontsize(thefontsize)
    textpath(st)
    nbps = pathtobezierpaths()
    for nbp in nbps
        setline(.15)
        sethue("grey50")
        drawbezierpath(nbp, :stroke)
        for p in nbp
            sethue("red")
            circle(p[2], 0.16, :fill)
            circle(p[3], 0.16, :fill)
            line(p[2], p[1], :stroke)
            line(p[3], p[4], :stroke)
            if p[1] != p[4]
                sethue("black")
                circle(p[1], 0.26, :fill)
                circle(p[4], 0.26, :fill)
            end
        end
    end
end
```

"""
function pathtobezierpaths()
    originalpath = getpath()
    # to store all the Bezier paths
    result = Array{NTuple{4,Luxor.Point}, 1}[]
    # to store a Bezier path
    newbezpath = NTuple{4,Luxor.Point}[]
    # to store a Bezier segment
    bezsegment = ()
    currentpos = Point(0, 0)
    if length(originalpath) > 0
        for e in originalpath
            if e.element_type == Cairo.CAIRO_PATH_MOVE_TO                # 0
                currentpos = Point(e.points[1], e.points[2])
            elseif e.element_type == Cairo.CAIRO_PATH_LINE_TO            # 1
                # add a straight line segment in the form of a bezsegment
                bezsegment = (currentpos,
                              currentpos,
                              Point(e.points[1], e.points[2]),
                              Point(e.points[1], e.points[2]))
                push!(newbezpath, bezsegment)
                currentpos = Point(e.points[1], e.points[2])
            elseif e.element_type == Cairo.CAIRO_PATH_CURVE_TO           # 2
                bezsegment = (currentpos,
                              Point(e.points[1], e.points[2]),
                              Point(e.points[3], e.points[4]),
                              Point(e.points[5], e.points[6]))
                currentpos = Point(e.points[5], e.points[6])
                push!(newbezpath, bezsegment)
            elseif e.element_type == Cairo.CAIRO_PATH_CLOSE_PATH         # 3
                # finish this path and store it away
                if length(newbezpath) > 0
                    push!(result, newbezpath)
                end
                # make new path
                newbezpath = NTuple{4,Luxor.Point}[]
            else
                error("unknown CairoPathEntry " * repr(e.element_type))
                error("unknown CairoPathEntry " * repr(e.points))
            end
        end
    end
    return result
end
