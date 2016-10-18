#!/usr/bin/env julia

using Luxor, Colors

if VERSION >= v"0.5.0-dev+7720"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

function color_blend_test(fname)
    Drawing(1200, 1200, fname)
    origin()
    background("blue")
    fontsize(20)

    # a linear blend
    redbluelinearblend = blend(Point(-100, 0), Point(100, 0))
    addstop(redbluelinearblend, 0, Colors.RGBA(1, 0, 0, 0.15))
    addstop(redbluelinearblend, 0.5, "white")
    addstop(redbluelinearblend, 1, Colors.RGBA(0, 0, 1, 0.15))

    # a radial blend
    redblueradialblend = blend(Point(0, 0), 0, Point(0, 0), 100)
    addstop(redblueradialblend, 0, Colors.RGBA(1, 0, 0, 0.15))
    addstop(redblueradialblend, 0.5, "white")
    addstop(redblueradialblend, 1, (0, 0, 1, 0.15))
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
        ellipse(O, tiles.tilewidth-10, tiles.tileheight-10, :fill)
        blendrad = blend(O, 1, O, 25, RGBA(0, 1, 1, 0.5), RGBA(0, 1, 0, 0.0))
        blendlin = blend(O, Point(O.x + tiles.tilewidth/2, O.y), "orange", "magenta")
        setblend(blendlin)
        text("linear", O+5)
        setblend(blendrad)
        text("radial", O-5)
        grestore()
    end

    sethue("black")
    blend_gold_black = blend(
            Point(0, 0), 0,                   # first circle center and radius
            Point(0, 0), 1,                   # second circle center and radius
            "gold", "black")

    translate(0, -550)
    tiles = Tiler(1000, 200, 1, 15, margin=20)
    orangegreenlinearblend = blend(Point(-1, 0), Point(1, 0), "orange", "green")

    for (pos, n) in tiles
        blend_adjust(orangegreenlinearblend, pos, tiles.tilewidth/2, tiles.tilewidth/2, rescale(n, 1, 15, 0, 2pi))
        setblend(orangegreenlinearblend)
        ellipse(pos, tiles.tilewidth, tiles.tilewidth, :fill)
        sethue("white")
        text(string(rescale(n, 1, 15, 0, 2pi)), pos)
    end
    @test finish() == true
end

fname = "color-blends-2.pdf"

color_blend_test(fname)

println("...finished color-blend-test")
