using Luxor
using Test
using Random
Random.seed!(3)

function test_lux_bb(; center = O)
    bx = BoundingBox(box(O + center, 200, 200, :none))
    box(bx, :stroke)
    for i in 0:14
        pt = if i < 4
            sethue("yellow")
            ang = i * π / 2
            O + center + 40 .* (cos(ang), sin(ang)) # adjust center!
        else
            sethue("grey50")
            randompoint((1.5bx)...)
        end
        arrow(O + center, pt) # adjust center!
        pt2 = pointcrossesboundingbox(pt, bx)
        circle(pt2, 3, :stroke)
    end
    snapshot()
end

function point_bb_test1(fname)
    Drawing(800, 400, :rec)
    background("brown")
    origin(200, 200)
    test_lux_bb()
    translate(400, 0)
    test_lux_bb(; center = (-45, -25))
    snapshot(; fname = fname)
    println("...finished point crosses bounding box test 1, saved in $(fname)")
end

function point_bb_test2(fname)
    Drawing(1200, 1200, fname)
    background("black")
    origin()
    boxcenter = rand(BoundingBox() * 0.8)
    bx = box(boxcenter, rand(150:500), rand(150:500))
    bbx = BoundingBox(bx)
    setline(0.5)
    sethue("gold")
    circle(boxcenter, 10, :stroke)
    box(bbx, :stroke)
    pts = randompointarray(BoundingBox(), 100)
    for pt in pts
        sethue("red")
        circle(pt, 2, :fill)
        p1 = pointcrossesboundingbox(pt, bbx)
        line(boxcenter, p1, :stroke)
        sethue("green")
        line(p1, pt, :stroke)
        sethue("cyan")
        circle(p1, 1, :fill)
    end
    finish()
    println("...finished point crosses bounding box test 2, saved in $(fname)")
end

fname = "point-crosses-bounding-box-test-1.png"
point_bb_test1(fname)

fname = "point-crosses-bounding-box-test-2.png"
point_bb_test2(fname)
