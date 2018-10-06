#!/usr/bin/env julia

using Luxor

using Test

using Random
Random.seed!(42)

function getpath_1(fname)
    Drawing(400, 250, fname)

    background("white")
    origin()
    setline(0.75)
    sethue("black")

    fontsize(220)
    t = "N" # no curves on this one
    translate(-textextents(t)[3]/2, textextents(t)[4]/2)
    textpath(t)
    pathdata = getpath()
    outline = Point[]
    for i in pathdata[1:end-1]
        if length(i.points) == 2
            x = i.points[1]
            y = i.points[2]
            push!(outline, Point(x, y))
        end
    end
    poly(outline, :stroke, close=true)
    for i in 5:5:35
        poly(offsetpoly(outline, i), :stroke, close=true)
    end
    @test finish() == true
end

fname= "figures-get-path.pdf"
getpath_1(fname)
println("...finished test: output in $(fname)")
