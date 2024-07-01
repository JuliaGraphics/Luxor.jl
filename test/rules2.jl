using Luxor
using Test

function test_rule2(fname)
    Drawing(500, 500, fname)
    background("white")
    origin()
    setline(0.7)

    L = 110

    toppts = between.(Point(-250, -250), Point(250, -250), range(0, 1, length = L))
    bottompts = between.(Point(-250, 250), Point(250, 250), range(0, 1, length = L))
    
    circle.(toppts, 3, :fill)
    circle.(bottompts, 3, :fill)
    
    bbox = BoundingBox(box(O, 495, 495))
    rule.(toppts, bottompts, boundingbox = bbox)
    rule.(toppts, reverse(bottompts), boundingbox = bbox)

    leftpts = between.(Point(-250, -250), Point(-250, 250), range(0, 1, length = L))
    rightpts = between.(Point(250, -250), Point(250, 250), range(0, 1, length = L))

    rule.(leftpts, rightpts)
    rule.(leftpts, reverse(rightpts))

    @test finish() == true
    println("...finished test: output in $(fname)")
end

test_rule2("rule2.png")
println("...finished rule2 test")