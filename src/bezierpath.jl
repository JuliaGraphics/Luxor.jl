"""
   findbeziercontrolpoints(previouspt::Point, pt1::Point, pt2::Point, nextpt::Point; smooth_value=0.5)

Find the Bèzier control points for a curve between `pt1` and `pt2`. We'll refer to the previous point before `pt1` and the next point after `pt2`.
"""
function findbeziercontrolpoints(previouspt::Point, pt1::Point, pt2::Point, nextpt::Point;
    smoothing=0.5)

    xc1  = (previouspt.x + pt1.x) / 2.0
    yc1 = (previouspt.y + pt1.y) / 2.0
    xc2 = (pt1.x + pt2.x) / 2.0
    yc2 = (pt1.y + pt2.y) / 2.0
    xc3 = (pt2.x + nextpt.x) / 2.0
    yc3 = (pt2.y + nextpt.y) / 2.0

    len1 = sqrt((pt1.x-previouspt.x) * (pt1.x-previouspt.x) + (pt1.y-previouspt.y) * (pt1.y-previouspt.y))
    len2 = sqrt((pt2.x-pt1.x) * (pt2.x-pt1.x) + (pt2.y-pt1.y) * (pt2.y-pt1.y))
    len3 = sqrt((nextpt.x-pt2.x) * (nextpt.x-pt2.x) + (nextpt.y-pt2.y) * (nextpt.y-pt2.y))

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
    makebezierpath(pgon::Array; smoothing=1)

Return a Bèzier path that follows an array of points. The Bèzier path is an array of
tuples; each tuple contains the four points that make up a section of the
path.
"""
function makebezierpath(pgon::Array; smoothing=1.0)
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

Draw a Bèzier path, and apply the action, such as `:none`, `:stroke`, `:fill`, etc. By
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
