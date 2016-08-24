VERSION >= v"0.4.0-dev+6641" && __precompile__()

module Luxor

using Colors, Cairo, Compat

include("point.jl")
include("Turtle.jl")
include("polygons.jl")

export Drawing, currentdrawing,
    rescale,

    finish, preview,
    origin, axes, background,
    newpath, closepath, newsubpath,
    circle, ellipse, rect, box, setantialias, setline, setlinecap, setlinejoin, setdash,
    move, rmove,
    line, rline, curve, arc, carc, ngon, ngonv, sector,
    do_action, stroke, fill, paint, paint_with_alpha, fillstroke,

    poly, simplify, polybbox, polycentroid, polysortbyangle, polysortbydistance, midpoint,
    prettypoly,

    star, starv,

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
    textextents, textcurve, textcentred,
    setcolor, setopacity, sethue, randomhue, randomcolor, @setcolor_str,
    getmatrix, setmatrix, transform,

    readpng, placeimage

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
    function Drawing(w=800, h=800, f="/tmp/luxor-drawing.png") #TODO this is Unix only...
        global currentdrawing
        (path, ext)         = splitext(f)
        if ext == ".pdf"
            the_surface     =  Cairo.CairoPDFSurface(f, w, h)
            the_surfacetype = "pdf"
            the_cr          =  Cairo.CairoContext(the_surface)
        elseif ext == ".png" || ext == "" # default to PNG
            the_surface     = Cairo.CairoRGBSurface(w,h)
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
        return "drawing '$f' ($w w x $h h) created"
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
Create a new drawing, optionally specify file type and dimensions.

    Drawing()

creates a drawing, defaulting to PNG format, default filename "/tmp/luxor-drawing.png",
default size 800 pixels square.

    Drawing(300,300)

creates a drawing 300 by 300 pixels, defaulting to PNG format, default filename
"/tmp/luxor-drawing.png".

    Drawing(300,300, "/tmp/my-drawing.pdf")

creates a PDF drawing in the file "/tmp/my-drawing.pdf", 300 by 300 pixels.

    Drawing(800,800, "/tmp/my-drawing.svg")`

creates an SVG drawing in the file "/tmp/my-drawing.svg", 800 by 800 pixels.

    Drawing(800,800, "/tmp/my-drawing.eps")

creates an EPS drawing in the file "/tmp/my-drawing.eps", 800 by 800 pixels.

    Drawing("A4", "/tmp/my-drawing.pdf")

creates a drawing in ISO A4 size in the file "/tmp/my-drawing.pdf". Other sizes available
are:  "A0", "A1", "A2", "A3", "A4", "A5", "A6", "Letter", "Legal", "A", "B", "C", "D", "E".
Append "landscape" to get the landscape version.

    Drawing("A4landscape")

Create the drawing A4 landscape size.

Note that PDF files seem to default to a white background, but PNG defaults to black.
Might be a bug here somewhere...
"""
function Drawing(paper_size::String, f="/tmp/luxor-drawing.png")
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

Finish the drawing, and close the file. The filename is still available in
`currentdrawing.filename`, and you may be able to open it using `preview()`.
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
On Unix, open the file with xdg-open.
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

Set the 0/0 origin at the center of the drawing (otherwise it will stay at the top left
corner).
"""
function origin()
    # set the origin at the center
    Cairo.translate(currentdrawing.cr, currentdrawing.width/2., currentdrawing.height/2.)
end

"""
Convert or rescale a value between `oldmin`/`oldmax` to the equivalent value between
`newmin`/`newmax`.

For example, to convert 42 that used to lie between 0 and 100 to the equivalent number
between 1 and 0, inverting the direction:

    rescale(42, 0, 100, 1, 0)

returns 0.5800000000000001
"""
rescale(value, oldmin, oldmax, newmin, newmax) =
   ((value - oldmin) / (oldmax - oldmin)) * (newmax - newmin) + newmin

"""
Draw two axes lines starting at 0/0 and continuing out along the current positive x and y axes.
"""
function axes()
    # draw axes
    gsave()
    setline(1)
    fontsize(20)
    sethue("gray")
    move(0,0)
    line(currentdrawing.width/2. - 20, 0)
    stroke()
    text("x", currentdrawing.width/2. - 20, 0)
    move(0, 0)
    line(0, currentdrawing.height/2. - 20)
    stroke()
    text("y", 0, currentdrawing.height/2. - 20)
    grestore()
end

"""
    background(color)

Fill the canvas with color. (if Colors.jl is installed).

Examples:

    background("antiquewhite")
    background("ivory")
    background(Colors.RGB(0, 0, 0))
    background(Colors.Luv(20, -20, 30))
"""
function background(col::String)
   setcolor(col)
   paint()
end

function background(col::ColorTypes.Colorant)
    temp = convert(RGBA,  col)
    setcolor(temp.r, temp.g, temp.b)
    paint()
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

Create a new subpath of the current path. This is Cairo's `new_sub_path()` function. It can
be used, for example, to make holes in shapes.
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
stroke()            = Cairo.stroke(currentdrawing.cr)

"""
Fill the current path with current settings. The current path is then cleared.

    fill()

"""
fill()              = Cairo.fill(currentdrawing.cr)

"""
Paint the current clip region with the current settings.

    paint()

"""
paint()             = Cairo.paint(currentdrawing.cr)

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

This is usually called by other graphics functions, actions for graphics commands include
:fill, :stroke, :clip, :fillstroke, :fillpreserve, :strokepreserve and :path.

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
Establish a new clip region by intersecting the current clip region with the current path
and then clearing the current path.

    clip()
"""
clip() = Cairo.clip(currentdrawing.cr)

"""
Establishes a new clip region by intersecting the current clip region with the current path,
but keep the current path.

    clippreserve()
"""
clippreserve() = Cairo.clip_preserve(currentdrawing.cr)

"""
Reset the clip region to the current drawing's extent.

    clipreset()
"""
clipreset() = Cairo.reset_clip(currentdrawing.cr)

"""
Draw a circle centred at `x`/`y`.

    circle(x, y, r, action)

`action` is one of the actions applied by `do_action`.
"""
function circle(x, y, r, action=:nothing)
    if action != :path
      newpath()
    end
    Cairo.circle(currentdrawing.cr, x, y, r)
    do_action(action)
end

"""
Draw a circle centred at `pt`.

    circle(pt, r, action)

"""
circle(centerpoint::Point, r, action=:nothing) =
  circle(centerpoint.x, centerpoint.y, r, action)

"""
Draw an ellipse, centered at xc/yc, with width w, and height h.

    ellipse(xc, yc, w, h, action=:none)
"""
function ellipse(xc, yc, w, h, action=:none)
    x  = xc - w/2
    y  = yc - h/2
    kappa = .5522848 # http://www.whizkidtech.redprince.net/bezier/circle/kappa/
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
Draw an ellipse, centered at c, with width w, and height h.

    ellipse(c, w, h, action=:none)
"""

ellipse(c::Point, w, h, action=:none) = ellipse(c.x, c.y, w, h, action)

"""
Add an arc to the current path from `angle1` to `angle2` going clockwise.

    arc(xc, yc, radius, angle1, angle2, action=:nothing)

Angles are defined relative to the x-axis, positive clockwise.
"""
function arc(xc, yc, radius, angle1, angle2, action=:nothing)
  Cairo.arc(currentdrawing.cr, xc, yc, radius, angle1, angle2)
  do_action(action)
end

"""
Add an arc to the current path from `angle1` to `angle2` going counterclockwise.

    carc(xc, yc, radius, angle1, angle2, action=:nothing)

Angles are defined relative to the x-axis, positive clockwise.
"""
function carc(xc, yc, radius, angle1, angle2, action=:nothing)
  Cairo.arc_negative(currentdrawing.cr, xc, yc, radius, angle1, angle2)
  do_action(action)
end

"""
Create a rectangle with one corner at (`xmin`/`ymin`) with width `w` and height `h` and do
an action.

    rect(xmin, ymin, w, h, action)
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
Create a rectangle between the first two points of an array of Points.

    box(points::Array, action=:nothing)
"""
function box(bbox::Array, action=:nothing)
    box(bbox[1], bbox[2], action)
end

"""
    sector(innerradius, outerradius, startangle, endangle, action=:none)

Draw a track/sector based at 0/0.
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
Set the line width.

    setline(n)

"""
setline(n)      = Cairo.set_line_width(currentdrawing.cr, n)

"""
Set the line ends. `s` can be "butt" (default), "square", or "round".

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
Set the line join, i.e. how to render the junction of two lines when stroking.

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
# thing didn't save/restore properly, hence the stack
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

Returns a CairoPath which is an array of .element_type and .points.
"""
getpath()      = Cairo.convert_cairo_path_data(Cairo.copy_path(currentdrawing.cr))

"""
Get the current path but flattened.

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

# text, the 'toy' API... "Any serious application should avoid them." :)
"""

    fontface(fontname)

Select a font to use. If the font is unavailable, it defaults to Helvetica/San Francisco (on macOS).

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

-    x_bearing
-    y_bearing
-    width
-    height
-    x_advance
-    y_advance

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
    text(str, x, y)
    text(str, pt)

Draw the text in the string `str` at `x`/`y` or `pt`, placing the start of
the string at the point. If you omit the point, it's placed at 0/0.

In Luxor, placing text doesn't affect the current point!
"""

function text(t, x=0, y=0)
    gsave()
    Cairo.move_to(currentdrawing.cr, x, y)
    Cairo.show_text(currentdrawing.cr, t)
    grestore()
end

text(t, pt::Point) = text(t, pt.x, pt.y)

"""
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
          x_pos,
          y_pos;
          # optional keyword arguments:
          spiral_ring_step = 0,   # step out or in by this amount
          letter_spacing = 0,     # tracking/space between chars, tighter is (-), looser is (+)
          spiral_in_out_shift = 0 # + values go outwards, - values spiral inwards
          )
```

`start_angle` is relative to +ve x-axis, arc/circle is centred on `(x_pos,y_pos)` with radius `start_radius`.
"""

function textcurve(the_text, start_angle, start_radius, x_pos, y_pos;
  # keyword optional arguments
  spiral_ring_step = 0,
  letter_spacing = 0, # tracking/space between chars, tighter is (-), looser is (+)
  spiral_in_out_shift = 0 # makes spiral outwards (+) or inwards (-)
  )

  angle = start_angle
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
    angle += angle_step / current_radius
    angle_step = (glyph_x_advance / 2.) + letter_spacing/2.
    xx = cos(angle) * current_radius + x_pos
    yy = sin(angle) * current_radius + y_pos
    gsave()
    translate(xx, yy)
    rotate(pi/2. + angle)
    textcentred(glyph, 0., 0.)
    grestore()
    current_radius < 10. && break
    counter += 1
  end
end

textcurve(the_text, start_angle, start_radius, centre::Point) = textcurve(the_text, start_angle, start_radius, centre.x, centre.y)

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
    setcolor(convert(Color.HSV, Color.RGB(0.5, 1, 1)))

    for i in 1:15:360
       setcolor(convert(Color.RGB, Color.HSV(i, 1, 1)))
       ...
    end
"""
function setcolor(col::ColorTypes.Colorant)
  temp = convert(RGBA, col)
  setcolor(temp.r, temp.g, temp.b)
end

function setcolor(r, g, b, a=1)
    currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue,
      currentdrawing.alpha = r, g, b, a
    Cairo.set_source_rgba(currentdrawing.cr, r, g, b, a)
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
end

"""
    sethue("red")

"""
function sethue(col::ColorTypes.Colorant)
    temp = convert(RGBA,  col)
    currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue = temp.r, temp.g, temp.b
    # use current alpha
    Cairo.set_source_rgba(currentdrawing.cr, temp.r, temp.g, temp.b, currentdrawing.alpha)
end

"""
    sethue(0.3, 0.7, 0.9)

Use `setcolor(r,g,b,a)` to set transparent colors.
"""
function sethue(r, g, b)
    currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue = r, g, b
    # use current alpha
    Cairo.set_source_rgba(currentdrawing.cr, r, g, b, currentdrawing.alpha)
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
end

"""
Set a random hue.

    randomhue()

Choose a random color without changing the current alpha opacity.
"""
function randomhue()
    sethue(rand(), rand(), rand())
end
"""
Set a random color.

    randomcolor()

This probably changes the current alpha opacity too.

"""
function randomcolor()
    setcolor(rand(), rand(), rand(), rand())
end

"""
Get the current matrix.

    getmatrix()

Return current Cairo matrix as an array. In Cairo and Luxor, a matrix is an array of 6 float64 numbers:

- xx component of the affine transformation
- yx component of the affine transformation
- xy component of the affine transformation
- yy component of the affine transformation
- x0 translation component of the affine transformation
- y0 translation component of the affine transformation

Some basic matrix transforms:

translate(dx,dy) =	  transform([1,  0, 0,  1, dx, dy])                 shift by
scale(fx, fy)    =    transform([fx, 0, 0, fy,  0, 0])                  scale by
rotate(A)        =    transform([c, s, -c, c,   0, 0])                  rotate to A radians
x-skew(a)        =    transform([1,  0, tan(a), 1,   0, 0])             xskew by A
y-skew(a)        =    transform([1, tan(a), 0, 1, 0, 0])                yskew by A
flip HV          =    transform([fx, 0, 0, fy, cx(*1-fx), cy* (fy-1)])  flip

WHen a drawing is first created, the matrix looks like this:

    getmatrix() = [1.0,0.0,0.0,1.0,0.0,0.0]

When the origin is moved to 400/400, it looks like this:

    getmatrix() = [1.0,0.0,0.0,1.0,400.0,400.0]

To reset the matrix to the original:

    setmatrix([1.0,0.0,0.0,1.0,0.0,0.0])

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

This returns a Cairo.CairoSurface, suitable for placing on the current drawing with
`placeimage()`. You can access its width and height properties.

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

Place an image previously loaded using `readpng()`.
"""
function placeimage(img::Cairo.CairoSurface, xpos, ypos)
    Cairo.set_source_surface(currentdrawing.cr, img, xpos, ypos)
    # no alpha
    Cairo.paint(currentdrawing.cr)
end

"""
Place a PNG image on the drawing using alpha transparency.

    placeimage(img, xpos, ypos, a)

Place an image previously loaded using `readpng()`.
"""
function placeimage(img::Cairo.CairoSurface, xpos, ypos, alpha)
    Cairo.set_source_surface(currentdrawing.cr, img, xpos, ypos)
    paint_with_alpha(currentdrawing.cr, alpha)
end

placeimage(img::Cairo.CairoSurface, pt::Point) =
  placeimage(img::Cairo.CairoSurface, pt.x, pt.y)
placeimage(img::Cairo.CairoSurface, pt::Point, alpha) =
  placeimage(img::Cairo.CairoSurface, pt.x, pt.y, alpha)

end
# module
