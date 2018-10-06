#!/usr/bin/env julia

using Luxor

using Test

using Random
Random.seed!(42)

function unit_conversions_test(fname)
    pagewidth, pageheight = 2000, 2000
    Drawing(pagewidth, pageheight, fname)
    origin()
    background("ivory")
    setline(0.5)
    tiles = Tiler(pagewidth, pageheight, 10, 4, margin=10)
    p = rand()
    for (pos, n) in tiles
        gsave()
        sethue("blue")
        translate(pos)
        if n % 2 == 0
            rect(O, 2inch, 1inch, :stroke)
            circle(O, 3inch/10, :stroke)

            rect(O + Point(-5mm, 3mm), 2cm, 1cm, :stroke)
            circle(O, 1cm, :stroke)

            rect(O, p*cm, p*cm, :stroke)
            circle(O, p*cm, :stroke)

        else
            sethue("darkorange")
            rect(O, 2*72, 72, :stroke)
            circle(O, 216/10, :stroke)

            rect(O + Point(-5 * 2.83464566929, 3 * 2.83464566929), 2 * 28.3464566929, 28.3464566929, :stroke)
            circle(O, 28.3464566929, :stroke)

            rect(O, p * 28.3464566929, p * 28.3464566929, :stroke)
            circle(O, p * 28.3464566929, :stroke)
        end
        grestore()
    end
    @test finish() == true
end

@test isapprox(1inch, 72)
@test isapprox(72, 1inch)
@test isapprox(2.54cm, 1inch)
@test isapprox(72, 2.54cm)

fname = "unit-conversions-test.pdf"
unit_conversions_test(fname)
println("...finished test: output in $(fname)")
