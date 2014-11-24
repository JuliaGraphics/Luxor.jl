#!/Applications/Julia-0.3.2.app/Contents/Resources/julia/bin/julia

using Luxor, Color

# Luxor is the lightest dusting of syntactic sugar on the Cairo graphics package, which must be installed. 
# It's slightly easier to use than Cairo, with shorter names, fewer undescores, and simplified functions.
# It's for when you just want to draw something without ceremony.

# Load the module:
# using Luxor
# Then create a drawing:

Drawing(1200, 1400, "/tmp/my-pdf.pdf") 

# if you don't specify width, height, and filename (eg Drawing()), you'll get a 
# width=800, height=800, PNG file saved in "/tmp/test.png"

# Color.jl provides many colors and goodies, Here's a color ramp from sea green to blue:
cramp = linspace(Color.color("darkseagreen"), Color.color("slateblue"), 15)

# a list of 6 points suitable for drawing hexagons
hexagon(r) = [(r * cos(theta), r * sin(theta)) for theta in 0:pi/3:6]
# a list of 7 points suitable for drawing heptagons, starting at the top - these are going to be closed polys ...
heptagon(r) = [(r * cos(theta), r * sin(theta)) for theta in -pi/2:pi/3.5:(3*pi)/2]

# The following code creates the same drawing in both PDF and PNF formats

# TODO this sometimes catches out OS X Yosemite Preview -> PDF - timing issues? bug?

function testdrawing(doc)
    # create drawing 1200 pixels wide by 1300 pixels high
    Drawing(1200, 1400, doc)
    # move 0/0 to center
    origin()

    # draw a background
    background(color("purple"))

    # opacity from 0 to 1
    setopacity(0.7)

    # sethue sets the color but doesn't change the opacity
    sethue(0.3,.7,0.9)
    
    # rectangles xleft, ybottom, width, height: use fill, stroke, fillstroke, clip, or leave blank
    rect(-400,-400,800,800, fill)
    # line width in points/pixels?
    setline(20)
    
    # any color, with current opacity
    randomhue()
    
    # circle xc, yc, radius, use fill, stroke, fillstroke, clip, or leave blank
    circle(0,0,460, stroke)

    setline(1)
    
    for i in enumerate(500:-50:50)
        # set a color from the color ramp, unlike sethue this changes opacity
        setcolor(cramp[first(i)])
        # draw polygons from list of points; close path (not closed by default)
        # polygon can use fill, stroke, fillstroke, clip, or leave blank
        poly(hexagon(last(i)), fill, close=true)
    end

    # clip the following graphics to a circle positioned above the x axis
    circle(0,-400,400,clip)
    sethue(color("gold"))
    setopacity(0.7)
    setline(10)
    # simple line drawing
    for i in pi/2:pi/36:2*pi
        move(0, 0)
        line(cos(i) * 600, sin(i) * 600 )
        stroke()
    end
    # finish clipping
    clipreset()

    # heptagons 
    setcolor(color("yellow"))
    setline(0.5)
    for i in 100:25:600
        # instead of translate(), you can move the y coordinates up with an anon function
        poly(map(pt -> (pt[1], pt[2] - 100), heptagon(i)), stroke, close=true)
    end

    # text
    setcolor(color("white"))
    fontsize(22)
    fontface("Helvetica-Bold")
    
    # text at x/y, using current drawing's dimensions to position it at the top
    # text("Drawn using Cairo", 0, -currentdrawing.height/2 + 30)
    
    # TODO unfortunately this would be left justified, not centered yet...
    # to center text currently we first have to get the width of the text 
    fontsize(50)
    # using  Mac OS X fonts
    fontface("Optima-ExtraBlack")
    textwidth = textextents("Centered text")[5]
    # then move the text by half the width
    text("Centered text", -textwidth/2, currentdrawing.height/2 - 60)
        
    # text on curve starting on an arc: arc starts at a line through (0,-10) radius 550, centered at 0,0 
    fontsize(18)
    fontface("Avenir-Black")
    textcurve("THIS IS TEXT ON A CURVE " ^ 14, 0, 0, 0, -10, 550)
    
    # saves the drawing in the file
    finish()
    
    # open using Preview (MacOS X only)
    preview()
end

testdrawing("/tmp/my-png.png")

# testdrawing("/tmp/my-pdf.pdf")
