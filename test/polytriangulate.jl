#!/usr/bin/env julia

using Luxor, Test, Random

function test_polytriangulate(fname)

    Random.seed!(42)

    width, height = 800, 800
    Drawing(width, height, fname)
    origin()
    background("white")

    rawpts = ngon(O, 300, 8, vertices = true)

    for i in 1:12
        push!(rawpts, rand(BoundingBox(rawpts) * 0.6))
    end

    @test length(rawpts) == 20

    ptriangles = polytriangulate(rawpts)

    @test length(ptriangles) == 30

    fontsize(16)
    # visual inspection...
    setline(3)
    for (n, p) in enumerate(ptriangles)
        sethue([Luxor.julia_purple, Luxor.julia_blue,  Luxor.julia_red,  Luxor.julia_green][mod1(n, end)])
        pgon = Point[p[1], p[2], p[3]]
        poly(pgon,  :fillpreserve, close = true)
        sethue("white")
        strokepath()
        text(string(n), polycentroid(pgon), halign=:middle)
    end

    sethue("white")
    circle.(rawpts, 5, :fill)

    # can't think of how to test the triangulation, ideas welcome
    @test isempty(polyintersect(ptriangles[1], ptriangles[2])) == false
    @test isempty(polyintersect(ptriangles[1], ptriangles[6])) == true
    @test isempty(polyintersect(ptriangles[1], ptriangles[10])) == true
    @test isempty(polyintersect(ptriangles[1], ptriangles[20])) == true

    @test finish() == true
end

fname = "polytriangulate.png"
test_polytriangulate(fname)
println("...finished test: output in $(fname)")
