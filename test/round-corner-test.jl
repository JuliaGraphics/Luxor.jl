using Luxor
using Test
using Random
Random.seed!(42)

function test_roundcorner(fname)
    @draw begin
        p1, p2, p3 = ngon(O, 100, 3, vertices = true)
        s, cp, f = roundcorner(p1, p2, p3, 50)
        line(p1, s, :stroke)
        line(f, p3, :stroke)
        arc2r(cp, s, f, :stroke)

        @test ispointonline(s, p1, p2) == true
        @test ispointonline(f, p2, p3) == true
    end

    return Drawing(700, 700, fname)
    background("black")
    origin()
        setline(1)
        bx = ngon(O, 250, 4, vertices = true)
        for radius in 0.0000001:10:400
            for (n, pt) in enumerate(bx)
                randomhue()
                p1 = bx[mod1(n - 1, end)]
                p2 = bx[mod1(n, end)]
                p3 = bx[mod1(n + 1, end)]
                startc, centerp, endc, flag = roundcorner(
                    p1, p2, p3, radius
                )
                arc2r(centerp, startc, endc, :stroke)
            end
        end
    @test finish() == true
    println("...finished test: output in $(fname)")
end

test_roundcorner("round-corner-test-1.png")
println("...finished roundcorner test")
