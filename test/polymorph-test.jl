using Luxor
using Test
using Random

Random.seed!(42)

function polymorph_test_1(fname)
    Drawing(500, 500, fname)
    background("grey20")
    origin()
    sethue("white")

    poly1 = [Point(70x, -200 + 20sin(x)) for x in -π:0.1:π]
    poly2 = [Point(70x, 200 + 20sin(2x)) for x in -π:0.1:π]

    poly(poly1, :stroke)
    poly(poly2, :stroke)

    # test that first points and last points remain the same x
    for i in 0:0.02:1.0
        pm = polymorph(poly1, poly2, i, closed=false, samples=50)
        poly.(pm, :stroke)
        @test first(pm[1]).x ≈ poly1[1].x ≈ poly2[1].x
        @test poly1[end].x ≈ poly2[end].x ≈ last(pm[1]).x
    end

    @test finish() == true

    println("...finished test: output in $(fname)")
end

polymorph_test_1("polymorph-test-1.png")
