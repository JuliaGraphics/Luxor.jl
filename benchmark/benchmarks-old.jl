using BenchmarkTools, Luxor

@benchmark begin
    Drawing(1000, 1000, "/tmp/test1.pdf")
    origin()
    t = Tiler(1000, 1000, 10, 10, margin=10)
    for (pos, n) in t
        randomhue()
        circle(pos, t.tilewidth/2, :fill)
    end
    finish()
end

@benchmark begin
    Drawing(1000, 1000, "/tmp/test2.pdf")
    origin()
    t = Tiler(1000, 1000, 10, 10, margin=10)
    for (pos, n) in t
        sethue("red")
        setopacity(rand())
        box(pos, t.tilewidth/2, t.tilewidth/2, :fill)
    end
    finish()
end

#=

results of version of 2017-02-02 13:54:56
macOS, Luxor release 0.7.5, Julia release 0.5

BenchmarkTools.Trial:
  memory estimate:  90.02 kb
  allocs estimate:  3793
  --------------
  minimum time:     9.414 ms (0.00% GC)
  median time:      59.505 ms (0.00% GC)
  mean time:        81.055 ms (0.00% GC)
  maximum time:     661.512 ms (0.00% GC)
  --------------
  samples:          68
  evals/sample:     1
  time tolerance:   5.00%
  memory tolerance: 1.00%

BenchmarkTools.Trial:
  memory estimate:  163.45 kb
  allocs estimate:  6293
  --------------
  minimum time:     4.790 ms (0.00% GC)
  median time:      69.581 ms (0.00% GC)
  mean time:        97.392 ms (0.00% GC)
  maximum time:     682.977 ms (0.00% GC)
  --------------
  samples:          57
  evals/sample:     1
  time tolerance:   5.00%
  memory tolerance: 1.00%


results of version of 2017-02-18 08:46:03
macOS, Luxor release 0.8, Julia release 0.5

BenchmarkTools.Trial:
  memory estimate:  90.02 KiB
  allocs estimate:  3793
  --------------
  minimum time:     2.827 ms (0.00% GC)
  median time:      3.462 ms (0.00% GC)
  mean time:        3.649 ms (0.41% GC)
  maximum time:     13.403 ms (0.00% GC)
  --------------
  samples:          1361
  evals/sample:     1
  time tolerance:   5.00%
  memory tolerance: 1.00%

BenchmarkTools.Trial:
  memory estimate:  163.45 KiB
  allocs estimate:  6293
  --------------
  minimum time:     1.711 ms (0.00% GC)
  median time:      2.266 ms (0.00% GC)
  mean time:        4.049 ms (0.78% GC)
  maximum time:     56.930 ms (0.00% GC)
  --------------
  samples:          1232
  evals/sample:     1
  time tolerance:   5.00%
  memory tolerance: 1.00%

results of version of 2017-02-18 08:51:01
macOS, Luxor release 0.8, Julia release 0.6

BenchmarkTools.Trial:
  memory estimate:  89.92 KiB
  allocs estimate:  3792
  --------------
  minimum time:     2.904 ms (0.00% GC)
  median time:      3.572 ms (0.00% GC)
  mean time:        4.149 ms (0.30% GC)
  maximum time:     50.399 ms (0.00% GC)
  --------------
  samples:          1198
  evals/sample:     1
  time tolerance:   5.00%
  memory tolerance: 1.00%

BenchmarkTools.Trial:
  memory estimate:  158.67 KiB
  allocs estimate:  6392
  --------------
  minimum time:     2.464 ms (0.00% GC)
  median time:      3.117 ms (0.00% GC)
  mean time:        3.878 ms (0.59% GC)
  maximum time:     29.715 ms (0.00% GC)
  --------------
  samples:          1282
  evals/sample:     1
  time tolerance:   5.00%
  memory tolerance: 1.00%

results of version of 2017-09-29T09:32:07.122
macOS, Luxor release 0.9.1, Julia release 0.6

  BenchmarkTools.Trial:
    memory estimate:  89.94 KiB

    allocs estimate:  3792
    --------------
    minimum time:     2.820 ms (0.00% GC)
    median time:      3.304 ms (0.00% GC)
    mean time:        4.307 ms (0.18% GC)
    maximum time:     18.284 ms (0.00% GC)
    --------------
    samples:          1160
    evals/sample:     1

  BenchmarkTools.Trial:
    memory estimate:  149.31 KiB
    allocs estimate:  5792
    --------------
    minimum time:     2.129 ms (0.00% GC)
    median time:      2.609 ms (0.00% GC)
    mean time:        3.753 ms (0.35% GC)
    maximum time:     22.421 ms (0.00% GC)
    --------------
    samples:          1331
    evals/sample:     1

results of version of 2017-07-29 18:07:01
macOS, Luxor release 0.9, Julia release 0.7

BenchmarkTools.Trial:
  memory estimate:  149.31 KiB
  allocs estimate:  5793
  --------------
  minimum time:     1.968 ms (0.00% GC)
  median time:      2.363 ms (0.00% GC)
  mean time:        4.024 ms (1.69% GC)
  maximum time:     846.859 ms (0.00% GC)
  --------------
  samples:          1241
  evals/sample:     1


=#
