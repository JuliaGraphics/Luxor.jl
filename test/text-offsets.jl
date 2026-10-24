#!/usr/bin/env julia

using Luxor

using Test

function textimage(; kwargs...)
    Drawing(200, 200, :png)
    origin()
    background("white")
    sethue("black")
    fontsize(20)
    text("Luxor", O; kwargs...)
    img = image_as_matrix()
    finish()
    return img
end

function text_offset_tests(fname)
    # with no rotation, toffset/noffset are the same as hoffset/voffset
    @test textimage(hoffset=30, voffset=-20) == textimage(toffset=30, noffset=-20)
    @test textimage(hoffset=30) != textimage()
    @test textimage(voffset=30) != textimage()

    # rotated a quarter turn clockwise, the normal points left and the tangent points down
    @test textimage(angle=π/2, voffset=25) == textimage(angle=π/2, toffset=25)
    @test textimage(angle=π/2, hoffset=-25) == textimage(angle=π/2, noffset=25)

    # offsets add up
    @test textimage(angle=π/2, hoffset=10, toffset=25) == textimage(angle=π/2, hoffset=10, voffset=25)

    Drawing(800, 800, fname)
    origin()
    background("white")
    fontsize(12)

    for θ in range(0, 2π, length=13)[1:end-1]
        pt = polar(250, θ)
        @layer begin
            sethue("red")
            circle(pt, 4, :fill)
        end
        sethue("black")
        text("tangent", pt, halign=:center, valign=:middle, angle=θ + π/2, toffset=40)
        text("normal",  pt, halign=:center, valign=:middle, angle=θ + π/2, noffset=20)
        text("h+v",     pt, halign=:center, valign=:middle, hoffset=-30, voffset=-30)
    end

    @test finish() == true
    println("...finished test: output in $(fname)")
end

text_offset_tests("text-offset-tests.svg")
