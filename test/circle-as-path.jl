#!/usr/bin/env julia

using Luxor

function circle_as_path(fname)
    currentwidth = 1200
    currentheight = 1200 # pts
    Drawing(currentwidth, currentheight, fname)
    origin()
    background("white")
    tiles = Tiler(currentwidth, currentheight, 8, 8, margin=20)
    for (pos, n) in tiles
        randomhue()
        circlepath(pos, 70, :path)
        newsubpath()
        circlepath(pos, rand(5:65), :fill, reversepath=true)
    end
    finish()
    println("circle_as_path test saved in $(fname)")
end

circle_as_path("/tmp/circlepath.pdf")
