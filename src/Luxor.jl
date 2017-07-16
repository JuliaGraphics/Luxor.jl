__precompile__()

"""
The Luxor package provides a set of vector drawing functions for creating graphical documents.
"""
module Luxor

# as of Julia version 0.4, we still have to share fill() and scale() with Base.
# as of Julia version 0.6, we still have to share fill() with Base.
# fill() is deprecated, replaced with fillpath()

import Base: fill

if isdefined(Base, :scale)
    import Base: scale
end

using Colors, Cairo, Compat, FileIO, Juno

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
#include("shapefile.jl")

@deprecate fill() fillpath()
@deprecate stroke() strokepath()

export Drawing, currentdrawing,
    cm, inch, mm,
    paper_sizes,
    Tiler, Partition,
    rescale,

    finish, preview,
    origin, axes, background,

    @png, @pdf, @svg,

    newpath, closepath, newsubpath,

    strokepath, fillpath, # stroke, fill are now deprecated

    rect, box, cropmarks,

    setantialias, setline, setlinecap, setlinejoin, setdash,

    move, rmove, line, rule, rline, arrow,

    circle, circlepath, ellipse, hypotrochoid, epitrochoid, squircle, center3pts, curve,
    arc, carc, arc2r, carc2r, spiral, sector,

    ngon, star, pie,
    do_action, paint, paint_with_alpha, fillstroke,

    Point, O, randompoint, randompointarray, midpoint, between, slope, intersection,
    intersection_line_circle, pointlinedistance, getnearestpointonline, isinside,
    perpendicular, crossproduct,
    prettypoly, polysmooth, polysplit, poly, simplify, polybbox, polycentroid,
    polysortbyangle, polysortbydistance, offsetpoly, polyfit,

    polyperimeter, polydistances, polyportion, polyremainder, nearestindex,
    polyarea,

    @polar, polar,

    strokepreserve, fillpreserve,
    gsave, grestore, @layer,
    scale, rotate, translate,
    clip, clippreserve, clipreset,

    getpath, getpathflat, pathtopoly,

    fontface, fontsize, text, textpath,
    textextents, textcurve, textcentred, textcentered, textright,
    textcurvecentred, textcurvecentered,
    setcolor, setopacity, sethue, setgrey, setgray,
    randomhue, randomcolor, @setcolor_str,
    getmatrix, setmatrix, transform,

    setfont, settext,

    Blend, setblend, blend, addstop, blendadjust,
    blendmatrix, rotationmatrix, scalingmatrix, translationmatrix,
    cairotojuliamatrix, juliatocairomatrix, getrotation, getscale, gettranslation,

    setmode, getmode,

    GridHex, GridRect, nextgridpoint,

    readpng, placeimage,

    julialogo, juliacircles,

    bars,

    # animation
    Sequence, Movie, Scene, animate,

    lineartween, easeinquad, easeoutquad, easeinoutquad, easeincubic, easeoutcubic,
    easeinoutcubic, easeinquart, easeoutquart, easeinoutquart, easeinquint, easeoutquint,
    easeinoutquint, easeinsine, easeoutsine, easeinoutsine, easeinexpo, easeoutexpo,
    easeinoutexpo, easeincirc, easeoutcirc, easeinoutcirc, easingflat

# basic unit conversion to Cairo/PostScript points
const inch = 72.0
const cm = 28.3464566929
const mm = 2.83464566929

type Drawing
    width::Float64
    height::Float64
    filename::String
    surface::CairoSurface
    cr::CairoContext
    surfacetype::String
    redvalue::Float64
    greenvalue::Float64
    bluevalue::Float64
    alpha::Float64
    function Drawing(w=800.0, h=800.0, f="luxor-drawing.png")
        global currentdrawing
        (path, ext)         = splitext(f)
        if ext == ".pdf"
            the_surface     =  Cairo.CairoPDFSurface(f, w, h)
            the_surfacetype = "pdf"
            the_cr          =  Cairo.CairoContext(the_surface)
        elseif ext == ".png" || ext == "" # default to PNG
            the_surface     = Cairo.CairoARGBSurface(w,h)
            the_surfacetype = "png"
            the_cr          = Cairo.CairoContext(the_surface)
        elseif ext == ".eps"
            the_surface     = Cairo.CairoEPSSurface(f, w,h)
            the_surfacetype = "eps"
            the_cr          = Cairo.CairoContext(the_surface)
        elseif ext == ".svg"
            the_surface     = Cairo.CairoSVGSurface(f, w,h)
            the_surfacetype = "svg"
            the_cr          = Cairo.CairoContext(the_surface)
        end
        # info("drawing '$f' ($w w x $h h) created in $(pwd())")
        currentdrawing      = new(w, h, f, the_surface, the_cr, the_surfacetype, 0.0, 0.0, 0.0, 1.0)
        return currentdrawing
    end
end

function Base.show(io::IO, d::Luxor.Drawing)
  print(io, """    width:    $(d.width)
    height:   $(d.height)
    filename: $(d.filename)
    type:     $(d.surfacetype)
    color:    ($(d.redvalue), $(d.greenvalue), $(d.bluevalue), $(d.alpha))
""")
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

    Drawing(1200, 1200/golden, "my-drawing.eps")

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
function Drawing(paper_size::String, f="luxor-drawing.png")
  if contains(paper_size, "landscape")
    psize = replace(paper_size, "landscape", "")
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
    if currentdrawing.surfacetype == "png"
        Cairo.write_to_png(currentdrawing.surface, currentdrawing.filename)
    end

    Cairo.finish(currentdrawing.surface)
    Cairo.destroy(currentdrawing.surface)

    return true
end

# Juno support

include("atom.jl")

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
    in(currentdrawing.surfacetype, ["png", "svg"]) ? candisplay = true : candisplay = false
    (isdefined(Main, :IJulia) && Main.IJulia.inited) ? jupyter = true : jupyter = false
    Juno.isactive() ? juno = true : juno = false
    if candisplay && jupyter
        Main.IJulia.clear_output(true)
        if currentdrawing.surfacetype == "png"
            display("image/png", load(currentdrawing.filename))
        elseif currentdrawing.surfacetype == "svg"
            open(currentdrawing.filename) do f
                display("image/svg+xml", readstring(f))
            end
        end
    elseif candisplay && juno
        display(currentdrawing)
    elseif @compat is_apple()
        run(`open $(currentdrawing.filename)`)
    elseif @compat is_windows()
        run(ignorestatus(`explorer $(currentdrawing.filename)`))
    elseif @compat is_unix()
        run(`xdg-open $(currentdrawing.filename)`)
    end
end

"""
    @svg drawing-instructions [width] [height]

Create and preview an SVG drawing, optionally specifying width and height (the default is
600 by 600). The file is saved in the current working directory as `luxor-drawing.svg`.

Examples

    @svg circle(O, 20, :fill)

    @svg circle(O, 20, :fill) 400

    @svg circle(O, 20, :fill) 400 1200

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

macro svg(body, width=600, height=600)
     quote
        Drawing($width, $height, "luxor-drawing.svg")
        origin()
        background("white")
        sethue("black")
        $(esc(body))
        finish()
        preview()
    end
end

"""
    @png drawing-instructions [width] [height]

Create and preview an PNG drawing, optionally specifying width and height (the default is
600 by 600). The file is saved in the current working directory as `luxor-drawing.png`.

Examples

    @png circle(O, 20, :fill)

    @png circle(O, 20, :fill) 400

    @png circle(O, 20, :fill) 400 1200

    @png begin
            setline(10)
            sethue("purple")
            circle(O, 20, :fill)
         end


    @png begin
            setline(10)
            sethue("purple")
            circle(O, 20, :fill)
         end 1200, 1200
"""

macro png(body, width=600, height=600)
     quote
        Drawing($width, $height, "luxor-drawing.png")
        origin()
        background("white")
        sethue("black")
        $(esc(body))
        finish()
        preview()
    end
end

"""
    @pdf drawing-instructions [width] [height]

Create and preview an PDF drawing, optionally specifying width and height (the default is
600 by 600). The file is saved in the current working directory as `luxor-drawing.pdf`.

Examples

    @pdf circle(O, 20, :fill)

    @pdf circle(O, 20, :fill) 400

    @pdf circle(O, 20, :fill) 400 1200

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
macro pdf(body, width=600, height=600)
     quote
        Drawing($width, $height, "luxor-drawing.pdf")
        origin()
        background("white")
        sethue("black")
        $(esc(body))
        finish()
        preview()
    end
end

end # module
