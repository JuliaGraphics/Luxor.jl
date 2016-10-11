typealias Blend CairoPattern

"""
    blend(from::Point, to::Point)

Create a linear blend.

A blend is a specification of how one color changes into another. Linear blends are
defined by two points: parallel lines through these points define the start and stop
locations of the blend. The blend is defined relative to the current axes origin. This means
that you should be aware of the current axes when you define blends, and when you use them.

A new blend is empty. To add colors, use `addstop()`.
"""

function blend(from::Point, to::Point)
    return Cairo.pattern_create_linear(from.x, from.y, to.x, to.y)
end

"""
    blend(centerpos1, rad1, centerpos2, rad2, color1, color2)

Create a radial blend.

Example:

    redblue = blend(
        pos, 0,                   # first circle center and radius
        pos, tiles.tilewidth/2,   # second circle center and radius
        "red",
        "blue"
        )
"""

function blend(centerpos1::Point, rad1, centerpos2::Point, rad2, color1, color2)
    newblend = blend(centerpos1, rad1, centerpos2, rad2)
    addstop(newblend, 0, color1)
    addstop(newblend, 1, color2)
    return newblend
end

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

function blend(from::Point, startradius, to::Point, endradius)
    return Cairo.pattern_create_radial(from.x, from.y, startradius, to.x, to.y, endradius)
end

"""
    addstop(b::Blend, offset, col

Add a color stop to a blend. The offset specifies the location along the blend's 'control
vector', which varies between 0 (beginning of the blend) and 1 (end of the blend). For
linear blends, the control vector is from the start point to the end point. For radial
blends, the control vector is from any point on the start circle, to the corresponding point
on the end circle.
"""

function addstop(b::Blend, offset, col::ColorTypes.Colorant)
    temp = convert(RGBA,  col)
    Cairo.pattern_add_color_stop_rgba(b, offset, temp.r, temp.g, temp.b, temp.alpha)
end

function addstop(b::Blend, offset, col::String)
    temp = parse(RGBA, col)
    Cairo.pattern_add_color_stop_rgba(b, offset, temp.r, temp.g, temp.b, temp.alpha)
end

"""
    setblend(blend)

Start using the named blend for filling graphics.

This aligns the original coordinates of the blend definition with the current axes.
"""

function setblend(b::Blend)
    Cairo.set_source(currentdrawing.cr, b)
end

"""
    blendmatrix(b::Blend, m)

Set the matrix of a blend.

To apply a sequence of matrix transforms to a blend:

```
A = [1 0 0 1 0 0]
Aj = cairotojuliamatrix(A)
Sj = scaling_matrix(2, .2) * Aj
Tj = translation_matrix(10, 0) * Sj
A1 = juliatocairomatrix(Tj)
blendmatrix(b, As)
```
"""

function blendmatrix(b::Blend, m)
    cm = Cairo.CairoMatrix(m[1], m[2], m[3], m[4], m[5], m[6])
    Cairo.set_matrix(b, cm)
end

"""
    rotation_matrix(a)

Return a 3 by 3 Julia matrix that will apply a rotation through `a` radians.
"""

function rotation_matrix(a)
    return ([cos(a)  -sin(a)    0 ;
             sin(a)   cos(a)    0 ;
             0            0   1.0 ])
end

"""
    translation_matrix(x, y)

Return a 3 by 3 Julia matrix that will apply a translation in `x` and `y`.
"""

function translation_matrix(x, y)
    return ([1.0     0     x ;
               0     1.0   y ;
               0     0     1.0 ])
end

"""
    scaling_matrix(sx, sy)

Return a 3 by 3 Julia matrix that will apply a scaling by `sx` and `sy`.
"""

function scaling_matrix(sx, sy)
    return ([sx   0   0 ;
             0   sy   0 ;
             0    0   1.0])
end

"""
    cairotojuliamatrix(c)

Return a 3 by 3 Julia matrix that's the equivalent of the six-element Cairo matrix in `c`.
"""

function cairotojuliamatrix(c::Array)
    return [c[1] c[3] c[5] ; c[2] c[4] c[6] ; 0 0 1]
end

"""
    juliatocairomatrix(c)

Return a six-element Cairo matrix 3 that's the equivalent of the 3 by 3 Julia matrix in `c`.
"""

function juliatocairomatrix(c::Matrix)
    return [c[1] c[2] c[4] c[5] c[7] c[8]]
end

# end
