#!/usr/bin/env julia

using Luxor

using Test

using Random
Random.seed!(42)

function annotatedash(pos, dashes, offset)
    @layer  begin
        translate(pos)
        @layer begin
            translate(0, 15)
            fontsize(3)
            sethue("black")
            x = 0
            for n in dashes
                text(string(n), O + (-offset + x + n/2, 0), halign=:center)
                x += n
            end
            fontsize(6)
            text("offset $offset", O + (-10, -10), halign=:right)
        end
        @layer begin
            translate(0, 2.5)
            setdash(dashes, offset)
            setline(0.5)
            sethue("grey60")
            line(O + (0, 6), O +  (3 * sum(dashes), 6), :stroke)
            sethue("red")
            setline(5)
            setdash(dashes, offset)
            line(O, O + (3 * sum(dashes), 0), :stroke)
        end
    end
end

function dash_tests(fname)
    pagewidth, pageheight = 800, 600
    Drawing(pagewidth, pageheight, fname)
    origin()
    background("ivory")
    setline(3)
    dashes = [30.0,  # ink
        10.0,  # skip
        5.0,  # ink
        15.0,  # skip
        20.0,  # ink
        4. # skip
        ]
    offset = -50.0
    sethue("black")
    text("Pattern is $(dashes)", boxtopcenter(BoundingBox() * 0.9),     halign=:center)
    sethue("blue")
    for y in -pageheight/2 + 50:30:pageheight/2 - 50
        randomhue()
        annotatedash(O + (-200, y), dashes, offset)
        offset += 10
    end
    @test finish() == true
end

fname = "dash-tests.svg"
dash_tests(fname)
println("...finished dash tests: output in $(fname)")
