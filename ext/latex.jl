import MathTeXEngine
# We don't add new methods to functions from MathTeXEngine. Hence, we 'use' these:
using MathTeXEngine:
    generate_tex_elements, inkwidth, inkheight, bottominkbound, TeXChar, HLine
using LaTeXStrings
import Luxor
import Luxor: text, latextextsize, latexboundingbox, rawlatexboundingbox
using Luxor: Point, @layer, translate, rotate, move,
    fontface, fontsize, get_fontsize, setfont,
    setline, line, poly, closepath, newsubpath, BoundingBox, newpath, 
    currentpoint, pathtopoly, boxbottomleft, boxwidth, boxheight

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
function latexboundingbox(lstr::LaTeXString, font_size=get_fontsize();
        halign=:left, valign=:right)

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
    text(lstr::LaTeXString, pt::Point;
        valign=:baseline,
        halign=:left,
        rotationfixed = false,
        angle=0,
        paths=false,
        kwargs...)

Draws LaTeX string using `MathTexEngine.jl`. Hence, uses
ModernCMU as font family. When `rotationfixed = true`,
the text will rotate around its own axis, instead of
rotating around `pt`.

If `paths` is true, text paths are added to the current
path, rather than drawn.

```
using Luxor
using MathTeXEngine
using LaTeXStrings
@draw begin
    fontsize(70)
    text(L"e^{i\\pi} + 1 = 0", halign=:center)
end
```
"""
function text(lstr::LaTeXString, pt::Point;
        valign=:baseline,
        halign=:left,
        angle=0::Real,
        rotationfixed=false,
        paths=false,
        kwargs...)

    # Function from MathTexEngine
    sentence = generate_tex_elements(lstr)

    # Get current font size.
    font_size = get_fontsize()

    textw, texth = latextextsize(lstr)
    bottom_pt, top_pt = rawlatexboundingbox(lstr)

    translate_x, translate_y = texalign(halign, valign, bottom_pt, top_pt, font_size)

    # Writes text using ModernCMU font.
    for text in sentence
        @layer begin
            translate(pt)
            if !rotationfixed
                rotate(angle)
                translate(translate_x, translate_y)
            else
                l_pt, r_pt = latexboundingbox(lstr, halign = halign, valign = valign)
                translate((l_pt + r_pt)/2)
                rotate(angle)
                translate(Point(translate_x,translate_y)-(l_pt + r_pt)/2)
            end

            if text[1] isa TeXChar

                if paths == true
                    fontface(text[1].font.family_name)
                    fontsize(font_size * text[3])
                    newsubpath()
                    move(Point(text[2]...) * font_size * (1, -1))
                    Luxor.textoutlines(string(text[1].represented_char),
                        Point(text[2]...) * font_size * (1, -1),
                        action=:path,
                        startnewpath=false)
                else
                    writelatexchar(text, font_size)
                end
            elseif text[1] isa HLine
                # text is eg (HLine{Float64}(0.7105, 0.009), [0.0, 0.2106], 1.0))
                #                            width   thick    x     y      scale
                if paths == true
                    pointstart = Point(text[2]...) * font_size * (1, -1)
                    pointend = pointstart + Point(text[1].width, 0) * font_size
                    poly([pointstart, pointend], :path)
                    closepath()
                    newsubpath()
                else
                    pointstart = Point(text[2]...) * font_size * (1, -1)
                    pointend = pointstart + Point(text[1].width, 0) * font_size
                    setline(0.5)
                    line(pointstart, pointend, :stroke)
                end
            end
        end
    end
end


"""
    writelatexchar(t::AbstractString)

Helper function to handle extra chars that are not supported
in MathTeXEngine.
"""
function writelatexchar(text, font_size)
    # Extra chars not supported by MathTeXEngine
    extrachars = ["⨟","{","}","𝔸","𝔹","ℂ","𝔻","𝔽", "𝔾", "ℍ", "𝕀", "𝕁", "𝕂", "𝕃", "𝕄", "ℕ", "𝕆", "ℙ", "ℚ", "ℝ", "𝕊", "𝕋", "𝕌", "𝕎", "𝕍", "𝕏", "ℤ", "𝔄", "𝔅", "ℭ", "𝔇", "𝔈", "𝔉", "𝔊", "ℌ", "ℑ", "𝔍", "𝔎", "𝔏", "𝔐", "𝔑", "𝔒", "𝔓", "𝔔", "ℜ", "𝔖", "𝔗", "𝔘", "𝔙", "𝔚", "𝔛", "𝔜", "ℨ", "𝕬", "𝕭", "𝕮", "𝕯", "𝕰", "𝕱", "𝕲", "𝕳", "𝕴", "𝕵", "𝕶", "𝕷", "𝕸", "𝕹", "𝕺", "𝕻", "𝕼", "𝕽", "𝕾", "𝕿", "𝖀", "𝖁", "𝖂", "𝖃", "𝖄", "𝖅", "𝒜", "ℬ", "𝒞", "𝒟", "ℰ", "ℱ", "𝒢", "ℋ", "ℐ", "𝒥", "𝒦", "ℒ", "ℳ", "𝒩", "𝒪", "𝒫", "𝒬", "ℛ", "𝒮", "𝒯", "𝒰", "𝒱", "𝒲", "𝒳", "𝒴", "𝒵","𝕒","𝕓" ,"𝕔" ,"𝕕" ,"𝕖" ,"𝕗","𝕘" ,"𝕙" ,"𝕚" ,"𝕛" ,"𝕜" ,"𝕝" ,"𝕞" ,"𝕟" ,"𝕠" ,"𝕡" ,"𝕢" ,"𝕣" ,"𝕤" ,"𝕥" ,"𝕦" ,"𝕧" ,"𝕩" ,"𝕨" ,"𝕪" ,"𝕫" ,"𝐚" ,"𝐛" ,"𝐜" ,"𝐝" ,"𝐞" ,"𝐟" ,"𝐠" ,"𝐡" ,"𝐢" ,"𝐣" ,"𝐤" ,"𝐥" ,"𝐦" ,"𝐧" ,"𝐨" ,"𝐩" ,"𝐪" ,"𝐫" ,"𝐬" ,"𝐭" ,"𝐮" ,"𝐯" ,"𝐱" ,"𝐰" ,"𝐲" ,"𝐳" ,"𝐀" ,"𝐁" ,"𝐂" ,"𝐃" ,"𝐄" ,"𝐅" ,"𝐆" ,"𝐇" ,"𝐈" ,"𝐉" ,"𝐊" ,"𝐋" ,"𝐌" ,"𝐍" ,"𝐎" ,"𝐏" ,"𝐐" ,"𝐑" ,"𝐒" ,"𝐓" ,"𝐔" ,"𝐕" ,"𝐗" ,"𝐖" ,"𝐘" ,"𝐙" ,"𝓐" ,"𝓑" ,"𝓒" ,"𝓓" ,"𝓔" ,"𝓕" ,"𝓖" ,"𝓗" ,"𝓘" ,"𝓙" ,"𝓚" ,"𝓛" ,"𝓜" ,"𝓝" ,"𝓞" ,"𝓟" ,"𝓠" ,"𝓡" ,"𝓢" ,"𝓣" ,"𝓤" ,"𝓥" ,"𝓧" ,"𝓦" ,"𝓨" ,"𝓩"]

    fontface(text[1].font.family_name)
    fontsize(font_size * text[3])

    if string(text[1].represented_char) == "⨟"
        setfont(text[1].font.family_name, font_size * text[3])
        Luxor.settext(string(text[1].represented_char), Point(text[2]...) * font_size * (1, -1)+Point(0.25,0.3)*font_size)

    elseif text[1].represented_char == '{' || text[1].represented_char == '}'
        Luxor.text(string(text[1].represented_char), Point(text[2]...) * font_size * (1, -1)+Point(0,-0.8)*font_size)

    elseif string(text[1].represented_char) in extrachars
        setfont(text[1].font.family_name, 1.3font_size * text[3])
        Luxor.settext(string(text[1].represented_char), Point(text[2]...) * font_size * (1, -1)+Point(0,0.3)*font_size)

    else
        Luxor.text(string(text[1].represented_char), Point(text[2]...) * font_size * (1, -1))
    end
end

# versions of _textformat that accept LaTeXString

function Luxor._textformat(str::LaTeXString, pos::Point, defaultparams)
    text(str, Point(pos.x, pos.y + -defaultparams.baseline))
    pos = Luxor.currentpoint()
    if isapprox(defaultparams.advance, 1.0)
        space = Luxor.textextents(" ")
        pos = Point(pos.x + space[5], pos.y)
    else
        space = [0, 0, 0, 0, defaultparams.advance, 0]
        pos = Point(pos.x + space[5], pos.y)
    end
    return pos
end 

function Luxor._textformat_tuple(str::LaTeXString, pos::Point, tempparams, defaultparams)
    # if there's a prolog function defined, do it now
    if tempparams.prolog isa Function
        # how do we calculate the box extents of a LaTeX string?
        # get all the paths and find their bounding box, that's how
        # TODO one day we can do better than this
        Luxor.newpath()
        text(str, Point(pos.x, pos.y + -tempparams.baseline), paths=true)
        paths = Luxor.pathtopoly()
        bbx = BoundingBox(first(paths))
        Luxor.newpath()
        for path in paths
            bbx += BoundingBox(path)
        end
        # fabricate some faux textextents from this box
        tx = [0, -tempparams.baseline, boxwidth(bbx), boxheight(bbx), boxwidth(bbx), boxheight(bbx)]
        tempparams.prolog(pos + (boxbottomleft(bbx).x, boxbottomleft(bbx).y), tx)
    end
    text(str, Point(pos.x, pos.y + -tempparams.baseline))
    pos = Luxor.currentpoint()
    if isapprox(tempparams.advance, 1.0)
        space = Luxor.textextents(" ")
        pos = Point(pos.x + space[5], pos.y)
    else
        space = [0, 0, 0, 0, tempparams.advance, 0]
        pos = Point(pos.x + space[5], pos.y)
    end
    return pos
end
