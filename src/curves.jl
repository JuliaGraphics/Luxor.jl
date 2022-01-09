# arcs, circles, ellipses, curves, pie, sector, bezier

function circle(x::Real, y::Real, r::Real;
     action=:none)
    if action != :path
        newpath()
    end
    Cairo.arc(get_current_cr(), x, y, r, 0, 2pi)
    do_action(action)
    return (Point(x, y) - (r, r), Point(x, y) + (r, r))
end

"""
    circle(centerpoint::Point, r; action=:none)
    circle(centerpoint::Point, r, action)

Make a circle of radius `r` centered at 'centerpoint'.

`action` is one of the actions applied by `do_action`, defaulting to `:none`.

Returns a tuple of two points, the corners of a bounding box that encloses the circle.

You can also use `ellipse()` to draw circles and place them by their centerpoint.
"""
circle(centerpoint::Point, r::Real; action=:none) =
    circle(centerpoint.x, centerpoint.y, r, action=action)

circle(pt::Point, r::Real, action::Symbol) = circle(pt, r, action = action::Symbol)

circle(x::Real, y::Real, r::Real, action::Symbol) = circle(Point(x, y), r, action = action::Symbol)

"""
    circle(pt1::Point, pt2::Point; action=:none)
    circle(pt1::Point, pt2::Point, action)

Make a circle that passes through two points that define the diameter.
"""
function circle(pt1::Point, pt2::Point;
        action=:none)
    center = midpoint(pt1, pt2)
    radius = distance(pt1, pt2)/2
    circle(center, radius, action=action)
end

circle(pt1::Point, pt2::Point, action::Symbol) = circle(pt1, pt2, action=action)

"""
    circle(pt1::Point, pt2::Point, pt3::Point; action=:none)
    circle(pt1::Point, pt2::Point, pt3::Point, action)

Make a circle that passes through three points.
"""
function circle(pt1::Point, pt2::Point, pt3::Point;
        action=:none)
    center = midpoint(pt1, pt2)
    radius = distance(pt1, pt2)/2
    circle(center3pts(pt1, pt2, pt3)..., action=action)
end

circle(pt1::Point, pt2::Point, pt3::Point, action::Symbol) =
    circle(pt1, pt2, pt3; action=action)

"""
    center3pts(a::Point, b::Point, c::Point)

Find the radius and center point for three points lying on a circle.

returns `(centerpoint, radius)` of a circle.

If there's no such circle, the function returns `(Point(0, 0), 0)`.

If two of the points are the same, use `circle(pt1, pt2)` instead.
"""
function center3pts(p1::Point, p2::Point, p3::Point)
    norm2(p::Point) = (p.x)^2+(p.y)^2

    α1 = norm2(p3-p2)*(norm2(p2-p1)+norm2(p1-p3)-norm2(p3-p2))
    α2 = norm2(p1-p3)*(norm2(p3-p2)+norm2(p2-p1)-norm2(p1-p3))
    α3 = norm2(p2-p1)*(norm2(p1-p3)+norm2(p3-p2)-norm2(p2-p1))

    if α1+α2+α3 ≠ 0.0
        c = (α1*p1+α2*p2+α3*p3)/(α1+α2+α3)
        r = √(norm2(p1-c))
        return c, r
    else
        @warn "center3pts(): There are no circles which pass through $p1, $p2 and $p3."
        return (Point(0, 0), 0)
    end
end

function ellipse(xc::Real, yc::Real, w::Real, h::Real;
        action=:none)
    x  = xc - w/2
    y  = yc - h/2
    # kappa = 4.0 * (sqrt(2.0) - 1.0) / 3.0
    kappa = 0.5522847498307936
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
    return (Point(xc, yc) - (w/2, h/2), Point(xc, yc) + (w/2, h/2))
end

ellipse(xc::Real, yc::Real, w::Real, h::Real, action::Symbol) =
    ellipse(xc, yc, w, h, action=action)

"""
    ellipse(centerpoint::Point, w, h; action=:none)
    ellipse(centerpoint::Point, w, h; action)

Make an ellipse, centered at `centerpoint`, with width `w`, and height `h`.

Returns a tuple of two points, the corners of a bounding box that encloses the ellipse. 
"""
ellipse(c::Point, w::Real, h::Real; action=:none) = ellipse(c.x, c.y, w, h, action=action)

ellipse(c::Point, w::Real, h::Real, action::Symbol) = ellipse(c, w, h, action=action)

"""
    squircle(center::Point, hradius, vradius;
        action=:none,
        rt = 0.5, stepby = pi/40, vertices=false)
    squircle(center::Point, hradius, vradius, action;
        rt = 0.5, stepby = pi/40, vertices=false)

Make a squircle or superellipse (basically a rectangle with rounded corners).
Specify the center position, horizontal radius (distance from center to a side),
and vertical radius (distance from center to top or bottom):

The root (`rt`) option defaults to 0.5, and gives an intermediate shape. Values
less than 0.5 make the shape more rectangular. Values above make the shape more
round. The horizontal and vertical radii can be different.
"""
function squircle(center::Point, hradius::Real, vradius::Real;
        action=:none,
        rt = 0.5,
        vertices=false,
        stepby = pi/40,
        reversepath=false)
    points = Point[]
    for theta in 0:stepby:2pi
        xpos = center.x + ^(abs(cos(theta)), rt) * hradius * sign(cos(theta))
        ypos = center.y + ^(abs(sin(theta)), rt) * vradius * sign(sin(theta))
        push!(points, Point(xpos, ypos))
    end
    result = reversepath ? reverse(points) : points
    if !vertices
        poly(points, action, close=true, reversepath=reversepath)
    end
    return result
end

squircle(center::Point, hradius::Real, vradius::Real, action::Symbol;
        rt = 0.5,
        vertices=false,
        stepby = pi/40,
        reversepath=false) =
    squircle(center, hradius, vradius;
        action=action,
        rt = rt,
        vertices=false,
        stepby = pi/40,
        reversepath=false)

function arc(xc, yc, radius, angle1, angle2;
        action=:none)
    Cairo.arc(get_current_cr(), xc, yc, radius, angle1, angle2)
    do_action(action)
end

arc(xc, yc, radius, angle1, angle2, the_action::Symbol) =
    arc(xc, yc, radius, angle1, angle2, action=the_action)

"""
    arc(centerpoint::Point, radius, angle1, angle2; action=:none)
    arc(centerpoint::Point, radius, angle1, angle2, action)

Add an arc to the current path from `angle1` to `angle2` going clockwise, centered
at `centerpoint`.

Angles are defined relative to the x-axis, positive clockwise.
"""
arc(centerpoint::Point, radius, angle1, angle2; action=:none) =
    arc(centerpoint.x, centerpoint.y, radius, angle1, angle2, action=action)

arc(centerpoint::Point, radius, angle1, angle2, action::Symbol) =
    arc(centerpoint.x, centerpoint.y, radius, angle1, angle2, action=action)


function carc(xc, yc, radius, angle1, angle2;
        action=:none)
    Cairo.arc_negative(get_current_cr(), xc, yc, radius, angle1, angle2)
    do_action(action)
end

"""
    carc(centerpoint::Point, radius, angle1, angle2; action=:none)
    carc(centerpoint::Point, radius, angle1, angle2, action)

Add an arc centered at `centerpoint` to the current path from `angle1` to
`angle2`, going counterclockwise.

Angles are defined relative to the x-axis, positive clockwise.
"""
carc(centerpoint::Point, radius, angle1, angle2; action=:none) =
    carc(centerpoint.x, centerpoint.y, radius, angle1, angle2, action=action)

carc(centerpoint::Point, radius, angle1, angle2, action::Symbol) =
    carc(centerpoint.x, centerpoint.y, radius, angle1, angle2, action=action)

carc(x::Real, y::Real, radius, angle1, angle2, action::Symbol=:none) =
    carc(x, y, radius, angle1, angle2, action=action)

"""
      arc2r(c1::Point, p2::Point, p3::Point; action=:none)
      arc2r(c1::Point, p2::Point, p3::Point, action)

Add a circular arc centered at `c1` that starts at `p2` and ends at `p3`, going clockwise,
to the current path.

`c1`-`p2` really determines the radius. If `p3` doesn't lie on the circular path,
 it will be used only as an indication of the arc's length, rather than its position.
"""
function arc2r(c1::Point, p2::Point, p3::Point;
        action=:none)
    r = distance(c1, p2)
    startangle = atan(p2.y - c1.y, p2.x - c1.x)
    endangle   = atan(p3.y - c1.y, p3.x - c1.x)
    if endangle < startangle
        endangle = mod2pi(endangle + 2pi)
    end
    arc(c1, r, startangle, endangle, action=action)
end

arc2r(c1::Point, p2::Point, p3::Point, action::Symbol) = arc2r(c1, p2, p3, action = action)

"""
    carc2r(c1::Point, p2::Point, p3::Point; action=:none)

Add a circular arc centered at `c1` that starts at `p2` and ends at `p3`,
going counterclockwise, to the current path.

`c1`-`p2` really determines the radius. If `p3` doesn't lie on the circular
path, it will be used only as an indication of the arc's length, rather than its position.
"""
function carc2r(c1::Point, p2::Point, p3::Point;
        action=:none)
    r = distance(c1, p2)
    startangle = atan(p2.y - c1.y, p2.x - c1.x)
    endangle   = atan(p3.y - c1.y, p3.x - c1.x)
    if startangle < endangle
        startangle = mod2pi(startangle + 2pi)
    end
    carc(c1, r, startangle, endangle, action=action)
end

carc2r(c1::Point, p2::Point, p3::Point, action::Symbol) = carc2r(c1, p2, p3, action = action)

"""
    isarcclockwise(c::Point, A::Point, B::Point)

Return `true` if an arc centered at `c` going from `A` to `B` is clockwise.

If `c`, `A`, and `B` are collinear, then a hemispherical arc could be
either clockwise or not.
"""
function isarcclockwise(c::Point, A::Point, B::Point)
    a = A - c
    b = B - c
    return crossproduct(a, b) > 0
end

"""
    sector(centerpoint::Point, innerradius, outerradius, startangle, endangle;
        action=:none)

Draw an annular sector centered at `centerpoint`.

"""
function sector(centerpoint::Point, innerradius::Real, outerradius::Real,
                startangle::Real, endangle::Real;
                    action=:none)
    (innerradius > outerradius) && throw(DomainError(outerradius, "outer radius must be larger than inner radius $(innerradius)"))
    gsave()
    translate(centerpoint)
    newpath()
    move(innerradius * cos(startangle), innerradius * sin(startangle))
    line(outerradius * cos(startangle), outerradius * sin(startangle))
    arc(0, 0, outerradius, startangle, endangle, action=:none)
    line(innerradius * cos(endangle), innerradius * sin(endangle))
    carc(0, 0, innerradius, endangle, startangle, action=:none)
    closepath()
    grestore()
    do_action(action)
end

sector(centerpoint::Point, innerradius::Real, outerradius::Real,
    startangle::Real, endangle::Real, action::Symbol) =
    sector(centerpoint, innerradius, outerradius, startangle, endangle, action=action)

"""
    sector(innerradius::Real, outerradius::Real, startangle::Real, endangle::Real;
       action=:none)

Draw an annular sector centered at the origin.
"""
sector(innerradius::Real, outerradius::Real, startangle::Real, endangle::Real;
        action=:none) =
    sector(O, innerradius, outerradius, startangle, endangle, action=action)

sector(innerradius::Real, outerradius::Real, startangle::Real, endangle::Real, action::Symbol) =
    sector(innerradius, outerradius, startangle, endangle, action=action)

"""
    sector(centerpoint::Point, innerradius, outerradius,
            startangle, endangle, cornerradius;
           action:none)

Draw an annular sector with rounded corners, basically a bent sausage shape,
centered at `centerpoint`.

TODO: The results aren't 100% accurate at the moment. There are small
discontinuities where the curves join.

The cornerradius is reduced from the supplied value if neceesary to prevent overshoots.
"""
function sector(centerpoint::Point, innerradius::Real, outerradius::Real, startangle::Real,
                endangle::Real, cornerradius::Real;
                    action=:none)
    (innerradius > outerradius) && throw(DomainError(outerradius, "outer radius must be larger than inner radius $(innerradius)"))
    gsave()
    translate(centerpoint)
    # some work is done using polar coords to calculate the points

    # attempts to prevent pathological cases
    cornerradius = min(cornerradius, abs(outerradius-innerradius)/2)
    if endangle < startangle
        endangle = mod2pi(endangle + 2pi)
    end

    # TODO reduce given corner radius to prevent messes when spanning angle too small
    # 4 is a magic number
    while abs(endangle - startangle) < 4.0(atan(cornerradius, innerradius))
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
    arc(@polar(p1p2center), cornerradius, slope(@polar(p1p2center), @polar(p1)),
        slope(@polar(p1p2center), @polar(p2)), action=:none)
    line(@polar(p3))
    # outer corner
    arc(@polar(p3p4center), cornerradius, slope(@polar(p3p4center), @polar(p3)),
        slope(@polar(p3p4center), @polar(p4)), action=:none)
    # outside arc
    arc(O, outerradius, slope(O, @polar(p4)), slope(O, @polar(p5)), action=:none)
    # last outside corner
    arc(@polar(p5p6center), cornerradius, slope(@polar(p5p6center), @polar(p5)),
        slope(@polar(p5p6center), @polar(p6)), action=:none)
    line(@polar(p7))
    # last inner corner
    arc(@polar(p7p8center), cornerradius, slope(@polar(p7p8center), @polar(p7)),
        slope(@polar(p7p8center), @polar(p8)), action=:none)
    s1, s2 = slope(O, @polar(p8)), slope(O, @polar(p1))
    if s1 < s2
        s2 = mod2pi(s2 + 2pi)
    end
    carc(O, innerradius, s1, s2, action=:none)
    closepath()
    do_action(action)
    grestore()
end

sector(centerpoint::Point, innerradius::Real, outerradius::Real, startangle::Real, endangle::Real,
    cornerradius::Real, action::Symbol) = sector(centerpoint,
    innerradius, outerradius, startangle, endangle,
    cornerradius, action=action)

"""
    sector(innerradius::Real, outerradius::Real, startangle::Real, endangle::Real,
       cornerradius::Real, action)

Draw an annular sector with rounded corners, centered at the current origin.
"""
sector(innerradius::Real, outerradius::Real, startangle::Real, endangle::Real,
       cornerradius::Real, action::Symbol) =
    sector(O, innerradius, outerradius, startangle, endangle, cornerradius, action=action)

sector(innerradius::Real, outerradius::Real, startangle::Real, endangle::Real, cornerradius::Real; action=:stroke) =
    sector(O, innerradius, outerradius, startangle, endangle, cornerradius, action=action)

"""
    pie(x, y, radius, startangle, endangle; action=:none)
    pie(centerpoint, radius, startangle, endangle; action=:none)

Draw a pie shape centered at `x`/`y`. Angles start at the positive x-axis and
are measured clockwise.
"""
function pie(x::Real, y::Real, radius::Real, startangle::Real, endangle::Real;
        action=:none)
    gsave()
    translate(x, y)
    newpath()
    move(0, 0)
    line(radius * cos(startangle), radius * sin(startangle))
    arc(0, 0, radius, startangle, endangle, action=:none)
    closepath()
    grestore()
    do_action(action)
end

pie(x::Real, y::Real, radius::Real, startangle::Real, endangle::Real, action::Symbol) =
    pie(x, y, radius, startangle, endangle, action=action)

pie(centerpoint::Point, radius::Real, startangle::Real, endangle::Real; action=:none) =
    pie(centerpoint.x, centerpoint.y, radius, startangle, endangle, action=action)

"""
    pie(centerpoint::Point, radius::Real, startangle::Real, endangle::Real, action::Symbol)
"""
pie(centerpoint::Point, radius::Real, startangle::Real, endangle::Real, action::Symbol) =
    pie(centerpoint.x, centerpoint.y, radius, startangle, endangle, action=action)

"""
    pie(radius, startangle, endangle;
        action=:none)

Draw a pie shape centered at the origin
"""
pie(radius::Real, startangle::Real, endangle::Real; action=:none) =
    pie(O, radius, startangle, endangle, action=action)

pie(radius::Real, startangle::Real, endangle::Real, action::Symbol) =
    pie(O, radius, startangle, endangle, action=action)

"""
    curve(x1, y1, x2, y2, x3, y3)
    curve(p1, p2, p3)

Add a Bézier curve.

The spline starts at the current position, finishing at `x3/y3` (`p3`),
following two control points `x1/y1` (`p1`) and `x2/y2` (`p2`).
"""
curve(x1, y1, x2, y2, x3, y3) = Cairo.curve_to(get_current_cr(), x1, y1, x2, y2, x3, y3)
curve(pt1, pt2, pt3)          = curve(pt1.x, pt1.y, pt2.x, pt2.y, pt3.x, pt3.y)

"""
    circlepath(center::Point, radius;
        action=:none,
        reversepath=false,
        kappa = 0.5522847498307936)
    circlepath(center::Point, radius, action;
        reversepath=false,
        kappa = 0.5522847498307936)

Draw a circle using Bézier curves. One benefit of using this
rather than `circle()` is that you can use the `reversepath`
option to draw the circle clockwise rather than
`circle`'s counterclockwise.

The magic value, `kappa`, is `4.0 * (sqrt(2.0) - 1.0) / 3.0`.
"""
function circlepath(center::Point, radius;
        action=:none,
        reversepath=false,
        kappa = 0.5522847498307936)
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

circlepath(center::Point, radius, action::Symbol; reversepath=false, kappa = 0.5522847498307936) = circlepath(center, radius;
                action=action,
                reversepath=reversepath,
                kappa = kappa)

"""
    ellipse(focus1::Point, focus2::Point, k;
            action=:none,
            stepvalue=pi/100,
            vertices=false,
            reversepath=false)

Build a polygon approximation to an ellipse, given two points and a distance, `k`, which is
the sum of the distances to the focii of any points on the ellipse (or the shortest length
of string required to go from one focus to the perimeter and on to the other focus).
"""
function ellipse(focus1::Point, focus2::Point, k;
            action=:none,
            stepvalue=pi/100,
            vertices=false,
            reversepath=false)
    a = k/2  # a = ellipse's major axis, the widest part
    cpoint = midpoint(focus1, focus2)
    dc = distance(focus1, cpoint)
    b = sqrt(abs(a^2 - dc^2)) # minor axis, hopefuly not 0
    phi = slope(focus1, focus2) # angle between the major axis and the x-axis
    points = Point[]
    drawing = false
    for t in 0:stepvalue:2pi
        xt = cpoint.x + a * cos(t) * cos(phi) - b * sin(t) * sin(phi)
        yt = cpoint.y + a * cos(t) * sin(phi) + b * sin(t) * cos(phi)
        push!(points, Point(xt, yt))
    end
    vertices ? points : poly(points, action, close=true, reversepath=reversepath)
end

ellipse(f1::Point, f2::Point, k, action::Symbol;
        stepvalue=pi/100,
        vertices=false,
        reversepath=false) =
    ellipse(f1, f2, k,
        action=action,
        stepvalue=stepvalue,
        vertices=vertices,
        reversepath=reversepath)

"""
    ellipse(focus1::Point, focus2::Point, pt::Point;
        action=:none,
        stepvalue=pi/100,
        vertices=false,
        reversepath=false)

Build a polygon approximation to an ellipse, given two points and a point somewhere on the
ellipse.
"""
function ellipse(focus1::Point, focus2::Point, pt::Point;
            action=:none,
            stepvalue=pi/100,
            vertices=false,
            reversepath=false)
    k = distance(focus1, pt) + distance(focus2, pt)
    ellipse(focus1, focus2, k, action=action, stepvalue=stepvalue,
        vertices=vertices, reversepath=reversepath)
end

ellipse(focus1::Point, focus2::Point, pt::Point, action::Symbol;
            stepvalue=pi/100,
            vertices=false,
            reversepath=false) = ellipse(focus1, focus2, pt;
        action=action,
        stepvalue=stepvalue,
        vertices=vertices,
        reversepath=reversepath)

"""
    hypotrochoid(R, r, d;
        action=:none,
        stepby=0.01,
        period=0.0,
        vertices=false)
    hypotrochoid(R, r, d, action;
        stepby=0.01,
        period=0.0,
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
function hypotrochoid(R, r, d;
            action=:none,
            close    = true,
            stepby   = 0.01,
            period   = 0.0,
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
    isapprox(points[1], points[end]) && pop!(points)
    vertices ? points : (poly(points, action, close=close); (length(points), period/pi))
end

hypotrochoid(R, r, d, action::Symbol;
            close    = true,
            stepby   = 0.01,
            period   = 0.0,
            vertices = false) = hypotrochoid(R, r, d;
                        action= action,
                        close    = close,
                        stepby   = stepby,
                        period   = period,
                        vertices = vertices)

"""
    epitrochoid(R, r, d;
        action=:none,
        stepby=0.01,
        period=0,
        vertices=false)
    epitrochoid(R, r, d, action;
        stepby=0.01,
        period=0,
        vertices=false)

Make a epitrochoid with short line segments. (Like a Spirograph.) The curve is traced by a
point attached to a circle of radius `r` rolling around the outside of a fixed circle of
radius `R`, where the point is a distance `d` from the center of the circle.
Things get interesting if you supply non-integral values.

`stepby`, the angular step value, controls the amount of detail, ie the smoothness of the
polygon.

If `period` is not supplied, or 0, the lowest period is calculated for you.

The function can return a polygon (a list of points), or draw the points directly using
the supplied `action`. If the points are drawn, the function returns a tuple showing how
many points were drawn and what the period was (as a multiple of `pi`).
"""
function epitrochoid(R, r, d;
            action   = :none,
            close    = true,
            stepby   = 0.01,
            period   = 0,
            vertices = false)
    function nextposition(t)
        x = (R + r) * cos(t) - (d * cos(((R - r)/r) * t))
        y = (R + r) * sin(t) - (d * sin(((R - r)/r) * t))
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
    isapprox(points[1], points[end]) && pop!(points)
    vertices ? points : (poly(points, action, close=close); (length(points), period/pi))
end

epitrochoid(R, r, d, action::Symbol;
            close    = true,
            stepby   = 0.01,
            period   = 0.0,
            vertices = false) = epitrochoid(R, r, d;
                        action= action,
                        close    = close,
                        stepby   = stepby,
                        period   = period,
                        vertices = vertices)

"""
    spiral(a, b;
        action = :none,
        stepby = 0.01,
        period = 4pi,
        vertices = false,
        log =false)
    spiral(a, b, action;
        stepby = 0.01,
        period = 4pi,
        vertices = false,
        log =false)

Make a spiral. The two primary parameters `a` and `b` determine the start radius, and the
tightness.

For linear spirals (`log=false`), `b` values are:

    lituus: -2

    hyperbolic spiral: -1

    Archimedes' spiral: 1

    Fermat's spiral: 2

For logarithmic spirals (`log=true`):

    golden spiral: b = ln(phi)/ (pi/2) (about 0.30)

Values of `b` around 0.1 produce tighter, staircase-like spirals.
"""
function spiral(a, b;
        action=:none,
        stepby = 0.01,
        period = 4pi,
        vertices = false,
        log=false)
    function nextpositionlog(t)
        ebt = exp(t * b)
        if abs(ebt) < 10^8 # arbitrary cutoff to avoid NaNs and Infs
            x = a * ebt * cos(t)
            y = a * ebt * sin(t)
            return Point(x, y)
        else
            return nothing
        end
    end
    function nextpositionlin(t)
        tpn = t ^ (1/b)
        if tpn < 10^8
            x = a * tpn * cos(t)
            y = a * tpn * sin(t)
            return Point(x, y)
        else
            return nothing
        end
    end
    log ? nextpos=nextpositionlog : nextpos = nextpositionlin
    points = Point[]
    for t = 0:stepby:period
        pt = nextpos(t)
        if isa(nextpos(t), Point)
            push!(points, pt)
        end
    end
    if vertices == false
        poly(points, action) # no close by default :)
    end
    return points
end

spiral(a, b, action::Symbol;
        stepby = 0.01,
        period = 4pi,
        vertices = false,
        log=false) = spiral(a, b;
                action=action,
                stepby = stepby,
                period = period,
                vertices = vertices,
                log=log)
"""
    intersection2circles(pt1, r1, pt2, r2)

Find the area of intersection between two circles, the first centered at `pt1` with radius
`r1`, the second centered at `pt2` with radius `r2`.

If one circle is entirely within another, that circle's area is returned.
"""
function intersection2circles(pt1, rad1, pt2, rad2)
    # via casey and jùlio on slack
    # squared radii
    rr1, rr2 = rad1 * rad1, rad2 * rad2
    d = distance(pt1, pt2)

    # trivial cases
    d ≥ rad1 + rad2      && return 0.0
    d ≤ abs(rad2 - rad1) && return π * min(rr1, rr2)

    # First center point to the middle line
    a_distancecenterfirst = (rr1 - rr2 + (d^2)) / (2d)

    # Second centre point to the middle line
    b_distancecentersecond = d - a_distancecenterfirst

    # Half of the middle line
    h_height = sqrt(rr1 - a_distancecenterfirst^2)

    # central angle for the first circle
    alpha = mod2pi(atan(h_height, a_distancecenterfirst) * 2.0 + 2π)

    # Central angle for the second circle
    beta = mod2pi(atan(h_height, b_distancecentersecond) * 2.0 + 2π)

    #  Area of the first circular segment
    A1 = rr1 / 2.0 * (alpha - sin(alpha))
    # Area of the second circular segment
    A2 = rr2 / 2.0 * (beta - sin(beta))
    return A1 + A2
end

"""
    intersectioncirclecircle(cp1, r1, cp2, r2)

Find the two points where two circles intersect, if they do. The first circle is centered
at `cp1` with radius `r1`, and the second is centered at `cp1` with radius `r1`.

Returns

    (flag, ip1, ip2)

where `flag` is a Boolean `true` if the circles intersect at the points `ip1` and `ip2`. If
the circles don't intersect at all, or one is completely inside the other, `flag` is `false`
and the points are both Point(0, 0).

Use `intersection2circles()` to find the area of two overlapping circles.

In the pure world of maths, it must be possible that two circles 'kissing' only have a
single intersection point. At present, this unromantic function reports that two kissing
circles have no intersection points.
"""
function intersectioncirclecircle(cp1, r1, cp2, r2)
    r1squared = r1^2
    r2squared = r2^2
    d = distance(cp1, cp2)
    if d > (r2 + r1) # circles do not overlap
        return (false, O, O)
    elseif (d <= abs(r1 - r2)) && (r1 >= r2)
        # second circle is completely inside first circle
        return (false, O, O)
    elseif (d <= abs(r1 - r2)) && (r1 < r2)
        # first circle is completely inside second circle
        return (false, O, O)
    end
    a = (r1squared - r2squared + d^2) / 2d
    h = sqrt(r1squared - a^2)
    p0 = cp1 + a * (cp2 - cp1)/d
    p3 = Point(
            p0.x + h * (cp2.y - cp1.y )/d,
            p0.y - h * (cp2.x - cp1.x )/d)
    p4 = Point(
            p0.x - h * (cp2.y - cp1.y )/d,
            p0.y + h * (cp2.x - cp1.x )/d)
    return (true, p3, p4)
end

"""
    circlepointtangent(through::Point, radius, targetcenter::Point, targetradius)

Find the centers of up to two circles of radius `radius` that pass through point
`through` and are tangential to a circle that has radius `targetradius` and
center `targetcenter`.

This function returns a tuple:

* (0, O, O)      - no circles exist

* (1, pt1, O)    - 1 circle exists, centered at pt1

* (2, pt1, pt2)  - 2 circles exist, with centers at pt1 and pt2

(The O are just dummy points so that three values are always returned.)
"""
function circlepointtangent(through::Point, radius, targetcenter::Point, targetradius)
    distx = targetcenter.x - through.x
    disty = targetcenter.y - through.y
    dsq = distance(through, targetcenter)^2
    if isless(dsq, 10e-6) # coincident
        return (0, O, O)
    else
        sqinv=0.5/dsq
        s = dsq - ((2radius + targetradius) * targetradius)
        root = 4(radius^2) * dsq - s^2
        s *= sqinv
        if isless(dsq, 0.0) # no center possible
            return (0, O, O)
        else
            if isless(root, 10e-6) # only one circle possible
                x = through.x + distx * s
                y = through.y + disty * s
                if isless(abs(distance(through, Point(x, y)) - radius), 10e-6)
                    return (1, Point(x, y), O)
                else
                    return (0, O, O)
                end
            else # two circles are possible
                root = sqrt(root) * sqinv
                xconst = through.x + distx * s
                yconst = through.y + disty * s
                xvar = disty * root
                yvar = distx * root
            return (2, Point(xconst - xvar, yconst + yvar), Point(xconst + xvar, yconst - yvar))
            end
        end
    end
end

"""
    circletangent2circles(radius, circle1center::Point, circle1radius, circle2center::Point, circle2radius)

Find the centers of up to two circles of radius `radius` that are tangent to the
two circles defined by `circle1...` and `circle2...`. These two circles can
overlap, but one can't be inside the other.

* (0, O, O)      - no such circles exist

* (1, pt1, O)    - 1 circle exists, centered at pt1

* (2, pt1, pt2)  - 2 circles exist, with centers at pt1 and pt2

(The O are just dummy points so that three values are always returned.)
"""
function circletangent2circles(radius, circle1center::Point, circle1radius, circle2center::Point, circle2radius)
    modradius1 = radius + circle1radius
    modradius2 = circle2radius - circle1radius
    return circlepointtangent(circle1center, modradius1, circle2center, modradius2)
end

"""
    arc2sagitta(p1::Point, p2::Point, s;
        action=:none)

Make a clockwise arc starting at `p1` and ending at `p2` that reaches a height of `s`, the sagitta, at the middle. Might append to current path...

Return tuple of the center point and the radius of the arc.
"""
function arc2sagitta(p1::Point, p2::Point, s::Real;
        action=:none)
    if isapprox(s, 0.0)
        throw(error("Height of arc $s should be greater than 0.0"))
    end
    l = distance(p1, p2)/2
    r = (s^2 + l^2) / 2s
    flag, ip1, ip2 = intersectioncirclecircle(p1, r, p2, r)
    if flag
        if r <= s
            arc2r(ip1, p1, p2, action=action)
            result = (ip1, r)
        else
            arc2r(ip2, p1, p2, action=action)
            result = (ip2, r)
        end
    else
        result = (O, 0.0)
    end
    return result
end

arc2sagitta(p1::Point, p2::Point, s::Real, action::Symbol) =  arc2sagitta(p1, p2, s; action=action)

"""
    carc2sagitta(p1::Point, p2::Point, s;
        action=:none)

Make a counterclockwise arc starting at `p1` and ending at `p2` that reaches a height of `s`, the sagitta, at the middle. Might append to current path...

Return tuple of center point and radius of arc.
"""
function carc2sagitta(p1::Point, p2::Point, s::Real;
        action=:none)
    if isapprox(s, 0.0)
        throw(error("Height of arc $s should be greater than 0.0"))
    end
    l = distance(p1, p2)/2
    r = (s^2 + l^2) / 2s
    flag, ip1, ip2 = intersectioncirclecircle(p1, r, p2, r)
    if flag
        if r <= s
            carc2r(ip2, p1, p2, action=action)
            result = (ip1, r)
        else
            carc2r(ip1, p1, p2, action=action)
            result = (ip2, r)
        end
    else
        result = (O, 0.0)
    end
    return result
end

carc2sagitta(p1::Point, p2::Point, s::Real, action::Symbol) =  carc2sagitta(p1, p2, s; action=action)

"""
    circlecircleoutertangents(cpt1::Point, r1, cpt2::Point, r2)

Return four points, `p1`, `p2, `p3`, `p4`, where a line
through `p1` and `p2`, and a line through `p3` and `p4`, form the outer
tangents to the circles defined by `cpt1/r1` and `cpt2/r2`.

Returns four identical points (`O`) if one of the circles lies inside the other.
"""
function circlecircleoutertangents(cpt1::Point, r1, cpt2::Point, r2)
    dx = cpt2.x - cpt1.x
    dy = cpt2.y - cpt1.y
    dist = distance(cpt1, cpt2)

    if dist <= abs(r2 - r1)
        # the circles overlap, no tangents
        @debug "circlecircleoutertangents: circles overlap"
        return O, O, O, O
    end

    # rotation from the x-axis.
    angle1 = atan(dy, dx)

    # relative angle of the normals
    angle2 = acos((r1 - r2)/dist)

    pt1 = Point(cpt1.x + r1 * cos(angle1 + angle2),
        cpt1.y + r1 * sin(angle1 + angle2))

    pt2 = Point(cpt2.x + r2 * cos(angle1 + angle2),
        cpt2.y + r2 * sin(angle1 + angle2))

    pt3 = Point(cpt1.x + r1 * cos(angle1 - angle2),
        cpt1.y + r1 * sin(angle1 - angle2))

    pt4 = Point(cpt2.x + r2 * cos(angle1 - angle2),
        cpt2.y + r2 * sin(angle1 - angle2))

    return pt1, pt2, pt3, pt4
end

"""
    pointcircletangent(point::Point, circlecenter::Point, circleradius)

Find the two points on a circle that lie on tangent lines
passing through an external point.

If both points are O, the external point is inside the
circle, and the result is `(O, O)`.
"""
function pointcircletangent(point::Point, circlecenter::Point, circleradius)
    d = distance(circlecenter, point)
    if d <= circleradius # isinside
        @debug "pointcircletangent: external point is inside circle"
        # for type stability, return two points anyway?
        return O, O
    end
    dx, dy = point.x - circlecenter.x, point.y - circlecenter.y
    dxr, dyr = -dy, dx # rotate
    ρ = circleradius/d
    ad = ρ^2
    bd = ρ * sqrt(1 - ρ^2)
    tangentpoint1x = circlecenter.x + (ad * dx) + (bd * dxr)
    tangentpoint1y = circlecenter.y + (ad * dy) + (bd * dyr)
    tangentpoint2x = circlecenter.x + (ad * dx) - (bd * dxr)
    tangentpoint2y = circlecenter.y + (ad * dy) - (bd * dyr)
    return Point(tangentpoint1x, tangentpoint1y), Point(tangentpoint2x, tangentpoint2y)
end

"""
circlecircleinnertangents(circle1center::Point, circle1radius, circle2center::Point, circle2radius)

Find the inner tangents of two circles. These are tangent lines that
cross as they skim past one circle and touch the other.

Returns the four points: tangentpoint1 on circle 1,
tangentpoint1 on circle2, tangentpoint2 on circle 1,
tangentpoint2 on circle2.

Returns `(O, O, O, O)` if inner tangents can't be found (eg when the circles overlap).

Use `circlecircleoutertangents()` to find the outer tangents.
"""
function circlecircleinnertangents(circle1center::Point, circle1radius, circle2center::Point, circle2radius)
    # point where the inner tangents will cross
    ip = (circle2center * circle1radius + circle1center * circle2radius) / (circle1radius + circle2radius)
    d = distance(circle1center, circle2center)
    # circles overlap?
    d <= (circle1radius + circle2radius) && return O, O, O, O
    tp1, tp2 = pointcircletangent(ip, circle1center, circle1radius)
    tp3, tp4 = pointcircletangent(ip, circle2center, circle2radius)
    # double check tp1 and tp3 are collinear, just in case the order was wrong
    if slope(tp1, ip) ≈ slope(ip, tp3)
        return tp1, tp3, tp2, tp4
    elseif slope(tp1, ip) ≈ slope(ip, tp4)
        return tp1, tp4, tp2, tp3
    end
end

"""
    ellipseinquad(qgon; action=:none)
    ellipseinquad(qgon, action)

Calculate a Bézier-based ellipse that fits inside the
quadrilateral `qgon`, an array of with at least four Points,
then apply `action`.

Returns `ellipsecenter, ellipsesemimajor, ellipsesemiminor,
ellipseangle`:

`ellipsecenter` the ellipse center

`ellipsesemimajor` ellipse semimajor axis

`ellipsesemiminor` ellipse semiminor axis

`ellipseangle` ellipse rotation

The function returns `O, 0, 0, 0` if a suitable ellipse
can't be found. (The qgon is probably not a convex polygon.)

## Examples

```julia
ellipseinquad(box(O, 130, 130); action=:stroke)

ellipseinquad(box(O, 140, 230), :stroke)
```

### References

http://faculty.mae.carleton.ca/John_Hayes/Papers/InscribingEllipse.pdf
"""
function ellipseinquad(qgon;
        action=:none)
    p1, p2, p3, p4 = qgon
    length(unique([p1, p2, p3, p4])) != 4 && throw(error("ellipseinquad() the 4 points must be different: $(qgon)"))
    if !ispolyclockwise(qgon)
        reverse!(qgon)
    end
    if !ispolyconvex(qgon)
        return O, 0, 0, 0
    end
    r = [p1.x, p1.y, 1]
    s = [p2.x, p2.y, 1]
    t = [p3.x, p3.y, 1]
    u = [p4.x, p4.y, 1]

    # Create the 'projective collineation' matrix
    # whatever that is
    e1 = s[1] * t[1] * u[2] - r[1] * t[1] * u[2] - s[1] * t[2] * u[1] + r[1] * t[2] * u[1] - r[1] * s[2] * u[1] + r[2] * s[1] * u[1] + r[1] * s[2] * t[1] - r[2] * s[1] * t[1]
    e2 = r[1] * t[1] * u[2] - r[1] * s[1] * u[2] - s[1] * t[2] * u[1] + s[2] * t[1] * u[1] - r[2] * t[1] * u[1] + r[2] * s[1] * u[1] + r[1] * s[1] * t[2] - r[1] * s[2] * t[1]
    e3 = s[1] * t[1] * u[2] - r[1] * s[1] * u[2] - r[1] * t[2] * u[1] - s[2] * t[1] * u[1] + r[2] * t[1] * u[1] + r[1] * s[2] * u[1] + r[1] * s[1] * t[2] - r[2] * s[1] * t[1]
    e4 = s[2] * t[1] * u[2] - r[2] * t[1] * u[2] - r[1] * s[2] * u[2] + r[2] * s[1] * u[2] - s[2] * t[2] * u[1] + r[2] * t[2] * u[1] + r[1] * s[2] * t[2] - r[2] * s[1] * t[2]
    e5 = -s[1] * t[2] * u[2] + r[1] * t[2] * u[2] + s[2] * t[1] * u[2] - r[1] * s[2] * u[2] - r[2] * t[2] * u[1] + r[2] * s[2] * u[1] + r[2] * s[1] * t[2] - r[2] * s[2] * t[1]
    e6 = s[1] * t[2] * u[2] - r[1] * t[2] * u[2] + r[2] * t[1] * u[2] - r[2] * s[1] * u[2] - s[2] * t[2] * u[1] + r[2] * s[2] * u[1] + r[1] * s[2] * t[2] - r[2] * s[2] * t[1]
    e7 = s[1] * u[2] - r[1] * u[2] - s[2] * u[1] + r[2] * u[1] - s[1] * t[2] + r[1] * t[2] + s[2] * t[1] - r[2] * t[1]
    e8 = t[1] * u[2] - s[1] * u[2] - t[2] * u[1] + s[2] * u[1] + r[1] * t[2] - r[2] * t[1] - r[1] * s[2] + r[2] * s[1]
    e9 = t[1] * u[2] - r[1] * u[2] - t[2] * u[1] + r[2] * u[1] + s[1] * t[2] - s[2] * t[1] + r[1] * s[2] - r[2] * s[1]
    mat = [e1 e2 e3 ; e4 e5 e6 ; e7 e8 e9]
    matinv = inv(mat)
    #  coefficients of the ellipse equation ax2 + 2bxy + cy2 + 2dx + 2fy + g = 0
    a = matinv[1,1] * matinv[1,1] + matinv[2,1] * matinv[2,1] - matinv[3,1] * matinv[3,1]
    b = matinv[1,1] * matinv[1,2] + matinv[2,1] * matinv[2,2] - matinv[3,1] * matinv[3,2]
    c = matinv[1,2] * matinv[1,2] + matinv[2,2] * matinv[2,2] - matinv[3,2] * matinv[3,2]
    d = matinv[1,1] * matinv[1,3] + matinv[2,1] * matinv[2,3] - matinv[3,1] * matinv[3,3]
    f = matinv[1,2] * matinv[1,3] + matinv[2,2] * matinv[2,3] - matinv[3,2] * matinv[3,3]
    g = matinv[1,3] * matinv[1,3] + matinv[2,3] * matinv[2,3] - matinv[3,3] * matinv[3,3]

    #  ellipse centre
    b2ac = b*b - a*c
    ellipsecenter = Point((c*d - b*f) / b2ac, (a*f - b*d) / b2ac)

    #  axes
    k = 2(a*f*f + c*d*d + g*b*b - 2*b*d*f - a*c*g) / b2ac
    ac24b2 = sqrt((a - c) * (a - c) + 4b*b)
    ellipsesemimajor = sqrt(abs(k / abs( ac24b2 - a - c)))
    ellipsesemiminor = sqrt(abs(k / abs(-ac24b2 - a - c)))

    #  rotation angle
    if b == 0
        ellipseangle = (a < c) ? 0 : π/2
    else
        ellipseangle = (a < c) ? 0.5 * atan(2b / (a-c)) : π/2 + 0.5 * atan(2b / (a-c))
    end

    # finally
    @layer begin
        translate(ellipsecenter)
        rotate(ellipseangle)
        ellipse(O, 2ellipsesemimajor, 2ellipsesemiminor, action=action)
    end
    return ellipsecenter, ellipsesemimajor, ellipsesemiminor, ellipseangle
end

ellipseinquad(qgon, action) = ellipseinquad(qgon, action=action)

"""
    crescent(pos, innerradius, outeradius;
        action=nothing,
        vertices=false,
        reversepath=false,
        steps = 30)

Create a crescent-shaped polygon, aligned with the current x-axis.
If the inner radius is 0, you'll get a semicircle.

See also ```crescent(pos1, innerradius, pos2, outeradius...)```.

## Examples

Create a filled crescent shape with outer radius of 200, inner radius of 130.
```
crescent(O, 130, 200, :fill) # or
crescent(O, 130, 200, action=:fill)
```

Create a stroked crescent shape; the inner radius of 0 produces a semicircle.

```
crescent(O, 0, 200, :stroke) # or
crescent(O, 0, 200, action=:stroke)
```
"""
function crescent(pos::Point, innerradius::Real, outerradius::Real;
        action=nothing,
        vertices=false,
        reversepath=false,
        steps = 30)
    Δ = π/steps
    ptlist = Point[]
    move(pos + Point(innerradius * sin(0), outerradius * cos(0)))
    push!(ptlist, currentpoint())
    for i in 1:steps
        pt = pos + Point(innerradius * sin(Δ * i), outerradius * cos(Δ * i))
        push!(ptlist, pt)
    end
    for i in 1:steps
        pt = pos + Point(outerradius * sin(π - (Δ * i)), outerradius * cos(π - (Δ * i)))
        push!(ptlist, pt)
    end
    if !vertices
        poly(ptlist, action, close=true, reversepath=reversepath)
    end
    return ptlist
end

crescent(pos::Point, innerradius::Real, outerradius::Real, action::Symbol;
        vertices=false,
        reversepath=false,
        steps = 30) = crescent(pos, innerradius, outerradius;
                action=action,
                vertices=vertices,
                reversepath=reversepath,
                steps = steps)

"""
crescent(cp1, r1, cp2, r2;
            action=nothing,
            vertices=false,
            reversepath=false)

Create a crescent-shaped polygon, aligned with the current
x-axis, by finding the intersection of two circles.
The two center positions should be different.

See also ```crescent(point, innerradius, outeradius...)```.

## Examples

Create a filled crescent shape from two circles.

```
crescent(O, 100, O + (60, 0), 150, :fill) # or
crescent(O, 100, O + (60, 0), 150, action=:fill)
```
"""
function crescent(cp1::Point, r1::Real, cp2::Point, r2::Real;
        action=nothing,
        vertices=false,
        reversepath=false)
    flag, ip1, ip2 = intersectioncirclecircle(cp1, r1, cp2, r2)
    if flag
        move(ip2)
        carc(cp2, r2, slope(cp2, ip2), slope(cp2, ip1), action=:path)
        arc(cp1, r1, slope(cp1, ip1), slope(cp1, ip2), action=:path)
        ptlist = pathtopoly()[1]
        if !vertices
            poly(ptlist, action, close=true, reversepath=reversepath)
        end
        return ptlist
    else
        @info "crescent(): the two arcs won't intersect "
    end
end

crescent(cp1::Point, r1::Real, cp2::Point, r2::Real, action::Symbol;
        vertices=false,
        reversepath=false) = crescent(cp1, r1, cp2, r2;
                action=action,
                vertices=vertices,
                reversepath=reversepath)
# eof
