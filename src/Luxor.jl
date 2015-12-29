VERSION >= v"0.4.0-dev+6641" && __precompile__()

module Luxor

using Colors, Cairo

include("point.jl")
include("Turtle.jl")

# as of version 0.4, it seems I've got to share fill() and scale() with Base.

import Base: fill, scale

type Drawing
    width::Float64
    height::Float64
    filename::AbstractString
    surface::CairoSurface
    cr::CairoContext
    surfacetype::AbstractString
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
        const currentdrawing      = new(w, h, f, the_surface, the_cr, the_surfacetype, 0, 0, 0, 1)
        return "drawing '$f' ($w w x $h h) created"
    end
end

export Drawing, currentdrawing,
    finish, preview,
    origin, axes, background,
    newpath, closepath, newsubpath,
    circle, rect, setantialias, setline, setlinecap, setlinejoin, setdash,
    move, rmove,
    line, rline, curve, arc, carc, ngon, sector,
    do_action, stroke, fill, paint, fillstroke, poly, simplify,
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
    getmatrix, setmatrix, transform

"""
    finish()

    Stop drawing, and close the file.

"""

function finish()
    if currentdrawing.surfacetype == "png"
        Cairo.write_to_png(currentdrawing.surface, currentdrawing.filename)
        Cairo.finish(currentdrawing.surface)
    else
        Cairo.finish(currentdrawing.surface)
    end
end

"""
    preview()

    On OS X, opens the file, probably using the default app, Preview.app
    On Windows, ?
    On Unix, ?

"""

# TODO what will these do on non-OSX?

function preview()
    @osx_only      run(`open $(currentdrawing.filename)`)
    @windows_only  run(`open $(currentdrawing.filename)`)
    @linux_only    run(`xdg-open $(currentdrawing.filename)`)
end

"""
    origin()

    Set the 0/0 origin at the center of the drawing (otherwise it will stay
    at the top left corner).

"""

function origin()
    # set the origin at the center
    Cairo.translate(currentdrawing.cr, currentdrawing.width/2, currentdrawing.height/2)
end

"""
    Draw two axes lines centered at 0/0.
"""

function axes()
    # draw axes
    gsave()
    setline(1)
    fontsize(20)
    sethue("gray")
    move(0,0)
    line(currentdrawing.width/2 - 20,0)
    stroke()
    text("x", currentdrawing.width/2 - 20, 0)
    move(0,0)
    line(0, currentdrawing.height/2 - 20)
    stroke()
    text("y", 0, currentdrawing.height/2 - 20)
    grestore()
end

"""
    background(color)

    Draw a colored rectangle centered at 0/0 and filling the canvas. Probably
    works best after `axes()`.

"""
function background(col::AbstractString)
# TODO: at present this only works properly after you call origin() to put 0/0 in the center
# but how can it tell whether you've used origin() first?
   setcolor(col)
   rect(-currentdrawing.width/2, -currentdrawing.height/2, currentdrawing.width, currentdrawing.height, :fill)
end

function background(col::ColorTypes.Colorant)
    temp = convert(RGBA,  col)
    setcolor(temp.r, temp.g, temp.b)
    rect(-currentdrawing.width/2, -currentdrawing.height/2, currentdrawing.width, currentdrawing.height, :fill)
end

# does this do anything in Cairo?
setantialias(n) = Cairo.set_antialias(currentdrawing.cr, n)

# paths

newpath() = Cairo.new_path(currentdrawing.cr)
newsubpath() = Cairo.new_sub_path(currentdrawing.cr)
closepath() = Cairo.close_path(currentdrawing.cr)

# shapes and lines

stroke()            = Cairo.stroke(currentdrawing.cr)
fill()              = Cairo.fill(currentdrawing.cr)
paint()             = Cairo.paint(currentdrawing.cr)
strokepreserve()    = Cairo.stroke_preserve(currentdrawing.cr)
fillpreserve()      = Cairo.fill_preserve(currentdrawing.cr)

function fillstroke()
    fillpreserve()
    stroke()
end

"""
actions for graphics commands include :fill, :stroke, :clip, :fillstroke, :fillpreserve, :strokepreserve
and :path.

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

# clipping

clip() = Cairo.clip(currentdrawing.cr)
clippreserve() = Cairo.clip_preserve(currentdrawing.cr)
clipreset() = Cairo.reset_clip(currentdrawing.cr)

# circles and arcs

"""
    circle(x, y, r, action)

    Draw a circle.

"""
function circle(x, y, r, action=:nothing) # action is a symbol or nothing
    if action != :path
        newpath()
    end
    Cairo.circle(currentdrawing.cr, x, y, r)
    do_action(action)
end

"""
    arc(xc, yc, radius, angle1, angle2, action=:nothing)

    Add an arc to the current path from `angle1` to `angle2` going clockwise.
    Angles are defined relative to the x-axis, positive clockwise.

"""

function arc(xc, yc, radius, angle1, angle2, action=:nothing)
    Cairo.arc(currentdrawing.cr, xc, yc, radius, angle1, angle2)
    do_action(action)
end

"""
    carc(xc, yc, radius, angle1, angle2, action=:nothing)

    Add an arc to the current path from `angle1` to `angle2` going counterclockwise.
    Angles are defined relative to the x-axis, positive clockwise.

"""

function carc(xc, yc, radius, angle1, angle2, action=:nothing)
    Cairo.arc_negative(currentdrawing.cr, xc, yc, radius, angle1, angle2)
    do_action(action)
end

"""
    rect(xmin, ymin, w, h, action)

    Draw a rectangle.
"""

function rect(xmin, ymin, w, h, action=:nothing)
    if action != :path
        newpath()
    end
    Cairo.rectangle(currentdrawing.cr, xmin, ymin, w, h)
    do_action(action)
end

"""
    sector(innerradius, outerradius, startangle, endangle, action=:none)

    Draw a track/sector.

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

setline(n)      = Cairo.set_line_width(currentdrawing.cr, n)

"""
    setlinecap(s)

    Set the line ends. `s` can be "butt", "square", or "round".

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

function setlinejoin(str="miter")
    if str == "round"
        Cairo.set_line_join(currentdrawing.cr, Cairo.CAIRO_LINE_JOIN_ROUND)
    elseif str == "bevel"
        Cairo.set_line_join(currentdrawing.cr, Cairo.CAIRO_LINE_JOIN_BEVEL)
    else
        Cairo.set_line_join(currentdrawing.cr, Cairo.CAIRO_LINE_JOIN_MITER)
    end
end

function setdash(dashing)
    # solid, dotted, dot, dotdashed, longdashed, shortdashed, dash, dashed, dotdotdashed, dotdotdotdashed
    Cairo.set_line_type(currentdrawing.cr, dashing)
end

move(x, y)      = Cairo.move_to(currentdrawing.cr,x, y)
rmove(x, y)     = Cairo.rel_move(currentdrawing.cr,x, y)
line(x, y)      = Cairo.line_to(currentdrawing.cr,x, y)
rline(x, y)     = Cairo.rel_line_to(currentdrawing.cr,x, y)
curve(x1, y1, x2, y2, x3, y3) = Cairo.curve_to(currentdrawing.cr, x1, y1, x2, y2, x3, y3)

saved_colors = Tuple[]

# I originally used simple Cairo save() but somehow the colors/opacity
# thing didn't save/restore properly, hence the stack

function gsave()
    Cairo.save(currentdrawing.cr)
    push!(saved_colors,
        (currentdrawing.redvalue,
         currentdrawing.greenvalue,
         currentdrawing.bluevalue,
         currentdrawing.alpha))
end

function grestore()
    Cairo.restore(currentdrawing.cr)
    try
    (currentdrawing.redvalue,
     currentdrawing.greenvalue,
     currentdrawing.bluevalue,
     currentdrawing.alpha) = pop!(saved_colors)
     catch err
         println("$err Not enough colors on the stack")
    end
end

scale(sx, sy) = Cairo.scale(currentdrawing.cr, sx, sy)
rotate(a) = Cairo.rotate(currentdrawing.cr, a)
translate(tx, ty) = Cairo.translate(currentdrawing.cr, tx, ty)

# polygon is an Array of Points

function poly(list::Array, action = :nothing; close=false, reversepath=false)
    # where list is array of Points
    # by default doesn't close or fill, to allow for clipping.etc
    if action != :path
        newpath()
    end
    if reversepath
        reverse!(list)
    end
    move(list[1].x, list[1].y)
    for p in list[2:end]
        line(p.x, p.y)
    end
    if close
        closepath()
    end
    do_action(action)
end

function point_line_distance(p, a, b)
    # area of triangle
    area = abs(0.5 * (a.x * b.y + b.x * p.y + p.x * a.y - b.x * a.y - p.x * b.y - a.x * p.y))
    # length of the bottom edge
    dx = a.x - b.x
    dy = a.y - b.y
    bottom = sqrt(dx * dx + dy * dy)
    return area / bottom
end

# use non-recursive Douglas-Peucker algorithm to simplify polygon
function douglas_peucker(points::Array, start_index, last_index, epsilon)
    temp_stack = Tuple{Int,Int}[] # version 0.4 only?
    push!(temp_stack, (start_index, last_index))
    global_start_index = start_index
    keep_list = trues(length(points))
    while length(temp_stack) > 0
        start_index = first(temp_stack[end])
        last_index =  last(temp_stack[end])
        pop!(temp_stack)
        dmax = 0.0
        index = start_index
        for i in index + 1:last_index - 1
            if (keep_list[i - global_start_index])
                d = point_line_distance(points[i], points[start_index], points[last_index])
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
    return points[keep_list]
end

function simplify(polygon::Array, detail)
    douglas_peucker(polygon, 1, length(polygon), detail)
end

# regular polygons

# draw a poly
function ngon(x, y, radius, sides::Int64, orientation=0, action=:nothing; close=true, reversepath=false)
    poly([Point(x+cos(orientation + n * (2 * pi)/sides) * radius,
           y+sin(orientation + n * (2 * pi)/sides) * radius) for n in 1:sides], close=close, action, reversepath=reversepath)
end

# if no action supplied, return a poly as a set of points
function ngon(x, y, radius, sides::Int64, orientation=0)
    [Point(x+cos(orientation + n * (2 * pi)/sides) * radius,
           y+sin(orientation + n * (2 * pi)/sides) * radius) for n in 1:sides]
end

# is a point inside a polygon?

function isinside(p::Point, poly::Array)
    # An implementation of Hormann-Agathos (2001) Point in Polygon algorithm
    c = false
    detq(q1,q2) = (q1.x - p.x) * (q2.y - p.y) - (q2.x - p.x) * (q1.y - p.y)
    for counter in 1:length(poly)
        q1 = poly[counter]
        # if reached last point, set "next point" to first point
        if counter == length(poly)
            q2 = poly[1]
        else
            q2 = poly[counter + 1]
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

# copy paths (thanks Andreas Lobinger!)
# return a CairoPath which is array of .element_type and .points

getpath()      = Cairo.convert_cairo_path_data(Cairo.copy_path(currentdrawing.cr))
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

fontface(f) = Cairo.select_font_face(currentdrawing.cr, f, Cairo.FONT_SLANT_NORMAL, Cairo.FONT_WEIGHT_NORMAL)
fontsize(n) = Cairo.set_font_size(currentdrawing.cr, n)

"""
    textextents(str)

    Return the measurements of string `str`:

    x_bearing
    y_bearing
    width
    height
    x_advance
    y_advance

    The bearing is the displacement from the reference point to the upper-left corner of the bounding box.
    It is often zero or a small positive value for x displacement, but can be negative x for characters like
    j as shown; it's almost always a negative value for y displacement. The width and height then describe the
    size of the bounding box. The advance takes you to the suggested reference point for the next letter.
    Note that bounding boxes for subsequent blocks of text can overlap if the bearing is negative, or the
    advance is smaller than the width would suggest.
"""

textextents(str) = Cairo.text_extents(currentdrawing.cr, str)

"""
    text(str, x, y)

    Draw text in string `str` at `x`/`y`.

    Text doesn't affect the current point!
"""

function text(t, x=0, y=0)
    gsave()
    Cairo.move_to(currentdrawing.cr, x, y)
    Cairo.show_text(currentdrawing.cr, t)
    grestore()
end


"""
    textcentred(str, x, y)

    Draw text in string `str` centered at `x`/`y`.

    Text doesn't affect the current point!
"""

function textcentred(t, x=0, y=0)
    textwidth = textextents(t)[5]
    text(t, x - textwidth/2, y)
end

"""
    textpath(t)

    Convert the text in `t` to a path, for subsequent filling...

"""
function textpath(t)
    Cairo.text_path(currentdrawing.cr, t)
end

"""
    textcurve(str, x, y, xc, yc, r)

    Put string of text on a circular arc
    Starting on line passing through (x,y), on arc/circle centred (xc,yc) on circle with radius r
    The radius is used to define the circle, the x/y are just used to define the start position...

"""

function textcurve(str, x, y, xc, yc, r)
    # first get widths of every character:
    widths = Float64[]
    for i in 1:length(str)
        extents = textextents(str[i:i])
        #        x_bearing = extents[1]
        #        y_bearing = extents[2]
        #        w = extents[3]
        #        h = extents[4]
        x_advance = extents[5]
        #        y_advance = extents[6]
        push!(widths, x_advance )
    end
    gsave()
    arclength = r * atan2(y, x) # starting on line passing through x/y but using radius
    for i in 1:length(str)
        gsave()
        theta = arclength/r  # angle for this character
        delta = widths[i]/r  # amount of turn created by width of this char
        translate(r * cos(theta), r * sin(theta)) # move the origin to this point
        rotate(theta + pi/2 + delta/2) # rotate so text baseline perp to center
        text(str[i:i])
        arclength += widths[i] # move on by the width of this character
        grestore()
    end
    grestore()
end

"""
    setcolor(col::AbstractString)

    Set the color to a string. Relying on Colors.jl to convert anything to RGBA
    eg setcolor("gold") # or "green", "darkturquoise", "lavender" or what have you


"""

function setcolor(col::AbstractString)
    temp = parse(RGBA, col)
    (currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue, currentdrawing.alpha) = (temp.r, temp.g, temp.b, temp.alpha)
    Cairo.set_source_rgba(currentdrawing.cr, currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue, temp.alpha)
end

"""
    setcolor(col::ColorTypes.Colorant)

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

"""
   setcolor(r, g, b, a=1)

   Set the color to r, g, b, a.

"""
function setcolor(r, g, b, a=1)
    currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue, currentdrawing.alpha = r, g, b, a
    Cairo.set_source_rgba(currentdrawing.cr, r, g, b, a)
end

"""
    setcolor_str(ex)

    Macro to set color:

        @setcolor"red"

"""

macro setcolor_str(ex)
    isa(ex, AbstractString) || error("colorant requires literal strings")
    col = parse(RGBA, ex)
    quote
    currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue, currentdrawing.alpha = $col.r, $col.g, $col.b, $col.alpha
    Cairo.set_source_rgba(currentdrawing.cr, currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue, $col.alpha)
    end
end

"""
    sethue is like setcolor(), but, like Mathematica we sometimes want to change the current 'color'
    without changing alpha/opacity. Using `sethue()` rather than `setcolor()` doesn't change the current alpha
    opacity.
"""

function sethue(col::AbstractString)
    temp = parse(RGBA,  col)
    currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue = temp.r, temp.g, temp.b
    Cairo.set_source_rgba(currentdrawing.cr, currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue, currentdrawing.alpha) # use current alpha, not incoming one
end

function sethue(col::ColorTypes.Colorant)
    temp = convert(RGBA,  col)
    currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue = temp.r, temp.g, temp.b
    # use current alpha
    Cairo.set_source_rgba(currentdrawing.cr, temp.r, temp.g, temp.b, currentdrawing.alpha)
end

function sethue(r, g, b)
    currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue = r, g, b
    # use current alpha
    Cairo.set_source_rgba(currentdrawing.cr, r, g, b, currentdrawing.alpha)
end


"""
    setopacity(a)

    Like Mathematica we sometimes want to change the current opacity without changing the current color.

"""

function setopacity(a)
    # use current RGB values
    currentdrawing.alpha = a
    Cairo.set_source_rgba(currentdrawing.cr, currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue, currentdrawing.alpha)
end

function randomhue()
    # don't touch current alpha
    sethue(rand(), rand(),rand())
end

function randomcolor()
    # can change alpha transparency
    setcolor(rand(), rand(),rand(), rand())
end

"""
    getmatrix()

    Return current Cairo matrix as an array.

    In Luxor, a matrix is an array of 6 float64 numbers:

        xx component of the affine transformation
        yx component of the affine transformation
        xy component of the affine transformation
        yy component of the affine transformation
        x0 translation component of the affine transformation
        y0 translation component of the affine transformation

"""

function getmatrix()
# return current matrix as an array
    gm = Cairo.get_matrix(currentdrawing.cr)
    return([gm.xx, gm.yx, gm.xy, gm.yy, gm.x0, gm.y0])
end

"""
    setmatrix(m::Array)

    Change the current Cairo matrix to match matrix `a`.

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
    transform(a::Array)

    Modify the current matrix by multiplying it by matrix `a`.

    For example, to skew the current state by 45 degrees in x and move by 20 in y direction:

        transform([1, 0, tand(45), 1, 0, 20])

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

end # module
