#!/usr/bin/env julia -

using Luxor

using Test

function place_svgtest(fnamein, fnameout)
    svgin = readsvg(fnamein)
    @testset "readsvg" begin
        @test svgin.xpos == 400
        @test svgin.ypos == 400
        @test svgin.width == 400
        @test svgin.height == 400
    end
    @testset "placeimage" begin
        Drawing(400, 800, fnameout)
        origin()
        background("green")
        placeimage(svgin, O, centered = true)
        @test finish() == true
        svgin2 = readsvg(fnameout)
        @test svgin2.xpos == 400
        @test svgin2.ypos == 800
        @test svgin2.width == 400
        @test svgin2.height == 800
    end
    println("...finished test: output in $(fnameout)")
end

place_svgtest("polysample.svg", "place-svg.svg")
