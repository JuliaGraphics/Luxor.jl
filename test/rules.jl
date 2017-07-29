#!/usr/bin/env julia

using Luxor

using Base.Test



function rule_test(fname)
    Drawing(2000, 2000, fname)
    origin()
    setline(0.2)
    for x in logspace(0, 3, 60)
        rule(Point(0 + x, 0), pi/2)
        rule(Point(0 - x, 0), pi/2)
        rotate(0.05)
    end    
    for y in logspace(0, 3, 60)
        rule(Point(0, 0 + y), 0)
        rule(Point(0, 0 - y), 0)
        rotate(0.05)
    end
    @test finish() == true
    println("...finished test: output in $(fname)")
end

rule_test("rules.pdf")
