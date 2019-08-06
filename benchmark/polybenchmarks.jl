# polygon benchmarks
using Luxor, BenchmarkTools, TimerOutputs

const to = TimerOutput()

function testpoly()
    pgon = star(O, 201.9, 23, 0.8, π / 2, vertices = true)
    @timeit to "polycentroid" begin
        for i in 1:10
            pc = polycentroid(pgon)
        end
    end

    @timeit to "polyportion" begin
        for i in 1:10
            ps = polyportion(pgon, i / 10)
        end
    end

    @timeit to "polyremainder" begin
        for i in 1:10
            ps = polyremainder(pgon, i / 10)
        end
    end

    @timeit to "polyarea" begin
        for i in 1:10
            pa = polyarea(pgon)
        end
    end

    @timeit to "polyperimeter" begin
        for i in 1:10
            pa = polyperimeter(pgon)
        end
    end

    @timeit to "polydistances" begin
        for i in 1:10
            pa = polydistances(pgon)
        end
    end

    @timeit to "polysample" begin
        for i in 1:10
            pa = polysample(pgon, 200)
        end
    end

    @timeit to "polyrotate" begin
        for i in 1:10
            polyrotate!(pgon, π / 5, center = O + (20, 20))
        end
    end

    pgon1 = deepcopy(pgon)
    @timeit to "polyreflect" begin
        for i in 1:10
            polyreflect!(pgon1, O, O + (49.9, 51.1))
        end
    end

    pgon1 = deepcopy(pgon)
    @timeit to "polymove" begin
        for i in 1:10
            polymove!(pgon1, O, O + (2000.1, 1999.9))
        end
    end

    pgon1 = deepcopy(pgon)
    @timeit to "polyscale" begin
        for i in 1:10
            polyscale!(pgon1, 2, 0.5, center = O + (200.1, 199.9))
        end
    end

    @timeit to "polysortbyangle" begin
        for i in 1:10
            polysortbyangle(pgon)
        end
    end

    @timeit to "polysortbydistance" begin
        for i in 1:10
            polysortbydistance(pgon, pgon[1])
        end
    end

    @timeit to "polyorientation" begin
        for i in 1:10
            polyorientation(pgon)
        end
    end

    @timeit to "polysplit" begin
        for i in 1:10
            polysplit(pgon, O - (0, 100), O - (0, 100))
        end
    end

    @timeit to "polyfit" begin
        for i in 1:10
            polyfit(pgon, 200)
        end
    end

    @timeit to "polysmooth" begin
        for i in 1:10
            polysmooth(pgon, 5, :none)
        end
    end

    @timeit to "offsetpoly" begin
        for i in 1:10
            offsetpoly(pgon, 5)
        end
    end

    @timeit to "polyremovecollinearpoints" begin
        for i in 1:10
            polyremovecollinearpoints(pgon)
        end
    end

    pgon1 = star(O, 201.9, 23, 0.8, π / 2, vertices = true)
    pgon2 = star(O, 201.9, 23, 0.8, π / 5, vertices = true)
    @timeit to "polyintersect" begin
        for i in 1:10
            polyintersect(pgon1, pgon2)
        end
    end

    pgon1 = star(O, 201.9, 23, 0.8, π / 2, vertices = true)
    pgon2 = star(O, 201.9, 23, 0.8, π / 5, vertices = true)
    @timeit to "polyintersections" begin
        for i in 1:10
            polyintersections(pgon1, pgon2)
        end
    end

    @timeit to "polytriangulate" begin
        pgons = []
        for i in 1:10
            pgon3 = deepcopy(pgon)
            pgons = polytriangulate!(pgon3)
        end
    end

    return pgon1, pgon2, pgons

end

# polyfit

function benchone()
    pgon = star(O, 201.9, 23, 0.8, π / 2, :stroke)
    sethue("red")
    p1 = p2 = p3 = Point[]
    for i in 1:10
        p1, p2, p3 = testpoly()
    end
    return p1, p2, p3
end

function drawtest()
    @png begin
        reset_timer!(to)
        p1, p2, p3 = benchone()
        print_timer(to)
        println()
        poly(p1, :stroke)
        scale(0.6)
        poly(p2, :stroke)
        sethue("green")
        scale(0.7)
        for i in p3
            randomhue()
            poly(i, :fill)
        end
    end 500 500 "/tmp/polybenchmark.png"
end

drawtest()

@btime benchone();
#=
────────────────────────────────────────────────────────────────────────────────────
                                             Time                   Allocations
                                     ──────────────────────   ───────────────────────
          Tot / % measured:               115ms / 94.1%            120MiB / 100%

 Section                     ncalls     time   %tot     avg     alloc   %tot      avg
 ────────────────────────────────────────────────────────────────────────────────────
 polytriangulate                 10   61.7ms  57.0%  6.17ms    102MiB  85.1%  10.2MiB
 polyintersections               10   16.2ms  14.9%  1.62ms   1.46MiB  1.22%   150KiB
 polyintersect                   10   16.0ms  14.8%  1.60ms   1.26MiB  1.05%   129KiB
 polysmooth                      10   4.59ms  4.24%   459μs   2.67MiB  2.22%   273KiB
 polyfit                         10   2.97ms  2.74%   297μs   6.30MiB  5.25%   645KiB
 polysortbydistance              10   2.62ms  2.42%   262μs   1.93MiB  1.61%   198KiB
 polysample                      10    992μs  0.92%  99.2μs    944KiB  0.77%  94.4KiB
 polyorientation                 10    667μs  0.62%  66.7μs   1.26MiB  1.05%   129KiB
 polyportion                     10    499μs  0.46%  49.9μs    289KiB  0.24%  28.9KiB
 offsetpoly                      10    459μs  0.42%  45.9μs   79.7KiB  0.06%  7.97KiB
 polysortbyangle                 10    329μs  0.30%  32.9μs    177KiB  0.14%  17.7KiB
 polyremovecollinearpoints       10    325μs  0.30%  32.5μs    546KiB  0.44%  54.6KiB
 polyremainder                   10    316μs  0.29%  31.6μs    287KiB  0.23%  28.7KiB
 polysplit                       10    305μs  0.28%  30.5μs    442KiB  0.36%  44.2KiB
 polyreflect                     10   85.3μs  0.08%  8.53μs     0.00B  0.00%    0.00B
 polyperimeter                   10   75.3μs  0.07%  7.53μs    116KiB  0.09%  11.6KiB
 polydistances                   10   59.7μs  0.06%  5.97μs    116KiB  0.09%  11.6KiB
 polyarea                        10   27.3μs  0.03%  2.73μs     0.00B  0.00%    0.00B
 polyrotate                      10   26.9μs  0.02%  2.69μs     0.00B  0.00%    0.00B
 polycentroid                    10   13.0μs  0.01%  1.30μs     0.00B  0.00%    0.00B
 polyscale                       10   4.40μs  0.00%   440ns     0.00B  0.00%    0.00B
 polymove                        10   4.33μs  0.00%   434ns     0.00B  0.00%    0.00B
 ────────────────────────────────────────────────────────────────────────────────────
  103.993 ms (3177473 allocations: 120.12 MiB)
 =#
