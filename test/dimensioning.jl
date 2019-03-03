using Luxor, Test

Drawing(700, 350, "dimensioning-test.svg")
origin()
background("white")
pentagon = ngonside(O, 120, 5, vertices=true)
sethue("black")
setline(.2)
poly(pentagon, :stroke, close=true)

@testset "dimensioning" begin
    d, t = dimension(O, pentagon[4],
    fromextension = [0, 0])

    @test isapprox(d, 102.0780970022448)
    @test t == "102.0780970022448"

    d, t = dimension(pentagon[1], pentagon[2],
        offset        = -60,
        fromextension = [20, 50],
        toextension   = [20, 50],
        textrotation  = 2π/5,
        textgap       = 20,
        format        = (d) -> string(round(d, digits=4), "pts"))

    @test isapprox(d, 119.99999999999997)
    @test t == "120.0pts"

    d, t = dimension(pentagon[2], pentagon[3],
         offset        = -40,
         format        =  string)

    @test isapprox(d, 120.0)
    @test t =="120.0"

    d, t = dimension(pentagon[5], Point(pentagon[5].x, pentagon[4].y),
        offset        = 60,
        format        = (d) -> string("approximately ",round(d, digits=4)),
        fromextension = [5, 5],
        toextension   = [80, 5])

    @test isapprox(d, 97.08203932499367)
    @test t ==  "approximately 97.082"

    d, t = dimension(pentagon[1], midpoint(pentagon[1], pentagon[5]),
        offset               = 70,
        fromextension        = [65, -5],
        toextension          = [65, -5],
        texthorizontaloffset = -5,
        arrowheadlength      = 5,
        format               = (d) ->
            begin
                if isapprox(d, 60.0)
                    string("exactly ", round(d, digits=4), "pts")
                else
                    string("≈ ", round(d, digits=4), "pts")
                end
            end)

    @test isapprox(d, 60.00000000000001)
    @test t == "exactly 60.0pts"

    d, t = dimension(pentagon[1], pentagon[5],
        offset               = 120,
        fromextension        = [5, 5],
        toextension          = [115, 5],
        textverticaloffset   = 0.5,
        texthorizontaloffset = 0,
        textgap              = 5)

    @test isapprox(d, 120.00000000000001)
    @test t == "120.00000000000001"

    finish()
    nothing
end
