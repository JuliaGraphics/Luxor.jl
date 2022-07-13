#!/usr/bin/env julia
using Luxor
using Test
using Colors

function grid_test(fname)
    println("a")
    Drawing("A1landscape", fname)
    origin()
    background("white")

    panes = Tiler(Luxor.current_width(), Luxor.current_height(), 1, 2)
    @layer begin
        translate(first(panes[1]))
        circle(O, 10, :fill)
        fontsize(14)
        setline(0.2)
        rulers()
        side = 100
        grid = GridRect(O - (400, 500), side, side, 1000, 1600)
        for p in 1:121
            randomhue()
            # rectangular
            pt = nextgridpoint(grid)
            box(pt, side, side, :fill)
            sethue("white")
            text(string(p, ":", grid.rownumber, ":", grid.colnumber), pt, halign = :center, valign = :middle)
        end
    end

    @layer begin
        translate(first(panes[2]))
        for q in -5:5 # vertical
            for r in -5:5 # horizontal
                pgon = hextile(HexagonOffsetEvenR(q, r, 60))
                sethue(HSB(rand(1:360), 0.6, 0.7))
                poly(pgon, :fill)
                sethue("white")
                text("$q", hexcenter(HexagonOffsetEvenR(q, r, 60)),
                    halign = :left, valign = :top)
                text("$r", hexcenter(HexagonOffsetEvenR(q, r, 60)),
                    halign = :right, valign = :bottom)
            end
        end
        rulers()
    end
    @layer begin
        translate(first(panes[2]))
        sethue("red")
        for q in -5:5 # vertical
            for r in -5:5 # horizontal
                h = HexagonOffsetOddR(q, r, 60)
                circle(hexcenter(h), 15, :fill)
            end
        end
        rulers()
    end
    @test finish() == true
end

fname = "grid-test.png"
grid_test(fname)
println("...finished test: output in $(fname)")
