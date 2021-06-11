using Luxor, Test

function test_polytriangulate(fname)
    width, height = 800, 800
    Drawing(width, height, fname)
    origin()
    background("white")

    rawpts = ngon(O, 300, 8, vertices = true)

    push!(rawpts, midpoint(rawpts[1], rawpts[4]))
    push!(rawpts, midpoint(rawpts[2], rawpts[5]))
    push!(rawpts, midpoint(rawpts[3], rawpts[6]))

    ptriangles = polytriangulate(rawpts)

    @test length(ptriangles) == 12

    fontsize(16)
    # visual inspection... :(
    setline(3)
    for (n, p) in enumerate(ptriangles)
        sethue([Luxor.julia_purple, Luxor.julia_blue,  Luxor.julia_red,  Luxor.julia_green][mod1(n, end)])
        pgon = Point[p[1], p[2], p[3]]
        poly(pgon,  :fillpreserve, close = true)
        sethue("white")
        strokepath()
        text(string(n), polycentroid(pgon), halign=:middle)
    end
    sethue("white")
    circle.(rawpts, 5, :fill)
    @test finish() == true
end

fname = "polytriangulate.png"
test_polytriangulate(fname)
println("...finished test: output in $(fname)")
