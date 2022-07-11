using Luxor
using Test

function test_hex_grids(fname)
    ha = HexagonAxial(0, 0)
    ha = HexagonAxial(0, 0, Point(10, 10))
    ha = HexagonAxial(0, 0, Point(10, 10), 10)
    ha = HexagonAxial(0, 0, Point(50, 50), 10, 10)

    convert(HexagonCubic, ha)
    # HexagonCubic(0, 0, 0, Point(10.0, 10.0), 10.0, 10.0)

    convert(HexagonOffsetOddR, ha)
    # HexagonOffsetOddR(0, 0, Point(10.0, 10.0), 10.0, 10.0)

    convert(HexagonOffsetEvenR, ha)
    # HexagonOffsetEvenR(0, 0, Point(10.0, 10.0), 10.0, 10.0)

    ha = HexagonAxial(0, 0, Point(10, 10), 10)
    hexcenter(ha)
    # Point(10.0, 10.0)

    ha = HexagonAxial(0, 0, Point(50, 50), 10, 10)
    hexcenter(ha)
    # Point(10.0, 10.0)

    ha = HexagonAxial(-1, 1, Point(50, 50), 20, 10)
    hon = convert(HexagonOffsetOddR, ha)

    hneighbors = collect(hexneighbors(hon))

    @test hneighbors[1] == HexagonCubic(0, -1, 1, Point(50.0, 50.0), 20.0, 10.0)

    Drawing(700, 800, fname)
    origin()
    ha = HexagonAxial(-1, 1, Point(20, 30), 20, 10)
    ho = convert(HexagonOffsetOddR, ha)
    pgon = hextile(ho)
    poly(pgon, :stroke, close = true)
    @test 518 < polyarea(pgon) < 520
    @test hexcenter(ho) ≈ Point(2.679491924311229, 45.0)

    ho = HexagonOffsetEvenR(0, 0, 25)
    setopacity(0.3)
    for ring in 1:10
        randomhue()
        for i in hexring(ring, ho)
            poly(hextile(i), :fill)
        end
    end

    setopacity(1)
    ho = HexagonOffsetEvenR(0, 0, 70)
    sethue("red")
    setline(10)
    poly(hextile(ho), :stroke)
    for n in hexneighbors(ho)
        randomhue()
        poly(hextile(n), :stroke, close = true)
    end

    ho = HexagonOffsetOddR(0, 0, 30)
    sethue("cyan")
    for n in hexagons_within(2, ho)
        poly(hextile(n), :stroke, close = true)
    end

    sethue("red")
    for n in hexdiagonals(ho)
        randomhue()
        poly(hextile(n), :fill, close = true)
    end

    h1 = HexagonOffsetEvenR(-10, -10, 5)
    h2 = HexagonOffsetEvenR(4, 6, 5)
    sethue("purple")
    for h in hexcube_linedraw(h1, h2)
        poly(hextile(h), :fill)
    end
    @test finish() == true
end

fname = "hex-grid-test.png"
test_hex_grids(fname)
println("...finished test: output in $(fname)")
