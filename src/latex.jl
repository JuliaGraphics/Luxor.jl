import .MathTeXEngine:
    generate_tex_elements, inkwidth, inkheight, bottominkbound, TeXChar, HLine
using .LaTeXStrings

# the fonts we're using 
mutable struct FontSpec
    setfontname::String
    fontfacename::String
end

mathbook = FontSpec("NewComputerModern Math", "NewCMMath-Book")
italic10 = FontSpec("NewComputerModern10-Italic", "NewCM10-Italic")
bold10   = FontSpec("NewComputerModern10-Bold", "NewCM10-Bold")
italic12 = FontSpec("NewComputerModern10-BoldItalic", "NewCM10-BoldItalic")
regular  = FontSpec("NewComputerModern10-Regular", "NewCM10-Regular")
mathreg  = FontSpec("NewComputerModern Math", "NewCMMath-Regular")

"""
    _findlatexfont(t::FTFont)

Given the FreeTypeAbstraction.FTFont in `ftf`, return a suitable FontSpec.
"""
function _findlatexfont(ftf::FTFont)
    if ftf.style_name == "Regular" && ftf.family_name == "NewComputerModern Math"
        f = mathbook
    elseif ftf.style_name == "10 Italic" && ftf.family_name == "NewComputerModern"
        f = italic10
    elseif ftf.style_name == "12 Italic" && ftf.family_name == "NewComputerModern"
        f = italic12
    elseif ftf.style_name == "Bold"
        f = bold10
    elseif ftf.style_name == "BoldItalic"
        f = italic12
    else
        f = regular
    end
    return f
end

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
    _writelatexchar(texchar, font_size)

Draw the texchar as text.
"""
function _write_tex_element(texelement, font_size)
    texchar = first(texelement)
    fontspec = _findlatexfont(texchar.font)
    ch = texchar.represented_char
    fscale = last(texelement)
    spt = Point(texelement[2]...)
    fontface(fontspec.setfontname)
    fontsize(font_size * fscale)
    if ch == '{' || ch == '}'
        Luxor.text(string(ch), spt * font_size * (1, -1) + Point(0, -0.8) * font_size)
    else
        Luxor.text(string(ch), spt * font_size * (1, -1))
    end
end

"""
    _writelatexcharaspath(texchar, font_size)

Add the texchar to the current path.
"""
function _write_tex_as_path(texelement, font_size)
    texchar = first(texelement)
    fontspec = _findlatexfont(texchar.font)
    ch = texchar.represented_char
    fscale = last(texelement)
    spt = Point(texelement[2]...)
    fontface(fontspec.setfontname)
    fontsize(font_size * fscale)
    newsubpath()
    move(spt * font_size * (1, -1))
    Luxor.textoutlines(string(ch),
        spt * font_size * (1, -1),
        action = :path,
        startnewpath = false)
end

"""
    text(lstr::LaTeXString, pt::Point;
        valign=:baseline,
        halign=:left,
        rotationfixed = false,
        angle=0,
        paths=false,
        kwargs...)

Another method for `text` that draws the LaTeX `lstr`,
using `MathTexEngine.jl`. Uses
ModernCMU as font family. When `rotationfixed = true`,
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
    text(L"e^{i\\pi} + 1 = 0", halign = :center)
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
    # with MathTexEngine.generate_tex_elements
    sentence = Luxor.generate_tex_elements(lstr)
    # get current font size
    font_size = get_fontsize()
    textw, texth = Luxor.latextextsize(lstr)
    bottom_pt, top_pt = rawlatexboundingbox(lstr)
    translate_x, translate_y = Luxor.texalign(halign, valign, bottom_pt, top_pt, font_size)
    for texelement in sentence
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
            if first(texelement) isa TeXChar
                if paths == true
                    _write_tex_as_path(texelement, font_size)
                else
                    _write_tex_element(texelement, font_size)
                end
            elseif first(texelement) isa HLine
                hline = texelement[1]
                spt = Point(texelement[2]...)
                fscale = texelement[3]
                fontsize(font_size * fscale)
                linestart = spt * font_size * (1, -1)
                lineend = linestart + (hline.width * font_size, hline.thickness * font_size)
                if paths == true
                    box(linestart, lineend, :path)
                    newsubpath()
                else
                    box(linestart, lineend, :fill)
                end
            elseif first(texelement) isa VLine
                # todo
            end
        end
    end
end

text(lstr::LaTeXString; kwargs...) = text(lstr, O; kwargs...)
