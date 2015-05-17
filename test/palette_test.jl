#!/Applications/Julia-0.3.2.app/Contents/Resources/julia/bin/julia

using Luxor, Color
currentwidth = 1000 # pts
currentheight = 1000 # pts

Drawing(currentwidth, currentheight, "/tmp/color-palette.pdf")

origin()
background(color("grey50"))


function draw_color_bars()
    setcolor(1,1,1)
    fontsize(8)

    number_of_colours = 50
    colormap = sequential_palette(0, number_of_colours)

    text("sequential palette 0", -currentwidth/2 + 20, -currentheight/2 + 20)

    x = -currentwidth/2 + 40
    y = -currentheight/2 + 40

    tilesize = (currentheight - 40 * 2) / number_of_colours

    for c in colormap
        setcolor(c)
        rect(x, y, tilesize, tilesize, :fill)
        setcolor(1,1,1)
        text(string(@sprintf("%2.2f ",c.r), @sprintf("%2.2f ",c.g),@sprintf("%2.2f ",c.b)), x + tilesize + 5, y + tilesize/2)
        y +=tilesize
    end
end

draw_color_bars()
finish()
preview()
