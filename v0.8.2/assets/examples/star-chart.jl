#!/usr/bin/env julia

# probably best to cd to `.julia/v0.5/Luxor/` first ...

using ColorSchemes, DataFrames, Luxor,  Colors

"""
change an RA value from 24 -> 0 to left edge -> right edge allowing for margin
"""

function rascale(n)
    rescale(n, 0, 24, (width/2) - margin, -(width/2) + margin)
end

"""
change a Declination value from -90 to 90
"""

function decscale(n)
    rescale(n, -90, 90, (height/2) - margin, (-height/2) + margin)
end

function magscale(n, highest_mag)
    # change mag value
    # lowest is about -2 (Sirius)
    # biggest circle 3, smallest 0.1
    rescale((2 + n), 0, highest_mag, 1.5, 0.01)
end

function drawgrid(theme)
    gsave()
    setline(theme[:gridline_width])
    sethue(theme[:gridline_color])
    fontsize(theme[:grid_label_font_size])
    fontface(theme[:grid_label_font_face])
    setopacity(theme[:grid_line_opacity])
    # vertical rules
    if  true # originally a test for rectangular or polar grids
        # rectangular
        # vertical lines for each RA value
        for ra in 0:24
            move(rascale(ra), -height/2 + margin)
            line(rascale(ra),  height/2 - margin)
            strokepath()
            gsave()
            sethue(theme[:grid_label_font_color])
            setopacity(theme[:grid_label_font_opacity])
            text(string(ra), rascale(ra),  -(height/2) + 40)
            text(string(ra), rascale(ra),   (height/2) - 40)
            grestore()
        end
        # horizontal lines for each declination tick
        for dec in -90:10:90
            move(-width/2 + margin, decscale(dec))
            line(width/2 - margin, decscale(dec))
            strokepath()
            gsave()
            sethue(theme[:grid_label_font_color])
            setopacity(theme[:grid_label_font_opacity])
            text(string(dec), width/2 - margin/2, decscale(dec))
            text(string(dec), -(width/2) + margin/2, decscale(dec))
            grestore()
        end
    end
    grestore()
end

function drawstars(table, theme)
  global starcounter
  for star in eachrow(table)
    starcounter += 1
    proper, ra, dec, mag, ci = map(last, star)
    if mag < -2 # don't draw the Sun ! :)
        continue
    end
    if !isna(ci)
        # set color of star
        #=
        1.41	M0	Red
        0.82	K0	Orange
        0.59	G0	Yellow
        0.31	F0	Yellowish
        0.00	A0	White
        -0.29	B0	Blue
        =#
        # rescale: blue is 0, red is 1
        sethue(get(theme[:starcolorscheme], rescale(ci, -0.3, 1.5, 0, 1)))
    else
        sethue("grey50")
    end
    circle(rascale(ra), decscale(dec), magscale(mag, highest_mag), :fill)
    # text labels for stars if mag is big enough
    fontface(theme[:starname_font_face])
    fontsize(theme[:starname_font_size])
    if isna(proper)
        # this star has no name
    else
        if mag <=  theme[:star_min_mag_label_size]
            fontsize(theme[:starname_font_size] - mag/10)
            sethue(theme[:starname_font_color])
            rect(rascale(ra), decscale(dec), 0.2, -5, :fill)
            text(proper, rascale(ra), decscale(dec) - 5)
        end
    end
  end
end

function drawconstellation(constell, theme)
  sethue(theme[:constellation_boundary_stroke_color])
  setline(theme[:constellation_boundary_stroke_width])
  v = constellation_boundaries[constell]
  realconstellationname = first(constellation_names[constell])
  gsave()
  setdash(theme[:constellation_boundary_stroke_pattern])
  for pgon in v
      pgon_scaled = map(pt -> Point(rascale((pt.x)/3600), decscale((pt.y)/3600)), pgon)
      pgon_scaled = map(pt -> Point(round(Int, pt.x), round(Int, pt.y)),  pgon_scaled)
      poly(pgon_scaled, close=true, :stroke)
      sethue(theme[:constellation_name_font_color])
      poly(pgon_scaled, close=true, :stroke)
      centrep = polycentroid(pgon_scaled)
      setopacity(theme[:constellation_name_opacity])
      fontsize(theme[:constellation_name_font_size])
      fontface(theme[:constellation_name_font_face])
      sethue(theme[:constellation_name_font_color])
      # draw text
      textcentred(string(realconstellationname), centrep)
  end
  grestore()
end

function main(d, w, h, margin, highest_mag)
  d1 = d[d[:mag] .< highest_mag, [:proper, :ra, :dec, :mag, :ci]]

  # all rows which have constellations
  # d[complete_cases(d[:,[:con]]), :]
  ## d[complete_cases(d[:,[:con, :proper]]), :]

  # a theme controls all the fills and strokes
  # this is the default theme
  default_theme = Dict(
      :name                                   => "bright stars on dark background",
      :highest_magnitude                      => 15,
      :starcolorscheme                        => ColorSchemes.thermometer,
      :starname_font_face                     => "Times-Italic",
      :starname_font_size                     => 12,
      :starname_font_color                    => "grey90",
      :star_min_mag_label_size                => 6,
      :background_color                       => "black",
      :constellation_name_opacity             => 0.8,
      :constellation_boundary_stroke_color    => "blue",
      :constellation_boundary_fill_color      => "",
      :constellation_boundary_stroke_pattern  => "solid",
      :constellation_boundary_stroke_width    => 0.2,
      :constellation_name_font_face           => "BodoniMT-UltraBold",
      :constellation_name_font_size           => 26,
      :constellation_name_font_color          => "grey90",
      :gridline_color                         => "red",
      :gridline_width                         => .2,
      :gridline_pattern                       => "dot",
      :grid_label_font_face                   => "BodoniMT-UltraBold",
      :grid_label_font_size                   => 12,
      :grid_label_font_color                  => "grey90",
      :grid_label_font_opacity                => 1.0,
      :grid_line_opacity                      => 0.3
  )

  antique_theme = Dict(
      :name                                   => "antique theme",
      :highest_magnitude                      => 10,
      :starcolorscheme                        => ColorSchemes.thermometer,
      :starname_font_face                     => "InputMono-Medium",
      :starname_font_size                     => 9,
      :starname_font_color                    => "grey30",
      :star_min_mag_label_size                => 10,
      :background_color                       => "ivory",
      :constellation_name_opacity             => 0.8,
      :constellation_boundary_stroke_color    => "orange",
      :constellation_boundary_fill_color      => "",
      :constellation_boundary_stroke_pattern  => "solid",
      :constellation_boundary_stroke_width    => 0.4,
      :constellation_name_font_face           => "BodoniMT-UltraBold",
      :constellation_name_font_size           => 25,
      :constellation_name_font_color          => "Grey70",
      :gridline_color                         => "blue",
      :gridline_width                         => .2,
      :gridline_pattern                       => "dotted",
      :grid_label_font_face                   => "BodoniMT-UltraBold",
      :grid_label_font_size                   => 14,
      :grid_label_font_color                  => "grey40",
      :grid_label_font_opacity                => 1.0,
      :grid_line_opacity                      => 0.2
  )

  Drawing(width, height, "/tmp/starmap.pdf")
  origin()
  global starcounter = 0
  theme=default_theme
  background(theme[:background_color])
  drawgrid(theme)
  x = -width/2 + 350
  y = -height/2 + 350
  for k in collect(keys(constellation_boundaries))[1:end]
      gsave()
      drawconstellation(k, theme)
      grestore()
  end

  drawstars(d1, theme)

  finish()
  preview()
end

# constallation boundaries
# some constellations are in two parts
# coordinates are in RA seconds float and Declination seconds float

info("loading constellations")
tic()
include("constellations.jl")
toc()

info("loading star data")

# for convenience I copied this file from https://github.com/astronexus/HYG-Database

astrodbfile = "docs/examples/hygdata_v3.csv"

tic()
db = readtable(astrodbfile, header = true)
toc()

width, height = 4000, 2000
margin = 80
highest_mag = 15

info("drawing chart")
tic()
main(db, width, height, margin, highest_mag)
toc()
@show starcounter
