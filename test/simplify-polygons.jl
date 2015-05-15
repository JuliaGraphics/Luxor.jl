#!/Applications/Julia-0.3.2.app/Contents/Resources/julia/bin/julia

# test polygon simplification

using Luxor, Color

const pagewidth = 1190 # points
const pageheight = 1684 # points

Drawing(pagewidth, pageheight, "/tmp/simplify-poly.pdf")

function draw_circles(points)
    save()
    sethue(1.0,0,0)
    for p in points
        circle(p.x, p.y, .4, :fill) # show vertex locations
    end
    restore()
end

function draw_sine_curves()
    save()
    translate(100, 100)
    setline(0.25)
    sethue(0,0,0)
    x_vals = [0:pi/180: 10 * 2 * pi]
    # generate array of Points
    plist = [Point(d * 2 * pi , -sin(d) * cos(12 * d) * 8 * sin(d/10)) for d in x_vals]
    poly(plist, :stroke) # draw original
    draw_circles(plist)
    text("original " * string(length(plist)) * " vertices" , 0, -15)
    for detail in [0.01, 0.05, 0.1, 0.2, 0.5, 0.75, 1.0, 2.0]
        translate(0, 50)
        simplified = simplify(plist, detail)
        poly(simplified, :stroke)
        draw_circles(simplified)
        text("detail  $(detail), " * string(length(simplified)) * " vertices" , 0, -15)
    end
    restore()
end

function test()
    save()
    translate(100, pageheight/2)
    setline(0.25)
    sethue(0,0,0)
    x_vals = [0:pi/100: 4 * pi]
    polyline = [Point(d * 2 * pi * 10 , 5 * -sin(d) * cos(12 * d) * 8 * sin(d/10)) for d in x_vals]
    poly(polyline, :stroke)
    draw_circles(polyline)
    text("original " * string(length(polyline)) * " vertices" , 0, -30)
    for detail in [0.01, 0.05, 0.075, 0.1, 0.2, 0.5, 0.75, 1.0, 2.0]
        translate(0, 60)
        polysimple = simplify(polyline, detail)
        poly(polysimple, :stroke)
        draw_circles(polysimple)
        text(" detail ($detail), " * string(length(polysimple)) * " vertices" , 0, -30)
    end
    restore()
end

draw_sine_curves()
test()
finish()
preview()
