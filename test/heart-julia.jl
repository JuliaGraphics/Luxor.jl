#!/usr/bin/env julia

using Luxor

using Test

using Random

using Colors

Random.seed!(42)

function background_text(str_array)
    colorband = diverging_palette(0, 10, 100)
    gsave()
    setopacity(0.5)
    x = -currentwidth / 2
    y = -currentheight / 2
    fontsize(12)
    while y < currentheight / 2
        sethue(colorband[rand(1:end)])
        s = str_array[rand(1:end)]
        text(s, x, y)
        se = textextents(s)
        x += se[5] # move to the right
        if x > currentwidth / 2
            x = -currentwidth / 2 # next row
            y += 10
        end
    end
    grestore()
end

function heart()
    move(127, 1) # damn, it's offset from 0/0, who drew this :/
    curve(134.2, -6.5, 134.2, -6.5, 156.1, -29.6)
    curve(185.8, -60.5, 198.1, -74.3, 213.7, -95.3)
    curve(240.4, -131, 253.3, -163.7, 253.3, -194.9)
    curve(253.3, -218, 246.4, -237.8, 232.6, -253.7)
    curve(219.1, -268.7, 204.1, -275.3, 181.9, -275.3)
    curve(154, -275.3, 136.3, -265.1, 127, -243.8)
    curve(124, -252.5, 120.4, -257.6, 112.9, -263.6)
    curve(103.6, -270.8, 88.3, -275.3, 73.3, -275.3)
    curve(59.2, -275.3, 46, -271.4, 35.2, -264.5)
    curve(14.5, -250.7, 1, -223.4, 1, -194.6)
    curve(1, -167.3, 13, -136.4, 37.3, -101)
    curve(53.8, -77, 86.5, -39.8, 127, 1)
    closepath()
end

function heart_with_julias(x = 0, y = 0)
    gsave()
    translate(x, y)
    setcolor("lavenderblush")
    heart()
    fillpreserve()
    clip()
    translate(-50, -300)
    for y in 0:30:500
        gsave()
        for x in 0:30:250
            translate(30, 0)
            gsave()
            scale(0.1, 0.1)
            julialogo()
            grestore()
        end
        grestore()
        translate(0, 20)
    end
    clipreset()
    grestore()
end

function outlined_heart()
    gsave()
    scale(1.2, 1.2)
    translate(-127, -30) # must fix that x-offset one day
    heart_with_julias()
    heart()
    setline(4)
    setcolor(1, 0, 0)
    strokepath()
    grestore()
end

function julia_heart(fname)
    global currentwidth = 1928 # pts
    global currentheight = 1064 # pts
    Drawing(currentwidth, currentheight, fname)

    origin()
    background("black")
    namelist = map(x -> string(x), names(Base)) # list of names in Base.

    background_text(namelist)
    for n in 1:5
        rotate(2pi / 5)
        outlined_heart()
    end
    @test finish() == true
    println("...finished test: output in $(fname)")
end

julia_heart("heart-julia.pdf")
