#!/usr/bin/env julia

using Luxor, Colors, Test, Random

Random.seed!(42)

function spirals()
    gsave()
    scale(0.3)
    r = 200
    setcolor("gray")
    for i = 0:pi/8:2pi
        gsave()
        translate(r * cos(i), r * sin(i))
        rotate(i)
        julialogo()
        grestore()
    end
    grestore()
    juliacircles(20)
end

function expandingspirals()
    gsave()
    scale(0.3)
    r = 200
    for i = pi:pi/12:6pi
        gsave()
        translate(i / 3 * r * cos(i), i / 3 * r * sin(i))
        scale(0.8)
        rotate(i)
        julialogo()
        grestore()
    end
    grestore()
end

function dropshadow()
    steps = 20
    # white-gray ramp
    gramp = range(
        colorant"white",
        stop = colorant"gray60",
        length = steps,
    )
    gsave()
    r = 200
    sethue("purple")
    rect(O, 5, 10, :stroke)
    setopacity(0.1)
    for i = 1:steps
        translate(-0.6, -0.5)
        julialogo(bodycolor = gramp[i], color = false)
    end
    julialogo()
    grestore()
end

function colorgrid()
    #cols = colormap("RdBu", 5; mid=0.5, logscale=false)
    #cols = sequential_palette(rand(10:360), 5, b=0.1)
    cols = distinguishable_colors(25)
    gsave()

    pagetiles = Tiler(500, 400, 5, 5)
    for (pos, n) in pagetiles
        gsave()
        setcolor(color(cols[n]))
        translate(pos)
        scale(0.3)
        julialogo(color = false)
        grestore()
    end
    grestore()
end

function boxes_and_rectangles(pt::Point)
    for i = 1:20
        randomhue()
        poly(
            box(pt + i, 10i, 10i, vertices = true),
            :stroke,
            close = true,
        )
    end
    for i = 40:10:150
        randomhue()
        translate(i, 0)
        poly(squircle(O, 30, 30, vertices = true), :stroke)
    end
end

function draw_julia_logos(fname)
    Drawing(1600, 1600, fname)
    origin()
    background("white")

    translate(-500, -200)
    spirals()

    translate(750, 0)
    expandingspirals()

    translate(-1000, 500)
    dropshadow()

    translate(800, 50)
    colorgrid()

    translate(-700, 300)
    boxes_and_rectangles(O)

    @test finish() == true
    println("...finished test: output in $(fname)")
end


# requires Luxor >= 2.0
function julialogodims(fname)
    Drawing(1600, 1600, fname)
    origin()
    background("white")
    sethue("black")
    julialogo(action = :path, centered = true)
    p = pathtopoly()
    lox, hix =
        extrema(first.(collect(Iterators.flatten(p))))
    loy, hiy = extrema(getfield.(
        collect(Iterators.flatten(p)),
        :y,
    ))
    bbx = BoundingBox(Point(lox, loy), Point(hix, hiy))
    sethue("grey58")
    box(bbx, :stroke)
    rule(boxmiddlecenter(bbx), boundingbox = bbx)
    rule(boxmiddlecenter(bbx), π / 2, boundingbox = bbx)
    dimension(
        boxtopleft(bbx),
        format = (d) -> string(round(d)),
        boxtopright(bbx),
        offset = -50,
        textgap = 0,
        textrotation = -π / 2,
        texthorizontaloffset = 20,
    )
    dimension(
        boxtopleft(bbx),
        format = (d) -> string(round(d)),
        boxbottomleft(bbx),
        textrotation = π,
        offset = 30,
        texthorizontaloffset = 20,
    )
    julialogo(centered = true)
    @test finish() == true
    println("...finished test: output in $(fname)")
end


function test1()
    randomhue()
    @layer begin
        translate(-100, 0)
        scale(0.5)
        julialogo(action = :path, centered = true)
        strokepath()
    end

    @layer begin
        translate(100, 0)
        scale(0.5)
        julialogo(action = :path, centered = true)
        strokepath()
    end
    text(
        "action=:path, centered=true)",
        halign = :center,
        Point(0, 100),
    )
end

function test2()
    randomhue()
    @layer begin
        translate(-100, 0)
        scale(0.5)
        julialogo(action = :clip, centered = true)
        paint()
        clipreset()
    end

    @layer begin
        translate(100, 0)
        scale(0.5)
        julialogo(action = :clip, centered = true)
        paint()
        clipreset()
    end

    text(
        "action=:clip, centered=true",
        halign = :center,
        Point(0, 100),
    )
end

function test3()
    sethue("blue")
    @layer begin
        translate(-100, 0)
        scale(0.5)
        julialogo(action = :stroke, centered = true)
    end
    @layer begin
        translate(100, 0)
        scale(0.5)
        julialogo(action = :stroke, centered = true)
    end
    text(
        "OG> action=:stroke, centered=true <NEW",
        halign = :center,
        Point(0, 100),
    )
end

function test4()
    randomhue()
    @layer begin
        translate(-100, 0)
        scale(0.5)
        julialogo(
            centered = true,
            color = true,
            bodycolor = "purple",
        )
    end

    @layer begin
        translate(100, 0)
        scale(0.5)
        julialogo(
            centered = true,
            color = true,
            bodycolor = "purple",
        )
    end

    text(
        "OG> centered=true, bodycolor=\"purple\" <NEW",
        halign = :center,
        Point(0, 100),
    )
end

function test5()
    randomhue()
    @layer begin
        translate(-100, 0)
        scale(0.5)
        julialogo(
            centered = true,
            color = true,
            bodycolor = "purple",
        )
    end

    @layer begin
        translate(100, 0)
        scale(0.5)
        julialogo(
            centered = true,
            color = true,
            bodycolor = "purple",
        )
    end

    text(
        "centered=true, color=true, bodycolor=\"purple\"",
        halign = :center,
        Point(0, 100),
    )
end

function test6()
    randomhue()
    @layer begin
        translate(-100, 0)
        scale(0.5)
        julialogo(
            centered = true,
            action = :path,
            color = true,
        )
    end
    fillpath()
    @layer begin
        translate(100, 0)
        scale(0.5)
        julialogo(
            centered = true,
            action = :path,
            color = true,
        )
    end
    fillpath()

    text(
        "centered=true, color=true, bodycolor=\"purple\"",
        halign = :center,
        Point(0, 100),
    )
end

function draw_julia_logos(fname)
    Drawing(1600, 1600, fname)
    origin()
    background("white")
    fontsize(12)
    tiles = Tiler(1200, 1200, 3, 2)
    for (pos, n) in tiles
        @layer begin
            translate(pos)
            n == 1 && test1()
            n == 2 && test2()
            n == 3 && test3()
            n == 4 && test4()
            n == 5 && test5()
            n == 6 && test6()
        end
    end
    @test finish() == true
    println("...finished test: output in $(fname)")
    finish()
end

draw_julia_logos("julia-logo-draw.png")
julialogodims("julia-logo-dims.png")
draw_julia_logos("julia-logo-draw-table.png")
