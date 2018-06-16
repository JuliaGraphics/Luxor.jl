#!/usr/bin/env julia

using Luxor

using Test

function get_text_path()
    translate(-400, -400)
    fontsize(60)
    textpath("get polygons from paths")
    plist = pathtopoly()
    setline(0.5)
    for (n, pgon) in enumerate(plist)
        randomhue()
        prettypoly(pgon, :stroke, close=true)
    end
end

function get_circle_path()
    translate(200, 200)
    circlepath(O, 50, :path)
    plist = pathtopoly()
    setline(0.5)
    for (n, pgon) in enumerate(plist)
        sethue(rand(), 0.5, 0.6)
        poly(offsetpoly(pgon, 5), close=true, :stroke)
        prettypoly(pgon, :stroke, close=true)
    end
end

function get_line_path()
    origin()
    translate(0, 200)
    move(Point(rand(-50:50), rand(-50:50)))
    line(Point(rand(-50:50), rand(-50:50)))
    line(Point(rand(-50:50), rand(-50:50)))
    line(Point(rand(-50:50), rand(-50:50)))
    line(Point(rand(-50:50), rand(-50:50)))
    closepath()
    plist = pathtopoly()
    setline(0.5)
    for (n, pgon) in enumerate(plist)
        for i in 0:10:50
            sethue(rand(), 0.5, 0.6)
            poly(offsetpoly(pgon, i), :stroke, close=true)
        end
    end
end

function outline_string(s)
    origin()
    setlinejoin("butt")
    fontface("Times")
    fontsize(400)
    textpath(s)
    plist = pathtopoly()
    for (n, pgon) in enumerate(plist)
        for i in -10:4:10
            sethue(rand(), 0.5, 0.6)
            setopacity(rescale(i, -10, 10, 3, 0.2))
            poly(offsetpoly(pgon, i), :stroke, close=true)
        end
    end
end

function main_path_to_poly(fname)
    Drawing(1200, 1200, fname)
    origin()
    background("white")
    get_text_path()
    get_circle_path()
    get_line_path()
    outline_string("πü")
    @test finish() == true
    println("...finished test: output in $(fname)")
end

main_path_to_poly("pathtopoly.pdf")
