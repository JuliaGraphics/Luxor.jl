#!/usr/bin/env julia

using Luxor

using Test

using Random
Random.seed!(42)

function get_all_png_files_alpha(folder)
    imagelist = filter(f -> !startswith(f, ".") && endswith(f, "png"), readdir(folder))
    return map(f -> string(folder, f), imagelist)
end

function alphaimages(fname)
    imagelist = get_all_png_files_alpha(dirname(@__FILE__) * "/../docs/src/assets/figures/")
    width, height = 3000, 3000
    Drawing(width, height, fname)
    origin()
    background("grey50")
    for imgfile in imagelist
        img = readpng(imgfile)
        rand(Bool) ? placeimage(img, rand(-width/2:width/2), rand(-height/2:height/2), rand(0.25:0.1:0.75)) : placeimage(img, Point(rand(-width/2:width/2), rand(-height/2:height/2)), rand(0.25:0.1:0.75))
    end
    @test finish() == true
end

fname = "images-with-alpha.pdf"
alphaimages(fname)
println("...finished test: output in $(fname)")
