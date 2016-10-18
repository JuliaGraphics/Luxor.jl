#!/usr/bin/env julia

using Luxor, Base.Test

demo = Sequence(400, 400, "test")

function backdrop_f(demo, framenumber, framerange)
    background("black")
end

function frame_f(demo, framenumber, framerange)
    xpos = 100 * cos(framenumber/100)
    ypos = 100 * sin(framenumber/100)
    sethue(Colors.HSV(rescale(framenumber, 0, 628, 0, 360), 1, 1))
    circle(xpos, ypos, 80, :fill)
    text(string("frame $framenumber of $(length(framerange))"), O)
end

mktempdir() do tmpdir
    @test animate(demo, 1:2:6, backdrop_f, frame_f, createanimation=false) == true
end

println("...finished animation test")
