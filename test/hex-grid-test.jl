#!/usr/bin/env julia

using Luxor

if VERSION >= v"0.5.0-dev+7720"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

import Luxor.nextgridpoint

function nextgridpoint(g::Luxor.Grid, radius)
    tempx = g.currentpoint.x + (radius * sqrt(3))
    tempy = g.currentpoint.y
    # only 1 column per row
    if g.xspacing == 0
        g.rownumber += 1
        g.colnumber = 1
        g.currentpoint = Point(g.startpoint.x - g.xspacing, tempy + g.yspacing)
    else
        g.colnumber += 1
        g.currentpoint = Point(tempx, tempy)
    end    
    # next row
    if tempx >= g.width
        g.rownumber += 1
        g.colnumber = 1
        if g.rownumber % 2 == 0
            @show g.rownumber
            g.currentpoint = Point(g.startpoint.x + sqrt(3)radius/2, tempy + (3/2)radius)
        else
            g.currentpoint = Point(g.startpoint.x , tempy + (3/2)radius)
        end
    end
    # finished?
    if g.currentpoint.y >= g.height
        # start again...?
        g.rownumber = 1
        g.colnumber = 1
        g.currentpoint = Point(0, 0)
    end
    return g.currentpoint
end

function hex_grid_test(fname)
    Drawing("A1landscape", "fname")
    background("white")
    translate(200, 200)
    fontsize(20)
    setopacity(0.9)
    radius = 50
    setline(0.2)
    grid = Grid(O, (radius * sqrt(3)), (radius * sqrt(3)), 1800, 2000)
    for p in 1:200
        randomhue()
        pt = nextgridpoint(grid, radius)
        ngon(pt, radius, 6, pi/2, :fill)
        sethue("white")
        text(string(p), pt, halign=:center, valign=:middle)
        pt = nextgridpoint(grid)
        randomhue()
        squircle(pt, 20, 20, :fill)
        sethue("white")
        text(string(p), pt, halign=:center, valign=:middle)
    end
    finish()
end

hex_grid_test("hex-grid-test.pdf")
