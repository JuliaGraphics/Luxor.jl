const Blend = CairoPattern

"""
    blend(from::Point, to::Point)

Create an empty linear blend.

A blend is a specification of how one color changes into another. Linear blends are
defined by two points: parallel lines through these points define the start and stop
locations of the blend. The blend is defined relative to the current axes origin. This means
that you should be aware of the current axes when you define blends, and when you use them.

To add colors, use `addstop()`.
"""
function blend(from::Point, to::Point)
    return Cairo.pattern_create_linear(from.x, from.y, to.x, to.y)
end

"""
    blend(centerpos1, rad1, centerpos2, rad2, color1, color2)

Create a radial blend.

Example:
```julia
redblue = blend(
    pos, 0,                   # first circle center and radius
    pos, tiles.tilewidth/2,   # second circle center and radius
    "red",
    "blue",
)
```
"""
function blend(centerpos1::Point, rad1, centerpos2::Point, rad2, color1, color2)
    newblend = blend(centerpos1, rad1, centerpos2, rad2)
    addstop(newblend, 0, color1)
    addstop(newblend, 1, color2)
    return newblend
end

"""
    blend(pt1::Point, pt2::Point, color1, color2)

Create a linear blend.

Example:

    redblue = blend(pos, pos, "red", "blue")
"""
function blend(pt1::Point, pt2::Point, color1, color2)
    newblend = blend(pt1, pt2)
    addstop(newblend, 0, color1)
    addstop(newblend, 1, color2)
    return newblend
end

"""
    blend(from::Point, startradius, to::Point, endradius)

Create an empty radial blend.

Radial blends are defined by two circles that define the start and stop locations. The
first point is the center of the start circle, the first radius is the radius of the first
circle.

A new blend is empty. To add colors, use `addstop()`.
"""
function blend(from::Point, startradius::Real, to::Point, endradius::Real)
    return Cairo.pattern_create_radial(from.x, from.y, startradius, to.x, to.y, endradius)
end

"""
    addstop(b::Blend, offset, col)
    addstop(b::Blend, offset, (r, g, b, a))
    addstop(b::Blend, offset, string)

Add a color stop to a blend. The offset specifies the location along the blend's 'control
vector', which varies between 0 (beginning of the blend) and 1 (end of the blend). For
linear blends, the control vector is from the start point to the end point. For radial
blends, the control vector is from any point on the start circle, to the corresponding point
on the end circle.

Examples:

    blendredblue = blend(Point(0, 0), 0, Point(0, 0), 1)
    addstop(blendredblue, 0, setcolor(sethue("red")..., .2))
    addstop(blendredblue, 1, setcolor(sethue("blue")..., .2))
    addstop(blendredblue, 0.5, sethue(randomhue()...))
    addstop(blendredblue, 0.5, setcolor(randomcolor()...))

"""
function addstop(b::Blend, offset, col::Colors.Colorant)
    temp = convert(RGBA,  col)
    Cairo.pattern_add_color_stop_rgba(b, offset, temp.r, temp.g, temp.b, temp.alpha)
end

function addstop(b::Blend, offset, col::AbstractString)
    temp = parse(RGBA, col)
    Cairo.pattern_add_color_stop_rgba(b, offset, temp.r, temp.g, temp.b, temp.alpha)
end

function addstop(b::Blend, offset, col::NTuple{4, Number})
    Cairo.pattern_add_color_stop_rgba(b, offset, col[1], col[2], col[3], col[4])
end

function addstop(b::Blend, offset, col::NTuple{3, Number})
    currentopacity = _get_current_alpha()
    Cairo.pattern_add_color_stop_rgba(b, offset, col[1], col[2], col[3], currentopacity)
end

"""
    setblend(blend)

Start using the named blend for filling graphics.

This aligns the original coordinates of the blend definition with the current axes.
"""
function setblend(b::Blend)
    Cairo.set_source(_get_current_cr(), b)
end

"""
    blendadjust(ablend, center::Point, xscale, yscale, rot=0)

Modify an existing blend by scaling, translating, and rotating it so that it will fill a
shape properly even if the position of the shape is nowhere near the original location of
the blend's definition.

For example, if your blend definition was this (notice the `1`)

```julia
blendgoldmagenta = blend(
    Point(0, 0), 0,                   # first circle center and radius
    Point(0, 0), 1,                   # second circle center and radius
    "gold",
    "magenta"
)
```

you can use it in a shape that's 100 units across and centered at `pos`,
by calling this:

    blendadjust(blendgoldmagenta, Point(pos.x, pos.y), 100, 100)

then use `setblend()`:

    setblend(blendgoldmagenta)
"""
function blendadjust(ablend, center::Point, xscale, yscale, rot=0)
    blendmatrix(ablend,
        juliatocairomatrix(
            rotationmatrix(-rot) *
            scalingmatrix(1/xscale, 1/yscale) *
            translationmatrix(-center.x, -center.y) *
        cairotojuliamatrix([1 0 0 1 0 0])))
end

"""
    blendmatrix(b::Blend, m)

Set the matrix of a blend.

To apply a sequence of matrix transforms to a blend:

```julia
A = [1 0 0 1 0 0]
Aj = cairotojuliamatrix(A)
Sj = scalingmatrix(2, .2) * Aj
Tj = translationmatrix(10, 0) * Sj
A1 = juliatocairomatrix(Tj)
blendmatrix(b, As)
```
"""
function blendmatrix(b::Blend, m)
    cm = Cairo.CairoMatrix(m[1], m[2], m[3], m[4], m[5], m[6])
    Cairo.set_matrix(b, cm)
end

"""
    setblendextend(blend::Blend, mode)

Specify how color blend patterns are repeated/extended. Supply the blend and one of the following strings:

- "repeat":  the pattern is repeated

- "reflect": the pattern is reflected (repeated in reverse)

- "pad": outside the pattern, use the closest color

- "none": outside of the pattern, use transparent pixels

"""
function setblendextend(blend::Blend, mode)
    if mode == "repeat" || mode == :repeat
        Cairo.pattern_set_extend(blend, Cairo.EXTEND_REPEAT)
    elseif mode == "reflect" || mode == :reflect
        Cairo.pattern_set_extend(blend, Cairo.EXTEND_REFLECT)
    elseif mode == "pad" || mode == :pad
        Cairo.pattern_set_extend(blend, Cairo.EXTEND_PAD)
    else
        Cairo.pattern_set_extend(blend, Cairo.EXTEND_NONE)
    end
end
