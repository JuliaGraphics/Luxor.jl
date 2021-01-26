#!/usr/bin/env julia

using Luxor, Test, Random

Random.seed!(42)

function image_testing(fname)
    width, height = 4000, 4000
    margin = 500
    Drawing(width, height, fname)
    origin()
    background("grey25")
    setline(5)
    sethue("green")

    # try a nonpng
    @test_throws ErrorException readpng(dirname(dirname(pathof(Luxor))) * "/test/test-image.jl")

    image = readpng(dirname(dirname(pathof(Luxor))) * "/test/stackoverflow.png")
    w = image.width
    h = image.height
    pagetiles = Tiler(width, height, 7, 9)
    tw = pagetiles.tilewidth/2
    for (pos, n) in pagetiles
        circle(pos, tw, :stroke)
        circle(pos, tw, :clip)
        gsave()
        translate(pos)
        scale(25, 25)
        rotate(rand(0.0:pi/8:2pi))
        placeimage(image, O, centered=true)
        grestore()
        clipreset()
    end
    @test finish() == true
end

function placetesting(fname)
    # make svg file
    Drawing(200, 200, "svgimage.svg")
    origin()
    setline(40)
    sethue("rebeccapurple")
    squircle(O, 80, 80, :strokepreserve)
    sethue("white")
    fillpath()
    fontsize(40)
    sethue("black")
    text("SVG", halign=:center, valign=:middle)
    finish()

    # make png file
    Drawing(200, 200, "pngimage.png")
    origin()
    setline(40)
    sethue("red")
    squircle(O, 80, 80, :strokepreserve)
    sethue("white")
    fillpath()
    fontsize(40)
    sethue("black")
    text("PNG", halign=:center, valign=:middle)
    finish()

    Drawing(1200, 1200, fname)
    origin()
    svgimg = readsvg("svgimage.svg")
    svgimg = readsvg(read("svgimage.svg", String))
    pngimg = readpng("pngimage.png")
    for (pt, n) in Tiler(1200, 1200, 4, 4)
        @layer begin
            translate(pt)
            isodd(n) && placeimage(svgimg, O, centered=true)
            iseven(n) && placeimage(pngimg, O, centered=true)
        end
    end
    finish()
end

fname = "test-image.png"
image_testing(fname)

fname = "test-image-place.png"
placetesting(fname)


println("...finished test: output in $(fname)")
