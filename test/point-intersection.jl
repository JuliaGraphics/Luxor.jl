#!/usr/bin/env julia

using Luxor, Base.Test

function point_intersect(fname)
  Drawing(1000, 1000, fname)
  origin()
  setopacity(0.4)

  for i in 1:100
      randomhue()
      p1 = Point(rand(-450:450), rand(-450:450))
      p2 = Point(rand(-450:450), rand(-450:450))
      p3 = Point(rand(-450:450), rand(-450:450))
      p4 = Point(rand(-450:450), rand(-450:450))
      flag, intersection_point = intersection(p1, p2, p3, p4, crossingonly=true)
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
  @test finish() == true
  println("...finished test: output in $(fname)")
end

point_intersect("line_intersection.pdf")
