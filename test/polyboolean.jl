using Luxor
using Test
using Random
Random.seed!(42)

function polyboolean(fname)
    Drawing(1200, 1200, fname)
    origin()
    background("grey20")

    square = ngon(O, 100, 4, π / 4, vertices = true)
    diamond = ngon(O, 100, 4, 0, vertices = true)

    union_sd = polyunion(square, diamond)
    union_ss = polyunion(square, square)
    union_dd = polyunion(diamond, diamond)
    diff_sd = polydifference(square, diamond)
    diff_ds = polydifference(diamond, square)
    diff_ss = polydifference(square, square)
    diff_dd = polydifference(diamond, diamond)
    inter_sd = polyintersect(square, diamond)
    inter_ss = polyintersect(square, square)
    xor_sd = polyxor(square, diamond)
    xor_ss = polyxor(square, square)
    xor_ds = polyxor(diamond, square)

    # bools
    bools = [:union_sd, :union_ss, :union_dd, :diff_sd, :diff_ds, :diff_ss, :diff_dd, :inter_sd, :inter_ss, :xor_sd, :xor_ss, :xor_ds]
    
    # the corresponding n of polygons in each result
    lengths = [1, 1, 1, 4, 4, 0, 0, 1, 1, 6, 0, 6]

    areas = [
         23431.4,
         20000.0,
         20000.0,
         857.8,
         857.8,
         857.8,
         857.8,
         857.8,
         857.8,
         857.8,
         857.8,
         16568.5,
         20000.0,
         1715.7,
         857.8,
         857.8,
         857.8,
         857.8,
         1715.7,
         1715.7,
         857.8,
         857.8,
         857.8,
         857.8,
         1715.7,
    ]

    tbl = Table(4, 4, 260, 260)
    cell = 1
    polycounter = 1
    fontsize(20)
    for (n, ptest) in enumerate([union_sd, union_ss, union_dd, diff_sd, diff_ds, diff_ss, diff_dd, inter_sd, inter_ss, xor_sd, xor_ss, xor_ds])
        @layer begin
            @test length(ptest) == lengths[n]
            translate(tbl[cell])
            for p in ptest
                pc = polycentroid(p)
                @test isapprox(polyarea(p), areas[polycounter], atol=1)
                randomhue()
                prettypoly(p, :fill, close = true)
                polycounter += 1
            end
            sethue("white")
            text(string(bools[n], " ", length(ptest)), halign=:center)
            cell += 1
        end
    end
    @test finish() == true
    println("...finished test: output in $(fname)")
end

polyboolean("poly-boolean-tests.png")
