#!/usr/bin/env julia

using Luxor

if VERSION >= v"0.5.0-dev+7720"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

function testbezierstroke(fname)
    srand(3)
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
                drawbezierpath(bezierstroke(bps, rand(1:15)), :fill)
            end
            # close needs doing manually
            if length(bpath) >= 2
                closingsegment = (bpath[end][3], bpath[end][4], bpath[1][1], bpath[1][2])
                drawbezierpath(bezierstroke(closingsegment, rand(1:15)), :fill)
            end
        end
        end
    end
    fontsize(500)
    fontface("Times-Bold")
    translate(-450, 0)
    textpath("julia")
    bp = pathtobezierpaths()
    newpath() # clear current path
    for b in bp
        for bps in b
            randomhue()
            drawbezierpath(bezierstroke(bps), :fill)
            sethue("black")
            drawbezierpath(bezierstroke(bps), :stroke)
        end
        # close needs doing manually
        if length(b) >= 2
            closingsegment = (b[end][4], b[end][4], b[1][1], b[1][1])
            drawbezierpath(bezierstroke(closingsegment, rand(5:25)), :fill)
            sethue("black")
            drawbezierpath(bezierstroke(closingsegment, rand(5:25)), :stroke)
        end
    end
    @test finish() == true
end

fname = "bezierstroke.png"
testbezierstroke(fname)
println("...finished bezier stroke tests: output in $(fname)")
