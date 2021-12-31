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
    latexboundingbox(lstr::LaTeXString, font_size=1)
Returns the bounding box containing the latex text with
`(Lower Left Point, Upper Right Point)`.
Use `box(latex_bb(testext)...,:stroke)` to draw the bounding box.
"""
function latexboundingbox(lstr::LaTeXString, font_size=1)
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
    return (bottom_pt * font_size, top_pt * font_size)
end

"""
    Luxor.text(lstr::LaTeXString, valign=:baseline, halign=:left; kwargs...)
Draws LaTeX string using `MathTexEngine.jl`. Hence, uses ModernCMU as font family.
Note that `valign` is not perfect.
This function assumes that the axis are in the standard Luxor directions,
i.e. ↓→.
"""
function text(
    lstr::LaTeXString, pt::Point; valign=:baseline, halign=:left, angle=0::Real, kwargs...
)

    # Function from MathTexEngine
    sentence = generate_tex_elements(lstr)

    # Get current font size.
    font_size = get_fontsize()

    textw, texth = latextextsize(lstr)

    if halign === :left
        translate_x = 0
    elseif halign === :right
        translate_x = -textw
    elseif halign === :center
        translate_x = -textw / 2
    end

    if valign === :baseline
        translate_y = 0
    elseif valign === :bottom
        translate_y = -font_size
    elseif valign === :top
        translate_y = texth
    elseif valign === :middle
        translate_y = font_size / 2
    end

    # Writes text using ModernCMU font.
    for text in sentence
        if text[1] isa TeXChar
            @layer begin
                translate(translate_x, translate_y)
                translate(pt)
                translate(
                    (1 - cos(-angle)) * textw / 2 * font_size,
                    font_size * textw / 2 * sin(-angle),
                )
                rotate(angle)
                fontface(text[1].font.family_name)
                fontsize(font_size * text[3])
                Luxor.text(string(text[1].char), Point(text[2]...) * font_size * (1, -1))
            end
        elseif text[1] isa HLine
            @layer begin
                translate(translate_x, translate_y)
                translate(pt)
                translate(
                    (1 - cos(-angle)) * textw / 2 * font_size,
                    font_size * textw / 2 * sin(-angle),
                )
                rotate(angle)
                pointstart = Point(text[2]...) * font_size * (1, -1)
                pointend = pointstart + Point(text[1].width, 0) * font_size
                setline(0.5)
                line(pointstart, pointend, :stroke)
            end
        end
    end
end
