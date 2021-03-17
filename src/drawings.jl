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
        elseif stype == :rec
            if isnan(w) || isnan(h)
                the_surface     = Cairo.CairoRecordingSurface()
            else
                extents = Cairo.CairoRectangle(0.0, 0.0, w, h)
                bckg = Cairo.CONTENT_COLOR_ALPHA
                the_surface     = Cairo.CairoRecordingSurface(bckg, extents)
                # Both the CairoSurface and the Drawing stores w and h in mutable structures.
                # Cairo.RecordingSurface does not set the w and h properties,
                # probably because that could be misinterpreted (width and height 
                # does not tell everything).
                # However, the image_as_matrix() function uses Cairo's values instead of Luxor's.
                # Setting these values here is the less clean, less impact solution. NOTE: Switch back 
                # if revising image_as_matrix to use Drawing: width, height.
                the_surface.width = w
                the_surface.height = h
            end
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

"""
    currentdrawing()

Return the current Luxor drawing, if there currently is one.
"""
function currentdrawing()
    if isempty(CURRENTDRAWING) || current_surface_ptr() == C_NULL
        # Already finished or not even started
        @info "There is no current drawing"
        return false
    else
        return CURRENTDRAWING[1]
    end
end

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
    @debug "show MIME:text/plain"
    returnvalue = d.filename
    # IJulia and Juno call the `show` function twice: once for
    # the image MIME and a second time for the text/plain MIME.
    # We check if this is such a 'second call':
    if (get(io, :jupyter, false) || Juno.isactive()) && (d.surfacetype == :svg || d.surfacetype == :png)
        return d.filename
    end
    # perhaps drawing hasn't started yet, eg in the REPL
    if !ispath(d.filename)
        location = !isempty(d.filename) ? d.filename : "in memory"
        println(" Luxor drawing: (type = :$(d.surfacetype), width = $(d.width), height = $(d.height), location = $(location))")
    else
        # open the image file
        if Sys.isapple()
            run(`open $(returnvalue)`)
        elseif Sys.iswindows()
            cmd = get(ENV, "COMSPEC", "cmd")
            run(`$(ENV["COMSPEC"]) /c start $(returnvalue)`)
        elseif Sys.isunix()
            run(`xdg-open $(returnvalue)`)
        end
    end
end

"""
    tidysvg(fname)

Read the SVG image in `fname` and write it to a file
`fname-tidy.svg` with modified glyph names.

Return the name of the modified file.

SVG images use named defs for text, which cause errors
problem when used in a notebook.
[See](https://github.com/jupyter/notebook/issues/333) for
example.

A kludgy workround is to rename the elements...
"""
function tidysvg(fname)
    # I pinched this from Simon's RCall.jl
    path, ext = splitext(fname)
    outfile = ""
    if ext == ".svg"
        outfile = "$(path * "-tidy" * ext)"
        open(fname) do f
            r = string(rand(100000:999999))
            d = read(f, String)
            d = replace(d, "id=\"glyph" => "id=\"glyph"*r)
            d = replace(d, "href=\"#glyph" => "href=\"#glyph"*r)
            open(outfile, "w") do out
                write(out, d)
            end
            @info "modified SVG file copied to $(outfile)"
        end
    end
    return outfile
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

Drawing(width, height, :rec)

creates the drawing in a recording surface in memory. `snapshot(fname, ...)` to any file format and bounding box,
or render as pixels with `image_as_matrix()`.
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
    snapshot(fname)

Take a snapshot and save to 'fname' name and suffix. 
One could continue drawing, or do the other things.

Internally, this stores the recording surface, then restores it.
"""
function snapshot(;fname = :svg, w = missing, h = missing) # TODO centered, BoundingBox etc.
    drec = currentdrawing()
    @assert !isnothing(drec)
    @assert current_surface_type() == :rec
    if isnan(drec.width) || isnan(drec.height)
        @assert !ismissing(w) || !ismissing(h) "Please provide w and h. Cairo.inkExtents not yet implemented."
    end
    Cairo.flush(current_surface())
    recmat = getmatrix()
    d = if ismissing(w) || ismissing(h)
        # Note, revisit this logic if Cairo.jl implements more of the RecordingSurface API.
        Drawing(drec.width, drec.height, fname)
    else
        Drawing(w, h, fname)
    end
    d.redvalue = drec.redvalue
    d.greenvalue = drec.greenvalue
    d.bluevalue = drec.bluevalue
    d.alpha = drec.alpha
    setmatrix(recmat)
    # Revisit this to cover all cases.
    set_source(d.cr, drec.surface, -drec.width / 2, -drec.height / 2)
    paint()
    finish()
    CURRENTDRAWING[1] = drec
    d
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
- on Windows, refer to `COMSPEC`.
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

### Examples

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
        Drawing($(esc(width)), $(esc(height)), lfname)
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

### Examples

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
        Drawing($(esc(width)), $(esc(height)), lfname)
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


### Examples

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
        Drawing($(esc(width)), $(esc(height)), lfname)
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

### Examples

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
        Drawing($(esc(width)), $(esc(height)), lfname)
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

### Examples

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
        Drawing($(esc(width)), $(esc(height)), :png)
        origin()
        background("white")
        sethue("black")
        $(esc(body))
        finish()
        preview()
    end
end

"""
    _argb32_to_rgba(i)

Convert a 32bit ARGB Int to a four value array:

```
_argb32_to_rgba(0xFF800000)

4-element Array{Float64,1}:
 1.0
 0.5019607843137255
 0.0
 0.0
```

"""
function _argb32_to_rgba(k)
    reverse(reinterpret(UInt8, [k]) ./ 0xFF)
end

"""
    unpremultiplyalpha(a)

Given an array of UInt32 values, divide each value by the
alpha value. See alphadivide or reversing premultiplied
alpha values.

Returns an array of arrays, where each array has four
Float64 values.

In a premultiplied image array, a 50% transparent red pixel
is stored as 0x80800000, rather than not 0x80ff0000. This
function reverses the process,  dividing each RGB value by
the alpha value.

The highest two digits of each incoming element is
interpreted as the alpha value.

```
unpremultiplyalpha([0x80800000])
 1-element Array{Array{Float64,1},1}:
 [1.0, 0.0, 0.0, 0.5019607843137255]
```

Notice the arithmetic errors introduced as 0x80 gets
converted to 0.5019.
"""
function unpremultiplyalpha(a)
    af = _argb32_to_rgba.(a)
    for i in eachindex(af)
        af[i] = circshift(af[i], -1)
        α = af[i][4]
        if ! iszero(α) # don't ÷ by 0
            af[i][1] /= α  # red
            af[i][2] /= α  # green
            af[i][3] /= α  # blue
        end
    end
    return af
end

"""
    image_as_matrix()

Return an Array of the current state of the picture as an
array of ARGB32.

A matrix 50 wide and 30 high => a table 30 rows by 50 cols

```
using Luxor, Images

Drawing(50, 50, :png)
origin()
background(randomhue()...)
sethue("white")
fontsize(40)
fontface("Georgia")
text("42", halign=:center, valign=:middle)
mat = image_as_matrix()
finish()
```
"""
function image_as_matrix()
    if length(CURRENTDRAWING) != 1
        error("no current drawing")
    end
    w = Int(current_surface().width)
    h = Int(current_surface().height)
    z = zeros(UInt32, w, h)
    # create a new image surface to receive the data from the current drawing
    # flipxy: see issue https://github.com/Wikunia/Javis.jl/pull/149
    imagesurface = CairoImageSurface(z, Cairo.FORMAT_ARGB32, flipxy=false)
    cr = Cairo.CairoContext(imagesurface)
    Cairo.set_source_surface(cr, current_surface(), 0, 0)
    Cairo.paint(cr)
    data = imagesurface.data
    Cairo.finish(imagesurface)
    Cairo.destroy(imagesurface)
    return reinterpret(ARGB32, permutedims(data, (2, 1)))
end

"""
    @imagematrix drawing-instructions [width=256] [height=256]

Create a drawing and return a matrix of the image.

This macro returns a matrix of pixels that represent the drawing
produced by the vector graphics instructions. It uses the `image_as_matrix()`
function.

The default drawing is 256 by 256 points.

You don't need `finish()` (the macro calls it), and it's not previewed by `preview()`.
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

```

If, for some strange reason you want to draw the matrix as another
Luxor drawing again, use code such as this:

```
m = @imagematrix begin
        sethue("red")
        box(O, 20, 20, :fill)
        sethue("blue")
        box(O, 10, 40, :fill)
    end 60 60

function convertmatrixtocolors(m)
    return convert.(Colors.RGBA, m)
end

function drawimagematrix(m)
    d = Drawing(500, 500, "/tmp/temp.png")
    origin()
    w, h = size(m)
    t = Tiler(500, 500, w, h)
    mi = convertmatrixtocolors(m)
    @show mi[30, 30]
    for (pos, n) in t
        c = mi[t.currentrow, t.currentcol]
        setcolor(c)
        box(pos, t.tilewidth -1, t.tileheight - 1, :fill)
    end
    finish()
    return d
end

drawimagematrix(m)
```

Transparency

The default value for the cells in an image matrix is
transparent black. (Luxor's default color is opaque black.)

```
julia> @imagematrix begin
       end 2 2
2×2 reinterpret(ARGB32, ::Array{UInt32,2}):
 ARGB32(0.0,0.0,0.0,0.0)  ARGB32(0.0,0.0,0.0,0.0)
 ARGB32(0.0,0.0,0.0,0.0)  ARGB32(0.0,0.0,0.0,0.0)
```

Setting the background to a partially or completely
transparent value may give unexpected results:

```
julia> @imagematrix begin
       background(1, 0.5, 0.0, 0.5) # semi-transparent orange
       end 2 2
2×2 reinterpret(ARGB32, ::Array{UInt32,2}):
 ARGB32(0.502,0.251,0.0,0.502)  ARGB32(0.502,0.251,0.0,0.502)
 ARGB32(0.502,0.251,0.0,0.502)  ARGB32(0.502,0.251,0.0,0.502)
```

here the semi-transparent orange color has been partially
applied to the transparent background.

```
julia> @imagematrix begin
           sethue(1., 0.5, 0.0)
       paint()
       end 2 2
2×2 reinterpret(ARGB32, ::Array{UInt32,2}):
 ARGB32(1.0,0.502,0.0,1.0)  ARGB32(1.0,0.502,0.0,1.0)
 ARGB32(1.0,0.502,0.0,1.0)  ARGB32(1.0,0.502,0.0,1.0)
```

picks up the default alpha of 1.0.
"""
macro imagematrix(body, width=256, height=256)
    quote
        Drawing($(esc(width)), $(esc(height)), :image)
        origin()
        $(esc(body))
        m = image_as_matrix()
        finish()
        m
    end
end

"""
    image_as_matrix!(buffer)

Like `image_as_matrix()`, but use an existing UInt32 buffer.

`buffer` is a buffer of UInt32.

```
w = 200
h = 150
buffer = zeros(UInt32, w, h)
Drawing(w, h, :image)
origin()
juliacircles(50)
m = image_as_matrix!(buffer)
finish()
# collect(m)) is Array{ARGB32,2}
Images.RGB.(m)
```
"""
function image_as_matrix!(buffer)
    if length(Luxor.CURRENTDRAWING) != 1
        error("no current drawing")
    end
    # create a new image surface to receive the data from the current drawing
    # flipxy: see issue https://github.com/Wikunia/Javis.jl/pull/149
    imagesurface = Cairo.CairoImageSurface(buffer, Cairo.FORMAT_ARGB32, flipxy=false)
    cr = Cairo.CairoContext(imagesurface)
    Cairo.set_source_surface(cr, Luxor.current_surface(), 0, 0)
    Cairo.paint(cr)
    data = imagesurface.data
    Cairo.finish(imagesurface)
    Cairo.destroy(imagesurface)
    return reinterpret(ARGB32, permutedims(data, (2, 1)))
end

"""
    @imagematrix! buffer drawing-instructions [width=256] [height=256]

Like `@imagematrix`, but use an existing UInt32 buffer.

```
w = 200
h  = 150
buffer = zeros(UInt32, w, h)
m = @imagematrix! buffer juliacircles(40) 200 150;
Images.RGB.(m)
```
"""
macro imagematrix!(buffer, body, width=256, height=256)
    quote
        Drawing($(esc(width)), $(esc(height)), :image)
        origin()
        $(esc(body))
        m = image_as_matrix!($(esc(buffer)))
        finish()
        m
    end
end
