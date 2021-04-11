#!/usr/bin/env julia -

using Luxor

using Test

function svgstring_test()
    @testset "svg string test" begin
        Drawing(400, 800, :svg)
        origin()
        juliacircles()
        @test finish() == true
        svgsource = svgstring()
        matches = collect(eachmatch(r"<.*?>", svgsource))
        @test first(matches).match == """<?xml version="1.0" encoding="UTF-8"?>"""
        @test last(matches).match == "</svg>"
    end
    println("...finished svgstring_test")
end

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

svgstring_test()
place_svgtest("polysample.svg", "place-svg.svg")
