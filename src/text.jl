# text

# first, the 'toy' API... "Any serious application should avoid them." :)

"""
    text(str)
    text(str, pos)
    text(str, pos, angle=pi/2)
    text(str, x, y)
    text(str, pos, halign=:left)
    text(str, valign=:baseline)
    text(str, valign=:baseline, halign=:left)
    text(str, pos, valign=:baseline, halign=:left)

Draw the text in the string `str` at `x`/`y` or `pt`, placing the start of the
string at the point. If you omit the point, it's placed at the current `0/0`.

`angle` specifies the rotation of the text relative to the current x-axis.

Horizontal alignment `halign` can be `:left`, `:center`, (also `:centre`) or
`:right`.  Vertical alignment `valign` can be `:baseline`, `:top`, `:middle`, or
`:bottom`.

The default alignment is `:left`, `:baseline`.

This uses Cairo's Toy text API.
"""
function text(t, pt::Point;
        halign=:left,
        valign=:baseline,
        angle=0.0)
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
    halignment = findfirst(isequal(halign), [:left, :center, :right, :centre])

    # if unspecified or wrong, default to left, also treat UK spelling centre as center
    if halignment == nothing
        halignment = 1
    elseif halignment == 4
        halignment = 2
    end

    textpointx = pt.x - [0, textwidth/2, textwidth][halignment]

    valignment = findfirst(isequal(valign), [:top, :middle, :baseline, :bottom])

    # if unspecified or wrong, default to baseline
    if valignment == nothing
        valignment = 3
    end

    textpointy = pt.y - [ybearing, ybearing/2, 0, textheight + ybearing][valignment]

    # need to adjust for any rotation now
    # rotate finalpt around original point
    finalpt = Point(textpointx, textpointy)
    x1 = finalpt.x - pt.x
    y1 = finalpt.y - pt.y
    x2 = x1 * cos(angle) - y1 * sin(angle)
    y2 = x1 * sin(angle) + y1 * cos(angle)
    finalpt = Point(x2 + pt.x, y2 + pt.y)

    gsave()
        translate(finalpt)
        rotate(angle)
        newpath()
        Cairo.show_text(get_current_cr(), t)
    grestore()

    return Point(textpointx, textpointy)
end

text(t; kwargs...) = text(t, O; kwargs...)
text(t, xpos, ypos; kwargs...) = text(t, Point(xpos, ypos); kwargs...)

"""
    textcentered(str)
    textcentered(str, x, y)
    textcentered(str, pt)

Draw text in the string `str` centered at `x`/`y` or `pt`. If you omit the point, it's
placed at 0/0.

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

"""
textright(t, x=0, y=0) = text(t, x, y, halign=:right)
textright(t, pt::Point) = textright(t, pt.x, pt.y)

"""
    fontface(fontname)

Select a font to use. (Toy API)
"""
fontface(f) =
    Cairo.select_font_face(get_current_cr(), f,
                           Cairo.FONT_SLANT_NORMAL,
                           Cairo.FONT_WEIGHT_NORMAL)

"""
    fontsize(n)

Set the font size to `n` units. The default size is 10 units. (Toy API)
"""
fontsize(n) = Cairo.set_font_size(get_current_cr(), n)


"""
    get_fontsize()

Return the font size set by `fontsize` or. more precisely. the y-scale of the Cairo font matrix
if `Cairo.set_font_matrix` is used directly. (Toy API)

> This only works if Cairo is at least at v1.0.5.
"""
function get_fontsize()
    if @isdefined get_font_matrix
        m = get_font_matrix(get_current_cr())
        font_size = sign(m.yy)*sqrt(m.yx^2+m.yy^2)
        return font_size
    else
        throw(MethodError(get_fontsize, "Please use Cairo v1.0.5 or later to use this feature."))
    end
end

"""
    textextents(str)

Return an array of six Float64s containing the measurements of the string `str`
when set using the current font settings (Toy API):

1 x_bearing

2 y_bearing

3 width

4 height

5 x_advance

6 y_advance

The x and y bearings are the displacement from the reference point to the
upper-left corner of the bounding box. It is often zero or a small positive
value for x displacement, but can be negative x for characters like "j"; it's
almost always a negative value for y displacement.

The width and height then describe the size of the bounding box. The advance
takes you to the suggested reference point for the next letter. Note that
bounding boxes for subsequent blocks of text can overlap if the bearing is
negative, or the advance is smaller than the width would suggest.

Example:

    textextents("R")

returns

    [1.18652; -9.68335; 8.04199; 9.68335; 9.74927; 0.0]
"""
textextents(str) = Cairo.text_extents(get_current_cr(), str)

"""
    textpath(t)

Convert the text in string `t` and adds closed paths to the current path, for subsequent filling/stroking etc...

Typically you'll have to use `pathtopoly()` or `getpath()` or `getpathflat()` then
work through the one or more path(s). Or use `textoutlines()`.
"""
function textpath(t)
    Cairo.text_path(get_current_cr(), t)
end

"""
    textoutlines(s::AbstractString, pos::Point=O, action::Symbol=:none;
        halign=:left,
        valign=:baseline,
        startnewpath=true)

Convert text to a graphic path and apply `action`.

By default this function discards any current path, unless you use `startnewpath=false`

See also `textpath()`.
"""
function textoutlines(s::AbstractString, pos::Point=O, action::Symbol=:none;
    halign=:left,
    valign=:baseline,
    startnewpath=true)

    # TODO this duplicates text() too much; re-factor needed
    xbearing, ybearing, textwidth, textheight, xadvance, yadvance = textextents(s)
    halignment = findfirst(isequal(halign), [:left, :center, :right, :centre])
    if halignment == nothing
        halignment = 1
    elseif halignment == 4
        halignment = 2
    end
    textpointx = pos.x - [0, textwidth/2, textwidth][halignment]
    valignment = findfirst(isequal(valign), [:top, :middle, :baseline, :bottom])
    if valignment == nothing
        valignment = 3
    end
    textpointy = pos.y - [ybearing, ybearing/2, 0, textheight + ybearing][valignment]
    @layer begin
        translate(Point(textpointx, textpointy))
        if startnewpath
           newpath() # forget any current path, start a new one
        end
        te = textextents(s)
        textpath(s)
        tp = pathtopoly()
        if length(tp) == 1
            poly.(tp, :path, close=true) # don't clip yet
        else
            newpath()
            for path in tp
                poly(path, :path, close=true)
                newsubpath()
            end
            closepath()
        end
    end
    do_action(action)
end

"""
    textcurve(the_text, start_angle, start_radius, x_pos = 0, y_pos = 0;
          # optional keyword arguments:
          spiral_ring_step = 0,    # step out or in by this amount
          letter_spacing = 0,      # tracking/space between chars, tighter is (-), looser is (+)
          spiral_in_out_shift = 0, # + values go outwards, - values spiral inwards
          clockwise = true
          )

Place a string of text on a curve. It can spiral in or out.

`start_angle` is relative to +ve x-axis, arc/circle is centered on `(x_pos,y_pos)` with
radius `start_radius`.
"""
function textcurve(the_text, start_angle, start_radius, x_pos=0, y_pos=0;
    spiral_ring_step = 0,
    letter_spacing = 0,
    spiral_in_out_shift = 0,
    clockwise = true
    )
    # TODO this is all very hacky and out of date...
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
        textcentered(glyph, 0, 0) # TODO this is deprecated?
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

This version of the `textcurve()` function is designed for shorter text strings
that need positioning around a circle. (A cheesy effect much beloved of hipster
brands and retronauts.)

`letter_spacing` adjusts the tracking/space between chars, tighter is (-),
looser is (+)).  `baselineshift` moves the text up or down away from the
baseline.

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

    # TODO
    # hack to adjust starting angle for the letter spacing
    # to do it accurately would take lots more code and brain cells
    lspaced = length(the_text) * letter_spacing
    lspacedangle = atan(lspaced, baselineradius)

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

Select a font and specify the size.

Example:

    setfont("Helvetica", 24)
    settext("Hello in Helvetica 24 using the Pro API", Point(0, 10))
"""
function setfont(family::AbstractString, fontsize)
    # output is set relative to 96dpi
    # so it needs to be rescaled
    fsize = fontsize * 72/96
    set_font_face(get_current_cr(), string(family, " ", fsize))
end

"""
    settext(text, pos;
        halign = "left",
        valign = "bottom",
        angle  = 0, # degrees!
        markup = false)

    settext(text;
        kwargs)

Draw the `text` at `pos` (if omitted defaults to `0/0`). If no font is
specified, on macOS the default font is Times Roman.

To align the text, use `halign`, one of "left", "center", or "right", and
`valign`, one of "top", "center", or "bottom".

`angle` is the rotation - in counterclockwise degrees, rather than Luxor's
default clockwise (+x-axis to +y-axis) radians.

If `markup` is `true`, then the string can contain some HTML-style markup.
Supported tags include:

    <b>, <i>, <s>, <sub>, <sup>, <small>, <big>, <u>, <tt>, and <span>

The `<span>` tag can contains things like this:

    <span font='26' background='green' foreground='red'>unreadable text</span>
"""
settext(text::AbstractString, pos::Point; kwargs...) =
    Cairo.text(get_current_cr(), pos.x, pos.y, text; kwargs...)

settext(text; kwargs...) = settext(text, O; kwargs...)

"""
    label(txt::AbstractString, alignment::Symbol=:N, pos::Point=O;
        offset=5,
        leader=false)

Add a text label at a point, positioned relative to that point, for example, `:N` signifies
North and places the text directly above that point.

Use one of `:N`, `:S`, `:E`, `:W`, `:NE`, `:SE`, `:SW`, `:NW` to position the label
relative to that point.

    label("text")          # positions text at North (above), relative to the origin
    label("text", :S)      # positions text at South (below), relative to the origin
    label("text", :S, pt)  # positions text South of pt
    label("text", :N, pt, offset=20)  # positions text North of pt, offset by 20

The default offset is 5 units.

If `leader` is true, draw a line as well.

TODO: Negative offsets don't give good results.
"""
function label(txt::AbstractString, alignment::Symbol=:N, pos::Point=O;
        offset=5,
        leader=false,
        leaderoffsets=[0.0, 1.0])
    # alignment one of :N, :S, :E, ;W, ;NE; :SE, :SW, :NW
    if in(alignment, [:N, :n])
        pt = Point(pos.x, pos.y - offset)
        text(txt, pt, halign = :center, valign = :bottom)
    elseif in(alignment, [:E, :e])
        pt = Point(pos.x + offset, pos.y)
        text(txt, pt, halign = :left, valign = :middle)
    elseif in(alignment, [:S, :s])
        pt = Point(pos.x, pos.y + offset)
        text(txt, pt, halign = :center, valign = :top)
    elseif in(alignment, [:W, :w])
        pt = Point(pos.x - offset, pos.y)
        text(txt, pt, halign = :right, valign = :middle)
    elseif in(alignment, [:NE, :ne])
        pt = Point(pos.x + (offset * cos(pi/4)), pos.y - (offset * sin(pi/4)))
        text(txt, pt, halign = :left, valign = :bottom)
    elseif in(alignment, [:SE, :se])
        pt = Point(pos.x + (offset * cos(pi/4)), pos.y + (offset * sin(pi/4)))
        text(txt, pt, halign = :left, valign = :top)
    elseif in(alignment, [:SW, :sw])
        pt = Point(pos.x - (offset * cos(pi/4)), pos.y + (offset * sin(pi/4)))
        text(txt, pt, halign = :right, valign = :top)
    elseif in(alignment, [:NW, :nw])
        pt = Point(pos.x - (offset * cos(pi/4)), pos.y - (offset * sin(pi/4)))
        text(txt, pt, halign = :right, valign = :bottom)
    end
    if leader
        line(between(pos, pt, leaderoffsets[1]), between(pos, pt, leaderoffsets[2]), :stroke)
    end
end

"""
    label(txt::AbstractString, rotation::Float64, pos::Point=O;
        offset=5,
        leader=false,
        leaderoffsets=[0.0, 1.0])

Add a text label at a point, positioned relative to that point, for example,
`0.0` is East, `pi` is West.

    label("text", pi)          # positions text to the left of the origin
"""
function label(txt::AbstractString, rotation::Real, pos::Point=O;
        offset=5,
        leader=false,
        leaderoffsets=[0.0, 1.0])
    if 0 < rotation <= pi/4
        vertalign  = :middle
        horizalign = :left
    elseif pi/4 < rotation <= 3pi/4
        vertalign  = :top
        horizalign = :center
    elseif 3pi/4 < rotation <= 5pi/4
        vertalign  = :middle
        horizalign = :right
    elseif 5pi/4 < rotation <= 7pi/4
        vertalign  = :bottom
        horizalign = :center
    else
        vertalign  = :middle
        horizalign = :left
    end
    pt = pos + polar(offset, rotation)
    if leader
        line(between(pos, pt, leaderoffsets[1]), between(pos, pt, leaderoffsets[2]), :stroke)
    end
    text(txt, pt, halign = horizalign, valign=vertalign)
end

"""
    splittext(s)

Split the text in string `s` into an array, but keep all the separators
attached to the preceding word.
"""
function splittext(s)
    # split text into array, keeping all separators
    # hyphens stay with first word
    result = Array{String, 1}()
    iobuffer = IOBuffer()
    for c in s
        if isspace(c)
            push!(result, String(take!(iobuffer)))
            iobuffer = IOBuffer()
        elseif c == '-' # hyphen splits words but needs keeping
            print(iobuffer, c)
            push!(result, String(take!(iobuffer)))
            iobuffer = IOBuffer()
        else
            print(iobuffer, c)
        end
    end
    push!(result, String(take!(iobuffer)))
    return result
end

"""
    textlines(s::AbstractString, width::Real;
         rightgutter=5)

Split the text in `s` into lines up to `width` units wide (in the current font).

Returns an array of strings. Use `textwrap` to draw an array of strings.

TODO: A `rightgutter` optional keyword adds some padding to the right hand side
of the column. This appears to be needed sometimes -— perhaps the algorithm
needs improving to take account of the interaction of `textextents` and spaces?
"""
function textlines(s::T where T<:AbstractString, width::Real; rightgutter=5)
    result = String[]
    fields = splittext(s)
    textwidth = width - rightgutter
    # how to get the width of a space?
    spacewidth = textextents("m m")[3] - textextents("mm")[3]
    spaceleft = textwidth
    currentline = String[]
    for word in fields
        word == "" && continue
        wordextents =  textextents(word)
        widthofword = wordextents[3] + wordextents[6]
        isapprox(widthofword, 0.0, atol=0.1) && continue
        if (widthofword + spacewidth) > spaceleft
            # start a new line
            push!(result, strip(join(currentline)))
            currentline=[]
            spaceleft = textwidth
        end
        if endswith(word, "-")
            push!(currentline, word)
        else
            push!(currentline, word * " ")
        end
        spaceleft -= (widthofword + spacewidth)
    end
    push!(result, strip(join(currentline)))

    # strip trailing spaces
    for i in eachindex(result)
       result[i] = strip(result[i])
    end
    return result
end

"""
    textbox(lines::Array, pos::Point=O;
        leading = 12,
        linefunc::Function = (linenumber, linetext, startpos, height) -> (),
        alignment=:left)

Draw the strings in the array `lines` vertically downwards. `leading` controls
the spacing between each line (default 12), and `alignment` determines the
horizontal alignment (default `:left`).

Optionally, before each line, execute the function
`linefunc(linenumber, linetext, startpos, height)`.

Returns the position of what would have been the next line.

See also `textwrap()`, which modifies the text so that the lines fit into a
specified width.
"""
function textbox(lines::Array, pos::Point=O;
        leading = 0,
        linefunc::Function = (linenumber, linetext, startpos, leading) -> (),
        alignment=:left)

    # find height of first non-empty line
    firstrealline = filter(!isempty, lines)[1]
    te = textextents(firstrealline)
    if leading == 0
        leading = te[4]
    end
    startpos = Point(pos.x, pos.y + leading)
    for (linenumber, linetext) in enumerate(lines)
        linefunc(linenumber, linetext, startpos, leading)
        text(linetext, startpos, halign=alignment)
        startpos = Point(startpos.x, startpos.y + leading)
    end
    return startpos
end
"""
    textbox(s::AbstractString, pos::Point=O;
        leading = 12,
        linefunc::Function = (linenumber, linetext, startpos, height) -> (),
        alignment=:left)
"""
textbox(s::AbstractString, pos::Point=O; kwargs...) = textbox([s], pos; kwargs...)

"""
    textwrap(s::T where T<:AbstractString, width::Real, pos::Point;
        rightgutter=5,
        leading=0)
    textwrap(s::T where T<:AbstractString, width::Real, pos::Point, linefunc::Function;
        rightgutter=5,
        leading=0)

Draw the string in `s` by splitting it at whitespace characters into lines, so that each
line is no longer than `width` units. The text starts at `pos` such that the first line of
text is drawn entirely below a line drawn horizontally through that position. Each line is
aligned on the left side, below `pos`.

See also `textbox()`.

Optionally, before each line, execute the function `linefunc(linenumber, linetext, startpos, leading)`.

If you don't supply a value for `leading`, the font's built-in extents are used.

Text with no whitespace characters won't wrap. You can write a simple chunking function
to split a string or array into chunks:

```
chunk(x, n) = [x[i:min(i+n-1,length(x))] for i in 1:n:length(x)]
```

For example:

```
textwrap(the_text, 300, boxtopleft(BoundingBox()) + 20,
    (ln, lt, sp, ht) -> begin
        c = count(t -> occursin(r"[[:punct:]]", t), split(lt, ""))
        @layer begin
            fontface("Menlo")
            sethue("darkred")
            text(string("[", c, "]"), sp + (310, 0))
        end
    end)
```

puts a count of the number of punctuation characters in each line at the end
of the line.

Returns the position of what would have been the next line.
"""
function textwrap(s::T where T<:AbstractString, width::Real, pos::Point, linefunc::Function;
        rightgutter=5,
        leading=0)
    lines = textlines(s, width; rightgutter=rightgutter)
    lines = textlines(s, width; rightgutter=rightgutter)
    textbox(lines, pos, linefunc=linefunc, leading=leading)
end

textwrap(s::T where T<:AbstractString, width::Real, pos::Point; kwargs...) =
    textwrap(s, width, pos, (linenumber, linetext, startpos, height) -> ();
             kwargs...)

"""
    texttrack(txt, pos, tracking, fontsize=12)

Place the text in `txt` at `pos`, left-justified, and letter space ('track') the text using the value in `tracking`.

The tracking units depend on the current font size! 1 is 1/1000 em. In a 6‑point font, 1 em equals 6 points;
in a 10‑point font, 1 em equals 10 points.

A value of -50 would tighten the letter spacing noticeably. A value of 50 would make the text more open.
"""
function texttrack(txt, pos, tracking, fontsize=12)
    te = textextents(txt)
    for i in txt
        glyph = string(i)
        glyph_x_bearing, glyph_y_bearing, glyph_width, glyph_height, glyph_x_advance, glyph_y_advance = textextents(glyph)
        text(glyph, pos)
        x = glyph_x_advance + (tracking/1000) * fontsize
        pos += (x, 0)
    end
end
