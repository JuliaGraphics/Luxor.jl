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
    return Cairo.read_from_png(pathname)
end

function paint_with_alpha(ctx::Cairo.CairoContext, a = 0.5)
    Cairo.paint_with_alpha(currentdrawing.cr, a)
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
    Cairo.set_source_surface(currentdrawing.cr, img, xpos, ypos)
    # no alpha
    Cairo.paint(currentdrawing.cr)
end

"""
    placeimage(img, pos; centered=false)

Place the top left corner of the PNG image on the drawing at `pos`.

Use keyword `centered=true` to place the center of the image at the position.
"""
placeimage(img::Cairo.CairoSurface, pt::Point; kwargs...) = placeimage(img, pt.x, pt.y; kwargs...)

"""
    placeimage(img, xpos, ypos, a; centered=false)

Place a PNG image on the drawing at (`xpos`/`ypos`) with transparency `a`.

Use keyword `centered=true` to place the center of the image at the position.
"""
function placeimage(img::Cairo.CairoSurface, xpos, ypos, alpha; centered=false)
    if centered == true
        w, h = img.width, img.height
        xpos, ypos = xpos - (w/2), ypos - (h/2)
    end
    Cairo.set_source_surface(currentdrawing.cr, img, xpos, ypos)
    paint_with_alpha(currentdrawing.cr, alpha)
end

"""
    placeimage(img, pos, a; centered=false)

Place a PNG image on the drawing at `pos` with transparency `a`.

Use keyword `centered=true` to place the center of the image at the position.
"""
placeimage(img::Cairo.CairoSurface, pt::Point, alpha; kwargs...) =
  placeimage(img::Cairo.CairoSurface, pt.x, pt.y, alpha; kwargs...)
