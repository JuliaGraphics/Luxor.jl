# text

# first, the 'toy' API... "Any serious application should avoid them." :)

"""
    text(str)
    text(str, pos)
    text(str, x, y)
    text(str, pos, halign=:left)
    text(str, valign=:baseline)
    text(str, valign=:baseline, halign=:left)
    text(str, pos, valign=:baseline, halign=:left)

Draw the text in the string `str` at `x`/`y` or `pt`, placing the start of
the string at the point. If you omit the point, it's placed at the current `0/0`. In Luxor,
placing text doesn't affect the current point.

Horizontal alignment `halign` can be `:left`, `:center`, (also `:centre`) or `:right`.
Vertical alignment `valign` can be `:baseline`, `:top`, `:middle`, or `:bottom`.

The default alignment is `:left`, `:baseline`.
"""
function text(t, pt::Point; halign=:left, valign=:baseline)
    #= text can aligned by one of the following points
        top/left       top/center       top/right
        middle/left    middle/center    middle/right
        baseline/left  baseline/center  baseline/right
        bottom/left    bottom/center    bottom/right

    # left center right x coords are
    # [:xbearing, :width-:xbearing/2, :width]
    # top middle baseline bottom y coords are
    # [:ybearing, :ybearing/2, 0, :height + :ybearing]
    =#

    xbearing, ybearing, textwidth, textheight, xadvance, yadvance = textextents(t)
    halignment = findfirst([:left, :center, :right, :centre], halign)

    # if unspecified or wrong, default to left, also treat UK spelling centre as center
    if halignment == 0
        halignment = 1
    elseif halignment == 4
        halignment = 2
    end

    textpointx = pt.x - [xbearing, (textwidth-xbearing)/2, textwidth][halignment]
    valignment = findfirst([:top, :middle, :baseline, :bottom], valign)

    # if unspecified or wrong, default to baseline
    if valignment == 0
        valignment = 3
    end

    textpointy = pt.y - [ybearing, ybearing/2, 0, textheight + ybearing][valignment]

    gsave()
    Cairo.move_to(currentdrawing.cr, textpointx, textpointy)
    Cairo.show_text(currentdrawing.cr, t)
    grestore()
end

text(t; kwargs...) = text(t, O; kwargs...)
text(t, xpos, ypos; kwargs...) = text(t, Point(xpos, ypos); kwargs...)

"""
    textcentered(str)
    textcentered(str, x, y)
    textcentered(str, pt)

Draw text in the string `str` centered at `x`/`y` or `pt`. If you omit the point, it's
placed at 0/0.

Text doesn't affect the current point!

textcentred (UK spelling) is a synonym.
"""
textcentered(t, x=0, y=0) = text(t, x, y, halign=:center)
textcentered(t, pt::Point) = textcentered(t, pt.x, pt.y)
textcentred = textcentered

"""
    textright(str)
    textright(str, x, y)
    textright(str, pt)

Draw text in the string `str` right-aligned at `x`/`y` or `pt`.
If you omit the point, it's placed at 0/0.

Text doesn't affect the current point!
"""
textright(t, x=0, y=0) = text(t, x, y, halign=:right)
textright(t, pt::Point) = textright(t, pt.x, pt.y)

"""
    fontface(fontname)

Select a font to use. (Toy API)
"""
fontface(f) =
    Cairo.select_font_face(currentdrawing.cr, f,
                           Cairo.FONT_SLANT_NORMAL,
                           Cairo.FONT_WEIGHT_NORMAL)

"""
    fontsize(n)

Set the font size to `n` points. The default size is 10 points. (Toy API)
"""
fontsize(n) = Cairo.set_font_size(currentdrawing.cr, n)

"""
    textextents(str)

Return an array of six Float64s containing the measurements of the string `str` when set
using the current font settings (Toy API):

1 x_bearing

2 y_bearing

3 width

4 height

5 x_advance

6 y_advance

The x and y bearings are the displacement from the reference point to the upper-left corner
of the bounding box. It is often zero or a small positive value for x displacement, but can
be negative x for characters like "j"; it's almost always a negative value for y displacement.

The width and height then describe the size of the bounding box. The advance takes you to
the suggested reference point for the next letter. Note that bounding boxes for subsequent
blocks of text can overlap if the bearing is negative, or the advance is smaller than the
width would suggest.

Example:

    textextents("R")

returns

    [1.18652; -9.68335; 8.04199; 9.68335; 9.74927; 0.0]
"""
textextents(str) = Cairo.text_extents(currentdrawing.cr, str)

"""
    textpath(t)

Convert the text in string `t` to a new path, for subsequent filling/stroking etc...
"""
function textpath(t)
    Cairo.text_path(currentdrawing.cr, t)
end

"""
Place a string of text on a curve. It can spiral in or out.

```
textcurve(the_text, start_angle, start_radius, x_pos = 0, y_pos = 0;
          # optional keyword arguments:
          spiral_ring_step = 0,    # step out or in by this amount
          letter_spacing = 0,      # tracking/space between chars, tighter is (-), looser is (+)
          spiral_in_out_shift = 0, # + values go outwards, - values spiral inwards
          clockwise = true
          )
```

`start_angle` is relative to +ve x-axis, arc/circle is centered on `(x_pos,y_pos)` with
radius `start_radius`.
"""
function textcurve(the_text, start_angle, start_radius, x_pos=0, y_pos=0;
    spiral_ring_step = 0,
    letter_spacing = 0,
    spiral_in_out_shift = 0,
    clockwise = true
    )
    refangle = start_angle
    current_radius = start_radius
    spiral_space_step = 0
    xx = 0
    yy = 0
    angle_step = 0
    radius_step = 0
    for i in the_text
        glyph = string(i)
        glyph_x_bearing, glyph_y_bearing, glyph_width,
        glyph_height, glyph_x_advance, glyph_y_advance = textextents(glyph)
        spiral_space_step = glyph_x_advance + letter_spacing
        cnter = (2pi * current_radius) / spiral_space_step
        radius_step = (spiral_ring_step + spiral_in_out_shift) / cnter
        current_radius += radius_step
        angle_step += (glyph_x_advance / 2.0) + letter_spacing/2.0
        if clockwise
            refangle += angle_step / current_radius
        else
            refangle -= angle_step / current_radius
        end
        angle_step = (glyph_x_advance / 2.0) + letter_spacing/2.0
        xx = cos(refangle) * current_radius + x_pos
        yy = sin(refangle) * current_radius + y_pos
        gsave()
        translate(xx, yy)
        if clockwise
            rotate(pi/2 + refangle)
        else
            rotate(-pi/2 + refangle)
        end
        textcentered(glyph, 0, 0)
        grestore()
        current_radius < 10 && break
    end
end

textcurve(the_text, start_angle, start_radius, center::Point; kwargs...) =
    textcurve(the_text, start_angle, start_radius, center.x, center.y; kwargs...)

"""
    textcurvecentered(the_text, the_angle, the_radius, center::Point;
          clockwise = true,
          letter_spacing = 0,
          baselineshift = 0

This version of the `textcurve()` function is designed for shorter text strings that need
positioning around a circle. (A cheesy effect much beloved of hipster brands and
retronauts.)

`letter_spacing` adjusts the tracking/space between chars, tighter is (-), looser is (+)).
`baselineshift` moves the text up or down away from the baseline.

textcurvecentred (UK spelling) is a synonym
"""
function textcurvecentered(the_text, the_angle, the_radius, center::Point;
                           clockwise = true,
                           letter_spacing = 0,
                           baselineshift = 0
      )
    atextbox = textextents(the_text)
    atextwidth = atextbox[3]                         # width of text
    if clockwise
        baselineradius = the_radius + baselineshift  # could be adjusted if we knew font height
    else
        baselineradius = the_radius - baselineshift  # could be adjusted if we knew font height
    end

    # hack to adjust starting angle for the letter spacing
    # to do it accurately would take lots more code and brain cells
    lspaced = length(the_text) * letter_spacing
    lspacedangle = atan2(lspaced, baselineradius)

    theta = atextwidth/baselineradius               # find angle
    if clockwise
        starttextangle = the_angle - (theta/2) - lspacedangle/2
    else
        starttextangle = the_angle + (theta/2) + lspacedangle/2
    end
    starttextxpos = baselineradius * cos(starttextangle)
    starttextypos = baselineradius * sin(starttextangle)
    textcurve(the_text, starttextangle, baselineradius, center,
              clockwise=clockwise, letter_spacing=letter_spacing)
end

textcurvecentred = textcurvecentered

# the professional interface

"""
    setfont(family, fontsize)

Select a font and specify the size in points.

Example:

    setfont("Helvetica", 24)
    settext("Hello in Helvetica 24 using the Pro API", Point(0, 10))
"""
function setfont(family::AbstractString, fontsize)
    # why is the size of the output set relative to 96dpi???
    fsize = fontsize * 72/96
    set_font_face(currentdrawing.cr, string(family, " ", fsize))
end

"""
    settext(text, pos;
        halign = "left",
        valign = "bottom",
        angle  = 0,
        markup = false)

    settext(text;
        kwargs)

Draw the `text` at `pos` (if omitted defaults to `0/0`). If no font is specified, on macOS
the default font is Times Roman.

To align the text, use `halign`, one of "left", "center", or "right", and `valign`, one of
"top", "center", or "bottom".

`angle` is the rotation - in counterclockwise degrees.

If `markup` is `true`, then the string can contain some HTML-style markup. Supported tags
include:

    <b>, <i>, <s>, <sub>, <sup>, <small>, <big>, <u>, <tt>, and <span>

The `<span>` tag can contains things like this:

    <span font='26' background='green' foreground='red'>unreadable text</span>
"""
settext(text::AbstractString, pos::Point; kwargs...) =
    Cairo.text(currentdrawing.cr, pos.x, pos.y, text; kwargs...)

settext(text; kwargs...) = settext(text, O; kwargs...)

"""
    label(txt::String, alignment::Symbol=:N, pos::Point=O; offset=5)

Add a text label at a point, positioned relative to that point, for example, `:N` signifies
North and places the text directly above that point.

Use one of `:N`, `:S`, `:E`, `:W`, `:NE`, `:SE`, `:SW`, `:NW` to position the label
relative to that point.

    label("text")          # positions text at North (above), relative to the origin
    label("text", :S)      # positions text at South (below), relative to the origin
    label("text", :S, pt)  # positions text South of pt
    label("text", :N, pt, offset=20)  # positions text North of pt, offset by 20

The default offset is 5 units.
"""
function label(txt::String, alignment::Symbol=:N, pos::Point=O; offset=5)
    # alignment one of :N, :S, :E, ;W, ;NE; :SE, :SW, :NW
    if in(alignment, [:N, :n])
        text(txt, Point(pos.x, pos.y - offset), halign = :center, valign = :bottom)
    elseif in(alignment, [:E, :e])
        text(txt, Point(pos.x + offset, pos.y), halign = :left, valign = :middle)
    elseif in(alignment, [:S, :s])
        text(txt, Point(pos.x, pos.y + offset), halign = :center, valign = :top)
    elseif in(alignment, [:W, :w])
        text(txt, Point(pos.x - offset, pos.y), halign = :right, valign = :middle)
    elseif in(alignment, [:NE, :ne])
        text(txt, Point(pos.x + (offset * cos(pi/4)), pos.y - (offset * sin(pi/4))), halign = :left, valign = :bottom)
    elseif in(alignment, [:SE, :se])
        text(txt, Point(pos.x + (offset * cos(pi/4)), pos.y + (offset * sin(pi/4))), halign = :left, valign = :top)
    elseif in(alignment, [:SW, :sw])
        text(txt, Point(pos.x - (offset * cos(pi/4)), pos.y + (offset * sin(pi/4))), halign = :right, valign = :top)
    elseif in(alignment, [:NW, :nw])
        text(txt, Point(pos.x - (offset * cos(pi/4)), pos.y - (offset * sin(pi/4))), halign = :right, valign = :bottom)
    end
end

"""
    splittext(s)

Split the text in string `s` into an array, but keep all the separators
attached to the preceding word.
"""
function splittext(s::String)
    # split text into array, keeping all separators
    # hyphens stay with first word
    result = Array{String, 1}()
    iobuffer = IOBuffer()
    for c in s
        if in(c, ['-', ' '])
            print(iobuffer, c)
            push!(result, String(take!(iobuffer)))
            iobuffer = IOBuffer()
        elseif in(c, ['\n', '\r', '\t'])
            # forget newlines etc.
        else
            print(iobuffer, c)
        end
    end
    push!(result, String(take!(iobuffer)))
    return result
end

"""
    textlines(s::String, width::Real;
         rightgutter=5)

Split text into lines up to `width` units wide (in the current font).

Return an array of strings. Use `textwrap` to draw an array of strings.

TODO: A `rightgutter` optional keyword adds some padding to the right hand side of the
column. This appears to be needed sometimes -— perhaps the algorithm needs improving to take
account  of the interaction of `textextents` and spaces?
"""
function textlines(s::String, width::Real; rightgutter=5)
    result = String[]
    for line in split(s, "\n")
        fields = splittext(line)
        if length(fields) % 2 == 1
            push!(fields, "")
        end
        x = ""
        for i in 1:2:length(fields)
            # lookahead
            wsofar =  textextents(x * fields[i])
            wtocome = textextents(fields[i+1])
            # does it fit?
            if (wsofar[3] + wsofar[6]) > width - rightgutter - (wtocome[3] - wtocome[6])
                if x == ""
                    push!(result, fields[i])
                    x = ""
                    continue
                else
                    push!(result, x)
                    x = ""
                end
            end
            x = x * fields[i] * fields[i + 1]
        end
        if x != ""
            push!(result, x)
        end
    end
    # strip remaining spaces
    for i in 1:length(result)
        result[i] = strip(result[i])
    end
    return result
end

"""
    textwrap(s::String, width::Real, pos::Point=O)

Draw the string in `s` by splitting it into lines, so that each line is no longer than
`width` units. The text starts at `pos` such that the first line of text is drawn entirely
below a line drawn  horizontally through that position. Each line is aligned on the left
side, below `pos`.

"""
function textwrap(s::String, width::Real, pos::Point=O; rightgutter=5)
    lines = textlines(s, width; rightgutter=rightgutter)
    # pos is top left corner, not baseline, so move first line down
    height = textextents(lines[1])[4] - textextents(lines[1])[2]
    cpos = Point(pos.x, pos.y + height)
    for l in lines
        height = textextents(l)[4] - textextents(l)[2]
        text(l, cpos)
        cpos = Point(cpos.x, cpos.y + height)
    end
end
