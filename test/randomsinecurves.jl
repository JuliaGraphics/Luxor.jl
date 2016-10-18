#!/usr/bin/env julia

using Luxor

if VERSION >= v"0.5.0-dev+7720"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

function randomsine(func, vertscale, horizontalscale, pagewidth, pageheight, style, delta=0.1)
    # y is positive downwards...
    pl = Point[]
    xc=delta
    if rand(Bool)
        for i in -pagewidth/2:delta:pagewidth/2
            push!(pl, Point(i, vertscale * -func(i/horizontalscale) * func(3 * i/horizontalscale) * func(i/horizontalscale)))
        end
    else
        for i in -pagewidth/2:delta:pagewidth/2
            push!(pl, Point(i, vertscale * -func(i / horizontalscale)))
        end
    end
    #push!(pl, Point(pagewidth/2,  pl[end].y))
    #push!(pl, Point(-pagewidth/2, pl[1].y))
    poly(pl, close=false, style)
end

function random_sines(w, h, fname)
    Drawing(w, h, fname)
    origin()
    background("black")
    for i in 1:250
        setline(rand(0.02:0.01:3))
        setdash([
         "solid",
         "dotted",
         "dot",
         "dotdashed",
         "longdashed",
         "shortdashed",
         "dash",
         "dashed",
         "dotdotdashed",
         "dotdotdotdashed"
         ][rand(1:end)])
        gsave()
        sf = rand(1:15)
        scale(sf, sf)
        translate(0, rand(-h/2:h/2))
        randomhue()
        setopacity(rand(0.25:0.1:0.75))
        randomsine(
         [sin, cos][rand(1:end)],                    # random function
         rand(20:40),                               # random vertical scale
         rand(10:20),                                # horizontalscale
         w,                                          # pagewidth
         h,                                          # pageheight
         [:fill, :stroke, :stroke, :fillstroke][rand(1:end)], # random drawing style
         rand(0.1:0.1:0.5))
        grestore()
    end
    @test finish() == true
end

fname = "random-sines.pdf"
random_sines(2000, 2000, fname)
println("...finished test: output in $(fname)")
