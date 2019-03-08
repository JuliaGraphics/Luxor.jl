"""
    arrow(startpoint::Point, endpoint::Point;
        linewidth = 1.0,
        arrowheadlength = 10,
        arrowheadangle = pi/8)

Draw a line between two points and add an arrowhead at the end. The arrowhead
length will be the length of the side of the arrow's head, and the arrowhead
angle is the angle between the sloping side of the arrowhead and the arrow's
shaft.

Arrows don't use the current linewidth setting (`setline()`), and defaults to 1,
but you can specify another value. It doesn't need stroking/filling, the shaft
is stroked and the head filled with the current color.

"""
function arrow(startpoint::Point, endpoint::Point;
        linewidth=1.0,
        arrowheadlength=10,
        arrowheadangle=pi/8)
    gsave()
    setlinejoin("butt")
    setline(linewidth)

    isapprox(startpoint, endpoint) && throw(error("can't draw arrow between two identical points"))
    shaftlength = distance(startpoint, endpoint)
    shaftangle = atan(startpoint.y - endpoint.y, startpoint.x - endpoint.x)
    arrowheadtopsideangle = shaftangle + arrowheadangle
    # shorten the length so that lines
    # stop before we get to the arrow
    # thus wide shafts won't stick out through the head of the arrow.
    max_undershoot = shaftlength - ((linewidth/2) / tan(arrowheadangle))
    true_arrowheadlength = arrowheadlength * cos(arrowheadangle)
    if true_arrowheadlength < max_undershoot
        ratio = (shaftlength - true_arrowheadlength)/shaftlength
    else
        ratio = max_undershoot/shaftlength
    end
    tox = startpoint.x + (endpoint.x - startpoint.x) * ratio
    toy = startpoint.y + (endpoint.y - startpoint.y) * ratio
    fromx = startpoint.x
    fromy = startpoint.y

    # draw the shaft of the arrow
    newpath()
    line(Point(fromx, fromy), Point(tox, toy), :stroke)

    # draw the arrowhead
    topx = endpoint.x + cos(arrowheadtopsideangle) * arrowheadlength
    topy = endpoint.y + sin(arrowheadtopsideangle) * arrowheadlength
    arrowheadbottomsideangle = shaftangle - arrowheadangle
    botx = endpoint.x + cos(arrowheadbottomsideangle) * arrowheadlength
    boty = endpoint.y + sin(arrowheadbottomsideangle) * arrowheadlength
    poly([Point(topx, topy), endpoint, Point(botx, boty)], :fill)
    grestore()
end

"""
    arrow(centerpos::Point, radius, startangle, endangle;
        linewidth = 1.0,
        arrowheadlength = 10,
        arrowheadangle = pi/8)

Draw a curved arrow, an arc centered at `centerpos` starting at `startangle` and ending at
`endangle` with an arrowhead at the end. Angles are measured clockwise from the positive
x-axis.

Arrows don't use the current linewidth setting (`setline()`); you can specify the linewidth.
"""
function arrow(centerpos::Point, radius, startangle, endangle;
        linewidth=1.0,
        arrowheadlength=10,
        arrowheadangle=pi/8)
    gsave()
    setlinejoin("butt")
    setline(linewidth)
    if startangle > endangle
        endangle += 2pi
    end
    # don't bother with them if theyre too small
    if isapprox(startangle, endangle, rtol = 0.1)
        return
    end
    # shorten the length so that lines
    # stop before we get to the arrow
    # thus wide shafts won't stick out through the head of the arrow.
    startpoint = Point(radius * cos(startangle), radius * sin(startangle))
    endpoint   = Point(radius * cos(endangle), radius * sin(endangle))
    arclength = radius * mod2pi(endangle - startangle)
    max_undershoot = arclength - ((linewidth/2) / tan(arrowheadangle))
    true_arrowheadlength = arrowheadlength * cos(arrowheadangle)
    if true_arrowheadlength < max_undershoot
        ratio = (arclength - true_arrowheadlength)/arclength
    else
        ratio = max_undershoot/arclength
    end
    newarclength = arclength * ratio
    newendangle = (newarclength/radius) + startangle
    translate(centerpos)
    # draw the arrow
    newpath()
    move(radius * cos(startangle), radius * sin(startangle))
    arc(0, 0, radius, startangle, newendangle, :stroke)
    closepath()
    # draw head
    # rotation of head should be based on end of shaft, not end of arrow
    newendpoint =              Point(radius * cos(newendangle), radius * sin(newendangle))
    shaftangle =               mod2pi(-pi/2 + atan(0 - newendpoint.y, 0 - newendpoint.x))
    #
    arrowheadoutersideangle = shaftangle + pi - arrowheadangle
    arrowheadinnersideangle    = shaftangle + pi + arrowheadangle
    topx =                     endpoint.x + cos(arrowheadinnersideangle) * arrowheadlength
    topy =                     endpoint.y + sin(arrowheadinnersideangle) * arrowheadlength
    botx =                     endpoint.x + cos(arrowheadoutersideangle) * arrowheadlength
    boty =                     endpoint.y + sin(arrowheadoutersideangle) * arrowheadlength
    poly([Point(topx, topy), Point(endpoint.x, endpoint.y), Point(botx, boty)], :fill)
    grestore()
end

"""
    dimension(p1::Point, p2::Point;
        format::Function   = (d) -> string(d), # process the measured value into a string
        offset             = 0.0,              # left/right, parallel with x axis
        fromextension      = (10.0, 10.0),     # length of extensions lines left and right
        toextension        = (10.0, 10.0),     #
        textverticaloffset = 0.0,              # range 1.0 (top) to -1.0 (bottom)
        texthorizontaloffset = 0.0,            # range 1.0 (top) to -1.0 (bottom)
        textgap            = 5,                # gap between start of each arrow (≈ fontsize?)
        textrotation       = 0.0,
        arrowlinewidth     = 1.0,
        arrowheadlength    = 10,
        arrowheadangle     = π/8)

Calculate and draw dimensioning graphics for the distance between `p1` and `p2`.
The value can be formatted with function `format`.

`p1` is the lower on the page (ie probably the higher y value) point, `p2` is
the higher on the page (ie probably lower y) point.

`offset` is to the left (-x) when negative.

Dimension graphics will be rotated to align with a line between `p1` and `p2`.

In `textverticaloffset`, "vertical" and "horizontal" are best understood by "looking" along the line from the first point to the
second. `textverticaloffset` ranges from -1 to 1, `texthorizontaloffset` in default units.

```
        toextension
        [5  ,  5]
       <---> <--->
                             to
       -----------            +
            ^
            |

           -50

            |
            v
       ----------            +
                            from
       <---> <--->
         [5 , 5]
       fromextension

            <---------------->
                  offset
```

Returns the measured distance and the text.
"""
function dimension(p1::Point, p2::Point;
    format::Function   = (d) -> string(d), # process the measured value into a string
    offset             = 0.0,              # left/right, parallel with x axis
    fromextension      = (10.0, 10.0),     # length of extensions lines left and right
    toextension        = (10.0, 10.0),     #
    textverticaloffset = 0.0,              # range 1.0 (top) to -1.0 (bottom)
    texthorizontaloffset = 0.0,            #
    textgap            = 5,                # gap between start of each arrow (≈ fontsize?)
    textrotation       = 0.0,
    arrowlinewidth     = 1.0,
    arrowheadlength    = 10,
    arrowheadangle     = π/8)

    p1 == p2 && throw(error("dimension(): the two points are the same, can't draw dimensions"))
    d     = distance(p1, p2)
    midpt = midpoint(p1, p2)
    s     = slope(p1, p2)
    t     = format(d)
    @layer begin
        o = perpendicular(midpt, p2, offset)
        translate(o)
        rotate(π/2 + s)

        line(Point(-fromextension[1], d/2), Point(fromextension[2], d/2), :stroke)
        line(Point(-toextension[1], -d/2), Point(toextension[2], -d/2), :stroke)

        # top (lower y)
        apos = O + (0, -textgap - rescale(textverticaloffset, 0, 1, 0, d/2))
        arrow(apos, Point(0, -d/2), linewidth = arrowlinewidth, arrowheadlength = arrowheadlength, arrowheadangle = arrowheadangle)

        # bottom (higher y)
        bpos = O + (0, textgap + rescale(-textverticaloffset, 0, 1, 0, d/2))
        arrow(bpos, Point(0, d/2), linewidth = arrowlinewidth, arrowheadlength = arrowheadlength, arrowheadangle = arrowheadangle)

        te = textextents(t)
        tpos = O + (texthorizontaloffset, -textverticaloffset * d/2)
        @layer begin
            translate(tpos)
            rotate(textrotation)
            text(t, halign=:center, valign=:middle)
        end
    end
    return (d, t)
end
