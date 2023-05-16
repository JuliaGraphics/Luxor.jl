using Luxor
using BenchmarkTools

function bm_text()
    Drawing(1000, 1000, :png)
    origin()
    t = Tiler(1000, 1000, 30, 30, margin=10)
    for (pos, n) in t
        text(string(n), pos, halign=:center)
    end
    finish()
end

function bm_graphics()
    Drawing(1000, 1000, :png)
    origin()
    t = Tiler(1000, 1000, 30, 30, margin=10)
    for (pos, n) in t
        @layer begin
            setcolor("red")
            setopacity(0.3)
            box(pos, t.tilewidth/2, t.tilewidth/2, :fill)
            circle(pos, t.tilewidth / 2, :stroke)
        end 
    end
    finish()
end

function bm_text_outlines()
    Drawing(1000, 1000, :png)
    background("white")
    origin()
    fontsize(30)
    t = Tiler(1000, 1000, 10, 10, margin=10)
    for (pos, n) in t
        textoutlines(string(n), pos, halign=:center, action=:path, startnewpath=false)
    end    
    sethue("black")
    strokepath()
    finish()
end
