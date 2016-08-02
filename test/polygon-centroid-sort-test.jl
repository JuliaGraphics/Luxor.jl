#!/usr/bin/env julia

using Luxor, Colors

width, height = 3000, 3000

Drawing(width, height, "/tmp/polycentroidsort.pdf")
origin()

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

function polycentroidsort()
    x = -width/2 + 200
    y = -height/2 + 300
    counter = 1
    while y < (height/2) - 50
        if rand(Bool)
            p = randompointarray(rand(-140:-10), rand(-140:-10), rand(10:140), rand(10:140), rand(5:12))
        else
            p = ngonv(0, 0, rand(50:100), rand(3:12))
        end
        drawpoly(p, x, y, counter)
        x += 200
        if x > (width/2) - 100
            x = -width/2 + 200
            y += 500
        end
        counter += 1
    end
end

polycentroidsort()
finish()
preview()
