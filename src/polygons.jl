# polygons

# a polygon is an Array of Points

function poly(pointlist::Array, action = :nothing; close=false, reversepath=false)
    # where pointlist is array of Points
    # by default doesn't close or fill, to allow for clipping.etc
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

function point_line_distance(p::Point, a, b)
    # area of triangle
    area = abs(0.5 * (a.x * b.y + b.x * p.y + p.x * a.y - b.x * a.y - p.x * b.y - a.x * p.y))
    # length of the bottom edge
    dx = a.x - b.x
    dy = a.y - b.y
    bottom = sqrt(dx * dx + dy * dy)
    return area / bottom
end

"""
    Find midpoint between two points.

    midpoint(p1, p2)

"""

midpoint(p1::Point, p2::Point) = Point((p1.x + p2.x) / 2, (p1.y + p2.y) / 2)
midpoint(pt::Array) = midpoint(pt[1], pt[2])

"""
    Find intersection of two lines p1-p2 and p3-p4

        intersection(p1, p2, p3, p4)

    returns (false, 0)
         or (true, Point)

"""

function intersection(p1, p2, p3, p4)
    flag = false
    ip = 0
    s1 = p2 - p1
    s2 = p4 - p3
    u = p1 - p3
    ip = 1 / (-s2.x * s1.y + s1.x * s2.y)
    s = (-s1.y * u.x + s1.x * u.y) * ip
    t = ( s2.x * u.y - s2.y * u.x) * ip
    if (s >= 0) && (s <= 1) && (t >= 0) && (t <= 1)
        if isapprox(ip, 0, atol=0.1)
            ip = p1 + (s1 * t)
            flag = true
        end
    end
    return (flag, ip)
end

"""

    Bounding box of polygon (array of points).

    Return two points of opposite corners.

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
    Find centroid of simple polygon.

        polycentroid(pointlist)

    Only works for simple (non-intersecting) polygons.
    This isn't a CAD system... :)

    Returns a point.
"""

function polycentroid(pointlist)
    centroid = Point(0, 0)
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
        centroid.x += (x0 + x1)*a
        centroid.y += (y0 + y1)*a
   end
    # Do last vertex separately to avoid performing an expensive
    # modulus operation in each iteration.
    x0 = pointlist[vertexCount].x
    y0 = pointlist[vertexCount].y
    x1 = pointlist[1].x
    y1 = pointlist[1].y
    a = x0*y1 - x1*y0
    signedArea += a
    centroid.x += (x0 + x1)*a
    centroid.y += (y0 + y1)*a

    signedArea *= 0.5
    centroid.x /= (6.0*signedArea)
    centroid.y /= (6.0*signedArea)

    return centroid
end

"""
    Sort the points of a polygon into order. Points
    are sorted according to the angle they make with a specified point.

        polysortbyangle(parray, parray[1])

    `refpoint` can be chosen, minimum point is usually OK:

        polysortbyangle(parray, polycentroid(parray))

"""

function polysortbyangle(pointlist::Array, refpoint=minimum(pointlist))
    angles = []
    for pt in pointlist
        push!(angles, atan2(refpoint.y - pt.y, refpoint.x - pt.x))
    end
    return pointlist[sortperm(angles)]
end

"""
    Sort polygon by finding the nearest point to the starting point, then
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


# use non-recursive Douglas-Peucker algorithm to simplify polygon
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

function simplify(pointlist::Array, detail)
    douglas_peucker(pointlist, 1, length(pointlist), detail)
end

"""
    Regular polygons.

    Draw a poly centred at x,y:

        ngon(x, y, radius, sides, orientation, action; close=true, reversepath=false)

    If no action supplied, return a poly as a set of points

        ngon(x, y, radius, sides, orientation; close=true, reversepath=false)

"""

function ngon(x::Real, y::Real, radius::Real, sides::Int64, orientation=0, action=:nothing; close=true, reversepath=false)
    poly([Point(x+cos(orientation + n * 2pi/sides) * radius,
           y+sin(orientation + n * 2pi/sides) * radius) for n in 1:sides], close=close, action, reversepath=reversepath)
end

ngon(centrepoint::Point, radius::Real, sides::Int64, orientation=0, action=:nothing; kwargs...) = ngon(centrepoint.x, centrepoint.y, radius, sides, orientation; kwargs...)

function ngon(x::Real, y::Real, radius::Real, sides::Int64, orientation=0)
    [Point(x+cos(orientation + n * 2pi/sides) * radius,
           y+sin(orientation + n * 2pi/sides) * radius) for n in 1:sides]
end

ngon(centrepoint::Point, radius::Real, sides::Int64, orientation=0) = ngon(centrepoint.x, centrepoint.y, radius, sides, orientation)

"""
    Is a point inside a polygon?

        isinside(p, poly)

    Return true or false
"""

function isinside(p::Point, pointlist::Array)
    # An implementation of Hormann-Agathos (2001) Point in Polygon algorithm
    c = false
    detq(q1,q2) = (q1.x - p.x) * (q2.y - p.y) - (q2.x - p.x) * (q1.y - p.y)
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
    Split a polygon into two where it intersects with a line

    polysplit(p, p1, p2)

    This doesn't always work, of course. For example, a polygon the shape of the
    letter "E" might be divided into more than two parts...

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
