#!/usr/bin/env julia

using Luxor, Random

using Test

function testbezierstroke(fname)
    Random.seed!(3)
    currentwidth = 1200
    currentheight = 1200
    Drawing(currentwidth, currentheight, fname)
    origin()
    background("pink")
    setopacity(0.5)
    path1 = [Point(-50, 50), Point(60, -60)]
    path4 = ngon(O, 40, 2, vertices=true)
    path2 = ngon(O, 40, 3, vertices=true)
    path3 = ngon(O, 40, 4, vertices=true)
    path5 = ngon(O, 40, 5, vertices=true)
    path6 = ngon(O, 40, 6, vertices=true)

    paths = [path1, path2, path3, path4, path5, path6]
    paths = vcat(paths, paths, paths)

    t = Table(3, 6, 120, 150, Point(0, 300))
    for (i, path) in enumerate(paths)
        @layer begin
        translate(t[i])
        poly(path, :path)
        bpatharray = pathtobezierpaths()
        for (n, bpath) in enumerate(bpatharray)
            randomhue()
            drawbezierpath(bpath, :stroke)
            for bps in bpath
                randomhue()
                drawbezierpath(setbezierhandles(bps, angles=[2rand(), 2rand()], handles=[3rand(), 2rand()]), :fill)
            end
            # close needs doing manually
            if length(bpath) >= 1
                closingsegment = BezierPathSegment(bpath[end].cp2, bpath[end].p2, bpath[1].p1, bpath[1].cp1)
                seg = setbezierhandles(closingsegment, angles=[2rand(), -2rand()], handles=[3rand(), 2rand()])
                drawbezierpath(seg, :fill)
            end
        end
        end
    end

    # Julia!
    fontsize(500)
    fontface("Times-Bold")
    translate(-450, 100)

    textpath("julia")
    bp = pathtobezierpaths()
    newpath() # clear current path
    for i in 1:5
    for b in bp
        for bps in b
            randomhue()
            drawbezierpath(setbezierhandles(bps,
                angles=[3rand(), 3rand()], handles=[4rand(), 4rand()]),
                :fill)
        end
        # close needs doing manually
        if length(b) >= 1
            closingsegment = BezierPathSegment(b[end].cp2, b[end].p2, b[1].p1, b[1].cp1)
            seg = setbezierhandles(closingsegment, angles=[4rand(), -4rand()], handles=[4rand(), 4rand()])
            drawbezierpath(seg, :fill)
        end
    end

    setmode("overlay")
    textpath("julia")
    sethue("blue")
    fillpath()

end
    @test finish() == true
end

fname = "bezierstroke.png"
testbezierstroke(fname)
println("...finished bezier stroke tests: output in $(fname)")
