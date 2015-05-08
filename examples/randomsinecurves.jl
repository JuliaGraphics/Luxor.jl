#!/Applications/Julia-0.3.2.app/Contents/Resources/julia/bin/julia

# random sin/cos curves

using Luxor
Drawing(1200, 1200, "/tmp/random-sines.pdf")
origin()
background(Color.color("black"))
function randomsine(func, m, l, style)
    # y is positive downwards...
    x_vals = [0:pi/100:l*2*pi]
    pl = float(hcat(x_vals * l*2*pi, [-func(d) * m for d in x_vals]))
    poly(pl, close=false, style)
end

for i in 1:100
    setline(2*rand())
    setdash(["solid", "dotted", "dot", "dotdashed", "longdashed",
             "shortdashed", "dash", "dashed",
             "dotdotdashed", "dotdotdotdashed"][rand(1:end)])
    save()
    translate(rand(-1000:1000), rand(-1000:1000))
    scale(0.1 + rand() * 2, 0.1 + rand() * 2)
    randomhue()
    setopacity(0.5 * rand())
    randomsine(
        [sin, cos][rand(1:end)],     # random function
        rand(50:250),                # random vertical scale
        rand(4:20), # random length
        [:fill, :stroke, :fillstroke][rand(1:end)] # random drawing style
        )
    restore()
end
finish()
preview()
