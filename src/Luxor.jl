VERSION >= v"0.4.0-dev+6641" && __precompile__()

"""
The Luxor package provides a set of vector drawing functions for creating graphical documents.
"""
module Luxor

using Colors, Cairo, Compat

include("point.jl")
include("Turtle.jl")
include("polygons.jl")
include("Tiler.jl")
include("arrows.jl")

export Drawing, currentdrawing,
    rescale,

    finish, preview,
    origin, axes, background,
    newpath, closepath, newsubpath,
    circle, ellipse, squircle, center3pts,
    rect, box, setantialias, setline, setlinecap, setlinejoin, setdash,
    move, rmove,
    line, rline, curve, arc, carc, ngon, sector, pie,
    do_action, stroke, fill, paint, paint_with_alpha, fillstroke,

    poly, simplify, polybbox, polycentroid, polysortbyangle, polysortbydistance, midpoint,
    prettypoly,

    star,

    intersection, polysplit,

    strokepreserve, fillpreserve,
    gsave, grestore,
    scale, rotate, translate,
    clip, clippreserve, clipreset,

    isinside,

    getpath, getpathflat,

    pattern_create_radial, pattern_create_linear,
    pattern_add_color_stop_rgb, pattern_add_color_stop_rgba,
    pattern_set_filter, pattern_set_extend,

    fontface, fontsize, text, textpath,
    textextents, textcurve, textcentred, textcentered, textright,
    setcolor, setopacity, sethue, randomhue, randomcolor, @setcolor_str,
    getmatrix, setmatrix, transform,

    readpng, placeimage,
    Tiler,
    arrow

# as of version 0.4, we still share fill() and scale() with Base.

import Base: fill, scale

type Drawing
    width::Float64
    height::Float64
    filename::String
    surface::CairoSurface
    cr::CairoContext
    surfacetype::String
    redvalue::Float64
    greenvalue::Float64
    bluevalue::Float64
    alpha::Float64
    function Drawing(w=800, h=800, f="luxor-drawing.png")
        global currentdrawing
        (path, ext)         = splitext(f)
        if ext == ".pdf"
            the_surface     =  Cairo.CairoPDFSurface(f, w, h)
            the_surfacetype = "pdf"
            the_cr          =  Cairo.CairoContext(the_surface)
        elseif ext == ".png" || ext == "" # default to PNG
            the_surface     = Cairo.CairoARGBSurface(w,h)
            the_surfacetype = "png"
            the_cr          = Cairo.CairoContext(the_surface)
        elseif ext == ".eps"
            the_surface     = Cairo.CairoEPSSurface(f, w,h)
            the_surfacetype = "eps"
            the_cr          = Cairo.CairoContext(the_surface)
        elseif ext == ".svg"
            the_surface     = Cairo.CairoSVGSurface(f, w,h)
            the_surfacetype = "svg"
            the_cr          = Cairo.CairoContext(the_surface)
        end
        currentdrawing      = new(w, h, f, the_surface, the_cr, the_surfacetype, 0, 0, 0, 1)
        return "drawing '$f' ($w w x $h h) created in $(pwd())"
    end
end

"""
The `paper_sizes` Dictionary holds a few paper sizes, width is first, so default is Portrait:

```
"A0"      => (2384, 3370),
"A1"      => (1684, 2384),
"A2"      => (1191, 1684),
"A3"      => (842, 1191),
"A4"      => (595, 842),
"A5"      => (420, 595),
"A6"      => (298, 420),
"A"       => (612, 792),
"Letter"  => (612, 792),
"Legal"   => (612, 1008),
"Ledger"  => (792, 1224),
"B"       => (612, 1008),
"C"       => (1584, 1224),
"D"       => (2448, 1584),
"E"       => (3168, 2448))
```
"""
paper_sizes = Dict{String, Tuple}(
  "A0" => (2384, 3370),
  "A1" => (1684, 2384),
  "A2" => (1191, 1684),
  "A3" => (842, 1191),
  "A4" => (595, 842),
  "A5" => (420, 595),
  "A6" => (298, 420),
  "A" => (612, 792),
  "Letter" => (612, 792),
  "Legal" => (612, 1008),
  "Ledger" => (792, 1224),
  "B" => (612, 1008),
  "C" => (1584, 1224),
  "D" => (2448, 1584),
  "E" => (3168, 2448))

"""
Create a new drawing, and optionally specify file type (PNG, PDF, SVG, etc) and dimensions.

    Drawing()

creates a drawing, defaulting to PNG format, default filename "luxor-drawing.png",
default size 800 pixels square.

You can specify dimensions, and use the default target filename:

    Drawing(300,300)

creates a drawing 300 by 300 pixels, defaulting to PNG format, default filename
"/tmp/luxor-drawing.png".

    Drawing(300,300, "my-drawing.pdf")

creates a PDF drawing in the file "my-drawing.pdf", 300 by 300 pixels.

    Drawing(800,800, "my-drawing.svg")`

creates an SVG drawing in the file "my-drawing.svg", 800 by 800 pixels.

    Drawing(800,800, "my-drawing.eps")

creates an EPS drawing in the file "my-drawing.eps", 800 by 800 pixels.

    Drawing("A4", "my-drawing.pdf")

creates a drawing in ISO A4 size in the file "my-drawing.pdf". Other sizes available
are:  "A0", "A1", "A2", "A3", "A4", "A5", "A6", "Letter", "Legal", "A", "B", "C", "D", "E".
Append "landscape" to get the landscape version.

    Drawing("A4landscape")

creates the drawing A4 landscape size.

PDF files default to a white background, but PNG defaults to transparent, unless you specify
one using `background()`.
"""
function Drawing(paper_size::String, f="luxor-drawing.png")
  if contains(paper_size, "landscape")
    psize = replace(paper_size, "landscape", "")
    h, w = paper_sizes[psize]
  else
    w, h = paper_sizes[paper_size]
  end
  Drawing(w, h, f)
end

"""
    finish()

Finish the drawing, and close the file. You may be able to open it in an external viewer
application with `preview()`.
"""
function finish()
    if currentdrawing.surfacetype == "png"
        Cairo.write_to_png(currentdrawing.surface, currentdrawing.filename)
        Cairo.finish(currentdrawing.surface)
        Cairo.destroy(currentdrawing.surface)
    else
        Cairo.finish(currentdrawing.surface)
        Cairo.destroy(currentdrawing.surface)
    end
end

"""
    preview()

On macOS, open the file, which probably uses the default, Preview.app.
On Unix, open the file with `xdg-open`.
On Windows, pass the filename to the shell.
"""
function preview()
    if @compat is_apple()
        run(`open $(currentdrawing.filename)`)
    elseif @compat is_windows()
        run(`$(currentdrawing.filename)`)
    elseif @compat is_unix()
        run(`xdg-open $(currentdrawing.filename)`)
    end
end

"""
    origin()

Reset the current matrix, and then set the 0/0 origin to the center of the drawing (otherwise
it will stay at the top left corner, the default).

You can refer to the 0/0 point as `O`. (O = `Point(0, 0)`),
"""
function origin()
    setmatrix([1.0, 0.0, 0.0, 1.0, 0.0, 0.0])
    Cairo.translate(currentdrawing.cr, currentdrawing.width/2., currentdrawing.height/2.)
end

"""
Convert or rescale a value between `oldmin`/`oldmax` to the equivalent value between
`newmin`/`newmax`.

    rescale(value, oldmin, oldmax, newmin, newmax)

For example, to convert 42 lying on a scale from 0 and 100 to the equivalent number
between 1 and 0 (inverting the direction):

    rescale(42, 0, 100, 1, 0)

returns 0.5800000000000001
"""
rescale(value, oldmin, oldmax, newmin=0, newmax=1) =
   ((value - oldmin) / (oldmax - oldmin)) * (newmax - newmin) + newmin

"""
Draw two axes lines starting at `O`, the current 0/0, and continuing out along the current
positive x and y axes.
"""
function axes()
    # draw axes
    gsave()
    setline(1)
    fontsize(20)
    sethue("gray")
    arrow(O, Point(currentdrawing.width/2. - 30, 0))
    text("x", Point(currentdrawing.width/2. - 30, -15))
    text("x", Point(30, -15))
    arrow(O, Point(0, currentdrawing.height/2. - 30))
    text("y", Point(5, currentdrawing.width/2. - 30))
    text("y", Point(5, 30))
    grestore()
end

"""
    background(color)

Fill the canvas with a single color. Returns the (red, green, blue, alpha) values.

Examples:

    background("antiquewhite")
    background("ivory")
    background(Colors.RGB(0, 0, 0))
    background(Colors.Luv(20, -20, 30))

If you don't specify a background color for a PNG drawing, the background will be
transparent.  You can set a partial of completely transparent background for PNG files by
passing a color with an alpha value, such as this transparent black:

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

# does this do anything in Cairo?
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
Stroke the current path with the current line width, line join, line cap, and dash settings.
The current path is then cleared.

    stroke()

"""
stroke() = Cairo.stroke(currentdrawing.cr)

"""
Fill the current path with current settings. The current path is then cleared.

    fill()

"""
fill() = Cairo.fill(currentdrawing.cr)

"""
Paint the current clip region with the current settings.

    paint()

"""
paint() = Cairo.paint(currentdrawing.cr)

"""
Stroke the current path with current line width, line join, line cap, and dash
settings, but then keep the path current.

    strokepreserve()

"""
strokepreserve()    = Cairo.stroke_preserve(currentdrawing.cr)

"""
Fill the current path with current settings, but then keep the path current.

    fillpreserve()

"""
fillpreserve()      = Cairo.fill_preserve(currentdrawing.cr)

"""
Fill and stroke the current path.
"""
function fillstroke()
    fillpreserve()
    stroke()
end

"""
    do_action(action)

This is usually called by other graphics functions. Actions for graphics commands include
`:fill`, `:stroke`, `:clip`, `:fillstroke`, `:fillpreserve`, `:strokepreserve` and `:path`.
"""
function do_action(action)
    if action == :fill
        fill()
    elseif action == :stroke
        stroke()
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
Establish a new clipping region by intersecting the current clipping region with the
current path and then clearing the current path.

    clip()
"""
clip() = Cairo.clip(currentdrawing.cr)

"""
Establish a new clipping region by intersecting the current clipping region with the current
path, but keep the current path.

    clippreserve()
"""
clippreserve() = Cairo.clip_preserve(currentdrawing.cr)

"""
Reset the clipping region to the current drawing's extent.

    clipreset()
"""
clipreset() = Cairo.reset_clip(currentdrawing.cr)

"""
Make a circle of radius `r` centred at `x`/`y`.

    circle(x, y, r, action=:nothing)

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
Make a circle centred at `pt`.

    circle(pt, r, action)

"""
circle(centerpoint::Point, r, action=:nothing) =
  circle(centerpoint.x, centerpoint.y, r, action)

"""
Make a circle that passes through two points that define the diameter:

    circle(pt1::Point, pt2::Point, action=:nothing)
"""
function circle(pt1::Point, pt2::Point, action=:nothing)
  center = midpoint(pt1, pt2)
  radius = norm(pt1, pt2)/2
  circle(center, radius, action)
end

"""
Find the radius and center point for three points lying on a circle.

    center3pts(a::Point, b::Point, c::Point)

returns (centerpoint, radius) of a circle. Then you can use `circle()` to place a
circle, or `arc()` to draw an arc passing through those points.

If there's no such circle, then you'll see an error message in the console and the function
returns `(Point(0,0), 0)`.
"""
function center3pts(a::Point, b::Point, c::Point)
# Find perpendicular bisectors of the segments connecting the first two and last two
# points. If they bisectors intersect, that's the center of the circle. If they don't,
# the points are colinear so they do not define a circle.

  # Get the perpendicular bisector of (x1, y1) and (x2, y2).
  x1 = (b.x + a.x) / 2
  y1 = (b.y + a.y) / 2
  dy1 = b.x - a.x
  dx1 = -(b.y - a.y)

  # Get the perpendicular bisector of (x2, y2) and (x3, y3).
  x2 = (c.x + b.x) / 2
  y2 = (c.y + b.y) / 2
  dy2 = c.x - b.x
  dx2 = -(c.y - b.y)

  # See where the lines intersect.

  dxy = (dx1 * dy2 - dy1 * dx2)
  if isapprox(dxy, 0)
    info("no circle passes through all three points")
    return Point(0,0), 0
  end

  ox = (y1 * dx1 * dx2 + x2 * dx1 * dy2 - x1 * dy1 * dx2 - y2 * dx1 * dx2) / dxy
  oy = (ox - x1) * dy1 / dx1 + y1
  dx = ox - a.x
  dy = oy - a.y
  radius = sqrt(dx * dx + dy * dy)
  return Point(ox, oy), radius
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

function squircle(center::Point, hradius, vradius, action=:none; rt = 0.5, vertices=false, reversepath=false)
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

TODO: Point versions
"""
function arc(xc, yc, radius, angle1, angle2, action=:nothing)
  Cairo.arc(currentdrawing.cr, xc, yc, radius, angle1, angle2)
  do_action(action)
end

"""
Add an arc to the current path from `angle1` to `angle2` going counterclockwise.

    carc(xc, yc, radius, angle1, angle2, action=:nothing)

Angles are defined relative to the x-axis, positive clockwise.

TODO: Point versions

"""
function carc(xc, yc, radius, angle1, angle2, action=:nothing)
  Cairo.arc_negative(currentdrawing.cr, xc, yc, radius, angle1, angle2)
  do_action(action)
end

"""
Create a rectangle with one corner at (`xmin`/`ymin`) with width `w` and height `h` and do
an action.

    rect(xmin, ymin, w, h, action)

See `box()` for more ways to do similar things, such as supplying two opposite corners,
placing by centerpoint and dimensions.
"""

function rect(xmin, ymin, w, h, action=:nothing)
    if action != :path
        newpath()
    end
    Cairo.rectangle(currentdrawing.cr, xmin, ymin, w, h)
    do_action(action)
end

"""
Create a rectangle with one corner at `cornerpoint` with width `w` and height `h` and do an
action.

    rect(cornerpoint, w, h, action)
"""
function rect(cornerpoint::Point, w, h, action)
    rect(cornerpoint.x, cornerpoint.y, w, h, action)
end

"""
Create a rectangle between two points and do an action.

    box(cornerpoint1, cornerpoint2, action=:nothing)

"""
function box(corner1::Point, corner2::Point, action=:nothing)
    rect(corner1.x, corner1.y, corner2.x - corner1.x, corner2.y - corner1.y, action)
end

"""
Create a box/rectangle using the first two points of an array of Points to defined
opposite corners.

    box(points::Array, action=:nothing)
"""
function box(bbox::Array, action=:nothing)
    box(bbox[1], bbox[2], action)
end

"""
Create a box/rectangle centered at point `pt` with width and height.

    box(pt::Point, width, height, action=:nothing)
"""
function box(pt::Point, width, height, action=:nothing)
    rect(pt.x - width/2, pt.y - height/2, width, height, action)
end

"""
Create a box/rectangle centered at point `x/y` with width and height.

    box(x, y, width, height, action=:nothing)
"""
function box(x, y, width, height, action=:nothing)
    rect(x - width/2, y - height/2, width, height, action)
end

"""
    sector(innerradius, outerradius, startangle, endangle, action=:none)

Make an annular sector centered at the current `0/0` point.
"""
function sector(innerradius, outerradius, startangle, endangle, action=:none)
    newpath()
    move(innerradius * cos(startangle), innerradius * sin(startangle))
    line(outerradius * cos(startangle), outerradius * sin(startangle))
    arc(0, 0, outerradius, startangle, endangle,:none)
    line(innerradius * cos(endangle), innerradius * sin(endangle))
    carc(0, 0, innerradius, endangle, startangle, :none)
    closepath()
    do_action(action)
end

"""
    pie(x, y, radius, startangle, endangle, action=:none)

Make a pie shape centered at `x`/`y`. Angles start at the positive x-axis and are measured
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

Make a pie shape centered at `centerpoint`.

Angles start at the positive x-axis and are measured clockwise.
"""

pie(centerpoint::Point, radius, startangle, endangle, action) =
 pie(centerpoint.x, centerpoint.y, radius, startangle, endangle, action)

"""
Set the line width.

    setline(n)

"""
setline(n) = Cairo.set_line_width(currentdrawing.cr, n)

"""
Set the line ends. `s` can be "butt" (the default), "square", or "round".

    setlinecap(s)

    setlinecap("round")
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
Set the line join, or how to render the junction of two lines when stroking.

    setlinejoin("round")
    setlinejoin("miter")
    setlinejoin("bevel")
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
Set the dash pattern to one of: "solid", "dotted", "dot", "dotdashed", "longdashed",
"shortdashed", "dash", "dashed", "dotdotdashed", "dotdotdotdashed"

    setlinedash("dot")
"""
function setdash(dashing)
    Cairo.set_line_type(currentdrawing.cr, dashing)
end

"""
Move to a point.

    move(x, y)
    move(pt)
"""
move(x, y)      = Cairo.move_to(currentdrawing.cr,x, y)
move(pt)        = move(pt.x, pt.y)

"""
Move by an amount from the current point. Move relative to current position by `x` and `y`:

    rmove(x, y)

Move relative to current position by the `pt`'s x and y:

    rmove(pt)
"""
rmove(x, y)     = Cairo.rel_move(currentdrawing.cr,x, y)
rmove(pt)       = rmove(pt.x, pt.y)

"""
Create a line from the current position to the `x/y` position and optionally apply an action:

    line(x, y)
    line(x, y, :action)
    line(pt)

"""
line(x, y)      = Cairo.line_to(currentdrawing.cr,x, y)
line(pt)        = line(pt.x, pt.y)

"""
Make a line between two points, `pt1` and `pt2`.

    line(pt1::Point, pt2::Point, action=:nothing)

"""
function line(pt1::Point, pt2::Point, action=:nothing)
    move(pt1)
    line(pt2)
    do_action(action)
end

"""
Create a line relative to the current position to the `x/y` position and optionally apply an action:

    rline(x, y)
    rline(x, y, :action)
    rline(pt)
"""
rline(x, y)     = Cairo.rel_line_to(currentdrawing.cr,x, y)
rline(pt)       = rline(pt.x, pt.y)

"""
Create a cubic Bézier spline curve.

    curve(x1, y1, x2, y2, x3, y3)
    curve(p1, p2, p3)

The spline starts at the current position, finishing at `x3/y3` (`p3`), following two
control points `x1/y1` (`p1`) and `x2/y2` (`p2`)

"""

curve(x1, y1, x2, y2, x3, y3) = Cairo.curve_to(currentdrawing.cr, x1, y1, x2, y2, x3, y3)
curve(pt1, pt2, pt3)          = curve(pt1.x, pt1.y, pt2.x, pt2.y, pt3.x, pt3.y)

saved_colors = Tuple{Float64,Float64,Float64,Float64}[]

# I originally used simple Cairo save() but the colors/opacity
# thing I've got going didn't save/restore properly, hence the stack
"""
Save the current graphics state on the stack.
"""
function gsave()
    Cairo.save(currentdrawing.cr)
    push!(saved_colors,
        (currentdrawing.redvalue,
         currentdrawing.greenvalue,
         currentdrawing.bluevalue,
         currentdrawing.alpha))
end
"""
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
Scale subsequent drawing in x and y.

Example:

    scale(0.2, 0.3)

"""

scale(sx, sy) = Cairo.scale(currentdrawing.cr, sx, sy)

"""
Rotate subsequent drawing by `a` radians clockwise.

    rotate(a)

"""

rotate(a) = Cairo.rotate(currentdrawing.cr, a)

"""
Translate to new location.

    translate(x, y)

or

    translate(point)
"""

translate(tx, ty)        = Cairo.translate(currentdrawing.cr, tx, ty)
translate(pt::Point)     = translate(pt.x, pt.y)

"""
Get the current path (thanks Andreas Lobinger!)

Returns a CairoPath which is an array of .element_type and .points. With the results you
could typically step through and examine each entry:

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
          stroke()
          circle(x, y, 1, :stroke)
      elseif e.element_type == Cairo.CAIRO_PATH_CURVE_TO
          (x1, y1, x2, y2, x3, y3) = e.points
          # Bezier control lines
          circle(x1, y1, 1, :stroke)
          circle(x2, y2, 1, :stroke)
          circle(x3, y3, 1, :stroke)
          move(x, y)
          curve(x1, y1, x2, y2, x3, y3)
          stroke()
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
Get the current path, like `getpath()` but flattened so that there are no Bezier curves.

Returns a CairoPath which is an array of .element_type and .points.
"""
getpathflat()  = Cairo.convert_cairo_path_data(Cairo.copy_path_flat(currentdrawing.cr))

# patterns not yet looked at these

#=
Cairo.pattern_create_radial(cx0::Real, cy0::Real, radius0::Real, cx1::Real, cy1::Real, radius1::Real)
Cairo.pattern_create_linear(x0::Real, y0::Real, x1::Real, y1::Real)
Cairo.pattern_add_color_stop_rgb(pat::CairoPattern, offset::Real, red::Real, green::Real, blue::Real)
Cairo.pattern_add_color_stop_rgba(pat::CairoPattern, offset::Real, red::Real, green::Real, blue::Real, alpha::Real)
Cairo.pattern_set_filter(p::CairoPattern, f)
Cairo.pattern_set_extend(p::CairoPattern, val)
Cairo.set_source(dest::CairoContext, src::CairoPattern)
=#

# text
# the 'toy' API... "Any serious application should avoid them." :)
"""

    fontface(fontname)

Select a font to use. If the font is unavailable, it defaults to Helvetica/San Francisco
(on macOS).
"""
fontface(f) = Cairo.select_font_face(currentdrawing.cr, f, Cairo.FONT_SLANT_NORMAL, Cairo.FONT_WEIGHT_NORMAL)

"""

    fontsize(n)

Set the font size to `n` points. Default is 10pt.

"""
fontsize(n) = Cairo.set_font_size(currentdrawing.cr, n)

"""
    textextents(str)

Return the measurements of the string `str` when set using the current font settings:

- x_bearing
- y_bearing
- width
- height
- x_advance
- y_advance

The bearing is the displacement from the reference point to the upper-left corner of the
bounding box. It is often zero or a small positive value for x displacement, but can be
negative x for characters like j; it's almost always a negative value for y displacement.

The width and height then describe the size of the bounding box. The advance takes you to
the suggested reference point for the next letter. Note that bounding boxes for subsequent
blocks of text can overlap if the bearing is negative, or the advance is smaller than the
width would suggest.

Example:

    textextents("R")

returns

    [1.18652; -9.68335; 8.04199; 9.68335; 9.74927; 0.0]
"""

textextents(str) = Cairo.text_extents(currentdrawing.cr, str)

"""
    text(str)
    text(str, x, y)
    text(str, pt)

Draw the text in the string `str` at `x`/`y` or `pt`, placing the start of
the string at the point. If you omit the point, it's placed at `0/0`.

In Luxor, placing text doesn't affect the current point.
"""

function text(t, x=0, y=0)
    gsave()
    Cairo.move_to(currentdrawing.cr, x, y)
    Cairo.show_text(currentdrawing.cr, t)
    grestore()
end

text(t, pt::Point) = text(t, pt.x, pt.y)

"""
    textcentred(str)
    textcentred(str, x, y)
    textcentred(str, pt)

Draw text in the string `str` centered at `x`/`y` or `pt`.
If you omit the point, it's placed at 0/0.

Text doesn't affect the current point!
"""

function textcentred(t, x=0, y=0)
    textwidth = textextents(t)[5]
    text(t, x - textwidth/2., y)
end

textcentred(t, pt::Point) = textcentred(t, pt.x, pt.y)

"""
Do I spell textcentred wrong...?
"""
textcentered = textcentred

"""
    textright(str)
    textright(str, x, y)
    textright(str, pt)

Draw text in the string `str` right-aligned at `x`/`y` or `pt`.
If you omit the point, it's placed at 0/0.

Text doesn't affect the current point!
"""

function textright(t, x=0, y=0)
    textwidth = textextents(t)[5]
    text(t, x - textwidth, y)
end

textright(t, pt::Point) = textright(t, pt.x, pt.y)

"""
    textpath(t)

Convert the text in string `t` to a new path, for subsequent filling/stroking etc...
"""
function textpath(t)
    Cairo.text_path(currentdrawing.cr, t)
end

"""
Place a string of text on a curve. It can spiral in or out.

```
textcurve(the_text,
          start_angle,
          start_radius,
          x_pos = 0,
          y_pos = 0;
          # optional keyword arguments:
          spiral_ring_step = 0,   # step out or in by this amount
          letter_spacing = 0,     # tracking/space between chars, tighter is (-), looser is (+)
          spiral_in_out_shift = 0 # + values go outwards, - values spiral inwards
          )
```

`start_angle` is relative to +ve x-axis, arc/circle is centred on `(x_pos,y_pos)` with
radius `start_radius`.
"""

function textcurve(the_text, start_angle, start_radius, x_pos=0, y_pos=0;
  # keyword optional arguments
  spiral_ring_step = 0,
  letter_spacing = 0, # tracking/space between chars, tighter is (-), looser is (+)
  spiral_in_out_shift = 0 # makes spiral outwards (+) or inwards (-)
  )
  refangle = start_angle
  current_radius = start_radius
  spiral_space_step = 0
  xx = 0
  yy = 0
  angle_step = 0
  radius_step = 0
  counter = 1
  for i in the_text
    glyph = string(i)
    glyph_x_bearing, glyph_y_bearing, glyph_width,
      glyph_height, glyph_x_advance, glyph_y_advance = textextents(glyph)
    spiral_space_step = glyph_x_advance + letter_spacing
    cnter = (2pi * current_radius) / spiral_space_step
    radius_step = (spiral_ring_step + spiral_in_out_shift) / cnter
    current_radius += radius_step
    angle_step += (glyph_x_advance / 2.) + letter_spacing/2.
    refangle += angle_step / current_radius
    angle_step = (glyph_x_advance / 2.) + letter_spacing/2.
    xx = cos(refangle) * current_radius + x_pos
    yy = sin(refangle) * current_radius + y_pos
    gsave()
    translate(xx, yy)
    rotate(pi/2. + refangle)
    textcentred(glyph, 0., 0.)
    grestore()
    current_radius < 10. && break
    counter += 1
  end
end

textcurve(the_text, start_angle, start_radius, centre::Point) =
  textcurve(the_text, start_angle, start_radius, centre.x, centre.y)

"""
    setcolor(col::String)

Set the current color to a named color. This relies on Colors.jl to convert a string to RGBA
eg setcolor("gold") # or "green", "darkturquoise", "lavender" or what have you. The list is at `Colors.color_names`.

    setcolor("gold")
    setcolor("darkturquoise")

Use `sethue()` for changing colors without changing current opacity level.
"""

function setcolor(col::String)
    temp = parse(RGBA, col)
    currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue, currentdrawing.alpha = temp.r, temp.g, temp.b, temp.alpha
    Cairo.set_source_rgba(currentdrawing.cr, currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue, temp.alpha)
    return (temp.r, temp.g, temp.b, temp.alpha)
end

"""
Set the current color.

    setcolor(r, g, b)
    setcolor(r, g, b, alpha)
    setcolor(color)
    setcolor(col::ColorTypes.Colorant)

Examples:

    setcolor(convert(Colors.HSV, Colors.RGB(0.5, 1, 1)))
    setcolor(.2, .3, .4, .5)
    setcolor(convert(Colors.HSV, Colors.RGB(0.5, 1, 1)))

    for i in 1:15:360
       setcolor(convert(Colors.RGB, Colors.HSV(i, 1, 1)))
       ...
    end
"""
function setcolor(col::ColorTypes.Colorant)
  temp = convert(RGBA, col)
  setcolor(temp.r, temp.g, temp.b)
  return (temp.r, temp.g, temp.b)
end

function setcolor(r, g, b, a=1)
    currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue,
      currentdrawing.alpha = r, g, b, a
    Cairo.set_source_rgba(currentdrawing.cr, r, g, b, a)
    return (r, g, b, a)
end

"""
Set the current color to a string.

For example:

    @setcolor"red"
"""
macro setcolor_str(ex)
    isa(ex, String) || error("colorant requires literal strings")
    col = parse(RGBA, ex)
    quote
    currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue,
      currentdrawing.alpha = $col.r, $col.g, $col.b, $col.alpha
    Cairo.set_source_rgba(currentdrawing.cr, currentdrawing.redvalue,
      currentdrawing.greenvalue, currentdrawing.bluevalue, $col.alpha)
    end
end

"""
Set the color. `sethue()` is like `setcolor()`, but (like Mathematica) we sometimes want to
change the current 'color' without changing alpha/opacity. Using `sethue()` rather than
`setcolor()` doesn't change the current alpha opacity.

    sethue("black")
    sethue(0.3,0.7,0.9)

"""
function sethue(col::String)
    temp = parse(RGBA,  col)
    currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue = temp.r, temp.g, temp.b
    Cairo.set_source_rgba(currentdrawing.cr, currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue, currentdrawing.alpha) # use current alpha, not incoming one
    return (temp.r, temp.g, temp.b)
end

"""
Set the color to a named color:

    sethue("red")

"""
function sethue(col::ColorTypes.Colorant)
    temp = convert(RGBA,  col)
    currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue = temp.r, temp.g, temp.b
    # use current alpha
    Cairo.set_source_rgba(currentdrawing.cr, temp.r, temp.g, temp.b, currentdrawing.alpha)
    return (temp.r, temp.g, temp.b, currentdrawing.alpha)
end

"""
Set the color's `r`, `g`, `b` values:

    sethue(0.3, 0.7, 0.9)

Use `setcolor(r,g,b,a)` to set transparent colors.
"""

function sethue(r, g, b)
    currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue = r, g, b
    # use current alpha
    Cairo.set_source_rgba(currentdrawing.cr, r, g, b, currentdrawing.alpha)
    return (r, g, b, currentdrawing.alpha)
end

"""
Set the current opacity to a value between 0 and 1.

    setopacity(alpha)

This modifies the alpha value of the current color.
"""
function setopacity(a)
    # use current RGB values
    currentdrawing.alpha = a
    Cairo.set_source_rgba(currentdrawing.cr, currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue, currentdrawing.alpha)
    return a
end

"""
Set a random hue.

    randomhue()

Choose a random color without changing the current alpha opacity.
"""

function randomhue()
  rrand, grand, brand = rand(3)
  sethue(rrand, grand, brand)
  return (rrand, grand, brand)
end

"""
Set a random color.

    randomcolor()

This probably changes the current alpha opacity too.

"""
function randomcolor()
  rrand, grand, brand, arand = rand(4)
  setcolor(rrand, grand, brand, arand)
  return (rrand, grand, brand, arand)
end

"""
Get the current matrix.

    getmatrix()

Returns the current Cairo matrix as an array. In Cairo/Luxor, a matrix is an array of six float64 numbers:

- xx component of the affine transformation
- yx component of the affine transformation
- xy component of the affine transformation
- yy component of the affine transformation
- x0 translation component of the affine transformation
- y0 translation component of the affine transformation

Some basic matrix transforms:

- translate
  `transform([1,  0, 0,  1, dx, dy])`
  => shift by `dx`, `dy`

- scale
  `transform([fx, 0, 0, fy,  0, 0])`
  => scale by `fx`, `fy`

- rotate
  `transform([cos(a), sin(a), -cos(a), cos(a), 0, 0])`
  => rotate to `a` radians

- x-skew
  `transform([1,  0, tan(a), 1, 0, 0])`
  => xskew by `a`

- y-skew
  `transform([1, tan(a), 0, 1, 0, 0])`
  => yskew by `a`

- flip
  `transform([fx, 0, 0, fy, centerx * (1 - fx), centery * (fy-1)])`
  => flip with center at `centerx`/`centery`

When a drawing is first created, the matrix looks like this:

    getmatrix() = [1.0, 0.0, 0.0, 1.0, 0.0, 0.0]

When the origin is moved to 400/400, it looks like this:

    getmatrix() = [1.0, 0.0, 0.0, 1.0, 400.0, 400.0]

To reset the matrix to the original:

    setmatrix([1.0, 0.0, 0.0, 1.0, 0.0, 0.0])

"""
function getmatrix()
    gm = Cairo.get_matrix(currentdrawing.cr)
    return([gm.xx, gm.yx, gm.xy, gm.yy, gm.x0, gm.y0])
end

"""
Change the current Cairo matrix to matrix `m`.

    setmatrix(m::Array)

Use `getmatrix()` to get the current matrix.
"""
function setmatrix(m::Array)
    if eltype(m) != Float64
        m = map(Float64,m)
    end
    # some matrices make Cairo freak out and need reset. Not sure what the rules are yet…
    if length(m) < 6
        throw("didn't like that matrix $m: not enough values")
    elseif countnz(m) == 0
        throw("didn't like that matrix $m: too many zeroes")
    else
        cm = Cairo.CairoMatrix(m[1], m[2], m[3], m[4], m[5], m[6])
        Cairo.set_matrix(currentdrawing.cr, cm)
    end
end

"""
Modify the current matrix by multiplying it by matrix `a`.

    transform(a::Array)

For example, to skew the current state by 45 degrees in x and move by 20 in y direction:

    transform([1, 0, tand(45), 1, 0, 20])

Use `getmatrix()` to get the current matrix.
"""
function transform(a::Array)
    b = Cairo.get_matrix(currentdrawing.cr)
    setmatrix([
        (a[1] * b.xx)  + a[2]  * b.xy,             # xx
        (a[1] * b.yx)  + a[2]  * b.yy,             # yx
        (a[3] * b.xx)  + a[4]  * b.xy,             # xy
        (a[3] * b.yx)  + a[4]  * b.yy,             # yy
        (a[5] * b.xx)  + (a[6] * b.xy) + b.x0,     # x0
        (a[5] * b.yx)  + (a[6] * b.yy) + b.y0      # y0
    ])
end

"""
Read a PNG file into Cairo.

    readpng(pathname)

This returns a image object suitable for placing on the current drawing with `placeimage()`.
You can access its width and height properties:

    image = readpng("/tmp/test-image.png")
    w = image.width
    h = image.height
"""
function readpng(pathname)
    return Cairo.read_from_png(pathname)
end

function paint_with_alpha(ctx::Cairo.CairoContext, a = 0.5)
    Cairo.paint_with_alpha(currentdrawing.cr, a)
end

"""
Place a PNG image on the drawing.

    placeimage(img, xpos, ypos)

The image `img` has been previously loaded using `readpng()`.
"""
function placeimage(img::Cairo.CairoSurface, xpos, ypos)
    Cairo.set_source_surface(currentdrawing.cr, img, xpos, ypos)
    # no alpha
    Cairo.paint(currentdrawing.cr)
end

"""
Place a PNG image on the drawing.

    placeimage(img, pos, a)

The image `img` has been previously loaded using `readpng()`.
"""
placeimage(img::Cairo.CairoSurface, pt::Point) =
placeimage(img::Cairo.CairoSurface, pt.x, pt.y)

"""
Place a PNG image on the drawing using alpha transparency.

    placeimage(img, xpos, ypos, a)

The image `img` has been previously loaded using `readpng()`.
"""
function placeimage(img::Cairo.CairoSurface, xpos, ypos, alpha)
    Cairo.set_source_surface(currentdrawing.cr, img, xpos, ypos)
    paint_with_alpha(currentdrawing.cr, alpha)
end

"""
Place a PNG image on the drawing using alpha transparency.

    placeimage(img, pos, a)

The image `img` has been previously loaded using `readpng()`.
"""
placeimage(img::Cairo.CairoSurface, pt::Point, alpha) =
  placeimage(img::Cairo.CairoSurface, pt.x, pt.y, alpha)

end
# module
