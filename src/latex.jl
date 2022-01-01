"""
    texalign(halign, valign, textw, texth, font_size)
Helper function to align LaTeX text properly. Returns
`translate_x` and `translate_y` which consists of the amount
to be shifted depending on the type of alignment chosen
and the dimensions of the text.
"""
function texalign(halign, valign, textw::Real, texth::Real, font_size)
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
        translate_y = -texth * font_size
    elseif valign === :top
        translate_y = texth * font_size
    elseif valign === :middle
        translate_y = texth * font_size / 2
    end
    return translate_x, translate_y
end

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
        translate_y = -top_pt[2]* font_size
    elseif valign === :middle
        translate_y = (bottom_pt[2]-top_pt[2])* font_size / 2
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
    latexboundingbox(lstr::LaTeXString, font_size=1)
Returns the bounding box containing the latex text with
`(Lower Left Point, Upper Right Point)`.
Use `box(latex_bb(testext)...,:stroke)` to draw the bounding box.
"""
function latexboundingbox(lstr::LaTeXString, font_size=1; halign=:left, valign=:right)
    bottom_pt, top_pt = rawlatexboundingbox(lstr)
    textw = top_pt[1] - bottom_pt[1]
    texth = -(top_pt[2] - bottom_pt[2])

    translate_x, translate_y = texalign(halign, valign, textw, texth, font_size)
    translate_pt = Point(translate_x,translate_y)

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
    text(lstr::LaTeXString, pt::Point; valign=:baseline, halign=:left, rotationfixed = false, angle=0, kwargs...)
Draws LaTeX string using `MathTexEngine.jl`. Hence, uses ModernCMU as font family.
When `rotationfixed = true`, the text will rotate around it's own axis, instead of rotating around `pt`.
"""
function text(
    lstr::LaTeXString, pt::Point; valign=:baseline, halign=:left, angle=0::Real, rotationfixed=false, kwargs...
)

    # Function from MathTexEngine
    sentence = generate_tex_elements(lstr)

    # Get current font size.
    font_size = get_fontsize()

    textw, texth = latextextsize(lstr)
    bottom_pt, top_pt = rawlatexboundingbox(lstr)

    translate_x, translate_y = texalign(halign, valign, bottom_pt, top_pt, font_size)
    # translate_x, translate_y = texalign(halign, valign, textw, texth, font_size)

    # Writes text using ModernCMU font.
    for text in sentence
            @layer begin
                if !rotationfixed
                    rotate(angle)
                end
                translate(translate_x, translate_y)
                translate(pt)
                if rotationfixed
                    translate(
                        (1 - cos(-angle)) * textw / 2 * font_size,
                        font_size * textw / 2 * sin(-angle),
                    )
                    rotate(angle)
                end
            if text[1] isa TeXChar
                fontface(text[1].font.family_name)
                fontsize(font_size * text[3])
                Luxor.text(string(text[1].char), Point(text[2]...) * font_size * (1, -1))

            elseif text[1] isa HLine
                pointstart = Point(text[2]...) * font_size * (1, -1)
                pointend = pointstart + Point(text[1].width, 0) * font_size
                setline(0.5)
                line(pointstart, pointend, :stroke)
            end
        end
    end
end
