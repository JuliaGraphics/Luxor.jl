#!/usr/bin/env julia

using Luxor, Base.Test

function offset_poly_test(fname)
    Drawing("A2", fname)
    origin()
    background("white")
    srand(42)
    setline(1.5)

    tiles = Tiler(currentdrawing.width, currentdrawing.height, 6, 6, margin=20)
    randomoffset = 18
    for (pos, n) in tiles
        gsave()
        translate(pos)
        radius =  tiles.tilewidth/4
        p = star(O, radius, 5, 0.25, 0, vertices=true)
        sethue("red")
        setdash("dot")
        poly(p, :stroke, close=true)
        setdash("solid")
        sethue("black")
        randomoffset -= 1
        poly(offsetpoly(p, randomoffset), :stroke, close=true)
        text(string(randomoffset), O.x, O.y + tiles.tilewidth/2, halign=:center)
        grestore()
    end
    @test finish() == true
end

fname="offsetpolys.pdf"
offset_poly_test(fname)
println("...finished luxor test: output in $(fname)")
