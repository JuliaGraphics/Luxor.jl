#!/Applications/Julia-0.3.2.app/Contents/Resources/julia/bin/julia

using Luxor, Color

currentwidth = 595 # pts
currentheight = 842 # pts
Drawing(currentwidth, currentheight, "/tmp/polygon-tests.pdf")

origin()
background(color("white"))

foregroundcolors = diverging_palette(230, 280, 200, s = 0.99, b=0.8)
backgroundcolors = diverging_palette(200, 260, 280, s = 0.8, b=0.5)

setopacity(0.6)

setline(2)

hexagon(x, y, size) = [Point{Float64}(x + size * cos(2 * pi/6 * i), y + size * sin(2 * pi/6 * i)) for i in 1:6]

function backgroundpattern()
    vstep = 100
    hstep = 100
    for y in -currentheight:vstep:currentheight
        for x in -currentwidth:hstep:currentwidth
            setopacity(0.3)
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
                 # tuple version
                 poly([
                        (rand() * -100,rand() * 100),
                        (rand() * -100,rand() * 100),
                        (rand() * -100,rand() * 100),
                        (rand() * -100,rand() * 100)
                     ], :fill)
                 # rect(0,0, hstep-5, vstep-5, :stroke)
            restore()

            sethue(backgroundcolors[rand(1:end)])
            save()
                 translate(x,y)
                 ngon(x, y, 50, rand(3:13), 0, :stroke)
                 rotate(rand() * pi)
                 poly(hexagon(rand() * 5, rand() * 5, 15 + rand() * 5), :stroke)
                 ngon(x, y, 50, rand(3:13), 0, :fill)
                 rect(0,0, hstep-5, vstep-5, :stroke)
                 ngon(x, y, 50, rand(3:13), 0, :none)
            restore()
        end
    end
end

# clip to septagon
ngon(0, 0, 300, 7, 0, :clip)
backgroundpattern()

finish()
preview()
