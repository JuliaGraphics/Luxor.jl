#!/usr/bin/env julia

using Luxor

using Test

using Random
Random.seed!(42)

function text_wrap_tests(fname)
    Drawing(1400, 1400, fname)
    origin()
    setopacity(0.8)
    sethue("black")
    fontface("Impact")
    tiles = Tiler(1000, 1000, 4, 3, margin=50)
    for (pos, n) in tiles
        fsize = 12
        opacity = 1.0
        fontsize(fsize)
        @layer begin
            translate(pos)
            sethue("antiquewhite")
            box(O, tiles.tilewidth-2, tiles.tileheight-2, :fill)
            sethue("black")
            if iseven(n)
                textwrap("Luxor is a city in Upper (southern) Egypt. " ^ 12,
                tiles.tilewidth,
                O - (tiles.tilewidth/2 - 2, tiles.tileheight/2 - 2),
                rightgutter=20)
            else
                # textwrap(s::String, width::Real, pos::Point, linefunc::Function; rightgutter=5)
               textwrap("Luxor is a city in Upper (southern) Egypt. " ^ 12,
                    tiles.tilewidth,
                    O - (tiles.tilewidth/2 - 2,  tiles.tileheight/2 - 2),
                    # l is the text of a line, p is the position of the start of the line, h is the interline height
                    (n, l, p, h) -> begin
                            text(string(length(l)), p + (tiles.tilewidth - 20, 0))
                            opacity *= 0.8
                            setopacity(opacity)
                        end,
                    rightgutter=40)
            end
        end
    end
    @test finish() == true
    println("...finished test: output in $(fname)")
end

text_wrap_tests("text-wrap-tests.svg")
