using Luxor, Colors

include("julia-logo.jl")

function spiral()
    save()
    scale(.3, .3)
    r = 200
    setcolor("gray")
    for i in 0:pi/8:(2*pi)
        save()
        translate(r * cos(i), r * sin(i))
        rotate(i)
        julialogo()
        restore()
    end
    restore()
end

function expandingspiral()
    save()
    scale(.3, .3)
    r = 200
    for i in pi:pi/12:(6*pi)
        save()
        translate(i/3 * r * cos(i), i/3 * r * sin(i))
        scale(0.8, 0.8)
        rotate(i)
        julialogo()
        restore()
    end
    restore()
end

function dropshadow()
    steps=20
    # white-gray ramp
    gramp = linspace(colorant"white", colorant"gray60", steps)
    save()
    r = 200
    setopacity(0.1)
    for i in 1:steps
        sethue(gramp[i])
        translate(-0.6,-0.5)
        julialogo(false)
    end
    julialogo()
    restore()
end

function colorgrid()
    #cols = colormap("RdBu", 5; mid=0.5, logscale=false)
    #cols = sequential_palette(rand(10:360), 5, b=0.1)
    cols = distinguishable_colors(25)
    save()
    c = 0
    for row in 100:100:500
        for column in 100:100:500
            save()
            setcolor(color(cols[c+=1]))
            translate(row, column)
            scale(0.3, 0.3)
            julialogo(false)
            restore()
        end
    end
    restore()
end

function main()
    Drawing(1600,1600, "/tmp/test.png")
    origin()
    background("white")

    translate(-500,-200)
    spiral()

    translate(750,0)
    expandingspiral()

    translate(-1000,500)
    dropshadow()

    translate(700, -100)
    colorgrid()

    finish()
    preview()
end

main()
