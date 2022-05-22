# simple benchmarks

using Luxor
using BenchmarkTools

function bm1()
    Drawing(1000, 1000, "/tmp/luxor-test1.pdf")
    origin()
    t = Tiler(1000, 1000, 10, 10, margin=10)
    for (pos, n) in t
        randomhue()
        circle(pos, t.tilewidth/2, :fill)
    end
    finish()
end

function bm2()
    Drawing(1000, 1000, "/tmp/luxor-test2.pdf")
    origin()
    t = Tiler(1000, 1000, 10, 10, margin=10)
    for (pos, n) in t
        setcolor"red"
        setopacity(rand())
        box(pos, t.tilewidth/2, t.tilewidth/2, :fill)
    end
    finish()
end

@benchmark bm1()

@benchmark bm2()

#=

1: Julia v1.0.0 Luxor v1.0.0 iMac 2018-10-05 12:37:11

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


2:  Julia v1.0.0 Luxor v1.1.0 iMac 2018-10-05 12:40:11

after some type work, there's a slight improvement in allocations

  julia-1.0> @benchmark bm1()
  BenchmarkTools.Trial:
    memory estimate:  38.94 KiB
    allocs estimate:  782
    --------------
    minimum time:     1.950 ms (0.00% GC)
    median time:      2.136 ms (0.00% GC)
    mean time:        2.302 ms (1.57% GC)
    maximum time:     68.908 ms (92.70% GC)
    --------------
    samples:          2165
    evals/sample:     1

  julia-1.0> @benchmark bm2()
  BenchmarkTools.Trial:
    memory estimate:  92.00 KiB
    allocs estimate:  2285
    --------------
    minimum time:     663.034 μs (0.00% GC)
    median time:      736.955 μs (0.00% GC)
    mean time:        806.080 μs (2.46% GC)
    maximum time:     49.676 ms (96.68% GC)
    --------------
    samples:          6164
    evals/sample:     1

3:  Julia v1.1 Luxor v1.3.0-master iMac 2019-03-03 17:30:20

  julia-1.1> @benchmark bm1()
    BenchmarkTools.Trial:
      memory estimate:  39.50 KiB
      allocs estimate:  787
      --------------
      minimum time:     1.917 ms (0.00% GC)
      median time:      2.145 ms (0.00% GC)
      mean time:        2.247 ms (1.18% GC)
      maximum time:     47.751 ms (91.55% GC)
      --------------
      samples:          2217
      evals/sample:     1

    julia-1.1> @benchmark bm2()
    BenchmarkTools.Trial:
      memory estimate:  50.27 KiB
      allocs estimate:  1190
      --------------
      minimum time:     623.612 μs (0.00% GC)
      median time:      781.187 μs (0.00% GC)
      mean time:        856.280 μs (1.62% GC)
      maximum time:     48.690 ms (95.28% GC)
      --------------
      samples:          5793
      evals/sample:     1


 =#
