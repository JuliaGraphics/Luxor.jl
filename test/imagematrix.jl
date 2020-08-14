using Luxor, Test, Colors

function imagematrix()
    Drawing(2, 2, :image)

    # get image as matrix
    mat = image_as_matrix()
    @test mat[1] == Colors.ARGB32(1.0, 1.0, 1.0, 0.0)
    @test mat[1] == mat[2] == mat[3] == mat[4]

    # make it red, then get image as matrix again
    setcolor("red")
    paint()
    mat = image_as_matrix()

    # make it green, then get image as matrix again
    setcolor(0, 1, 0)
    paint()
    mat = image_as_matrix()
    @test mat[1] == Colors.ARGB32(0.0, 1.0, 0.0, 1.0)
    @test mat[1] == mat[2] == mat[3] == mat[4]

    @test finish() == true

    # make 20 by 20 (400) grid
    Drawing(20, 20, :image)
    Luxor.origin()
    tiles = Tiler(20, 20, 20, 20, margin=0)
    background("white")
    sethue("blue")
    # fill odd ones with blue
    for (pos, n) in tiles
        isodd(n) && box(pos, 1, 1, :fill)
    end
    mat = image_as_matrix()

    # half the 400 are white
    @test count(i -> i == ARGB32(1, 1, 1, 1), mat) == 200

    # half are blue - 0r, 0g, 1b, 1a
    @test count(i -> i == ARGB32(0, 0, 1, 1), mat) == 200
    @test finish() == true
end

imagematrix()

println("...finished imagematrixtest")
