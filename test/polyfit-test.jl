#!/usr/bin/env julia

using Luxor

currentwidth = 2400 # pts
currentheight = 2400 # pts
Drawing(currentwidth, currentheight, "/tmp/polyfit.pdf")

origin()
background("white")

fontsize(20)
setopacity(0.7)

macro g(a)
    quote
        gsave()
        $(esc(a))
        grestore()
    end
end

tiles = Tiler(2400, 2400, 5, 5, margin=20)
setline(1)
for (pos, n) in tiles
    @g  begin
        translate(pos)
        randomhue()
        box(O, -tiles.tilewidth, tiles.tilewidth, :fill)
        pts = [Point(x, rand(-tiles.tilewidth/3:tiles.tilewidth/3)) for x in -tiles.tileheight/2:30:tiles.tileheight/2]
        begin
            for (i, pt) in enumerate(pts)
                sethue("red")
                circle(pt, 6, :fill)
                sethue("black")
                text(string(i), pt)
            end
        end
        poly(polyfit(pts, rand(30:130)), :stroke)
    end
end

finish()
