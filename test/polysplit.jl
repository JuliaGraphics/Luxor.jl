#!/usr/bin/env julia

using Luxor, Colors

function randompoly(rad, n)
    result = []
    for i in 1:n
        push!(result, Point(rand(-rad:rad), rand(-rad:rad)))
    end
    return polysortbyangle(result)
end

function testapoly(x, y)
    gsave()
    translate(x, y)

    sethue("white")

    # try both regular and irregular polygons
    if rand(Bool)
        p1 = ngonv(0, 0, 80, rand(3:8), rand(0:pi/10:2pi))
    else
        p1 = polysortbyangle(randompoly(80, rand(3:12)))
    end
    setline(0.5)

    poly(p1, close=true, :fillstroke)
    for p in p1
        gsave()
        sethue("black")
        circle(p, 1, :fill)
        grestore()
    end

    gsave()
    randomline = [Point(rand(-100:100), -100), Point(rand(-100:100), 100)]
    sethue("red")
    setdash("dotted")
    line(randomline[1], randomline[2], :stroke)
    grestore()

    # split the polygon
    twopolys = polysplit(p1, randomline[1], randomline[2])

    # draw each poly
    for ply in twopolys
        if length(ply) > 1
            randomhue()
            gsave()
            setopacity(0.5)
            poly(polysortbyangle(ply), close=true, :fill)
            grestore()
        end
    end

    grestore()
end

width, height = 2000, 2000
Drawing(width, height, "/tmp/polysplit.pdf")
origin()
background("ivory")

x = -width/2 + 150
y = -height/2 + 150
for i in 1:50
    testapoly(x, y)
    x += 250
    if x > width/2 - 150
        x = -width/2 + 150
        y += 250
    end
end

finish()
preview()
