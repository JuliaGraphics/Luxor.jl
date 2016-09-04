#!/usr/bin/env julia

using Luxor, Colors

fname = "/tmp/pagetiler-test1.pdf"
pagewidth, pageheight = 600, 900
Drawing(pagewidth, pageheight, fname)
origin() # move 0/0 to center
background("ivory")
setopacity(0.9)
setline(0.3)

# width, height, nrows, ncols, margin
pagetiles = PageTiler(pagewidth, pageheight, 8, 2, margin=20)

setopacity(0.5)

for (pos, n) in pagetiles
  randomhue()
  ellipse(pos, pagetiles.tilewidth, pagetiles.tileheight, :fill)
end

pagetiles = PageTiler(200, 300, 4, 5, margin=20)
for (pos, n) in pagetiles
  randomhue()
  ellipse(pos, pagetiles.tilewidth, pagetiles.tileheight, :fill)
end

finish()
preview()
