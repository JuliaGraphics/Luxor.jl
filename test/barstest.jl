#!/usr/bin/env julia

using Luxor, Test, Random

Random.seed!(42)

function barfunc1(values, i, lowpos, highpos, barwidth, scaledvalue)
    extremes=extrema(values)
    barnumber=i
    bartotal=sum(values)
    @layer begin
        sethue(rescale(values[i], 0, extremes[2], 0, 1), rand(), rand())
        circle(lowpos, 2, :fill)
        box(Point(lowpos.x - 5, lowpos.y), Point(highpos.x + 5, highpos.y), :fill)
        fontsize(6)
        sethue("black")
        textbox([string(round(values[i], digits=2))], Point(lowpos.x, 100), leading=5, alignment=:center)
        sethue("gray80")
        setline(0.5)
        setdash("dot")
        line(lowpos, Point(lowpos.x, 100), :stroke)
    end
end

function barfunc2(values, i, lowpos, highpos, barwidth, scaledvalue)
    extremes=extrema(values)
    barnumber=i
    bartotal=sum(values)
    @layer begin
        sethue("red")
        randomhue()
        setline(4)
        setlinecap("round")
        line(lowpos, highpos, :stroke)
        circle(highpos, 2, :fill)

        arrow(highpos - (barwidth/2.0, 0), highpos + (barwidth/2.0, 0))
    end
end

emptylabelfunction(args...) = nothing

function mylabelfunction(values, i, lowpos, highpos, scaledvalue)
    t = string(values[i])
    textoffset = textextents(t)[4]
    @layer begin
        translate(highpos)
        rotate(-π/2)
        text(t, O, halign=:left, valign=:middle)
    end
end

function test_barchart(fname)
    pagewidth, pageheight = 1200, 1400
    Drawing(pagewidth, pageheight, fname)
    background("antiquewhite")
    fontsize(10)
    sethue("black")
    origin()
    tiles = Tiler(pagewidth, pageheight, 3, 2, margin=35)
    for (pos, n) in tiles
        @layer begin
            if n == 1
                v = randn(15)
                text("line bar function, grey label function",pos)
                barchart(v,
                    boundingbox=BoundingBox(box(tiles, n)),
                    barfunction = (values, i, lowpos, highpos, barwidth, scaledvalue) ->  begin
                      @layer begin
                        setline(rescale(values[i], extrema(values)..., 1, 50))
                        setgray(rand())
                        line(lowpos, highpos, :stroke)
                      end
                    end,
                    labelfunction = (values, i, lowpos, highpos, barwidth, scaledvalue) ->  begin
                      @layer begin
                        text(string(i), highpos, halign=:center)
                      end
                    end,
                    border = true)
                box(tiles, n, :stroke)
            elseif n == 2
                # no labels
                v = rand(1:10, 20)
                barchart(v,
                    boundingbox=BoundingBox(box(tiles, n)) * 0.8,
                    labelfunction=emptylabelfunction)
            elseif n == 3
                # a custom label function
                v = rand(20)
                barchart(v,
                    boundingbox=BoundingBox(box(pos, tiles.tilewidth, tiles.tileheight, vertices=true)) * 0.8,
                    labelfunction=mylabelfunction)
            elseif n == 4
                # a custom barfunction
                v = rand(5:0.1:10, 20)
                barchart(v,
                    boundingbox=BoundingBox(box(pos, tiles.tilewidth, tiles.tileheight, vertices=true)) * 0.8,
                    barfunction = barfunc1)
            elseif n == 5
                # another custom barfunction
                v = rand(-20:2:20, 30)
                barchart(v,
                    boundingbox=BoundingBox(box(pos, tiles.tilewidth, tiles.tileheight, vertices=true)) * 0.8,
                    barfunction=barfunc2)
            else
                v = randn(15)
                barchart(v,
                    boundingbox=BoundingBox(box(pos, tiles.tilewidth, tiles.tileheight, :none)) * 0.8,
                    barfunction=barfunc2)
            end
        end
    end
    @test finish() == true
    println("...finished barstest, saved in $(fname)")
end
fname = "bars-test.png"
test_barchart(fname)
