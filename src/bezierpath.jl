"""
    findbeziercontrolpoints(previouspt::Point,
        pt1::Point,
        pt2::Point,
        nextpt::Point;
        smooth_value=0.5)

Find the Bézier control points for the line between `pt1` and `pt2`, where the
point before `pt1` is `previouspt` and the next point after `pt2` is `nextpt`.
"""
function findbeziercontrolpoints(previouspt::Point, point1::Point, point2::Point, nextpt::Point;
    smoothing=0.5)

    xc1 = (previouspt.x + point1.x)/2.0 ; yc1 = (previouspt.y + point1.y)/2.0
    xc2 = (point1.x + point2.x)/2.0     ; yc2 = (point1.y + point2.y)/2.0
    xc3 = (point2.x + nextpt.x)/2.0     ; yc3 = (point2.y + nextpt.y)/2.0

    l1, l2, l3 = norm(previouspt, point1), norm(point2, point1), norm(nextpt, point2)
    k1 = l1 / (l1 + l2)   ; k2 = l2 / (l2 + l3)
    xm1 = xc1 + (xc2-xc1) * k1  ; ym1 = yc1 + (yc2-yc1) * k1
    xm2 = xc2 + (xc3-xc2) * k2  ; ym2 = yc2 + (yc3-yc2) * k2
    c1x = xm1 + (xc2-xm1) * smoothing + point1.x-xm1
    c1y = ym1 + (yc2-ym1) * smoothing + point1.y-ym1
    c2x = xm2 + (xc2-xm2) * smoothing + point2.x-xm2
    c2y = ym2 + (yc2-ym2) * smoothing + point2.y-ym2
    return (Point(c1x, c1y),  Point(c2x, c2y))
end

"""
    makebezierpath(pgon::AbstractArray{Point, 1}; smoothing=1)

Return a Bézier path that represents a polygon (an array of points). The Bézier
path is an array of segments (tuples of 4 points); each segment contains the
four points that make up a section of the entire Bézier path. `smoothing`
determines how closely the curve follows the polygon. A value of 0 returns a
straight-sided path; as values move above 1 the paths deviate further from
the original polygon's edges.
"""
function makebezierpath(pgon::AbstractArray{Point, 1}; smoothing=1.0)
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

Draw the Bézier path, and apply the action, such as `:none`, `:stroke`, `:fill`,
etc. By default the path is closed.
"""
function drawbezierpath(bezierpath::AbstractArray{NTuple{4,Luxor.Point}}, action=:none; close=true)
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
    drawbezierpath(bezierpathsegment, action=:none;
        close=true)

Draw the Bézier path segment, and apply the action, such as `:none`, `:stroke`,
`:fill`, etc. By default the path is open.
"""
drawbezierpath(bezierpathsegment::NTuple{4,Luxor.Point},
    action=:none; kwargs...) = drawbezierpath([bezierpathsegment], action; kwargs...)

"""
    beziertopoly(bpseg::NTuple{4,Luxor.Point}; steps=10)

Convert a Bezier segment (a tuple of four points: anchor1, control1, control2,
anchor2) to a polygon (an array of points).
"""
function beziertopoly(bpseg::NTuple{4,Luxor.Point}; steps=10)
    thepolygon = Point[]
    anchor1, control1, control2, anchor2 = bpseg
    dx1 = control1.x - anchor1.x
    dy1 = control1.y - anchor1.y
    dx2 = control2.x - control1.x
    dy2 = control2.y - control1.y
    dx3 = anchor2.x - control2.x
    dy3 = anchor2.y - control2.y

    ss1 = 1.0/(steps + 1)
    ss2 = ss1 * ss1
    ss3 = ss2 * ss1

    p1 = 3.0 * ss1; p2 = 3.0 * ss2; p4 = 6.0 * ss2; p5 = 6.0 * ss3

    t1x = anchor1.x - control1.x * 2.0 + control2.x
    t1y = anchor1.y - control1.y * 2.0 + control2.y

    t2x = (control1.x - control2.x) * 3.0 - anchor1.x + anchor2.x
    t2y = (control1.y - control2.y) * 3.0 - anchor1.y + anchor2.y

    fx = anchor1.x ; fy = anchor1.y

    dfx = (control1.x - anchor1.x) * p1 + t1x * p2 + t2x * ss3
    dfy = (control1.y - anchor1.y) * p1 + t1y * p2 + t2y * ss3

    d2fx = t1x * p4 + t2x * p5 ; d2fy = t1y * p4 + t2y * p5
    d3fx = t2x * p5            ; d3fy = t2y * p5

    n = steps
    push!(thepolygon, Point(anchor1.x, anchor1.y))
    while n > 0
        fx   += dfx
        fy   += dfy
        dfx  += d2fx
        dfy  += d2fy
        d2fx += d3fx
        d2fy += d3fy
        push!(thepolygon, Point(fx, fy))
        n -= 1
    end
    # should we add the last point? no, do that downstream if required:
    # push!(thepolygon, Point(x4, y4))
    return thepolygon
end

"""
    bezierpathtopoly(bezierpath::AbstractArray{NTuple{4,Luxor.Point}}; steps=10)

Convert a Bezier path (an array of Bezier segments, where each segment is a tuple of four points: anchor1, control1, control2, anchor2) to a polygon.

To make a Bezier path, use `makebezierpath()` on a polygon.

The `steps` optional keyword determines how many line sections are used for each path.
"""
function bezierpathtopoly(bezierpath::AbstractArray{NTuple{4,Luxor.Point}}; steps=10)
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
        # tidy up, not everything gets closed
        if length(newbezpath) > 0
            push!(result, newbezpath)
        end
    end
    return result
end

# More Bezier madness

function _solvexy(a, b, c, d, e, f)
# solve linear equation ai + bj = c and di + ej = f
    j = (c - a / d * f) / (b - a * e / d)
    i = (c - (b * j)) / a
    return i, j
end

# basis functions
_b0(t) = (1 - t) ^ 3
_b1(t) = t * (1 - t) * (1 - t) * 3
_b2(t) = (1 - t) * t * t * 3
_b3(t) = (t ^ 3)

"""
    bezierfrompoints(startpoint::Point, pointonline1::Point, pointonline2::Point, endpoint::Point)

Given four points, return a Bezier path segment that passes through all
four points, starting at `startpoint` and ending at `endpoint`. The two middle
points of the returned tuple are the two control points.

(Don Lancaster ftw: https://www.tinaja.com/glib/nubz4pts1.pdf)
"""
function bezierfrompoints(startpoint::Point, pointonline1::Point, pointonline2::Point, endpoint::Point)
    # chord lengths
    c1 = sqrt((pointonline1.x - startpoint.x) * (pointonline1.x - startpoint.x) + (pointonline1.y - startpoint.y) * (pointonline1.y - startpoint.y))
    c2 = sqrt((pointonline2.x - pointonline1.x) * (pointonline2.x - pointonline1.x) + (pointonline2.y - pointonline1.y) * (pointonline2.y - pointonline1.y))
    c3 = sqrt((endpoint.x - pointonline2.x) * (endpoint.x - pointonline2.x) + (endpoint.y - pointonline2.y) * (endpoint.y - pointonline2.y))
    # best guess for t
    t1 = c1 / (c1 + c2 + c3)
    t2 = (c1 + c2) / (c1 + c2 + c3)
    (x1, x2) = _solvexy(_b1(t1), _b2(t1), pointonline1.x - (startpoint.x * _b0(t1)) - (endpoint.x * _b3(t1)), _b1(t2), _b2(t2), pointonline2.x - (startpoint.x * _b0(t2)) - (endpoint.x * _b3(t2)))
    (y1, y2) = _solvexy(_b1(t1), _b2(t1), pointonline1.y - (startpoint.y * _b0(t1)) - (endpoint.y * _b3(t1)), _b1(t2), _b2(t2), pointonline2.y - (startpoint.y * _b0(t2)) - (endpoint.y * _b3(t2)))
    return startpoint, Point(x1, y1), Point(x2, y2), endpoint
end

"""
    bezier(t, A::Point, A1::Point, B1::Point, B::Point)

The Bezier cubic curve function, `t` going from 0 to 1, starting at A, finishing
at B, control points A1 (controlling A), and B1 (controlling B).
"""
bezier(t, A::Point, A1::Point, B1::Point, B::Point) =
      A * (1 - t)^3 +
      (A1 * 3t * (1 - t)^2) +
      (B1 * 3t^2 * (1 - t)) +
      (B * t^3)

"""
  bezier′(t, A::Point, A1::Point, B1::Point, B::Point)

Return the first derivative of Bezier function
"""
bezier′(t, A, A1, B1, B) = 3(1-t)^2 * (A1-A) + 6(1-t) * t * (B1-A1) + 3t^2 * (B-B1)

"""
    bezier′(t, A::Point, A1::Point, B1::Point, B::Point)

Return the second derivative of Bezier function.
"""
bezier′′(t, A, A1, B1, B) = 6(1-t) * (B1-2A1+A) + 6t * (B-2B1+A1)

"""
    beziercurvature(t, A::Point, A1::Point, B1::Point, B::Point)

Return the curvature of the Bezier curve at `t` ([0-1]), given start and end
points A and B, and control points A1 and B1. The value (kappa) will typically
be a value between -0.001 and 0.001 for points with coordinates in the 100-500
range.

κ(t) is the curvature of the curve at point t, which for a parametric planar
curve is:

```math
\begin{equation}
\kappa = \frac{\mid \dot{x}\ddot{y}-\dot{y}\ddot{x}\mid}
    {(\dot{x}^2 + \dot{y}^2)^{\frac{3}{2}}}
\end{equation}
```

The radius of curvature, or the radius of an osculating circle at a point, is
1/κ(t). Values of 1/κ will typically be in the range -1000 to 1000 for points
with coordinates in the 100-500 range.

TODO Fix

The value of kappa can sometimes collapse near 0, returning NaN (and Inf for
radius of curvature).
"""
function beziercurvature(t, A::Point, A1::Point, B1::Point, B::Point)
    x′ = bezier′(t, A, A1, B1, B).x
    y′ = bezier′(t, A, A1, B1, B).y
    x′′ = bezier′′(t, A, A1, B1, B).x
    y′′ = bezier′′(t, A, A1, B1, B).y
    return ((x′ * y′′) - (y′ * x′′)) / (x′^2 + y′^2)^(3/2)
end
