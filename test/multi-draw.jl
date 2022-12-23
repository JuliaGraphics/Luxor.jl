using Luxor, Test

function multi_draw()
    @test Luxor._reset_all_drawings() == true
    
    @test Luxor.drawing_indices() == 1:1
    @test Luxor.get_drawing_index() == 1
    @test Luxor.set_drawing_index(5) == 1
    @test Luxor.get_next_drawing_index() == 1
    @test Luxor.set_next_drawing_index() == 1

    Drawing(2, 2, :png)

    @test Luxor.has_drawing() == true

    @test Luxor.drawing_indices() == 1:1
    @test Luxor.get_drawing_index() == 1
    @test Luxor.set_drawing_index(5) == 1
    @test Luxor.get_next_drawing_index() == 2
    @test Luxor.set_next_drawing_index() == 2

    @test currentdrawing() == false
    
    d2 = Drawing(2, 2, :png)
    background(1.0,0,0,1.0)
    mat2=image_as_matrix()

    @test Luxor.drawing_indices() == 1:2
    @test Luxor.get_drawing_index() == 2
    @test Luxor.set_drawing_index(5) == 2

    @test Luxor.set_drawing_index(1) == 1
    @test finish()
    @test Luxor.get_next_drawing_index() == 1
    @test Luxor.set_next_drawing_index() == 1

    d3 = Drawing(2, 2, :png)
    @test currentdrawing(d2) == d2

    mat3=image_as_matrix()
    @test mat3[1] == mat2[1]
    @test mat3[2] == mat2[2]
    @test mat3[3] == mat2[3]
    @test mat3[4] == mat2[4]

    background(0.0,1,0,1.0)
    mat3=image_as_matrix()
    @test Luxor.set_drawing_index(2) == 2
    mat2=image_as_matrix()
    @test mat3[1] == mat2[1]
    @test mat3[2] == mat2[2]
    @test mat3[3] == mat2[3]
    @test mat3[4] == mat2[4]
    
    finish()

    @test Luxor.set_drawing_index(1) == 1
    finish()
end

multi_draw()

println("...finished multi-draw test")

