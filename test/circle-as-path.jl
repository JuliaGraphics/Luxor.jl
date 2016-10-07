#!/usr/bin/env julia

using Luxor

currentwidth = 1200
currentheight = 1200 # pts
Drawing(currentwidth, currentheight, "/tmp/circlepath.pdf")
origin()
background("white")
tiles = Tiler(currentwidth, currentheight, 8, 8, margin=20)
for (pos, n) in tiles
    randomhue()
    circlepath(pos, 70, :path)
    newsubpath()
    circlepath(pos, rand(5:65), :fill, clockwise=false, reversepath=true)
end

finish()
