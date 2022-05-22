#!/usr/bin/env julia

using Luxor

using Test

using Random
Random.seed!(42)

function drawtriangle(points, degree)
    sethue(cols[degree])
    poly(points, :fill)
end

function sierpinskitriangle(points, degree)
    drawtriangle(points, degree)
    if degree > 1
        p1, p2, p3 = points
        sierpinskitriangle([p1, midpoint(p1, p2),
                                midpoint(p1, p3)], degree-1)
        sierpinskitriangle([p2, midpoint(p1, p2),
                                midpoint(p2, p3)], degree-1)
        sierpinskitriangle([p3, midpoint(p3, p2),
                                midpoint(p1, p3)], degree-1)
    end
end

function drawsierpinski(fname, n)
  Drawing(200, 200, fname)
  origin()
  background("ivory")
  circle(O, 75, :clip)
  my_points = ngon(O, 150, 3, -pi/2, vertices=true)
  depth = 8 # 12 is ok, 20 is right out
  sierpinskitriangle(my_points, n)
  @test finish() == true
end

cols = distinguishable_colors(8)
fname = "sierpinskitriangle.svg"
drawsierpinski(fname, 8)
println("...finished test: output in $(fname)")
