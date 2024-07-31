#!/usr/bin/env julia

using Luxor, Test, Random

Random.seed!(42)

function main()
    w, h = 600, 600

    fname = "polysidelengths-test.png"
    Drawing(w, h, fname)
    background("white")
    origin()
    setline(0.5)

    pg = ngon(O, 100, 4, vertices = true)

    r = polysidelengths(pg)
    @test all(isapprox(141.42135623), r)
    @test length(r) == 4

    r = polysidelengths(pg, closed = false)
    @test all(isapprox(141.42135623), r)
    @test length(r) == 3

    for S in 3:10
        D = rand(9:173)
        pg = ngonside(rand(BoundingBox()), D, S, vertices = true)
        @show sum(polysidelengths(pg)), S * D
        @test isapprox(sum(polysidelengths(pg)), S * D)
    end

    @test finish() == true
    println("...finished test: output in $(fname)")
end

main()