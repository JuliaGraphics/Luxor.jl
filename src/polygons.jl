# polygons, part of Luxor module

"""
Draw a polygon.

    poly(pointlist::Array, action = :nothing; close=false, reversepath=false)

A polygon is an Array of Points. By default `poly()` doesn't close or fill the polygon,
to allow for clipping.
"""
function poly(pointlist::Array, action = :nothing; close=false, reversepath=false)
    # where pointlist is array of Points
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
end

"""
Find the bounding box of a polygon (array of points).

    polybbox(pointlist::Array)

Return the two opposite corners (suitable for `box()`, for example).
"""
function polybbox(pointlist::Array)
    lowx, lowy = pointlist[1].x, pointlist[1].y
    highx, highy = pointlist[end].x, pointlist[end].y
    for p in pointlist
        p.x < lowx  && (lowx  = p.x)
        p.y < lowy  && (lowy  = p.y)
        p.x > highx && (highx = p.x)
        p.y > highy && (highy = p.y)
    end
    return [Point(lowx, lowy), Point(highx, highy)]
end

"""
Find the centroid of simple polygon.

    polycentroid(pointlist)

Returns a point. This only works for simple (non-intersecting) polygons.

You could test the point using `isinside()`.
"""
function polycentroid(pointlist)
    # if Points are immutable, then use separate variables for these calculations
    centroid_x = 0
    centroid_y = 0
    signedArea = 0.0
    vertexCount = length(pointlist)
    x0 = 0.0 # Current vertex X
    y0 = 0.0 # Current vertex Y
    x1 = 0.0 # Next vertex X
    y1 = 0.0 # Next vertex Y
    a = 0.0  # Partial signed area

    # For all vertices except last
    i = 1
    for i in 1:vertexCount-1
        x0 = pointlist[i].x
        y0 = pointlist[i].y
        x1 = pointlist[i+1].x
        y1 = pointlist[i+1].y
        a = x0*y1 - x1*y0
        signedArea += a
        centroid_x += (x0 + x1)*a
        centroid_y += (y0 + y1)*a
   end
    # Do last vertex separately to avoid performing an expensive
    # modulus operation in each iteration.
    x0 = pointlist[vertexCount].x
    y0 = pointlist[vertexCount].y
    x1 = pointlist[1].x
    y1 = pointlist[1].y
    a = x0*y1 - x1*y0
    signedArea += a
    centroid_x += (x0 + x1)*a
    centroid_y += (y0 + y1)*a
    signedArea *= 0.5
    centroid_x /= (6.0 * signedArea)
    centroid_y /= (6.0 * signedArea)

    return Point(centroid_x, centroid_y)
end

"""
Sort the points of a polygon into order. Points are sorted according to the angle they make
with a specified point.

    polysortbyangle(pointlist::Array, refpoint=minimum(pointlist))

The `refpoint` can be chosen, but the minimum point is usually OK too:

    polysortbyangle(parray, polycentroid(parray))
"""
function polysortbyangle(pointlist::Array, refpoint=minimum(pointlist))
    angles = Float64[]
    for pt in pointlist
        push!(angles, atan2(refpoint.y - pt.y, refpoint.x - pt.x))
    end
    return pointlist[sortperm(angles)]
end

"""
Sort a polygon by finding the nearest point to the starting point, then
the nearest point to that, and so on.

    polysortbydistance(p, starting::Point)

You can end up with convex (self-intersecting) polygons, unfortunately.
"""
function polysortbydistance(pointlist, starting::Point)
    route = [starting]
    # start with the first point in pointlist
    remaining = setdiff(pointlist, route)
    while length(remaining) > 0
        # find the nearest point to the current position on the route
        nearest = first(sort!(remaining, lt = (x, y) -> norm(route[end], x) < norm(route[end], y)))
        # add this to the route and remove from remaining points
        push!(route, nearest)
        shift!(remaining)
    end
    return route
end

"""
Use a non-recursive Douglas-Peucker algorithm to simplify a polygon. Used by `simplify()`.

    douglas_peucker(pointlist::Array, start_index, last_index, epsilon)
"""
function douglas_peucker(pointlist::Array, start_index, last_index, epsilon)
    temp_stack = Tuple{Int,Int}[] # version 0.4 only?
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
                d = point_line_distance(pointlist[i], pointlist[start_index], pointlist[last_index])
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

`detail` is probably the smallest permitted distance between two points in pixels.
"""

function simplify(pointlist, detail=0.1)
    douglas_peucker(pointlist, 1, length(pointlist), detail)
end

"""
Find the vertices of a regular n-sided polygon centred at `x`, `y`:

    ngon(x, y, radius, sides=5, orientation=0, action=:nothing; vertices=false, reversepath=false)

`ngon()` draws the shapes: if you just want the raw points, use keyword argument `vertices=true`, which returns the array of points instead. Compare:

```julia
ngon(0, 0, 4, 4, 0, vertices=true) # returns the polygon's points:

    4-element Array{Luxor.Point,1}:
    Luxor.Point(2.4492935982947064e-16,4.0)
    Luxor.Point(-4.0,4.898587196589413e-16)
    Luxor.Point(-7.347880794884119e-16,-4.0)
    Luxor.Point(4.0,-9.797174393178826e-16)

whereas

ngon(0, 0, 4, 4, 0, :close) # draws a polygon
```
"""

function ngon(x::Real, y::Real, radius::Real, sides::Int64=5, orientation=0, action=:nothing; vertices=false, reversepath=false)
  ptlist = [Point(x+cos(orientation + n * 2pi/sides) * radius,
                  y+sin(orientation + n * 2pi/sides) * radius) for n in 1:sides]
  if vertices
    return ptlist
  else
    poly(ptlist, action, close=true, reversepath=reversepath)
  end
end

"""
Draw a regular polygon centred at point `p`:

    ngon(centerpos, radius, sides=5, orientation=0, action=:nothing; vertices=false, reversepath=false)

"""

ngon(centrepoint::Point, radius::Real, sides::Int64=5, orientation=0, action=:nothing; kwargs...) = ngon(centrepoint.x, centrepoint.y, radius, sides, orientation, action; kwargs...)

"""
Make a star:

    star(xcenter, ycenter, radius, npoints=5, ratio=0.5, orientation=0, action=:nothing; vertices = false, reversepath=false)

Use `vertices=true` to return the vertices of a star instead of drawing it.
"""

function star(x::Real, y::Real, radius::Real, npoints::Int64=5, ratio::Real=0.5, orientation=0, action=:nothing; vertices = false, reversepath=false)
    outerpoints = [Point(x+cos(orientation + n * 2pi/npoints) * radius,
                    y+sin(orientation + n * 2pi/npoints) * radius) for n in 1:npoints]
    innerpoints = [Point(x+cos(orientation + (n + 1/2) * 2pi/npoints) * (radius * ratio),
                    y+sin(orientation + (n + 1/2) * 2pi/npoints) * (radius * ratio)) for n in 1:npoints]
    result = Point[]
    for i in eachindex(outerpoints)
        push!(result, outerpoints[i])
        push!(result, innerpoints[i])
    end
    if reversepath
        result = reverse(result)
    end
    if vertices
      return result
    else
      poly(result, action, close=true)
    end
end

"""
Draw a star centered at a position:

    star(center, radius, npoints=5, ratio=0.5, orientation=0, action=:nothing; vertices = false, reversepath=false)
"""

star(centerpoint::Point, radius::Real, npoints::Int64=5, ratio::Real=0.5, orientation=0, action=:nothing; vertices = false, reversepath=false) = star(centerpoint.x, centerpoint.y, radius, npoints, ratio, orientation, action; vertices = vertices, reversepath=reversepath)

"""
Is a point `p` inside a polygon `pol`?

    isinside(p, pol)

Returns true or false.

This is an implementation of the Hormann-Agathos (2001) Point in Polygon algorithm
"""
function isinside(p::Point, pointlist::Array)
    c = false
    detq(q1, q2) = (q1.x - p.x) * (q2.y - p.y) - (q2.x - p.x) * (q1.y - p.y)
    for counter in 1:length(pointlist)
        q1 = pointlist[counter]
        # if reached last point, set "next point" to first point
        if counter == length(pointlist)
            q2 = pointlist[1]
        else
            q2 = pointlist[counter + 1]
        end
        if q1 == p
            error("VertexException")
        end
        if q2.y == p.y
            if q2.x == p.x
                error("VertexException")
            elseif (q1.y == p.y) && ((q2.x > p.x) == (q1.x < p.x))
                error("EdgeException")
            end
        end
        if (q1.y < p.y) != (q2.y < p.y) # crossing
            if q1.x >= p.x
                if q2.x > p.x
                    c = !c
                elseif ((detq(q1,q2) > 0) == (q2.y > q1.y)) # right crossing
                    c = !c
                end
            elseif q2.x > p.x
                if ((detq(q1,q2) > 0) == (q2.y > q1.y))     # right crossing
                    c = !c
                end
            end
        end
    end
    return c
end

"""
Split a polygon into two where it intersects with a line:

    polysplit(p, p1, p2)

This doesn't always work, of course. (Tell me you're not surprised.) For example, a polygon the shape of the
letter "E" might end up being divided into more than two parts.
"""
function polysplit(pointlist, p1, p2)
    poly1 = []
    poly2 = []
    i = 1
    for i in 1:length(pointlist)-1
        s = ((p2.x - p1.x) * (pointlist[i].y - p1.y)) - ((p2.y - p1.y) * (pointlist[i].x - p1.x))
        flag, intersectpoint = intersection(pointlist[i], pointlist[i+1], p1, p2)
        if flag
            push!(poly1, intersectpoint)
            push!(poly2, intersectpoint)
        end
        if s > 0
            push!(poly1, pointlist[i])
        elseif isapprox(s, 0.0)
            push!(poly1, pointlist[i])
            push!(poly2, pointlist[i])
        else
            push!(poly2, pointlist[i])
        end
    end
    # don't forget last point to first
    i += 1
    s = ((p2.x - p1.x) * (pointlist[i].y - p1.y)) - ((p2.y - p1.y) * (pointlist[i].x - p1.x))
    flag, intersectpoint = intersection(pointlist[i], pointlist[1], p1, p2)
    if flag
        push!(poly1, intersectpoint)
        push!(poly2, intersectpoint)
    end
    if s > 0
        push!(poly1, pointlist[i])
    elseif isapprox(s, 0.0)
        push!(poly1, pointlist[i])
        push!(poly2, pointlist[i])
    else
        push!(poly2, pointlist[i])
    end

    return(poly1, poly2)
end

"""
Draw the polygon defined by points in `pointlist`, possibly closing and reversing it, using the current parameters,
and then evaluate (using `eval`, *shudder*) the expression at every vertex of the polygon. For example, you can mark each vertex of a polygon with a filled circle.

    prettypoly(pointlist::Array,
      action = :nothing,
      vertex_action::Expr = :(circle(0, 0, 1, :fill));
      close=false,
      reversepath=false)

Example:

    prettypoly(pl, :fill, :(scale(0.1, 0.1);
                            circle(0, 0, 10, :fill)
                           ),
              close=false)

The expression can't use definitions that are not in scope, eg you can't pass a variable in from the calling
function and expect this function to know about it. Yes, not tidy...
"""
function prettypoly(pointlist::Array, action = :nothing, vertex_action::Expr = :(circle(0, 0, 1, :fill)); close=false, reversepath=false)
    # by default doesn't close or fill, to allow for clipping etc
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
    for p in pointlist
        gsave()
        translate(p.x, p.y)
        eval(vertex_action)
        grestore()
    end
end

function getproportionpoint(point::Point, segment, length, dx, dy)
    factor = segment / length
    return Point((point.x - dx * factor), (point.y - dy * factor))
end

function drawroundedcorner(cornerpoint, p1, p2, radius, path; debug=false)
    dx1 = cornerpoint.x - p1.x     # vector 1
    dy1 = cornerpoint.y - p1.y
    dx2 = cornerpoint.x - p2.x     # vector 2
    dy2 = cornerpoint.y - p2.y

    # Angle between vector 1 and vector 2 divided by 2
    angle2 = (atan2(dy1, dx1) - atan2(dy2, dx2)) / 2

    #  length of segment between corner point and the
    #  points of intersection with the circle of a given radius
    t = abs(tan(angle2))
    segment = radius / t

    # Check the segment
    length1 = hypot(dx1, dy1)
    length2 = hypot(dx2, dy2)
    length = min(length1, length2)
    if segment > length
        segment = length
        radius = length * t
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
    startangle = atan2(p1_cross.y - circlepoint.y, p1_cross.x - circlepoint.x)
    endangle   = atan2(p2_cross.y - circlepoint.y, p2_cross.x - circlepoint.x)

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

Make a polygon from `points`, but round any sharp corners by making them arcs with the given
radius.

In fact, the arcs are sometimes different sizes: if the given radius is bigger than the
length of the shortest side, the arc can't be drawn at its full radius and is therefore
drawn as large as possible (as large as the shortest side allows).

The `debug` option draws the construction circles at each corner.
"""
function polysmooth(points, radius, action=:action; debug=false)
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
            line(p)    # add line segement
        elseif c == :arc
            arc(p...)  # add clockwise arc segment
        elseif c == :carc
            carc(p...) # add counterclockwise arc segment
        end
    end
    do_action(action)
end

# end
