using Luxor, Test

function imagematrix(fname)
    Drawing(2, 2, :image)

    # get image as matrix
    mat = image_as_matrix()
    @test mat[1] == 0
    @test mat[1] == mat[2] == mat[3] == mat[4]

    # make it red, then get image as matrix again
    setcolor("red")
    paint()
    mat = image_as_matrix()
    remat = reinterpret(ARGB32, mat)

    @test Float64.(red.(remat))   == [1.0 1.0; 1.0 1.0]
    @test Float64.(green.(remat)) == [0.0 0.0; 0.0 0.0]
    @test Float64.(blue.(remat))  == [0.0 0.0; 0.0 0.0]

    # make it green, then get image as matrix again
    setcolor(0, 1, 0)
    paint()
    mat = image_as_matrix()
    remat = reinterpret(ARGB32, mat)

    @test Float64.(red.(remat)) == [0.0 0.0; 0.0 0.0]
    @test Float64.(green.(remat))   == [1.0 1.0; 1.0 1.0]
    @test Float64.(blue.(remat))  == [0.0 0.0; 0.0 0.0]

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

    @test count(i -> i == 0xffffffff, mat) == 200
    @test count(i -> i != 0xffffffff, mat) == 200
    @test finish() == true
end

fname = "image-matrix-test.png"

imagematrix(fname)

println("...finished test: output in $(fname)")
