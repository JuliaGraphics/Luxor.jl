#!/usr/bin/env julia

using Luxor

if VERSION >= v"0.5.0-dev+7720"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

demo = Movie(400, 400, "test", 0:359)

function backdrop(movie, framenumber)
    background("black")
end

function frame(movie, framenumber)
    sethue(Colors.HSV(framenumber, 1, 1))
    circle(polar(100, -pi/2 - (framenumber/360) * 2pi), 80, :fill)
    text(string("frame $framenumber of $(length(movie.movieframerange))"), Point(O.x, O.y-190))
end

mktempdir() do tmpdir
    @test animate(demo, [Scene(demo, 0:359,  backdrop), Scene(demo, 0:359,  frame)], creategif=true) == true
end

println("...finished animation test")
