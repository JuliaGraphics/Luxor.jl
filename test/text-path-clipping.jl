using Luxor

using Test

using Random
Random.seed!(42)

function text_path_clip(fname)
    currentwidth = 1250 # pts
    currentheight = 800 # pts
    Drawing(currentwidth, currentheight, fname)

    origin()
    background("darkslategray3")

    fontsize(600) # big text to use for clipping
    fontface("Agenda-Black")
    str = "julia" # string to be clipped
    w, h = textextents(str)[3:4] # get width and height

    translate(-(currentwidth/2) + 50, -(currentheight/2) + h)

    textpath(str) # make text into a path
    setline(3)
    setcolor("black")
    fillpreserve() # fill but keep
    clip()  # clip

    fontface("Monaco")
    fontsize(10)
    namelist = map(x->string(x), names(Base)) # list of names in Base.

    x = -20
    y = -h
    while y < currentheight
        sethue(rand(7:10)/10, rand(7:10)/10, rand(7:10)/10)
        s = namelist[rand(1:end)]
        text(s, x, y)
        se = textextents(s)
        x += se[5] # move to the right
        if x > w
           x = -20 # next row
           y += 10
        end
    end

    @test finish() == true
end

fname = "text-path-clipping.png"
text_path_clip(fname)
println("...finished test: output in $(fname)")
