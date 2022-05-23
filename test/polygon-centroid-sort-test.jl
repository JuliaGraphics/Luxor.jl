#!/usr/bin/env julia

using Luxor

using Test

using Random
Random.seed!(42)

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

    # label old points
    @layer begin
        sethue("grey50")
        fontsize(8)
        for (n, pt) in enumerate(p)
            circle(pt, 1, :fill)
            label(string(n), :NW, pt, offset=5)
        end
    end

    psort = polysortbyangle(p)
    drawpolyboundingbox(psort)
    poly(psort, close=true, :stroke)

    # label sorted points
    for (n, pt) in enumerate(psort)
        circle(pt, 1, :fill)
        text(string(n), pt.x, pt.y)
    end

    sethue("green")
    cp = polycentroid(psort)
    circle(cp, 5, :fill)
    text(string(counter), cp.x, cp.y)

    # highlight cases where centroid isn't inside poly. Might be an error...
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

        # check for axis-aligned edges too
        rand(1:10) > 7 && (p = Random.shuffle!(box(O, 250, 300, vertices=true)))
        drawpoly(p, pos.x, pos.y, n)
    end
end

function polycentroidtest(fname)
    width, height = 3000, 3000
    Drawing(width, height, fname)
    fontsize(20)
    background("white")
    origin()
    polycentroidsort(width, height)
    @test finish() == true
end

fname = "polycentroidsort.png"
polycentroidtest(fname)

println("...finished test: output in $(fname)")
