#!/usr/bin/env julia

using Luxor, Colors

function draw_triangle(points::Array{Point}, degree::Int64)
    global triangle_count, cols
    setcolor(cols[degree+1])
    poly(points, :fill)
    triangle_count += 1
end

function sierpinski(points::Array{Point}, degree::Int64)
    draw_triangle(points, degree)
    if degree > 0
        p1,p2,p3 = points
        sierpinski([p1, midpoint(p1, p2),
                        midpoint(p1, p3)], degree-1)
        sierpinski([p2, midpoint(p1, p2),
                        midpoint(p2, p3)], degree-1)
        sierpinski([p3, midpoint(p3, p2),
                        midpoint(p1, p3)], degree-1)
    end
end

@time begin
    depth = 8 # 12 is ok, 20 is right out
    cols = distinguishable_colors(depth+1)
    Drawing(400, 400, "/tmp/sierpinski.svg")
    origin()
    setopacity(0.5)
    triangle_count = 0
    my_points = [Point(-100,-50), Point(0,100), Point(100.0,-50.0)]
    sierpinski(my_points, depth)
    println("drew $triangle_count triangles")
end

finish()
preview()

