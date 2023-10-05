using Luxor
using Colors
using Test

function getcelltest(fname)
    Drawing(1200, 1200, fname)
    origin()
    a = [1, 2, 4]
    b = 2:3
    R = 6
    k = 7
    fontsize(30)
    panes = Tiler(1200, 1200, 3, 3)
    @layer begin
        translate(first(panes[1]))
        t = Tiler(260, 260, R, 4)
        for (pos, n) in t
            sethue(HSB(36n, 0.7, 0.8))
            box(t, n, :fill)
            sethue("purple")
            box(t, n, :stroke)
        end
        s = getcells(t, a, b)
        for is in s
            pt, n = is
            sethue("white")
            circle(pt, 20, :fill)
        end
    end
    @layer begin
        translate(first(panes[2]))
        t = Table(R, 4, 40, 40)
        for (pos, n) in t
            sethue(HSB(36n, 0.7, 0.8))
            box(t, n, :fill)
            sethue("purple")
            box(t, n, :stroke)
        end
        s = getcells(t, a, b)
        for is in s
            pt, n = is
            sethue("white")
            circle(pt, 20, :fill)
        end
    end

    @layer begin
        translate(first(panes[3]))
        t = Tiler(260, 260, R, 4)
        for (pos, n) in t
            sethue(HSB(36n, 0.7, 0.8))
            box(t, n, :fill)
            sethue("purple")
            box(t, n, :stroke)
        end
        s = getcells(t, k)
        for is in s
            pt, n = is
            sethue("white")
            circle(pt, 20, :fill)
            sethue("black")
            text(string(k), pt, halign=:center, valign=:middle)
        end
    end

    @layer begin
        translate(first(panes[4]))
        t = Tiler(250, 250, R, 4)
        t = Table(R, 4, 40, 40)
        for (pos, n) in t
            sethue(HSB(36n, 0.7, 0.8))
            box(t, n, :fill)
            sethue("purple")
            box(t, n, :stroke)
        end
        s = getcells(t, 22:-3:7)
        markcells(t, s,
            action=:fill,
            func=(pos, w, h, n) -> begin
                sethue("white")
                circle(pos, h / 2, :fill)
                sethue("black")
                text(string(n), pos, halign=:center, valign=:middle)
            end
        )
    end

    @layer begin
        translate(first(panes[5]))
        t = Tiler(400, 400, 5, 6)
        markcells(t, getcells(t, 1:30),
            func=(pos, w, h, n) -> begin
                sethue(["red", "green", "blue", "purple"][mod1(n, end)])
                circle(pos, w / 2, :fill)
                sethue("white")
                text(string(n), pos, halign=:center, valign=:middle)
            end)
    end

    @layer begin
        translate(first(panes[6]))
        t = Tiler(300, 300, 4, 5)
        t = Table(4, 5, 50, 60)
        for (pos, n) in t
            sethue(HSB(36n, 0.7, 0.8))
            box(t, n, :fill)
            sethue("purple")
            box(t, n, :stroke)
            text(string(n), pos, halign=:center, valign=:middle)
        end
        markcells(t, getcells(t, 1:2:10),
            func=(pos, w, h, n) -> begin
                isodd(n) ? sethue("red") : sethue("green")
                circle(pos, w / 2, :fill)
                sethue("white")
                text(string(n), pos, halign=:center, valign=:middle)
            end)

    end
    @test finish() == true
end

fname = "getcell.png"
getcelltest(fname)
println("getcell test: output in $(fname)")
println("...finished getcell tests: output in $(fname)")
