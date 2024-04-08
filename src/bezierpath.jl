"""
BezierPathSegment is an array of four points:

`p1`  - start point
`cp1` - control point for start point
`cp2` - control point for finishpoint
`p2`  - finish point
"""
mutable struct BezierPathSegment <: AbstractArray{Luxor.Point,1}
    p1::Point
    cp1::Point
    cp2::Point
    p2::Point
end

Base.size(bps::BezierPathSegment) = (4,)
Base.length(bps::BezierPathSegment) = 4
Base.eltype(::Type{BezierPathSegment}) = Luxor.Point
Base.getindex(bps::BezierPathSegment, i::T) where {T<:Integer} = [bps.p1, bps.cp1, bps.cp2, bps.p2][i]
Base.setindex!(bps::BezierPathSegment, v, i::T) where {T<:Integer} = [bps.p1, bps.cp1, bps.cp2, bps.p2][i] = v
Base.IndexStyle(::Type{<:BezierPathSegment}) = IndexLinear()

# state is integer referring to one of the four points
function Base.iterate(bps::BezierPathSegment)
    return (bps.p1, 2)
end

function Base.iterate(bps::BezierPathSegment, s)
    if (s > length(bps))
        return
    end
    return bps[s], s + 1
end

BezierPathSegment(a::Array{Point,1}) =
    BezierPathSegment(a[1], a[2], a[3], a[4])

# function Base.show(io::IO, bps::BezierPathSegment)
#     println(io, "p1  $(bps.p1)  cp1 $(bps.cp1)")
#     println(io, "cp2  $(bps.cp2)  p2 $(bps.p2)")
# end

"""
BezierPath is an array of BezierPathSegments.
`segments` is `Vector{BezierPathSegment}`.
"""
mutable struct BezierPath <: AbstractArray{BezierPathSegment,1}
    segments::Vector{BezierPathSegment}
end

BezierPath(bps::BezierPathSegment) = BezierPath([bps])
BezierPath() = BezierPath(BezierPathSegment[])

Base.size(bp::BezierPath) = size(bp.segments)
Base.length(bp::BezierPath) = length(bp.segments)
Base.eltype(::Type{BezierPath}) = BezierPathSegment
Base.getindex(bp::BezierPath, i::T) where {T<:Integer} = bp.segments[i]
Base.setindex!(bp::BezierPath, v, i::T) where {T<:Integer} = bp.segments[i] = v
Base.IndexStyle(::Type{<:BezierPath}) = IndexLinear()

Base.push!(bp::BezierPath, v::BezierPathSegment) = Base.push!(bp.segments, v)

# Base.show(io::IO, bp::BezierPath) =
#     print(io, "BezierPath with $(length(bp.segments)) segments")

"""
    bezier(t, A::Point, A1::Point, B1::Point, B::Point)

Return the result of evaluating the Bézier cubic curve function, `t` going from
0 to 1, starting at A, finishing at B, control points A1 (controlling A), and B1
(controlling B).
"""
bezier(t, A::Point, A1::Point, B1::Point, B::Point) =
    A * (1.0 - t)^3 +
    (A1 * 3t * (1.0 - t)^2) +
    (B1 * 3t^2 * (1.0 - t)) +
    (B * t^3)

bezier(t, bps::BezierPathSegment) =
    bezier(t, bps.p1, bps.cp1, bps.cp1, bps.p2)

"""
bezier′(t, A::Point, A1::Point, B1::Point, B::Point)

Return the first derivative of the Bézier function.
"""
bezier′(t, A, A1, B1, B) = 3(1.0 - t)^2 * (A1 - A) + 6(1.0 - t) * t * (B1 - A1) + 3t^2 * (B - B1)

bezier′(t, bps::BezierPathSegment) =
    bezier′(t, bps.p1, bps.cp1, bps.cp1, bps.p2)

"""
    bezier′′(t, A::Point, A1::Point, B1::Point, B::Point)

Return the second derivative of Bézier function.
"""
bezier′′(t, A, A1, B1, B) = 6(1 - t) * (B1 - 2A1 + A) + 6t * (B - 2B1 + A1)

bezier′′(t, bps::BezierPathSegment) =
    bezier′′(t, bps.p1, bps.cp1, bps.cp1, bps.p2)

"""
    beziercurvature(t, A::Point, A1::Point, B1::Point, B::Point)

Return the curvature of the Bézier curve at `t` ([0-1]), given start and end
points A and B, and control points A1 and B1. The value (kappa) will typically
be a value between -0.001 and 0.001 for points with coordinates in the 100-500
range.

κ(t) is the curvature of the curve at point t, which for a parametric planar
curve is:

```math
\\begin{equation}
\\kappa = \\frac{\\mid \\dot{x}\\ddot{y}-\\dot{y}\\ddot{x}\\mid}
    {(\\dot{x}^2 + \\dot{y}^2)^{\\frac{3}{2}}}
\\end{equation}
```

The radius of curvature, or the radius of an osculating circle at a point, is
1/κ(t). Values of 1/κ will typically be in the range -1000 to 1000 for points
with coordinates in the 100-500 range.

TODO Fix overshoot...

...The value of kappa can sometimes collapse near 0, returning NaN (and Inf for
radius of curvature).
"""
function beziercurvature(t, A::Point, A1::Point, B1::Point, B::Point)
    x′ = bezier′(t, A, A1, B1, B).x
    y′ = bezier′(t, A, A1, B1, B).y
    x′′ = bezier′′(t, A, A1, B1, B).x
    y′′ = bezier′′(t, A, A1, B1, B).y
    return ((x′ * y′′) - (y′ * x′′)) / (x′^2 + y′^2)^(3 / 2)
end

beziercurvature(t, bps::BezierPathSegment) =
    beziercurvature(t, bps.p1, bps.cp1, bps.cp1, bps.p2)

"""
    findbeziercontrolpoints(
        previouspt::Point,
        pt1::Point,
        pt2::Point,
        nextpt::Point;
            smoothing = 0.5)

Find the Bézier control points for the line between `pt1` and `pt2`, where the
point before `pt1` is `previouspt` and the next point after `pt2` is `nextpt`.
"""
function findbeziercontrolpoints(
    previouspt::Point,
    point1::Point,
    point2::Point,
    nextpt::Point;
    smoothing = 0.5)
    xc1 = (previouspt.x + point1.x) / 2.0
    yc1 = (previouspt.y + point1.y) / 2.0
    xc2 = (point1.x + point2.x) / 2.0
    yc2 = (point1.y + point2.y) / 2.0
    xc3 = (point2.x + nextpt.x) / 2.0
    yc3 = (point2.y + nextpt.y) / 2.0

    l1, l2, l3 = distance(previouspt, point1), distance(point2, point1), distance(nextpt, point2)
    k1 = l1 / (l1 + l2)
    k2 = l2 / (l2 + l3)
    xm1 = xc1 + (xc2 - xc1) * k1
    ym1 = yc1 + (yc2 - yc1) * k1
    xm2 = xc2 + (xc3 - xc2) * k2
    ym2 = yc2 + (yc3 - yc2) * k2
    c1x = xm1 + (xc2 - xm1) * smoothing + point1.x - xm1
    c1y = ym1 + (yc2 - ym1) * smoothing + point1.y - ym1
    c2x = xm2 + (xc2 - xm2) * smoothing + point2.x - xm2
    c2y = ym2 + (yc2 - ym2) * smoothing + point2.y - ym2
    return (Point(c1x, c1y), Point(c2x, c2y))
end

"""
    makebezierpath(pgon::Array{Point, 1};
        smoothing=1.0)

Return a Bézier path (a BezierPath) that represents a polygon (an array of points). The Bézier
path is an array of segments (tuples of 4 points); each segment contains the
four points that make up a section of the entire Bézier path.

`smoothing` determines how closely the curve follows the
polygon. A value of 0 returns a straight-sided path; as
values move above 1 the paths deviate further from the
original polygon's edges.
"""
function makebezierpath(pgon::Array{Point,1};
    smoothing = 1.0)
    lpg = length(pgon)
    newpath = BezierPath()
    for i in 1:lpg
        cp1, cp2 = findbeziercontrolpoints(
            pgon[mod1(i - 1, lpg)],
            pgon[mod1(i, lpg)],
            pgon[mod1(i + 1, lpg)],
            pgon[mod1(i + 2, lpg)], smoothing = smoothing)
        push!(newpath, BezierPathSegment(pgon[mod1(i, lpg)], cp1, cp2, pgon[mod1(i + 1, lpg)]))
    end
    return newpath
end

"""
    drawbezierpath(bezierpath::BezierPath, action=:none;
        close=true)
    drawbezierpath(bezierpath::BezierPath;
        action=:none,
        close=true)

Draw the Bézier path, and apply the action, such as `:none`, `:stroke`, `:fill`,
etc. By default the path is closed.

TODO Return something more useful than a Boolean.
"""
function drawbezierpath(bezierpath::BezierPath, action;
    close = true)
    move(bezierpath[1].p1)
    for i in 1:(length(bezierpath) - 1)
        c = bezierpath[i]
        curve(c.cp1, c.cp2, c.p2)
    end
    if close == true
        c = bezierpath[end]
        curve(c.cp1, c.cp2, c.p2)
    end
    do_action(action)
end

drawbezierpath(bezierpath; action = :none, close = true) =
    drawbezierpath(bezierpath, action; close = close)

"""
    drawbezierpath(bps::BezierPathSegment;
        action=:none,
        close=false)

Draw the Bézier path segment, and apply the action, such as `:none`, `:stroke`,
`:fill`, etc. By default the path is open.

TODO Return something more useful than a Boolean.
"""
function drawbezierpath(bps::BezierPathSegment;
    action = :none,
    close = false)
    move(bps.p1)
    curve(bps.cp1, bps.cp2, bps.p2)
    if close == true
        closepath()
    end
    do_action(action)
end

# allow drawbezierpath(bps, :stroke)
drawbezierpath(bps::BezierPathSegment, action::Symbol; close = true) =
    drawbezierpath(bps, action = action, close = close)

drawbezierpath(bpsa::Array{BezierPathSegment,1}, action = :none) =
    foreach(b -> drawbezierpath(b, action), bpsa)

"""
    beziertopoly(bpseg::BezierPathSegment;
        steps=10)

Convert a BezierPathsegment to a polygon (an array of points).
"""
function beziertopoly(bpseg::BezierPathSegment;
    steps = 10)
    thepolygon = Point[]
    anchor1, control1, control2, anchor2 = bpseg.p1, bpseg.cp1, bpseg.cp2, bpseg.p2
    dx1 = control1.x - anchor1.x
    dy1 = control1.y - anchor1.y
    dx2 = control2.x - control1.x
    dy2 = control2.y - control1.y
    dx3 = anchor2.x - control2.x
    dy3 = anchor2.y - control2.y

    ss1 = 1.0 / (steps + 1)
    ss2 = ss1 * ss1
    ss3 = ss2 * ss1

    p1 = 3.0 * ss1
    p2 = 3.0 * ss2
    p4 = 6.0 * ss2
    p5 = 6.0 * ss3

    t1x = anchor1.x - control1.x * 2.0 + control2.x
    t1y = anchor1.y - control1.y * 2.0 + control2.y

    t2x = (control1.x - control2.x) * 3.0 - anchor1.x + anchor2.x
    t2y = (control1.y - control2.y) * 3.0 - anchor1.y + anchor2.y

    fx = anchor1.x
    fy = anchor1.y

    dfx = (control1.x - anchor1.x) * p1 + t1x * p2 + t2x * ss3
    dfy = (control1.y - anchor1.y) * p1 + t1y * p2 + t2y * ss3

    d2fx = t1x * p4 + t2x * p5
    d2fy = t1y * p4 + t2y * p5
    d3fx = t2x * p5
    d3fy = t2y * p5

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
    bezierpathtopoly(bezierpath::BezierPath;
        steps=10)

Convert a Bézier path (an array of BezierPathSegments, where each is a
tuple of four points: anchor1, control1, control2, anchor2), to a polygon.

To make a Bézier path, use `makebezierpath()` on a polygon.

The `steps` optional keyword determines how many straight
line sections are used for each path.
"""
function bezierpathtopoly(bezierpath::BezierPath;
    steps = 10)
    resultpoly = Point[]
    for bp in bezierpath
        p = beziertopoly(bp, steps = steps)
        append!(resultpoly, p)
    end
    if resultpoly[1] == resultpoly[end]
        pop!(resultpoly)
    end
    return resultpoly
end

"""
    pathtobezierpaths(
        ; flat=true)

Convert the current Cairo path (which may consist of one or more paths) to an array of
Bézier paths, each of which is an array of BezierPathSegments. Each path
segment is a tuple of four points. A straight line is converted to a Bézier segment
in which the control points are set to be the same as the end points.

If `flat` is true, use `getpathflat()` rather than `getpath()`.

# Example

This code draws the BezierPathSegments and shows the control points as "handles", like
a vector-editing program might.

```julia
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
function pathtobezierpaths(;
    flat = true)
    flat ? (originalpath = getpath()) : (originalpath = getpathflat())
    # to store all the Bezier paths
    result = BezierPath[]
    # to store one Bezier path
    newbezpath = BezierPath()
    # to store a Bezier segment
    currentpos = Point(0, 0)
    if length(originalpath) > 0
        for e in originalpath
            if e.element_type == Cairo.CAIRO_PATH_MOVE_TO                # 0
                currentpos = Point(e.points[1], e.points[2])
            elseif e.element_type == Cairo.CAIRO_PATH_LINE_TO            # 1
                # add a straight line segment in the form of a bezsegment
                bezsegment = BezierPathSegment(currentpos,
                    currentpos,
                    Point(e.points[1], e.points[2]),
                    Point(e.points[1], e.points[2]))
                push!(newbezpath, bezsegment)
                currentpos = Point(e.points[1], e.points[2])
            elseif e.element_type == Cairo.CAIRO_PATH_CURVE_TO           # 2
                bezsegment = BezierPathSegment(currentpos,
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
                newbezpath = BezierPath()
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
_b0(t) = (1 - t)^3
_b1(t) = t * (1 - t) * (1 - t) * 3
_b2(t) = (1 - t) * t * t * 3
_b3(t) = (t^3)

"""
    bezierfrompoints(startpoint::Point,
        pointonline1::Point,
        pointonline2::Point,
        endpoint::Point)

Given four points, return the Bézier curve that passes through all four points,
starting at `startpoint` and ending at `endpoint`. The two middle points of the
returned BezierPathSegment are the two control points that make the curve pass
through the two middle points supplied.
"""
function bezierfrompoints(startpoint::Point,
    pointonline1::Point,
    pointonline2::Point,
    endpoint::Point)
    # chord lengths
    c1 = sqrt((pointonline1.x - startpoint.x) * (pointonline1.x - startpoint.x) + (pointonline1.y - startpoint.y) * (pointonline1.y - startpoint.y))
    c2 = sqrt((pointonline2.x - pointonline1.x) * (pointonline2.x - pointonline1.x) + (pointonline2.y - pointonline1.y) * (pointonline2.y - pointonline1.y))
    c3 = sqrt((endpoint.x - pointonline2.x) * (endpoint.x - pointonline2.x) + (endpoint.y - pointonline2.y) * (endpoint.y - pointonline2.y))
    # best guess for t
    t1 = c1 / (c1 + c2 + c3)
    t2 = (c1 + c2) / (c1 + c2 + c3)
    (x1, x2) = _solvexy(_b1(t1), _b2(t1), pointonline1.x - (startpoint.x * _b0(t1)) - (endpoint.x * _b3(t1)), _b1(t2), _b2(t2), pointonline2.x - (startpoint.x * _b0(t2)) - (endpoint.x * _b3(t2)))
    (y1, y2) = _solvexy(_b1(t1), _b2(t1), pointonline1.y - (startpoint.y * _b0(t1)) - (endpoint.y * _b3(t1)), _b1(t2), _b2(t2), pointonline2.y - (startpoint.y * _b0(t2)) - (endpoint.y * _b3(t2)))
    return BezierPathSegment(startpoint, Point(x1, y1), Point(x2, y2), endpoint)
end

"""
    bezierfrompoints(ptslist::Array{Point, 1})

Given four points, return the Bézier curve that passes through all four points.
"""
bezierfrompoints(ptslist::Array{Point,1}) = bezierfrompoints(ptslist...)

"""
    bezierstroke(point1, point2, width=0.0)

Return a BezierPath, a stroked version of a straight line between two points.

It wil have 2 or 6 Bezier path segments that define a brush or pen shape. If
width is 0, the brush shape starts and ends at a point. Otherwise the brush shape
starts and ends with the thick end.

To draw it, use eg `drawbezierpath(..., :fill)`.
"""
function bezierstroke(p1::Point, p2::Point, width = 0.0)
    bezpath = BezierPath()
    if isapprox(width, 0.0)
        # simple wavy stroke starting ending at point
        push!(bezpath, BezierPathSegment(p1, p1, p2, p2))
        push!(bezpath, BezierPathSegment(p2, p2, p1, p1))
        result = setbezierhandles.(bezpath, angles = [0.1, -0.1], handles = [0.3, 0.3])
    else
        # stroke with broad opening and closing
        # make the paths, then give them some control power
        cp1 = perpendicular(p1, p2, -width)
        seg = BezierPathSegment(p1, p1, cp1, cp1)
        adjustedseg = setbezierhandles(seg, angles = [0.1, -0.1], handles = [0.3, 0.3])
        push!(bezpath, adjustedseg)

        cp2 = perpendicular(p2, p1, width)
        seg = BezierPathSegment(cp1, cp1, cp2, cp2)
        adjustedseg = setbezierhandles(seg, angles = [0.1, -0.1], handles = [0.3, 0.3])
        push!(bezpath, adjustedseg)

        seg = BezierPathSegment(cp2, cp2, p2, p2)
        adjustedseg = setbezierhandles(seg, angles = [0.1, -0.1], handles = [0.3, 0.3])
        push!(bezpath, adjustedseg)

        # TODO the segments should be collinear, perhaps?
        cp3 = perpendicular(p2, p1, -width)
        seg = BezierPathSegment(p2, p2, cp3, cp3)
        adjustedseg = setbezierhandles(seg, angles = [0.1, -0.1], handles = [0.3, 0.3])
        push!(bezpath, adjustedseg)

        cp4 = perpendicular(p1, p2, width)
        seg = BezierPathSegment(cp3, cp3, cp4, cp4)
        adjustedseg = setbezierhandles(seg, angles = [0.1, -0.1], handles = [0.3, 0.3])
        push!(bezpath, adjustedseg)

        seg = BezierPathSegment(cp4, cp4, p1, p1)
        adjustedseg = setbezierhandles(seg, angles = [0.1, -0.1], handles = [0.3, 0.3])
        push!(bezpath, adjustedseg)
        result = bezpath
    end
    return result
end

"""
    setbezierhandles(bps::BezierPathSegment;
            angles  = [0.05, -0.1],
            handles = [0.3, 0.3])

Return a new BezierPathSegment with new locations for the Bezier control
points in the BezierPathSegment `bps`.

`angles` are the two angles that the "handles" make with the line direciton.

` handles` are the lengths of the "handles". 0.3 is a typical value.
"""
function setbezierhandles(bps::BezierPathSegment;
    angles = [0.05, -0.1],
    handles = [0.3, 0.3])
    d = distance(bps[1], bps[4])
    s = slope(bps[1], bps[4])
    bezhandle1 = bps[1] + polar(d * handles[1], s - angles[1])
    s = slope(bps[4], bps[1])
    bezhandle2 = bps[4] + polar(d * handles[2], s + angles[2])
    return BezierPathSegment(bps[1], bezhandle1, bezhandle2, bps[4])
end

"""
    setbezierhandles(bezpath::BezierPath;
        angles=[0 .05, -0.1],
        handles=[0.3, 0.3])

Return a new BezierPath with new locations for the Bézier control points in
every Bézier path segment of the BezierPath in `bezpath`.

`angles` are the two angles that the "handles" make with the line direciton.

` handles` are the lengths of the "handles". 0.3 is a typical value.
"""
function setbezierhandles(bezpath::BezierPath;
    angles = [0.05, -0.1],
    handles = [0.4, 0.4])
    newbezpath = BezierPath()
    for bps in bezpath
        push!(newbezpath, setbezierhandles(bps, angles = angles, handles = handles))
    end
    return newbezpath
end

"""
    shiftbezierhandles(bps::BezierPathSegment;
        angles=[0.1, -0.1],
        handles=[1.1, 1.1])

Return a new BezierPathSegment that modifies the Bézier path in `bps` by moving
the control handles. The values in `angles` increase the angle of the handles;
the values in `handles` modifies the lengths: 1 preserves the length, 0.5 halves
the length of the  handles, 2 doubles them.
"""
function shiftbezierhandles(bps::BezierPathSegment;
    angles  = [0.1, -0.1],
    handles = [0.1, 0.1])
    p1, cp1, cp2, p2 = bps
    # find slope of curve at the end points
    spt1 = bezier′(0.0, p1, cp1, cp2, p2)
    spt2 = bezier′(1.0, p1, cp1, cp2, p2)
    # angle of handle to curve
    s1 = slope(p1, cp1)
    s2 = slope(p2, cp2)
    # length of handles
    l1 = distance(p1, cp1)
    l2 = distance(p2, cp2)
    # new angle
    s1 += angles[1]
    s2 += angles[2]
    # new handle lengths
    l1 = l1 * handles[1]
    l2 = l2 * handles[2]
    newcontrolpoint1 = p1 + polar(l1, s1)
    newcontrolpoint2 = p2 + polar(l2, s2)
    return BezierPathSegment(p1, newcontrolpoint1, newcontrolpoint2, p2)
end

"""
    brush(pt1, pt2, width=10;
        strokes=10,
        minwidth=0.01,
        maxwidth=0.03,
        twist = -1,
        lowhandle  = 0.3,
        highhandle = 0.7,
        randomopacity = true,
        tidystart = false,
        action = :fill,
        strokefunction = (nbpb) -> nbpb))

Draw a composite brush stroke made up of some randomized individual filled
Bezier paths.

`strokefunction` allows a function to process a BezierPathSegment or do other things before it's drawn.

!!! note
    
    There is a lot of randomness in this function. Results are unpredictable.
"""
function brush(pt1, pt2, width = 10;
    strokes = 10,
    minwidth = 0.01,
    maxwidth = 0.03,
    twist = -1,
    lowhandle = 0.3,
    highhandle = 0.7,
    randomopacity = true,
    tidystart = false,
    action = :fill,
    strokefunction = (nbpb) -> nbpb)
    @layer begin
        sl = slope(pt1, pt2)
        n = distance(pt1, pt2)
        translate(pt1)
        rotate(sl - pi / 2)
        widthsteps = (maxwidth - minwidth) / 10
        for j in 1:strokes
            shiftedline = [O + (0, 0), O + (0, n)]
            if tidystart
                shiftedline .+= Ref(Point(rand((-width/2):(width/2)), 0))
            else
                shiftedline .+= Ref(Point(rand((-width/2):(width/2)), rand((-width/2):(width/2))))
            end
            pbp = bezierstroke(shiftedline[1],
                shiftedline[2],
                rand(Bool) ? 0.0 : rand(minwidth:widthsteps:maxwidth),
            )
            for bps in pbp
                randomopacity ? setopacity(rand(0.3:0.1:0.9)) : setopacity(1.0)
                nbpb = shiftbezierhandles(bps,
                    angles  = [twist * rand(minwidth:widthsteps:maxwidth), -twist * rand(minwidth:widthsteps:maxwidth)],
                    handles = [rand(lowhandle:0.01:highhandle, 2)...],
                )
                strokefunction(nbpb)
                drawbezierpath(nbpb, action, close = false)
            end
        end
    end
end

"""
    beziersegmentangles(pt1, pt2;
        out = deg2rad(45),
        in  = deg2rad(135),
        l   = 100)

Return a BezierPathSegment joining `pt1` and `pt2` making
the angles `out` at the start and `in` at the end.

It's similar to the tikZ `(a) to [out=135, in=45] (b)`
drawing instruction (but in radians obviously).

`out` is the angle that a line from `pt1` to the outgoing
Bézier handle makes with the horizontal. `in` is the angle
that a line joining `pt2` from the preceding Bézier handle
makes with the horizontal.

The function finds the interesction point of two lines with
the two angles and constructs a BezierPathSegment that fits.

See also the `bezierfrompoints()` function that makes a
BezierPathSegment that passes through four points.

### Example

```julia
drawbezierpath(beziersegmentangles(O, O + (100, 0),
    out = deg2rad(45),
    in  = 2π - deg2rad(45)),
    :stroke)
```
"""
function beziersegmentangles(pt1, pt2;
    out = deg2rad(45),
    in  = deg2rad(135))
    # find intersection of the tangents
    tangent1 = (pt1, pt1 + polar(1, out)) # arbitrary length "ray" :(
    tangent2 = (pt2, pt2 + polar(1, in))
    flag, ip = intersectionlines(tangent1..., tangent2...)
    if flag
        bp = BezierPathSegment(pt1, ip, ip, pt2)
    else
        cpt1 = pt1 + polar(1, out)
        cpt2 = pt2 + polar(1, in)
        bp = BezierPathSegment(pt1, cpt1, cpt2, pt2)
    end
    return bp
end

"""
    splitbezier(bps::BezierPathSegment, t)

Split the Bezier path segment at t, where t is between 0 and 1.

Use Paul de Casteljaus' algorithm (the man who really
introduced Bezier curves...).

Returns a tuple of two BezierPathSegments, the 'lower' one
(0 to `t`) followed by the 'higher' one (`t` to 1).

## Example

```julia
julia> bps = BezierPathSegment(ngon(O, 200, 4, vertices=true)...)
4-element BezierPathSegment:
 Point(1.2246467991473532e-14, 200.0)
 Point(-200.0, 2.4492935982947064e-14)
 Point(-3.6739403974420595e-14, -200.0)
 Point(200.0, -4.898587196589413e-14)

julia> l, h = splitbezier(bps::BezierPathSegment, 0.5)
(Point[Point(1.2246467991473532e-14, 200.0), Point(-100.0, 100.00000000000001), Point(-100.0, 1.4210854715202004e-14), Point(-50.00000000000001, -49.99999999999999)], Point[Point(-50.00000000000001, -49.99999999999999), Point(-1.4210854715202004e-14, -100.0), Point(99.99999999999999, -100.00000000000003), Point(200.0, -4.898587196589413e-14)])

julia> h
4-element BezierPathSegment:
 Point(-50.00000000000001, -49.99999999999999)
 Point(-1.4210854715202004e-14, -100.0)
 Point(99.99999999999999, -100.00000000000003)
 Point(200.0, -4.898587196589413e-14)

julia> l.p2 == h.p1
true
"""
function splitbezier(bps::BezierPathSegment, t)
    p1, cp1, cp2, p2 = bps.p1, bps.cp1, bps.cp2, bps.p2
    icp1 = (1.0 - t)p1 + (t * cp1)
    M = (1.0 - t)cp1 + (t * cp2) # unused center point
    icp4 = (1.0 - t)cp2 + (t * p2)
    icp2 = (1.0 - t)icp1 + (t * M)
    icp3 = (1.0 - t)M + (t * icp4)
    mp = (1.0 - t)icp2 + (t * icp3)
    return (BezierPathSegment(p1, icp1, icp2, mp), BezierPathSegment(mp, icp3, icp4, p2))
end

"""
    trimbezier(bps::BezierPathSegment, lowpt, highpt)

Chop the ends of a BezierPathSegment at `lowpt` and
`highpt`. `lowpt` and `highpt` should be between 0 and 1.

Returns a trimmed BezierPathSegment.
"""
function trimbezier(bps::BezierPathSegment, lowpt, highpt)
    if lowpt > highpt
        lowpt, highpt = highpt, lowpt
    end
    _, highptbezier = splitbezier(bps, lowpt)
    centerbezier, _ = splitbezier(highptbezier, highpt)
    return centerbezier
end

"""
    bezigon(corners::Array{Point,1}, sides;
        close = false,
        action = :none))

Construct a bezigon, a path made of Bezier curves.

`corners` is an array of points, the corners of the bezigon, eg this triangle:

```julia
[Point(0, 0), Point(50, 50), Point(100, 0)]
```

`sides` is an array of arrays of points, where each array contains two control
points, eg:

```julia
sides = [
    [Point(-10, -20), Point(40, -120)], # control points for first side
    [Point(120, -120), Point(180, -20)],
]
```

The first pair of `sides` (two points) are control points, which combine with
the first two points in corners to define a Bezier curve. And so on for the next pair.

Returns a path.
"""
function bezigon(pts::Array{Point,1}, sides;
        close = false,
        action = :none)
    if isempty(sides)
        sides = [[O, O]]
    end
    move(pts[1])
    for i in 1:length(pts)
        if i <= length(sides)
            cp1 = sides[mod1(i, end)][1]
            cp2 = sides[mod1(i, end)][2]
        else
            cp1 = pts[mod1(i, end)]
            cp2 = pts[mod1(i + 1, end)]
        end
        all(x -> x isa Point, [cp1, cp2]) && curve(cp1, cp2, pts[mod1(i + 1, end)])
    end
    if close
        closepath()
    end
    path = storepath()
    do_action(action)
    return path
end

bezigon(pts::Array{Point,1}, sides, the_action::Symbol; close::Bool=false) = begin
    bezigon(pts, sides, action = the_action, close = close)
end
