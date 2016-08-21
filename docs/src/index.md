## Luxor

Luxor is the lightest dusting of syntactic sugar on Julia's Cairo graphics package (which should also be installed). It provides some basic vector drawing commands, and a few utilities for working with polygons, clipping masks, PNG images, and turtle graphics.

![](examples/tiled-images.png)

The idea of Luxor is that it's slightly easier to use than [Cairo.jl](https://github.com/JuliaLang/Cairo.jl), with shorter names, fewer underscores, default contexts, and simplified functions. It's for when you just want to draw something without too much ceremony. If you've ever hacked on a PostScript file, you should feel right at home (only without the reverse Polish notation, obviously).

For a much more powerful (and harder to use) graphics environment, try [Compose.jl](http://composejl.org). [Colors.jl](https://github.com/JuliaGraphics/Colors.jl) provides excellent color definitions and is also required.

# Current status #

It's been updated for Julia version 0.5 and for the new Colors.jl.
Needs more testing on Unix and Windows platforms.

# Installation and basic usage

To install:

```
Pkg.clone("https://github.com/cormullion/Luxor.jl")
```

and to use:

```
using Luxor
```

## The basic "Hello World"

Here's a simple "Hello world":

!["Hello world"](examples/hello-world.png)

```julia
using Luxor, Colors
Drawing(1000, 1000, "/tmp/hello-world.png")
origin()
sethue("red")
fontsize(50)
text("hello world")
finish()
preview()
```

The `Drawing(1000, 1000, "/tmp/hello-world.png")` line defines the size of the image and the location of the finished image when it's saved.

`origin()` moves the 0/0 point to the centre of the drawing surface (by default it's at the top left corner). Because we're using `Colors.jl`, we can specify colors by name.

`text()` places text. It's placed at 0/0 if you don't specify otherwise.

`finish()` completes the drawing and saves the image in the file. `preview()` tries to open the saved file using some other application (eg on MacOS X, Preview).

## A slightly more interesting image

![Luxor test](examples/basic-test.png)

```julia
using Luxor, Colors
Drawing(1200, 1400, "/tmp/basic-test.png") # or PDF/SVG filename for PDF or SVG

origin()
background("purple")

setopacity(0.7)                      # opacity from 0 to 1
sethue(0.3,0.7,0.9)                  # sethue sets the color but doesn't change the opacity
setline(20)                          # line width

rect(-400,-400,800,800, :fill)       # or :stroke, :fillstroke, :clip
randomhue()
circle(0, 0, 460, :stroke)

circle(0,-200,400,:clip)             # a circular clipping mask above the x axis
sethue("gold")
setopacity(0.7)
setline(10)

for i in 0:pi/36:2pi - pi/36
    move(0, 0)
    line(cos(i) * 600, sin(i) * 600 )
    stroke()
end

clipreset()                           # finish masking

fontsize(60)
setcolor("turquoise")
fontface("Optima-ExtraBlack")
textwidth = textextents("Luxor")[5]

# move the text by half the width
textcentred("Luxor", -textwidth/2, currentdrawing.height/2 - 400)

fontsize(18)
fontface("Avenir-Black")

# text on curve starting at angle 0 rads centered on origin with radius 550
textcurve("THIS IS TEXT ON A CURVE " ^ 14, 0, 550, Point(0, 0))

finish()
preview() # on macOS, opens in Preview
```

## Types

The two main defined types are the `Point` and the `Drawing`. The Point type holds two coordinates, the x and y:

```
`Point(12.0, 13.0)`
```

## Drawings and files

To create a drawing, and optionally specify the filename and type, and dimensions, use the `Drawing` function.

```@docs
Drawing
```

To finish a drawing and close the file, use `finish()`, and, to launch an external application to view it, use `preview()`.

```@docs
finish
preview
```

The global variable `currentdrawing` holds a few parameters:

```
julia> fieldnames(currentdrawing)
10-element Array{Symbol,1}:
:width
:height
:filename
:surface
:cr
:surfacetype
:redvalue
:greenvalue
:bluevalue
:alpha
```

## Axes and backgrounds

The origin (0/0) is at the top left, x axis runs left to right, y axis runs top to bottom.

The `origin()` function moves the 0/0 point. The `axes()` function draws a couple of lines to indicate the current axes. `background()` fills the entire image with a color.

```@docs
background
axes
origin
```

## Basic drawing

The underlying Cairo drawing model is similar to PostScript: paths can be filled and/or stroked, using the current graphics state, which specifies colors, line thicknesses and patterns, and opacity.

Many drawing functions have an *action* argument. This can be `:nothing`, `:fill`, `:stroke`, `:fillstroke`, `:fillpreserve`, `:strokepreserve`, `:clip`. The default is `:nothing`.

Positions are usually specified either by x and y coordinates or a `Point(x, y)`. Angles are usually measured from the positive x-axis to the positive y-axis (which points 'down' the page or canvas) in radians, clockwise.

### Simple shapes

Functions for drawing shapes include `circle()`, `arc()`, `carc()`, `curve()`, `sector()`, `rect()`, and `box()`.

```@docs
circle
arc
carc
curve
sector
rect
box
```

### Lines and arcs

There is a 'current position' which you can set with `move()`, and use implicitly in functions like `line()` and `text()`.

```@docs
move
rmove
line
rline
```

## Paths

A path is a group of points. A path can have subpaths (which can form holes).

```@docs
newpath
newsubpath
closepath
```

The `getpath()` function get the current Cairo path as an array of element types and points. `getpathflat()` gets the current path as an array of type/points with curves flattened to line segments.

## Color and opacity

For color definitions and conversions, we use Colors.jl. The difference between the `setcolor()` and `sethue()` functions is that `sethue()` is independent of alpha opacity, so you can change the hue without changing the current opacity value (this is similar to Mathematica).

## Styles

The `set-` commands control the width, end shapes, join behaviour and dash pattern:

```@docs
setline
setlinecap
setlinejoin
setdash
fillstroke
stroke
fill
strokepreserve
fillpreserve
```

`gsave()` saves a copy of the current graphics settings (current axis rotation, position, scale, line and text settings, and so on). When the next `grestore()` is called, all changes you've made to the graphics settings will be discarded, and they'll return to how they were when you used `gsave()`. `gsave()` and `grestore()` should always be balanced in pairs.

```@docs
gsave
grestore
```

## Polygons and shapes

### Regular polygons ("ngons")

You can make regular polygons — from triangles, pentagons, hexagons, septagons, heptagons, octagons, nonagons, decagons, and on-and-on-agons — with `ngon()` and `ngonv()`. `ngon()` makes the shapes: if you just want the raw points, use `ngonv`, which returns an array of points instead:

![n-gons](examples/n-gon.png)

```julia
using Luxor, Colors
Drawing(1200, 1400)

origin()
cols = diverging_palette(60,120, 20) # hue 60 to hue 120
background(cols[1])
setopacity(0.7)
setline(2)

ngon(0, 0, 500, 8, 0, :clip)

for y in -500:50:500
  for x in -500:50:500
    setcolor(cols[rand(1:20)])
    ngon(x, y, rand(20:25), rand(3:12), 0, :fill)
    setcolor(cols[rand(1:20)])
    ngon(x, y, rand(10:20), rand(3:12), 0, :stroke)
  end
end

finish()
preview()
```

```@docs
ngon
ngonv
```
### Polygons

A polygon is an array of Points. Use poly() to add them, or randompointarray() to create a random list of Points.

Polygons can contain holes. The `reversepath` keyword changes the direction of the polygon.

The following piece of code uses `ngon()` to make two polygons, the second forming a hole in the first, to make a hexagonal bolt shape:

```
ngon(0, 0, 60, 6, 0, :path)
newsubpath()
ngon(0, 0, 40, 6, 0, :path, reversepath=true)
fillstroke()
```

Polygons can be simplified using the Douglas-Peucker algorithm (non-recursive version), via `simplify()`.

```@docs
simplify
```

There are some experimental polygon functions. These don't work well for polygons that aren't simple or where the sides intersect each other.

```@docs
polysplit
polysortbydistance
polysortbyangle
polycentroid
polybbox
```

The `prettypoly()` function can place graphics at each vertex of a polygon. After the polygon action, the `vertex_action` is evaluated at each vertex. For example, to mark each vertex of a polygon with a circle scaled to 0.1:

```
prettypoly(pl, :fill, :(
                        scale(0.1, 0.1);
                        circle(0, 0, 10, :fill)
                       ),
           close=false)
```

The `vertex_action` expression can't use definitions that are not in scope, eg you can't pass a variable in from the calling function and expect the polygon-drawing function to know about it.

### Stars

Use `starv()` to return the vertices of a star, and `star()` to make a star.

![stars](examples/stars.png)

```julia
using Luxor, Colors
w, h = 600, 600
Drawing(w, h, "/tmp/stars.png")
origin()
cols = [RGB(rand(3)...) for i in 1:50]
background("grey20")
x = -w/2
for y in 100 * randn(h, 1)
    setcolor(cols[rand(1:end)])
    star(x, y, 10, rand(4:7), rand(3:7)/10, 0, :fill)
    x += 2
end
finish()
preview()
```

```@docs
starv
star
```

## Text and fonts

### Placing text

Use `text()` and `textcentred()` to place text. `textpath()` converts the text into  a graphic path suitable for further manipulations.

```@docs
text
textcentred
textpath
```

### Fonts

Use `fontface(fontname)` to choose a font, and `fontsize(n)` to set font size in points.

The `textextents(str)` function gets array of dimensions of the string `str`, given current font.

```@docs
fontface
fontsize
textextents
```

### Text on a curve

Use `textcurve(str)` to draw a string `str` on a circular arc.

![text on a curve or spiral](examples/text-spiral.png)

```julia
  using Luxor, Colors
  Drawing(1800, 1800, "/tmp/text-spiral.png")
  fontsize(18)
  fontface("LucidaSansUnicode")
  origin()
  background("ivory")
  sethue("royalblue4")
  textstring = join(names(Base), " ")
  textcurve("this spiral contains every word in julia names(Base): " * textstring, -pi/2,
    800, 0, 0,
    spiral_in_out_shift = -18.0,
    letter_spacing = 0,
    spiral_ring_step = 0)

  fontsize(35)
  fontface("Agenda-Black")
  textcentred("julia names(Base)", 0, 0)
  finish()
  preview()
```

```@docs
textcurve
```

### Text clipping

You can use newly-created text paths as a clipping region - here the text paths are 'filled' with names of randomly chosen Julia functions.

![text clipping](examples/text-path-clipping.png)

```julia
    using Luxor, Colors

    currentwidth = 1250 # pts
    currentheight = 800 # pts
    Drawing(currentwidth, currentheight, "/tmp/text-path-clipping.png")

    origin()
    background("darkslategray3")

    fontsize(600)                             # big fontsize to use for clipping
    fontface("Agenda-Black")
    str = "julia"                             # string to be clipped
    w, h = textextents(str)[3:4]              # get width and height

    translate(-(currentwidth/2) + 50, -(currentheight/2) + h)

    textpath(str)                             # make text into a path
    setline(3)
    setcolor("black")
    fillpreserve()                            # fill but keep
    clip()                                    # and use for clipping region

    fontface("Monaco")
    fontsize(10)
    namelist = map(x->string(x), names(Base)) # get list of function names in Base.

    x = -20
    y = -h
    while y < currentheight
        sethue(rand(7:10)/10, rand(7:10)/10, rand(7:10)/10)
        s = namelist[rand(1:end)]
        text(s, x, y)
        se = textextents(s)
        x += se[5]                            # move to the right
        if x > w
           x = -20                            # next row
           y += 10
        end
    end

    finish()
    preview()
```

## Transforms and matrices

For basic transformations of the drawing space, use `scale(sx, sy)`, `rotate(a)`, and `translate(tx, ty)`.

```@docs
scale
rotate
translate
```

The current matrix is a six number array, perhaps like this:

```
[1, 0, 0, 1, 0, 0]
```

`getmatrix()` gets the current matrix, `setmatrix(a)` sets the matrix to array `a`, and  `transform(a)` transforms the current matrix by 'multiplying' it with matrix `a`.

```@docs
getmatrix
setmatrix
transform
```

## Clipping

Use `clip()` to turn the current path into a clipping region, masking any graphics outside the path. `clippreserve()` keep the current path, but also use it as a clipping region. `clipreset()` resets it. `:clip` is also an action for drawing commands like `circle()`.

```@docs
clip
clippreserve
clipreset
```

This example loads a file containing a function that draws the Julia logo. It can create paths but doesn't necessarily apply an action them; they can therefore be used as a mask for clipping subsequent graphics:

![julia logo mask](examples/julia-logo-mask.png)

```julia
# load functions to draw the Julia logo
include("../test/julia-logo.jl")

currentwidth = 500 # pts
currentheight = 500 # pts
Drawing(currentwidth, currentheight, "/tmp/clipping-tests.pdf")

function draw(x, y)
    foregroundcolors = diverging_palette(rand(0:360), rand(0:360), 200, s = 0.99, b=0.8)
    gsave()
    translate(x-100, y)
    julialogo(false, true)      # add paths for logo
    clip()                      # use paths for clipping
    for i in 1:500
        sethue(foregroundcolors[rand(1:end)])
        circle(rand(-50:350), rand(0:300), 15, :fill)
    end
    grestore()
end

origin()
background("white")
setopacity(.4)
draw(0, 0)

finish()
preview()
```

## Images ##

There is some limited support for placing PNG images on the drawing. First, load a PNG image using `readpng(filename)`.

```@docs
readpng
```

Then use `placeimage()` to place a loaded PNG image by its top left corner at point `x/y` or `pt`.

```@docs
placeimage
```
!["Images"](examples/test-image.png)

```julia
img = readpng(filename)
placeimage(img, xpos, ypos)
placeimage(img, pt::Point)
placeimage(img, xpos, ypos, 0.5) # use alpha transparency of 0.5
placeimage(img, pt::Point, 0.5)

img = readpng("examples/julia-logo-mask.png")
w = img.width
h = img.height
placeimage(img, -w/2, -h/2) # centered at point
```

Image clipping is possible:

```julia
using Luxor

width, height = 4000, 4000
margin = 500

Drawing(width, height, "/tmp/cairo-image.pdf")
origin()
background("grey25")

setline(5)
sethue("green")

image = readpng("examples/julia-logo-mask.png")
w = image.width
h = image.height

x = (-width/2) + margin
y = (-height/2) + margin

for i in 1:36
    circle(x, y, 250, :stroke)
    circle(x, y, 250, :clip)
    gsave()
    translate(x, y)
    scale(.95, .95)
    rotate(rand(0.0:pi/8:2pi))

    placeimage(image, -w/2, -h/2)

    grestore()
    clipreset()
    x += 600
    if x > width/2
        x = (-width/2) + margin
        y += 600
    end
end

finish()
preview()
```

## Turtle graphics

Some simple "turtle graphics" commands are included. Functions to control the turtle begin with a capital letter: Forward, Turn, Circle, Orientation, Rectangle, Pendown, Penup, Pencolor, Penwidth, and Reposition.

![Turtle](examples/turtles.png)

```julia
using Luxor, Colors

Drawing(1200, 1200, "/tmp/turtles.png")
origin()
background("black")

# let's have two turtles
raphael = Turtle(0, 0, true, 0, (1.0, 0.25, 0.25)) ; michaelangelo = Turtle(0, 0, true, 0, (1.0, 0.25, 0.25))

setopacity(0.95)
setline(6)

Pencolor(raphael, 1.0, 0.4, 0.2);       Pencolor(michaelangelo, 0.2, 0.9, 1.0)
Reposition(raphael, 500, -200);         Reposition(michaelangelo, 500, 200)
Message(raphael, "Raphael");            Message(michaelangelo, "Michaelangelo")
Reposition(raphael, 0, -200);           Reposition(michaelangelo, 0, 200)

pace = 10
for i in 1:5:400
    for turtle in [raphael, michaelangelo]
        Circle(turtle, 3)
        HueShift(turtle, rand())
        Forward(turtle, pace)
        Turn(turtle, 30 - rand())
        Message(turtle, string(i))
        pace += 1
    end
end

finish()
preview()
```

```@docs
Turtle
Forward
Turn
Circle
Orientation
Rectangle
Pendown
Penup
Pencolor
Penwidth
Reposition
```

## More examples

### Sierpinski triangle

![Sierpinski](examples/sierpinski.png)

```julia
using Luxor, Colors

function triangle(points::Array{Point}, degree::Int64)
    global counter, cols
    setcolor(cols[degree+1])
    poly(points, :fill)
    counter += 1
end

function sierpinski(points::Array{Point}, degree::Int64)
    triangle(points, degree)
    if degree > 0
        p1, p2, p3 = points
        sierpinski([p1, midpoint(p1, p2),
                        midpoint(p1, p3)], degree-1)
        sierpinski([p2, midpoint(p1, p2),
                        midpoint(p2, p3)], degree-1)
        sierpinski([p3, midpoint(p3, p2),
                        midpoint(p1, p3)], degree-1)
    end
end

@time begin
    depth = 8 # 12 is ok, 20 is right out
    cols = distinguishable_colors(depth+1)
    Drawing(400, 400, "/tmp/sierpinski.svg")
    origin()
    setopacity(0.5)
    counter = 0
    my_points = [Point(-100,-50), Point(0,100), Point(100.0,-50.0)]
    sierpinski(my_points, depth)
    println("drew $counter triangles")
end

finish()
preview()

# drew 9841 triangles
# elapsed time: 1.738649452 seconds (118966484 bytes allocated, 2.20% gc time)
```
