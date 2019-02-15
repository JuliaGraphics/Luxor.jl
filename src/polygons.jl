# polygons, part of Luxor

"""
Draw a polygon.

    poly(pointlist::AbstractArray{Point, 1}, action = :nothing;
        close=false,
        reversepath=false)

A polygon is an Array of Points. By default `poly()` doesn't close or fill the polygon,
to allow for clipping.
"""
function poly(pointlist::AbstractArray{Point, 1}, action::Symbol = :nothing;
        close::Bool=false, reversepath::Bool=false)
    if action != :path
        newpath()
    end
    if reversepath == true
        reverse!(pointlist)
    end
    move(pointlist[1].x, pointlist[1].y)
    for p in pointlist[2:end]
        line(p.x, p.y)
    end
    if close==true
        closepath()
    end
    do_action(action)
end

"""
Find the centroid of simple polygon.

    polycentroid(pointlist)

Returns a point. This only works for simple (non-intersecting) polygons.

You could test the point using `isinside()`.
"""
function polycentroid(pointlist::AbstractArray{Point, 1})
    # Points are immutable, use separate variables for these calculations
    centroid_x = 0.0
    centroid_y = 0.0
    signedArea = 0.0
    vertexCount = length(pointlist)
    x0 = 0.0 # Current vertex X
    y0 = 0.0 # Current vertex Y
    x1 = 0.0 # Next vertex X
    y1 = 0.0 # Next vertex Y
    a  = 0.0  # Partial signed area

    # For all vertices except last
    i = 1
    for i in 1:vertexCount-1
        x0 = pointlist[i].x
        y0 = pointlist[i].y
        x1 = pointlist[i+1].x
        y1 = pointlist[i+1].y
        a = x0 * y1 - x1 * y0
        signedArea += a
        centroid_x += (x0 + x1) * a
        centroid_y += (y0 + y1) * a
   end
    # Do last vertex separately to avoid performing an expensive
    # modulus operation in each iteration.
    x0 = pointlist[vertexCount].x
    y0 = pointlist[vertexCount].y
    x1 = pointlist[1].x
    y1 = pointlist[1].y
    a = x0 * y1 - x1 * y0
    signedArea += a
    centroid_x += (x0 + x1) * a
    centroid_y += (y0 + y1) * a
    signedArea *= 0.5
    centroid_x /= (6.0 * signedArea)
    centroid_y /= (6.0 * signedArea)
    return Point(centroid_x, centroid_y)
end

"""
Sort the points of a polygon into order. Points are sorted according to the angle they make
with a specified point.

    polysortbyangle(pointlist::AbstractArray, refpoint=minimum(pointlist))

The `refpoint` can be chosen, but the minimum point is usually OK too:

    polysortbyangle(parray, polycentroid(parray))
"""
function polysortbyangle(pointlist::AbstractArray{Point, 1}, refpoint=minimum(pointlist))
    angles = Float64[]
    for pt in pointlist
        push!(angles, mod2pi(atan(pt.y - refpoint.y, pt.x - refpoint.x)))
    end
    return pointlist[sortperm(angles)]
end

"""
Sort a polygon by finding the nearest point to the starting point, then
the nearest point to that, and so on.

    polysortbydistance(p, starting::Point)

You can end up with convex (self-intersecting) polygons, unfortunately.
"""
function polysortbydistance(pointlist::AbstractArray{Point, 1}, starting::Point)
    route = [starting]
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

    douglas_peucker(pointlist::AbstractArray, start_index, last_index, epsilon)
"""
function douglas_peucker(pointlist::AbstractArray{Point, 1}, start_index, last_index, epsilon)
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

    simplify(pointlist::AbstractArray, detail=0.1)

`detail` is the smallest permitted distance between two points in pixels.
"""
function simplify(pointlist::AbstractArray{Point, 1}, detail=0.1)
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
function isinside(p::Point, pointlist::AbstractArray{Point, 1};
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
            allowonedge || error("VertexException a")
            continue
        end
        if q2.y == p.y
            if q2.x == p.x
                allowonedge || error("VertexException b")
                continue
            elseif (q1.y == p.y) && ((q2.x > p.x) == (q1.x < p.x))
                allowonedge || error("EdgeException")
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

Split a polygon into two where it intersects with a line. It returns two polygons:

    (poly1, poly2)

This doesn't always work, of course. For example, a polygon the shape of the letter "E"
might end up being divided into more than two parts.
"""
function polysplit(pointlist::AbstractArray{Point, 1}, p1::Point, p2::Point)
    # the two-pass version
    # TODO should be one-pass
    newpointlist = Point[]
    l = length(pointlist)
    vertex1 = Point(0, 0)
    vertex2 = Point(0, 0)
    for i in 1:l
        vertex1 = pointlist[mod1(i, l)]
        vertex2 = pointlist[mod1(i + 1, l)]
        flag, intersectpoint = intersection(vertex1, vertex2, p1, p2, crossingonly=true)
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
    for i in 1:l
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
    prettypoly(points::AbstractArray{Point, 1}, action=:nothing, vertexfunction = () -> circle(O, 2, :stroke);
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

TODO Does it render paths with no points correctly ?!
"""
function prettypoly(pointlist::AbstractArray{Point, 1}, action=:nothing, vertexfunction = () -> circle(O, 2, :stroke);
    close=false,
    reversepath=false,
    vertexlabels = (n, l) -> ()
    )

    if action != :path
        newpath()
    end
    if reversepath
        reverse!(pointlist)
    end
    move(pointlist[1].x, pointlist[1].y)
    for p in pointlist[2:end]
        line(p.x, p.y)
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
function polysmooth(points::AbstractArray{Point, 1}, radius, action=:action; debug=false)
    temppath = Tuple[]
    l = length(points)
    # perhaps should check that l >= 3?
    for i in 1:l
        p1 = points[mod1(i, l)]
        p2 = points[mod1(i + 1, l)]
        p3 = points[mod1(i + 2, l)]
        drawroundedcorner(p2, p1, p3, radius, temppath, debug=debug)
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
    offsetpoly(path::AbstractArray{Point, 1}, d)

Return a polygon that is offset from a polygon by `d` units.

The incoming set of points `path` is treated as a polygon, and another set of points is
created, which form a polygon lying `d` units away from the source poly.

Polygon offsetting is a topic on which people have written PhD theses and published academic
papers, so this short brain-dead routine will give good results for simple polygons up to a
point (!). There are a number of issues to be aware of:

- very short lines tend to make the algorithm 'flip' and produce larger lines

- small polygons that are counterclockwise and larger offsets may make the new polygon appear
  the wrong side of the original

- very sharp vertices will produce even sharper offsets, as the calculated intersection point
  veers off to infinity

- duplicated adjacent points might cause the routine to scratch its head and wonder how to
  draw a line parallel to them
"""
function offsetpoly(path::AbstractArray{Point, 1}, d)
    # don't try to calculate offset of two identical points
    if path[1] == path[end]
        popfirst!(path)
    end
    l = length(path)
    resultpoly = Array{Point}(undef, l)
    for i in 1:l
        p1 = path[mod1(i, l)]
        p2 = path[mod1(i + 1, l)]
        p3 = path[mod1(i + 2, l)]

        # should check for identical points here too...
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

        intersectionpoint = intersection(
            Point(x1p, y1p),
            Point(x2p, y2p),
            Point(x3p, y3p),
            Point(x4p, y4p), crossingonly=false, collinearintersect=true)

        if intersectionpoint[1]
            resultpoly[i] = intersectionpoint[2]
        end
    end
    return resultpoly
end

"""
    polyfit(plist::AbstractArray, npoints=30)

Build a polygon that constructs a B-spine approximation to it. The resulting list of points
makes a smooth path that runs between the first and last points.
"""
function polyfit(plist::AbstractArray{Point, 1}, npoints=30)
    l = length(plist)
    resultpoly = Array{Point}(undef, 0)
    # start at first point
    push!(resultpoly, plist[1])
    # skip the first point
    for i in 2:l-1
        p1 = plist[mod1(i - 1,     l)]
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

Returns an array of polygons.

"""
function pathtopoly()
    originalpath = getpathflat()
    polygonlist = Array{Point, 1}[]
    pointslist = Point[]
    if length(originalpath) > 0
        for e in originalpath
            if e.element_type == Cairo.CAIRO_PATH_MOVE_TO                # 0
                pointslist = Point[]
                push!(pointslist, Point(e.points[1], e.points[2]))
            elseif e.element_type == Cairo.CAIRO_PATH_LINE_TO            # 1
                push!(pointslist, Point(e.points[1], e.points[2]))
            elseif e.element_type == Cairo.CAIRO_PATH_CLOSE_PATH         # 3
                closepath()
                push!(polygonlist, pointslist)
            else
                error("unknown CairoPathEntry " * repr(e.element_type))
                error("unknown CairoPathEntry " * repr(e.points))
            end
        end
        if length(pointslist) > 1
            # if length is 1, there's a stray moveto point which we don't want
            push!(polygonlist, pointslist)
        end
    end
    return polygonlist
end

"""
    polydistances(p::AbstractArray{Point, 1}; closed=true)

Return an array of the cumulative lengths of a polygon.
"""
function polydistances(p::AbstractArray{Point, 1}; closed=true)
    r = Float64[0.0]
    t = 0.0
    for i in 1:length(p) - 1
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
    polyperimeter(p::AbstractArray{Point, 1}; closed=true)

Find the total length of the sides of polygon `p`.
"""
function polyperimeter(p::AbstractArray{Point, 1}; closed=true)
    return polydistances(p, closed=closed)[end]
end

"""
    nearestindex(polydistancearray, value)

Return a tuple of the index of the largest value in `polydistancearray` less than `value`,
and the difference value. Array is assumed to be sorted.

(Designed for use with `polydistances()`).
"""
function nearestindex(a::AbstractArray{T, 1} where T <: Real, val)
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
    polyportion(p::AbstractArray{Point, 1}, portion=0.5; closed=true, pdist=[])

Return a portion of a polygon, starting at a value between 0.0 (the beginning) and 1.0 (the end). 0.5 returns the first half of the polygon, 0.25 the first quarter, 0.75 the first three quarters, and so on.

If you already have a list of the distances between each point in the polygon (the "polydistances"), you can pass them in `pdist`, otherwise they'll be calculated afresh, using `polydistances(p, closed=closed)`.

Use the complementary `polyremainder()` function to return the other part.
"""
function polyportion(p::AbstractArray{Point, 1}, portion=0.5; closed=true, pdist=[])
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
    polyremainder(p::AbstractArray{Point, 1}, portion=0.5; closed=true, pdist=[])

Return the rest of a polygon, starting at a value between 0.0 (the beginning) and 1.0 (the end). 0.5 returns the last half of the polygon, 0.25 the last three quarters, 0.75 the last quarter, and so on.

If you already have a list of the distances between each point in the polygon (the "polydistances"), you can pass them in `pdist`, otherwise they'll be calculated afresh, using `polydistances(p, closed=closed)`.

Use the complementary `polyportion()` function to return the other part.
"""
function polyremainder(p::AbstractArray{Point, 1}, portion=0.5; closed=true, pdist=[])
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
    polysample(p::AbstractArray{Point, 1}, npoints::Int64;
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
function polysample(p::AbstractArray{Point, 1}, npoints::Int64;
        closed=true)
    length(p) < 2 && error("not enough points in polygon to take samples")
    npoints < 2  && return p[[1, end]]
    distances = polydistances(p, closed=closed)
    result = Point[]
    for i in 1:npoints
        ind, surplus = nearestindex(distances, (i/npoints) * distances[end])
        if surplus > 0.0
            nextind = mod1(ind + 1, length(p))
            overshootpoint = between(p[ind], p[nextind], surplus/distance(p[ind], p[nextind]))
            push!(result, overshootpoint)
        else
            push!(result, p[i])
        end
    end
    return result
end

"""
    polyarea(p::AbstractArray)

Find the area of a simple polygon. It works only for polygons that don't
self-intersect. See also `polyorientation()`.
"""
function polyarea(plist::AbstractArray{Point, 1})
    n = length(plist)
    area = 0.0
    for i in eachindex(plist)
        j = mod1(i + 1, n)
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
function intersectlinepoly(pt1::Point, pt2::Point, C::AbstractArray{Point, 1})
    intersectingpoints = Point[]
    for j in eachindex(C)
        Cpointpair = (C[j], C[mod1(j+1, length(C))])
        flag, pt = intersection(pt1, pt2, Cpointpair..., crossingonly=true)
        if flag
            push!(intersectingpoints, pt)
        end
    end
    # sort by distance from pt1
    sort!(intersectingpoints, lt = (p1, p2) -> distance(p1, pt1) < distance(p2, pt1))
    return intersectingpoints
end

"""
    polyintersections(S::AbstractArray{Point, 1}, C::AbstractArray{Point, 1})

Return an array of the points in polygon S plus the points where polygon S crosses
polygon C. Calls `intersectlinepoly()`.

TODO This code is experimental...
"""
function polyintersections(S::AbstractArray{Point, 1}, C::AbstractArray{Point, 1})
    Splusintersectionpoints = Point[]
    for i in eachindex(S)
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
function polyorientation(pgon::AbstractArray{Point, 1})
    # in Luxor polys are usually clockwise
    # perhaps this is because the Y axis goes down...
    sum = 0.0
    for i in 1:length(pgon)
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
function ispolyclockwise(pgon::AbstractArray{Point, 1})
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

ispointinsidetriangle(p::Point, triangle::Array{Point,1}) =
    ispointinsidetriangle(p, triangle[1], triangle[2], triangle[3])

"""
    polyselfintersections(pgon::AbstractArray{Point, 1};
        findfirst=false)

return a set of points defining the intersecting lines.

Crossings are usually included twice... ?

If `findfirst` is true, only the first one is returned, which should be quicker.

TODO This code is still experimental... Needs some thought about closed
polygons where the first and last points are the same...?
"""
function polyselfintersections(S::AbstractArray{Point, 1};
        findfirst=false)
    selfcrossings = Array{Point, 1}[]
    for i in 1:length(S)
        for j in 1:length(S)
            flag, p = intersection(
                S[i], S[mod1(i+1, length(S))],
                S[j], S[mod1(j+1, length(S))],
                    crossingonly = true,
                    commonendpoints = true)
            if flag
                push!(selfcrossings, Point[
                    S[i],
                    S[mod1(i+1, length(S))],
                    S[j],
                    S[mod1(j+1, length(S))]
                    ])
            end
            if findfirst
                length(selfcrossings) > 0 && break
            end
        end
    end
    return selfcrossings
end

"""
    polytriangulate!(pgon::AbstractArray{Point, 1})

Replace the polygon with an array of triangles which triangulate the polygon.

Caution: this destroys the polygon in place.

TODO This code is still experimental...
"""
function polytriangulate!(pgon::AbstractArray{Point, 1})
    if !ispolyclockwise(pgon)
        pgon = reverse(pgon)
    end
    triangles = Array{Point, 1}[]
    sz = length(pgon)
    while sz >= 3
        istriangleremoved = false
        for i in 1:sz-1
            sz = length(pgon)
            p1 = pgon[mod1(i, sz)]
            p2 = pgon[mod1(i + 1, sz)]
            p3 = pgon[mod1(i + 2, sz)]
            iscw = (polyorientation(p1, p2, p3) > 0.0)
            !iscw && continue
            overlappingpoints = 0
            for v in 1:sz-1
                v == i || v == i + 1 || v == i + 2 && continue
                if ispointinsidetriangle(pgon[mod1(v, sz)], p1, p2, p3)
                    overlappingpoints += 1
                end
                overlappingpoints > 0 && continue
            end
            push!(triangles, Point[p1, p2, p3])
            deleteat!(pgon, mod1(i + 1, sz))
            sz = length(pgon)
            istriangleremoved = true
        end
        !istriangleremoved && break
    end
    return triangles
end

"""
    polyremovecollinearpoints(pgon::AbstractArray{Point, 1})

Return copy of polygon with no collinear points.

Caution: may return an empty polygon... !

TODO This code is still experimental...
"""
function polyremovecollinearpoints(pgon::AbstractArray{Point, 1})
    markfordeletion = []
    for n in 1:length(pgon)
        p1 = pgon[n]

        pfirst = pgon[mod1(n - 1, length(pgon))]
        plast = pgon[mod1(n + 1, length(pgon))]

        if ispointonline(p1, pfirst, plast, extended=true, atol=0.1)
            push!(markfordeletion, n)
        end
    end
    return pgon[setdiff(1:length(pgon), markfordeletion)]
end
