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

    pgon1 = star(O, 201.9, 23, 0.8, π / 2, vertices = true)
    @timeit to "polyreflect" begin
        for i in 1:10
            polyreflect!(pgon1, O, O + (49.9, 51.1))
        end
    end

    pgon1 = star(O, 201.9, 23, 0.8, π / 2, vertices = true)
    @timeit to "polymove" begin
        for i in 1:10
            polymove!(pgon1, O, O + (2000.1, 1999.9))
        end
    end

    pgon1 = star(O, 201.9, 23, 0.8, π / 2, vertices = true)
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
    pgon = star(O, 201.9, 23, 0.8, π / 2, vertices = true)
        for i in 1:10
            pgons = polytriangulate(pgon)
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

#=
────────────────────────────────────────────────────────────────────────────────────
                                             Time                   Allocations
                                     ──────────────────────   ───────────────────────
          Tot / % measured:               132ms / 99.4%            109MiB / 100%

 Section                     ncalls     time   %tot     avg     alloc   %tot      avg
 ────────────────────────────────────────────────────────────────────────────────────
 polytriangulate                 10   81.9ms  62.6%  8.19ms   87.3MiB  80.6%  8.73MiB
 polyintersect                   10   17.5ms  13.4%  1.75ms   1.26MiB  1.17%   129KiB
 polyintersections               10   16.6ms  12.7%  1.66ms   1.20MiB  1.11%   123KiB
 polysmooth                      10   4.95ms  3.78%   495μs   2.67MiB  2.46%   273KiB
 polyfit                         10   3.14ms  2.40%   314μs   9.50MiB  8.77%   973KiB
 polysortbydistance              10   2.53ms  1.94%   253μs   1.93MiB  1.78%   198KiB
 polysample                      10   1.00ms  0.77%   100μs   1.21MiB  1.11%   124KiB
 polyorientation                 10    681μs  0.52%  68.1μs   1.26MiB  1.17%   129KiB
 polyportion                     10    578μs  0.44%  57.8μs    302KiB  0.27%  30.2KiB
 offsetpoly                      10    491μs  0.38%  49.1μs   79.7KiB  0.07%  7.97KiB
 polyremovecollinearpoints       10    352μs  0.27%  35.2μs    546KiB  0.49%  54.6KiB
 polyremainder                   10    294μs  0.23%  29.4μs    299KiB  0.27%  29.9KiB
 polysortbyangle                 10    273μs  0.21%  27.3μs    177KiB  0.16%  17.7KiB
 polysplit                       10    265μs  0.20%  26.5μs    314KiB  0.28%  31.4KiB
 polyreflect                     10   80.5μs  0.06%  8.05μs     0.00B  0.00%    0.00B
 polydistances                   10   51.3μs  0.04%  5.13μs    128KiB  0.12%  12.8KiB
 polyperimeter                   10   50.8μs  0.04%  5.08μs    128KiB  0.12%  12.8KiB
 polyarea                        10   24.0μs  0.02%  2.40μs     0.00B  0.00%    0.00B
 polyrotate                      10   10.6μs  0.01%  1.06μs     0.00B  0.00%    0.00B
 polycentroid                    10   9.86μs  0.01%   986ns     0.00B  0.00%    0.00B
 polymove                        10   5.53μs  0.00%   553ns     0.00B  0.00%    0.00B
 polyscale                       10   4.26μs  0.00%   426ns     0.00B  0.00%    0.00B
 ────────────────────────────────────────────────────────────────────────────────────
=#
