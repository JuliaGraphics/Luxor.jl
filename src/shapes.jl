"""
    rect(xmin, ymin, w, h, action)

Create a rectangle with one corner at (`xmin`/`ymin`) with width `w` and height `h` and then
do an action.

See `box()` for more ways to do similar things, such as supplying two opposite corners,
placing by centerpoint and dimensions.
"""
function rect(xmin, ymin, w, h, action::Symbol=:nothing)
    if action != :path
        newpath()
    end
    Cairo.rectangle(currentdrawing.cr, xmin, ymin, w, h)
    do_action(action)
end

"""
    rect(cornerpoint, w, h, action)

Create a rectangle with one corner at `cornerpoint` with width `w` and height `h` and do an
action.
"""
rect(cornerpoint::Point, w, h, action::Symbol) =
    rect(cornerpoint.x, cornerpoint.y, w, h, action)

"""
    box(cornerpoint1, cornerpoint2, action=:nothing)

Create a rectangle between two points and do an action.
"""
box(corner1::Point, corner2::Point, action::Symbol=:nothing) =
    rect(corner1.x, corner1.y, corner2.x - corner1.x, corner2.y - corner1.y, action)

"""
    box(points::Array, action=:nothing)

Create a box/rectangle using the first two points of an array of Points to defined
opposite corners.
"""
box(bbox::Array, action::Symbol=:nothing) = box(bbox[1], bbox[2], action)

"""
    box(pt::Point, width, height, action=:nothing; vertices=false)

Create a box/rectangle centered at point `pt` with width and height. Use `vertices=true` to
return an array of the four corner points rather than draw the box.
"""
function box(pt::Point, width, height, action::Symbol=:nothing; vertices=false)
    if vertices
        return [Point(pt.x - width/2, pt.y + height/2),
                Point(pt.x - width/2, pt.y - height/2),
                Point(pt.x + width/2, pt.y - height/2),
                Point(pt.x + width/2, pt.y + height/2)]
    end
    rect(pt.x - width/2, pt.y - height/2, width, height, action)
end

"""
    box(x, y, width, height, action=:nothing)

Create a box/rectangle centered at point `x/y` with width and height.
"""
box(x::Real, y::Real, width::Real, height::Real, action::Symbol=:nothing) =
    rect(x - width/2.0, y - height/2.0, width, height, action)

"""
    box(x, y, width, height, cornerradius, action=:nothing)

Create a box/rectangle centered at point `x/y` with `width` and `height`. Round each corner
by `cornerradius`.
"""
function box(centerpoint::Point, width, height, cornerradius, action::Symbol=:stroke)
    gsave()
    translate(centerpoint)
    # go clockwise around box
    p1center = Point(O.x + width/2 - cornerradius, O.y + height/2 - cornerradius) # bottom right
    p1start  = Point(O.x + width/2, O.y + height/2 - cornerradius)
    p1end    = Point(O.x + width/2 - cornerradius, O.y + height/2)

    p2center = Point(O.x - width/2 + cornerradius, O.y + height/2 - cornerradius) # bottom left
    p2start  = Point(O.x - width/2 + cornerradius, O.y + height/2)
    p2end    = Point(O.x - width/2, O.y + height/2 - cornerradius)

    p3center = Point(O.x - width/2 + cornerradius, O.y - height/2 + cornerradius) # top left
    p3start  = Point(O.x - width/2, O.y - height/2 + cornerradius)
    p3end    = Point(O.x - width/2 + cornerradius, O.y - height/2)

    p4center = Point(O.x + width/2 - cornerradius, O.y - height/2 + cornerradius) # top right
    p4start  = Point(O.x + width/2 - cornerradius, O.y - height/2)
    p4end    = Point(O.x + width/2, O.y - height/2 + cornerradius)

    newpath()
    move(Point(O.x + width/2, O.y))
    line(p1start)
    arc(p1center, cornerradius, 0, pi/2, :none)
    line(p1end)
    line(p2start)

    arc(p2center, cornerradius, pi/2, pi, :none)
    line(p2end)
    line(p3start)

    arc(p3center, cornerradius, pi, (3pi)/2, :none)
    line(p3end)
    line(p4start)

    arc(p4center, cornerradius, (3pi)/2, 2pi, :none)
    line(p4end)
    line(p1start)

    closepath()
    do_action(action)
    grestore()
end

"""
    ngon(x, y, radius, sides=5, orientation=0, action=:nothing;
        vertices=false, reversepath=false)

Find the vertices of a regular n-sided polygon centered at `x`, `y`:

`ngon()` draws the shapes: if you just want the raw points, use keyword argument
`vertices=true`, which returns the array of points instead. Compare:

```julia
ngon(0, 0, 4, 4, 0, vertices=true) # returns the polygon's points:

    4-element Array{Luxor.Point,1}:
    Luxor.Point(2.4492935982947064e-16,4.0)
    Luxor.Point(-4.0,4.898587196589413e-16)
    Luxor.Point(-7.347880794884119e-16,-4.0)
    Luxor.Point(4.0,-9.797174393178826e-16)
```

whereas

```
ngon(0, 0, 4, 4, 0, :close) # draws a polygon
```
"""
function ngon(x::Real, y::Real, radius::Real, sides::Int=5, orientation=0, action=:nothing;
              vertices=false,
              reversepath=false)
    ptlist = [Point(x+cos(orientation + n * 2pi/sides) * radius,
                    y+sin(orientation + n * 2pi/sides) * radius) for n in 1:sides]
    if vertices
        ptlist
    else
        poly(ptlist, action, close=true, reversepath=reversepath)
    end
end

"""
    ngon(centerpos, radius, sides=5, orientation=0, action=:nothing;
        vertices=false,
        reversepath=false)

Draw a regular polygon centered at point `p`:
"""

ngon(centerpoint::Point, radius::Real, sides::Int=5, orientation=0, action=:nothing; kwargs...) =
    ngon(centerpoint.x, centerpoint.y, radius, sides, orientation, action; kwargs...)

"""
    star(xcenter, ycenter, radius, npoints=5, ratio=0.5, orientation=0, action=:nothing;
        vertices = false,
        reversepath=false)

Make a star.  `ratio` specifies the height of the smaller radius of the star relative to the
larger.

Use `vertices=true` to return the vertices of a star instead of drawing it.
"""
function star(x::Real, y::Real, radius::Real, npoints::Int=5, ratio::Real=0.5,
    orientation=0, action=:nothing;
    vertices = false,
    reversepath=false)
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
        result
    else
        poly(result, action, close=true)
    end
end

"""
    star(center, radius, npoints=5, ratio=0.5, orientation=0, action=:nothing;
        vertices = false, reversepath=false)

Draw a star centered at a position:
"""

function star(centerpoint::Point, radius::Real, npoints::Int=5, ratio::Real=0.5, orientation=0,
              action=:nothing;
              vertices=false,
              reversepath=false)
    star(centerpoint.x, centerpoint.y, radius, npoints, ratio, orientation, action;
         vertices = vertices, reversepath=reversepath)
end

"""
    cropmarks(center, width, height)

Draw cropmarks (also known as trim marks).
"""
function cropmarks(center, width, height)
    gap = 5
    crop = 15
    gsave()
    setcolor("black")
    setline(0.5)
    setdash("solid")
    # horizontal top left
    line(Point(-width/2 - gap - crop, -height/2),
         Point(-width/2 - gap, -height/2),
         :stroke)

    # horizontal bottom left
    line(Point(-width/2 - gap - crop, height/2),
         Point(-width/2 - gap, height/2),
         :stroke)

    # horizontal top right
    line(Point(width/2 + gap, -height/2),
         Point(width/2 + gap + crop, -height/2),
         :stroke)

    # horizontal bottom right
    line(Point(width/2 + gap, height/2),
         Point(width/2 + gap + crop, height/2),
         :stroke)

    # vertical top left
    line(Point(-width/2, -height/2 - gap - crop),
         Point(-width/2, -height/2 - gap),
         :stroke)

    # vertical bottom left
    line(Point(-width/2, height/2 + gap),
         Point(-width/2, height/2 + gap + crop),
         :stroke)

    # vertical top right
    line(Point(width/2, -height/2 - gap - crop),
         Point(width/2, -height/2 - gap),
         :stroke)

    # vertical bottom right
    line(Point(width/2, height/2 + gap),
         Point(width/2, height/2 + gap + crop),
         :stroke)

    grestore()
end
