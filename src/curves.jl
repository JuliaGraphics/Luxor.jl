# arcs, circles, ellipses, curves, pie, sector, bezier

"""
    circle(x, y, r, action=:nothing)

Make a circle of radius `r` centred at `x`/`y`.

`action` is one of the actions applied by `do_action`, defaulting to `:nothing`. You can
also use `ellipse()` to draw circles and place them by their centerpoint.
"""
function circle(x, y, r, action=:nothing)
    if action != :path
      newpath()
    end
    Cairo.circle(currentdrawing.cr, x, y, r)
    do_action(action)
end

"""
    circle(pt, r, action)

Make a circle centred at `pt`.
"""
circle(centerpoint::Point, r, action=:nothing) =
  circle(centerpoint.x, centerpoint.y, r, action)

"""
    circle(pt1::Point, pt2::Point, action=:nothing)

Make a circle that passes through two points that define the diameter:
"""
function circle(pt1::Point, pt2::Point, action=:nothing)
  center = midpoint(pt1, pt2)
  radius = norm(pt1, pt2)/2
  circle(center, radius, action)
end

"""
    center3pts(a::Point, b::Point, c::Point)

Find the radius and center point for three points lying on a circle.

returns `(centerpoint, radius)` of a circle. Then you can use `circle()` to place a
circle, or `arc()` to draw an arc passing through those points.

If there's no such circle, then you'll see an error message in the console and the function
returns `(Point(0,0), 0)`.
"""
function center3pts(a::Point, b::Point, c::Point)
    midAB = midpoint(a, b)
    perpAB = perpendicular(a - b)
    midBC = midpoint(b, c)
    perpBC = perpendicular(b - c)
    # do the lines intersect?
    crossp = crossproduct(perpAB, perpBC)
    if isapprox(crossp, 0)
        info("no circle passes through all three points")
        return Point(0,0), 0
    end
    centerX = ((midAB.y * perpAB.x * perpBC.x) +
               (midBC.x * perpAB.x * perpBC.y) -
               (midAB.x * perpAB.y * perpBC.x) -
               (midBC.y * perpAB.x * perpBC.x)) / crossp
    centerY = ((centerX - midAB.x) * perpAB.y / perpAB.x)  + midAB.y
    radius = hypot(centerX - a.x, centerY - a.y)
    return Point(centerX, centerY), radius
end

"""
Make an ellipse, centered at `xc/yc`, fitting in a box of width `w` and height `h`.

    ellipse(xc, yc, w, h, action=:none)
"""
function ellipse(xc, yc, w, h, action=:none)
    x  = xc - w/2
    y  = yc - h/2
    kappa = .5522848 # ??? http://www.whizkidtech.redprince.net/bezier/circle/kappa/
    ox = (w / 2) * kappa  # control point offset horizontal
    oy = (h / 2) * kappa  # control point offset vertical
    xe = x + w            # x-end
    ye = y + h            # y-end
    xm = x + w / 2        # x-middle
    ym = y + h / 2        # y-middle
    move(x, ym)
    curve(x, ym - oy, xm - ox, y, xm, y)
    curve(xm + ox, y, xe, ym - oy, xe, ym)
    curve(xe, ym + oy, xm + ox, ye, xm, ye)
    curve(xm - ox, ye, x, ym + oy, x, ym)
    do_action(action)
end

"""
Make an ellipse, centered at point `c`, with width `w`, and height `h`.

    ellipse(cpt, w, h, action=:none)
"""
ellipse(c::Point, w, h, action=:none) = ellipse(c.x, c.y, w, h, action)

"""
Make a squircle (basically a rectangle with rounded corners). Specify the center position, horizontal radius (distance from center to a side), and vertical radius (distance from center to top or bottom):

    squircle(center::Point, hradius, vradius, action=:none; rt = 0.5, vertices=false)

The `rt` option defaults to 0.5, and gives an intermediate shape. Values less than 0.5 make the shape more square. Values above make the shape more round.
"""
function squircle(center::Point, hradius, vradius, action=:none;
    rt = 0.5,
    vertices=false,
    reversepath=false)
  points = Point[]
  for theta in 0:pi/40:2pi
      xpos = center.x + ^(abs(cos(theta)), rt) * hradius * sign(cos(theta))
      ypos = center.y + ^(abs(sin(theta)), rt) * vradius * sign(sin(theta))
      push!(points, Point(xpos, ypos))
  end
  if vertices
    return points
  end
  poly(points, action, close=true, reversepath=reversepath)
end

"""
Add an arc to the current path from `angle1` to `angle2` going clockwise.

    arc(xc, yc, radius, angle1, angle2, action=:nothing)

Angles are defined relative to the x-axis, positive clockwise.
"""
function arc(xc, yc, radius, angle1, angle2, action=:nothing)
  Cairo.arc(currentdrawing.cr, xc, yc, radius, angle1, angle2)
  do_action(action)
end

"""
Arc with centerpoint.

    arc(centerpoint::Point, radius, angle1, angle2, action=:nothing)
"""
arc(centerpoint::Point, radius, angle1, angle2, action=:nothing) =
  arc(centerpoint.x, centerpoint.y, radius, angle1, angle2, action)

"""
Add an arc to the current path from `angle1` to `angle2` going counterclockwise.

    carc(xc, yc, radius, angle1, angle2, action=:nothing)

Angles are defined relative to the x-axis, positive clockwise.
"""
function carc(xc, yc, radius, angle1, angle2, action=:nothing)
  Cairo.arc_negative(currentdrawing.cr, xc, yc, radius, angle1, angle2)
  do_action(action)
end

" Add an arc centered at `centerpoint` to the current path from `angle1` to `angle2` going counterclockwise."
carc(centerpoint::Point, radius, angle1, angle2, action=:nothing) =
  carc(centerpoint.x, centerpoint.y, radius, angle1, angle2, action)

"""
      arc2r(c1::Point, p2::Point, p3::Point, action=:nothing)

Make a circular arc centered at `c1` that starts at `p2` and ends at `p3`, going clockwise.

`c1`-`p2` really determines the radius. If `p3` doesn't lie on the circular path, it will be used only as an indication of the arc's length, rather than its position.
"""
function arc2r(c1::Point, p2::Point, p3::Point, action=:nothing)
    r = norm(c1, p2)
    startangle = atan2(p2.y - c1.y, p2.x - c1.x)
    endangle   = atan2(p3.y - c1.y, p3.x - c1.x)
    if endangle < startangle
       endangle = mod2pi(endangle + 2pi)
    end
    arc(c1, r, startangle, endangle, action)
end

"""
    carc2r(c1::Point, p2::Point, p3::Point, action=:nothing)

Make a circular arc centered at `c1` that starts at `p2` and ends at `p3`, going counterclockwise.

`c1`-`p2` really determines the radius. If `p3` doesn't lie on the circular path, it will be used only as an indication of the arc's length, rather than its position.
"""
function carc2r(c1::Point, p2::Point, p3::Point, action=:nothing)
    r = norm(c1, p2)
    startangle = atan2(p2.y - c1.y, p2.x - c1.x)
    endangle   = atan2(p3.y - c1.y, p3.x - c1.x)
    if startangle < startangle
       startangle = mod2pi(startangle + 2pi)
    end
    carc(c1, r, startangle, endangle, action)
end

"""
    sector(centerpoint::Point, innerradius, outerradius, startangle, endangle, action:none)

Draw an annular sector centered at `centerpoint`.
"""
function sector(centerpoint::Point, innerradius::Real, outerradius::Real, startangle::Real,
      endangle::Real, action::Symbol=:none)
    gsave()
    translate(centerpoint)
    newpath()
    move(innerradius * cos(startangle), innerradius * sin(startangle))
    line(outerradius * cos(startangle), outerradius * sin(startangle))
    arc(0, 0, outerradius, startangle, endangle,:none)
    line(innerradius * cos(endangle), innerradius * sin(endangle))
    carc(0, 0, innerradius, endangle, startangle, :none)
    closepath()
    do_action(action)
    grestore()
end

"Draw an annular sector centered at the origin."
sector(innerradius::Real, outerradius::Real, startangle::Real, endangle::Real, action::Symbol=:none) =
    sector(O, innerradius, outerradius, startangle, endangle, action)

"""
    sector(centerpoint::Point, innerradius, outerradius, startangle, endangle, cornerradius, action:none)

Draw an annular sector with rounded corners, basically a bent sausage shape, centered at `centerpoint`.

TODO: The results aren't 100% accurate at the moment. There are small discontinuities where
the curves join.

The cornerradius is reduced from the supplied value if neceesary to prevent overshoots.
"""
function sector(centerpoint::Point, innerradius::Real, outerradius::Real, startangle::Real,
    endangle::Real, cornerradius::Real, action::Symbol=:none)
    gsave()
    translate(centerpoint)
    # some work is done using polar coords to calculate the points

    # attempts to prevent pathological cases
    cornerradius = min(cornerradius, abs(outerradius-innerradius)/2)
    if endangle < startangle
        startangle, endangle = endangle, startangle
    end

    # TODO reduce given corner radius to prevent messes when spanning angle too small
    # 4 is a magic number
        while abs(endangle - startangle) < 4.0(atan2(cornerradius, innerradius))
            cornerradius *= 0.75
        end

    # first inner corner
    alpha1 = asin(cornerradius/(innerradius+cornerradius))
    p1p2center = (innerradius + cornerradius, startangle + alpha1)
    p1 = (innerradius, startangle + alpha1)
    p2 = (innerradius + cornerradius, startangle)
    # first outer
    alpha2 = asin(cornerradius/(outerradius-cornerradius))
    p3p4center = (outerradius - cornerradius, startangle + alpha2)
    p3 = (outerradius - cornerradius, startangle)
    p4 = (outerradius, startangle + alpha2)
    # last outer
    p5p6center = (outerradius - cornerradius, endangle - alpha2)
    p5 = (outerradius, endangle - alpha2)
    p6 = (outerradius - cornerradius, endangle)
    # last inner
    p7p8center = (innerradius + cornerradius, endangle - alpha1)
    p7 = (innerradius + cornerradius, endangle)
    p8 = (innerradius, endangle - alpha1)

    # make path
    move(@polar(p1))
    newpath()
    # inner corner
    arc(@polar(p1p2center), cornerradius, slope(@polar(p1p2center), @polar(p1)), slope(@polar(p1p2center), @polar(p2)), :none)
    line(@polar(p3))
    # outer corner
    arc(@polar(p3p4center), cornerradius, slope(@polar(p3p4center), @polar(p3)), slope(@polar(p3p4center), @polar(p4)), :none)
    # outside arc
    arc(O, outerradius, slope(O, @polar(p4)), slope(O, @polar(p5)), :none)
    # last outside corner
    arc(@polar(p5p6center), cornerradius, slope(@polar(p5p6center), @polar(p5)), slope(@polar(p5p6center), @polar(p6)), :none)
    line(@polar(p7))
    # last inner corner
    arc(@polar(p7p8center), cornerradius, slope(@polar(p7p8center), @polar(p7)), slope(@polar(p7p8center), @polar(p8)), :none)
    s1, s2 = slope(O, @polar(p8)), slope(O, @polar(p1))
    if s1 < s2
        s2 = mod2pi(s2 + 2pi)
    end
    carc(O, innerradius, s1, s2, :none)
    closepath()
    do_action(action)
    grestore()
end

"Draw an annular sector with rounded corners, centered at the current origin."
sector(innerradius::Real, outerradius::Real, startangle::Real, endangle::Real,
    cornerradius::Real, action::Symbol=:none) =
    sector(O, innerradius, outerradius, startangle, endangle, cornerradius, action)

"""
    pie(x, y, radius, startangle, endangle, action=:none)

Draw a pie shape centered at `x`/`y`. Angles start at the positive x-axis and are measured
clockwise.
"""
function pie(x, y, radius, startangle, endangle, action=:none)
    gsave()
    translate(x, y)
    newpath()
    move(0, 0)
    line(radius * cos(startangle), radius * sin(startangle))
    arc(0, 0, radius, startangle, endangle, :none)
    closepath()
    grestore()
    do_action(action)
end

"""
    pie(centerpoint, radius, startangle, endangle, action=:none)

Draw a pie shape centered at `centerpoint`.

Angles start at the positive x-axis and are measured clockwise.
"""
pie(centerpoint::Point, radius, startangle, endangle, action) =
    pie(centerpoint.x, centerpoint.y, radius, startangle, endangle, action)

"Draw a pie shape centered at the origin"
pie(radius, startangle, endangle, action=:none) = pie(O, radius, startangle, endangle, action)

"""
Add a Bézier curve.

     curve(x1, y1, x2, y2, x3, y3)
     curve(p1, p2, p3)

 The spline starts at the current position, finishing at `x3/y3` (`p3`), following two
 control points `x1/y1` (`p1`) and `x2/y2` (`p2`)

"""
curve(x1, y1, x2, y2, x3, y3) = Cairo.curve_to(currentdrawing.cr, x1, y1, x2, y2, x3, y3)
curve(pt1, pt2, pt3)          = curve(pt1.x, pt1.y, pt2.x, pt2.y, pt3.x, pt3.y)

"""
    circlepath(center::Point, radius, action=:none;
        reversepath=false,
        kappa = 0.5522847)

Draw a circle using Bézier curves.
"""
function circlepath(center::Point, radius, action=:none; reversepath=false, kappa = 0.5522847)
    function northtoeast(center::Point, radius, kappa)
        curve(center.x + (radius * kappa), center.y + radius, center.x + radius,
        center.y + (radius * kappa), center.x + radius, center.y )
    end

    function easttosouth(center::Point, radius, kappa)
        curve(center.x + radius, center.y - (radius * kappa), center.x + (radius * kappa),
        center.y - radius, center.x, center.y - radius)
    end

    function southtowest(center::Point, radius, kappa)
        curve(center.x - (radius * kappa), center.y - radius, center.x - radius,
        center.y - (radius * kappa), center.x - radius, center.y)
    end

    function westtonorth(center::Point, radius, kappa)
        curve(center.x - radius, center.y + (radius * kappa), center.x - (radius * kappa),
        center.y + radius, center.x, center.y + radius)
    end

    function northtowest(center::Point, radius, kappa)
        curve(center.x - (radius * kappa), center.y + radius, center.x - radius,
        center.y + (radius * kappa), center.x - radius, center.y )
    end

    function westtosouth(center::Point, radius, kappa)
        curve(center.x - radius, center.y - (radius * kappa), center.x - (radius * kappa),
        center.y - radius, center.x, center.y - radius )
    end

    function southtoeast(center::Point, radius, kappa)
        curve(center.x + (radius * kappa), center.y - radius, center.x + radius,
        center.y - (radius * kappa), center.x + radius, center.y)
    end

    function easttonorth(center::Point, radius, kappa)
        curve(center.x + radius, center.y + (radius * kappa), center.x + (radius * kappa),
        center.y + radius, center.x, center.y + radius )
    end

    move(center.x, center.y + radius)
    if !reversepath
        northtoeast(center, radius, kappa)
        easttosouth(center, radius, kappa)
        southtowest(center, radius, kappa)
        westtonorth(center, radius, kappa)
    else
        northtowest(center, radius, kappa)
        westtosouth(center, radius, kappa)
        southtoeast(center, radius, kappa)
        easttonorth(center, radius, kappa)
    end
    do_action(action)
end

"""
    ellipse(focus1::Point, focus2::Point, k, action=:none;
             stepvalue=pi/100,
             vertices=false,
             reversepath=false)

Build a polygon approximation to an ellipse, given two points and a distance, `k`, which is
the sum of the distances to the focii of any points on the ellipse (or the shortest length
of string required to go from one focus to the perimeter and on to the other focus).
"""
function ellipse(focus1::Point, focus2::Point, k, action=:none;
        stepvalue=pi/100,
        vertices=false,
        reversepath=false)
    a = k/2  # a = ellipse's major axis, the widest part
    cpoint = midpoint(focus1, focus2)
    dc = norm(focus1, cpoint)
    b = sqrt(abs(a^2 - dc^2)) # minor axis, hopefuly not 0
    phi = slope(O, focus2) # angle between the major axis and the x-axis
    points = Point[]
    drawing = false
    for t in 0:stepvalue:2pi
        xt = cpoint.x + a * cos(t) * cos(phi) - b * sin(t) * sin(phi)
        yt = cpoint.y + a * cos(t) * sin(phi) + b * sin(t) * cos(phi)
        push!(points, Point(xt, yt))
    end
    if vertices
        return points
    end
    poly(points, action, close=true, reversepath=reversepath)
end

"""
    hypotrochoid(R, r, d, action=:none;
            stepby=0.01,
            period=0,
            vertices=false)

Make a hypotrochoid with short line segments. (Like a Spirograph.) The curve is traced by a
point attached to a circle of radius `r` rolling around the inside  of a fixed circle of
radius `R`, where the point is a distance `d` from  the center of the interior circle.
Things get interesting if you supply non-integral values.

Special cases include the hypocycloid, if `d` = `r`, and an ellipse, if `R` = `2r`.

`stepby`, the angular step value, controls the amount of detail, ie the smoothness of the
polygon,

If `period` is not supplied, or 0, the lowest period is calculated for you.

The function can return a polygon (a list of points), or draw the points directly using
the supplied `action`. If the points are drawn, the function returns a tuple showing how
many points were drawn and what the period was (as a multiple of `pi`).
"""
function hypotrochoid(R, r, d, action=:none;
        stepby   = 0.01,
        period   = 0,
        vertices = false)
    function nextposition(t)
        x = (R - r) * cos(t) + (d * cos(((R - r)/r) * t))
        y = (R - r) * sin(t) - (d * sin(((R - r)/r) * t))
        return Point(x, y)
    end
    # try to calculate the period exactly
    if isapprox(period, 0)
        period = 2pi * (r/gcd(convert(Int, floor(R)), convert(Int, floor(r))))
    end
    counter=1
    points=Point[]
    for t = 0:stepby:period
        push!(points, nextposition(t))
    end
    # don't repeat end point if it's more or less the same as the start point
    if isapprox(points[1], points[end])
        pop!(points)
    end
    if vertices == false
        poly(points, action)
        return (length(points), period/pi)
    else
        return points
    end
end
# eof
