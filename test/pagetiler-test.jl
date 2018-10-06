#!/usr/bin/env julia

using Luxor

using Test

using Random
Random.seed!(42)

setantialias(6)

fname = "tiler-test1.pdf"
pagewidth, pageheight = 600, 900
Drawing(pagewidth, pageheight, fname)
origin() # move 0/0 to center
background("ivory")
setopacity(0.9)
setline(0.6)

# width, height, nrows, ncols, margin
pagetiles = Tiler(pagewidth, pageheight, 8, 2, margin=20)
t = length(pagetiles)

setopacity(0.5)

for (pos, n) in pagetiles
  randomhue()
  ellipse(pos, pagetiles.tilewidth, pagetiles.tileheight, :fill)
end

# testing eachindex
for i in 1:length(pagetiles)
    cpos, n =  pagetiles[i]
    for j in 1:20
        box(cpos, 5j, 5j, :stroke)
    end
end

pagetiles = Tiler(200, 300, 4, 5, margin=20)
t = length(pagetiles)

for (pos, n) in pagetiles
  randomhue()
  ellipse(pos, pagetiles.tilewidth, pagetiles.tileheight, :fill)
end

@test finish() == true
