"""
    origin()

Reset the current matrix, and then set the 0/0 origin to the center of the drawing
(otherwise it will stay at the top left corner, the default).

You can refer to the 0/0 point as `O`. (O = `Point(0, 0)`),
"""
function origin()
    setmatrix([1.0, 0.0, 0.0, 1.0, 0.0, 0.0])
    Cairo.translate(get_current_cr(), current_width()/2.0, current_height()/2.0)
end

function origin(x, y)
    setmatrix([1.0, 0.0, 0.0, 1.0, 0.0, 0.0])
    Cairo.translate(get_current_cr(), x, y)
end

"""
    origin(pt:Point)

Reset the current matrix, then move the `0/0` position to `pt`.
"""
function origin(pt)
    setmatrix([1.0, 0.0, 0.0, 1.0, 0.0, 0.0])
    Cairo.translate(get_current_cr(), pt.x, pt.y)
end

"""
    rescale(x, from_min, from_max, to_min, to_max)

Convert `x` from one linear scale (`from_min` to `from_max`) to another (`to_min` to `to_max`).

The scales can also be supplied in tuple form:

    rescale(x, (from_min, from_max), (to_min, to_max))

```jldoctest
using Luxor
julia> rescale(15, 0, 100, 0, 1)
0.15

julia> rescale(15, (0, 100), (0, 1))
0.15

julia> rescale(pi/20, 0, 2pi, 0, 1)
0.025

julia> rescale(pi/20, (0, 2pi), (0, 1))
0.025

julia> rescale(25, 0, 1, 0, 1.609344)
40.2336

julia> rescale(15, (0, 100), (1000, 0))
850.0
```

"""
rescale(x, from_min, from_max, to_min, to_max) =
    ((x - from_min) / (from_max - from_min)) * (to_max - to_min) + to_min
rescale(x, from::NTuple{2,Number}, to::NTuple{2, Number}) =
    ((x - from[1]) / (from[2] - from[1])) * (to[2] - to[1]) + to[1]

"""
    background(color)

Fill the canvas with a single color. Returns the (red, green, blue, alpha) values.

Examples:

    background("antiquewhite")
    background("ivory")

If Colors.jl is installed:

    background(RGB(0, 0, 0))
    background(Luv(20, -20, 30))

If you don't specify a background color for a PNG drawing, the background will
be transparent. You can set a partly or completely transparent background for
PNG files by passing a color with an alpha value, such as this 'transparent
black':

    background(RGBA(0, 0, 0, 0))

"""
function background(col::AbstractString)
   setcolor(col)
   paint()
   return (get_current_redvalue(), get_current_greenvalue(), get_current_bluevalue(), get_current_alpha())
end

function background(col::ColorTypes.Colorant)
    temp = convert(RGBA,  col)
    setcolor(temp.r, temp.g, temp.b, temp.alpha)
    paint()
    return (get_current_redvalue(), get_current_greenvalue(), get_current_bluevalue(), get_current_alpha())
end

function background(r, g, b)
    sethue(r, g, b)
    paint()
    return (get_current_redvalue(), get_current_greenvalue(), get_current_bluevalue(), get_current_alpha())
end

function background(r, g, b, a)
    setcolor(r, g, b, a)
    paint()
    return (get_current_redvalue(), get_current_greenvalue(), get_current_bluevalue(), get_current_alpha())
end

"""
    setantialias(n)

Set the current antialiasing to a value between 0 and 6:

    antialias_default  = 0, the default antialiasing for the subsystem and target device
    antialias_none     = 1, use a bilevel alpha mask
    antialias_gray     = 2, use single-color antialiasing (using shades of gray for black text on a white background, for example)
    antialias_subpixel = 3, take advantage of the order of subpixel elements on devices such as LCD panels
    antialias_fast     = 4, perform some antialiasing but prefer speed over quality
    antialias_good     = 5, balance quality against performance
    antialias_best     = 6, render at the highest quality, sacrificing speed if necessary

This affects graphics, but not text, and it doesn't apply to all types of output file.
"""
setantialias(n) = Cairo.set_antialias(get_current_cr(), n)

"""
    newpath()

Create a new path. This is Cairo's `new_path()` function.
"""
newpath() = Cairo.new_path(get_current_cr())

"""
    newsubpath()

Add a new subpath to the current path. This is Cairo's `new_sub_path()` function. It can
be used for example to make holes in shapes.
"""
newsubpath() = Cairo.new_sub_path(get_current_cr())

"""
    closepath()

Close the current path. This is Cairo's `close_path()` function.
"""
closepath() = Cairo.close_path(get_current_cr())

"""
    strokepath()

Stroke the current path with the current line width, line join, line cap, and dash settings.
The current path is then cleared.
"""
strokepath() = Cairo.stroke(get_current_cr())

"""
    fillpath()

Fill the current path according to the current settings. The current path is then cleared.
"""
fillpath() = Cairo.fill(get_current_cr())

"""
    paint()

Paint the current clip region with the current settings.
"""
paint() = Cairo.paint(get_current_cr())

"""
    strokepreserve()

Stroke the current path with current line width, line join, line cap, and dash
settings, but then keep the path current.
"""
strokepreserve()    = Cairo.stroke_preserve(get_current_cr())

"""
    fillpreserve()

Fill the current path with current settings, but then keep the path current.
"""
fillpreserve()      = Cairo.fill_preserve(get_current_cr())

"""
    fillstroke()

Fill and stroke the current path.
"""
function fillstroke()
    fillpreserve()
    strokepath()
end

"""
    do_action(action)

This is usually called by other graphics functions. Actions for graphics commands include
`:fill`, `:stroke`, `:clip`, `:fillstroke`, `:fillpreserve`, `:strokepreserve`, `:none`, and
`:path`.
"""
function do_action(action)
    if action == :fill
        fillpath()
    elseif action == :stroke
        strokepath()
    elseif action == :clip
        clip()
    elseif action == :fillstroke
        fillstroke()
    elseif action == :fillpreserve
        fillpreserve()
    elseif action == :strokepreserve
        strokepreserve()
    elseif action == :none
    end
    return true
end

"""
    clip()

Establish a new clipping region by intersecting the current clipping region with the
current path and then clearing the current path.
"""
clip() = Cairo.clip(get_current_cr())

"""
    clippreserve()

Establish a new clipping region by intersecting the current clipping region with the current
path, but keep the current path.
"""
clippreserve() = Cairo.clip_preserve(get_current_cr())

"""
    clipreset()

Reset the clipping region to the current drawing's extent.
"""
clipreset() = Cairo.reset_clip(get_current_cr())

"""
    setline(n)

Set the line width.
"""
setline(n) = Cairo.set_line_width(get_current_cr(), n)

"""
    setlinecap(s)

Set the line ends. `s` can be "butt" (the default), "square", or "round".
"""
function setlinecap(str="butt")
    if str == "round"
        Cairo.set_line_cap(get_current_cr(), Cairo.CAIRO_LINE_CAP_ROUND)
    elseif str == "square"
        Cairo.set_line_cap(get_current_cr(), Cairo.CAIRO_LINE_CAP_SQUARE)
    else
        Cairo.set_line_cap(get_current_cr(), Cairo.CAIRO_LINE_CAP_BUTT)
    end
end

"""
    setlinejoin("miter")
    setlinejoin("round")
    setlinejoin("bevel")

Set the line join style, or how to render the junction of two lines when stroking.
"""
function setlinejoin(str="miter")
    if str == "round"
        Cairo.set_line_join(get_current_cr(), Cairo.CAIRO_LINE_JOIN_ROUND)
    elseif str == "bevel"
        Cairo.set_line_join(get_current_cr(), Cairo.CAIRO_LINE_JOIN_BEVEL)
    else
        Cairo.set_line_join(get_current_cr(), Cairo.CAIRO_LINE_JOIN_MITER)
    end
end

"""
    setlinedash("dot")

Set the dash pattern to one of: "solid", "dotted", "dot", "dotdashed", "longdashed",
"shortdashed", "dash", "dashed", "dotdotdashed", "dotdotdotdashed"
"""
function setdash(dashing)
    Cairo.set_line_type(get_current_cr(), dashing)
end

"""
    move(pt)

Move to a point.
"""
move(x, y)      = Cairo.move_to(get_current_cr(),x, y)
move(pt)        = move(pt.x, pt.y)

"""
    rmove(pt)

Move relative to current position by the `pt`'s x and y:
"""
rmove(x, y)     = Cairo.rel_move_to(get_current_cr(),x, y)
rmove(pt)       = rmove(pt.x, pt.y)

"""
    line(pt)

Draw a line from the current position to the `pt`.
"""
line(x, y)      = Cairo.line_to(get_current_cr(),x, y)
line(pt)        = line(pt.x, pt.y)

"""
    line(pt1::Point, pt2::Point, action=:nothing)

Make a line between two points, `pt1` and `pt2` and do an action.
"""
function line(pt1::Point, pt2::Point, action=:nothing)
    move(pt1)
    line(pt2)
    do_action(action)
end

"""
    rline(pt)

Draw a line relative to the current position to the `pt`.
"""
rline(x, y)     = Cairo.rel_line_to(get_current_cr(), x, y)
rline(pt)       = rline(pt.x, pt.y)

"""
    rule(pos, theta;
        boundingbox=BoundingBox())

Draw a straight line through `pos` at an angle `theta` from the x axis.

By default, the line spans the entire drawing, but you can supply a BoundingBox
to change the extent of the line.

    rule(O)       # draws an x axis
    rule(O, pi/2) # draws a  y axis

The function:

    rule(O, pi/2, boundingbox=BoundingBox()/2)

draws a line that spans a bounding box half the width and height of the drawing.
"""
function rule(pos, theta=0.0;
        boundingbox=BoundingBox())
    bbox       = box(boundingbox, vertices=true)
    topside    = bbox[1:2]
    rightside  = bbox[2:3]
    bottomside = bbox[3:4]
    leftside   = vcat(bbox[4], bbox[1])

    #if !isinside(pos, bbox, allowonedge=true)
    #    #@warn "position is not inside bounding box"
    #end

    # ruled line could be as long as the diagonal so add a bit extra
    r = boxdiagonal(boundingbox)/2 + 10
    rcosa = r * cos(theta)
    rsina = r * sin(theta)
    ruledline = (pos - (rcosa, rsina), pos + (rcosa, rsina))

    # use set to avoid duplicating points
    interpoints = Set{Point}()

    # check for intersection with top of bounding box
    flag, ip = intersection(ruledline[1], ruledline[2], topside[1], topside[2])
    if flag
        if !(ip.x > topside[2].x || ip.x < topside[1].x)
            push!(interpoints, ip)
        end
    end

    # check for right intersection
    flag, ip = intersection(ruledline[1], ruledline[2], rightside[1], rightside[2])
    if flag
        if !(ip.y > rightside[2].y || ip.y < rightside[1].y)
            push!(interpoints, ip)
        end
    end

    # check for bottom intersection
    flag, ip = intersection(ruledline[1], ruledline[2], bottomside[1], bottomside[2])
    if flag
        if !(ip.x < bottomside[2].x || ip.x > bottomside[1].x)
            push!(interpoints, ip)
        end
    end

    # check for left intersection
    flag, ip = intersection(ruledline[1], ruledline[2], leftside[1], leftside[2])
    if flag
        if !(ip.y > leftside[1].y || ip.y < leftside[2].y)
            push!(interpoints, ip)
        end
    end

    # finally draw the line if we have two points
    length(interpoints) == 2 && line(interpoints..., :stroke)
    return interpoints
end

saved_colors = Tuple{Float64,Float64,Float64,Float64}[]

# I originally used simple Cairo save() but the colors/opacity
# thing I've got going didn't save/restore properly, hence the stack
"""
    gsave()

Save the current color settings on the stack.
"""
function gsave()
    Cairo.save(get_current_cr())
    r, g, b, a = (get_current_redvalue(),
                  get_current_greenvalue(),
                  get_current_bluevalue(),
                  get_current_alpha()
                 )
    push!(saved_colors, (r, g, b, a))
    return (r, g, b, a)
end

"""
    grestore()

Replace the current graphics state with the one on top of the stack.
"""
function grestore()
    Cairo.restore(get_current_cr())
    try
        (r, g, b, a) =  pop!(saved_colors)
        set_current_redvalue(r)
        set_current_greenvalue(g)
        set_current_bluevalue(b)
        set_current_alpha(a)
    catch err
         println("$err Not enough colors on the stack to restore.")
    end
end

"""
    The `layer` macro is a shortcut for `gsave()` ... `grestore()`.
"""
macro layer(a)
    quote
        gsave()
        $(esc(a))
        grestore()
    end
end

"""
    scale(x, y)

Scale workspace by `x` and `y`.

Example:

    scale(0.2, 0.3)

"""
scale(sx::Real, sy::Real) = Cairo.scale(get_current_cr(), sx, sy)

"""
    scale(f)

Scale workspace by `f` in both `x` and `y`.
"""
scale(f::Real) = Cairo.scale(get_current_cr(), f, f)

"""
    rotate(a::Float64)

Rotate workspace by `a` radians clockwise (from positive x-axis to positive y-axis).
"""
rotate(a) = Cairo.rotate(get_current_cr(), a)

"""
    translate(point)
    translate(x::Real, y::Real)

Translate the workspace to `x` and `y` or to `pt`.
"""
translate(tx::Real, ty::Real)        = Cairo.translate(get_current_cr(), tx, ty)
translate(pt::Point)     = translate(pt.x, pt.y)

"""
    getpath()

Get the current path and return a CairoPath object, which is an array of `element_type` and
`points` objects. With the results you can step through and examine each entry:

```
o = getpath()
for e in o
      if e.element_type == Cairo.CAIRO_PATH_MOVE_TO
          (x, y) = e.points
          move(x, y)
      elseif e.element_type == Cairo.CAIRO_PATH_LINE_TO
          (x, y) = e.points
          # straight lines
          line(x, y)
          strokepath()
          circle(x, y, 1, :stroke)
      elseif e.element_type == Cairo.CAIRO_PATH_CURVE_TO
          (x1, y1, x2, y2, x3, y3) = e.points
          # Bezier control lines
          circle(x1, y1, 1, :stroke)
          circle(x2, y2, 1, :stroke)
          circle(x3, y3, 1, :stroke)
          move(x, y)
          curve(x1, y1, x2, y2, x3, y3)
          strokepath()
          (x, y) = (x3, y3) # update current point
      elseif e.element_type == Cairo.CAIRO_PATH_CLOSE_PATH
          closepath()
      else
          error("unknown CairoPathEntry " * repr(e.element_type))
          error("unknown CairoPathEntry " * repr(e.points))
      end
  end
```
"""
getpath()      = Cairo.convert_cairo_path_data(Cairo.copy_path(get_current_cr()))

"""
    getpathflat()

Get the current path, like `getpath()` but flattened so that there are no Bèzier curves.

Returns a CairoPath which is an array of `element_type` and `points` objects.
"""
getpathflat()  = Cairo.convert_cairo_path_data(Cairo.copy_path_flat(get_current_cr()))

"""
    rulers()

Draw and label two rulers starting at `O`, the current 0/0, and continuing out
along the current positive x and y axes.
"""
function rulers()
    @layer begin
        n = 200
        w = 20
        setopacity(0.5)
        setline(0.25)
        sethue("darkorange")
        #x axis
        box(O, O + (n, -w), :fillstroke)
        #y axis
        box(O - (w, 0), O + (0, n), :fillstroke)
        sethue("darkgoldenrod")
        setopacity(1)
        [line(Point(x, 0), Point(x, -w/4), :stroke) for x in 0:10:n]
        [line(Point(-w/4, y), Point(0, y), :stroke) for y in 0:10:n]
        [line(Point(x, 0), Point(x, -w/6), :stroke) for x in 0:5:n]
        [line(Point(-w/6, y), Point(0, y), :stroke) for y in 0:5:n]
        fontsize(2)
        [text(string(x), Point(x, -w/3), halign=:right) for x in 10:10:n]
        @layer begin
                rotate(pi/2)
                [text(string(x), Point(x, w/3), halign=:right) for x in 10:10:n]
        end
        fontsize(15)
        text("X", O + (n-w/2, w), halign=:right, valign=:middle)
        text("Y", O + (-3w/2, n-w), halign=:right, valign=:middle, angle=pi/2)
        sethue("white")
        text("X", O + (w, -w/2), halign=:right, valign=:middle)
        text("Y", O + (-w/3, w/3), halign=:right, valign=:middle, angle=pi/2)
        #center
        circle(O, 2, :strokepreserve)
        setopacity(0.5)
        fillpath()
    end
end
