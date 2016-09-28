#!/usr/bin/env julia

using Luxor

function drawbbox(apoly)
    gsave()
    setline(0.3)
    setdash("dotted")
    box(polybbox(apoly), :stroke)
    grestore()
end

function drawpoly(p, x, y, counter)
    gsave()
    translate(x, y)
    sethue("purple")
    psort = polysortbyangle(p)
    drawbbox(psort)
    poly(psort, close=true, :stroke)

    # label points
    for (n, pt) in enumerate(psort)
        circle(pt, 1, :fill)
        text(string(n), pt.x, pt.y)
    end

    sethue("green")
    cp = polycentroid(psort)
    circle(cp, 2, :fill)
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
      if rand(Bool)
        p = randompointarray(rand(-tilesize:-tilesize), rand(-tilesize:-tilesize), rand(tilesize:tilesize), rand(tilesize:tilesize), rand(5:12))
      else
        p = ngon(0, 0, tilesize, rand(3:12), vertices=true)
      end
      drawpoly(p, pos.x, pos.y, n)
    end
end

width, height = 3000, 3000
fname = "/tmp/polycentroidsort.pdf"
Drawing(width, height, fname)
fontsize(20)
origin()
polycentroidsort(width, height)
finish()
println("finished test: output in $(fname)")
