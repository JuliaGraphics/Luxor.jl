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
            the_surface     = Cairo.CairoPDFSurface(iobuf, w, h)
        elseif stype == :png # default to PNG
            the_surface     = Cairo.CairoARGBSurface(w, h)
        elseif stype == :eps
            the_surface     = Cairo.CairoEPSSurface(iobuf, w, h)
        elseif stype == :svg
            the_surface     = Cairo.CairoSVGSurface(iobuf, w, h)
        elseif stype == :image
            the_surface     = Cairo.CairoImageSurface(w, h, Cairo.FORMAT_ARGB32)
        else
            error("Unknown Luxor surface type" \"$stype\"")
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

function get_current_cr()
    try
        getfield(CURRENTDRAWING[1], :cr)
    catch
        error("There is no current drawing.")
    end
end

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

# How Luxor output works. You start by creating a drawing
# either aimed at a file (PDF, EPS, PNG, SVG) or aimed at an
# in-memory buffer (:svg, :png, or :image); you could be
# working in Jupyter or Pluto or Atom, or a terminal, and on
# either Mac, Linux, or Windows.  (The @svg/@png/@pdf macros
# are shortcuts to file-based drawings.) When a drawing is
# finished, you go `finish()` (that's the last line of the
# @... macros.). Then, if you want to actually see it, you
# go `preview()`, which returns the current drawing.

# Then the code has to decide where you're working, and what
# type of file it is, then sends it to the right place,
# depending on the OS.

function Base.show(io::IO, ::MIME"text/plain", d::Drawing)
    returnvalue = d.filename
    # IJulia and Juno call the `show` function twice: once for
    # the image MIME and a second time for the text/plain MIME.
    # We check if this is such a 'second call':
    if (get(io, :jupyter, false) || Juno.isactive()) && (d.surfacetype == :svg || d.surfacetype == :png)
        return
    end
    # otherwise, we open the image file
    if Sys.isapple()
        run(`open $(returnvalue)`)
    elseif Sys.iswindows()
        cmd = get(ENV, "COMSPEC", "cmd")
        run(`$(ENV["COMSPEC"]) /c start $(returnvalue)`)
    elseif Sys.isunix()
        run(`xdg-open $(returnvalue)`)
    end
end

function tidysvg(m::MIME"image/svg+xml", fname)
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

# in memory:

Base.showable(::MIME"image/svg+xml", d::Luxor.Drawing) = d.surfacetype == :svg
Base.showable(::MIME"image/png", d::Luxor.Drawing) = d.surfacetype == :png

function Base.show(f::IO, ::MIME"image/svg+xml", d::Luxor.Drawing)
    @debug "show MIME:svg "
    write(f, d.bufferdata)
end

function Base.show(f::IO, ::MIME"image/png", d::Luxor.Drawing)
    @debug "show MIME:png "
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
Create a new drawing, and optionally specify file type (PNG, PDF, SVG, EPS),
file-based or in-memory, and dimensions.

    Drawing(width=600, height=600, file="luxor-drawing.png")

# Extended help

    Drawing()

creates a drawing, defaulting to PNG format, default filename "luxor-drawing.png",
default size 800 pixels square.

You can specify dimensions, and assume the default output filename:

    Drawing(400, 300)

creates a drawing 400 pixels wide by 300 pixels high, defaulting to PNG format, default
filename "luxor-drawing.png".

    Drawing(400, 300, "my-drawing.pdf")

creates a PDF drawing in the file "my-drawing.pdf", 400 by 300 pixels.

    Drawing(1200, 800, "my-drawing.svg")

creates an SVG drawing in the file "my-drawing.svg", 1200 by 800 pixels.

    Drawing(width, height, surfacetype | filename)

creates a new drawing of the given surface type (e.g. :svg, :png), storing the picture
only in memory if no filename is provided.

    Drawing(1200, 1200/Base.Mathconstants.golden, "my-drawing.eps")

creates an EPS drawing in the file "my-drawing.eps", 1200 wide by 741.8 pixels (= 1200 ÷ ϕ)
high. Only for PNG files must the dimensions be integers.

    Drawing("A4", "my-drawing.pdf")

creates a drawing in ISO A4 size (595 wide by 842 high) in the file "my-drawing.pdf".
Other sizes available are: "A0", "A1", "A2", "A3", "A4", "A5", "A6", "Letter", "Legal",
"A", "B", "C", "D", "E". Append "landscape" to get the landscape version.

    Drawing("A4landscape")

creates the drawing A4 landscape size.

PDF files default to a white background, but PNG defaults to transparent, unless you specify
one using `background()`.

    Drawing(width, height, :image)

creates the drawing in an image buffer in memory. You can obtain the data as a matrix with
`image_as_matrix()`.

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

Finish the drawing, and close the file. You may be able to open it in an
external viewer application with `preview()`.
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

If working in a notebook (eg Jupyter/IJulia), display a PNG or SVG file in the notebook.

If working in Juno, display a PNG or SVG file in the Plot pane.

Drawings of type :image should be converted to a matrix with `image_as_matrix()`
before calling `finish()`.

Otherwise:

- on macOS, open the file in the default application, which is probably the Preview.app for
  PNG and PDF, and Safari for SVG
- on Unix, open the file with `xdg-open`
- on Windows, pass the filename to `explorer`.
"""
function preview()
    @debug "preview()"
    return CURRENTDRAWING[1]
end

# for filenames, the @pdf/png/svg macros may pass either
# a string or an expression (with
# interpolation) which may or may not contain a valid
# extension ... yikes

function _add_ext(fname, ext)
    if isa(fname, Expr)
        # fname is an expression
        if endswith(string(last(fname.args)), string(ext))
            # suffix has been passed
            return fname
        else
            # there was no suffix
            push!(fname.args, string(".", ext))
            return fname
        end
    else
        # fname is a string
        if endswith(fname, string(ext))
            # file had a suffix
            return fname
        else
            # file did not have a suffix
            return string(fname, ".", ext)
        end
    end
end

"""
    @svg drawing-instructions [width] [height] [filename]

Create and preview an SVG drawing, optionally specifying width and height (the
default is 600 by 600). The file is saved in the current working directory as
`filename` if supplied, or `luxor-drawing-(timestamp).svg`.

Examples

```
@svg circle(O, 20, :fill)

@svg circle(O, 20, :fill) 400

@svg circle(O, 20, :fill) 400 1200

@svg circle(O, 20, :fill) 400 1200 "/tmp/test"

@svg circle(O, 20, :fill) 400 1200 "/tmp/test.svg"

@svg begin
        setline(10)
        sethue("purple")
        circle(O, 20, :fill)
     end

@svg begin
        setline(10)
        sethue("purple")
        circle(O, 20, :fill)
     end 1200 1200
```
"""
macro svg(body, width=600, height=600, fname="luxor-drawing-$(Dates.format(Dates.now(), "HHMMSS_s")).svg")
    quote
        local lfname = _add_ext($(esc(fname)), :svg)
        Drawing($width, $height, lfname)
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

```
@png circle(O, 20, :fill)

@png circle(O, 20, :fill) 400

@png circle(O, 20, :fill) 400 1200

@png circle(O, 20, :fill) 400 1200 "/tmp/round"

@png circle(O, 20, :fill) 400 1200 "/tmp/round.png"

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
```
"""
macro png(body, width=600, height=600, fname="luxor-drawing-$(Dates.format(Dates.now(), "HHMMSS_s")).png")
    quote
        local lfname = _add_ext($(esc(fname)), :png)
        Drawing($width, $height, lfname)
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

```
@pdf circle(O, 20, :fill)

@pdf circle(O, 20, :fill) 400

@pdf circle(O, 20, :fill) 400 1200

@pdf circle(O, 20, :fill) 400 1200 "/tmp/A0-version"

@pdf circle(O, 20, :fill) 400 1200 "/tmp/A0-version.pdf"

@pdf begin
        setline(10)
        sethue("purple")
        circle(O, 20, :fill)
     end

@pdf begin
        setline(10)
        sethue("purple")
        circle(O, 20, :fill)
     end 1200 1200
```
"""
macro pdf(body, width=600, height=600, fname="luxor-drawing-$(Dates.format(Dates.now(), "HHMMSS_s")).pdf")
     quote
        local lfname = _add_ext($(esc(fname)), :pdf)
        Drawing($width, $height, lfname)
        origin()
        background("white")
        sethue("black")
        $(esc(body))
        finish()
        preview()
    end
end

"""
    @eps drawing-instructions [width] [height] [filename]

Create and preview an EPS drawing, optionally specifying width and height (the
default is 600 by 600). The file is saved in the current working directory as
`filename` if supplied, or `luxor-drawing(timestamp).eps`.

On some platforms, EPS files are converted automatically to PDF when previewed.

Examples

```
@eps circle(O, 20, :fill)

@eps circle(O, 20, :fill) 400

@eps circle(O, 20, :fill) 400 1200

@eps circle(O, 20, :fill) 400 1200 "/tmp/A0-version"

@eps circle(O, 20, :fill) 400 1200 "/tmp/A0-version.eps"

@eps begin
        setline(10)
        sethue("purple")
        circle(O, 20, :fill)
     end

@eps begin
        setline(10)
        sethue("purple")
        circle(O, 20, :fill)
     end 1200 1200
```
"""
macro eps(body, width=600, height=600, fname="luxor-drawing-$(Dates.format(Dates.now(), "HHMMSS_s")).eps")
    quote
       local lfname = _add_ext($(esc(fname)), :eps)
       Drawing($width, $height, lfname)
        origin()
        background("white")
        sethue("black")
        $(esc(body))
        finish()
        preview()
    end
end

"""
    @draw drawing-instructions [width] [height]

Preview an PNG drawing, optionally specifying width and height (the
default is 600 by 600). The drawing is stored in memory, not in a file on disk.

Examples

```
@draw circle(O, 20, :fill)

@draw circle(O, 20, :fill) 400

@draw circle(O, 20, :fill) 400 1200


@draw begin
         setline(10)
         sethue("purple")
         circle(O, 20, :fill)
      end


@draw begin
         setline(10)
         sethue("purple")
         circle(O, 20, :fill)
      end 1200 1200
```
"""
macro draw(body, width=600, height=600)
    quote
        Drawing($width, $height, :png)
        origin()
        background("white")
        sethue("black")
        $(esc(body))
        finish()
        preview()
    end
end

"""
    image_as_matrix()

If the current Luxor drawing is an `:image type`, return a `Array{ARGB32,2}`
matrix of the current state of the picture, where each element is a colored pixel.

```
using Luxor, Images

Drawing(50, 50, :image)
origin()
background(randomhue()...)
sethue("white")
fontsize(40)
fontface("Georgia")
text("42", halign=:center, valign=:middle)
mat = image_as_matrix()
finish()

# working in Images:
img = Gray.(permutedims(mat, (2, 1)))
display(imresize(img, 150, 150))
```
"""
function image_as_matrix()
    if length(CURRENTDRAWING) != 1
        error("no current drawing")
    end
    w = Int(current_surface().width)
    h = Int(current_surface().height)
    z = zeros(UInt32, w, h)
    imagesurface = Cairo.CairoImageSurface(z, Cairo.FORMAT_ARGB32)
    cr = Cairo.CairoContext(imagesurface)
    Cairo.set_source_surface(cr, current_surface(), 0, 0)
    Cairo.paint(cr)
    data = imagesurface.data
    Cairo.finish(imagesurface)
    Cairo.destroy(imagesurface)
    return reinterpret(ARGB32, data)
end

"""
    Create a drawing and return a matrix of the image.

This macro returns a matrix of pixels that represent the drawing
produced by the vector graphics instructions. It uses the `image_as_matrix()`
function.

The default drawing is 256 by 256 units, and is composed of transparent black
pixels until you draw something different.

```
m = @imagematrix begin
        sethue("red")
        box(O, 20, 20, :fill)
    end 60 60

julia>  m[1220:1224] |> show
    ARGB32[ARGB32(0.0N0f8,0.0N0f8,0.0N0f8,0.0N0f8),
           ARGB32(1.0N0f8,0.0N0f8,0.0N0f8,1.0N0f8),
           ARGB32(1.0N0f8,0.0N0f8,0.0N0f8,1.0N0f8),
           ARGB32(1.0N0f8,0.0N0f8,0.0N0f8,1.0N0f8),
           ARGB32(1.0N0f8,0.0N0f8,0.0N0f8,1.0N0f8)]

julia> getfield.(m[1220:1224], :color)
 5-element Array{UInt32,1}:
 0x00000000
 0xffff0000
 0xffff0000
 0xffff0000
 0xffff0000
```

"""
macro imagematrix(body, width=256, height=256)
    quote
        Drawing($width, $height, :image)
        origin()
        $(esc(body))
        m = image_as_matrix()
        finish()
        m
    end
end
