# text

# first, the 'toy' API... "Any serious application should avoid them." :)

"""
    text(str)
    text(str, pos)
    text(str, pos, angle = pi/2)
    text(str, x, y)
    text(str, pos, halign = :left)
    text(str, valign = :baseline)
    text(str, valign = :baseline, halign = :left)
    text(str, pos, valign = :baseline, halign = :left)
    text(latexstr, pos, valign = :baseline, halign = :left, rotationfixed = false, angle = 0)

Draw the text in the string `str` at `x`/`y` or `pt`, placing the start of the
string at the point. If you omit the point, it's placed at the current `0/0`.

`angle` specifies the rotation of the text relative to the current x-axis.

Horizontal alignment `halign` can be `:left`, `:center`, (also `:centre`) or
`:right`.  Vertical alignment `valign` can be `:baseline`, `:top`, `:middle`, or
`:bottom`.

The default alignment is `:left`, `:baseline`.

This uses `textextents()` to query the dimensions of the text. This returns
values of the built in to the font. You can't find

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

    # was textpointx = pt.x - [0, textwidth/2, textwidth][halignment]
    textpointx = pt.x - [0, xadvance/2, textwidth + xbearing][halignment]

    valignment = findfirst(isequal(valign), [:top, :middle, :baseline, :bottom])

    # if unspecified or wrong, default to baseline
    if valignment == nothing
        valignment = 3
    end

    textpointy = pt.y - [ybearing, ybearing/2, 0, textheight + ybearing][valignment]

    # need to adjust for any rotation now
    # rotate around original point
    finalpt = rotate_point_around_point(Point(textpointx, textpointy), pt, angle)

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

# deprecated probably
textcentered(t, x=0, y=0) = text(t, x, y, halign=:center)
textcentered(t, pt::Point) = textcentered(t, pt.x, pt.y)
textcentred = textcentered
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

Convert the text in string `t` to paths, adding them to the current path, for subsequent filling/stroking etc...

You can use `pathtopoly()` or `getpath()` or `getpathflat()` to convert the paths to polygons.

See also `textoutlines()`. `textpath()` retains Bezier curves, whereas `textoutlines()` returns flattened curves.
"""
function textpath(t)
    Cairo.text_path(get_current_cr(), t)
end
"""
    textpath(s::AbstractString, pos::Point;
        action=:none,
        halign=:left,
        valign=:baseline,
        startnewpath=true)

Convert the text in string `s` to paths and apply the action.

TODO Return something more useful than a Boolean.
"""
function textpath(s::AbstractString, pos::Point;
        action=:none,
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
    textpointx = pos.x - [0, xadvance/2, textwidth + xbearing][halignment]
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
    end
    do_action(action)
end

textpath(s::AbstractString, pos::Point, action::Symbol;
        halign=:left,
        valign=:baseline,
        startnewpath=true) = textpath(s, pos, action=action, halign=halign, valign=valign, startnewpath=startnewpath)

"""
    textoutlines(s::AbstractString, pos::Point=O;
        action=:none,
        halign=:left,
        valign=:baseline,
        startnewpath=true)

Convert text to polygons and apply `action`.

By default this function discards any current path, unless you use `startnewpath=false`

See also `textpath()`. `textpath()` retains Bezier curves, whereas `textoutlines()` returns flattened curves.

TODO Return something more useful than a Boolean.
"""
function textoutlines(s::AbstractString, pos::Point;
    action=:none,
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
    textpointx = pos.x - [0, xadvance/2, textwidth + xbearing][halignment]
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

textoutlines(s::AbstractString, pos::Point, action::Symbol;
    halign=:left,
    valign=:baseline,
    startnewpath=true) = textoutlines(s, pos;
        action=action,
        halign=halign,
        valign=valign,
        startnewpath=startnewpath)

textoutlines(s::AbstractString; kwargs...) = textoutlines(s, O, kwargs...)

"""
    textcurve(the_text, start_angle, start_radius, x_pos = 0, y_pos = 0;
          # optional keyword arguments:
          spiral_ring_step = 0,    # step out or in by this amount
          letter_spacing = 0,      # tracking/space between chars, tighter is (-), looser is (+)
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
        text(glyph, O, halign=:center)
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
looser is (+)). `baselineshift` moves the text up or down away from the
baseline.

`textcurvecentred` (UK spelling) is a synonym.
"""
function textcurvecentered(the_text, the_angle, the_radius, center::Point;
                           clockwise = true,
                           letter_spacing = 0,
                           baselineshift = 0
      )
    atextbox = textextents(the_text)
    atextwidth = atextbox[3]                         # width of text
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
        leader=false,
        leaderoffsets=[0.0, 1.0])

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

`leaderoffsts` uses normalized fractions (see `between()`)
to specify the gap between the designated points and the
start and end of the lines.

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
        # hyphenation can leave an empty string field
        if word == ""
            word = " "
            push!(currentline, " ")
        end
        wordextents = textextents(word)
        widthofword = wordextents[1] + wordextents[3]
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
        spaceleft -= (wordextents[5] + spacewidth)
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

puts a count of the number of punctuation characters in each
line at the end of the line.

Returns the position of what would have been the next line.
"""
function textwrap(s::T where T<:AbstractString, width::Real, pos::Point, linefunc::Function;
        rightgutter=5,
        leading=0)
    lines = textlines(s, width; rightgutter=rightgutter)
    textbox(lines, pos, linefunc=linefunc, leading=leading)
end

textwrap(s::T where T<:AbstractString, width::Real, pos::Point; kwargs...) =
    textwrap(s, width, pos, (linenumber, linetext, startpos, height) -> ();
             kwargs...)

"""
    texttrack(txt, pos, tracking;
        action=:fill,
        halign=:left,
        valign=:baseline,
        startnewpath=true)
    texttrack(txt, pos, tracking, fontsize;
        action=:fill,
        halign=:left,
        valign=:baseline,
        startnewpath=true)

Place the text in `txt` at `pos`, left-justified, and letter
space ('track') the text using the value in `tracking`.

The tracking units depend on the current font size. In a
12‑point font, 1 em equals 12 points. A point is about
0.35mm, 1em is about 4.2mm, and a 1000 units of tracking are
about 4.2mm. So a tracking value of 1000 for a 12 point font
places about 4mm between each character.

A negative value tightens the letter spacing noticeably.

The text drawing action applied to each character defaults
to `textoutlines(... :fill)`.

If `startnewpath` is true, each character is acted on
separately. To clip and track text, specify the clip action
and avoid resetting the clipping path for each character.

```julia
    newpath()
    texttrack(t, O + (0, 80), 200, action=:clip, startnewpath=false)
    ...
    clipreset()
```

TODO Is it possible to fix strings with combining characters such as "\u0308"?
"""
function texttrack(txt, pos, tracking, fsize;
            action=:fill,
            halign=:left,
            valign=:baseline,
            startnewpath=true)

    advances = []
    emspacewidth = textextents(" ")[5]
    for c in txt
        xbearing, ybearing, textwidth, textheight, xadvance, yadvance  = textextents(string(c))
        if c == ' '
            textwidth = emspacewidth
        end
        push!(advances, xadvance)
    end

    # adjust start position for alignment
    # first, horizontal alignment - 1, 2, 3
    halignment = findfirst(isequal(halign), [:left, :center, :right, :centre])

    # if unspecified or wrong, default to left, also treat UK spelling centre as center
    if halignment == nothing
        halignment = 1
    elseif halignment == 4
        halignment = 2
    end

    # calculate width of the final tracked string
    # need this to do alignment
    total_textwidth = sum(advances) + length(advances) * ((tracking/1000) * fsize)
    textpointx = pos.x - [0, total_textwidth/2, total_textwidth][halignment]
    # next vertical alignment
    valignment = findfirst(isequal(valign), [:top, :middle, :baseline, :bottom])
    # if unspecified or wrong, default to baseline
    if valignment == nothing
        valignment = 3
    end
    ybearing, textheight = textextents(txt)[[2, 4]]
    textpointy = pos.y - [ybearing, ybearing/2, 0, textheight + ybearing][valignment]

    # this is the first point of the text string
    newpos = Point(textpointx, textpointy)

    # if clipping, clip the entire path, not individual characters
    if action == :clip
        _action = :path
    else
        _action = action
    end

    # draw the text
    for (n, c) in enumerate(txt)
        textpath(string(c), newpos, _action, halign=:left, startnewpath=startnewpath)
        # calculate new position based on precalculated widths plus the tracking
        newpos = Point(newpos.x + advances[n] + ((tracking/1000) * fsize), newpos.y)
    end
    if action == :clip
        do_action(:clip)
    end
end

texttrack(txt, pos, tracking;
            action=:fill,
            halign=:left,
            valign=:baseline,
            startnewpath=true) = texttrack(txt, pos, tracking, get_fontsize();
                        action=action,
                        halign=halign,
                        valign=valign,
                        startnewpath=startnewpath)

"""
    textplace(txt::AbstractString, pos::Point, params::Vector;
        action = :fill,
        startnewpath = false)

A low-level function that places text characters one by one
according to the parameters in `params`. First character
uses the first tuple, second character uses the second, and
so on.

Returns the next text position.

A tuple of parameters is:

```julia
(face = "TimesRoman", size = 12, color=colorant"black", kern = 0, shift = 0, advance = true)
```

where

- `face` is fontface "string"                   # sticky

- `size` is fontsize # pts                      # sticky

- `color` is color                              # sticky

- `kern` amount (pixels) shifted to the right   # resets after each char

- `shift` = baseline shifted vertically         # resets after each char

- `advance` - whether to advance                # resets after each char

Some parameters are "sticky": once set, they apply for all
subsequent characters until a new value is supplied. Others
aren't sticky, and are reset for each character. So font
face, size, and color parameters need only be specified
once, whereas kern/shift/advance modifiers are reset for each
character.

## Example

Draw the Hogwarts Express Platform number 9 and 3/4:

```julia
txtpos = textplace("93—4!", O - (200, 0), [
    # format for 9:
    (size=120, face="Bodoni-Poster", color=colorant"grey10"),
    # format for 3:
    (size=60,  kern = 5, shift = 60,  advance=false,),
    # format for -:
    (          kern = 0, shift = 25,  advance=false,),
    # format for 4:
    (          kern = 5, shift = -20, advance=true),
    # format for !:
    (size=120, kern = 20,),
    ])
```
"""
function textplace(txt::AbstractString, pos::Point, params::Vector;
        action = :fill,
        startnewpath = false)
    @layer begin
        textpos = Point(pos.x, pos.y)
        currentparams = (face = "", size = 12, color = colorant"black", kern=0, shift=0, advance=true,)
        for (n, c) in enumerate(txt)
            currentparams = merge(currentparams, (kern=0, shift=0, advance=true,))
            if n <= length(params)
                currentparams = merge(currentparams, params[n])
            end
            fontface(currentparams.face)
            fontsize(currentparams.size)
            sethue(currentparams.color)
            xbearing, ybearing, textwidth, textheight, xadvance, yadvance  = textextents(string(c))
            temp_text_pos = Point(textpos.x + currentparams.kern, textpos.y - currentparams.shift)
            textoutlines(string(c), temp_text_pos, action=action, halign=:left, startnewpath = startnewpath)
            if currentparams.advance == true
                textpos += (xadvance + currentparams.kern, 0)
            end
        end
    end
    return textpos
end

"""
    textfit(str, bbox::BoundingBox, maxfontsize = 800;
         horizontalmargin=12,
         leading=100)

Fit the string `str` into the bounding box `bbox` by adjusting the font
size and line breaks.

Instead of using the current font size, the largest possible
value will be calculated. You can specify a size limit in
`maxfontsize`, such that the text will never be larger than this
value, although it may have to be smaller.

`horizontalmargin` is applied to each side.

Optionally, `leading` can be supplied, and this will be
interpreted as a percentage of the final calculated font
size. The default value is 110 (%).

The function returns a named tuple with information about
the calculated values:

```julia
(fontsize = 37.6, linecount = 5, finalpos = Point(-117.43, 92.60)
```

!!! note

    This function is in need of improvement. It's quite
    difficult to find out the height of a line of text in a
    specific font. (Unless we import FreeType.) Suggestions for
    improvements welcome!

"""
function textfit(s::T where T<:AbstractString, bbox::BoundingBox, maxfontsize = 800;
        horizontalmargin=3,
        leading=110)
    @layer begin
        bbox  = bbox - horizontalmargin
        width = boxwidth(bbox)
        requiredheight = boxheight(bbox)

        # we'll never go bigger than this:
        fsize = maxfontsize
        fontsize(fsize)

        # remove blank lines from rearranged lines
        lines = filter!(!isempty, textlines(s, width))

        te = textextents(lines[1])

        # set up our binary search
        foundminsize = 0.5
        foundmaxsize = maxfontsize
        totalattempts = 20
        attempts = 0

        # binary search for the closest fontsize that satisfies our requirements
        while foundmaxsize - foundminsize > 0.1
            attempts += 1
            if attempts > totalattempts
                throw(error("textfit(): couldn't fit the text with $maxfontsize maxfontsize after trying $(atttempts) times"))
            end

            fsize = foundminsize + (foundmaxsize - foundminsize) / 2.0
            fontsize(fsize)

            # split into lines
            lines = filter!(!isempty, textlines(s, width))

            # estimate the finish height with our current fontsize
            # since we don't know the height well enough, just hope that putting leading
            # between every line will work
            estimatedfinishheight = (fsize + (100/leading)) * length(lines)

            # estimate finish width
            widestline = 0
            for l in lines
                te = textextents(l)
                if widestline <= te[3]
                    widestline = te[3]
                end
            end

            # is this estimated result good enough with this font size?
            if estimatedfinishheight < requiredheight && widestline < boxwidth(bbox)
                # estimated size is too small
                # search for a larger font size
                foundminsize = fsize
            else
                # estimated size is too large
                # search for a smaller font size.
                foundmaxsize = fsize
            end
        end # while

        # use the most recent font size
        fontsize(fsize * (100/leading))
        lines = filter!(!isempty, textlines(s, width))

        # start below the top of the box

        te = textextents(lines[1])
        # we can't get the height of a text character, sadly
        # but we can guess
        # not all fonts will have these characters though?
        fontheight = textextents("AA⃰gg̲")[4]
        textpos = boxtopleft(bbox) + Point(0, max(te[4], fontheight))

        for (linenumber, linetext) in enumerate(lines)
            text(linetext, textpos)
            te = textextents(linetext)
            textpos = Point(textpos.x, textpos.y + (max(te[4], fontheight) * (leading/100)))
        end
        # return top position, bottom position
    end
    return (fontsize=fsize, linecount=length(lines), finalpos=textpos)
end

"""
    textonpoly(str, pgon;
            tracking = 0,
            startoffset = 0.0,
            baselineshift = 0.0,
            closed = false)

Draw the text in `str` along the route of the polygon in
`pgon`.

The `closed` option determines whether the final edge of the
polygon (joining the last point to the first) is included or
not. Eg if you want to draw a string around all three sides
of a triangle, you'd use `closed=true`:

```julia
textonpoly("mèdeis ageômetrètos eisitô mou tèn
stegèn - let no one ignorant of geometry come under my roof
",
    ngon(O, 100, 3, vertices=true),
    closed=true)
```

If `false`, only two sides are considered.

Increase `tracking` from 0 to add space between the glyphs.

The `startoffset` value is a normalized percentage that
specifies the start position. So, to start drawing the text
halfway along the polygon, specify a start offset value of
0.5.

Positive values for `baselineshift` move the characters
upwards from the baseline.

Returns a tuple with the number of characters drawn, and the
final value of the index, between 0.0 and 1.0. If the
returned index value is less than 1, this means that the
text supplied ran out before the end of the polygon was reached.
"""
function textonpoly(str, pgon;
        tracking = 0,
        startoffset = 0.0,
        baselineshift = 0.0,
        closed=false)
    pdist = polydistances(pgon, closed = closed)
    pgondist = polyperimeter(pgon, closed = closed)
    currentindex = startoffset
    characters_drawn = 1

    # hack: we can't find the slope of the line at its end
    # kludge: extend last segment
    if !closed
        push!(pgon, between(pgon[end - 1], pgon[end], 1.0001))
    end
    for (n, c) in enumerate(str)
        glyph = string(c)
        fs = get_fontsize()
        if glyph == " "
            # we need the dimensions of the space character
            glyph_x_bearing,
            glyph_y_bearing,
            glyph_width,
            glyph_height,
            glyph_x_advance,
            glyph_y_advance =
                textextents("m m") .- textextents("mm")
        else
            glyph_x_bearing,
            glyph_y_bearing,
            glyph_width,
            glyph_height,
            glyph_x_advance,
            glyph_y_advance = textextents(glyph)
        end

        currentindex += (glyph_width / 2 + glyph_x_bearing + tracking) / pgondist
        # find slope of line at the current location
        θ = slope(
            last(polyportion(
                pgon,
                mod(currentindex - 0.0001, 1.0),
                closed = false,
                pdist=pdist
            )),
            last(polyportion(
                pgon,
                mod(currentindex + 0.0001, 1.0),
                closed = false,
                pdist=pdist
            )),
        )
        # move to the position for the middle of the glyph
        @layer begin
            translate(last(polyportion(
                pgon,
                currentindex,
                closed = closed,
            )))
            rotate(θ)
            # draw the glyph
            text(glyph, O + (0, -baselineshift), halign = :center)
        end
        # move on
        currentindex +=
            (glyph_width / 2 + glyph_x_bearing + tracking) /
            pgondist

        characters_drawn = n
        if currentindex >= 1.0
            break
        end
    end
    return (characters_drawn, currentindex)
end
