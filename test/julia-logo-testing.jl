#!/usr/bin/env julia

using Luxor

using Test

function julia_logo_test(fname)
    Drawing(1000, 1000, fname)
    origin()
    background("white")
    for (pos, n) in Tiler(1000, 1000, 2, 2)
        gsave()
        translate(pos - Point(150, 100))
        if n == 1
            julialogo()
            fillpath()
        elseif n == 2
            randomhue()
            setline(0.3)
            julialogo(action=:stroke)
        elseif n == 3
            sethue("orange")
            julialogo(color=false)
        elseif n == 4
            julialogo(action=:clip)
            setopacity(0.6)
            for i in 1:400
                randomhue()
                gsave()
                box(Point(rand(0:250), rand(0:250)), 350, 5, :fill)
                grestore()
            end
            clipreset()
        end
        grestore()
    end
    @test finish() == true
end

fname="julia-logo-drawing.pdf"
julia_logo_test(fname)
println("...finished test: output in $(fname)")
