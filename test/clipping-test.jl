#!/Applications/Julia-0.3.2.app/Contents/Resources/julia/bin/julia

using Luxor, Color

include("../examples/julia-logo.jl") # the julia logo coordinates

currentwidth = 2000 # pts
currentheight = 2000 # pts
Drawing(currentwidth, currentheight, "/tmp/clipping-tests.png")

function draw_logo_clip(x, y)
    foregroundcolors = diverging_palette(rand(0:360), rand(0:360), 200, s = 0.99, b=0.8)
    save()
    translate(x-100, y)
    # use julia logo as clipping mask
    julialogomask()
    clip()
    for i in 1:500
        sethue(foregroundcolors[rand(1:end)])
        circle(rand(-50:350), rand(0:300), 15, :fill)
    end
    restore()
end

origin()
background(color("black"))
setopacity(.4)

for y in (-currentheight/2)+200:250:(currentheight/2)-100
    for x in (-currentwidth/2)+175:375:currentwidth/2
        draw_logo_clip(x,y)
    end
end
finish()
preview()
