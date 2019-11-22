#!/usr/bin/env julia

using Luxor

using Test

using Random
Random.seed!(42)

function arrow_test(fname)
    pagewidth, pageheight = 2000, 2000
    Drawing(pagewidth, pageheight, fname)
    origin() # move 0/0 to center
    background("ivory")
    setopacity(0.8)
    pagetiles = Tiler(pagewidth, pageheight, 40, 8, margin=50)
    theta = 0
    for theta in range(0, step=π/8, stop = 2π - π/8)
        @layer begin
            rotate(theta)
            translate(120, 0)
            sethue("magenta")
            line(O, O + (230, 230), :stroke)
            sethue("grey10")
            arrow(O, O + (230, 230), [rand(-80:80), rand(-80:80)],
                :stroke,
                linewidth=3,
                startarrow=rand(Bool),
                finisharrow=rand(Bool),
                arrowheadlength=30,
                decoration = rescale(theta, 0, 2π),
                decorate=() -> (randomhue(), circle(O, rescale(theta, 0, 2π, 5, 20), :fill)))
        end
    end
    @test finish() == true
end

Random.seed!(42)
fname = "arrow-bezier-test.pdf"
arrow_test(fname)
println("...finished test: output in $(fname)")
