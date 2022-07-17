using Luxor, Test, Colors

#function convertmatrixtocolors(m)
#    return @. convert(Colors.RGBA{Float64}, m)
#end

function imagematrix2()

    img = zeros(ARGB32, 10, 2)
    Drawing(img)
    origin()
    finish()
    @test img == permutedims(image_as_matrix())

    img = zeros(ARGB32, 2, 2)
    Drawing(img)

    # get image as matrix
    mat = convertmatrixtocolors(image_as_matrix())
    @test mat[1] == RGBA{Float64}(0.0, 0.0, 0.0, 0.0)
    @test mat[1] == mat[2] == mat[3] == mat[4]
    @test img[1] == RGBA{Float64}(0.0, 0.0, 0.0, 0.0)
    @test img[1] == img[2] == img[3] == img[4]

    # make it red, then get image as matrix again
    setcolor("red")
    paint()
    mat = image_as_matrix()

    @test mat[1] == RGBA{Float64}(1.0, 0.0, 0.0, 1.0)
    @test mat[1] == mat[2] == mat[3] == mat[4]
    @test img[1] == RGBA{Float64}(1.0, 0.0, 0.0, 1.0)
    @test img[1] == img[2] == img[3] == img[4]

    # make it green, then get image as matrix again
    setcolor(0, 1, 0)
    paint()

    mat = image_as_matrix()
    @test mat[1] == RGBA{Float64}(0.0, 1.0, 0.0, 1.0)
    @test mat[1] == mat[2] == mat[3] == mat[4]
    @test img[1] == RGBA{Float64}(0.0, 1.0, 0.0, 1.0)
    @test img[1] == img[2] == img[3] == img[4]

    finish()

    # test alpha
    img = zeros(ARGB32, 2, 2)
    Drawing(img)

    setcolor(0, 0, 0, .5)
    paint()
    mat = image_as_matrix()

    @test red(img[1]) == 0.0
    @test red(mat[1]) == 0.0
    @test isapprox(alpha(img[1]), 0.5, atol=0.1)
    @test isapprox(alpha(mat[1]), 0.5, atol=0.1)

    @test finish() == true

    # make 20 by 20 (400) grid
    img = zeros(ARGB32, 5, 5)
    Drawing(img)

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
    @test blue(img[1]) == 1.0
    @test blue(mat[1]) == 1.0

    # second square is white
    @test red(img[2]) == blue(img[2]) == green(img[2])
    @test red(mat[2]) == blue(mat[2]) == green(mat[2])

    # third square is blue
    @test blue(img[2]) == 1.0
    @test blue(mat[2]) == 1.0

    @test finish() == true

    # test placeimage
    K = 100
    m1 = @imagematrix begin
        juliacircles(20)
    end K 100

    img = zeros(ARGB32, 100, 100)
    Drawing(img)
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

    img = zeros(ARGB32, 100, 100)
    Drawing(img)
    Luxor.origin()
    placeimage(m1, centered=true)
    @test finish() == true
    
    K = 100
    m2 = @imagematrix begin
        juliacircles(20)
    end K 100

    img = zeros(ARGB32, 100, 100)
    Drawing(img)
    Luxor.origin()
    placeimage(m2, alpha=1, centered=true)
    @test finish() == true
end

imagematrix2()

println("...finished imagematrix2 test")
