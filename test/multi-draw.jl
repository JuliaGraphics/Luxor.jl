using Luxor, Test

function multi_draw()
    @test Luxor.get_drawings() == 1:1
    @test Luxor.get_current_drawing() == 1
    @test Luxor.set_current_drawing(5) == 1
    @test Luxor.get_next_drawing() == 1
    @test Luxor.set_next_drawing() == 1

    Drawing(2, 2, :png)

    @test Luxor.get_drawings() == 1:1
    @test Luxor.get_current_drawing() == 1
    @test Luxor.set_current_drawing(5) == 1
    @test Luxor.get_next_drawing() == 2
    @test Luxor.set_next_drawing() == 2

    @test ! currentdrawing()
    
    Drawing(2, 2, :png)

    @test Luxor.get_drawings() == 1:2
    @test Luxor.get_current_drawing() == 2
    @test Luxor.set_current_drawing(5) == 2

    @test Luxor.set_current_drawing(1) == 1
    @test finish()
    @test Luxor.get_next_drawing() == 1
    @test Luxor.set_next_drawing() == 1

end

multi_draw()

println("...finished multi-draw test")

