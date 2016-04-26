#!usr/bin/env julia

using Luxor, Colors

function randomsine(func, vertscale, horizontalscale, pagewidth, pageheight, style, delta=0.1)
    # y is positive downwards...
    pl = Point[]
    xc=delta
    for i in -pagewidth/2:delta:pagewidth/2
        if rand(Bool)
            push!(pl, Point(i, vertscale * -func(i/horizontalscale) * func(3 * i/horizontalscale) * func(i/horizontalscale)))
        else
            push!(pl, Point(i, vertscale * -func(i / horizontalscale)))
        end
    end
    push!(pl, Point(pagewidth/2,  pl[end].y))
    push!(pl, Point(-pagewidth/2, pl[1].y))
    poly(pl, close=false, style)
end

#= this is
a string 

=#


function main(w, h)
    Drawing(w, h, "/tmp/random-sines.pdf")
    origin()
    background("black")
    for i in 1:250
        setline(rand(0.2:0.1:3))
        setdash(["solid",
        "dotted",
        "dot",
        "dotdashed",
        "longdashed",
        "shortdashed",
        "dash",
        "dashed",
        "dotdotdashed",
        "dotdotdotdashed"][rand(1:end)])
        gsave()
        sf = rand(1:0.1:15)
        scale(sf, sf)
        translate(0, rand(-h/2:5:h/2))
        randomhue()
        setopacity(rand(0.85:0.1:0.98))
        randomsine(
         [sin, cos][rand(1:end)],                    # random function
         rand(2:25),                                 # random vertical scale
         rand(1:.5:15),                              # horizontalscale
         w,                                          # pagewidth
         h,                                          # pageheight
         [:fill, :stroke, :fillstroke][rand(1:end)], # random drawing style
         rand(0.1:0.1:0.5))
        grestore()
    end
    finish()
    preview()
end

main(2000, 2000)
