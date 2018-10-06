#!/usr/bin/env julia -

using Luxor

using Test

using Random
Random.seed!(42)

function polysampletest(fname)
    Drawing(400, 400, fname)
    origin()
    background("white")

    p = ngon(O, 100, 6, vertices=true)
    setline(12)
    sethue("grey70")
    prettypoly(p, :stroke, close=true, ()->circle(O, 10, :fill))

    upsample = polysample(p, 12)
    setline(3)
    sethue("cyan")
    prettypoly(upsample, :stroke, close=true, ()->circle(O, 7, :fill))

    resample = polysample(p, 6)
    setline(2)
    sethue("magenta")
    prettypoly(upsample, :stroke, close=true, ()->circle(O, 4, :fill))

    @test p == circshift(resample, 1)

    downsample = polysample(p, 3)
    setline(1)
    sethue("orange")
    prettypoly(downsample, :stroke, close=true, ()->circle(O, 2, :fill))

    @test length(findall(pt -> pt == downsample[1], p)) == 1

    @test finish() == true
    println("...finished test: output in $(fname)")

end

polysampletest("polysample.svg")
