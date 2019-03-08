mutable struct Drawing
    width::Float64
    height::Float64
    filename::AbstractString
    surface::CairoSurface
    cr::CairoContext
    surfacetype::Symbol
    redvalue::Float64
    greenvalue::Float64
    bluevalue::Float64
    alpha::Float64
    buffer::IOBuffer # Keeping both buffer and data because I think the buffer might get GC'ed otherwise
    bufferdata::Array{UInt8, 1} # Direct access to data

    function Drawing(w, h, stype::Symbol, f::AbstractString="")
        bufdata = UInt8[]
        iobuf = IOBuffer(bufdata, read=true, write=true)
        the_surfacetype = stype
        if stype == :pdf
            the_surface     =  Cairo.CairoPDFSurface(iobuf, w, h)
        elseif stype == :png # default to PNG
            the_surface     = Cairo.CairoARGBSurface(w, h)
        elseif stype == :eps
            the_surface     = Cairo.CairoEPSSurface(iobuf, w, h)
        elseif stype == :svg
            the_surface     = Cairo.CairoSVGSurface(iobuf, w, h)
        else
            error("Unknown Luxor surface type $stype")
        end
        the_cr  = Cairo.CairoContext(the_surface)
        # @info("drawing '$f' ($w w x $h h) created in $(pwd())")
        currentdrawing      = new(w, h, f, the_surface, the_cr, the_surfacetype, 0.0, 0.0, 0.0, 1.0, iobuf, bufdata)
        if isempty(CURRENTDRAWING)
            push!(CURRENTDRAWING, currentdrawing)
        else
            CURRENTDRAWING[1] = currentdrawing
        end
        return currentdrawing
    end
end

const CURRENTDRAWING = Array{Drawing, 1}()

# utility functions that access the internal current Cairo drawing object, which is
# stored as item 1 in a constant global array

get_current_cr()          = getfield(CURRENTDRAWING[1], :cr)
get_current_redvalue()    = getfield(CURRENTDRAWING[1], :redvalue)
get_current_greenvalue()  = getfield(CURRENTDRAWING[1], :greenvalue)
get_current_bluevalue()   = getfield(CURRENTDRAWING[1], :bluevalue)
get_current_alpha()       = getfield(CURRENTDRAWING[1], :alpha)

set_current_redvalue(r)   = setfield!(CURRENTDRAWING[1], :redvalue, convert(Float64, r))
set_current_greenvalue(g) = setfield!(CURRENTDRAWING[1], :greenvalue, convert(Float64, g))
set_current_bluevalue(b)  = setfield!(CURRENTDRAWING[1], :bluevalue, convert(Float64, b))
set_current_alpha(a)      = setfield!(CURRENTDRAWING[1], :alpha, convert(Float64, a))

current_filename()        = getfield(CURRENTDRAWING[1], :filename)
current_width()           = getfield(CURRENTDRAWING[1], :width)
current_height()          = getfield(CURRENTDRAWING[1], :height)
current_surface()         = getfield(CURRENTDRAWING[1], :surface)
current_surface_ptr()     = getfield(getfield(CURRENTDRAWING[1], :surface), :ptr)
current_surface_type()    = getfield(CURRENTDRAWING[1], :surfacetype)

current_buffer()          = getfield(CURRENTDRAWING[1], :buffer)
current_bufferdata()      = getfield(CURRENTDRAWING[1], :bufferdata)


# How Luxor output works. You start by creating a drawing either aimed at a
# file (PDF, EPS, PNG, SVG) or aimed at an in-memory buffer (:SVG and :PNG); you
# could be working in Jupyter or Atom, or a terminal, and on either Mac, Linux,
# or Windows.  (The @svg/@png/@pdf macros are shortcuts to file-based drawings.)
# When a drawing is finished, you go `finish()` (that's the last line of the
# @... macros.). Then, if you want to see it, you go `preview()`. Then the code
# decides where you're working, and what type of file it is, then sends it to the
# right place, depending on the OS.

function display_ijulia(m::MIME"image/png", fname)
    open(fname) do f
        d = read(f)
        display(m, d)
    end
end

function display_ijulia(m::MIME"image/svg+xml", fname)
    # rename the elements to avoid display issues
    # I pinched this from Simon's RCall.jl
    open(fname) do f
        r = string(rand(100000:999999))
        d = read(f, String)
        d = replace(d, "id=\"glyph" => "id=\"glyph"*r)
        d = replace(d, "href=\"#glyph" => "href=\"#glyph"*r)
        display(m, d)
    end
end

function Base.show(io::IO, d::Luxor.Drawing)
    print(io, """\n    width:    $(d.width)
    height:   $(d.height)
    filename: $(d.filename)
    type:     $(d.surfacetype)
        """)
    end

# in memory:

Base.showable(::MIME"image/svg+xml", d::Luxor.Drawing) = d.surfacetype == :svg
Base.showable(::MIME"image/png", d::Luxor.Drawing) = d.surfacetype == :png

# file-based

function Base.show(f::IO, ::MIME"image/svg+xml", d::Luxor.Drawing)
    write(f, d.bufferdata)
end

function Base.show(f::IO, ::MIME"image/png", d::Luxor.Drawing)
    write(f, d.bufferdata)
end

"""
    paper_sizes

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
const paper_sizes = Dict{String, Tuple}(
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
function Drawing(w=800.0, h=800.0, f::AbstractString="luxor-drawing.png")
    (path, ext)         = splitext(f)
    currentdrawing = Drawing(w, h, Symbol(ext[2:end]), f)
    if isempty(CURRENTDRAWING)
        push!(CURRENTDRAWING, currentdrawing)
    else
        CURRENTDRAWING[1] = currentdrawing
    end
    return currentdrawing
end

function Drawing(paper_size::AbstractString, f="luxor-drawing.png")
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
    if current_surface_ptr() == C_NULL
        # Already finished
        return false
    end
    if current_surface_type() == :png
        Cairo.write_to_png(current_surface(), current_buffer())
    end

    Cairo.finish(current_surface())
    Cairo.destroy(current_surface())

    if current_filename() != ""
        write(current_filename(), current_bufferdata())
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
    in(current_surface_type(), [:png, :svg]) ? candisplay = true : candisplay = false
    (isdefined(Main, :IJulia) && Main.IJulia.inited) ? jupyter = true : jupyter = false
    Juno.isactive() ? juno = true : juno = false
    if candisplay && jupyter
        Main.IJulia.clear_output(true)
        returnvalue = nothing
        if current_surface_type() == :png
            # avoid world age errors
            # Base.invokelatest(display, "image/png", load(current_filename()))
            display_ijulia(MIME("image/png"), current_filename())
        elseif current_surface_type() == :svg
            display_ijulia(MIME("image/svg+xml"), current_filename())
        end
    elseif candisplay && juno
        display(CURRENTDRAWING[1])
        returnvalue = nothing
    elseif Sys.isapple()
        returnvalue = current_filename()
        run(`open $(returnvalue)`)
    elseif Sys.iswindows()
        returnvalue = current_filename()
        cmd = get(ENV, "COMSPEC", "cmd")
        run(`$(ENV["COMSPEC"]) /c start $(returnvalue)`)
    elseif Sys.isunix()
        returnvalue = current_filename()
        run(`xdg-open $(returnvalue)`)
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
