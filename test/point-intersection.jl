#!/usr/bin/env julia

using Luxor

Drawing(1000, 1000, "/tmp/line_intersection.pdf")
origin()
setopacity(0.4)

for i in 1:100
    randomhue()
    p1 = Point(rand(-300:300), rand(-300:300))
    p2 = Point(rand(-300:300), rand(-300:300))
    p3 = Point(rand(-300:300), rand(-300:300))
    p4 = Point(rand(-300:300), rand(-300:300))
    flag, intersection_point = intersection(p1, p2, p3, p4)
    if flag
        circle(intersection_point, 5, :fill)
        move(p1)
        line(p2)
        stroke()
        move(p3)
        line(p4)
        stroke()
    end
end

finish()
preview()
