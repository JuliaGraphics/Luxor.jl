using BenchmarkTools, Luxor

@benchmark begin
    Drawing(1000, 1000, "/tmp/test1.pdf")
    origin()
    t = Tiler(1000, 1000, 10, 10, margin=10)
    for (pos, n) in t
        randomhue()
        circle(pos, t.tilewidth/2, :fill)
    end
    finish()
end

@benchmark begin
    Drawing(1000, 1000, "/tmp/test2.pdf")
    origin()
    t = Tiler(1000, 1000, 10, 10, margin=10)
    for (pos, n) in t
        sethue("red")
        setopacity(rand())
        box(pos, t.tilewidth/2, t.tilewidth/2, :fill)
    end
    finish()
end
