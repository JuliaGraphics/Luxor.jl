using Luxor, Test

function polycliptest()
    Drawing(100, 100, :svg)
    origin()
    pgon1 = ngon(O, 100, 5, vertices = true)
    pgon2 = ngon(O, 150, 7, vertices = true)

    pc = polyclip(pgon1, pgon2)
    @test polyarea(pc) > 0
    @test !isnothing(pc)

    pgon1 = ngon(O, 50, 5, vertices = true)
    pgon2 = ngon(O + (0, 100), 50, 7, vertices = true)
    pc = polyclip(pgon1, pgon2)
    @test isnothing(pc)

    pgon1 = box(O, 50, 50, vertices = true)
    pgon2 = box(O + (50, 0), 50, 50, vertices = true)

    # boxes share edge so don't 
    @test pgon1[3].x == pgon2[1].x
    pc = polyclip(pgon1, pgon2)
    @test isnothing(pc)
    @test finish() == true
end

polycliptest()

# println("...finished polyclip test")

