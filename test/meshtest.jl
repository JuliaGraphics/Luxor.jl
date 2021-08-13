#!/usr/bin/env julia

using Luxor, Colors

using Test

using Random
Random.seed!(2)

function meshtest1(fname)
    Drawing(1200, 1200, fname)
    origin()
    background("ivory")
    tiles = Partition(1200, 1200, 120, 120)
    fontsize(120)
    fontface("Courier-Bold")
    for (pos, n) in tiles
        @layer begin
            translate(pos)
            setcolor("black")
            setline(1)
            box(O, tiles.tilewidth-8, tiles.tileheight-8, :stroke)
            circle(O, 20, :fill)
            pl = ngon(O, tiles.tilewidth/2, 4, pi/4, vertices=true)
            # some of these should be transparent
            mesh1 = mesh(pl, [
                "red",
                Colors.RGBA(randomcolor()...),
                Colors.RGBA(randomcolor()...),
                Colors.RGBA(randomcolor()...)
                ])
            setmesh(mesh1)
            # box(O, tiles.tilewidth-10, tiles.tileheight-10, :fillpreserve)
            text(string(Char(rand(64:89))), halign=:center, valign=:middle)
        end
    end
    @test finish() == true
end

function meshtest2(fname)
    Drawing(1200, 1200, fname)
    origin()
    background("ivory")
    setcolor("black")
    fontsize(60)
    text("illuminati", halign=:center)
    pl = ngon(O, 300, 3, pi/6, vertices=true)
    mesh1 = mesh(pl, [
        "purple",
        Colors.RGBA(randomcolor()...),
        "yellow"
        ])
    setmesh(mesh1)
    setline(260)
    ngon(O, 300, 3, pi/6, :strokepreserve)
    setline(5)
    sethue("black")
    strokepath()
    @test finish() == true
end

function meshtest3(fname)
    Drawing(1200, 1200, fname)
    origin()
    background("ivory")
    bp = makebezierpath(ngon(O, 600, 3, pi/6, vertices=true))
    mesh1 = mesh(bp, [
        "purple",
        Colors.RGBA(randomcolor()...),
        "yellow"
        ])
    add_mesh_patch(mesh1, makebezierpath(ngon(O, 400, 4, vertices=true)), ["red", "blue", "green"])
    setmesh(mesh1)
    setline(550)
    drawbezierpath(bp, :strokepreserve)

    setline(5)
    sethue("black")
    strokepath()
    setcolor("black")
    fontsize(60)
    text("illuminati", halign=:center)
    @test finish() == true
end

fname = "meshtest1.png"
meshtest1(fname)
println("...finished mesh test 1: output in $(fname)")

fname = "meshtest2.png"
meshtest2(fname)
println("...finished mesh test 2: output in $(fname)")

fname = "meshtest3.png"
meshtest3(fname)
println("...finished mesh test 3: output in $(fname)")
