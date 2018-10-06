#!/usr/bin/env julia

using Luxor

using Test

using Random
Random.seed!(42)

function barfunc1(low, high, v; extremes=extrema(values), barnumber=0, bartotal=0, mvalue=0)
    @layer begin
        sethue(rescale(v, 0, extremes[2], 0, 1), rand(), rand())
        circle(low, 2, :fill)
        box(Point(low.x - 5, low.y), Point(high.x + 5, high.y), :fill)
        fontsize(6)
        sethue("black")
        textbox([string(round(v, digits=2))], Point(low.x, 100), leading=5, alignment=:center)
        sethue("gray80")
        setline(0.5)
        setdash("dot")
        line(low, Point(low.x, 100), :stroke)
    end
end

function barfunc2(low, high, value; extremes=extrema(values), barnumber=0, bartotal=0)
    @layer begin
        sethue("red")
        randomhue()
        setline(4)
        setlinecap("round")
        line(low, high, :stroke)
        circle(high, 2, :fill)
    end
end

emptylabelfunction(args...; extremes=[], barnumber=0, bartotal=0) = nothing

function mylabelfunction(bottom::Point, top::Point, value;
        extremes=[], barnumber=0, bartotal=0)
    t = string(value)
    textoffset = textextents(t)[4]
    if top.y < 0
        tp = Point(top.x, min(top.y, bottom.y) - textoffset)
    else
        tp = Point(top.x, max(top.y, bottom.y) + textoffset)
    end
    @layer begin
        translate(tp)
        rotate(-pi/2)
        text(t, O, halign=:left, valign=:middle)
    end
end

function test_bars(fname)
    pagewidth, pageheight = 1200, 1400
    Drawing(pagewidth, pageheight, fname)
    background("antiquewhite")
    fontsize(5)
    sethue("black")
    origin()
    translate(-200, 0)
    tiles = Tiler(pagewidth, pageheight, 6, 2, margin=35)
    for (pos, n) in tiles
        @layer begin
            translate(pos)
            if n % 5 == 1
                v = randn(15)
                bars(v, labelfunction = (args...; extremes=[], barnumber=0, bartotal=0) ->  setgray(rand()))
            elseif n % 5 == 2
                # no labels
                v = rand(1:10, 100)
                bars(v, xwidth=rand(2:6), yheight=rand(50:100), labelfunction=emptylabelfunction)
            elseif n % 5 == 3
                # a custom label function
                v = rand(20)
                bars(v, yheight=rand(10:80), xwidth=rand(5:20), labelfunction=mylabelfunction)
            elseif n % 5 == 4
                # a custom barfunction
                v = rand(5:0.1:10, 20)
                bars(v, yheight=30, xwidth=20, labels=false, barfunction = barfunc1)
            elseif n % 5 == 5
                # another custom barfunction
                v = rand(-20:2:20, 30)
                bars(v, xwidth=14, barfunction=barfunc2)
            else
                v = randn(15)
                bars(v)
            end
        end
    end
    @test finish() == true
    println("...finished barstest, saved in $(fname)")
end

fname = "bars-test.pdf"
test_bars(fname)
