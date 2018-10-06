#!/usr/bin/env julia

using Luxor

using Test

function grid_test(fname)
    Drawing("A0landscape", fname)
    background("white")
    translate(200, 200)
    fontsize(14)
    setline(0.2)
    rulers()
    side = 100
    grid = GridRect(O, side, side, 1000, 1600)
    for p in 1:121
        randomhue()
        # rectangular
        pt = nextgridpoint(grid)
        box(pt, side, side, :fill)
        sethue("white")
        text(string(p, ":", grid.rownumber, ":", grid.colnumber), pt, halign=:center, valign=:middle)
    end
    translate(Luxor.current_width()/2, 0)
    rulers()
    centers = 100
    grid = GridHex(O, centers, 800, 800)
    lastpt = O
    for p in 1:30
        # hex grid
        pt = nextgridpoint(grid)
        randomhue()
        ngon(pt, centers, 6, pi/2, :stroke)
        sethue("black")
        text(string(p, ":", grid.rownumber, ":", grid.colnumber), pt, halign=:center, valign=:middle)
        if grid.rownumber > 6
            break
        end
        lastpt = pt
    end
    sethue("black")

    arrow(O, Point(O.x + (sqrt(3) * centers) / 2, 0))
    circle(O, (sqrt(3) * centers) / 2, :stroke)
    circle(O, centers, :stroke)

    finish()
end

grid_test("grid-test.pdf")
