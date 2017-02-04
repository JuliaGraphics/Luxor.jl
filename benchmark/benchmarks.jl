using BenchmarkTools, Luxor

@show @benchmark begin
    Drawing(1000, 1000, "/tmp/test1.pdf")
    origin()
    t = Tiler(1000, 1000, 10, 10, margin=10)
    for (pos, n) in t
        randomhue()
        circle(pos, t.tilewidth/2, :fill)
    end
    finish()
end

@show @benchmark begin
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

results of latest version of 2017-02-02 13:54:56 

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

=#
