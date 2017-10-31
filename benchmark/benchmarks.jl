using PkgBenchmark, Luxor


@benchgroup "basicgraphics" begin
    @bench "circle" begin
        Drawing(1000, 1000, "luxor-test1.pdf")
        origin()
        t = Tiler(1000, 1000, 10, 10, margin=10)
        for (pos, n) in t
            randomhue()
            circle(pos, t.tilewidth/2, :fill)
        end
        finish()
    end
    @bench "box" begin
        Drawing(1000, 1000, "luxor-test2.pdf")
        origin()
        t = Tiler(1000, 1000, 10, 10, margin=10)
        for (pos, n) in t
            sethue("red")
            setopacity(rand())
            box(pos, t.tilewidth/2, t.tilewidth/2, :fill)
        end
        finish()
    end
end
