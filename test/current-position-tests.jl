using Luxor, Test

@draw begin
    # initially O
    @test currentpoint() == Point(0.0, 0.0)
    @test hascurrentpoint() == false
    move(Point(30, 30))
    @test currentpoint() == Point(30.0, 30.0)
    @test hascurrentpoint() == true
    line(Point(50, -50))
    @test currentpoint() == Point(50.0, -50.0)
    closepath()
    @test hascurrentpoint() == true
    newpath()
    @test hascurrentpoint() == false
    @test currentpoint() == Point(0.0, 0.0)
end
println("...finished currentpoint tests")
