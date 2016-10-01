#!/usr/bin/env julia

using Luxor

Drawing(1200, 1200, "/tmp/color-blends-2.pdf")
origin()
background("blue")

# a linear blend
redbluelinearblend = blend(Point(-100, 0), Point(100, 0))
addstop(redbluelinearblend, 0, Colors.RGBA(1, 0, 0, 0.15))
addstop(redbluelinearblend, 0.5, "white")
addstop(redbluelinearblend, 1, Colors.RGBA(0, 0, 1, 0.15))

# a radial blend
redbluelinearblend =
redblueradialblend = blend(Point(0, 0), 0, Point(0, 0), 100)
addstop(redblueradialblend, 0, Colors.RGBA(1, 0, 0, 0.15))
addstop(redblueradialblend, 0.5, "white")
addstop(redblueradialblend, 1, Colors.RGBA(0, 0, 1, 0.15))

tiles = Tiler(1200, 1200, 5, 5, margin=20)
for (pos, n) in tiles
    gsave()
    # take a Cairo matrix, convert it to Julia, apply scale, rotate, and translate matrix
    # transforms, convert back to Cairo, and apply it to the blend.
    # It doesn't seem right, does it...
    A = [1 0 0 1 0 0]
    Aj = cairotojuliamatrix(A)
    Sj = translation_matrix(0, -15) * rotation_matrix(rescale(n, 0, 25, 0, 2pi)) * scaling_matrix(1 - n/30, 1 - n/30) * Aj
    As = juliatocairomatrix(Sj)
    translate(pos)
    sethue("green")
    box(O, tiles.tilewidth/2, tiles.tilewidth/2, :fill)
    blendmatrix(redblueradialblend, As)
    setblend(redblueradialblend) # aligns pattern with current axes
    ellipse(O, tiles.tilewidth, tiles.tilewidth, :fill)
    grestore()
end

finish()
preview()
