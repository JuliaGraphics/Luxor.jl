#!usr/bin/env julia

# random sin/cos curves

using Luxor, Colors

function randomsine(func, m, l, style)
    # y is positive downwards...
    x_vals = collect(0:pi/100:l*2*pi)
    # pl = float(hcat(x_vals * l*2*pi, [-func(d) * m for d in x_vals]))
    pl = [Point(d * 2 * pi , -sin(d) * cos(12 * d) * 8 * sin(d/10)) for d in x_vals]
    poly(pl, close=false, style)
end

function main()
    Drawing(1200, 1200, "/tmp/random-sines.pdf")
    origin()
    background("black")

    for i in 1:100
        setline(2*rand())
        setdash(["solid", "dotted", "dot", "dotdashed", "longdashed",
        "shortdashed", "dash", "dashed",
        "dotdotdashed", "dotdotdotdashed"][rand(1:end)])
        gsave()
        translate(rand(-1000:1000), rand(-1000:1000))
        scale(0.1 + rand() * 2, 0.1 + rand() * 2)
        randomhue()
        setopacity(0.5 * rand())
        randomsine(
        [sin, cos][rand(1:end)],                   # random function
        rand(50:250),                              # random vertical scale
        rand(4:20),                                # random length
        [:fill, :stroke, :fillstroke][rand(1:end)] # random drawing style
        )
        grestore()

    end
    finish()
    preview()
end

main()
