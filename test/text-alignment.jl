#!/usr/bin/env julia

using Luxor

if VERSION >= v"0.5.0-dev+7720"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

function dot(pos)
    gsave()
    sethue("red")
    circle(pos, 5, :fill)
    grestore()
end

function showt(c, p, ha, va, n)
  text(c, p, halign=ha, valign=va)
  gsave()
  setopacity(0.1)
  text(string(n), p)
  grestore()
end

function text_alignment_tests(fname)
    legend = String[]
    Drawing(1400,1400, fname)
    origin()
    setopacity(0.8)
    sethue("black")
    fontsize(65)
    tiles = Tiler(1000, 1000, 4, 3, margin=50)
    # Test for :centre (synonym for :center) works, and unknown is treated as :left
    haligns = (:left, :center, :right, :centre, :foo)
    # Test for unknown is treated as :baseline
    valigns = (:baseline, :top, :middle, :bottom, :bar)
    current_h = 1
    current_v = 1
    for (pos, n) in tiles
        gsave()
        h = haligns[current_h]
        v = valigns[current_v]
        dot(Point(pos))
        showt("Å˰̀Ά", pos, h, v, n)
        grestore()
        push!(legend, "$n h: $h v: $v")
        current_h += 1
        if current_h > 5
            current_v += 1
            current_h = 1
        end
        if current_v > 5
            break
        end
    end
    fontsize(8)
    text(join(legend, "; "), 0, 600, halign=:center)
    @test finish() == true
    println("...finished test: output in $(fname)")
end

text_alignment_tests("text-alignment-tests.pdf")
