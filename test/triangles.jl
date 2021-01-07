#!/usr/bin/env julia

using Luxor

using Test

using Random
Random.seed!(42)

function triangle_tests(fname)
    Drawing(800, 800, fname)
    origin()
    background("white")
    fontsize(10)

    panes = Tiler(500, 500, 1, 2)

    @layer begin
        translate(first(panes[1]))
        # equilateral
        tri1 = [polar(100, θ) for θ in (0, 2π/3, 4π/3)]
        prettypoly(tri1, :stroke, close=true)

        orthocenter = triangleorthocenter(tri1...)
        incenter = triangleincenter(tri1...)
        center = trianglecenter(tri1...)
        circumcenter = trianglecircumcenter(tri1...)
        circle.((orthocenter, incenter, center, circumcenter), 2, :fill)

        # all centers are the same
        @test isapprox(orthocenter, incenter)
        @test isapprox(orthocenter, center)
        @test isapprox(orthocenter, circumcenter)
    end

    @layer begin
        translate(first(panes[2]))
        # isosceles
        tri2 = [Point(0, 0), Point(80, -80), Point(160, 0)]
        prettypoly(tri2, :stroke, close=true)

        orthocenter = triangleorthocenter(tri2...)
        incenter = triangleincenter(tri2...)
        center = trianglecenter(tri2...)
        circumcenter = trianglecircumcenter(tri2...)
        circle.((orthocenter, incenter, center, circumcenter), 2, :fill)

        # all centers lie on the same vetical line
        @test isapprox(orthocenter.x, incenter.x)
        @test isapprox(orthocenter.x, center.x)
        @test isapprox(orthocenter.x, circumcenter.x)
    end

    @test finish() == true
    println("...finished test: output in $(fname)")
end

triangle_tests("triangle-tests.svg")
