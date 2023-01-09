using Luxor, Test, Colors

function strokescale()
    Drawing(10, 10, :png, strokescale = true)
    @test getline() == 2 # default linewidth is 2.0    

    # was the scale set correctly when the Drawing was created?
    @test setstrokescale() == true

    background("white")
    setcolor(0, 0, 0)

    # scale the canvas to use coordinates [0, 1]
    scale(10)

    # set our stroke width to the width of the canvas
    setline(1)

    @test getline() == 1

    # a line the width of the canvas drawn at 0 should cover 50% of the canvas
    line(Point(0, 0), Point(0, 1), :stroke)

    mat = image_as_matrix()
    @test RGBA{Float32}(0, 0, 0, 1) == convert(RGBA{Float32}, mat[5, 3])

    background("white")

    setstrokescale(false)
    @test setstrokescale() == false

    # set our stroke width to size 1, independent of scaling
    setline(1)
    @test getline() == 1

    # An unscaled line of size 1 will not cover 50% of the canvas
    line(Point(0, 0), Point(0, 1), :stroke)
    mat = image_as_matrix()

    # assert that the same pixel is now white
    @test RGBA{Float32}(1, 1, 1, 1) == convert(RGBA{Float32}, mat[5, 3])
    @test finish() == true
end

strokescale()

println("...finished strokescaletest")