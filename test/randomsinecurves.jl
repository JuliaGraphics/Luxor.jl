#!usr/bin/env julia

using Luxor, Colors

function randomsine(func, m, l, style)
    # y is positive downwards...
    x_vals = 0:pi/100:l*2*pi
    pl = [Point(d * 2 * pi , -func(d) * func(12 * d) * 8 * func(d/10)) for d in x_vals]
    poly(pl, close=false, style)
end

function main(w, h)
    Drawing(w, h, "/tmp/random-sines.pdf")
    origin()
    background("black")
    for i in 1:100
        setline(rand(0.2:0.1:30))
        setdash(["solid", "dotted", "dot", "dotdashed", "longdashed",
        "shortdashed", "dash", "dashed",
        "dotdotdashed", "dotdotdotdashed"][rand(1:end)])
        gsave()
        translate(-w/2, rand(-h:h))
        scale(rand(0.5:0.1:15), rand(0.5:0.1:15))
        randomhue()
        setopacity(rand(0.5:0.1:0.9))
        randomsine(
            [sin, cos][rand(1:end)],              # random function
            rand(50:500),                              # random vertical scale
            rand(4:20),                                # random length
            [:fill, :stroke, :fillstroke][rand(1:end)] # random drawing style
        )
        grestore()

    end
    finish()
    preview()
end

main(2000, 2000)
