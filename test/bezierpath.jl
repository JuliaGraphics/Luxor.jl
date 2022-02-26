#!/usr/bin/env julia

using Luxor
using Test
using Random
Random.seed!(42)

function bezierarithmetic()
    bps = BezierPathSegment(ngon(O, 100, 4, vertices=true)...)
    @test length(bps) == 4
    @test Luxor.get_bezier_length(bps) ≈ 281.4703644162024
    @test Luxor.get_bezier_length(bps, steps=100) ≈ 282.8313796714682
    l, r = splitbezier(bps, 0.5)
    @test last(l) ≈ first(r)
    @test first(l) ≈ first(bps)
    @test last(r) ≈ last(bps)
end

function bezierpathtest(fname)
    Random.seed!(3)
    currentwidth = 1200
    currentheight = 1200
    Drawing(currentwidth, currentheight, fname)
    origin()
    background(setgray(0.8)...)
    tiles = Tiler(currentwidth, currentheight, 4, 4, margin=20)
    for (pos, n) in tiles
        @layer begin
            translate(pos)
            pts = randompointarray(Point(-tiles.tilewidth/2, -tiles.tilewidth/2), Point(tiles.tilewidth/2, tiles.tilewidth/2), rand(3:5))
            setopacity(0.7)
            sethue("black")
            prettypoly(pts, :stroke, close=true)
            randomhue()
            drawbezierpath(makebezierpath(pts, smoothing=rand(0:0.1:1)), :fill)
        end
    end
    @test finish() == true
end

function pathtobezierpath(fname)
    Random.seed!(3)
    currentwidth = 800
    currentheight = 800
    Drawing(currentwidth, currentheight, fname)
    origin()
    background("white")
    st = "julia"
    setopacity(0.7)
    thefontsize = 200
    sethue("red")
    fontsize(thefontsize)
    move(Point(-350, 0))
    textpath(st)
    nbps = pathtobezierpaths()
    for nbp in nbps
        setline(.25)
        sethue("grey50")
        drawbezierpath(nbp, :stroke)
        # exaggerate position of Bezier control points
        for p in nbp
            sethue("magenta")
            exthandle1 = between(p[2], p[1], -3)
            exthandle2 = between(p[3], p[4], -3)
            circle(exthandle1, 1, :fill)
            circle(exthandle2, 1, :fill)
            line(p[1], exthandle1, :stroke)
            line(exthandle2, p[4], :stroke)
            if p[1] != p[4]
                sethue("black")
                circle(p[1], 1, :fill)
                circle(p[4], 1, :fill)
            end
        end
    end
    @test finish() == true
end

bezierarithmetic()

fname = "bezierpath.png"
bezierpathtest(fname)

println("...bezier test: output in $(fname)")

fname = "pathtobezierpath.svg"
pathtobezierpath(fname)

println("...finished bezier tests: output in $(fname)")
