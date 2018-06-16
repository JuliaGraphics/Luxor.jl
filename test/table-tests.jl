#!/usr/bin/env julia

using Luxor, Random

using Test

function testtable(fname)
    srand(3)
    currentwidth = 800
    currentheight = 800
    Drawing(currentwidth, currentheight, fname)
    origin()
    background("white")

    t = Table(collect(linspace(30, 85, 10)), collect(linspace(20, 75, 10)))
    sethue("red")
    circle.(t[:, 3], 10, :fill)
    sethue("blue")
    circle.(t[3, :], 9, :fill)
    sethue("green")
    circle(t[4, 5], 8, :fill)

    for n in 1:20
        randomhue()
        circle.(t[rand(1:10), :], 7, :fill)
    end
    for n in 1:30
        randomhue()
        circle.(t[:, rand(1:10)], 6, :fill)
    end

    sethue("black")
    fontsize(10)
    for n in 1:length(t)
        label(string(n), :n, t[n], offset=15)
    end

    @test finish() == true
end

fname = "table.png"
testtable(fname)
println("table test: output in $(fname)")
println("...finished table tests: output in $(fname)")
