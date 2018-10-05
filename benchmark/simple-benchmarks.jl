# simple benchmars

using Luxor, BenchmarkTools

using BenchmarkTools

function bm1()
    @info
    Drawing(1000, 1000, "luxor-test1.pdf")
    origin()
    t = Tiler(1000, 1000, 10, 10, margin=10)
    for (pos, n) in t
        randomhue()
        circle(pos, t.tilewidth/2, :fill)
    end
    finish()
end

function bm2()
    Drawing(1000, 1000, "luxor-test2.pdf")
    origin()
    t = Tiler(1000, 1000, 10, 10, margin=10)
    for (pos, n) in t
        sethue("red")
        setopacity(rand())
        box(pos, t.tilewidth/2, t.tilewidth/2, :fill)
    end
    finish()
end

@benchmark bm1()

@benchmark bm2()

#=

Julia v1.0.0 Luxor v1.0.0 iMac

julia-1.0> @benchmark bm1()
BenchmarkTools.Trial:
  memory estimate:  75.00 KiB
  allocs estimate:  2886
  --------------
  minimum time:     1.975 ms (0.00% GC)
  median time:      2.151 ms (0.00% GC)
  mean time:        2.271 ms (1.59% GC)
  maximum time:     56.407 ms (93.63% GC)
  --------------
  samples:          2196
  evals/sample:     1

julia-1.0> @benchmark bm2()
BenchmarkTools.Trial:
  memory estimate:  131.19 KiB
  allocs estimate:  4689
  --------------
  minimum time:     830.662 μs (0.00% GC)
  median time:      1.049 ms (0.00% GC)
  mean time:        1.169 ms (2.81% GC)
  maximum time:     61.274 ms (97.08% GC)
  --------------
  samples:          4247
  evals/sample:     1

 =#
