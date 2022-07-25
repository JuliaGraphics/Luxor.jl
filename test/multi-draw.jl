using Luxor, Test

function multi_draw()
    @test Luxor.drawing_indices() == 1:1
    @test Luxor.get_drawing_index() == 1
    @test Luxor.set_drawing_index(5) == 1
    @test Luxor.get_next_drawing_index() == 1
    @test Luxor.set_next_drawing_index() == 1

    Drawing(2, 2, :png)

    @test Luxor.drawing_indices() == 1:1
    @test Luxor.get_drawing_index() == 1
    @test Luxor.set_drawing_index(5) == 1
    @test Luxor.get_next_drawing_index() == 2
    @test Luxor.set_next_drawing_index() == 2

    @test ! currentdrawing()
    
    Drawing(2, 2, :png)

    @test Luxor.drawing_indices() == 1:2
    @test Luxor.get_drawing_index() == 2
    @test Luxor.set_drawing_index(5) == 2

    @test Luxor.set_drawing_index(1) == 1
    @test finish()
    @test Luxor.get_next_drawing_index() == 1
    @test Luxor.set_next_drawing_index() == 1

end

multi_draw()

println("...finished multi-draw test")

