#!/usr/bin/env julia

using Luxor

using Test

using Random
Random.seed!(42)

function test_rulers(x, y, rot, w)
    gsave()
    translate(x, y)
    rotate(rot)
    box(0, 0, w, w, :clip)
    rulers()
    clipreset()
    grestore()
end

function drawing_png_buffer()
    width, height = 2000, 2000
    Drawing(width, height, :png)
    origin(1200, 1200)
    background("ivory")
    pagetiles = Tiler(width, height, 5, 5, margin=10)
    for (pos, n) in pagetiles
      test_rulers(pos.x, pos.y, rand() * 2pi, pagetiles.tilewidth)
    end

    println("...finished rulers in png buffer test")
    @test finish() == true
end

function drawing_svg_buffer()
    width, height = 2000, 2000
    Drawing(width, height, :svg)
    origin(1200, 1200)
    background("ivory")
    pagetiles = Tiler(width, height, 5, 5, margin=10)
    for (pos, n) in pagetiles
      test_rulers(pos.x, pos.y, rand() * 2pi, pagetiles.tilewidth)
    end

    println("...finished rulers in svg buffer test")
    @test finish() == true
end

function drawing(fname)
    width, height = 2000, 2000
    Drawing(width, height, fname)
    origin(1200, 1200)
    background("ivory")
    pagetiles = Tiler(width, height, 5, 5, margin=10)
    for (pos, n) in pagetiles
      test_rulers(pos.x, pos.y, rand() * 2pi, pagetiles.tilewidth)
    end

    @test finish() == true
    println("...finished rulers test: output in $(fname)")
end

drawing_png_buffer()
drawing_svg_buffer()
drawing("rulers-test.pdf")
