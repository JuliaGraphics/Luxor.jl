#!/usr/bin/env julia

using Luxor

if VERSION >= v"0.5.0-dev+7720"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

function test_pie(fname)
  pagewidth, pageheight = 1200, 1400
  Drawing(pagewidth, pageheight, fname)
  origin() # move 0/0 to center
  background("ivory")
  setopacity(0.8)
  setline(0.4)

  pagetiles = Tiler(pagewidth, pageheight, 4, 5, margin=50)
  rad = 60
  for (pos, n) in pagetiles
    randomhue()
    fromA, toA = rand() * 2pi, rand() * 2pi
    fromA_str, toA_str = string(convert(Int, round(rad2deg(fromA), 0))),
                         string(convert(Int, round(rad2deg(toA), 0)))
    pie(pos, rad, fromA, toA, :fill)

    #label

    text(fromA_str, pos.x + 1.1rad  * cos(fromA), pos.y + 1.1rad  * sin(fromA))
    text(toA_str, pos.x + 1.1rad  * cos(toA), pos.y + 1.1rad  * sin(toA))
    sethue("black")
    text(string(fromA_str, "°/", toA_str, "°"), pos.x, pos.y)
  end
  @test finish() == true
end

fname = "pie-test1.pdf"
test_pie(fname)
println("...finished test: output in $(fname)")
