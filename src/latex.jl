import .MathTeXEngine:
    generate_tex_elements, inkwidth, inkheight, bottominkbound, TeXChar, HLine
using .LaTeXStrings

"""
    texalign(halign, valign, bottom_pt, top_pt, font_size)

Helper function to align LaTeX text properly. Returns
`translate_x` and `translate_y` which consists of the amount
to be shifted depending on the type of alignment chosen
and the bounding box of the text.
"""
function texalign(halign, valign, bottom_pt::Point, top_pt::Point, font_size)
    textw = top_pt[1] - bottom_pt[1]
    translate_x, translate_y = 0, 0

    if halign === :left
        translate_x = 0
    elseif halign === :right
        translate_x = -textw * font_size
    elseif halign === :center
        translate_x = -textw / 2 * font_size
    end

    if valign === :baseline
        translate_y = 0
    elseif valign === :bottom
        translate_y = 0
    elseif valign === :top
        translate_y = -top_pt[2] * font_size
    elseif valign === :middle
        translate_y = -(bottom_pt[2] + top_pt[2]) * font_size / 2
    end
    return translate_x, translate_y
end

"""
    rawlatexboundingbox(lstr::LaTeXString, font_size=1)

Helper function that returns the coordinate points
of the bounding box containing the specific LaTeX text.
"""
function rawlatexboundingbox(lstr::LaTeXString)
    sentence = generate_tex_elements(lstr)
    els = filter(x -> x[1] isa TeXChar, sentence)
    texchars = [x[1] for x in els]
    pos_x = [x[2][1] for x in els]
    pos_y = [x[2][2] for x in els]
    scales = [x[3] for x in els]
    textw = maximum(inkwidth.(texchars) .* scales .+ pos_x)
    bottom = bottominkbound.(texchars)
    bottom_pt = Point(0, maximum(-bottom .* scales .- pos_y))
    top_pt = Point(textw, -maximum(inkheight.(texchars) .* scales .+ pos_y .+ bottom))

    return (bottom_pt, top_pt)
end

"""
    latexboundingbox(lstr::LaTeXString, font_size=get_fontsize(); halign=:left, valign=:right)

Returns the bounding box containing the latex text with
`(Lower Left Point, Upper Right Point)`.
Use `box(latex_bb(testext)...,:stroke)` to draw the bounding box.
"""
function latexboundingbox(lstr::LaTeXString, font_size = get_fontsize();
    halign = :left, valign = :right)
    bottom_pt, top_pt = rawlatexboundingbox(lstr)

    translate_x, translate_y = texalign(halign, valign, bottom_pt, top_pt, font_size)
    translate_pt = Point(translate_x, translate_y)

    return (bottom_pt * font_size + translate_pt, top_pt * font_size + translate_pt)
end

"""
    latextextsize(lstr::LaTeXString)

Returns the width and height of a latex string.
"""
function latextextsize(lstr::LaTeXString)
    bottom_pt, top_pt = latexboundingbox(lstr)
    textw = top_pt[1] - bottom_pt[1]
    texth = -(top_pt[2] - bottom_pt[2])
    return textw, texth
end

"""
    _write_tex_element(texelement, font_size)

Draw the texchar as text. This uses the
Pro text API: `setfont()` and `settext()`
"""
function _write_tex_element(texchar::TeXChar, pos, fscale, font_size ; paths=false)
    setfont(texchar.font, font_size * fscale)
    x = pos[1] * font_size
    y = -pos[2] * font_size
    cg = Cairo.CairoGlyph(texchar.glyph_id, x, y)

    @show paths
    @show texchar

    if paths
        newsubpath()
        Cairo.glyph_path(get_current_cr(), cg)
        do_action(:stroke)
    else
        Cairo.show_glyph(get_current_cr(), cg)
    end
end

function _write_tex_element(hline::HLine, pos, fscale, font_size ; paths=false)
    spt = Point(pos...) * font_size
    linestart = spt * (fscale, -fscale)
    lineend = linestart + (hline.width * font_size, hline.thickness * font_size)

    if paths
        box(linestart, lineend, :path)
        newsubpath()
    else
        box(linestart, lineend, :fill)
    end
end

"""
    text(lstr::LaTeXString, pt::Point;
        valign = :baseline,
        halign = :left,
        angle = 0::Real,
        rotationfixed = false,
        paths = false,
        kwargs...)

Another method for `text` that draws the LaTeX `lstr`,
using `MathTexEngine.jl`. Uses NewComputerModern as font 
family. When `rotationfixed = true`,
the text will rotate around its own axis, instead of
rotating around `pt`.

If `paths` is true, text paths are added to the current
path, rather than drawn.

```julia
using Luxor
using MathTeXEngine
using LaTeXStrings
@draw begin
    fontsize(70)
    text(L"e^{i \\pi} + 1 = 0", halign = :center)
end
```
"""
function text(lstr::LaTeXString, pt::Point;
    valign = :baseline,
    halign = :left,
    angle = 0::Real,
    rotationfixed = false,
    paths = false,
    kwargs...)
    @show lstr
    @show paths
    # with MathTexEngine.generate_tex_elements
    sentence = Luxor.generate_tex_elements(lstr)
    # get current font size
    font_size = get_fontsize()
    bottom_pt, top_pt = Luxor.rawlatexboundingbox(lstr)
    translate_x, translate_y = Luxor.texalign(halign, valign, bottom_pt, top_pt, font_size)

    for (texelement, pos, scale) in sentence
        @layer begin
            translate(pt)
            if !rotationfixed
                rotate(angle)
                translate(translate_x, translate_y)
            else
                l_pt, r_pt = Luxor.latexboundingbox(lstr, halign = halign, valign = valign)
                translate((l_pt + r_pt) / 2)
                rotate(angle)
                translate(Point(translate_x, translate_y) - (l_pt + r_pt) / 2)
            end
            _write_tex_element(texelement, pos, scale, font_size ; paths)
        end
    end
end

text(lstr::LaTeXString; kwargs...) = text(lstr, O; kwargs...)
