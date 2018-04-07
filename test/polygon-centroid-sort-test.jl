#!/usr/bin/env julia

using Luxor

if VERSION >= v"0.5.0-dev+7720"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

function drawpolyboundingbox(apoly)
    gsave()
    setline(0.3)
    setdash("dotted")
    poly(convert(Vector{Point}, BoundingBox(apoly)), :stroke, close=true)
    box(BoundingBox(apoly), :stroke)
    grestore()
end

function drawpoly(p, x, y, counter)
    gsave()
    translate(x, y)
    sethue("purple")
    psort = polysortbyangle(p)
    drawpolyboundingbox(psort)
    poly(psort, close=true, :stroke)

    # label points
    for (n, pt) in enumerate(psort)
        circle(pt, 1, :fill)
        text(string(n), pt.x, pt.y)
    end

    sethue("green")
    cp = polycentroid(psort)
    circle(cp, 5, :fill)
    text(string(counter), cp.x, cp.y)

    # highlight cases where centroid isn't inside poly. Might be an error...
    if ! isinside(cp, psort)
        gsave()
        setdash("dotted")
        setopacity(0.2)
        sethue("red")
        circle(cp, 100, :fillstroke)
        grestore()
    end

    grestore()
end

function polycentroidsort(width, height)
    pagetiles = Tiler(width, height, 5, 5, margin=50)
    tilesize = pagetiles.tilewidth/2
    for (pos, n) in pagetiles
        p = randompointarray(rand(-tilesize:-tilesize), rand(-tilesize:-tilesize), rand(tilesize:tilesize), rand(tilesize:tilesize), rand(5:12))
        drawpoly(p, pos.x, pos.y, n)
    end
end

function polycentroidtest(fname)
    width, height = 3000, 3000
    Drawing(width, height, fname)
    fontsize(20)
    origin()
    polycentroidsort(width, height)
    @test finish() == true
end

fname = "polycentroidsort.pdf"
polycentroidtest(fname)

println("...finished test: output in $(fname)")
