"""
    arrowhead(target[, action=:fill];
        shaftangle=0,
        headlength=10,
        headangle=pi/8)

Draw an arrow head. The arrowhead length will be the length of the side of
the arrow's head, and the arrowhead angle is the angle between the sloping
side of the arrowhead and the arrow's shaft.

This doesn't use the current linewidth setting (`setline()`), and defaults to 1,
but you can specify another value.
"""
function arrowhead(target, action=:fill;
        shaftangle=0, headlength=10, headangle=pi/8)
    gsave()
    topangle = shaftangle + headangle
    botangle = shaftangle - headangle

    topx = target.x + cos(topangle) * headlength
    topy = target.y + sin(topangle) * headlength
    botx = target.x + cos(botangle) * headlength
    boty = target.y + sin(botangle) * headlength
    poly([Point(topx, topy), target, Point(botx, boty)], action)
    grestore()
end

"""
    arrow(startpoint::Point, endpoint::Point;
        linewidth         = 1.0,
        arrowheadlength   = 10,
        arrowheadangle    = pi/8,
        decoration        = 0.5 or range(),
        decorate          = nothing,
        arrowheadfunction = nothing)

Draw a line between two points and add an arrowhead at the
end. The arrowhead length will be the length of the side of
the arrow's head, and the arrowhead angle is the angle
between the sloping side of the arrowhead and the arrow's
shaft.

Arrows don't use the current linewidth setting
(`setline()`), and defaults to 1, but you can specify
another value. It doesn't need stroking/filling, the shaft
is stroked and the head filled with the current color.

### Decoration

The `decorate` keyword argument accepts a function with zero
arguments that can execute code at one or more locations on
the arrow's shaft. The inherited graphic environment is
centered at each point on the shaft between 0 and 1 given by
scalar or vector `decoration`, and the x-axis is aligned
with the direction of the curve at that point.

### Arrowheads

A triangular arrowhead is drawn by default. But you can pass
a function to the `arrowheadfunction` keyword argument that
accepts three arguments: the shaft end, the arrow head end,
and the shaft angle. Thsi allows you to draw any shape
arrowhead.

### Example

```
function redbluearrow(shaftendpoint, endpoint, shaftangle)
    @layer begin
        sethue("red")
        sidept1 = shaftendpoint  + polar(10, shaftangle + π/2 )
        sidept2 = shaftendpoint  - polar(10, shaftangle + π/2)
        poly([sidept1, endpoint, sidept2], :fill)
        sethue("blue")
        poly([sidept1, endpoint, sidept2], :stroke, close=false)
    end
end

@drawsvg begin
    background("white")
    arrow(O, O + (120, 120),
        linewidth=4,
        arrowheadlength=40,
        arrowheadangle=π/7,
        arrowheadfunction = redbluearrow)

    arrow(O, 100, 3π/2, π,
        linewidth=4,
        arrowheadlength=20,
        clockwise=false,arrowheadfunction=redbluearrow)
end 800 250
```

"""
function arrow(startpoint::Point, endpoint::Point;
        linewidth         = 1.0,
        arrowheadlength   = 10,
        arrowheadangle    = pi/8,
        decoration        = 0.5,
        decorate          = nothing,
        arrowheadfunction = nothing)

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

    toppoint = Point(endpoint.x + cos(arrowheadtopsideangle) * arrowheadlength,
                     endpoint.y + sin(arrowheadtopsideangle) * arrowheadlength)

    arrowheadbottomsideangle = shaftangle - arrowheadangle

    bottompoint = Point(endpoint.x + cos(arrowheadbottomsideangle) * arrowheadlength,
                        endpoint.y + sin(arrowheadbottomsideangle) * arrowheadlength)

    #  use a user-supplied arrowhead function?
    if arrowheadfunction === nothing
        poly([toppoint, endpoint, bottompoint], :fill)
    else
        # shaft end, head end, angle
        arrowheadfunction(Point(tox, toy), endpoint, slope(startpoint, endpoint))
    end

    # prepare to add decorations at point along shaft
    if decorate === nothing
    else
        for decpos in decoration
            decpoint = between(startpoint, endpoint, decpos)
            # slope at this point
            slp = slope(startpoint, endpoint)
            @layer begin
                translate(decpoint)
                rotate(slp)
                decorate()
            end
        end
    end
    grestore()
end

"""
    arrow(centerpos::Point, radius, startangle, endangle;
        linewidth          = 1.0,
        arrowheadlength    = 10,
        arrowheadangle     = π/8,
        decoration         = 0.5,
        decorate           = nothing,
        arrowheadfunction  = nothing,
        clockwise          = true)

Draw a curved arrow, an arc centered at `centerpos` starting
at `startangle` and ending at `endangle` with an arrowhead
at the end. Angles are measured clockwise from the positive
x-axis.

Arrows don't use the current linewidth setting
(`setline()`); you can specify the linewidth.

The `decorate` keyword argument accepts a zero-argument
function that can execute code at one or more locations on
the arrow's shaft. The inherited graphic environment is
centered at points on the shaft between 0 and 1 given by
scalar or vector `decoration`, and the x-axis is aligned
with the direction of the curve at that point.

A triangular arrowhead is drawn by default. But you can pass
a function to the `arrowheadfunction` keyword argument that
accepts three arguments: the shaft end, the arrow head end,
and the shaft angle. Thsi allows you to draw any shape
arrowhead.
"""
function arrow(centerpos::Point, radius, startangle, endangle;
    linewidth          = 1.0,
    arrowheadlength    = 10,
    arrowheadangle     = π/8,
    decoration         = 0.5,
    decorate           = nothing,
    arrowheadfunction  = nothing,
    clockwise          = true)

    # don't bother with them if theyre too small
    if isapprox(startangle, endangle, rtol = 0.01)
        return
    end
    # circular arcs needs swapping to avoid Cairo crash
    if isapprox(startangle - endangle, 2π, rtol = 0.01)
        startangle, endangle = endangle, startangle
    end

    gsave()
    setlinejoin("butt")
    setline(linewidth)
    translate(centerpos)
    θ = mod2pi((2π + endangle) - startangle)
    if clockwise != true
        θ = 2π  - θ
    end
    arclength = radius * θ
    startpoint = Point(radius * cos(startangle), radius * sin(startangle))
    endpoint   = Point(radius * cos(endangle),   radius * sin(endangle))

    # shorten the length so that lines stop before we get to the arrow
    # thus wide shafts won't stick out through the head of the arrow.

    max_undershoot = arclength - ((linewidth/2) / tan(arrowheadangle))
    true_arrowheadlength = arrowheadlength * cos(arrowheadangle)
    if true_arrowheadlength < max_undershoot
        ratio = (arclength - true_arrowheadlength)/arclength
    else
        ratio = max_undershoot/arclength
    end

    # draw the arrow shaft
    newpath()
    move(radius * cos(startangle), radius * sin(startangle))
    newarclength = arclength * ratio
    if clockwise == true
        newendangle = startangle + (newarclength/radius)
        arc(O, radius, startangle, newendangle, :stroke)
    else
        newendangle = startangle - (newarclength/radius)
        carc(O, radius, startangle, newendangle, :stroke)
    end
    closepath()

    # draw the arrowhead
    newendpoint = Point(radius * cos(newendangle), radius * sin(newendangle))
    shaftangle = slope(newendpoint, endpoint)
    #  use a user-supplied arrowhead function?
    if arrowheadfunction === nothing
        arrowheadoutersideangle = shaftangle + pi - arrowheadangle
        arrowheadinnersideangle = shaftangle + pi + arrowheadangle
        toppoint    = Point(endpoint.x + cos(arrowheadinnersideangle) * arrowheadlength,
                            endpoint.y + sin(arrowheadinnersideangle) * arrowheadlength)
        bottompoint = Point(endpoint.x + cos(arrowheadoutersideangle) * arrowheadlength,
                            endpoint.y + sin(arrowheadoutersideangle) * arrowheadlength)
        poly([toppoint, endpoint, bottompoint], :fill)
    else
        # shaft end, head end, angle
        arrowheadfunction(newendpoint, endpoint, shaftangle)
    end

    # use-suppplied shaft decoration function?
    if decorate === nothing
    else
        gsave()
        for decpos in decoration
            decorationangle = rescale(decpos, 0, 1, startangle, newendangle)
            decorationpoint = Point(radius * cos(decorationangle), radius * sin(decorationangle))
            ptangle = atan(decorationpoint.y, decorationpoint.x)
            @layer begin
                translate(decorationpoint)
                rotate(π/2 + ptangle)
                decorate()
            end
        end
        grestore()
    end
    grestore()
end

"""
    arrow(start::Point, C1::Point, C2::Point, finish::Point, action=:stroke;
        linewidth       = 1.0,
        arrowheadlength = 10,
        arrowheadangle  = pi/8,
        startarrow      = false,
        finisharrow     = true,
        decoration      = 0.5,
        decorate        = nothing
        arrowheadfunction = nothing)

Draw a Bezier curved arrow, from `start` to `finish`, with
control points `C1` and `C2`. Arrow heads can be
added/hidden by changing `startarrow` and `finisharrow`
options.

The `decorate` keyword argument accepts a function that can
execute code at one or more locations on the arrow's shaft.
The inherited graphic environment is centered at each point
on the shaft given by scalar or vector `decoration`, and the
x-axis is aligned with the direction of the curve at that
point.

### Example

This code draws an arrow head that's filled with orange and outlined in green.

```
function myarrowheadfunction(originalendpoint, newendpoint, shaftangle)
    @layer begin
        setline(5)
        translate(newendpoint)
        rotate(shaftangle)
        sethue("orange")
        ngon(O, 20, 3, 0, :fill)
        sethue("green")
        ngon(O, 20, 3, 0, :stroke)
    end
end

@drawsvg begin
    background("white")
    arrow(O, 220, 0, π,
        linewidth=10,
        arrowheadlength=30,
        arrowheadangle=π/7,
        clockwise=true,
        arrowheadfunction = myarrowheadfunction)
end
```

"""
function arrow(start::Point, C1::Point, C2::Point, finish::Point, action=:stroke;
        # optional
        linewidth=1.0,
        arrowheadlength=10,
        arrowheadangle=pi/8,
        arrowheadfill=true,
        startarrow=false,
        finisharrow=true,
        decoration = 0.5,
        decorate = nothing,
        arrowheadfunction = nothing)
    @layer begin
        setline(linewidth)
        overlap = 0.1 # radians of fudginess
        # TODO rewrite all this
        # arrow heads are a pain
        # length of proposed arrow
        bezlength = polyperimeter(beziertopoly(BezierPathSegment(start, C1, C2, finish)))
        if startarrow && arrowheadfill
            # calculate the shorter version
            actualcurvestart = bezier((arrowheadlength * cos(arrowheadangle + overlap))/bezlength, start, C1, C2, finish)
        else
            actualcurvestart = start
        end
        if finisharrow && arrowheadfill
            # calculate the shorter version
            actualcurvefinish = bezier(1 - (arrowheadlength * cos(arrowheadangle + overlap))/bezlength, start, C1, C2, finish)
        else
            actualcurvefinish = finish
        end

        move(actualcurvestart)
        curve(C1, C2, actualcurvefinish)

        do_action(action)

        start_shaftangle  = slope(start, C1)
        finish_shaftangle = slope(C2, finish)

        if arrowheadfunction === nothing
            finisharrow && arrowhead(finish, arrowheadfill == true ? :fill : :stroke, headlength = arrowheadlength, headangle = arrowheadangle, shaftangle = π + finish_shaftangle)
            startarrow && arrowhead(start, arrowheadfill == true ? :fill : :stroke, headlength = arrowheadlength, headangle = arrowheadangle,   shaftangle = start_shaftangle)
        else
            # shaftangle starts at end and continues outwards
            finisharrow && arrowheadfunction(actualcurvefinish, finish, finish_shaftangle)
            startarrow && arrowheadfunction(actualcurvestart, start, start_shaftangle)
        end

        # prepare to add decorations at points along shaft
        if decorate === nothing
        else
            for decpos in decoration
                decpoint = bezier(decpos, start, C1, C2, finish)
                bp = bezier′(decpos, start, C1, C2, finish)
                slp = atan(bp.y, bp.x)
                @layer begin
                    translate(decpoint)
                    rotate(slp)
                    decorate()
                end
            end
        end
    end # layer
end

"""
    arrow(start::Point, finish::Point, height::Vector, action=:stroke;
        keyword arguments...)

Draw a Bézier arrow between `start` and `finish`, with control points defined to fit in
an imaginary box defined by the two supplied `height` values (see `bezierfrompoints()`). If the height values are different signs, the arrow will change direction on its way.

Keyword arguments are the same as [`arrow(pt1, pt2, pt3, pt4)`](@ref).

### Example

```
arrow(pts[1], pts[end], [15, 15],
    decoration = 0.5,
    decorate = () -> text(string(pts[1])))
```

"""
function arrow(start::Point, finish::Point, height::Vector, action=:stroke;
        # optional kwargs
        linewidth=1.0,
        arrowheadlength=10,
        arrowheadangle=pi/8,
        arrowheadfill=true,
        startarrow=false,
        finisharrow=true,
        decoration = 0.5,
        decorate = nothing,
        arrowheadfunction = nothing)

    @layer begin
        s = slope(start, finish)
        perp1 = start +  polar(height[1], s - π/2)
        perp2 = finish + polar(height[2], s - π/2)
    end

    cpt1 = between(perp1, perp2, 0.33)
    cpt2 = between(perp1, perp2, 0.66)
    pts = bezierfrompoints([start,
        cpt1,
        cpt2,
        finish])

    # i've forgotten how to do this better...
    arrow(pts[1], pts[2], pts[3], pts[4], action,
        linewidth=linewidth,
        arrowheadlength=arrowheadlength,
        arrowheadangle=arrowheadangle,
        arrowheadfill=arrowheadfill,
        startarrow=startarrow,
        finisharrow=finisharrow,
        decoration = decoration,
        decorate = decorate,
        arrowheadfunction = arrowheadfunction)
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

"""
    tickline(startpos, finishpos;
        startnumber         = 0,
        finishnumber        = 1,
        major               = 1,
        minor               = 0,
        major_tick_function = nothing,
        minor_tick_function = nothing,
        rounding            = 2,
        axis                = true, # draw the line?
        log                 = false,
        vertices            = false # just return the points
        )

Draw a line with ticks. `major` is the number of ticks
required between the start and finish point. So `1` divides
the line in half. `minor` is the number of ticks between
each major tick.

## Examples

```
tickline(Point(0, 0), Point(100, 0))
tickline(Point(0, 0), Point(100, 0), major = 4)
majorticks, minorticks = tickline(Point(0, 0), Point(100, 0), axis=false)
```

## Custom ticks

Supply functions to make custom ticks. Custom tick functions
should have arguments as follows:

```
function mtick(n, pos;
        startnumber         = 0,
        finishnumber        = 1,
        nticks = 1)
        ...
```
and

```
function mntick(n, pos;
        startnumber        = 0,
        finishnumber       = 1,
        nticks             = 1,
        majorticklocations = [])
        ...
```

For example:

```
tickline(O - (300, 0), Point(300, 0),
    startnumber  = -10,
    finishnumber = 10,
    minor        = 0,
    major        = 4,
    axis         = false,
    major_tick_function = (n, pos;
        startnumber=30, finishnumber=40, nticks=10) -> begin
        @layer begin
            translate(pos)
            ticklength = get_fontsize()
            line(O, O + polar(ticklength, 3π/2), :stroke)
            k = rescale(n, 0, nticks - 1, startnumber, finishnumber)
            ticklength = get_fontsize() * 1.3
            text("\$(round(k, digits=2))",
                O + (0, ticklength),
                halign=:center,
                valign=:middle,
                angle = -getrotation())
        end
    end)
```
"""
function tickline(startpos, finishpos;
        startnumber         = 0,
        finishnumber        = 1,
        major               = 1,
        minor               = 0,
        major_tick_function = nothing,
        minor_tick_function = nothing,
        rounding            = 2,
        axis                = true,
        log                 = false,
        vertices            = false)

    # this function is too long
    # the default function to draw major ticks
    function _maj_func(n, pos;
        startnumber         = 0,
        finishnumber        = 1,
        nticks = 1)
        @layer begin
            translate(pos)
            ticklength = get_fontsize() * 2
            line(O, O + polar(ticklength, π/2), :stroke)
            k = rescale(n, 0, nticks - 1, startnumber, finishnumber)
            text("$(round(k, digits=rounding))",
                O + (0, ticklength * 1.3),
                halign=:center,
                valign=:top,
                angle = -getrotation())
        end
    end
    # default to draw minor ticks
    function _min_func(n, pos;
        startnumber        = 0,
        finishnumber       = 1,
        nticks             = 1,
        majorticklocations = Point[])
        @layer begin
            translate(pos)
            ticklength = get_fontsize()
            line(O, O + polar(ticklength, π/2), :stroke)
            k = rescale(n, 0, nticks - 1, startnumber, finishnumber)

            # if there's a major tick here, skip
            if pos ∈ majorticklocations

            else
                text("$(round(k, digits=rounding))",
                    O + (0, ticklength * 1.3),
                    halign=:center,
                    valign=:top,
                    angle=-getrotation())
            end
        end
    end

    if startnumber == finishnumber
        throw(error("tickline(): start and finish numbers should be different"))
    end

    @layer begin
        translate(startpos)
        rotate(slope(startpos, finishpos))
        newfinishpos =  O + polar(distance(startpos, finishpos), 0)

        # draw the axis
        if axis == true && vertices == false
            line(O, newfinishpos, :stroke)
        end

        # 1 major/minor division means 3 ticks (beginning, middle, end)

        if log == true
            majorticklocations = between.(O, newfinishpos, log10.(range(1, 10, length=(major+2))))
            n_minorticks = ((major + 1) * (minor + 1)) + 1
            minorticklocations = between.(O, newfinishpos, log10.(range(1, 10, length=n_minorticks)))
        else
            majorticklocations = between.(O, newfinishpos, range(0, 1, length=(major+2)))
            n_minorticks = ((major + 1) * (minor + 1)) + 1
            minorticklocations = between.(O, newfinishpos, range(0, 1, length=n_minorticks))
        end
        if vertices == true
        else
            # draw the ticks using the supplied functions, or the default ones
            if major > 0
                for (n, majorticklocation) in enumerate(majorticklocations)
                    if major_tick_function === nothing
                        _maj_func(n - 1, majorticklocation,
                            startnumber  = startnumber,
                            finishnumber = finishnumber,
                            nticks       = length(majorticklocations))
                    else
                        # start counting at 0, remember :)
                        major_tick_function(n - 1, majorticklocation,
                            startnumber  = startnumber,
                            finishnumber = finishnumber,
                            nticks       = length(majorticklocations))
                    end
                end
            end

            if minor >= 1
                for (n, minorticklocation) in enumerate(minorticklocations)
                    if minor_tick_function === nothing
                        _min_func(n - 1, minorticklocation,
                            startnumber  = startnumber,
                            finishnumber = finishnumber,
                            nticks = length(minorticklocations),
                            majorticklocations = majorticklocations)
                    else
                        # start counting at 0!
                        minor_tick_function(n - 1, minorticklocation,
                            startnumber  = startnumber,
                            finishnumber = finishnumber,
                            nticks = length(minorticklocations),
                            majorticklocations = majorticklocations)
                    end
                end
            end # minor
        end # vertices = true
    end # layer
    # calculate where the tick locations would be in reality
    majpts = map(pt -> rotate_point_around_point(Point(startpos.x + pt.x, startpos.y + pt.y), startpos, slope(startpos, finishpos)), majorticklocations)
    minpts = map(pt -> rotate_point_around_point(Point(startpos.x + pt.x, startpos.y + pt.y), startpos, slope(startpos, finishpos)), minorticklocations)
    return (majpts, minpts)
end
