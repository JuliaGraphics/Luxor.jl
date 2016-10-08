#!/usr/bin/env julia

using Luxor

function run_line_intersection_test(fname)
    Drawing(2000, 2000, "/tmp/line-intersection-options.pdf")
    origin()
    sethue("magenta")
    setline(.3)
    fontsize(4)
    tiles = Tiler(1000, 1000, 10, 10)
    for (pos, n) in tiles
        gsave()
        randomhue()
        setlinecap(["butt", "round", "square"][rand(1:end)])
        setlinejoin(["round", "miter", "bevel"][rand(1:end)])
        translate(pos)
        topleft = Point(-tiles.tilewidth/2, -tiles.tileheight/2)
        bottomright = Point(tiles.tilewidth/2, tiles.tileheight/2)
        a = randompoint(topleft, bottomright)
        b = randompoint(topleft, bottomright)
        c = randompoint(topleft, bottomright)
        d = randompoint(topleft, bottomright)
        line(a, b, :stroke)
        line(c, d, :stroke)
        if n % 2 == 0
            (flag, ip) = intersection(a, b, c, d, crossingonly=true)
            text("crossingonly", O)
        else
            (flag, ip) = intersection(a, b, c, d, crossingonly=false)
            text("any intersection", O)
        end
        if flag
            gsave()
            setline(.5)
            setdash("dot")
            if norm(a, ip) < norm(b, ip)
                arrow(a, ip, arrowheadlength=1)
            else
                arrow(b, ip, arrowheadlength=1)
            end
            if norm(c, ip) < norm(d, ip)
                arrow(c, ip, arrowheadlength=1)
            else
                arrow(d, ip, arrowheadlength=1)
            end
            circle(ip, 2, :fill)
            grestore()
        else
            if ip != O
                circle(ip, 2, :stroke)
            end
            dist = norm(O, ip)
            if dist > 500
                text("intersection point is $(dist) units away", O)
            end
        end
        grestore()
    end
    finish()
    println("line-intersection-options-test saved in $(fname)")
end

run_line_intersection_test("/tmp/line-intersection-options.pdf")
