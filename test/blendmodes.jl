#!/usr/bin/env julia

using Luxor, Colors

if VERSION >= v"0.5.0-dev+7720"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

function blend_mode_test(fname)
    Drawing(600, 600, fname)
    origin()
    # transparent, no background
    fontsize(15)
    setline(1)
    tiles = Tiler(600, 600, 4, 5, margin=30)
    modes = length(Luxor.blendingmodes)
    setgrey(0.15)
    for (pos, n) in tiles
        n > modes && break
        gsave()
        translate(pos)
        box(O, tiles.tilewidth-10, tiles.tileheight-10, :clip)

        # diagonal
        diag = (Point(-tiles.tilewidth/2, -tiles.tileheight/2),
                Point(tiles.tilewidth/2,  tiles.tileheight/2))
        upper = between(diag, 0.4)
        lower = between(diag, 0.6)

        # first red shape uses default blend operator
        setcolor(0.7, 0, 0, .8)
        circle(upper, tiles.tilewidth/4, :fill)

        # second blue shape shows results of blend operator
        setcolor((0, 0, 0.9, 0.4))
        blendingmode = Luxor.blendingmodes[mod1(n, modes)]
        setmode(blendingmode)
        circle(lower, tiles.tilewidth/4, :fill)

        clipreset()
        grestore()

        gsave()
        translate(pos)
        text(Luxor.blendingmodes[mod1(n, modes)], O.x, O.y + tiles.tilewidth/2, halign=:center)
        grestore()
    end
    @test finish() == true
end

fname = "blend_mode_test.png"
blend_mode_test(fname)
println("...finished test: output in $(fname)")
