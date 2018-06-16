#!/usr/bin/env julia

using Luxor, Random

using Test

function drawctrlpoints(bezpath, r)
    @layer begin
        for seg in bezpath
            circle.(seg, r, :fill)
        end
    end
end

function bezpathtopolytest(fname)

    ng = ngon(O, 300, 5, vertices=true)

    bprough = makebezierpath(ng, smoothing=0.5)
    bpsmooth = makebezierpath(ng, smoothing=0.25)

    @test length(bprough) == 5
    @test typeof(bprough[1][1]) == Luxor.Point

    @test length(bpsmooth) == 5
    @test typeof(bpsmooth[1][1]) == Luxor.Point

    p1 = bezierpathtopoly(bprough)
    p2 = bezierpathtopoly(bpsmooth)

    @test length(p1) == 55
    @test typeof(p1[1]) == Luxor.Point
    @test length(p2) == 55
    @test typeof(p2[1]) == Luxor.Point

    srand(3)
    setline(0.01)
    currentwidth = 800
    currentheight = 800
    Drawing(currentwidth, currentheight, fname)
    origin()
    background("white")
    setopacity(0.5)

    # draw original polygon
    sethue("purple")
    prettypoly(ng, :stroke, close=true, () -> circle(O, 26, :fill))

    # draw the rough (non-smoothed) bezierpath
    sethue("green")
    drawctrlpoints(bprough, 15)
    drawbezierpath(bprough, :stroke)

    # draw the smoother bezierpath
    sethue("blue")
    drawctrlpoints(bpsmooth, 10)
    drawbezierpath(bpsmooth, :stroke)

    sethue("orange")
    prettypoly(p1, :stroke, () -> circle(O, 6, :fill))

    @test 254257 < polyarea(p1) < 254258
    @test 234992 < polyarea(p2) < 234993
    @test 213987 < polyarea(ng) < 213988

    @test finish() == true

end

fname = "bezpathtopolytest.svg"
bezpathtopolytest(fname)

println("...finished bezier path conversion tests: output in $(fname)")
