# text
# the 'toy' API... "Any serious application should avoid them." :)

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

`:halign` can be `:left`, `:center`, or `:right`. `:valign` can be `:baseline`, `:top`,
`:middle`, or `:bottom`.

However, the `:valign` doesn't work properly because we're using
Cairo's so-called "toy" interface... :(
"""
function text(t, x=0.0, y=0.0; halign=:left, valign=:baseline)
    wdfactor = 0.0
    htfactor = 0.0
    textents = textextents(t)
    halign == :left         && (wdfactor = 0.0)
    halign == :center       && (wdfactor = 0.5)
    halign == :right        && (wdfactor = 1.0)
    valign == :baseline     && (htfactor = 0.0)
    valign == :top          && (htfactor = -1.0)
    valign == :middle       && (htfactor = 0.5)
    valign == :bottom       && (htfactor = 1.0)
    textpointx = x - (wdfactor * (textents[3]))
    textpointy = y - (htfactor * textents[4])
    gsave()
    Cairo.move_to(currentdrawing.cr, textpointx, textpointy)
    Cairo.show_text(currentdrawing.cr, t)
    grestore()
end

text(t, pt::Point; kwargs...) = text(t, pt.x, pt.y; kwargs...)

"""
    textcentred(str)
    textcentred(str, x, y)
    textcentred(str, pt)

Draw text in the string `str` centered at `x`/`y` or `pt`. If you omit the point, it's
placed at 0/0.

Text doesn't affect the current point!
"""
function textcentred(t, x=0, y=0)
  text(t, x, y, halign=:center)
end

textcentred(t, pt::Point) = textcentred(t, pt.x, pt.y)
textcentered = textcentred

"""
    textright(str)
    textright(str, x, y)
    textright(str, pt)

Draw text in the string `str` right-aligned at `x`/`y` or `pt`.
If you omit the point, it's placed at 0/0.

Text doesn't affect the current point!
"""
function textright(t, x=0, y=0)
  text(t, x, y, halign=:right)
end

textright(t, pt::Point) = textright(t, pt.x, pt.y)

"""
    fontface(fontname)

Select a font to use. If the font is unavailable, it defaults to Helvetica/San Francisco
(on macOS).
"""
fontface(f) = Cairo.select_font_face(currentdrawing.cr, f, Cairo.FONT_SLANT_NORMAL, Cairo.FONT_WEIGHT_NORMAL)

"""
    fontsize(n)

Set the font size to `n` points. Default is 10pt.

"""
fontsize(n) = Cairo.set_font_size(currentdrawing.cr, n)

"""
    textextents(str)

Return the measurements of the string `str` when set using the current font settings:

1 x_bearing
2 y_bearing
3 width
4 height
5 x_advance
6 y_advance

The bearing is the displacement from the reference point to the upper-left corner of the
bounding box. It is often zero or a small positive value for x displacement, but can be
negative x for characters like j; it's almost always a negative value for y displacement.

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

`start_angle` is relative to +ve x-axis, arc/circle is centred on `(x_pos,y_pos)` with
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
        angle_step += (glyph_x_advance / 2.) + letter_spacing/2.
        if clockwise
            refangle += angle_step / current_radius
        else
            refangle -= angle_step / current_radius
        end
        angle_step = (glyph_x_advance / 2.) + letter_spacing/2.
        xx = cos(refangle) * current_radius + x_pos
        yy = sin(refangle) * current_radius + y_pos
        gsave()
        translate(xx, yy)
        if clockwise
            rotate(pi/2. + refangle)
        else
            rotate(-pi/2. + refangle)
        end
        textcentred(glyph, 0., 0.)
        grestore()
        current_radius < 10. && break
    end
end

textcurve(the_text, start_angle, start_radius, centre::Point; kwargs...) =
  textcurve(the_text, start_angle, start_radius, centre.x, centre.y; kwargs...)

"""
    textcurvecentered(the_text, start_angle, start_radius, center::Point;
          clockwise = true,
          letter_spacing = 0,
          baselineshift = 0

This version of the `textcurve()` function is designed for shorter text strings that need
positioning around a circle. (A cheesy effect much beloved of hipster brands and
retronauts.)

`letter_spacing` adjusts the tracking/space between chars, tighter is (-), looser is (+)).
`baselineshift` moves the text up or down away from the baseline.

The letter spacing is not taken into account when first positioning the text.
"""
function textcurvecentered(the_text, start_angle, start_radius, center::Point;
      clockwise = true,
      letter_spacing = 0,
      baselineshift = 0
      )
    atextbox = textextents(the_text)
    atextwidth = atextbox[3]                         # width of text
    if clockwise
        baselineradius = start_radius + baselineshift  # could be adjusted if we knew font height
    else
        baselineradius = start_radius - baselineshift  # could be adjusted if we knew font height
    end

    theta = atextwidth/baselineradius               # find angle
    if clockwise
        starttextangle = start_angle - (theta/2)
    else
        starttextangle = start_angle + (theta/2)
    end
    starttextxpos = baselineradius * cos(starttextangle)
    starttextypos = baselineradius * sin(starttextangle)
    textcurve(the_text, starttextangle, baselineradius, center,
        clockwise=clockwise, letter_spacing=letter_spacing)
end

# end
