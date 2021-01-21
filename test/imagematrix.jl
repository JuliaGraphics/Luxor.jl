using Luxor, Test, Colors

function convertmatrixtocolors(m)
    return @. convert(Colors.RGBA{Float64}, m)
end

function imagematrix()

    Drawing(10, 2, :png)
    origin()
    img = image_as_matrix()
    finish()

    @test size(img) == (2, 10)

    Drawing(2, 2, :png)

    # get image as matrix

    mat = convertmatrixtocolors(image_as_matrix())

    @test mat[1] == RGBA{Float64}(0.0, 0.0, 0.0, 0.0)

    @test mat[1] == mat[2] == mat[3] == mat[4]

    # make it red, then get image as matrix again

    setcolor("red")
    paint()
    mat = image_as_matrix()

    @test mat[1] == RGBA{Float64}(1.0, 0.0, 0.0, 1.0)
    @test mat[1] == mat[2] == mat[3] == mat[4]


    # make it green, then get image as matrix again
    setcolor(0, 1, 0)
    paint()

    mat = image_as_matrix()
    @test mat[1] == RGBA{Float64}(0.0, 1.0, 0.0, 1.0)
    @test mat[1] == mat[2] == mat[3] == mat[4]

    finish()

    # test alpha
    Drawing(2, 2, :png)

    setcolor(0, 0, 0, .5)
    paint()
    mat = image_as_matrix()

    @test red(mat[1]) == 0.0
    @test isapprox(alpha(mat[1]), 0.5, atol=0.1)

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
    mat = convertmatrixtocolors(image_as_matrix())

    # first square is blue
    @test blue(mat[1]) == 1.0

    # second square is white
    @test red(mat[2]) == blue(mat[2]) == green(mat[2])

    # third square is blue
    @test blue(mat[2]) == 1.0

    @test finish() == true


    # test placeimage
    m1 = @imagematrix begin
        juliacircles(20)
    end 100 100

    Drawing(100, 100, :png)
    Luxor.origin()
    rotate(π/2)
    placeimage(m1, centered=true)
    placeimage(Gray.(m1))
    @test finish() == true

    m1 = Drawing(40,40, :svg)
    origin()
    sethue("black")
    background(0,1,1,0)
    juliacircles(10) 
    finish()

    Drawing(100, 100, :svg)
    Luxor.origin()
    placeimage(m1, centered=true)
    @test finish() == true

end

imagematrix()

println("...finished imagematrixtest")
