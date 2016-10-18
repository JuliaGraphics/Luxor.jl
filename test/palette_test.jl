#!/usr/bin/env julia

using Luxor, Base.Test

function draw_color_bars(x, y, n, colmap, label)
    setcolor(1,1,1)
    fontsize(8)

    number_of_colours = n
    text(label, x, y - 10)

    tilesize = (currentheight - 40 * 2) / number_of_colours

    for c in colmap
        setcolor(c)
        rect(x, y, tilesize, tilesize, :fill)
        setcolor(1,1,1)
        text(string(@sprintf(" %2.2f ",c.r), @sprintf("%2.2f ",c.g),@sprintf("%2.2f ",c.b)), x + tilesize + 5, y + tilesize/2)
        y +=tilesize
    end
end


function palette_test(fname)
    global currentwidth = 1000 # pts
    global currentheight = 1000 # pts
    Drawing(currentwidth, currentheight, fname)

    # background
    setcolor("grey50")
    rect(0,0,currentwidth, currentheight, :fill)

    # sequential_palette(h, [N::Int=100; c=0.88, s=0.6, b=0.75, w=0.15, d=0.0, wcolor=RGB(1,1,0), dcolor=RGB(0,0,1), logscale=false])
    # diverging_palette(h1, h2 [, N::Int=100; mid=0.5,c=0.88, s=0.6, b=0.75, w=0.15, d1=0.0, d2=0.0, wcolor=RGB(1,1,0), dcolor1=RGB(1,0,0), dcolor2=RGB(0,0,1), logscale=false])
    # colormap(cname::String [, N::Int=100; mid=0.5, logscale=false, kvs...])

    draw_color_bars(20, 20, 50, diverging_palette(0, 360, 50, mid=0.1), "diverging 0 360 mid 0.1")
    draw_color_bars(120, 20, 50, sequential_palette(0, 50), "sequential 0 #50")
    draw_color_bars(220, 20, 50, sequential_palette(128, 50), "sequential 128 #50")
    draw_color_bars(320, 20, 50, sequential_palette(200, 50), "sequential 200 #50")
    draw_color_bars(420, 20, 50, diverging_palette(120, 140, 50, mid=0.1), "diverging 120 140 #50 ")
    draw_color_bars(520, 20, 50, distinguishable_colors(50), "distinguishable")
    draw_color_bars(620,  20, 50, diverging_palette(120, 140, 50, b=1.0), "diverging 120 140 b 0.5")
    draw_color_bars(720,  20, 50, diverging_palette(120, 140, 50, mid=1.0), "diverging 120 140 mid 1.0")

    @test finish() == true
    println("...finished test: output in $(fname)")
end

palette_test("color-palette.pdf")
