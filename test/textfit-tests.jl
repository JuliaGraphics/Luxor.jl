using Luxor
using Test

function textfit_test(fname)
    Drawing(1200, 1200, fname)
    origin()
    background("antiquewhite")
    t = Tiler(1200, 1200, 4, 4)
    for (pos, n) in t
        @layer begin
            translate(pos)
            r = rescale(n, 1, length(t), 0.2, 1)
            bx = BoundingBox(O - Point(t.tilewidth, t.tileheight)/2, O + Point(t.tilewidth, t.tileheight)/2) * r
            sethue("purple")
            box(bx, :fill)
            sethue("white")
            textfit("this text is supposed to fit inside the box.", bx, 100, horizontalmargin=1)
        end
    end

    @test finish() == true
    println("...finished test: output in $(fname)")
end

textfit_test("textfit-test.png")
