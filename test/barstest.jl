#!/usr/bin/env julia

using Luxor

if VERSION >= v"0.5.0-dev+7720"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

function barfunc1(low, high, v; extremes=extrema(values))
    @layer begin
        sethue(rescale(v, 0, extremes[2], 0, 1), rand(), rand())
        circle(low, 2, :fill)
        box(Point(low.x - 2, low.y), Point(high.x + 2, high.y), :fill)
        text(string(extremes[2]), low.x, low.y+15, halign=:center)
    end
end

function barfunc2(low, high, value; extremes=extrema(values))
    @layer begin
        sethue("red")
        randomhue()
        setline(4)
        setlinecap("round")
        line(low, high, :stroke)
        circle(high, 2, :fill)
    end
end

emptylabelfunction(args...; extremes=[]) = nothing

function mylabelfunction(bottom::Point, top::Point, value;
        extremes=[])
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
    tiles = Tiler(pagewidth, pageheight, 10, 2, margin=35)
    for (pos, n) in tiles
        @layer begin
            translate(pos)
            if n % 5 == 1
                v = collect(rand(50:100):-10:rand(-50:50))
                bars(v)
            elseif n % 5 == 2
                # no labels
                v = rand(1:10, 100)
                bars(v, xwidth=rand(2:6), yscale=rand(50:100), labelfunction=emptylabelfunction)
            elseif n % 5 == 3
                # a custom label function
                v = rand(30)
                bars(v, yscale=rand(10:80), xwidth=rand(5:20), labelfunction=mylabelfunction)
            elseif n % 5 == 4
                # a custom barfunction
                v = rand(5:10, 40)
                bars(v, yscale=30, xwidth=10, barfunction=barfunc1)
            else n % 5 == 5
                # another custom barfunction
                v = rand(-20:2:20, 30)
                bars(v, xwidth=14, barfunction=barfunc2)
            end
        end
    end
    @test finish() == true
    println("...finished barstest, saved in $(fname)")
end

fname = "bars-test.pdf"
test_bars(fname)
