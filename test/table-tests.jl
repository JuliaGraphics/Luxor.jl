#!/usr/bin/env julia

using Luxor

using Test

using Random
Random.seed!(42)

function testtable(fname)
    currentwidth = 800
    currentheight = 800
    Drawing(currentwidth, currentheight, fname)
    origin()
    background("white")
    setline(0.5)

    # test single cell tables
    t = Table(1, 1, 0, 0)
    for n in t
        pt = n[1]
        i = n[2]
    end

    t = Table(
        collect(range(30, stop=85, length=10)),
        collect(range(20, stop=75, length=10)))
    for n in t
        pt = n[1]
        i = n[2]
    end

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
    setline(2)
    highlightcells(t, 1:3:length(t), offset=2)

    sethue("black")
    fontsize(10)
    for (pt, n) in t
        label(string(n), :n, t[n], offset=15)
    end

    @test finish() == true
end

fname = "table.png"
testtable(fname)
println("table test: output in $(fname)")
println("...finished table tests: output in $(fname)")
