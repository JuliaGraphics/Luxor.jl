import SnoopPrecompile

@info "SnoopPrecompile is analyzing Luxor.jl code..."

SnoopPrecompile.@precompile_all_calls begin
    ngon(O, 100, 3, vertices=true)
    @draw circle(1.0, 1.2, 1.9, action=:fill)
    noise(1)
    noise(1, 2)
    noise(1, 2, 3)
    noise(1, 2, 3, 4)
    @draw text("snooping away", O)
    pgon = star(O, 201.9, 23, 0.8, π / 2, vertices = true)
    ps = polyportion(pgon, 3/10)
    pa = polydistances(pgon)
    sethue("red")
    polysortbyangle(pgon)
    polysortbydistance(pgon, pgon[1])
    polysmooth(pgon, 5, :none)
    polyremovecollinearpoints(pgon)
    polytriangulate(pgon)
    randomhue()
end
