using Luxor, Random, Test

function test_tangents(fname)
    Drawing(500, 500, fname)
    background("white")
    origin()
    setline(0.5)
    sethue("black")
    for i in 1:30
        circlecenter = polar(rand(100:190), 2π * i/30)
        circleradius = rand(4:10)
        point = polar(rand(170:240), 2π * i/20)
        circle(circlecenter, 2, :fill)
        circle(point, 2, :fill)
        circle(circlecenter, circleradius, :fill)
        pt1, pt2 = pointcircletangent(point, circlecenter, circleradius)
        if pt1 != pt2
            line(point, pt1, :stroke)
            line(point, pt2, :stroke)
        end
    end
    @test finish() == true
end

fname = "point-circle-tangent.png"
test_tangents(fname)
println("...finished test: output in $(fname)")
