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
    placeimage(img, xpos, ypos)

Place a PNG image on the drawing at (`xpos`/`ypos`). The image `img` has been previously
loaded using `readpng()`.
"""
function placeimage(img::Cairo.CairoSurface, xpos, ypos)
    Cairo.set_source_surface(currentdrawing.cr, img, xpos, ypos)
    # no alpha
    Cairo.paint(currentdrawing.cr)
end

"""
    placeimage(img, pos)

Place a PNG image on the drawing at `pos`.
"""
placeimage(img::Cairo.CairoSurface, pt::Point) = placeimage(img, pt.x, pt.y)

"""
    placeimage(img, xpos, ypos, a)

Place a PNG image on the drawing at (`xpos`/`ypos`) with transparency `a`.
"""
function placeimage(img::Cairo.CairoSurface, xpos, ypos, alpha)
    Cairo.set_source_surface(currentdrawing.cr, img, xpos, ypos)
    paint_with_alpha(currentdrawing.cr, alpha)
end

"""
    placeimage(img, pos, a)

Place a PNG image on the drawing at `pos` with transparency `a`.
"""
placeimage(img::Cairo.CairoSurface, pt::Point, alpha) =
  placeimage(img::Cairo.CairoSurface, pt.x, pt.y, alpha)
