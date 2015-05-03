#!/Applications/Julia-0.3.2.app/Contents/Resources/julia/bin/julia

using Luxor, Color

include("../examples/julia-logo.jl")

currentwidth = 595 # pts
currentheight = 842 # pts
Drawing(currentwidth, currentheight, "/tmp/clipping-tests.pdf")

origin()
background(color("white"))

sethue(color("black"))
foregroundcolors = diverging_palette(230, 280, 200, s = 0.99, b=0.8)
backgroundcolors = diverging_palette(200, 260, 280, s = 0.8, b=0.5)

setopacity(.4)
sethue(backgroundcolors[rand(1:end)])
translate(-100,0)
# use julia logo as clipping mask
julialogomask()
clip()
for i in 1:500
    randomhue()
    circle(rand(-50:300), rand(0:300), 20, :fill)
end

finish()
preview()
