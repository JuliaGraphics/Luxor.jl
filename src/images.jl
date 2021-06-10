# PNG, SVG, matrix import

# PNG

"""
    readpng(pathname)

Read a PNG file.

This returns a image object suitable for placing on the current drawing with `placeimage()`.
You can access its `width` and `height` fields:

    image = readpng("/tmp/test-image.png")
    w = image.width
    h = image.height
"""
function readpng(pathname)
    im = Cairo.read_from_png(pathname)
    if iszero(im.width) || iszero(im.height)
        throw(error("can't read this PNG image from $(pathname). Either it's not a valid PNG file, or the format is different from what Cairo is expecting."))
    end
    return im
end

function paint_with_alpha(ctx::Cairo.CairoContext, a = 0.5)
    Cairo.paint_with_alpha(get_current_cr(), a)
end

"""
    placeimage(pngimg, pos=O; centered=false)
    placeimage(pngimg, xpos, ypos; centered=false)

Place the PNG image on the drawing at `pos`, or (`xpos`/`ypos`). The image `img` has been previously
read using `readpng()`.

Use keyword `centered=true` to place the center of the image at the position.
"""
function placeimage(img::Cairo.CairoSurface, xpos, ypos; centered=false)
    if centered == true
        w, h = img.width, img.height
        xpos, ypos = xpos - (w/2), ypos - (h/2)
    end
    Cairo.set_source_surface(get_current_cr(), img, xpos, ypos)
    # no alpha
    Cairo.paint(get_current_cr())
end

placeimage(img::Cairo.CairoSurface, pt::Point=O; kwargs...) = placeimage(img, pt.x, pt.y; kwargs...)

"""
    placeimage(img, pt::Point=O, alpha; centered=false)
    placeimage(pngimg, xpos, ypos, alpha; centered=false)

Place a PNG image `pngimg` on the drawing at `pt` or `Point(xpos, ypos)`
with opacity/transparency `alpha`. The image has been
previously loaded using `readpng()`.

Use keyword `centered=true` to place the center of the image at the position.
"""
function placeimage(img::Cairo.CairoSurface, xpos, ypos, alpha; centered=false)
    if centered == true
        w, h = img.width, img.height
        xpos, ypos = xpos - (w/2), ypos - (h/2)
    end
    Cairo.set_source_surface(get_current_cr(), img, xpos, ypos)
    paint_with_alpha(get_current_cr(), alpha)
end

placeimage(img::Cairo.CairoSurface, pt::Point, alpha; kwargs...) =
  placeimage(img::Cairo.CairoSurface, pt.x, pt.y, alpha; kwargs...)

# SVG

struct SVGimage
    im::RsvgHandle
    xpos::Float64
    ypos::Float64
    width::Float64
    height::Float64
end

function _readsvgfile(fname)
    if Base.stat(fname).size == 0
         throw(error("readsvg: file $fname not found"))
    end
    r = Rsvg.handle_new_from_file(fname)

    if r.ptr == C_NULL
        throw(error("readsvg: couldn't read the file $fname"))
    end

    d = Rsvg.handle_get_dimensions(r)
    if iszero(d.width) || iszero(d.height)
        throw(error("readsvg(): can't get dimensions of this SVG image in $(pathname). Perhaps it's not a valid SVG file."))
    end

    return Luxor.SVGimage(r, d.em, d.ex, d.width, d.height)
end

function _readsvgstring(str)
    r = Rsvg.handle_new_from_data(str)

    if r.ptr == C_NULL
        throw(error("readsvg: can't read SVG from string starting $(str[1:20])."))
    end

    d = Rsvg.handle_get_dimensions(r)
    if iszero(d.width) || iszero(d.height)
        throw(error("readsvg_string(): can't get dimensions of this SVG image. Perhaps it's not valid SVG."))
    end
    return SVGimage(r, d.em, d.ex, d.width, d.height)
end

"""
    readsvg(str)

Read an SVG image. `str` is either pathname or pure SVG
code. This returns an SVG image object suitable for placing
on the current drawing with `placeimage()`.

Placing an SVG file:

```
@draw begin
    mycoollogo = readsvg("/tmp/mylogo.svg")
    placeimage(mycoollogo)
end
```

Placing SVG code:

```
# from https://github.com/edent/SuperTinyIcons
julialogocode = \"\"\"<svg xmlns="http://www.w3.org/2000/svg"
    aria-label="Julia" role="img"
    viewBox="0 0 512 512">
    <rect width="512" height="512" rx="15%" fill="#fff"/>
    <circle fill="#389826" cx="256" cy="137" r="83"/>
    <circle fill="#cb3c33" cx="145" cy="329" r="83"/>
    <circle fill="#9558b2" cx="367" cy="329" r="83"/>
</svg>\"\"\"

@draw begin
    julia_logo = readsvg(julialogocode)
    placeimage(julia_logo, centered=true)
end
```
"""
function readsvg(str)
    # str is either pathname or pure SVG code
    # unfortunately ispath fails on Mac if the string is longer than 255 characters
     if length(str) > 255 # don't check ispath, assume SVG string
         _readsvgstring(str)
     elseif ispath(str) # check is a file
         _readsvgfile(str)
     else
         _readsvgstring(str)
     end
 end

"""
    placeimage(svgimg, pos=O; centered=false)

Place an SVG image stored in `svgimg` on the drawing at `pos`. Use `readsvg()`
to read an SVG image from file, or from SVG code.

Use keyword `centered=true` to place the center of the image
at the position.
"""
function placeimage(im::SVGimage, pos=O; centered=false)
    if centered == true
        w, h = im.width, im.height
        pos = pos - ((w/2), (h/2))
    end
    @layer begin
        translate(pos)
        Rsvg.handle_render_cairo(Luxor.get_current_cr(), im.im)
    end
end

"""
    placeimage(matrix::AbstractMatrix{UInt32}, pos=O;
        alpha=1, centered=false)

Place an image matrix on the drawing at `pos` with opacity/transparency `alpha`.

Use keyword `centered=true` to place the center of the image
at the position.
"""
function placeimage(buffer::AbstractMatrix{UInt32}, pt=O; 
        alpha=1, centered=false)
    if centered == true
        w, h = size(buffer)
        pt = Point(pt.x - (w/2), pt.y - (h/2))
    end
    Cairo.set_source_surface(Luxor.get_current_cr(), Cairo.CairoImageSurface(buffer, Cairo.FORMAT_ARGB32), pt.x, pt.y)
    paint_with_alpha(get_current_cr(), alpha)
end
placeimage(buffer::AbstractMatrix{ARGB32}, args...; kargs...) = placeimage(collect(reinterpret(UInt32, buffer)), args...; kargs...)
placeimage(buffer::AbstractMatrix{<:Colorant}, args...; kargs...) = placeimage(convert.(ARGB32, buffer), args...; kargs...)

function placeimage(buffer::Drawing, args...;
        kargs...)
    if buffer.surfacetype == :svg
        placeimage(_readsvgstring(String(copy(buffer.bufferdata))), args...; kargs...)
    else
        throw(error("surfacetype `$(buffer.surfacetype)` is not supported. Use `image` instead."))
    end
end
