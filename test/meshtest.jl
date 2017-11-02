#!/usr/bin/env julia

using Luxor, Colors

if VERSION >= v"0.5.0-dev+7720"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

function meshtest1(fname)
    Drawing(1200, 1200, fname)
    origin()
    # transparent, no background
    background("ivory")
    tiles = Tiler(1200, 1200, 8, 8)
    setline(0.5)
    for (pos, n) in tiles
        @layer begin
            translate(pos)
            pl = ngon(O, tiles.tilewidth/2, 4, pi/4, vertices=true)
            mesh1 = mesh(pl, [
                "red",
                Colors.RGBA(randomcolor()...),
                Colors.RGBA(randomcolor()...),
                Colors.RGBA(randomcolor()...)
                ])
            setmesh(mesh1)
            box(O, tiles.tilewidth-8, tiles.tileheight-8, :fillpreserve)
            sethue("black")
            box(O, tiles.tilewidth-8, tiles.tileheight-8, :stroke)
        end
    end
    @test finish() == true
end

function meshtest2(fname)
    Drawing(1200, 1200, fname)
    origin()
    # transparent, no background
    background("ivory")
    pl = ngon(O, 250, 3, pi/6, vertices=true)
    mesh1 = mesh(pl, [
        "purple",
        "green",
        "yellow"
        ])
    setmesh(mesh1)
    setline(180)
    ngon(O, 250, 3, pi/6, :strokepreserve)
    setline(5)
    sethue("black")
    strokepath()
    @test finish() == true
end

fname = "meshtest1.png"
meshtest1(fname)
println("...finished mesh test 1: output in $(fname)")

fname = "meshtest2.png"
meshtest2(fname)
println("...finished mesh test 2: output in $(fname)")
