"""
    rect(xmin, ymin, w, h; action=:none)
    rect(xmin, ymin, w, h, action)

Create a rectangle with one corner at (`xmin`/`ymin`) with
width `w` and height `h`, and add it to the current path.
Then apply `action`.

Returns a tuple of two points, the corners of a bounding box
that encloses the rectangle.

See `box()` for more ways to do similar things, such as
supplying two opposite corners, placing by centerpoint and
dimensions.
"""
function rect(xmin::Real, ymin::Real, w::Real, h::Real;
        action = :none)
    if action != :path
        newpath()
    end
    Cairo.rectangle(get_current_cr(), xmin, ymin, w, h)
    do_action(action)
    return Point(xmin, ymin), Point(xmin + w, ymin + h)
end

rect(xmin::Real, ymin::Real, w::Real, h::Real, action::Symbol) = rect(xmin, ymin, w, h, action = action)

"""
    rect(cornerpoint, w, h; action = none, reversepath=false,
        vertices=false)
    rect(cornerpoint, w, h, action; reversepath=false,
        vertices=false)

Create a rectangle with one corner at `cornerpoint` with
width `w` and height `h`, and add it to the current path.
Then apply `action`.

Use `vertices=true` to return an array of the four corner
points: bottom left, top left, top right, bottom right.

`reversepath` reverses the direction of the path (and
returns points in the order: bottom left, bottom right, top
right, top left).

Returns the four corner vertices.
"""
function rect(cornerpoint::Point, w::Real, h::Real;
        action = :none,
        reversepath = false,
        vertices = false)

    pts =  [
        Point(cornerpoint.x,     cornerpoint.y + h),
        Point(cornerpoint.x,     cornerpoint.y),
        Point(cornerpoint.x + w, cornerpoint.y),
        Point(cornerpoint.x + w, cornerpoint.y + h)
        ]
    if reversepath == true
        pts = pts[[1, 4, 3, 2]]
    end
    if vertices == false && action != :none
        move(pts[1])
        line(pts[2])
        line(pts[3])
        line(pts[4])
        closepath()
        do_action(action)
    end
    return pts
end

rect(cornerpoint::Point, w::Real, h::Real, action::Symbol;
        reversepath = false,
        vertices = false) = rect(cornerpoint, w, h;
                action = action,
                reversepath = reversepath,
                vertices = vertices)

"""
    box(cornerpoint1, cornerpoint2; action=:none, vertices=false, reversepath=false)
    box(cornerpoint1, cornerpoint2, action; vertices=false, reversepath=false)

Create a box (rectangle) between two points and add it to
the current path. Then apply `action`.

Use `vertices=true` to return an array of the four corner
points: bottom left, top left, top right, bottom right
rather than execute action.

`reversepath` reverses the direction of the path (and
returns points in the order: bottom left, bottom right, top
right, top left).
"""
function box(corner1::Point, corner2::Point;
        action::Symbol=:none,
        reversepath=false,
        vertices=false)
    # rearrange to get topleft -> bottom right
    # I'm not sure whether this is worth doing just
    # to get the order of vertices correct
    xmin, xmax = extrema((corner1.x, corner2.x))
    ymin, ymax = extrema((corner1.y, corner2.y))

    c1 = Point(xmin, ymin)
    c2 = Point(xmax, ymax)
    pts = [
        Point(c1.x, c2.y),
        Point(c1.x, c1.y),
        Point(c2.x, c1.y),
        Point(c2.x, c2.y)
        ]
    if reversepath == true
        pts = pts[[1, 4, 3, 2]]
    end
    if vertices == false && action != :none
        move(pts[1])
        line(pts[2])
        line(pts[3])
        line(pts[4])
        closepath()
        do_action(action)
    end
    return pts
end

box(corner1::Point, corner2::Point, action::Symbol;
        reversepath=false,
        vertices=false) = box(corner1, corner2;
                action=action,
                reversepath=reversepath,
                vertices=vertices)

"""
    box(points::Array; action=:none,
        reversepath=reversepath,
        vertices=vertices)
    box(points::Array; action=:none,
        reversepath=reversepath,
        vertices=vertices)

Create a box/rectangle using the first two points of an
array of Points to defined opposite corners, and add it to
the current path. Then apply `action`.

Use `vertices=true` to return an array of the four corner
points: bottom left, top left, top right, bottom right
rather than execute action.
"""
box(bbox::Array, action::Symbol; kwargs...) =
    box(bbox[1], bbox[2], action; kwargs...)

box(bbox::Array; kwargs...) =
    box(bbox[1], bbox[2]; kwargs...)

"""
    box(pt::Point, width, height; action=:none, vertices=false)
    box(pt::Point, width, height, action=:none; vertices=false)

Create a box/rectangle centered at point `pt` with width and
height. Use `vertices=true` to return an array of the four
corner points rather than apply the action.

`reversepath` reverses the direction of the path.
"""
function box(pt::Point, width, height;
        action = :none,
        reversepath = false,
        vertices = false)
    pts = [
        Point(pt.x - width/2, pt.y + height/2),
        Point(pt.x - width/2, pt.y - height/2),
        Point(pt.x + width/2, pt.y - height/2),
        Point(pt.x + width/2, pt.y + height/2)
        ]
    if reversepath == true
        pts = pts[[1, 4, 3, 2]]
    end
    if vertices == false && action != :none
        move(pts[1])
        line(pts[2])
        line(pts[3])
        line(pts[4])
        closepath()
        do_action(action)
    end
    return pts
end

box(pt::Point, width, height, action::Symbol;
        reversepath = false,
        vertices = false) = box(pt, width, height;
                action = action,
                reversepath = reversepath,
                vertices = vertices)

box(x::Real, y::Real, width::Real, height::Real, action::Symbol) =
    rect(x - width/2.0, y - height/2.0, width, height, action)

box(x::Real, y::Real, width::Real, height::Real; action::Symbol=:none) =
    rect(x - width/2.0, y - height/2.0, width, height, action)

"""
    box(pt, width, height, cornerradius, action=:none)
    box(pt, width, height, cornerradius; action=:none)

Draw a box/rectangle centered at point `pt` with `width` and `height` and
round each corner by `cornerradius`.

The constructed path consists of arcs and straight lines.
"""
box(centerpoint::Point, width, height, cornerradius::Real, action::Symbol) =
    box(centerpoint, width, height, fill(cornerradius, 4), action=action)

box(centerpoint::Point, width, height, cornerradius::Real; action=:none) =
    box(centerpoint, width, height, fill(cornerradius, 4), action=action)

"""
    box(pt, width, height, cornerradii::Array; action=:none)
    box(pt, width, height, cornerradii::Array, action=:none)

Draw a box/rectangle centered at point `pt` with `width` and `height` and
round each corner by the corresponding value in the array `cornerradii`.

The constructed path consists of arcs and straight lines.

The first corner is the one at the bottom left, the second at
the top left, and so on.

## Example

```
@draw begin
    box(O, 120, 120, [0, 20, 40, 60], :fill)
end
```
"""
function box(centerpoint::Point, width, height, cornerradii::Array;
        action=:none)
    gsave()
    translate(centerpoint)

    length(cornerradii) != 4 && throw(error("box() must have four values to specify rounded corners"))

    # bottom left
    p1start  = Point(O.x - width/2 + cornerradii[1], O.y + height/2)
    p1center = Point(O.x - width/2 + cornerradii[1], O.y + height/2 - cornerradii[1])
    p1end    = Point(O.x - width/2, O.y + height/2 - cornerradii[1])

    # top left
    p2start  = Point(O.x - width/2, O.y - height/2 + cornerradii[2])
    p2center = Point(O.x - width/2 + cornerradii[2], O.y - height/2 + cornerradii[2])
    p2end    = Point(O.x - width/2 + cornerradii[2], O.y - height/2)

    # top right
    p3start  = Point(O.x + width/2 - cornerradii[3], O.y - height/2)
    p3center = Point(O.x + width/2 - cornerradii[3], O.y - height/2 + cornerradii[3])
    p3end    = Point(O.x + width/2, O.y - height/2 + cornerradii[3])

    # bottom right
    p4start  = Point(O.x + width/2, O.y + height/2 - cornerradii[4])
    p4center = Point(O.x + width/2 - cornerradii[4], O.y + height/2 - cornerradii[4])
    p4end    = Point(O.x + width/2 - cornerradii[4], O.y + height/2)

    #  start at bottom center then bottomleft→topleft→topright→bottomright
    newpath()
    move(Point(O.x, O.y + height/2))

    line(p1start)
    arc(p1center, cornerradii[1], π/2, π, :none)
    line(p1end)

    line(p2start)
    arc(p2center, cornerradii[2], π, (3π)/2, :none)
    line(p2end)

    line(p3start)
    arc(p3center, cornerradii[3], 3π/2, 0, :none)
    line(p3end)

    line(p4start)
    arc(p4center, cornerradii[4], 0, π/2, :none)
    line(p4end)

    closepath()
    grestore()
    do_action(action)
    return Point(centerpoint.x - width/2, centerpoint.y - height/2),
           Point(centerpoint.x + width/2, centerpoint.y + height/2)
end

box(centerpoint::Point, width, height, cornerradii::Array, action::Symbol) =
     box(centerpoint::Point, width, height, cornerradii::Array, action=action)

"""
    ngon(x, y, radius, sides=5, orientation=0;
        action = :none,
        vertices = false,
        reversepath = false)

Draw a regular polygon centered at point `centerpos`.
"""
function ngon(x::Real, y::Real, radius::Real, sides::Int=5, orientation=0.0;
            action=:none,
            vertices=false,
            reversepath=false)
    ptlist = [Point(x+cos(orientation + n * 2pi/sides) * radius,
                    y+sin(orientation + n * 2pi/sides) * radius) for n in 1:sides]
    if !vertices
        poly(ptlist, action=action, close=true, reversepath=reversepath)
    end
    return ptlist
end

ngon(x::Real, y::Real, radius::Real, sides::Int, action::Symbol) =
    ngon(x, y, radius, sides, action=action, vertices=false, reversepath=false)

ngon(x::Real, y::Real, radius::Real, sides::Int, orientation::Real, action::Symbol) =
    ngon(x, y, radius, sides, orientation, action=action, vertices=false, reversepath=false)

# Point version
"""
    ngon(centerpos, radius, sides=5, orientation=0;
        action=:none,
        vertices=false,
        reversepath=false)

Draw a regular polygon centered at point `centerpos`.

Find the vertices of a regular n-sided polygon centered at `x`, `y` with
circumradius `radius`.

The polygon is constructed counterclockwise, starting with the first vertex
drawn below the positive x-axis.

If you just want the raw points, use keyword argument `vertices=true`, which
returns the array of points. Compare:

```julia
ngon(0, 0, 4, 4, 0, vertices=true) # returns the polygon's points:

4-element Array{Luxor.Point, 1}:
Luxor.Point(2.4492935982947064e-16, 4.0)
Luxor.Point(-4.0, 4.898587196589413e-16)
Luxor.Point(-7.347880794884119e-16, -4.0)
Luxor.Point(4.0, -9.797174393178826e-16)
```

whereas

```
ngon(0, 0, 4, 4, 0, :close) # draws a polygon
```
"""
ngon(centerpoint::Point, radius, sides::Int=5, orientation=0.0;
        action=:none, vertices=false, reversepath=false) = ngon(centerpoint.x, centerpoint.y, radius, sides, orientation,
        action=action, vertices=vertices, reversepath=reversepath)

# action as argument

# this is a bit untidy?
ngon(centerpoint::Point, radius::Real, sides::Int, orientation::Real, a::Symbol;
        action=:none, vertices=false, reversepath=false) = ngon(centerpoint, radius, sides, orientation,
        action=a, vertices=vertices, reversepath=reversepath)

"""
    ngonside(centerpoint::Point, sidelength::Real, sides::Int=5, orientation=0;
            action=:none,
            vertices=false,
            reversepath=false)
    ngonside(centerpoint::Point, sidelength::Real, sides::Int, orientation, action;
            vertices=false,
            reversepath=false)

Draw a regular polygon centered at `centerpoint` with `sides` sides of length `sidelength`.
"""
function ngonside(centerpoint::Point, sidelength::Real, sides::Int=5, orientation=0;
        action=:none,
        vertices=false,
        reversepath=false)
    radius = 0.5 * sidelength * csc(pi/sides)
    ngon(centerpoint, radius, sides, orientation, action=action,
        vertices=vertices,
        reversepath=reversepath)
end

ngonside(centerpoint::Point, sidelength::Real, sides::Int, orientation::Real, action::Symbol;
        vertices=false,
        reversepath=false) = ngonside(centerpoint, sidelength, sides, orientation, action=action,
        vertices=vertices, reversepath=reversepath)

ngonside(centerpoint::Point, sidelength::Real, sides::Int, action::Symbol;
        vertices=false,
        reversepath=false) = ngonside(centerpoint, sidelength, sides, action=action,
        vertices=vertices, reversepath=reversepath)

function star(x::Real, y::Real, radius::Real, npoints::Int=5, ratio::Real=0.5, orientation=0;
        action=:none,
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
    if !vertices
        poly(result, action=action, close=true)
    end
    return result
end

"""
    star(center, radius, npoints, ratio=0.5, orientation, action=:none;
        vertices = false, reversepath=false)
    star(center, radius, npoints, ratio=0.5, orientation=0.0;
        action=:none, vertices = false, reversepath=false)

Make a star centered at `center` with `npoints` sections oriented by `orientation`.
`ratio` specifies the height of the smaller radius of the
star relative to the larger.

Returns the vertices of the star.

Use `vertices=true` to only return the vertices of a star
instead of making it.

## Examples

```julia
star(O, 120, 5, 0.5, 0.0, :fill,
    vertices = false,
    reversepath=false)

star(O, 220, 5, 0.5;
    action=:stroke,
    vertices = false,
    reversepath=false)
```
"""
function star(centerpoint::Point, radius::Real, npoints::Int=5, ratio::Real=0.5, orientation=0;
              action=:none,
              vertices=false,
              reversepath=false)
    star(centerpoint.x, centerpoint.y, radius, npoints, ratio, orientation, action=action,
         vertices = vertices, reversepath=reversepath)
end

star(x::Real, y::Real, radius::Real, npoints::Int, ratio::Real, orientation, a::Symbol;
    action=:none,
    vertices = false,
    reversepath=false) = star(Point(x, y), radius, npoints, ratio, orientation,
    action=a, vertices = vertices, reversepath=reversepath)

star(pt::Point, radius::Real, npoints::Int, ratio::Real, orientation, a::Symbol;
    action=:none,
    vertices = false,
    reversepath=false) = star(pt, radius, npoints, ratio, orientation,
    action=a, vertices = vertices, reversepath=reversepath)

"""
    cropmarks(center, width, height)

Draw cropmarks (also known as trim marks). Use current color.
"""
function cropmarks(center, width, height)
    gap = 5
    crop = 15
    gsave()
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

"""
    polycross(pt::Point, radius, npoints::Int, ratio=0.5, orientation=0.0;
        action      = :none,
        splay       = 0.5,
        vertices    = false,
        reversepath = false)
    polycross(pt::Point, radius, npoints::Int, ratio=0.5, orientation=0.0, action;
        splay       = 0.5,
        vertices    = false,
        reversepath = false)

Make a cross-shaped polygon with `npoints` arms to fit
inside a circle of radius `radius` centered at `pt`.

`ratio` specifies the ratio of the two sides of each arm.
`splay` makes the arms ... splayed.

Use `vertices=true` to return the vertices of the shape
instead of executing the action.

(Adapted from Compose.jl.xgon()))

## Examples

```julia
polycross(O, 100, 5,
    action = :fill,
    splay  = 0.5)

polycross(O, 120, 5, 0.5, 0.0, :stroke,
    splay  = 0.5)
```
"""
function polycross(pt::Point, radius::Real, npoints::Int, ratio=0.5, orientation=0.0;
        action      = :none,
        splay       = .5,
        vertices    = false,
        reversepath = false)
    # adapted from:    Compose.jl, https://github.com/GiovineItalia/Compose.jl/src/form.jl
    # original author: mattriks

    ratio = clamp(ratio, 0.0, 1.0)

    θ₁ = range(π/2 + orientation + 0, stop = π/2 + orientation + 2π, length = npoints + 1)[1:end-1]

    width = 2radius * ratio * sin(π/npoints)

    dₒ = asin(clamp(splay * width/radius, -1.0, 1.0))
    dᵢ = asin(0.5 * width/(radius * ratio))

    r₂ = repeat([radius * ratio, radius, radius], outer = npoints)
    θ₂ = vec([mod2pi(θ + x) for x in [-dᵢ, -dₒ, dₒ], θ in θ₁])

    pts = @. Point.(pt.x .+ r₂ .* cos.(θ₂), pt.y .+ r₂ .* sin.(θ₂))
    if reversepath
        reverse!(pts)
    end
    if !vertices
        poly(pts, action=action, close=true)
    end
    return pts
end

polycross(pt::Point, radius::Real, npoints::Int, ratio, orientation::Real, action::Symbol;
    splay       = .5,
    vertices    = false,
    reversepath = false) = polycross(pt, radius, npoints, ratio, orientation,
        action = action,
        splay       = splay,
        vertices    = vertices,
        reversepath = reversepath)
