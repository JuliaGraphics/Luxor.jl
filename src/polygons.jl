# polygons, part of Luxor

"""
Draw a polygon.

    poly(pointlist::Array{Point, 1}, action = :none;
        close=false,
        reversepath=false)

A polygon is an Array of Points. By default `poly()` doesn't close or fill the polygon,
to allow for clipping.
"""
function poly(pointlist::Array{Point, 1}, action::Symbol = :none;
        close::Bool=false, reversepath::Bool=false)
    if action != :path
        newpath()
    end
    if reversepath == true
        reverse!(pointlist)
    end
    move(pointlist[1].x, pointlist[1].y)
    @inbounds for p in pointlist[2:end]
        line(p.x, p.y)
    end
    if close==true
        closepath()
    end
    do_action(action)
    return pointlist
end

"""
Find the centroid of simple polygon.

    polycentroid(pointlist)

Returns a point. This only works for simple (non-intersecting) polygons.

You could test the point using `isinside()`.
"""
function polycentroid(pointlist::Array{Point,1})
    # Points are immutable, use separate variables for these calculations
    centroid_x = 0.0
    centroid_y = 0.0
    signedarea = 0.0
    vertexcount = length(pointlist)
    x0 = 0.0 # Current vertex X
    y0 = 0.0 # Current vertex Y
    x1 = 0.0 # Next vertex X
    y1 = 0.0 # Next vertex Y
    a = 0.0  # Partial signed area

    # For all vertices except last
    i = 1
    @inbounds for i in 1:vertexcount-1
        x0 = pointlist[i].x
        y0 = pointlist[i].y
        x1 = pointlist[i+1].x
        y1 = pointlist[i+1].y
        a = x0 * y1 - x1 * y0
        signedarea += a
        centroid_x += (x0 + x1) * a
        centroid_y += (y0 + y1) * a
    end
    # Do last vertex separately to avoid performing an expensive
    # modulus operation in each iteration.
    x0 = pointlist[vertexcount].x
    y0 = pointlist[vertexcount].y
    x1 = pointlist[1].x
    y1 = pointlist[1].y
    a = x0 * y1 - x1 * y0
    signedarea += a
    centroid_x += (x0 + x1) * a
    centroid_y += (y0 + y1) * a
    signedarea *= 0.5
    centroid_x /= (6.0 * signedarea)
    centroid_y /= (6.0 * signedarea)
    return Point(centroid_x, centroid_y)
end

"""
Sort the points of a polygon into order. Points are sorted according to the angle they make
with a specified point.

    polysortbyangle(pointlist::Array, refpoint=minimum(pointlist))

The `refpoint` can be chosen, but the minimum point is usually OK too:

    polysortbyangle(parray, polycentroid(parray))
"""
function polysortbyangle(pointlist::Array{Point, 1}, refpoint=minimum(pointlist))
    angles = Float64[] ; sizehint!(angles, length(pointlist))
    @inbounds for pt in pointlist
        push!(angles, slope(pt, refpoint))
    end
    return pointlist[sortperm(angles)]
end

"""
Sort a polygon by finding the nearest point to the starting point, then
the nearest point to that, and so on.

    polysortbydistance(p, starting::Point)

You can end up with convex (self-intersecting) polygons, unfortunately.
"""
function polysortbydistance(pointlist::Array{Point, 1}, starting::Point)
    route = [starting]; sizehint!(route, length(pointlist))
    # start with the first point in pointlist
    remaining = setdiff(pointlist, route)
    while length(remaining) > 0
        # find the nearest point to the current position on the route
        nearest = first(sort!(remaining, lt = (x, y) -> distance(route[end], x) < distance(route[end], y)))
        # add this to the route and remove from remaining points
        push!(route, nearest)
        popfirst!(remaining)
    end
    return route
end

"""
Use a non-recursive Douglas-Peucker algorithm to simplify a polygon. Used by `simplify()`.

    douglas_peucker(pointlist::Array, start_index, last_index, epsilon)
"""
function douglas_peucker(pointlist::Array{Point, 1}, start_index, last_index, epsilon)
    temp_stack = Tuple{Int, Int}[]
    push!(temp_stack, (start_index, last_index))
    global_start_index = start_index
    keep_list = trues(length(pointlist))
    while length(temp_stack) > 0
        start_index = first(temp_stack[end])
        last_index =  last(temp_stack[end])
        pop!(temp_stack)
        dmax = 0.0
        index = start_index
        for i in index + 1:last_index - 1
            if (keep_list[i - global_start_index])
                d = pointlinedistance(pointlist[i], pointlist[start_index], pointlist[last_index])
                if d > dmax
                    index = i
                    dmax = d
                end
            end
        end
        if dmax > epsilon
            push!(temp_stack, (start_index, index))
            push!(temp_stack, (index, last_index))
        else
            for i in start_index + 2:last_index - 1 # 2 seems to keep the starting point...
                keep_list[i - global_start_index] = false
            end
        end
    end
    return pointlist[keep_list]
end

"""
Simplify a polygon:

    simplify(pointlist::Array, detail=0.1)

`detail` is the maximum approximation error of simplified polygon.
"""
function simplify(pointlist::Array{Point, 1}, detail=0.1)
    douglas_peucker(pointlist, 1, length(pointlist), detail)
end

function det3p(q1::Point, q2::Point, p::Point)
    (q1.x - p.x) * (q2.y - p.y) - (q2.x - p.x) * (q1.y - p.y)
end

"""
    isinside(p, pol; allowonedge=false)

Is a point `p` inside a polygon `pol`? Returns true if it does, or false.

This is an implementation of the Hormann-Agathos (2001) Point in Polygon algorithm.

The classification of points lying on the edges of the target polygon, or coincident with
its vertices is not clearly defined, due to rounding errors or arithmetical
inadequacy. By default these will generate errors, but you can suppress these by setting
`allowonedge` to `true`.
"""
function isinside(p::Point, pointlist::Array{Point, 1};
        allowonedge::Bool=false)
    c = false
    @inbounds for counter in eachindex(pointlist)
        q1 = pointlist[counter]
        # if reached last point, set "next point" to first point
        if counter == length(pointlist)
            q2 = pointlist[1]
        else
            q2 = pointlist[counter + 1]
        end
        if q1 == p
            allowonedge || error("isinside(): VertexException a")
            continue
        end
        if q2.y == p.y
            if q2.x == p.x
                allowonedge || error("isinside(): VertexException b")
                continue
            elseif (q1.y == p.y) && ((q2.x > p.x) == (q1.x < p.x))
                allowonedge || error("isinside(): EdgeException")
                continue
            end
        end
        if (q1.y < p.y) != (q2.y < p.y) # crossing
            if q1.x >= p.x
                if q2.x > p.x
                    c = !c
                elseif ((det3p(q1, q2, p) > 0) == (q2.y > q1.y))
                    c = !c
                end
            elseif q2.x > p.x
                if ((det3p(q1, q2, p) > 0) == (q2.y > q1.y))
                    c = !c
                end
            end
        end
    end
    return c
end

"""
    polysplit(p, p1, p2)

Split a polygon into two where it intersects with a line. It returns two
polygons:

```
(poly1, poly2)
```

This doesn't always work, of course. For example, a polygon the shape of the
letter "E" might end up being divided into more than two parts.
"""
function polysplit(pointlist::Array{Point, 1}, p1::Point, p2::Point)
    # the two-pass version
    # TODO should be one-pass
    newpointlist = Point[]; sizehint!(newpointlist, length(pointlist))
    vertex1 = Point(0, 0)
    vertex2 = Point(0, 0)
    l = length(pointlist)
    @inbounds for i in 1:l
        vertex1 = pointlist[mod1(i, l)]
        vertex2 = pointlist[mod1(i + 1, l)]
        flag, intersectpoint = intersectionlines(vertex1, vertex2, p1, p2, crossingonly=true)
        push!(newpointlist, vertex1)
        if flag
            push!(newpointlist, intersectpoint)
        end
    end
    # close?
    # push!(newpointlist, vertex2)
    # now sort points
    poly1 = Point[]
    poly2 = Point[]
    l = length(newpointlist)
    @inbounds for i in 1:l
        vertex1 = newpointlist[mod1(i, l)]
        d = pointlinedistance(vertex1, p1, p2)
        centerpoint = (p2.x - p1.x) * (vertex1.y - p1.y) > (p2.y - p1.y) * (vertex1.x - p1.x)
        if centerpoint
            push!(poly1, vertex1)
            abs(d) < 0.1 && push!(poly2, vertex1)
        else
            push!(poly2, vertex1)
            abs(d) < 0.1 && push!(poly1, vertex1)
        end
    end
    return(poly1, poly2)
end

"""
    prettypoly(points::Array{Point, 1}, action=:none, vertexfunction = () -> circle(O, 2, :stroke);
        close=false,
        reversepath=false,
        vertexlabels = (n, l) -> ()
        )

Draw the polygon defined by `points`, possibly closing and reversing it, using the current
parameters, and then evaluate the `vertexfunction` function at every vertex of the polygon.

The default vertexfunction draws a 2 pt radius circle.

To mark each vertex of a polygon with a randomly colored filled circle:

    p = star(O, 70, 7, 0.6, 0, vertices=true)
    prettypoly(p, :fill, () ->
        begin
            randomhue()
            circle(O, 10, :fill)
        end,
        close=true)

The optional keyword argument `vertexlabels` lets you supply a function with
two arguments that can access the current vertex number and the total number of vertices
at each vertex. For example, you can label the vertices of a triangle "1 of 3", "2 of 3",
and "3 of 3" using:

    prettypoly(triangle, :stroke,
        vertexlabels = (n, l) -> (text(string(n, " of ", l))))
"""
function prettypoly(pointlist::Array{Point, 1}, action=:none, vertexfunction = () -> circle(O, 2, :stroke);
    close=false,
    reversepath=false,
    vertexlabels = (n, l) -> ()
    )

    if isempty(pointlist)
        return nothing
    end

    if action != :path
        newpath()
    end

    if reversepath
        reverse!(pointlist)
    end

    move(pointlist[1])
    @inbounds for p in pointlist[2:end]
        line(p)
    end

    if close
        closepath()
    end
    do_action(action)
    pointnumber = 1

    for p in pointlist
        gsave()
        translate(p.x, p.y)
        vertexfunction()
        vertexlabels(pointnumber, length(pointlist))
        grestore()
        pointnumber += 1
    end

    if action == :fillpreserve || action == :strokepreserve
        move(pointlist[1])
        @inbounds for p in pointlist[2:end]
            line(p)
        end
    end

    return pointlist
end

function getproportionpoint(point::Point, segment, length, dx, dy)
    scalefactor = segment / length
    return Point((point.x - dx * scalefactor), (point.y - dy * scalefactor))
end

function drawroundedcorner(cornerpoint::Point, p1::Point, p2::Point, radius, path; debug=false)
    dx1 = cornerpoint.x - p1.x     # vector 1
    dy1 = cornerpoint.y - p1.y
    dx2 = cornerpoint.x - p2.x     # vector 2
    dy2 = cornerpoint.y - p2.y

    # Angle between vector 1 and vector 2 divided by 2
    angle2 = (atan(dy1, dx1) - atan(dy2, dx2)) / 2

    #  length of segment between corner point and the
    #  points of intersection with the circle of a given radius
    t = abs(tan(angle2))
    segment = radius / t

    # Check the segment
    length1 = hypot(dx1, dy1)
    length2 = hypot(dx2, dy2)
    seglength = min(length1, length2)
    if segment > seglength
        segment = seglength
        radius = seglength * t
    end

    #  points of intersection are calculated by the proportion between
    #  the coordinates of the vector, length of vector and the length of the segment.
    p1_cross = getproportionpoint(cornerpoint, segment, length1, dx1, dy1)
    p2_cross = getproportionpoint(cornerpoint, segment, length2, dx2, dy2)

    #  calculation of the coordinates of the circle's center by the addition of angular vectors
    dx = cornerpoint.x * 2 - p1_cross.x - p2_cross.x
    dy = cornerpoint.y * 2 - p1_cross.y - p2_cross.y
    L = hypot(dx, dy)
    d = hypot(segment, radius)

    # this prevents impossible constructions; Cairo will crash if L is 0
    if isapprox(L, 0.0)
        L= 0.01
    end

    circlepoint = getproportionpoint(cornerpoint, d, L, dx, dy)

    # if "debugging" or you just like the circles:
    debug && circle(circlepoint, radius, :stroke)

    # start angle and end engle of arc
    startangle = atan(p1_cross.y - circlepoint.y, p1_cross.x - circlepoint.x)
    endangle   = atan(p2_cross.y - circlepoint.y, p2_cross.x - circlepoint.x)

    # add first line segment, up to the start of the arc
    push!(path, (:line, p1_cross)) # draw line to arc start

    # adjust. Cairo also does this when you draw arc()s, btw
    if endangle < 0
        endangle = 2pi + endangle
    end
    if startangle < 0
        startangle = 2pi + startangle
    end
    sweepangle = endangle - startangle

    if abs(sweepangle) > pi
        if startangle < endangle
            push!(path, (:carc, [circlepoint, radius, startangle, endangle]))
        else
            push!(path, (:arc, [circlepoint, radius, startangle, endangle]))
        end
    else
        if startangle < endangle
            push!(path, (:arc, [circlepoint, radius, startangle, endangle]))
        else
            push!(path, (:carc, [circlepoint, radius, startangle, endangle]))
        end
    end
    # line from end of arc to start of next side
    push!(path, (:line,  p2_cross))
end

"""
    polysmooth(points, radius, action=:action; debug=false)

Make a closed path from the `points` and round the corners by making them arcs with the
given radius. Execute the action when finished.

The arcs are sometimes different sizes: if the given radius is bigger than the length of the
shortest side, the arc can't be drawn at its full radius and is therefore drawn as large as
possible (as large as the shortest side allows).

The `debug` option also draws the construction circles at each corner.
"""
function polysmooth(points::Array{Point, 1}, radius, action=:action; debug=false)
    temppath = Tuple[]
    l = length(points)
    if l < 3
        # there are less than three points to smooth
        return nothing
    else
        @inbounds for i in 1:l
            p1 = points[mod1(i, l)]
            p2 = points[mod1(i + 1, l)]
            p3 = points[mod1(i + 2, l)]
            drawroundedcorner(p2, p1, p3, radius, temppath, debug=debug)
        end
    end
    # need to close by joining to first point
    push!(temppath, temppath[1])
    # draw the path
    for (c, p) in temppath
        if c == :line
            line(p)    # add line segment
        elseif c == :arc
            arc(p...)  # add clockwise arc segment
        elseif c == :carc
            carc(p...) # add counterclockwise arc segment
        end
    end
    do_action(action)
end

"""
    offsetpoly(plist::Array{Point, 1}, d)

Return a polygon that is offset from a polygon by `d` units.

The incoming set of points `plist` is treated as a polygon, and another set of
points is created, which form a polygon lying `d` units away from the source
poly.

Polygon offsetting is a topic on which people have written PhD theses and
published academic papers, so this short brain-dead routine will give good
results for simple polygons up to a point (!). There are a number of issues to
be aware of:

- very short lines tend to make the algorithm 'flip' and produce larger lines

- small polygons that are counterclockwise and larger offsets may make the new
polygon appear the wrong side of the original

- very sharp vertices will produce even sharper offsets, as the calculated intersection point veers off to infinity

- duplicated adjacent points might cause the routine to scratch its head and wonder how to draw a line parallel to them
"""
function offsetpoly(plist::Array{Point, 1}, d)
    # don't try to calculate offset of two identical points
    l = length(plist)
    resultpoly = Array{Point}(undef, l)
    previouspoint = plist[end]
    for i in 1:l
        plist[i] == previouspoint && continue
        p1 = plist[mod1(i, l)]
        p2 = plist[mod1(i + 1, l)]
        p3 = plist[mod1(i + 2, l)]

        p1 == p2 && continue
        p2 == p3 && continue

        L12 = distance(p1, p2)
        L23 = distance(p2, p3)
        # the offset line of p1 - p2
        x1p = p1.x + (d * (p2.y - p1.y))/ L12
        y1p = p1.y + (d * (p1.x - p2.x))/ L12
        x2p = p2.x + (d * (p2.y - p1.y))/ L12
        y2p = p2.y + (d * (p1.x - p2.x))/ L12

        # the offset line of p2 - p3
        x3p = p2.x + (d * (p3.y - p2.y))/ L23
        y3p = p2.y + (d * (p2.x - p3.x))/ L23
        x4p = p3.x + (d * (p3.y - p2.y))/ L23
        y4p = p3.y + (d * (p2.x - p3.x))/ L23

        intersectionpoint = intersectionlines(
            Point(x1p, y1p),
            Point(x2p, y2p),
            Point(x3p, y3p),
            Point(x4p, y4p), crossingonly=false)

        if intersectionpoint[1]
            resultpoly[i] = intersectionpoint[2]
        end
        previouspoint = plist[i]
    end
    return resultpoly
end

"""
    offsetlinesegment(p1, p2, p3, d1, d2)

Given three points, find another 3 points that are offset by
d1 at the start and d2 at the end.

Negative d values put the offset on the left.
"""
function offsetlinesegment(p1, p2, p3, d1, d2)
    if p1 == p2 || p2 == p3 || p1 == p3
        throw(error("offsetlinesegment: the three points must be different"))
    end

    pt1 = perpendicular(p1, p2, -d1)
    pt2 = perpendicular(p3, p2, d2)

    L12 = distance(p1, p2)
    L23 = distance(p2, p3)

    d = (d1 + d2) / 2
    # the offset line of p1 - p2
    x1p = p1.x + (d * (p2.y - p1.y))/ L12
    y1p = p1.y + (d * (p1.x - p2.x))/ L12
    x2p = p2.x + (d * (p2.y - p1.y))/ L12
    y2p = p2.y + (d * (p1.x - p2.x))/ L12

    # the offset line of p2 - p3
    x3p = p2.x + (d * (p3.y - p2.y))/ L23
    y3p = p2.y + (d * (p2.x - p3.x))/ L23
    x4p = p3.x + (d * (p3.y - p2.y))/ L23
    y4p = p3.y + (d * (p2.x - p3.x))/ L23

    intersectionpoint = intersectionlines(
        Point(x1p, y1p),
        Point(x2p, y2p),
        Point(x3p, y3p),
        Point(x4p, y4p), crossingonly=false)

    if first(intersectionpoint)
        pt3 = intersectionpoint[2]
    else
        #  collinear probably
        pt3 = midpoint(pt1, pt2)
    end
    return pt1, pt3, pt2
end

"""
    offsetpoly(plist;
        startoffset = 10,
        endoffset   = 10,
        easingfunction = lineartween)

Return a closed polygon that is offset from and encloses an
open polygon.

The incoming set of points `plist` is treated as an open
polygon, and another set of points is created, which form a
polygon lying `...offset` units away from the source poly.

This method for `offsetpoly()` treats the list of points as
`n` vertices connected with `n - 1` lines. It allows you to
vary the offset from the start of the line to the end.

The other method `offsetpoly(plist, d)` treats the list of
points as `n` vertices connected with `n` lines.

# Extended help

This function accepts a keyword argument that allows you to
control the offset using a function, using the easing
functionality built in to Luxor. By default the function is
`lineartween()`, so the offset changes linearly between the
`startoffset` and the `endoffset`. The function:

```
f(a, b, c, d) = 2sin((a * π))
```

runs from 0 to 2 and back as `a` runs from 0 to 1.
The offsets are scaled by this amount.

"""
function offsetpoly(plist;
        startoffset = 10,
        endoffset   = 10,
        easingfunction = lineartween)

    l = length(plist)
    l < 3 && throw(error("variableoffsetline: not enough points"))

    # build the poly in two halves
    leftcurve  = Point[]
    rightcurve = Point[]

    pt1 = perpendicular(plist[1], plist[2], -startoffset)
    pt2 = perpendicular(plist[1], plist[2], startoffset)

    push!(leftcurve, pt1)
    push!(rightcurve, pt2)

    for i in 1:l-2
        k1 = easingfunction(rescale(i,     1, l - 2), 0.0, 1.0, 1.0)
        k2 = easingfunction(rescale(i + 1, 1, l - 2), 0.0, 1.0, 1.0)

        d1 = rescale(k1 * l, 1, l, startoffset, endoffset)
        d2 = rescale(k2 * l, 1, l, startoffset, endoffset)

        p1, mpt, p3 = offsetlinesegment(plist[i], plist[i + 1], plist[i + 2],  d1,  d2)
        push!(leftcurve, mpt)
        p1, mpt, p3 = offsetlinesegment(plist[i], plist[i + 1], plist[i + 2], -d1, -d2)
        push!(rightcurve, mpt)
    end
    # final point
    k = easingfunction(1, 0.0, 1.0, 1.0)
    d = rescale(k * l, 1, l, startoffset, endoffset)
    pt1 = perpendicular(plist[end], plist[end - 1], -d)
    pt2 = perpendicular(plist[end], plist[end - 1],  d)
    push!(leftcurve, pt2)
    push!(rightcurve, pt1)
    return vcat(leftcurve, reverse(rightcurve))
end


"""
    polyfit(plist::Array, npoints=30)

Build a polygon that constructs a B-spine approximation to it. The resulting list of points
makes a smooth path that runs between the first and last points.
"""
function polyfit(plist::Array{Point, 1}, npoints=30)
    l = length(plist)
    resultpoly = Array{Point}(undef, 0) ; sizehint!(resultpoly, npoints)
    # start at first point
    push!(resultpoly, plist[1])
    # skip the first point
    @inbounds for i in 2:l-1
        p1 = plist[mod1(i - 1, l)]
        p2 = plist[mod1(i, l)]
        p3 = plist[mod1(i + 1, l)]
        p4 = plist[mod1(i + 2, l)]
        a3 = (-p1.x + 3 * (p2.x - p3.x) + p4.x) / 6.0
        b3 = (-p1.y + 3 * (p2.y - p3.y) + p4.y) / 6.0
        a2 = (p1.x - 2p2.x + p3.x) / 2.0
        b2 = (p1.y - 2p2.y + p3.y) / 2.0
        a1 = (p3.x - p1.x) / 2.0
        b1 = (p3.y - p1.y) / 2.0
        a0 = (p1.x + 4p2.x + p3.x) / 6.0
        b0 = (p1.y + 4p2.y + p3.y) / 6.0
        for i in 1:l-1
            t = i/npoints
            x = ((((a3 * t + a2) * t) + a1) * t) + a0
            y = ((((b3 * t + b2) * t) + b1) * t) + b0
            push!(resultpoly, Point(x, y))
        end
    end
    # finish at last point
    push!(resultpoly, plist[end])
    return resultpoly
end

"""
    pathtopoly()

Convert the current path to an array of polygons.

Returns an array of polygons, corresponding to the paths and subpaths of the original path.
"""
function pathtopoly()
    originalpath = getpathflat()
    polygonlist = Array{Point, 1}[] ; sizehint!(polygonlist, length(originalpath))
    if length(originalpath) > 0
        pointslist = Point[]
        for e in originalpath
            if e.element_type == Cairo.CAIRO_PATH_MOVE_TO                # 0
                push!(pointslist, Point(first(e.points), last(e.points)))
            elseif e.element_type == Cairo.CAIRO_PATH_LINE_TO            # 1
                push!(pointslist, Point(first(e.points), last(e.points)))
            elseif e.element_type == Cairo.CAIRO_PATH_CLOSE_PATH         # 3
                if last(pointslist) == first(pointslist)
                    # don’t repeat first point, we can close it ourselves
                    if length(pointslist) > 2
                        pop!(pointslist)
                    end
                end
                push!(polygonlist, pointslist)
                pointslist = Point[]
            else
                error("pathtopoly(): unknown CairoPathEntry " * repr(e.element_type))
                error("pathtopoly(): unknown CairoPathEntry " * repr(e.points))
            end
        end
        # the path was never closed, so flush
        if length(pointslist) > 0
            push!(polygonlist, pointslist)
        end
    end
    return polygonlist
end

"""
    polydistances(p::Array{Point, 1}; closed=true)

Return an array of the cumulative lengths of a polygon.
"""
function polydistances(p::Array{Point, 1}; closed=true)
    l = length(p)
    r = Float64[0.0] ; sizehint!(r, l)
    t = 0.0
    @inbounds for i in 1:l - 1
        t += distance(p[i], p[i + 1])
        push!(r, t)
    end
    if closed
        t += distance(p[end], p[1])
        push!(r, t)
    end
    return r
end

"""
    polyperimeter(p::Array{Point, 1}; closed=true)

Find the total length of the sides of polygon `p`.
"""
function polyperimeter(p::Array{Point, 1}; closed=true)
    return polydistances(p, closed=closed)[end]
end

"""
    nearestindex(polydistancearray, value)

Return a tuple of the index of the largest value in `polydistancearray` less
than `value`, and the difference value. Array is assumed to be sorted.

(Designed for use with `polydistances()`).
"""
function nearestindex(a::Array{T, 1} where T <: Real, val)
    ind = findlast(v -> (v < val), a)
    surplus = 0.0
    if ind > 0.0
        surplus = val - a[ind]
    else
        ind = 1
    end
    return (ind, surplus)
end

"""
    polyportion(p::Array{Point, 1}, portion=0.5; closed=true, pdist=[])

Return a portion of a polygon, starting at a value between 0.0 (the beginning)
and 1.0 (the end). 0.5 returns the first half of the polygon, 0.25 the first
quarter, 0.75 the first three quarters, and so on.

If you already have a list of the distances between each point in the polygon
(the "polydistances"), you can pass them in `pdist`, otherwise they'll be
calculated afresh, using `polydistances(p, closed=closed)`.

Use the complementary `polyremainder()` function to return the other part.
"""
function polyportion(p::Array{Point, 1}, portion=0.5; closed=true, pdist=[])
    # portion is 0 to 1
    if isempty(pdist)
        pdist = polydistances(p, closed=closed)
    end
    portion = clamp(portion, 0.0, 1.0)
    # don't bother to do 0.0
    isapprox(portion, 0.0, atol=0.00001) && return p[1:1]
    # don't bother to do 1.0
    if closed == false && isapprox(portion, 1.0, atol=0.00001)
        return p
    elseif isapprox(portion, 1.0, atol=0.00001)
        return p
    end
    ind, surplus = nearestindex(pdist, portion * pdist[end])
    if surplus > 0.0
        nextind = mod1(ind + 1, length(p))
        overshootpoint = between(p[ind], p[nextind], surplus/distance(p[ind], p[nextind]))
        return vcat(p[1:ind], overshootpoint)
    else
        return p[1:end]
    end
end

"""
    polyremainder(p::Array{Point, 1}, portion=0.5; closed=true, pdist=[])

Return the rest of a polygon, starting at a value between 0.0 (the beginning)
and 1.0 (the end). 0.5 returns the last half of the polygon, 0.25 the last three
quarters, 0.75 the last quarter, and so on.

If you already have a list of the distances between each point in the polygon
(the "polydistances"), you can pass them in `pdist`, otherwise they'll be
calculated afresh, using `polydistances(p, closed=closed)`.

Use the complementary `polyportion()` function to return the other part.
"""
function polyremainder(p::Array{Point, 1}, portion=0.5; closed=true, pdist=[])
    # portion is 0 to 1
    if isempty(pdist)
        pdist = polydistances(p, closed=closed)
    end
    portion = clamp(portion, 0.0, 1.0)

    # don't bother to do 0.0
    isapprox(portion, 0.0, atol=0.00001) && return p

    # don't bother to do 1.0
    if isapprox(portion, 1.0, atol=0.00001)
        return p[1:1]
    end
    ind, surplus = nearestindex(pdist, portion * pdist[end])
    if surplus > 0.0
        nextind = mod1(ind + 1, length(p))
        overshootpoint = between(p[ind], p[nextind], surplus/distance(p[ind], p[nextind]))
        return vcat(overshootpoint, p[nextind:end])
    else
        return p[1:end]
    end
end

"""
    polysample(p::Array{Point, 1}, npoints::T where T <: Integer;
            closed=true)

Sample the polygon `p`, returning a polygon with `npoints` to represent it. The
first sampled point is:

     1/`npoints` * `perimeter of p`

away from the original first point of `p`.

If `npoints` is the same as `length(p)` the returned polygon is the same as the
original, but the first point finishes up at the end (so `new=circshift(old,
1)`).

If `closed` is true, the entire polygon (including the edge joining the last
point to the first point) is sampled.
"""
function polysample(p::Array{Point, 1}, npoints::T where T <: Integer;
        closed=true)
    l = length(p)
    l < 2 && error("polysample(): not enough points in polygon to take samples")
    npoints < 2  && return p[[1, end]]
    distances = polydistances(p, closed=closed)
    result = Point[] ; sizehint!(result, l)
    for i in 1:npoints
        ind, surplus = nearestindex(distances, (i/npoints) * distances[end])
        if surplus > 0.0
            nextind = mod1(ind + 1, l)
            overshootpoint = between(p[ind], p[nextind], surplus/distance(p[ind], p[nextind]))
            push!(result, overshootpoint)
        else
            push!(result, p[i])
        end
    end
    return result
end

"""
    polyarea(p::Array)

Find the area of a simple polygon. It works only for polygons that don't
self-intersect. See also `polyorientation()`.
"""
function polyarea(plist::Array{Point, 1})
    l = length(plist)
    area = 0.0
    @inbounds for i in eachindex(plist)
        j = mod1(i + 1, l)
        area += plist[i].x * plist[j].y
        area -= plist[j].x * plist[i].y
    end
    area = abs(area) / 2.0
    return area
end

"""
    intersectlinepoly(pt1::Point, pt2::Point, C)

Return an array of the points where a line between pt1 and pt2 crosses polygon C.
"""
function intersectlinepoly(pt1::Point, pt2::Point, C::Array{Point, 1})
    intersectingpoints = Point[]
    @inbounds for j in eachindex(C)
        Cpointpair = (C[j], C[mod1(j + 1, length(C))])
        flag, pt = intersectionlines(pt1, pt2, Cpointpair..., crossingonly=true)
        if flag
            push!(intersectingpoints, pt)
        end
    end
    # sort by distance from pt1
    sort!(intersectingpoints, lt = (p1, p2) -> distance(p1, pt1) < distance(p2, pt1))
    return intersectingpoints
end

"""
    polyintersections(S::Array{Point, 1}, C::Array{Point, 1})

Return an array of the points in polygon S plus the points where polygon S crosses
polygon C. Calls `intersectlinepoly()`.

TODO This code is experimental...
"""
function polyintersections(S::Array{Point, 1}, C::Array{Point, 1})
    Splusintersectionpoints = Point[] ; sizehint!(Splusintersectionpoints, length(S) + length(C))
    @inbounds for i in eachindex(S)
        Spointpair = (S[i], S[mod1(i+1, length(S))])
        push!(Splusintersectionpoints, S[i])
        for pt in intersectlinepoly(Spointpair..., C)
            push!(Splusintersectionpoints, pt)
        end
    end
    return Splusintersectionpoints
end

# TODO these experimental functions don't work all the time
# use with caution... :)

"""
    polyorientation(pgon)

Returns a number which is positive if the polygon is clockwise in Luxor...

TODO This code is still experimental...
"""
function polyorientation(pgon::Array{Point, 1})
    # in Luxor polys are usually clockwise
    # perhaps this is because the Y axis goes down...
    sum = 0.0
    @inbounds for i in 1:length(pgon)
        sum += crossproduct(pgon[i], pgon[mod1(i + 1, end)])
    end
    return sum
end

polyorientation(pt1, pt2, pt3) = polyorientation(Point[pt1, pt2, pt3])

"""
    ispolyclockwise(pgon)

Returns true if polygon is clockwise. WHEN VIEWED IN A LUXOR DRAWING...?

TODO This code is still experimental...
"""
function ispolyclockwise(pgon::Array{Point, 1})
    polyorientation(pgon) > 0.0
end

"""
    ispointinsidetriangle(p, p1, p2, p3)
    ispointinsidetriangle(p, triangle::Array{Point, 1})

Returns false if `p` is not inside triangle p1 p2 p3.
"""

function ispointinsidetriangle(p::Point, p1::Point, p2::Point, p3::Point)
    if polyorientation([p1, p2, p3]) < 0.0
        p1, p3 = p3, p1
    end
    # barycentric method?
    s = p1.y * p3.x - p1.x * p3.y + (p3.y - p1.y) * p.x + (p1.x - p3.x) * p.y
    t = p1.x * p2.y - p1.y * p2.x + (p1.y - p2.y) * p.x + (p2.x - p1.x) * p.y

    if s < 0 != t < 0
        return false
    end
    A = -p2.y * p3.x + p1.y * (p3.x - p2.x) + p1.x * (p2.y - p3.y) + p2.x * p3.y
    return A < 0 ?
        (s <= 0 && s + t >= A) :
        (s >= 0 && s + t <= A)
end

ispointinsidetriangle(p::Point, triangle::Array{Point, 1}) =
    ispointinsidetriangle(p, triangle[1], triangle[2], triangle[3])

"""
    polyremovecollinearpoints(pgon::Array{Point, 1})

Return copy of polygon with no collinear points.

Caution: may return an empty polygon... !

TODO This code is still experimental...
"""
function polyremovecollinearpoints(pgon::Array{Point, 1})
    markfordeletion = []
    @inbounds for n in 1:length(pgon)
        p1 = pgon[n]

        pfirst = pgon[mod1(n - 1, length(pgon))]
        plast = pgon[mod1(n + 1, length(pgon))]

        if ispointonline(p1, pfirst, plast, extended=true, atol=0.1)
            push!(markfordeletion, n)
        end
    end
    return pgon[setdiff(1:length(pgon), markfordeletion)]
end

"""
    polymove!(pgon, frompoint::Point, topoint::Point)

Move (permanently) a polygon from `frompoint` to `topoints`.
"""
function polymove!(pgon, frompoint::Point, topoint::Point)
    d = topoint - frompoint
    @inbounds for i in eachindex(pgon)
        pgon[i] = Point(pgon[i].x + d.x, pgon[i].y + d.y)
    end
    return pgon
end

"""
    polyscale!(pgon, s;
       center=O)

Scale (permanently) a polygon by `s`, relative to `center`.
"""
function polyscale!(pgon, s;
        center=O)
    @inbounds for i in eachindex(pgon)
        pgon[i] = between(center, pgon[i], s)
    end
    return pgon
end

"""
    polyscale!(pgon, sh, sv;
        center=O)

Scale (permanently) a polygon by `sh` horizontally and `sv` vertically,
relative to `center`.
"""
function polyscale!(pgon, sh, sv;
        center=O)
    @inbounds for i in eachindex(pgon)
        pgon[i] = (pgon[i] - center) * (sh, sv)
    end
    return pgon
end

"""
    polyrotate!(pgon, θ;
        center=O)

Rotate (permanently) a polygon around `center` by `θ` radians.
"""
function polyrotate!(pgon, θ;
        center=O)
    costheta = cos(θ)
    sintheta = sin(θ)
    @inbounds for i in eachindex(pgon)
        pgon[i] = Point(
            (pgon[i].x - center.x) * costheta  -  ((pgon[i].y - center.y) * sintheta) + center.x,
            (pgon[i].x - center.x) * sintheta  +  ((pgon[i].y - center.y) * costheta) + center.y)
    end
    return pgon
end

"""
    polyreflect!(pgon, pt1 = O, pt2 = O + (0, 100)

Reflect (permanently) a polygon in a line (default to the y-axis)
joining two points.

"""
function polyreflect!(pgon, pt1=O, pt2 = O + (0, 100))
    @inbounds for i in eachindex(pgon)
        gnp = getnearestpointonline(pt1, pt2, pgon[i])
        pgon[i] = between(pgon[i], gnp, 2.0)
    end
    return pgon
end

"""
    insertvertices!(pgon;
        ratio=0.5)

Insert a new vertex into each edge of a polygon `pgon`. The default `ratio` of
0.5 divides the original edge of the polygon into half.
"""
function insertvertices!(pgon;
        ratio=0.5)
    counter = 1
    vertexnumber = 2
    originallength = length(pgon)
    while true
        insert!(pgon, vertexnumber,
        between(pgon[mod1(vertexnumber - 1, length(pgon))],
            pgon[mod1(vertexnumber, length(pgon))],
            ratio))
        vertexnumber += 2
        counter += 1
        if counter > originallength
            break
        end
    end
    return pgon
end

"""
    polyintersect(p1::AbstractArray{Point, 1}, p2::AbstractArray{Point, 1};
        closed=true)

TODO: Fix/test/improve this experimental polygon intersection routine.

Return the points where polygon p1 and polygon p2 cross.

If `closed` is false, the intersection points must lie on the first `n - 1` lines of each polygon.

"""
function polyintersect(p1::AbstractArray{Point, 1}, p2::AbstractArray{Point, 1};
    closed=true)
    length(p1) < 3 || length(p2) < 3 && error("polyintersect(): not enough points")
    temp = Point[]
    @inbounds for i in eachindex(p1)
        Spointpair = (p1[i], p1[mod1(i + 1, length(p1))])
        for pt in intersectlinepoly(Spointpair..., p2)
            push!(temp, pt)
        end
    end
    # if not closed polygons, remove ipts that are on close side
    if closed == false
        ripts = Point[]
        for ipt in temp
            if !(ispointonline(ipt, p1[end], p1[1]) || ispointonline(ipt, p2[end], p2[1]) )
                push!(ripts, ipt)
            end
        end
        return ripts
    else
        return temp
    end
end

# triangulation functions

function _smallesttriangle(bb::BoundingBox)
    # find the smallest triangle that completely encloses bounding box
    diag = boxdiagonal(bb)

    # circle that encloses this box
    circ = (center = boxmiddlecenter(bb), radius = diag / 2)

    # three equally spaced points on circle
    side1pt = circ.center + polar(circ.radius, 0)
    side2pt = circ.center + polar(circ.radius, 2π / 3)
    side3pt = circ.center + polar(circ.radius, 4π / 3)

    # make them clockwise
    pgon = [side1pt, side2pt, side3pt]
    if !ispolyclockwise(pgon)
        reverse!(pgon)
    end
    return offsetpoly(pgon, circ.radius / 2)
end

mutable struct TriEdge
    spt::Point
    ept::Point
    valid::Bool
end

function _edgesequal(edge1::TriEdge, edge2::TriEdge)
    !edge1.valid && return false
    !edge2.valid && return false
    if ((edge1.spt ≈ edge2.spt) && (edge1.ept ≈ edge2.ept)) ||
       ((edge1.spt ≈ edge2.ept) && (edge1.ept ≈ edge2.spt))
        return true
    else
        return false
    end
end

"""
    polytriangulate(plist::Array{Point,1}; epsilon = -0.01)

Triangulate the polygon in `plist`.

This uses the Bowyer–Watson/Delaunay algorithm to make triangles. It returns an array of triangular polygons.

TODO: This experimental polygon function is not very efficient, because it first copies the list of points (to avoid modifying the original), and sorts it, before making triangles.
"""
function polytriangulate(plist::Array{Point,1}; epsilon = -0.001)
    trianglelist = Vector{Point}[]
    pointlist = deepcopy(plist)
    vertexcount = length(pointlist)

    # make enclosing supertriangle
    bb = BoundingBox(pointlist)
    supertriangle = Luxor._smallesttriangle(bb)

    # add the supertriangle to the trianglelist
    push!(trianglelist, supertriangle)

    # add the supertriangle’s vertices to the point list
    push!(pointlist, supertriangle[1])
    push!(pointlist, supertriangle[2])
    push!(pointlist, supertriangle[3])

    # sorting the list of points by x coordinate
    sort!(pointlist)

    @inbounds for point in pointlist
        edgebuffer = Vector{Luxor.TriEdge}() # to store edges
        tobedeleted = Int64[]

        for ntriangle in eachindex(trianglelist)
            # for each triangle currently in the trianglelist
            # calculate the triangle circumcircle center and radius
            triangle = trianglelist[ntriangle]
            cp, r = center3pts(triangle[1], triangle[2], triangle[3])

            #as soon as the x component of the distance from the current point to the
            #circumcircle center is greater than the circumcircle radius, that triangle need
            #never be considered for later points, as further points will never again be on
            #the interior of that triangles circumcircle.
            abs(point.x - cp.x) > r && continue

            # if this fails, r is zero, so no problem with adding edges/deleting triangles
            if distance(point, cp) < (r + epsilon)
                # if the point lies in the triangle’s circumcircle,
                # add the triangle’s edges to the edge buffer
                push!(edgebuffer, Luxor.TriEdge(triangle[1], triangle[2], true))
                push!(edgebuffer, Luxor.TriEdge(triangle[2], triangle[3], true))
                push!(edgebuffer, Luxor.TriEdge(triangle[3], triangle[1], true))
                # and mark the triangle to be deleted
                push!(tobedeleted, ntriangle)
            end
        end
        deleteat!(trianglelist, tobedeleted)

        # find all shared edges in the edge buffer
        # when they’re removed, the edges of the enclosing polygon are left
        j = 1
        while j <= length(edgebuffer)
            k = j + 1
            while k <= length(edgebuffer)
                if Luxor._edgesequal(edgebuffer[j], edgebuffer[k]) == true
                    edgebuffer[j].valid = false
                    edgebuffer[k].valid = false
                end
                k += 1
            end
            j += 1
        end

        # make new triangles around the current point
        # skip over any tagged edges
        j = 1
        while j <= length(edgebuffer)
            if edgebuffer[j].valid
                # the order is important
                pgon = sort([edgebuffer[j].ept, point, edgebuffer[j].spt])
                # make sure every polygon is clockwise
                if !ispolyclockwise(pgon)
                    reverse!(pgon)
                end
                push!(trianglelist, pgon)
            end
            j += 1
        end
    end # do next point

    # # tidy up
    # # remove any triangles that use the supertriangle’s vertices
    indexes = Int64[]
    for n in eachindex(trianglelist)
        triangle = trianglelist[n]
        for tpt in triangle
            for stpt in supertriangle
                if tpt ≈ stpt
                    push!(indexes, n) # mark for deletion
                end
            end
        end
    end
    deleteat!(trianglelist, unique(indexes))
    return trianglelist
end
