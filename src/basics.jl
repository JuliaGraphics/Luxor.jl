"""
    origin()

Reset the current matrix, and then set the 0/0 origin to the center of the drawing
(otherwise it will stay at the top left corner, the default).

You can refer to the 0/0 point as `O`. (O = `Point(0, 0)`),
"""
function origin()
    setmatrix([1.0, 0.0, 0.0, 1.0, 0.0, 0.0])
    Cairo.translate(currentdrawing.cr, currentdrawing.width/2.0, currentdrawing.height/2.0)
end

"""
    origin(x, y)

Reset the current matrix, then move the `0/0` position relative to the top left corner of
the drawing.
"""
function origin(x, y)
    setmatrix([1.0, 0.0, 0.0, 1.0, 0.0, 0.0])
    Cairo.translate(currentdrawing.cr, x, y)
end

"""
    origin(pt:Point)

Reset the current matrix, then move the `0/0` position to `pt`.
"""
function origin(pt)
    setmatrix([1.0, 0.0, 0.0, 1.0, 0.0, 0.0])
    Cairo.translate(currentdrawing.cr, pt.x, pt.y)
end

"""
    rescale(x, from_min, from_max, to_min, to_max)

Convert `x` from one linear scale (`from_min` to `from_max`) to another (`to_min` to `to_max`).

The scales can also be supplied in tuple form:

    rescale(x, (from_min, from_max), (to_min, to_max))

```jldoctest
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
Draw and label two axes lines starting at `O`, the current 0/0, and continuing out along the
current positive x and y axes.
"""
function axes()
    # draw axes
    gsave()
    setline(1)
    fontsize(20)
    sethue("gray")
    arrow(O, Point(currentdrawing.width/2.0 * 0.6, 0.0))
    text("x", Point(currentdrawing.width/2.0 * 0.6, -15.0))
    text("x", Point(30, -15))
    arrow(O, Point(0, currentdrawing.height/2.0 * 0.6))
    text("y", Point(5, currentdrawing.width/2.0 * 0.6))
    text("y", Point(5, 30))
    grestore()
end

"""
    background(color)

Fill the canvas with a single color. Returns the (red, green, blue, alpha) values.

Examples:

    background("antiquewhite")
    background("ivory")

If Colors.jl is installed:

    background(RGB(0, 0, 0))
    background(Luv(20, -20, 30))

If you don't specify a background color for a PNG drawing, the background will be
transparent. You can set a partly or completely transparent background for PNG files by
passing a color with an alpha value, such as this 'transparent black':

    background(RGBA(0, 0, 0, 0))

"""
function background(col::String)
   setcolor(col)
   paint()
   return (currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue, currentdrawing.alpha)
end

function background(col::ColorTypes.Colorant)
    temp = convert(RGBA,  col)
    setcolor(temp.r, temp.g, temp.b, temp.alpha)
    paint()
    return (currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue, currentdrawing.alpha)
end

function background(r, g, b)
    sethue(r, g, b)
    paint()
    return (currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue, currentdrawing.alpha)
end

function background(r, g, b, a)
    setcolor(r, g, b, a)
    paint()
    return (currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue, currentdrawing.alpha)
end

# I don't think this has a visible effect

"""
    setantialias(n)

Set the current antialiasing to a value between 0 and 6:

    antialias_default  = 0
    antialias_none     = 1
    antialias_gray     = 2
    antialias_subpixel = 3
    antialias_fast     = 4
    antialias_good     = 5
    antialias_best     = 6

I can't see any difference between these values. Perhaps on your machine you can!
"""
setantialias(n) = Cairo.set_antialias(currentdrawing.cr, n)

"""
    newpath()

Create a new path. This is Cairo's `new_path()` function.
"""
newpath() = Cairo.new_path(currentdrawing.cr)

"""
    newsubpath()

Add a new subpath to the current path. This is Cairo's `new_sub_path()` function. It can
be used for example to make holes in shapes.
"""
newsubpath() = Cairo.new_sub_path(currentdrawing.cr)

"""
    closepath()

Close the current path. This is Cairo's `close_path()` function.
"""
closepath() = Cairo.close_path(currentdrawing.cr)

"""
    strokepath()

Stroke the current path with the current line width, line join, line cap, and dash settings.
The current path is then cleared.
"""
strokepath() = Cairo.stroke(currentdrawing.cr)

"""
    fillpath()

Fill the current path according to the current settings. The current path is then cleared.
"""
fillpath() = Cairo.fill(currentdrawing.cr)

"""
    paint()

Paint the current clip region with the current settings.
"""
paint() = Cairo.paint(currentdrawing.cr)

"""
    strokepreserve()

Stroke the current path with current line width, line join, line cap, and dash
settings, but then keep the path current.
"""
strokepreserve()    = Cairo.stroke_preserve(currentdrawing.cr)

"""
    fillpreserve()

Fill the current path with current settings, but then keep the path current.
"""
fillpreserve()      = Cairo.fill_preserve(currentdrawing.cr)

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
clip() = Cairo.clip(currentdrawing.cr)

"""
    clippreserve()

Establish a new clipping region by intersecting the current clipping region with the current
path, but keep the current path.
"""
clippreserve() = Cairo.clip_preserve(currentdrawing.cr)

"""
    clipreset()

Reset the clipping region to the current drawing's extent.
"""
clipreset() = Cairo.reset_clip(currentdrawing.cr)

"""
    setline(n)

Set the line width.
"""
setline(n) = Cairo.set_line_width(currentdrawing.cr, n)

"""
    setlinecap(s)

Set the line ends. `s` can be "butt" (the default), "square", or "round".
"""
function setlinecap(str="butt")
    if str == "round"
        Cairo.set_line_cap(currentdrawing.cr, Cairo.CAIRO_LINE_CAP_ROUND)
    elseif str == "square"
        Cairo.set_line_cap(currentdrawing.cr, Cairo.CAIRO_LINE_CAP_SQUARE)
    else
        Cairo.set_line_cap(currentdrawing.cr, Cairo.CAIRO_LINE_CAP_BUTT)
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
        Cairo.set_line_join(currentdrawing.cr, Cairo.CAIRO_LINE_JOIN_ROUND)
    elseif str == "bevel"
        Cairo.set_line_join(currentdrawing.cr, Cairo.CAIRO_LINE_JOIN_BEVEL)
    else
        Cairo.set_line_join(currentdrawing.cr, Cairo.CAIRO_LINE_JOIN_MITER)
    end
end

"""
    setlinedash("dot")

Set the dash pattern to one of: "solid", "dotted", "dot", "dotdashed", "longdashed",
"shortdashed", "dash", "dashed", "dotdotdashed", "dotdotdotdashed"
"""
function setdash(dashing)
    Cairo.set_line_type(currentdrawing.cr, dashing)
end

"""
    move(x, y)
    move(pt)

Move to a point.
"""
move(x, y)      = Cairo.move_to(currentdrawing.cr,x, y)
move(pt)        = move(pt.x, pt.y)

"""
    rmove(x, y)

Move by an amount from the current point. Move relative to current position by `x` and `y`:

Move relative to current position by the `pt`'s x and y:

    rmove(pt)
"""
rmove(x, y)     = Cairo.rel_move_to(currentdrawing.cr,x, y)
rmove(pt)       = rmove(pt.x, pt.y)

"""
    line(x, y)
    line(x, y)
    line(pt)

Create a line from the current position to the `x/y` position.
"""
line(x, y)      = Cairo.line_to(currentdrawing.cr,x, y)
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
    rline(x, y)
    rline(x, y)
    rline(pt)

Create a line relative to the current position to the `x/y` position.
"""
rline(x, y)     = Cairo.rel_line_to(currentdrawing.cr, x, y)
rline(pt)       = rline(pt.x, pt.y)

"""
    rule(pos::Point, theta=0.0)

Draw a line across the entire drawing passing through `pos`, at an angle of `theta` to the
x-axis. Returns the two points.

The end points are not calculated exactly, they're just a long way apart.
"""
function rule(pos::Point, theta=0.0)
    diagonal = hypot(currentdrawing.width, currentdrawing.height)
    postarget  = Point(pos.x + (diagonal * cos(theta)), pos.y + (diagonal * sin(theta)))
    pt1 = between(pos, postarget, -2)
    pt2 = between(pos, postarget, 3)
    line(pt1, pt2, :stroke)
    return (pt1, pt2)
end

saved_colors = Tuple{Float64,Float64,Float64,Float64}[]

# I originally used simple Cairo save() but the colors/opacity
# thing I've got going didn't save/restore properly, hence the stack
"""
    gsave()

Save the current color settings on the stack.
"""
function gsave()
    Cairo.save(currentdrawing.cr)
    push!(saved_colors,
        (currentdrawing.redvalue,
         currentdrawing.greenvalue,
         currentdrawing.bluevalue,
         currentdrawing.alpha))
    return (currentdrawing.redvalue,
         currentdrawing.greenvalue,
         currentdrawing.bluevalue,
         currentdrawing.alpha)
end

"""
    grestore()

Replace the current graphics state with the one on top of the stack.
"""
function grestore()
    Cairo.restore(currentdrawing.cr)
    try
    (currentdrawing.redvalue,
     currentdrawing.greenvalue,
     currentdrawing.bluevalue,
     currentdrawing.alpha) = pop!(saved_colors)
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
scale(sx::Real, sy::Real) = Cairo.scale(currentdrawing.cr, sx, sy)

"""
    scale(f)

Scale workspace by `f` in both `x` and `y`.
"""
scale(f::Real) = Cairo.scale(currentdrawing.cr, f, f)

"""
    rotate(a::Float64)

Rotate workspace by `a` radians clockwise (from positive x-axis to positive y-axis).
"""
rotate(a) = Cairo.rotate(currentdrawing.cr, a)

"""
    translate(x::Real, y::Real)
    translate(point)

Translate the workspace by `x` and `y` or by moving the origin to `pt`.
"""
translate(tx::Real, ty::Real)        = Cairo.translate(currentdrawing.cr, tx, ty)
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
getpath()      = Cairo.convert_cairo_path_data(Cairo.copy_path(currentdrawing.cr))

"""
    getpathflat()

Get the current path, like `getpath()` but flattened so that there are no Bèzier curves.

Returns a CairoPath which is an array of `element_type` and `points` objects.
"""
getpathflat()  = Cairo.convert_cairo_path_data(Cairo.copy_path_flat(currentdrawing.cr))
