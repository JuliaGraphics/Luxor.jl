# Luxor

Luxor is the lightest dusting of syntactic sugar on the Cairo graphics package, which must be installed.

Luxor is intended to be slightly easier to use than Cairo, with shorter names, fewer underscores, and simplified functions.

It's for when you just want to draw something without too much ceremony.

I usually load Color.jl as well.

# Usage

    using Luxor, Color
    Drawing(1200, 1400, "/tmp/my-pdf.pdf") 
    # or PNG filename for PNG
    
    origin() # move 0/0 to center
    
    background(color("purple"))

    # opacity from 0 to 1

    setopacity(0.7)

    # sethue sets the color but doesn't change the opacity

    sethue(0.3,.7,0.9)

    setline(20)

    # graphics functions use fill, stroke, fillstroke, 
    # clip, or leave blank

    rect(-400,-400,800,800, fill)

    randomhue()

    circle(0, 0, 460, stroke)

    finish()

    preview() # Mac OS X only, opens in Preview  

# To do
