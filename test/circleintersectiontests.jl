#!/usr/bin/env julia

using Luxor, Test, Random
Random.seed!(42)

function testcircleintersections(fname)
    # completely overlapping circles
    c1 = (O, 100)
    c2 = (O, 100)
    cia = intersection2circles(c1..., c2...)
    @test isapprox(cia, 10000π, atol=0.1)

    # nonoverlapping circles
    c1 = (O, 100)
    c2 = (O + (200, 200), 100)
    cia = intersection2circles(c1..., c2...)
    @test isapprox(cia, 0.0, atol=0.1)

    # test for transition between inside and outside
    c1 = (O, 100)
    for v in -200:200
        c2 = (O + (100 * sqrt(2), 100 * sqrt(2)), 100 + (v * eps(Float64)))
        cia = intersection2circles(c1..., c2...)
    end
    @test 0.0 < cia < 0.000000001

    pagewidth, pageheight = 1200, 1400
    Drawing(pagewidth, pageheight, fname)
    background("grey30")
    origin() # move 0/0 to center

    @layer  begin
        scale(2)
        setopacity(0.3)
        sethue("cyan")
        circle(c1..., :fill)
        circle(c2..., :fill)
        sethue("red")
        circle(c1..., :clip)
        circle(c2..., :fill)
        clipreset()
    end

    occultations  = []
    for (pt, n) in Table(10, 10, 120, 120)
        c1 = (O, rand(5:40))
        c2 = (O + (rand(-20:20, 2)...), rand(10:50))
        cia = intersection2circles(c1..., c2...)
        push!(occultations, (c1, c2, cia))
    end

    sort!(occultations, by = (x) -> last(x))

    for (pt, n) in Table(10, 10, 120, 120)
        c1, c2, cia = occultations[n]
        @layer begin
            translate(pt)
            randomhue()
            circle(c1..., :fill)
            circle(c2..., :fill)
            sethue("white")
            circle(c1..., :clip)
            circle(c2..., :fill)
            clipreset()
            text(string(round(cia)), O + (0, 50), halign=:center)
        end
    end
    fontsize(30)
    sethue("white")
    text("assorted occultations sorted by area", boxtopcenter(BoundingBox() * 0.9), halign=:center)
    @test finish() == true
    println("...finished circletest, saved in $(fname)")
end

fname = "circle-intersection-test.png"

testcircleintersections(fname)
