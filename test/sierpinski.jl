#!/Applications/Julia-0.3.10.app/Contents/Resources/julia/bin/julia

using Luxor, Color

function draw_triangle(points::Array{Point{Float64}}, degree::Int64)
    global triangle_count, cols
    setcolor(cols[degree+1])
    poly(points, :fill)
    triangle_count += 1
end

get_midpoint(p1::Point, p2::Point) = Point((p1.x + p2.x) / 2, (p1.y + p2.y) / 2)

function sierpinski(points::Array{Point{Float64}}, degree::Int64)
    draw_triangle(points, degree)
    if degree > 0
        p1,p2,p3 = points
        sierpinski([p1, get_midpoint(p1, p2),
                        get_midpoint(p1, p3)], degree-1)
        sierpinski([p2, get_midpoint(p1, p2),
                        get_midpoint(p2, p3)], degree-1)
        sierpinski([p3, get_midpoint(p3, p2),
                        get_midpoint(p1, p3)], degree-1)
    end
end

@time begin
    depth = 8 # 12 is ok, 20 is right out
    cols = distinguishable_colors(depth+1)
    Drawing(400, 400, "/tmp/sierpinski.pdf") # or PNG filename for PNG
    origin()
    setopacity(0.5)
    triangle_count = 0
    my_points = [Point{Float64}(-100,-50), Point{Float64}(0,100), Point{Float64}(100.0,-50.0)]
    sierpinski(my_points, depth)
    println("drew $triangle_count triangles")
end

finish()
preview()
exit()
# drew 9841 triangles
# elapsed time: 1.738649452 seconds (118966484 bytes allocated, 2.20% gc time)
