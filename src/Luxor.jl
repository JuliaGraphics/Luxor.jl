"""
The Luxor package provides a set of vector drawing functions for creating graphical documents.
"""
module Luxor

import Base: fill

using Juno

using Colors, FileIO, Dates

using Cairo

#= from Cairo use: CairoARGBSurface, CairoEPSSurface, CairoMatrix, CairoPDFSurface,
CairoPattern, CairoPatternMesh, CairoSurface, CairoSVGSurface,
CairoContext, arc, arc_negative, circle, clip, clip_preserve, close_path,
convert_cairo_path_data, copy_path, copy_path_flat, curve_to, destroy, fill,
fill_preserve, finish, get_matrix, get_operator, height, image, line_to,
mesh_pattern_begin_patch, mesh_pattern_curve_to, mesh_pattern_end_patch,
mesh_pattern_line_to, mesh_pattern_move_to, mesh_pattern_set_corner_color_rgba,
move_to, new_path, new_sub_path,paint, paint_with_alpha,
pattern_add_color_stop_rgba, pattern_create_linear, pattern_create_radial,
read_from_png, rectangle, rel_line_to, rel_move_to, reset_clip, restore, rotate,
save, scale, select_font_face, set_antialias, set_font_face, set_font_size,
set_line_cap, set_line_join, set_line_type, set_line_width, set_matrix,
set_operator, set_source, set_source_rgba, set_source_surface, show_text,
status, stroke, stroke_preserve, text, text_extents, text_path, translate,
width, write_to_png =#

include("point.jl")
include("basics.jl")
include("Turtle.jl")
include("shapes.jl")
include("polygons.jl")
include("curves.jl")
include("tiles-grids.jl")
include("arrows.jl")
include("text.jl")
include("blends.jl")
include("matrix.jl")
include("juliagraphics.jl")
include("colors_styles.jl")
include("images.jl")
include("animate.jl")
include("bars.jl")
include("bezierpath.jl")
include("mesh.jl")
include("Table.jl")
include("BoundingBox.jl")
include("Boxmaptile.jl")
include("noise.jl")
include("deprecations.jl")
#include("shapefile.jl") # don't load unless you've loaded Shapefile.jl

export Drawing, currentdrawing,
    cm, inch, mm,
    paper_sizes,
    Tiler, Partition,
    rescale,

    finish, preview,
    origin, rulers, background,

    @png, @pdf, @svg,

    newpath, closepath, newsubpath,

    BezierPath, BezierPathSegment, bezier, bezier′, bezier′′, makebezierpath, drawbezierpath, bezierpathtopoly, beziertopoly, pathtobezierpaths,
    bezierfrompoints, beziercurvature, bezierstroke, setbezierhandles, shiftbezierhandles, brush,

    strokepath, fillpath,

    rect, box, cropmarks,

    setantialias, setline, setlinecap, setlinejoin, setdash,

    move, rmove, line, rule, rline, arrow,

    BoundingBox, boundingbox, boxwidth, boxheight, boxdiagonal, boxaspectratio, boxtop, boxbottom,

    Boxmaptile, boxmap,

    circle, circlepath, ellipse, hypotrochoid, epitrochoid, squircle, center3pts, curve,
    arc, carc, arc2r, carc2r, spiral, sector, intersection2circles,
    intersection_line_circle, intersectionlinecircle, intersectioncirclecircle, ispointonline,
    intersectlinepoly, polyintersections, circlepointtangent, circletangent2circles,

    intersectboundingboxes, boundingboxesintersect,

    ngon, ngonside, star, pie,
    do_action, paint, paint_with_alpha, fillstroke,

    Point, O, randompoint, randompointarray, midpoint, between, slope, intersection,
    pointlinedistance, getnearestpointonline, isinside,
    perpendicular, crossproduct, dotproduct, distance,
    prettypoly, polysmooth, polysplit, poly, simplify,  polycentroid,
    polysortbyangle, polysortbydistance, offsetpoly, polyfit,

    polyperimeter, polydistances, polyportion, polyremainder, nearestindex,
    polyarea, polysample,

    @polar, polar,

    strokepreserve, fillpreserve,
    gsave, grestore, @layer,
    scale, rotate, translate,
    clip, clippreserve, clipreset,

    getpath, getpathflat, pathtopoly,

    fontface, fontsize, text, textpath, label,
    textextents, textcurve, textcentred, textcentered, textright,
    textcurvecentred, textcurvecentered,
    textwrap, textlines, splittext, textbox,

    setcolor, setopacity, sethue, setgrey, setgray,
    randomhue, randomcolor, @setcolor_str,
    getmatrix, setmatrix, transform,

    setfont, settext,

    Blend, setblend, blend, addstop, blendadjust,
    blendmatrix, rotationmatrix, scalingmatrix, translationmatrix,
    cairotojuliamatrix, juliatocairomatrix, getrotation, getscale, gettranslation,

    setmode, getmode,

    GridHex, GridRect, nextgridpoint,

    Table,
    readpng, placeimage,

    julialogo, juliacircles,

    bars,

    mesh, setmesh,

    # animation
    Sequence, Movie, Scene, animate,

    lineartween, easeinquad, easeoutquad, easeinoutquad, easeincubic, easeoutcubic,
    easeinoutcubic, easeinquart, easeoutquart, easeinoutquart, easeinquint, easeoutquint,
    easeinoutquint, easeinsine, easeoutsine, easeinoutsine, easeinexpo, easeoutexpo,
    easeinoutexpo, easeincirc, easeoutcirc, easeinoutcirc, easingflat, easeinoutinversequad,

    # noise
    noise

# basic unit conversion to Cairo/PostScript points
const inch = 72.0
const cm = 28.3464566929
const mm = 2.83464566929

mutable struct Drawing
    width::Float64
    height::Float64
    filename::String
    surface::CairoSurface
    cr::CairoContext
    surfacetype::Symbol
    redvalue::Float64
    greenvalue::Float64
    bluevalue::Float64
    alpha::Float64
    buffer::IOBuffer # Keeping both buffer and data because I think the buffer might get GC'ed otherwise
    bufferdata::AbstractArray{UInt8,1} # Direct access to data

    function Drawing(w, h, stype::Symbol, f::AbstractString="")
        global currentdrawing
        bufdata = UInt8[]
        iobuf = IOBuffer(bufdata, read=true, write=true)
        the_surfacetype = stype
        if stype == :pdf
            the_surface     =  Cairo.CairoPDFSurface(iobuf, w, h)
        elseif stype == :png # default to PNG
            the_surface     = Cairo.CairoARGBSurface(w,h)
        elseif stype == :eps
            the_surface     = Cairo.CairoEPSSurface(iobuf, w,h)
        elseif stype == :svg
            the_surface     = Cairo.CairoSVGSurface(iobuf, w,h)
        else
            error("Unknown Luxor surface type $stype")
        end
        the_cr  = Cairo.CairoContext(the_surface)
        # @info("drawing '$f' ($w w x $h h) created in $(pwd())")
        currentdrawing      = new(w, h, f, the_surface, the_cr, the_surfacetype, 0.0, 0.0, 0.0, 1.0, iobuf, bufdata)
        return currentdrawing
    end
end

function Base.show(io::IO, d::Luxor.Drawing)
  print(io, """\n    width:    $(d.width)
    height:   $(d.height)
    filename: $(d.filename)
    type:     $(d.surfacetype)
""")
end

# How Luxor output works. You start by creating a drawing either aimed at a
# file (PDF, EPS, PNG, SVG) or aimed at an in-memory buffer (:SVG and :PNG); you
# could be working in Jupyter or Atom, or a terminal, and on either Mac, Linux,
# or Windows.  (The @svg/@png/@pdf macros are shortcuts to file-based drawings.)
# When a drawing is finished, you go `finish()` (that's the last line of the
# @... macros.). Then, if you want to see it, you go `preview()`. Then the code
# decides where you're working, and what type of file it is, then sends it to the
# right place, depending on the OS.

# in memory:

Base.showable(::MIME"image/svg+xml",d::Luxor.Drawing) = d.surfacetype == :svg
Base.showable(::MIME"image/png", d::Luxor.Drawing) = d.surfacetype == :png

# file-based

function Base.show(f::IO, ::MIME"image/svg+xml", d::Luxor.Drawing)
    write(f, d.bufferdata)
end

function Base.show(f::IO, ::MIME"image/png", d::Luxor.Drawing)
    write(f, d.bufferdata)
end

"""
The `paper_sizes` Dictionary holds a few paper sizes, width is first, so default is Portrait:

```
"A0"      => (2384, 3370),
"A1"      => (1684, 2384),
"A2"      => (1191, 1684),
"A3"      => (842, 1191),
"A4"      => (595, 842),
"A5"      => (420, 595),
"A6"      => (298, 420),
"A"       => (612, 792),
"Letter"  => (612, 792),
"Legal"   => (612, 1008),
"Ledger"  => (792, 1224),
"B"       => (612, 1008),
"C"       => (1584, 1224),
"D"       => (2448, 1584),
"E"       => (3168, 2448))
```
"""
paper_sizes = Dict{String, Tuple}(
  "A0"     => (2384, 3370),
  "A1"     => (1684, 2384),
  "A2"     => (1191, 1684),
  "A3"     => (842, 1191),
  "A4"     => (595, 842),
  "A5"     => (420, 595),
  "A6"     => (298, 420),
  "A"      => (612, 792),
  "Letter" => (612, 792),
  "Legal"  => (612, 1008),
  "Ledger" => (792, 1224),
  "B"      => (612, 1008),
  "C"      => (1584, 1224),
  "D"      => (2448, 1584),
  "E"      => (3168, 2448))

"""
Create a new drawing, and optionally specify file type (PNG, PDF, SVG, or EPS) and dimensions.

    Drawing()

creates a drawing, defaulting to PNG format, default filename "luxor-drawing.png",
default size 800 pixels square.

You can specify the dimensions, and assume the default output filename:

    Drawing(400, 300)

creates a drawing 400 pixels wide by 300 pixels high, defaulting to PNG format, default
filename "luxor-drawing.png".

    Drawing(400, 300, "my-drawing.pdf")

creates a PDF drawing in the file "my-drawing.pdf", 400 by 300 pixels.

    Drawing(1200, 800, "my-drawing.svg")`

creates an SVG drawing in the file "my-drawing.svg", 1200 by 800 pixels.

    Drawing(width, height, surfacetype, [filename])

creates a new drawing of the given surface type (e.g. :svg, :png), storing the image only in memory if no filename is provided.

    Drawing(1200, 1200/Base.Mathconstants.golden, "my-drawing.eps")

creates an EPS drawing in the file "my-drawing.eps", 1200 wide by 741.8 pixels (= 1200 ÷ ϕ)
high. Only for PNG files must the dimensions be integers.

    Drawing("A4", "my-drawing.pdf")

creates a drawing in ISO A4 size (595 wide by 842 high) in the file "my-drawing.pdf".
Other sizes available are:  "A0", "A1", "A2", "A3", "A4", "A5", "A6", "Letter", "Legal",
"A", "B", "C", "D", "E". Append "landscape" to get the landscape version.

    Drawing("A4landscape")

creates the drawing A4 landscape size.

PDF files default to a white background, but PNG defaults to transparent, unless you specify
one using `background()`.
"""
function Drawing(w=800.0, h=800.0, f::String="luxor-drawing.png")
    global currentdrawing
    (path, ext)         = splitext(f)
    currentdrawing = Drawing(w, h, Symbol(ext[2:end]), f)
    return currentdrawing
end
function Drawing(paper_size::String, f="luxor-drawing.png")
  if occursin("landscape", paper_size)
    psize = replace(paper_size, "landscape" => "")
    h, w = paper_sizes[psize]
  else
    w, h = paper_sizes[paper_size]
  end
  Drawing(w, h, f)
end

"""
    finish()

Finish the drawing, and close the file. You may be able to open it in an external viewer
application with `preview()`.
"""
function finish()
    if currentdrawing.surface.ptr == C_NULL
        # Already finished
        return false
    end
    if currentdrawing.surfacetype == :png
        Cairo.write_to_png(currentdrawing.surface, currentdrawing.buffer)
    end

    Cairo.finish(currentdrawing.surface)
    Cairo.destroy(currentdrawing.surface)

    if currentdrawing.filename != ""
        write(currentdrawing.filename, currentdrawing.bufferdata)
    end

    return true
end

"""
    preview()

If working in Jupyter (IJulia), display a PNG or SVG file in the notebook.

If working in Juno, display a PNG or SVG file in the Plot pane.

Otherwise:

- on macOS, open the file in the default application, which is probably the Preview.app for
  PNG and PDF, and Safari for SVG
- on Unix, open the file with `xdg-open`
- on Windows, pass the filename to `explorer`.
"""
function preview()
    in(currentdrawing.surfacetype, [:png, :svg]) ? candisplay = true : candisplay = false
    (isdefined(Main, :IJulia) && Main.IJulia.inited) ? jupyter = true : jupyter = false
    Juno.isactive() ? juno = true : juno = false
    if candisplay && jupyter
        Main.IJulia.clear_output(true)
        returnvalue = nothing
        if currentdrawing.surfacetype == :png
            # avoid world age errors
            Base.invokelatest(display, "image/png", load(currentdrawing.filename))
        elseif currentdrawing.surfacetype == :svg
            open(currentdrawing.filename) do f
                display("image/svg+xml", read(f, String))
            end
        end
    elseif candisplay && juno
        display(currentdrawing)
        returnvalue = nothing
    elseif Sys.isapple()
        run(`open $(currentdrawing.filename)`)
        returnvalue = currentdrawing.filename
    elseif Sys.iswindows()
        run(ignorestatus(`explorer $(currentdrawing.filename)`))
        returnvalue = currentdrawing.filename
    elseif Sys.isunix()
        run(`xdg-open $(currentdrawing.filename)`)
        returnvalue = currentdrawing.filename
    end
    return returnvalue
end

"""
    @svg drawing-instructions [width] [height] [filename]

Create and preview an SVG drawing, optionally specifying width and height (the
default is 600 by 600). The file is saved in the current working directory as
`filename` if supplied, or `luxor-drawing-(timestamp).svg`.

Examples

    @svg circle(O, 20, :fill)

    @svg circle(O, 20, :fill) 400

    @svg circle(O, 20, :fill) 400 1200

    @svg circle(O, 20, :fill) 400 1200 "images/test.svg"

    @svg begin
            setline(10)
            sethue("purple")
            circle(O, 20, :fill)
         end


    @svg begin
            setline(10)
            sethue("purple")
            circle(O, 20, :fill)
         end 1200, 1200
"""
macro svg(body, width=600, height=600, fname="luxor-drawing-$(Dates.format(Dates.now(), "HHMMSS_s")).svg")
     quote
        Drawing($width, $height, $fname)
        origin()
        background("white")
        sethue("black")
        $(esc(body))
        finish()
        preview()
    end
end

"""
    @png drawing-instructions [width] [height] [filename]

Create and preview an PNG drawing, optionally specifying width and height (the
default is 600 by 600). The file is saved in the current working directory as
`filename`, if supplied, or `luxor-drawing(timestamp).png`.

Examples

    @png circle(O, 20, :fill)

    @png circle(O, 20, :fill) 400

    @png circle(O, 20, :fill) 400 1200

    @png circle(O, 20, :fill) 400 1200 "images/round.png"

    @png begin
            setline(10)
            sethue("purple")
            circle(O, 20, :fill)
         end


    @png begin
            setline(10)
            sethue("purple")
            circle(O, 20, :fill)
         end 1200 1200
"""
macro png(body, width=600, height=600, fname="luxor-drawing-$(Dates.format(Dates.now(), "HHMMSS_s")).png")
     quote
        Drawing($width, $height, $fname)
        origin()
        background("white")
        sethue("black")
        $(esc(body))
        finish()
        preview()
    end
end

"""
    @pdf drawing-instructions [width] [height] [filename]

Create and preview an PDF drawing, optionally specifying width and height (the
default is 600 by 600). The file is saved in the current working directory as
`filename` if supplied, or `luxor-drawing(timestamp).pdf`.

Examples

    @pdf circle(O, 20, :fill)

    @pdf circle(O, 20, :fill) 400

    @pdf circle(O, 20, :fill) 400 1200

    @pdf circle(O, 20, :fill) 400 1200 "images/A0-version.pdf"

    @pdf begin
            setline(10)
            sethue("purple")
            circle(O, 20, :fill)
         end

    @pdf begin
            setline(10)
            sethue("purple")
            circle(O, 20, :fill)
         end 1200, 1200
"""
macro pdf(body, width=600, height=600, fname="luxor-drawing-$(Dates.format(Dates.now(), "HHMMSS_s")).pdf")
     quote
        Drawing($width, $height, $fname)
        origin()
        background("white")
        sethue("black")
        $(esc(body))
        finish()
        preview()
    end
end

end # module
