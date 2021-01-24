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
    placeimage(img, xpos, ypos; centered=false)

Place a PNG image on the drawing at (`xpos`/`ypos`). The image `img` has been previously
loaded using `readpng()`.

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

"""
    placeimage(img, pos; centered=false)

Place the top left corner of the PNG image on the drawing at `pos`.

Use keyword `centered=true` to place the center of the image at the position.
"""
placeimage(img::Cairo.CairoSurface, pt::Point; kwargs...) = placeimage(img, pt.x, pt.y; kwargs...)

"""
    placeimage(img, xpos, ypos, alpha; centered=false)

Place a PNG image on the drawing at `Point(xpos, ypos)` with transparency `alpha`.

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

"""
    placeimage(img, pt::Point, alpha; centered=false)

Place a PNG image on the drawing at `pt` with transparency `alpha`.

Use keyword `centered=true` to place the center of the image at the position.
"""
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

"""
    readsvg(pathname)

Read an SVG image.

This returns an SVG image object suitable for placing on the current drawing with `placeimage()`.
"""
function readsvg(fname)
    if Base.stat(fname).size == 0
         throw(error("readsvg(): file $fname not found"))
    end
    r = Rsvg.handle_new_from_file(fname)

    if r.ptr == C_NULL
        throw(error("readsvg(): couldn't read this file"))
    end

    d = Rsvg.handle_get_dimensions(r)
    if iszero(d.width) || iszero(d.height)
        throw(error("readsvg(): can't get dimensions from this SVG image from $(pathname). Either it's not a valid SVG file, or the format is different from what I'm expecting."))
    end

    return Luxor.SVGimage(r, d.em, d.ex, d.width, d.height)
    SVGimage(r, d.em, d.ex, d.width, d.height)
end

"""
    placeimage(svgimg, pos; centered=false)

Place an SVG image on the drawing at `pos`. Use `readsvg()` to read an SVG image.

Use keyword `centered=true` to place the center of the image at the position.
"""
function placeimage(im::SVGimage, pos;
        centered=false)
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
    placeimage(matrix, pos; centered=false)

Place an image matrix on the drawing at `pos`.

Use keyword `centered=true` to place the center of the image at the position.
"""
function placeimage(buffer::AbstractMatrix{UInt32}, pt=O; centered=false)
    if centered == true
        w, h = size(buffer)
        pt = Point(pt.x - (w/2), pt.y - (h/2))
    end
    Cairo.set_source_surface(Luxor.get_current_cr(), Cairo.CairoImageSurface(buffer, Cairo.FORMAT_ARGB32), pt.x, pt.y)
    Cairo.paint(Luxor.get_current_cr())
end
placeimage(buffer::AbstractMatrix{ARGB32}, args...; kargs...) = placeimage(collect(reinterpret(UInt32, buffer)), args...; kargs...)
placeimage(buffer::AbstractMatrix{<:Colorant}, args...; kargs...) = placeimage(convert.(ARGB32, buffer), args...; kargs...)
