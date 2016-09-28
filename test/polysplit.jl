#!/usr/bin/env julia

using Luxor

function randompoly(rad, n)
    result = Point[]
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
        p1 = ngon(0, 0, 80, rand(3:8), rand(0:pi/10:2pi), vertices=true)
    else
        p1 = polysortbyangle(randompoly(80, rand(3:12)))
    end
    setline(1.5)

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
            poly(polysortbyangle(ply), close=true, :fill)
            grestore()
        end
    end

    grestore()
end

fname = "/tmp/polysplit.pdf"
width, height = 2000, 2000
Drawing(width, height, fname)
origin()
background("ivory")

pagetiles = Tiler(width, height, 6, 5, margin=50)
for (pos, n) in pagetiles
  testapoly(pos.x, pos.y)
end

finish()
println("finished test: output in $(fname)")
