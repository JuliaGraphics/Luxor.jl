using Luxor, Random, Colors

Random.seed!(42)

using Test

function test_arc_sagitta(fname)
    Drawing("A4", fname)
    origin()
    background(Colors.RGB(1, 1, 1))
    setopacity(0.6)

    translate(0, -150)
    p1 = O - (150, 0)
    p2 = O + (150, 0)
    @test_throws ErrorException arc2sagitta(p1, p2, 0)
    @test_throws ErrorException carc2sagitta(p1, p2, 0)

    sethue("red")
    for s in 1:4:150
        @test isarcclockwise(O, p1, p2) == false
        cp, r = arc2sagitta(p1, p2, s, :stroke)
        @test r >= 150
    end
    sethue("green")
    for s in 1:4:150
        cp, r = carc2sagitta(p1, p2, s, :stroke)
        @test r >= 150
    end

    translate(0, 300)

    p1 = O - (0, 150)
    p2 = O + (0, 150)
    @test_throws ErrorException arc2sagitta(p1, p2, 0)
    @test_throws ErrorException carc2sagitta(p1, p2, 0)

    sethue("red")
    for s in 1:4:150
        # the arc is neither clockwise or counterclockwise
        # because points are collinear!
        @test isarcclockwise(O, p2, p1) == false
        @test isarcclockwise(O, p1, p2) == false
        cp, r = arc2sagitta(p1, p2, s, :stroke)
        @test r >= 150
    end
    sethue("green")
    for s in 1:4:150
        cp, r = carc2sagitta(p1, p2, s, :stroke)
        @test r >= 150
    end

    @test finish() == true
end

fname = "arc-sagitta.png"
test_arc_sagitta(fname)
println("...finished arc_sagitta test: output in $(fname)")
