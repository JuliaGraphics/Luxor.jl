using Luxor
using Test
using Random

Random.seed!(42)

e1 = PathLine(Point(100, 45))
e2 = PathMove(Point(0, 5))
e3 = PathClose()
e4 = PathCurve(Point(0, 45), Point(50, 10), Point(100, -15))

function path_test_1(fname)
    Drawing(500, 500, fname)
    background("grey30")
    origin()
    fontsize(40)
    sethue("gold")

    p = Path([e1, e2, e3, e4])
    drawpath(p, action=:stroke)

    pts = star(O, 200, 6, 0.5, vertices=true)
    p = Path(pts)
    drawpath(p, action=:stroke)

    textpath("hello", O, :stroke)
    p = storepath()
    drawpath(p, action=:stroke)

    textpath("hello", O + (0, 100), action=:stroke)
    p = storepath()
    drawpath(p, :stroke)

    textpath("hello", O + (0, 150), action=:fill)
    p = storepath()
    drawpath(p, action=:fill)

    sethue("cyan")
    scale(0.9)
    drawpath(polytopath(pts), action=:stroke)

    sethue("magenta")
    scale(0.8)
    drawpath(polytopath(pts), :stroke)

    bp = BezierPath([BezierPathSegment(
        rand(BoundingBox() ),
        rand(BoundingBox() ),
        rand(BoundingBox() ),
        rand(BoundingBox() ),
    ) for i in 1:10])

    sethue("white")
    setlinejoin("round")
    setline(15)
    drawbezierpath(bp, :stroke)

    setline(5)
    sethue("black")
    drawpath(bezierpathtopath(bp), :stroke)

    @test finish() == true
    println("...finished test: output in $(fname)")
end

function path_test(path)
    # path info
    @test size(path) == 10
    @test length(path) == 10
    @test typeof(path[1]) == PathMove
    @test typeof(path[end]) == PathCurve
    @test findfirst(pe -> pe isa PathClose, path) == 6
    @test findfirst(pe -> pe isa PathCurve, path) == 8
    @test findfirst(pe -> pe isa PathMove, path) == 1
    @test findfirst(pe -> pe isa PathLine, path) == 3

    # BoundingBox of path
    bbox = BoundingBox(path)
    @test boxwidth(bbox) == 300.0
    @test boxheight(bbox) == 300

    # length of path
    @test isapprox(pathlength(path), 2141, atol = 1)
    @test isapprox(pathlength(path, steps = 50), 2142.57, atol = 0.1)
    @test isapprox(pathlength(path, steps = 500), 2142.611, atol = 0.1)

    # resample path
    @test 219 < length(pathsample(path, 10)) < 221
    @test 27 < length(pathsample(path, 100)) < 29
end

function path_test_2(fname)
    Drawing(800, 800, fname)
    background("black")
    origin()

    newpath()
    box(O, 300, 300, :path)
    move(polar(150, 0))
    circle(O, 150, :path)

    path = storepath()
    #=
    Path([
     PathMove(Point(-150.0, 150.0)),
     PathLine(Point(-150.0, -150.0)),
     PathLine(Point(150.0, -150.0)),
     PathLine(Point(150.0, 150.0)),
     PathClose(),
     PathMove(Point(-150.0, 150.0)),
     PathLine(Point(150.0, 0.0)),
     PathCurve(Point(150.0, 82.84375), Point(82.84375, 150.0), Point(0.0, 150.0)),
     PathCurve(Point(-82.84375, 150.0), Point(-150.0, 82.84375), Point(-150.0, 0.0)),
     PathCurve(Point(-150.0, -82.84375), Point(-82.84375, -150.0), Point(0.0, -150.0)),
     PathCurve(Point(82.84375, -150.0), Point(150.0, -82.84375), Point(150.0, 0.0))
    ])
    =#

    path_test(path)

    sethue("gold")
    setline(2)
    drawpath(path, :stroke)

    setline(1)
    @layer begin
        for k in 0.0:0.05:1.0
            sethue("cyan")
            pt = drawpath(path, k, :stroke)
            scale(1.045)
            sethue("magenta")
            circle(pt, 5, :fill)
        end
    end

    @test finish() == true

end

path_test_1("path-test-1.png")
path_test_2("path-test-3.png")
