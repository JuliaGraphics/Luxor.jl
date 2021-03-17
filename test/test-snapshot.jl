#!/usr/bin/env julia

using Luxor, Test, Random

function drawcentered(Δα)
    println(Δα * 360 /6.28)
    setline(8)
    for r = 0:20:5000
        α = r / 100  + Δα
        circle(O + sqrt(r ) .* (cos(α), sin(α)), r, :stroke)
        settext("<span font = '16' foreground = 'darkblue' > $(string(r)) </span>", 
            O + (0, 8 -r ); markup = true)
    end
end

function draw_and_snapshot(fname)
    drawcentered(0.5 * tryparse(Float64, filter(isnumeric, fname)))
    @test typeof(snapshot(;fname)) == Drawing
    println("...finished test: output in $(fname)")
end

Drawing(640, 480, :rec)
origin(O + (300, 200))
sethue("gold4")
draw_and_snapshot("test-snapshot1.png")
sethue("gold3")
draw_and_snapshot("test-snapshot2.svg")
sethue("gold2")
draw_and_snapshot("test-snapshot3.pdf")
sethue("gold2")
draw_and_snapshot("test-snapshot4.png")
origin()
sethue("red")
box(BoundingBox() - 50, :stroke)
snapshot(;fname = "test-snapshot5.png", w = 320, h = 240)
finish()
