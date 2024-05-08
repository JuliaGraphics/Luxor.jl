"""
    origin()

Reset the current position, scale, and orientation, and then set the 0/0 origin to the center of the drawing
(otherwise it will stay at the top left corner, the default).

You can refer to the 0/0 point as `O`. (O = `Point(0, 0)`),
"""
function origin()
    setmatrix([1.0, 0.0, 0.0, 1.0, 0.0, 0.0])
    Cairo.translate(_get_current_cr(), _current_width() / 2.0, _current_height() / 2.0)
end

function origin(x, y)
    setmatrix([1.0, 0.0, 0.0, 1.0, 0.0, 0.0])
    Cairo.translate(_get_current_cr(), x, y)
end

"""
    origin(pt:Point)

Reset the current position, scale, and orientation, then move the `0/0` position to `pt`.
"""
function origin(pt)
    setmatrix([1.0, 0.0, 0.0, 1.0, 0.0, 0.0])
    Cairo.translate(_get_current_cr(), pt.x, pt.y)
end

"""
    rescale(x, from_min, from_max, to_min=0.0, to_max=1.0)

Convert `x` from one linear scale (`from_min` to `from_max`) to another
(`to_min` to `to_max`).

The scales can also be supplied in tuple form:

```julia
rescale(x, (from_min, from_max), (to_min, to_max))
```

Examples
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
rescale(x, from_min, from_max, to_min = 0.0, to_max = 1.0) =
    ((x - from_min) / (from_max - from_min)) * (to_max - to_min) + to_min
rescale(x, from::NTuple{2,Number}, to::NTuple{2,Number}) =
    ((x - from[1]) / (from[2] - from[1])) * (to[2] - to[1]) + to[1]

"""
    background(col::Colors.Colorant)

Paint the drawing (or the current clipping region, if there is one) with the
`color``. Previously-drawn graphics will be wholly or partly obscured depending on
the opacity of the color.

Returns a tuple `(r, g, b, a)` of the color that was used to paint the background.

The macros `@png`, `@draw`, and `@svg` use `background("white")` as part of the drawing set-up.

# Examples:

```julia
background("antiquewhite")
background(1, 0.0, 1.0)
background(1, 0.0, 1.0, .5)
background(Luxor.Colors.RGB(0, 1, 0))
```

If Colors.jl has been imported:

```julia
background(RGB(0, 1, 0))
background(RGBA(0, 1, 0))
background(RGBA(0, 1, 0, .5))
background(Luv(20, -20, 30))
```

If you don't specify a background color for a PNG drawing, the background will
be transparent. You can set a partly or completely transparent background for
PNG files by passing a color with an alpha value, such as this 'transparent
black':

```julia
background(RGBA(0, 0, 0, 0))
```

or

```julia
background(0, 0, 0, 0)
```

Returns a tuple `(r, g, b, a)` of the color that was used to paint the background.
"""
function background(col::Colors.Colorant)
    gsave()
    setcolor(col)
    paint()
    r, g, b, a = _get_current_redvalue(), _get_current_greenvalue(), _get_current_bluevalue(), _get_current_alpha()
    grestore()
    return (r, g, b, a)
end

function background(col::T) where {T<:AbstractString}
    return background(parse(Colorant, col))
end

function background(r, g, b, a = 1)
    return background(RGBA(r, g, b, a))
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

This affects subsequent graphics, but not text, and it
doesn't apply to all types of output file.
"""
setantialias(n) = Cairo.set_antialias(_get_current_cr(), n)

"""
    newpath()

Discard the current path's contents. After this, the current path is empty, and there's
no current point.
"""
newpath() = Cairo.new_path(_get_current_cr())

"""
    newsubpath()

Start a new subpath in the current path. After this, there's no current point.
"""
newsubpath() = Cairo.new_sub_path(_get_current_cr())

"""
    closepath()

Draw a line from the current point to the first point of the current subpath.
This is Cairo's `close_path()` function.
"""
closepath() = Cairo.close_path(_get_current_cr())

abstract type LDispatcher end
# Packages which want to override strokepath/fillpath/strokepreserve/fillpreserve
# can subtype an empty struct from this abstract type and dispatch on them .
# Make sure Luxor.DISPATCHER[1] is set to an instance of the struct you want to
# dispatch on in your module.

#Default luxor behaviour dispatches on `DefaultLuxor`
struct DefaultLuxor <: LDispatcher end
#global constant to decide dispatch, a single element array which
const DISPATCHER = Array{LDispatcher}([DefaultLuxor()])

"""
    strokepath()

Stroke the current path with the current line width, line join, line cap, dash,
and stroke scaling settings. The current path is then emptied.
"""
strokepath() = strokepath(DISPATCHER[1])
strokepath(::DefaultLuxor) = _get_current_strokescale() ? Cairo.stroke_transformed(_get_current_cr()) : Cairo.stroke(_get_current_cr())
strokepath(::LDispatcher) = strokepath(DefaultLuxor())

"""
    fillpath()

Fill the current path according to the current settings. The current path is then emptied.
"""
fillpath() = fillpath(DISPATCHER[1])
fillpath(::DefaultLuxor) = Cairo.fill(_get_current_cr())
fillpath(::LDispatcher) = fillpath(DefaultLuxor())

"""
    paint()

Paint the current clip region with the current settings.
"""
paint() = paint(DISPATCHER[1])
paint(::DefaultLuxor) = Cairo.paint(_get_current_cr())
paint(::LDispatcher) = paint(DefaultLuxor())

"""
    strokepreserve()

Stroke the current path with current line width, line join, line cap, dash, and
stroke scaling settings, but then keep the path current.
"""
strokepreserve() = strokepreserve(DISPATCHER[1])
strokepreserve(::DefaultLuxor) = _get_current_strokescale() ? Cairo.stroke_preserve_transformed(_get_current_cr()) : Cairo.stroke_preserve(_get_current_cr())
strokepreserve(::LDispatcher) = strokepreserve(DefaultLuxor())

"""
    fillpreserve()

Fill the current path with current settings, but then keep the path current.
"""
fillpreserve() = fillpreserve(DISPATCHER[1])
fillpreserve(::DefaultLuxor) = Cairo.fill_preserve(_get_current_cr())
fillpreserve(::LDispatcher) = fillpreserve(DefaultLuxor())

"""
    fillstroke()

Fill and stroke the current path.
After this, the current path is empty, and there is no current point.
"""
function fillstroke()
    fillpreserve()
    strokepath()
end

"""
    do_action(action)

This is usually called by other graphics functions. Actions for graphics commands include
`:fill`, `:stroke`, `:clip`, `:fillstroke`, `:fillpreserve`, and `:strokepreserve`.

The `:path` action adds the graphics to the current path.
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
    end
    # ignore any other value for action
    return true
end

"""
    clip()

Establish a new clipping region by intersecting the current clipping region with the
current path and then clearing the current path.

An existing clipping region is enforced through and after a
`gsave()`-`grestore()` block, but a clipping region set inside a
`gsave()`-`grestore()` block is lost after `grestore()`. [?]
"""
clip() = clip(DISPATCHER[1])
clip(::DefaultLuxor) = Cairo.clip(_get_current_cr())
clip(::LDispatcher) = clip(DefaultLuxor())

"""
    clippreserve()

Establish a new clipping region by intersecting the current clipping region with the current
path, but keep the current path.
"""
clippreserve() = clippreserve(DISPATCHER[1])
clippreserve(::DefaultLuxor) = Cairo.clip_preserve(_get_current_cr())
clippreserve(::LDispatcher) = clippreserve(DefaultLuxor())

"""
    clipreset()

Reset the clipping region to the current drawing's extent.
"""
clipreset() = Cairo.reset_clip(_get_current_cr())

"""
    setline(n)

Set the line width, in points.

Use `getline()` to get the current value.
"""
setline(n) = Cairo.set_line_width(_get_current_cr(), n)

"""
    getline()

Get the current line width, in points.

Use `setline()` to set the value.
"""
function getline()
    ccall((:cairo_get_line_width, Cairo.libcairo),
        Float64, (Ptr{Nothing},), Luxor._get_current_cr().ptr)
end

"""
    setlinecap(s)

Set the line ends. `s` can be "butt" or `:butt` (the
default), "square" or `:square`, or "round" or `:round`.
"""
function setlinecap(str::String = "butt")
    if str == "round"
        Cairo.set_line_cap(_get_current_cr(), Cairo.CAIRO_LINE_CAP_ROUND)
    elseif str == "square"
        Cairo.set_line_cap(_get_current_cr(), Cairo.CAIRO_LINE_CAP_SQUARE)
    else
        Cairo.set_line_cap(_get_current_cr(), Cairo.CAIRO_LINE_CAP_BUTT)
    end
end

function setlinecap(sym::Symbol)
    if sym == :round
        Cairo.set_line_cap(_get_current_cr(), Cairo.CAIRO_LINE_CAP_ROUND)
    elseif sym == :square
        Cairo.set_line_cap(_get_current_cr(), Cairo.CAIRO_LINE_CAP_SQUARE)
    else
        Cairo.set_line_cap(_get_current_cr(), Cairo.CAIRO_LINE_CAP_BUTT)
    end
end

"""
    setlinejoin("miter")
    setlinejoin("round")
    setlinejoin("bevel")

Set the way line segments are joined when the path is stroked.

The default joining style is "mitered".
"""
function setlinejoin(str = "miter")
    if str == "round"
        Cairo.set_line_join(_get_current_cr(), Cairo.CAIRO_LINE_JOIN_ROUND)
    elseif str == "bevel"
        Cairo.set_line_join(_get_current_cr(), Cairo.CAIRO_LINE_JOIN_BEVEL)
    else
        Cairo.set_line_join(_get_current_cr(), Cairo.CAIRO_LINE_JOIN_MITER)
    end
end

"""
    setdash("dot")

Set the dash pattern of lines to one of: "solid", "dotted", "dot", "dotdashed",
"longdashed", "shortdashed", "dash", "dashed", "dotdotdashed",
"dotdotdotdashed".

Use `setdash(dashes::Vector)` to specify the pattern numerically.
"""
function setdash(dashing::AbstractString)
    Cairo.set_line_type(_get_current_cr(), dashing)
end

"""
    setdash(dashes::Vector, offset=0.0)

Set the dash pattern for lines to the values in `dashes`. The first number is the length
of the inked portion, the second the space, and so on.

The `offset` specifies an offset into the pattern at which the stroke begins. So
an offset of 10 means that the stroke starts at `dashes[1] + 10` into the
pattern.

Or use `setdash("dot")` etc.
"""
function setdash(dashes::Vector, offset = 0.0)
    # no negative dashes
    Cairo.set_dash(_get_current_cr(), abs.(Float64.(dashes)), offset)
end

"""
    setstrokescale()

Return the current stroke scaling setting.
"""
setstrokescale() = _get_current_strokescale()

"""
    setstrokescale(state::Bool)

Enable/disable stroke scaling for the current drawing.
"""
setstrokescale(state::Bool) = _set_current_strokescale(state)

"""
    move(pt)

Begin a new subpath in the current path, and set the current path's current point
to `pt`, without drawing anything.

Other path-building functions are `line()`, `curve()`, `arc()`, `rline()`, and
`rmove()`.

`hascurrentpoint()` returns true if there is a current point.
"""
move(x, y) = Cairo.move_to(_get_current_cr(), x, y)
move(pt) = move(pt.x, pt.y)

"""
    rmove(pt)

Begin a new subpath in the current path, add `pt` to the current path's current
point, then update the current point.

Other path-building functions are `move()`, `line()`, `curve()`, `arc()`, and `rline()`.

There must be a current point before you call this function.

See also `currentpoint()` and `hascurrentpoint()`.
"""
rmove(x, y) = Cairo.rel_move_to(_get_current_cr(), x, y)
rmove(pt) = rmove(pt.x, pt.y)

"""
    line(pt::Point)

Add a straight line to the current path that joins the path's current point to `pt`. The
current point is then updated to `pt`.

Other path-building functions are `move()`, `curve()`, `arc()`, `rline()`, and
`rmove()`.

See also `currentpoint()` and `hascurrentpoint()`.
"""
line(x, y) = Cairo.line_to(_get_current_cr(), x, y)
line(pt) = line(pt.x, pt.y)

"""
    line(pt1::Point, pt2::Point; action=:path)
    line(pt1::Point, pt2::Point, action=:path)

Add a straight line between two points `pt1` and `pt2`, and do the action.
"""
function line(pt1::Point, pt2::Point;
    action = :path)
    move(pt1)
    line(pt2)
    do_action(action)
end

line(pt1::Point, pt2::Point, action::Symbol) = line(pt1, pt2, action = action)

"""
    rline(pt)

Add a line relative to the current position to the `pt`.
"""
rline(x, y) = Cairo.rel_line_to(_get_current_cr(), x, y)
rline(pt) = rline(pt.x, pt.y)

"""
    rule(pos, theta;
        boundingbox=BoundingBox(),
        vertices=false)

Draw a straight line through `pos` at an angle `theta` from the x axis.

By default, the line spans the entire drawing, but you can supply a BoundingBox
to change the extent of the line.

```julia
rule(O)       # draws an x axis
rule(O, pi/2) # draws a  y axis
```

The function:

```julia
rule(O, pi/2, boundingbox=BoundingBox()/2)
```

draws a line that spans a bounding box half the width and height of the drawing,
and returns a Set of end points. If you just want the vertices and don't want to
draw anything, use `vertices=true`.
"""
function rule(pos, theta = 0.0;
    boundingbox = BoundingBox(),
    vertices = false)
    #TODO interaction with clipping regions needs work

    #TODO which boundingbox is providing the default???
    bbox       = box(boundingbox, vertices = true)
    topside    = bbox[2:3]
    rightside  = bbox[3:4]
    bottomside = vcat(bbox[4], bbox[1])
    leftside   = bbox[1:2]

    # ruled line could be as long as the diagonal so add a bit extra
    r = boxdiagonal(boundingbox) + 10
    rcosa = r * cos(theta)
    rsina = r * sin(theta)
    ruledline = (pos - (rcosa, rsina), pos + (rcosa, rsina))

    interpoints = Vector{Point}()

    # check for intersection with top of bounding box
    flag, ip = intersectionlines(ruledline[1], ruledline[2], topside[1], topside[2], crossingonly = true)
    if flag
        if !(ip.x > topside[2].x || ip.x < topside[1].x)
            push!(interpoints, ip)
        end
    end

    # check for right intersection
    flag, ip = intersectionlines(ruledline[1], ruledline[2], rightside[1], rightside[2], crossingonly = true)
    if flag
        if !(ip.y > rightside[2].y || ip.y < rightside[1].y)
            push!(interpoints, ip)
        end
    end

    # check for bottom intersection
    flag, ip = intersectionlines(ruledline[1], ruledline[2], bottomside[1], bottomside[2], crossingonly = true)
    if flag
        if !(ip.x < bottomside[2].x || ip.x > bottomside[1].x)
            push!(interpoints, ip)
        end
    end

    # check for left intersection
    flag, ip = intersectionlines(ruledline[1], ruledline[2], leftside[1], leftside[2], crossingonly = true)
    if flag
        if !(ip.y > leftside[1].y || ip.y < leftside[2].y)
            push!(interpoints, ip)
        end
    end

    # eliminate duplicates due to rounding errors
    ruledline = unique(interpoints)

    # finally draw the line if we have two points
    if vertices == false && length(ruledline) == 2
        line(ruledline..., :stroke)
    end
    return ruledline
end

# we need a thread safe way to store the color palette as a stack:
#  access to the stack is only possible using the global function:
#   - predefine all needed Dict entries in a thread safe way
#   - each thread has it's own stack, separated by threadid
# this is not enough for Threads.@spawn (TODO, but no solution yet)
let _SAVED_COLORS_STACK = Ref{Dict{Int,Vector{NTuple{4,Float64}}}}(Dict(0 => Vector{NTuple{4,Float64}}()))
    global _saved_colors
    function _saved_colors()
        id = Threads.threadid()
        if !haskey(_SAVED_COLORS_STACK[], id)
            # predefine all needed Dict entries
            lc = ReentrantLock()
            lock(lc)
            for preID in 1:Threads.nthreads()
                _SAVED_COLORS_STACK[][preID] = Vector{NTuple{4,Float64}}()
            end
            unlock(lc)
        end
        if isnothing(_SAVED_COLORS_STACK[][id])
            # all Dict entries are predefined, so we should never reach this error
            error("(4)thread id should be preallocated")
        end
        # thread specific stack
        return _SAVED_COLORS_STACK[][id]
    end
end

# I originally used simple Cairo save() but the colors/opacity
# thing I've got going didn't save/restore properly, hence the stack
"""
    gsave()

Save the current graphics environment, including current color settings.
"""
function gsave()
    Cairo.save(_get_current_cr())
    r, g, b, a = (_get_current_redvalue(),
        _get_current_greenvalue(),
        _get_current_bluevalue(),
        _get_current_alpha(),
    )
    push!(_saved_colors(), (r, g, b, a))
    return (r, g, b, a)
end

"""
    grestore()

Replace the current graphics state with the one previously saved by the most recent
`gsave()`.
"""
function grestore()
    Cairo.restore(_get_current_cr())
    try
        (r, g, b, a) = pop!(_saved_colors())
        _set_current_redvalue(r)
        _set_current_greenvalue(g)
        _set_current_bluevalue(b)
        _set_current_alpha(a)
    catch err
        println("$err Not enough colors on the stack to restore.")
    end
end

"""
The `@layer` macro is a shortcut for `gsave()` ... `grestore()`.
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

Scale the current workspace by different values in `x` and `y`.

Values are relative to the current scale.
Example:

```julia
scale(0.2, 0.3)
```
"""
scale(sx::Real, sy::Real) = Cairo.scale(_get_current_cr(), sx, sy)

"""
    scale(f)

Scale the current workspace by `f` in both `x` and `y` directions.

Values are relative to the current scale.
"""
scale(f::Real) = Cairo.scale(_get_current_cr(), f, f)

"""
    rotate(a::Float64)

Rotate the current workspace by `a` radians clockwise (from positive x-axis to positive y-axis).

Values are relative to the current orientation.
"""
rotate(a) = Cairo.rotate(_get_current_cr(), a)

"""
    translate(point)
    translate(x::Real, y::Real)

Translate the current workspace to `x` and `y` or to `pt`.

Values are relative to the current location.
"""
translate(tx::Real, ty::Real) = Cairo.translate(_get_current_cr(), tx, ty)
translate(pt::Point) = translate(pt.x, pt.y)

"""
    getpath()

Get the current path and return a CairoPath object, which is an array of `element_type` and
`points` objects. With the results you can step through and examine each entry like this:

```julia
o = getpath()
x, y = currentpoint()
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
        (x, y) = (x3, y3) # update current point
    elseif e.element_type == Cairo.CAIRO_PATH_CLOSE_PATH
        closepath()
    else
        error("unknown CairoPathEntry " * repr(e.element_type))
        error("unknown CairoPathEntry " * repr(e.points))
    end
end
```
"""
getpath() = Cairo.convert_cairo_path_data(Cairo.copy_path(_get_current_cr()))

"""
    getpathflat()

Get the current path, like `getpath()` but flattened so that there are no Bézier curves.

Returns a CairoPath which is an array of `element_type` and `points` objects.
"""
getpathflat() = Cairo.convert_cairo_path_data(Cairo.copy_path_flat(_get_current_cr()))

"""
    rulers()

Draw and label two CAD-style rulers starting at `O`, the current 0/0, and continuing out
along the current positive x and y axes.
"""
function rulers()
    @layer begin
        n = 200
        w = 20
        setopacity(0.5)
        setline(0.25)
        sethue(1.0, 0.549, 0.0) # darkorange
        #x axis
        box(O, O + (n, -w), :fillstroke)
        #y axis
        box(O - (w, 0), O + (0, n), :fillstroke)
        sethue(0.722, 0.525, 0.043) # darkgoldenrod
        setopacity(1)
        [line(Point(x, 0), Point(x, -w / 4), :stroke) for x in 0:10:n]
        [line(Point(-w / 4, y), Point(0, y), :stroke) for y in 0:10:n]
        [line(Point(x, 0), Point(x, -w / 6), :stroke) for x in 0:5:n]
        [line(Point(-w / 6, y), Point(0, y), :stroke) for y in 0:5:n]
        fontsize(2)
        [text(string(x), Point(x, -w / 3), halign = :right) for x in 10:10:n]
        @layer begin
            rotate(pi / 2)
            [text(string(x), Point(x, w / 3), halign = :right) for x in 10:10:n]
        end
        fontsize(15)
        text("X", O + (n - w / 2, w), halign = :right, valign = :middle)
        text("Y", O + (-3w / 2, n - w), halign = :right, valign = :middle, angle = pi / 2)
        sethue(1.0, 1.0, 1.0)
        text("X", O + (w, -w / 2), halign = :right, valign = :middle)
        text("Y", O + (-w / 3, w / 3), halign = :right, valign = :middle, angle = pi / 2)
        #center
        circle(O, 2, :strokepreserve)
        setopacity(0.5)
        fillpath()
    end
    return true
end

"""
    hcat(D::Drawing...; valign=:top, hpad=0, clip=true)

Create a new SVG drawing by horizontal concatenation of SVG drawings. If drawings
have different height, the `valign` option can be used in order to define
how to align. The `hpad` argument can be used to add padding between
concatenated images.

The `clip` argument is a boolean for whether
the concatenated images should be clipped before concatenation.
Note that drawings sometimes have elements that go beyond it's margins,
and they only show when the image is drawn in a larger canvas. The `clip`
argument ensures that these elements are not drawn in the concatenated drawing.

Example:

```julia
d1 = Drawing(200, 100, :svg)
origin()
circle(O, 60, :fill)
finish()

d2 = Drawing(200, 200, :svg)
rect(O, 200, 200, :fill)
finish()
hcat(d1, d2; hpad = 10, valign = :top, clip = true)
```
"""
function Base.hcat(D::Drawing...; valign = :top, hpad = 0, clip = true)
    dheight, dwidth = 0, -hpad
    for d in D
        dheight = max(dheight, d.height)
        dwidth += d.width + hpad
        if d.surfacetype !== :svg
            throw(error("hcat(): Drawing must be SVG, not $(d.surfacetype)"))
        end
    end
    dcat = Drawing(dwidth, dheight, :svg)
    @layer begin
        for d in D
            if valign === :top
                pt = O
                clip ? rect(pt, d.width, d.height, :clip) : nothing
                placeimage(d, pt)
            elseif valign === :bottom
                pt = Point(0, dheight - d.height)
                clip ? rect(pt, d.width, d.height, :clip) : nothing
                placeimage(d, pt)
            elseif valign === :middle
                pt = Point(0, dheight - d.height) / 2
                clip ? rect(pt, d.width, d.height, :clip) : nothing
                placeimage(d, pt)
            else
                throw("`valign` option not valid. Use either `:top`, `:bottom` or `:middle`.")
            end
            clipreset()
            translate(Point(d.width + hpad, 0))
        end
    end
    finish()
    dcat
end

"""
    vcat(D::Drawing...; halign=:left, vpad=0, clip=true)

Creates a new SVG drawing by vertical concatenation of SVG drawings. If drawings
have different widths, the `halign` option can be used in order to define
how to align. The `vpad` argument can be used to add padding between
concatenated images.

The `clip` argument is a boolean for whether
the concatenated images should be clipped before concatenation.
Note that drawings sometimes have elements that go beyond it's margins,
and they only show when the image is drawn in a larger canvas. The `clip`
argument ensures that these elements are not drawn in the concatenated drawing.

Example:

```julia
d1 = Drawing(200, 100, :svg)
origin()
circle(O, 60, :fill)
finish()

d2 = Drawing(200, 200, :svg)
rect(O, 200, 200, :fill)
finish()
vcat(d1, d2; vpad = 10, halign = :left, clip = true)
```
"""
function Base.vcat(D::Drawing...; halign = :left, vpad = 0, clip = true)
    dheight, dwidth = -vpad, 0
    for d in D
        dwidth = max(dwidth, d.width)
        dheight += d.height + vpad
        if d.surfacetype !== :svg
            throw(error("vcat(): Drawing must be SVG, not $(d.surfacetype)"))
        end
    end
    dcat = Drawing(dwidth, dheight, :svg)
    @layer begin
        for d in D
            if halign === :left
                pt = O
                clip ? rect(pt, d.width, d.height, :clip) : nothing
                placeimage(d, pt)
            elseif halign === :right
                pt = Point(dwidth - d.width, 0)
                clip ? rect(pt, d.width, d.height, :clip) : nothing
                placeimage(d, pt)
            elseif halign === :center
                pt = Point(dwidth - d.width, 0) / 2
                clip ? rect(pt, d.width, d.height, :clip) : nothing
                placeimage(d, pt)
            else
                throw("`halign` option not valid. Use either `:left`, `:right` or `:center`.")
            end
            clipreset()
            translate(Point(0, d.height + vpad))
        end
    end
    finish()
    dcat
end

"""
    setfillrule(rule::Symbol)

Set the fill rule for paths for the current drawing.

`rule` can be `:winding` or `:even_odd`

The fill rule is used to select how subpaths are filled. For both fill rules,
whether or not a point is included in the fill is determined by taking a ray
from that point to infinity and looking at intersections with the path. The ray
can be in any direction, as long as it doesn't pass through the end point of a
segment or have a tricky intersection such as intersecting tangent to the path.
(Note that filling is not actually implemented in this way. This is just a
description of the rule that is applied.)

The default fill rule is `:winding`.

`:winding`: If the path crosses the ray from left-to-right, counts +1. If the
path crosses the ray from right to left, counts -1. (Left and right are
determined from the perspective of looking along the ray from the starting
point.) If the total count is non-zero, the point will be filled.

`even_odd`: counts the total number of intersections, without regard to the
orientation of the contour. If the total number of intersections is odd, the
point will be filled. (Since 1.0)

See [`getfillrule`](@ref).
"""
function setfillrule(rule::Symbol = :winding)
    if rule === :even_odd
        Cairo.set_fill_type(_get_current_cr(), Cairo.CAIRO_FILL_RULE_EVEN_ODD)
    else
        Cairo.set_fill_type(_get_current_cr(), Cairo.CAIRO_FILL_RULE_WINDING)
    end
end

"""
    getfillrule()

Get the current fill rule for paths for the current drawing.

The `rule` can be `:winding` or `:even_odd`.

See [`setfillrule`](@ref).
"""
function getfillrule()
    c = ccall((:cairo_get_fill_rule, Luxor.Cairo.libcairo),
        Int64, (Ptr{Nothing},), Luxor._get_current_cr().ptr)
    if c == 0
        return Symbol(:winding)
    elseif c == 1
        return Symbol(:even_odd)
    else
        throw(error("getfillrule(): no information available"))
    end
end
