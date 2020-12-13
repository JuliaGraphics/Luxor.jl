#!/usr/bin/env julia

using Luxor

using Test

using Random
Random.seed!(42)

function drawdot(pos)
    gsave()
    sethue("red")
    circle(pos, 5, :fill)
    grestore()
end

function text_rotation_tests(fname)
    Drawing(800, 800, fname)
    origin()
    background("white")
    fontsize(10)

    for (n, θ) in enumerate(range(0, 2π, length=11))
        pt = polar(100, θ)
        @layer begin
            sethue("red")
            circle(pt, 5, :fill)
        end
        text("LEFT BOTTOM",  pt, halign=:left, valign=:bottom, angle=θ)
        text("RIGHT BOTTOM", pt, halign=:right, valign=:bottom, angle=θ)
        text("LEFT TOP",     pt, halign=:left, valign=:top, angle=θ)
        text("RIGHT TOP",    pt, halign=:right, valign=:top, angle=θ)
    end

    for (n, θ) in enumerate(range(0, 2π, length=15))
        pt = polar(300, θ)
        @layer begin
            sethue("red")
            circle(pt, 5, :fill)
        end
        text("CENTER BOTTOM",  pt, halign=:center, valign=:bottom, angle=θ)
        text("CENTER TOP",     pt, halign=:center, valign=:top, angle=θ)
    end

    @test finish() == true
    println("...finished test: output in $(fname)")
end

text_rotation_tests("text-rotation-tests.svg")
