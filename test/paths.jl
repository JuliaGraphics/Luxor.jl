using Luxor
using Test
using Random

Random.seed!(42)

e1 = PathLine(Point(100, 45))
e2 = PathMove(Point(0, 5))
e3 = PathClose()
e4 = PathCurve(Point(0, 45), Point(50, 10), Point(100, -15))

function path_test(fname)
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

path_test("path-test.png")
