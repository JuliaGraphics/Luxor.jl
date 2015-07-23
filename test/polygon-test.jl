#!/Applications/Julia-0.3.10.app/Contents/Resources/julia/bin/julia

using Luxor, Color

currentwidth = 595 # pts
currentheight = 842 # pts
Drawing(currentwidth, currentheight, "/tmp/polygon-test.pdf")

origin()
background(color("antiquewhite"))

foregroundcolors = diverging_palette(230, 280, 200, s = 0.99, b=0.8)
backgroundcolors = diverging_palette(200, 260, 280, s = 0.8, b=0.5)

setopacity(0.6)

setline(2)

hexagon(x, y, size) = [Point{Float64}(x + size * cos(2 * pi/6 * i), y + size * sin(2 * pi/6 * i)) for i in 1:6]

function simple_polys()
    save()
    sethue(0,0,0)
    vstep = 50
    hstep = 50
    x = 0
    y = 0
    translate(-currentwidth/2 + 50, -currentheight/2 + 50)
    for sides in 3:12
        ngon(x, y, 20, sides, 0, :stroke)
        x += hstep
        if x > currentwidth x = 0; y += vstep end
    end
    translate(0, currentheight - 150)
    x = 0
    for sides in 3:12
        ngon(x, y, 20, sides, 0, :fill, close=false)
        x += hstep
        if x > currentwidth x = 0; y += vstep end
    end

    restore()
end

function hex_mixtures()
    save()
    vstep = 50
    hstep = 50
    for y in -currentheight:vstep:currentheight
        for x in -currentwidth:hstep:currentwidth
            setopacity(0.2)
            setline(rand()*10)
            sethue(backgroundcolors[rand(1:end)])
            save()
                 translate(x,y)
                 rotate(rand() * pi)
                 # point version
                 poly(hexagon(rand() * 5, rand() * 5, 15 + rand() * 5), :fill, close=true)
                 setopacity(0.1)
                 poly(hexagon(rand() * 10, rand() * 5, 15 + rand() * 5))
                 setopacity(0.3)
                 randomhue()
                 poly([
                        Point(rand() * -100,rand() * 100),
                        Point(rand() * -100,rand() * 100),
                        Point(rand() * -100,rand() * 100),
                        Point(rand() * -100,rand() * 100)
                     ], :fill)
            restore()
            sethue(backgroundcolors[rand(1:end)])
            save()
                 translate(x,y)
                 ngon(x, y, 50, rand(3:13), 0, :stroke)
                 rotate(rand() * pi)
                 poly(hexagon(rand() * 5, rand() * 5, 15 + rand() * 5), :stroke)
                 ngon(x, y, 50, rand(3:13), 0, :fill)
                 rect(0, 0, hstep-5, vstep-5, :stroke)
                 ngon(x, y, 50, rand(3:13), 0, :none)
            restore()
        end
    end
    restore()
end

# fill, then clip to heptagon
setcolor(color("lightcyan"))
setline(3)
ngon(0, 0, 270, 7, 0, :fillpreserve) # fill it
sethue(color("orange"))
strokepreserve()                     # stroke it
clip()                               # then use to clip
hex_mixtures()
clipreset()

simple_polys()

finish()
preview()
