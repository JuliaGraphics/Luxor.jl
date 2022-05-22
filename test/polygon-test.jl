#!/usr/bin/env julia

using Luxor, Colors

using Test

using Random
Random.seed!(42)

function poly_areas()
    # test area calculations
    @test polyarea(ngon(O, 100, 4, 0, vertices=true)) ≈ 20_000
    @test polyarea(ngonside(O, 100, 4, 0, vertices=true)) < polyarea(ngonside(O, 100, 5, 0, vertices=true))
    @test polyarea(ngonside(O, 100, 3, 0, vertices=true)) ≈ 2500sqrt(3)
end

function simple_polys()
    gsave()
    sethue(0, 0, 0)
    vstep = 50
    hstep = 50
    x = 0
    y = 0
    translate(-currentwidth/2 + 50, -currentheight/2 + 50)
    for sides in 3:12
        ngon(x, y, 20, sides, 0, :stroke)
        x += hstep
        if x > currentwidth
            x = 0
            y += vstep
        end
    end
    translate(0, currentheight - 150)
    x = 0
    for sides in 3:12
        ngon(x, y, 20, sides, 0, :fill)
        x += hstep
        if x > currentwidth
            x = 0
            y += vstep
        end
    end
    grestore()

    @layer begin
        translate(BoundingBox()[1] + (0, 130))
        pgon = ngonside(O, 20, 5, vertices=true)
        for i in 1:10
            polymove!(pgon, O, Point(50, 0))
            poly(pgon, :stroke, close=true)
            polyrotate!(pgon, rand() * π, center=polycentroid(pgon))
            polyscale!(pgon, isodd(i) ? 1.5 : 1/1.5, center=polycentroid(pgon))
        end
    end
end

function hex_mixtures()
    gsave()
    vstep = 50
    hstep = 50
    for y in -currentheight:vstep:currentheight
        for x in -currentwidth:hstep:currentwidth
            setopacity(0.2)
            setline(rand()*10)
            sethue(backgroundcolors[rand(1:end)])
            gsave()
                 translate(x, y)
                 rotate(rand() * pi)
                 # point version
                 poly(hexagon(rand() * 5, rand() * 5, 15 + rand() * 5), :fill, close=true)
                 setopacity(0.1)
                 poly(hexagon(rand() * 10, rand() * 5, 15 + rand() * 5))
                 setopacity(0.3)
                 randomhue()
                 poly([
                        Point(rand() * -100, rand() * 100),
                        Point(rand() * -100, rand() * 100),
                        Point(rand() * -100, rand() * 100),
                        Point(rand() * -100, rand() * 100)
                     ], :fill)
            grestore()
            sethue(backgroundcolors[rand(1:end)])
            gsave()
                 translate(x, y)
                 ngon(x, y, 50, rand(3:13), 0, :stroke)
                 rotate(rand() * pi)
                 poly(hexagon(rand() * 5, rand() * 5, 15 + rand() * 5), :stroke)
                 ngon(x, y, 50, rand(3:13), 0, :fill)
                 rect(0, 0, hstep-5, vstep-5, :stroke)
                 ngon(x, y, 50, rand(3:13), 0, :none)
            grestore()
        end
    end
    grestore()
end

hexagon(x, y, size) = [Point(x + size * cos(2pi/6 * i), y + size * sin(2pi/6 * i)) for i in 1:6]

function polygon_test(fname)
    global currentwidth = 595 # pts
    global currentheight = 842 # pts
    Drawing(currentwidth, currentheight, fname)

    origin()
    background("antiquewhite")

    # test polyareas
    poly_areas()

    global foregroundcolors = diverging_palette(230, 280, 200, s = 0.99, b=0.8)
    global backgroundcolors = diverging_palette(200, 260, 280, s = 0.8, b=0.5)
    setline(2)
    # fill, then clip to heptagon
    setcolor("lightcyan")
    setline(3)
    ngon(0, 0, 270, 7, 0, :fillpreserve) # fill it
    sethue("orange")
    strokepreserve()                     # stroke it
    clip()                               # then use to clip
    hex_mixtures()
    clipreset()
    simple_polys()
    @test finish() == true
    println("...finished test: output in $(fname)")
end

polygon_test("polygon-test.pdf")
