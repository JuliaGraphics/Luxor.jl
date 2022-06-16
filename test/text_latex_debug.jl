# copy of function that outputs information
function _text_latex_debug(lstr::LaTeXString, pt::Point;
        valign=:baseline,
        halign=:left,
        angle=0::Real,
        rotationfixed=false,
        paths=false,
        kwargs...)

    # Function from MathTexEngine
    sentence = generate_tex_elements(lstr)

    @info "sentence: ", sentence

    # Get current font size.
    font_size = get_fontsize()
    @info "font size: ", font_size

    textw, texth = latextextsize(lstr)
    bottom_pt, top_pt = rawlatexboundingbox(lstr)
    @info "bottom and top:" , bottom_pt, top_pt

    translate_x, translate_y = Luxor.texalign(halign, valign, bottom_pt, top_pt, font_size)
    @info translate_x, translate_y

    # Writes text using ModernCMU font.
    for text in sentence
        @info "  writing: ", text
        @layer begin
            translate(pt)
            if !rotationfixed
                @info "  rotating: ", angle
                rotate(angle)
                translate(translate_x, translate_y)
            else
                l_pt, r_pt = latexboundingbox(lstr, halign = halign, valign = valign)
                translate((l_pt + r_pt)/2)
                rotate(angle)
                @info "  rotating fixed: ", angle
                translate(Point(translate_x,translate_y)-(l_pt + r_pt)/2)
            end

            if text[1] isa TeXChar
                @info "  text char: ", text[1]
                @info "  font family: ", text[1].font.family_name
                @info "  font size: ", font_size * text[3]
                if paths == true
                    @info "  paths: ", paths
                    fontface(text[1].font.family_name)
                    fontsize(font_size * text[3])
                    newsubpath()
                    move(Point(text[2]...) * font_size * (1, -1))
                    Luxor.textoutlines(string(text[1].char),
                        Point(text[2]...) * font_size * (1, -1),
                        action=:path,
                        startnewpath=false)
                else
                    Luxor.writelatexchar(text, font_size)
                    @info "  writelatexchar(): ", text, font_size
                end
            elseif text[1] isa HLine
                @info "  draw: HLine"
                # text is eg (HLine{Float64}(0.7105, 0.009), [0.0, 0.2106], 1.0))
                #                            width   thick    x     y      scale
                if paths == true
                    @info "  drawing paths", paths
                    pointstart = Point(text[2]...) * font_size * (1, -1)
                    pointend = pointstart + Point(text[1].width, 0) * font_size
                    poly([pointstart, pointend], :path)
                    closepath()
                    newsubpath()
                else
                    @info "  drawing lines", paths
                    pointstart = Point(text[2]...) * font_size * (1, -1)
                    pointend = pointstart + Point(text[1].width, 0) * font_size
                    setline(0.5)
                    line(pointstart, pointend, :stroke)
                end
            end
        end
    end
end
