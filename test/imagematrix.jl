using Luxor, Test, Colors

function imagematrix()
    Drawing(2, 2, :png)

    # get image as matrix
    mat = image_as_matrix()

    @test mat[1] == [0.0, 0.0, 0.0, 0.0]
    @test mat[1] == mat[2] == mat[3] == mat[4]

    # make it red, then get image as matrix again

    setcolor("red")
    paint()
    mat = image_as_matrix()

    @test mat[1] == [1.0, 0.0, 0.0, 1.0]
    @test mat[1] == mat[2] == mat[3] == mat[4]


    # make it green, then get image as matrix again
    setcolor(0, 1, 0)
    paint()

    mat = image_as_matrix()
    @test mat[1] == [0.0, 1.0, 0.0, 1.0]
    @test mat[1] == mat[2] == mat[3] == mat[4]


    # test alpha
    setcolor(0, 0, 0, .5)
    paint()
    mat = image_as_matrix()
    @test mat[1][1] == 0.0
    @test round(mat[2][2], digits=1) ≈ 0.5
    @test mat[3][3] == 0.0
    @test mat[4][4] == 1.0

    @test finish() == true

    # make 20 by 20 (400) grid
    Drawing(5, 5, :svg)
    Luxor.origin()
    tiles = Tiler(5, 5, 5, 5, margin=0)
    background("white")
    sethue("blue")
    # fill odd ones with blue
    for (pos, n) in tiles
        isodd(n) && box(pos, 1, 1, :fill)
    end
    mat = image_as_matrix()

    # first square is blue
    @test mat[1][1] == 0.0
    @test mat[1][2] == 0.0
    @test mat[1][3] == 1.0
    @test mat[1][4] == 1.0

    # second square is white
    @test mat[2][1] == 1.0
    @test mat[2][2] == 1.0
    @test mat[2][3] == 1.0
    @test mat[2][4] == 1.0

    # third square is blue
    @test mat[3][1] == 0.0
    @test mat[3][2] == 0.0
    @test mat[3][3] == 1.0
    @test mat[3][4] == 1.0

    m = @imagematrix begin
            background(1, 0.5, 0.5, 0.5)
        end 5 5

    # test that rounding errors for alpha aren't too bad
    @test isapprox(m[1][1], 1.0, atol=0.01)
    @test isapprox(m[1][2], 0.5, atol=0.01)
    @test isapprox(m[1][3], 0.5, atol=0.01)
    @test isapprox(m[1][4], 0.5, atol=0.01)

    # test each element is the same "color"
    @test all(isequal(1), [el[1] for el in m])
    @test all(isapprox(0.5, atol=0.01), [el[2] for el in m])
    @test all(isapprox(0.5, atol=0.01), [el[3] for el in m])
    @test all(isapprox(0.5, atol=0.01), [el[4] for el in m])

end

imagematrix()

println("...finished imagematrixtest")
