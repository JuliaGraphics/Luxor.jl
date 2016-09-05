# Luxor

Luxor provides basic vector drawing functions and utilities for working with shapes, polygons, clipping masks, PNG images, and turtle graphics. It's a dusting of syntactic sugar on Julia's Cairo graphics package (which should also be installed).

The idea of Luxor is that it's easier to use than [Cairo.jl](https://github.com/JuliaLang/Cairo.jl), with shorter names, fewer underscores, default contexts, utilities, and simplified functions. It's for when you just want to draw something without too much ceremony. If you've ever hacked on a PostScript file, you should feel right at home (only without the reverse Polish notation, obviously).

For a more powerful (but less easy to use) graphics environment, try [Compose.jl](http://composejl.org). [Colors.jl](https://github.com/JuliaGraphics/Colors.jl) provides excellent color definitions.

## Current status

It's been updated for Julia version 0.5 and Colors.jl. It needs more testing on Unix and Windows platforms.

## Installation and basic usage

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

`origin()` moves the 0/0 point to the centre of the drawing surface (by default it's at the top left corner). Because we're `using Colors`.jl, we can specify colors by name.

`text()` places text. It's placed at the current 0/0 if you don't specify otherwise.

`finish()` completes the drawing and saves the image in the file. `preview()` tries to open the saved file using some other application (eg on MacOS X, Preview).

## A slightly more interesting example

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
clipreset()                           # finish clipping/masking
fontsize(60)
setcolor("turquoise")
fontface("Optima-ExtraBlack")
textwidth = textextents("Luxor")[5]
textcentred("Luxor", 0, currentdrawing.height/2 - 400)
fontsize(18)
fontface("Avenir-Black")

# text on curve starting at angle 0 rads centered on origin with radius 550
textcurve("THIS IS TEXT ON A CURVE " ^ 14, 0, 550, Point(0, 0))
finish()
preview() # on macOS, opens in Preview
```

# Overview

## Types

The two main defined types are the `Point` and the `Drawing`. The Point type holds two coordinates, the x and y:

```
Point(12.0, 13.0)
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

The global variable `currentdrawing` of type Drawing holds a few parameters:

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

The drawing area (or any other area) can be divided into tiles (rows and columns) using the `Tiler` iterator.

```@example
using Luxor, Colors # hide
Drawing(400, 300, "../examples/tiler.png") # hide
background("white") # hide
origin() # hide
tiles = Tiler(400, 300, 4, 5, margin=5)
for (pos, n) in tiles
  randomhue()
  box(pos, tiles.tilewidth, tiles.tileheight, :fillstroke)
end
finish() # hide
```

![](examples/tiler.png)

```@docs
Tiler
```

## Axes and backgrounds

The origin (0/0) is at the top left, x axis runs left to right, y axis runs top to bottom.

The `origin()` function moves the 0/0 point to the center of the drawing.

The `axes()` function draws a couple of lines and text labels in light gray to indicate the current axes.

`background()` fills the entire image with a color.

```@example
using Luxor, Colors # hide
Drawing(400, 400, "../examples/axes.png") # hide
background("gray20")
origin()
axes()
finish() # hide
```

![](examples/axes.png)

```@docs
background
axes
origin
```

# Basic drawing

The underlying Cairo drawing model is similar to PostScript: points are added to paths, paths can be filled and/or stroked, using the current graphics state, which specifies colors, line thicknesses and patterns, and opacity. You modify the drawing space by transforming/rotating/scaling it before you add graphics.

Many drawing functions have an *action* argument. This can be `:nothing`, `:fill`, `:stroke`, `:fillstroke`, `:fillpreserve`, `:strokepreserve`, `:clip`. The default is `:nothing`.

Positions are usually specified either by x and y coordinates or a `Point(x, y)`. Angles are usually measured from the positive x-axis to the positive y-axis (which points 'down' the page or canvas) in radians, so clockwise.

## Simple shapes

Functions for making shapes include `circle()`, `ellipse()`, `squircle()`, `arc()`, `carc()`, `curve()`, `sector()`, `rect()`, `pie()`, and `box()`.

## Rectangles and boxes

```@docs
rect
box
```

## Circles, ellipses, and the like

There are various ways to make circles, including by center and radius, through two points, or passing through three points. You can place ellipses (and circles) by defining centerpoint and width and height.

```@example
using Luxor, Colors # hide
Drawing(400, 200, "../examples/center3.png") # hide
background("white") # hide
origin() # hide
setline(3) # hide
sethue("black")
p1 = Point(0, -50)
p2 = Point(100, 0)
p3 = Point(0, 65)
map(p -> circle(p, 4, :fill), [p1, p2, p3])
sethue("orange") # hide
circle(center3pts(p1, p2, p3)..., :stroke)
finish() # hide
```

![](examples/center3.png)

```@docs
circle
ellipse
```

A sector has an inner and outer radius, as well as start and end angles.

```@example
using Luxor, Colors # hide
Drawing(400, 200, "../examples/sector.png") # hide
background("white") # hide
origin() # hide
sethue("cyan") # hide
sector(50, 90, pi/2, 0, :fill)
finish() # hide
```
```@docs
sector
```

![](examples/sector.png)

A pie has start and end angles.

```@example
using Luxor, Colors # hide
Drawing(400, 300, "../examples/pie.png") # hide
background("white") # hide
origin() # hide
sethue("magenta") # hide
pie(0, 0, 100, pi/2, 0, :fill)
finish() # hide
```

![](examples/pie.png)

```@docs
pie
```

A squircle is a cross between a square and a circle. You can adjust the squariness and circularity of it to taste:

```@example
using Luxor, Colors # hide
Drawing(600, 400, "../examples/squircle.png") # hide
background("white") # hide
origin() # hide
fontsize(20) # hide
setline(2)
tiles = Tiler(600, 400, 1, 3)
for (pos, n) in tiles
    sethue("lavender")
    squircle(pos, 80, 80, rt=[0.3, 0.5, 0.7][n], :fillpreserve)
    sethue("grey20")
    stroke()
    textcentered("rt = $([0.3, 0.5, 0.7][n])", pos)
end

finish() # hide
```

![](examples/squircle.png)

```@docs
squircle
```

## Lines, arcs, and curves

There is a 'current position' which you can set with `move()`, and can use implicitly in functions like `line()` and `text()`.

```@docs
move
rmove
line
rline
arc
carc
curve
```

### Arrows

You can draw lines or arcs with arrows at the end with `arrow()`. For straight arrows, supply the start and end points. For arrows as circular arcs, you provide center, radius, start and finish angles. You can optionally provide dimensions for the arrowheadlength and angle of the tip of the arrow.

```@example
using Luxor, Colors # hide
Drawing(400, 250, "../examples/arrow.png") # hide
background("white") # hide
origin() # hide
sethue("steelblue4") # hide
setline(2)
arrow(Point(0, 0), Point(0, -65))
arrow(Point(0, 0), Point(100, -65), arrowheadlength=20, arrowheadangle=pi/4)
arrow(Point(0, 0), 100, pi, pi/2, arrowheadlength=25,   arrowheadangle=pi/12)
finish() # hide
```
![](examples/arrow.png)

```@docs
arrow
```

## Paths

A path is a group of points. A path can have subpaths (which can form holes).

The `getpath()` function gets the current Cairo path as an array of element types and points. `getpathflat()` gets the current path as an array of type/points with curves flattened to line segments.

```@docs
newpath
newsubpath
closepath
getpath
getpathflat
```

## Color and opacity

For color definitions and conversions, use Colors.jl. The difference between the `setcolor()` and `sethue()` functions is that `sethue()` is independent of alpha opacity, so you can change the hue without changing the current opacity value (this is similar to Mathematica).

```@docs
sethue
setcolor
randomhue
randomcolor
```

## Styles

The `set-` functions control the width, end shapes, join behavior and dash pattern:

```@example
using Luxor, Colors # hide
Drawing(400, 250, "../examples/line-ends.png") # hide
background("white") # hide
origin() # hide
translate(-100, -60) # hide
fontsize(18) # hide
for l in 1:3
  sethue("black")
  setline(20)
  setlinecap(["butt", "square", "round"][l])
  textcentred(["butt", "square", "round"][l], 80l, 80)
  setlinejoin(["round", "miter", "bevel"][l])
  textcentred(["round", "miter", "bevel"][l], 80l, 120)
  poly(ngon(Point(80l, 0), 20, 3, 0, vertices=true), :strokepreserve, close=false)
  sethue("white")
  setline(1)
  stroke()
end
finish() # hide
```

![](examples/line-ends.png)

```@example
using Luxor, Colors # hide
Drawing(400, 250, "../examples/dashes.png") # hide
background("white") # hide
origin() # hide
fontsize(14) # hide
sethue("black") # hide
setline(12)
patterns = "solid", "dotted", "dot", "dotdashed", "longdashed", "shortdashed", "dash", "dashed", "dotdotdashed", "dotdotdotdashed"
tiles =  Tiler(400, 250, 10, 1, margin=10)
for (pos, n) in tiles
  setdash(patterns[n])
  textright(patterns[n], pos.x - 20, pos.y + 4)
  line(pos, Point(pos.x + 250, pos.y), :stroke)
end
finish() # hide
```
![](examples/dashes.png)

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

### Shapes

### Regular polygons ("ngons")

You can make regular polygons — from triangles, pentagons, hexagons, septagons, heptagons, octagons, nonagons, decagons, and on-and-on-agons — with `ngon()`.

![n-gons](examples/n-gon.png)

```julia
using Luxor, Colors
Drawing(1200, 1400)

origin()
cols = diverging_palette(60, 120, 20) # hue 60 to hue 120
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
```
### Polygons

A polygon is an array of Points. Use `poly()` to add them, or `randompointarray()` to create a random list of Points.

Polygons can contain holes. The `reversepath` keyword changes the direction of the polygon. The following piece of code uses `ngon()` to make two polygons, the second forming a hole in the first, to make a hexagonal bolt shape:

```@example
using Luxor, Colors # hide
Drawing(400, 250, "../examples/holes.png") # hide
background("white") # hide
origin() # hide
sethue("orchid4") # hide
ngon(0, 0, 60, 6, 0, :path)
newsubpath()
ngon(0, 0, 40, 6, 0, :path, reversepath=true)
fillstroke()
finish() # hide
```
![](examples/holes.png)

The `prettypoly()` function can place graphics at each vertex of a polygon. After the polygon action, the `vertex_action` is evaluated at each vertex. For example, to mark each vertex of a polygon with a randomly-colored circle:

```@example
using Luxor, Colors
Drawing(400, 250, "../examples/prettypoly.png") # hide
background("white") # hide
origin() # hide
sethue("steelblue4") # hide
setline(4)
poly1 = ngon(0, 0, 100, 6, 0, vertices=true)
prettypoly(poly1, :stroke, :(
  randomhue();
  scale(0.5, 0.5);
  circle(0, 0, 15, :stroke)
  ),
close=true)
finish() # hide
```

![](examples/prettypoly.png)

```@docs
prettypoly
```

Polygons can be simplified using the Douglas-Peucker algorithm (non-recursive version), via `simplify()`.

```@example
using Luxor, Colors # hide
Drawing(600, 500, "../examples/simplify.png") # hide
background("white") # hide
origin() # hide
sethue("black") # hide
setline(1) # hide
fontsize(20) # hide
translate(0, -120) # hide
sincurve =  (Point(6x, 80sin(x)) for x in -5pi:pi/20:5pi)
prettypoly(collect(sincurve), :stroke, :(sethue("red"); circle(0, 0, 3, :fill)))
text(string("number of points: ", length(collect(sincurve))), 0, 100)
translate(0, 200)
simplercurve = simplify(collect(sincurve), 0.5)
prettypoly(simplercurve, :stroke, :(sethue("red"); circle(0, 0, 3, :fill)))
text(string("number of points: ", length(simplercurve)), 0, 100)
finish() # hide
```
![](examples/simplify.png)

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

The `isinside()` returns true if a point is inside a polygon.

```@docs
isinside
```

### Stars

Use `star()` to make a star.

```@example
using Luxor, Colors # hide
Drawing(400, 300, "../examples/stars.png") # hide
background("white") # hide
origin() # hide
tiles = Tiler(400, 300, 4, 6, margin=5)
for (pos, n) in tiles
  randomhue()
  star(pos, tiles.tilewidth/3, rand(3:8), 0.5, 0, :fill)
end
finish() # hide
```

![stars](examples/stars.png)

```@docs
star
```

## Text and fonts

### Placing text

Use `text()`, `textcentred()`, and `textright()` to place text. `textpath()` converts the text into  a graphic path suitable for further manipulations.

```@docs
text
textcentred
textright
textpath
```

### Fonts

Use `fontface(fontname)` to choose a font, and `fontsize(n)` to set font size in points.

The `textextents(str)` function gets an array of dimensions of the string `str`, given the current font.

```@example
using Luxor, Colors # hide
Drawing(400, 300, "../examples/stars.png") # hide
background("white") # hide
origin() # hide
tiles = Tiler(400, 300, 4, 4, margin=5)
for (pos, n) in tiles
  randomhue()
  star(pos, tiles.tilewidth/3, rand(3:8), 0.5, 0, :fill)
end
finish() # hide
```

```@docs
fontface
fontsize
textextents
```

### Text on a curve

Use `textcurve(str)` to draw a string `str` on a circular arc or spiral.

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

You can use newly-created text paths as a clipping region - here the text paths are 'filled' with names of randomly chosen Julia functions:

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

# Transforms and matrices

For basic transformations of the drawing space, use `scale(sx, sy)`, `rotate(a)`, and `translate(tx, ty)`.

```@docs
scale
rotate
translate
```

The current matrix is a six element array, perhaps like this:

```
[1, 0, 0, 1, 0, 0]
```

`getmatrix()` gets the current matrix, `setmatrix(a)` sets the matrix to array `a`, and  `transform(a)` transforms the current matrix by 'multiplying' it with matrix `a`.

```@docs
getmatrix
setmatrix
transform
```

# Clipping

Use `clip()` to turn the current path into a clipping region, masking any graphics outside the path. `clippreserve()` keeps the current path, but also uses it as a clipping region. `clipreset()` resets it. `:clip` is also an action for drawing functions like `circle()`.

```@docs
clip
clippreserve
clipreset
```

This example loads a file containing a function that draws the Julia logo. It can create paths but doesn't necessarily apply an action to them; they can therefore be used as a mask for clipping subsequent graphics, which in this example are mainly randomly-colored circles:

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

# Images

There is some limited support for placing PNG images on the drawing. First, load a PNG image using `readpng(filename)`.

```@docs
readpng
```

Then use `placeimage()` to place a loaded PNG image by its top left corner at point `x/y` or `pt`.

```@docs
placeimage
```

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

You can clip images. The following script repeatedly places an image using a circle to define a clipping path:

!["Images"](examples/test-image.png)

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

# Turtle graphics

Some simple "turtle graphics" functions are included. Functions to control the turtle begin with a capital letter: Forward, Turn, Circle, Orientation, Rectangle, Pendown, Penup, Pencolor, Penwidth, and Reposition.

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

# More examples

A good place to look for examples (sometimes not very exciting or well-written examples, I'll admit), is in the `Luxor/test` directory.

!["tiled images"](examples/tiled-images.png)

## Sierpinski triangle

The main type is the Point, an immutable composite type containing `x` and `y` fields.

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
    cols = distinguishable_colors(depth + 1)
    Drawing(400, 400, "/tmp/sierpinski.svg")
    origin()
    setopacity(0.5)
    counter = 0
    my_points = [Point(-100, -50), Point(0, 100), Point(100.0, -50.0)]
    sierpinski(my_points, depth)
    println("drew $counter triangles")
end

finish()
preview()

# drew 9841 triangles
# elapsed time: 1.738649452 seconds (118966484 bytes allocated, 2.20% gc time)
```

## Luxor logo

A simple of example of clipping. The circle of radius 90 units sets a clipping
mask or region, and subsequent curves are clipped by that circle, until the
`clipreset()`  function clears the clipping mask.

![logo](examples/luxor-logo.png)

```
using Luxor, Colors, ColorSchemes

width = 300  # pts
height = 300 # pts
Drawing(width, height, "/tmp/luxor-logo.png")

function spiral(colscheme)
  circle(0, 0, 90, :clip)
  for theta in 0:pi/6:2pi-pi/6
    sethue(colorscheme(colscheme, rescale(theta, 0, 2pi, 0, 1)))
    gsave()
    rotate(theta)
    move(5,0)
    curve(Point(60, 70), Point(80, -70), Point(120, 70))
    closepath()
    fill()
    grestore()
  end
  clipreset()
end

origin()
background("white")
scale(1.3, 1.3)
colscheme = loadcolorscheme("solarcolors")
spiral(colscheme)
finish()
preview()
```

# Index

```@index
```
