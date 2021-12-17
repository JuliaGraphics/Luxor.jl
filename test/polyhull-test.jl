using Luxor
using Test

function testpolyhull(fname)
    Drawing(800, 1200, fname)
    origin()
    setopacity(0.5)
    points = randompointarray(BoundingBox(), 30)
    while length(points) > 2
        hull = polyhull(points)
        randomhue()
        prettypoly(hull, close=true, :fill)
        # discard this hull and repeat
        points = setdiff(points, hull)
    end
    @test finish() == true
    println("...finished test: output in $(fname)")
end

testpolyhull("polyhull-test.png")
