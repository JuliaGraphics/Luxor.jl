using Luxor
using Test

function checkpoints(points, hull)
    flag  = true
    for pt in points
        if ! isinside(pt, offsetpoly(hull, 0.1), allowonedge=true)
            flag = false
        end
    end
    return flag
end

function testpolyhull1(fname)
    Drawing(800, 1200, fname)
    origin()
    setopacity(0.5)
    tiles = Tiler(600, 600, 4, 4)
    for (pos, n) in tiles
        @layer begin
            translate(pos)
            if n == 1
                pts = box(O, 100, 100, vertices=true)
            elseif n == 2
                pts = ngon(O, 60, 3, vertices=true)
            elseif n == 3
                pts = randompointarray(BoundingBox(box(O, 100, 100, vertices=true)), 25)
            elseif n == 4
                pts = star(O, 60, 5, 0.2, vertices=true)
            else
                pts = ngon(O, 60, n, vertices=true)
            end
            hull = polyhull(pts)
            @test checkpoints(pts, hull)
            sethue("black")
            setline(10)
            poly(pts, :fill, close=true)
            sethue("red")
            setline(2)
            poly(hull, :stroke, close=true)
        end
    end
    @test finish() == true
    println("...finished test: output in $(fname)")
end

function testpolyhull2(fname)
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

testpolyhull1("polyhull-test-1.png")
testpolyhull2("polyhull-test-2.png")
