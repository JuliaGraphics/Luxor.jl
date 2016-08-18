
<a id='Luxor-1'></a>

## Luxor


Luxor is the lightest dusting of syntactic sugar on Julia's Cairo graphics package (which should also be installed). It provides some basic vector drawing commands, and a few utilities for working with polygons, clipping masks, PNG images, and turtle graphics.


![](examples/tiled-images.png)


The idea of Luxor is that it's slightly easier to use than [Cairo.jl](https://github.com/JuliaLang/Cairo.jl), with shorter names, fewer underscores, default contexts, and simplified functions. It's for when you just want to draw something without too much ceremony. If you've ever hacked on a PostScript file, you should feel right at home (only without the reverse Polish notation, obviously).


For a much more powerful graphics environment, try [Compose.jl](http://composejl.org). Also worth looking at is Andrew Cooke's [Drawing.jl](https://github.com/andrewcooke/Drawing.jl) package.


[Colors.jl](https://github.com/JuliaGraphics/Colors.jl) provides excellent color definitions and is also required.


I've only tried this on MacOS X. It will need some changes to work on Windows (but I can't test it).


<a id='Current-status-1'></a>

### Current status


It's been updated for Julia version 0.5 and for the new Colors.jl. SVG rendering currently seems unreliable — text placement generates segmentation faults.


<a id='Installation-and-basic-usage-1'></a>

### Installation and basic usage


To install:


```
Pkg.clone("https://github.com/cormullion/Luxor.jl")
```


and to use:


```
using Luxor
```


<a id='The-basic-"Hello-World"-1'></a>

#### The basic "Hello World"


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


`text()` places text at 0/0 if you don't specify otherwise.


`finish()` completes the drawing and saves the image in the file. `preview()` tries to open the saved file using some other application (eg on MacOS X, Preview).


<a id='A-slightly-more-interesting-image-1'></a>

#### A slightly more interesting image


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
    preview() # on Mac OS X, opens in Preview
```


<a id='Types-1'></a>

#### Types


The two main defined types are the `Point` and the `Drawing`.


The Point type holds two coordinates, the x and y:


```
`Point(12.0, 13.0)`
```


<a id='Drawings-and-files-1'></a>

#### Drawings and files


To create a drawing, and optionally specify the file name and type, and dimensions, use the `Drawing` function.

<a id='Luxor.Drawing' href='#Luxor.Drawing'>#</a>
**`Luxor.Drawing`** &mdash; *Type*.



Create a new drawing.

  * `Drawing()`

create a drawing, defaulting to PNG format, default filename "/tmp/luxor-drawing.png", default size 800 pixels square

  * `Drawing(300,300)`

create a drawing 300 by 300 pixels, defaulting to PNG format, default filename "/tmp/luxor-drawing.png",

  * `Drawing(300,300, "/tmp/my-drawing.pdf")`

create a PDF drawing in the file "/tmp/my-drawing.pdf", 300 by 300 pixels

  * `Drawing(800,800, "/tmp/my-drawing.svg")`

create an SVG drawing in the file "/tmp/my-drawing.svg", 800 by 800 pixels

  * `Drawing(800,800, "/tmp/my-drawing.eps")`

create an EPS drawing in the file "/tmp/my-drawing.eps", 800 by 800 pixels

  * `Drawing("A4")`

create the drawing in ISO A4 size. Other sizes available are:  "A0", "A1", "A2", "A3", "A4", "A5", "A6", "Letter", "Legal", "A", "B", "C", "D", "E". Append "landscape" to get the landscape version.

  * `Drawing("A4landscape")`

create the drawing A4 landscape size.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L108-L138' class='documenter-source'>source</a><br>


To finish a drawing and close the file, use `finish()`, and, to launch an external application to view it, use `preview()`.

<a id='Luxor.finish' href='#Luxor.finish'>#</a>
**`Luxor.finish`** &mdash; *Function*.



```
finish()
```

Finish drawing, and close the file. The filename is still available in `currentdrawing.filename`, and you may be able to open it using `preview()`.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L149-L153' class='documenter-source'>source</a><br>

<a id='Luxor.preview' href='#Luxor.preview'>#</a>
**`Luxor.preview`** &mdash; *Function*.



```
preview()
```

On macOS, opens the file, which probably uses the default app, Preview.app On Unix, open the file with xdg-open. On Windows, pass the filename to the shell.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L163-L169' class='documenter-source'>source</a><br>


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


<a id='Axes-and-backgrounds-1'></a>

#### Axes and backgrounds


The origin (0/0) is at the top left, x axis runs left to right, y axis runs top to bottom The `origin()` function moves the c0/0 point. The `axes()` function draws a couple of lines to indicate the current axes. `background()` fills the entire image with a color.

<a id='Luxor.background' href='#Luxor.background'>#</a>
**`Luxor.background`** &mdash; *Function*.



```
background(color)
```

Fill the canvas with color.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L221-L226' class='documenter-source'>source</a><br>

<a id='Luxor.axes' href='#Luxor.axes'>#</a>
**`Luxor.axes`** &mdash; *Function*.



Draw two axes lines centered at 0/0.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L201-L203' class='documenter-source'>source</a><br>

<a id='Luxor.origin' href='#Luxor.origin'>#</a>
**`Luxor.origin`** &mdash; *Function*.



```
origin()
```

Set the 0/0 origin at the center of the drawing (otherwise it will stay at the top left corner).


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L180-L184' class='documenter-source'>source</a><br>


<a id='Basic-drawing-1'></a>

#### Basic drawing


The underlying Cairo drawing model is similar to PostScript: paths can be filled and/or stroked, using the current graphics state, which specifies colors, line thicknesses and patterns, and opacity.


Many drawing functions have an *action* argument. This can be `:nothing`, `:fill`, `:stroke`, `:fillstroke`, `:fillpreserve`, `:strokepreserve`, `:clip`. The default is `:nothing`.


Positions are usually specified either by x and y coordinates or a `Point(x, y)`.


<a id='Simple-shapes-1'></a>

##### Simple shapes

<a id='Luxor.circle' href='#Luxor.circle'>#</a>
**`Luxor.circle`** &mdash; *Function*.



Draw a circle centred at `x`/`y`.

```
circle(x, y, r, action)
```

`action` is one of the actions applied by `do_action`.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L356-L362' class='documenter-source'>source</a><br>


Draw a circle centred at `pt`.

```
circle(pt, r, action)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L371-L376' class='documenter-source'>source</a><br>


  * `arc(xc, yc, radius, angle1, angle2, action)` add arc to current path centered at `xc/yc` starting at `angle1` and ending at `angle2` drawing arc clockwise

<a id='Luxor.arc' href='#Luxor.arc'>#</a>
**`Luxor.arc`** &mdash; *Function*.



Add an arc to the current path from `angle1` to `angle2` going clockwise.

```
arc(xc, yc, radius, angle1, angle2, action=:nothing)
```

Angles are defined relative to the x-axis, positive clockwise.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L379-L385' class='documenter-source'>source</a><br>


  * `carc(xc, yc, radius, angle1, angle2, action)` add arc to current path centered at `xc/yc` starting at `angle1` and ending at `angle2`, drawing arc counterclockwise.

<a id='Luxor.carc' href='#Luxor.carc'>#</a>
**`Luxor.carc`** &mdash; *Function*.



Add an arc to the current path from `angle1` to `angle2` going counterclockwise.

```
carc(xc, yc, radius, angle1, angle2, action=:nothing)
```

Angles are defined relative to the x-axis, positive clockwise.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L392-L398' class='documenter-source'>source</a><br>


Sectors are drawn relative to the current 0/0 point.

<a id='Luxor.sector' href='#Luxor.sector'>#</a>
**`Luxor.sector`** &mdash; *Function*.



```
sector(innerradius, outerradius, startangle, endangle, action=:none)
```

Draw a track/sector based at 0/0.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L446-L450' class='documenter-source'>source</a><br>


Angles are measured from the positive x-axis to the positive y-axis (which points 'down' the page or canvas) in radians, clockwise.


<a id='Rectangles-and-boxes-1'></a>

##### Rectangles and boxes

<a id='Luxor.rect' href='#Luxor.rect'>#</a>
**`Luxor.rect`** &mdash; *Function*.



Create a rectangle with one corner at (`xmin`/`ymin`) with width `w` and height `h` and do an action.

```
rect(xmin, ymin, w, h, action)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L404-L408' class='documenter-source'>source</a><br>


Create a rectangle with one corner at `cornerpoint` with width `w` and height `h` and do an action.

```
rect(cornerpoint, w, h, action)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L418-L422' class='documenter-source'>source</a><br>

<a id='Luxor.box' href='#Luxor.box'>#</a>
**`Luxor.box`** &mdash; *Function*.



Create a rectangle between two points and do an action.

```
box(cornerpoint1, cornerpoint2, action=:nothing)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L427-L432' class='documenter-source'>source</a><br>


Create a rectangle between the first two points of an array of Points.

```
box(points::Array, action=:nothing)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L437-L441' class='documenter-source'>source</a><br>


<a id='Lines-and-arcs-1'></a>

##### Lines and arcs


There is a 'current position' which you can set with `move()`, and use implicitly in commands like `line()` and `text()`.

<a id='Luxor.move' href='#Luxor.move'>#</a>
**`Luxor.move`** &mdash; *Function*.



Move to a point.

```
- `move(x, y)`
- `move(pt)`
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L513-L518' class='documenter-source'>source</a><br>

<a id='Luxor.rmove' href='#Luxor.rmove'>#</a>
**`Luxor.rmove`** &mdash; *Function*.



Move by an amount from the current point. Move relative to current position by `x` and `y`:

```
- `rmove(x, y)`
```

Move relative to current position by the `pt`'s x and y:

```
- `rmove(pt)`
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L522-L530' class='documenter-source'>source</a><br>

<a id='Luxor.line' href='#Luxor.line'>#</a>
**`Luxor.line`** &mdash; *Function*.



Create a line from the current position to the `x/y` position and optionally apply an action:

```
- `line(x, y)`

- `line(x, y, :action)`

- `line(pt)`
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L534-L543' class='documenter-source'>source</a><br>


Make a line between two points, `pt1` and `pt2`.

```
line(pt1::Point, pt2::Point, action=:nothing)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L547-L552' class='documenter-source'>source</a><br>

<a id='Luxor.rline' href='#Luxor.rline'>#</a>
**`Luxor.rline`** &mdash; *Function*.



Create a line relative to the current position to the `x/y` position and optionally apply an action:

```
- `rline(x, y)`

- `rline(x, y, :action)`

- `rline(pt)`
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L559-L567' class='documenter-source'>source</a><br>

<a id='Luxor.curve' href='#Luxor.curve'>#</a>
**`Luxor.curve`** &mdash; *Function*.



Create a cubic Bézier spline curve.

```
- `curve(x1, y1, x2, y2, x3, y3)`

- `curve(p1, p2, p3)`
```

The spline starts at the current position, finishing at `x3/y3` (`p3`), following two control points `x1/y1` (`p1`) and `x2/y2` (`p2`)


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L572-L581' class='documenter-source'>source</a><br>


<a id='Paths-1'></a>

#### Paths


A path is a group of points. A path can have subpaths (which can form holes).

<a id='Luxor.newpath' href='#Luxor.newpath'>#</a>
**`Luxor.newpath`** &mdash; *Function*.



```
newpath()
```

This is Cairo's `new_path()` function.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L241-L245' class='documenter-source'>source</a><br>

<a id='Luxor.newsubpath' href='#Luxor.newsubpath'>#</a>
**`Luxor.newsubpath`** &mdash; *Function*.



```
newsubpath()
```

This is Cairo's `new_sub_path()` function. It can be used, for example, to make holes in shapes:


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L248-L252' class='documenter-source'>source</a><br>

<a id='Luxor.closepath' href='#Luxor.closepath'>#</a>
**`Luxor.closepath`** &mdash; *Function*.



```
closepath()
```

This is Cairo's `close_path()` function.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L255-L259' class='documenter-source'>source</a><br>


  * `getpath()` get the current Cairo path as an array of element types and points
  * `getpathflat()` get the current path as an array of type/points with curves flattened to lines


<a id='Color-and-opacity-1'></a>

#### Color and opacity


For color definitions and conversions, use Colors.jl.


The difference between the `setcolor()` and `sethue()` functions is that `sethue()` is independent of alpha opacity, so you can change the hue without changing the current opacity value (this is similar to Mathematica).


<a id='Styles-1'></a>

#### Styles


  * `setline(n)` set line width
  * `setlinecap(str)` set line ends to "butt", "round", or "square"
  * `setlinejoin(str)` set line joins to "miter", "round", or "bevel"
  * `setdash(str)` set line dashing to "solid", "dotted", "dot", "dotdashed", "longdashed", "shortdashed", "dash", "dashed", "dotdotdashed", or "dotdotdotdashed"
  * `fillstroke()` fill and stroke the current path
  * `stroke()` stroke the current path
  * `fill()` fill the current path
  * `strokepreserve()` stroke the path but keep it current
  * `fillpreserve()` fill the path but keep it current


`gsave()` and `grestore()` should always be balanced in pairs. `gsave()` saves a copy of the current graphics settings (current axis rotation, position, scale, line and text settings, and so on). When the next `grestore()` is called, all changes you've made to the graphics settings will be discarded, and they'll return to how they were when you used `gsave()`.


  * `gsave()` save the graphics state
  * `grestore()` restore the graphics state


<a id='Polygons-and-others-1'></a>

#### Polygons and others


<a id='Regular-polygons-ngons-1'></a>

##### Regular polygons - ngons


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


You can make regular polygons — from triangles, pentagons, hexagons, septagons, heptagons, octagons, nonagons, decagons, and on-and-on-agons — with:


  * `ngon(xc, yc, radius, sides, orientation, action=:nothing)` draws a `sides`-sided polygon
  * `ngon(point, radius, sides, orientation, action=:nothing)`  draws a `sides`-sided polygon


These ngons are closed by default.


  * `ngon(x, y, radius, sides, orientation, action; close=true, reversepath=false)`
  * `ngon(point, radius, sides, orientation, action; close=true, reversepath=false)`


If you just want the points, use `ngonv`, which returns an array of points instead:


  * `ngonv(xc, yc, radius, sides, orientation)`
  * `ngonv(point, radius, sides, orientation)`


Compare:


```julia
ngonv(0, 0, 4, 4, 0) # returns the polygon's points

4-element Array{Luxor.Point,1}:
Luxor.Point(2.4492935982947064e-16,4.0)
Luxor.Point(-4.0,4.898587196589413e-16)
Luxor.Point(-7.347880794884119e-16,-4.0)
Luxor.Point(4.0,-9.797174393178826e-16)

ngon(0, 0, 4, 4, 0, :close) # draws a polygon
```


<a id='Polygons-1'></a>

##### Polygons


A polygon is an array of Points.


  * `poly(list::Array, action = :nothing; close=false, reversepath=false)`:


```
    `poly(randompointarray(0, 0, 200, 200, 85), :stroke)`
```


  * `randompoint(lowx, lowy, highx, highy)` returns a random point
  * `randompointarray(lowx, lowy, highx, highy, n)` returns an array of random points. For example:


```
    `poly(randompointarray(0,0,200,200, 85), :stroke)`
```


Polygons can contain holes. The `reversepath` keyword changes the direction of the polygon. This draws an hexagonal bolt shape:


```
    ngon(0, 0, 60, 6, 0, :path)
    newsubpath()
    ngon(0, 0, 40, 6, 0, :path, reversepath=true)
    fillstroke()
```


Polygons can be simplified using the Douglas-Peucker algorithm (non-recursive version):


  * `simplify(polygon, tolerance)` to delete points from an array of Points within the tolerance provided
  * `isinside(point, polygon)` returns true if the point is inside the polygon


There are some experimental polygon functions. These don't work well for polygons that aren't simple or where the sides intersect each other.


  * `polysplit(p, point1, point2)`


returns two polygons if a line from `point1` to `point2` divides the polygon.


  * `polysortbydistance(p, startingpoint)`


returns the points sorted by finding the nearest point to the start point, then the nearest point to that, and so on.


  * `polysortbyangle(p, startingpoint)`


returns the points sorted by the angle that each point makes with a starting point.


  * `polycentroid(p)`


returns `Point(centerx, centery)


  * `polybbox(p)`


returns `[Point(lowx, lowy), Point(highx, highy)]`, opposite corners of a bounding box.


The `prettypoly()` function can place graphics at each vertex of a polygon. After the poly action, the `vertex_action` is evaluated at each vertex.


  * prettypoly(`pointlist::Array, action = :nothing, vertex_action::Expr = :(); close=false, reversepath=false))`


For example, to mark each vertex of a polygon with a circle scaled to 0.1.


```
prettypoly(pl, :fill, :(
                        scale(0.1, 0.1);
                        circle(0, 0, 10, :fill)
                       ),
           close=false)
```


The `vertex_action` expression can't use definitions that are not in scope, eg you can't pass a variable in from the calling function and expect the polygon-drawing function to know about it.


<a id='Stars-1'></a>

##### Stars


![stars](examples/stars.png)


  * `starv()` makes a star, returning its vertices:


```
starv(xcenter, ycenter, radius, npoints, ratio=0.5, orientation=0, action=:nothing, close=true, reversepath=false)
```


  * `star()` draws a star:


```
star(xcenter, ycenter, radius, npoints, ratio=0.5, orientation=0, action=:nothing, close=true, reversepath=false)
```


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


<a id='Text-and-fonts-1'></a>

#### Text and fonts


<a id='Placing-text-1'></a>

##### Placing text


  * `text(t, x, y)` draw string `t` at `x`/`y`, or at `0/0` if `x`/`y` omitted
  * `text(t, pt)` draw string `t` at `pt`
  * `textcentred(t, x, y)` draw string `t` centred at `x`/`y` or `0/0`
  * `textcentred(t, pt)`
  * `textpath(t)` makes the string `t` into a graphic path suitable for `fill()`, `stroke()`...
  * `textcurve(str, startangle, startradius, xcentre, ycentre)`
  * `textcurve(str, startangle, startradius, centerpt)`


<a id='Fonts-1'></a>

##### Fonts


  * `fontface(fontname)`


chooses font `fontname`


  * `fontsize(n)`


sets font size in points


  * `textextents(str)`


gets array of dimensions of the string `str`, given current font:


```
[xb, yb, width, height, xadvance, yadvance]
```


<a id='Text-on-a-curve-1'></a>

##### Text on a curve


Use `textcurve()` to draw a string `str` on an arc of radius `startradius` centered at `xcenter/ycenter` (or `centrept`) starting on angle `start_angle`, which is relative to the +ve x-axis.


You can change the letter spacing, and/or spiral in or out, using these optional keywords:


  * `spiral_ring_step = 0`,   step out or in by this amount
  * `letter_spacing = 0`,     tracking/space between chars, tighter is (-), looser is (+)
  * `spiral_in_out_shift = 0` + values go outwards, - values spiral inwards


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


<a id='Text-clipping-1'></a>

#### Text clipping


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


<a id='Transforms-and-matrices-1'></a>

#### Transforms and matrices


  * `scale(sx, sy)` scale by sx and sy
  * `rotate(a)` rotate clockwise (positive x-axis to positive/down y-axis) by `a` radians around current 0/0
  * `translate(tx, ty)` translate to `tx/ty` or `pt`
  * `translate(pt)`


The current matrix is a six number array, perhaps like this:


```
[1, 0, 0, 1, 0, 0]
```


  * `getmatrix()` gets the current matrix
  * `setmatrix(a)` sets the matrix to array `a`
  * `transform(a)` transform the current matrix by 'multiplying' it with matrix `a`. For example, to skew by 45 degrees in x and move by 20 in y direction:


```
`transform([1, 0, tand(45), 1, 0, 20])`
```


<a id='Clipping-1'></a>

#### Clipping


  * `clip()` turn the current path into a clipping region, masking any graphics outside the path
  * `clippreserve()` keep the current path, but also use it as a clipping region
  * `clipreset()`


<a id='Clipping-masks-1'></a>

##### Clipping masks


This example loads a file containing functions that draw the Julia logo. One of the functions creates paths but doesn't apply an action them; they can therefore be used as a mask for clipping subsequent graphics:


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
        julialogomask()                 # add paths for logo
        clip()                          # use paths for clipping
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


<a id='Images-1'></a>

#### Images


There is some limited support for placing PNG images on the drawing.


First, load a PNG image using `readpng(filename)`.

<a id='Luxor.readpng' href='#Luxor.readpng'>#</a>
**`Luxor.readpng`** &mdash; *Function*.



Read a PNG file into Cairo.

```
readpng(pathname)
```

This returns a Cairo.CairoSurface, suitable for placing on the current drawing with `placeimage()`. You can access its width and height properties.

```
image = readpng("/tmp/test-image.png")
w = image.width
h = image.height
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L1006-L1016' class='documenter-source'>source</a><br>


Use `placeimage()` to place a loaded PNG image by its top left corner at point `x/y` or `pt`.


```
    placeimage(img, x, y)
    placeimage(img, pt)
```


You can specify an alpha value:


```
    placeimage(image, x, y, alpha)
    placeimage(image, pt, alpha)
```

<a id='Luxor.placeimage' href='#Luxor.placeimage'>#</a>
**`Luxor.placeimage`** &mdash; *Function*.



Place a PNG image on the drawing.

```
placeimage(img, xpos, ypos)
```

Place an image previously loaded using `readpng()`.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L1025-L1031' class='documenter-source'>source</a><br>


Place a PNG image on the drawing using alpha transparency.

```
placeimage(img, xpos, ypos, 0.5) # alpha
```

Place an image previously loaded using `readpng()`.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L1038-L1044' class='documenter-source'>source</a><br>


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


<a id='Turtle-graphics-1'></a>

#### Turtle graphics


Some simple "turtle graphics" commands are included:


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


<a id='Examples:-1'></a>

#### Examples:


<a id='Sierpinski-triangle-1'></a>

##### Sierpinski triangle


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


<a id='List-of-API-functions-1'></a>

#### List of API functions

<a id='Base.fill-Tuple{}' href='#Base.fill-Tuple{}'>#</a>
**`Base.fill`** &mdash; *Method*.



Fill the current path with current settings. The current path is then cleared.

```
fill()
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L270-L275' class='documenter-source'>source</a><br>

<a id='Base.scale-Tuple{Any,Any}' href='#Base.scale-Tuple{Any,Any}'>#</a>
**`Base.scale`** &mdash; *Method*.



Scale in x and y

Example:

```
scale(0.2, 0.3)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L616-L623' class='documenter-source'>source</a><br>

<a id='Luxor.Circle-Tuple{Luxor.Turtle,Any}' href='#Luxor.Circle-Tuple{Luxor.Turtle,Any}'>#</a>
**`Luxor.Circle`** &mdash; *Method*.



Circle: draw a filled circle centred at the current position with the given radius.

```
Circle(t::Turtle, radius)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Turtle.jl#L94-L98' class='documenter-source'>source</a><br>

<a id='Luxor.Forward-Tuple{Luxor.Turtle,Any}' href='#Luxor.Forward-Tuple{Luxor.Turtle,Any}'>#</a>
**`Luxor.Forward`** &mdash; *Method*.



Forward: the turtle moves forward by `d` units. The stored position is updated.

```
Forward(t::Turtle, d)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Turtle.jl#L42-L46' class='documenter-source'>source</a><br>

<a id='Luxor.HueShift' href='#Luxor.HueShift'>#</a>
**`Luxor.HueShift`** &mdash; *Function*.



Shift the Hue of the turtle's pen forward by inc

```
HueShift(t::Turtle, inc = 1)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Turtle.jl#L145-L149' class='documenter-source'>source</a><br>

<a id='Luxor.Message-Tuple{Luxor.Turtle,Any}' href='#Luxor.Message-Tuple{Luxor.Turtle,Any}'>#</a>
**`Luxor.Message`** &mdash; *Method*.



Message: write some text at the current position.

```
Message(t::Turtle, txt)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Turtle.jl#L134-L138' class='documenter-source'>source</a><br>

<a id='Luxor.Orientation-Tuple{Luxor.Turtle,Any}' href='#Luxor.Orientation-Tuple{Luxor.Turtle,Any}'>#</a>
**`Luxor.Orientation`** &mdash; *Method*.



Orientation: set the turtle's orientation to `r` radians. See also `Turn`.

```
Orientation(t::Turtle, r)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Turtle.jl#L70-L74' class='documenter-source'>source</a><br>

<a id='Luxor.Pencolor-Tuple{Luxor.Turtle,Any,Any,Any}' href='#Luxor.Pencolor-Tuple{Luxor.Turtle,Any,Any,Any}'>#</a>
**`Luxor.Pencolor`** &mdash; *Method*.



Pencolor: Set the Red, Green, and Blue colors of the turtle:

```
Pencolor(t::Turtle, r, g, b)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Turtle.jl#L172-L176' class='documenter-source'>source</a><br>

<a id='Luxor.Pendown-Tuple{Luxor.Turtle}' href='#Luxor.Pendown-Tuple{Luxor.Turtle}'>#</a>
**`Luxor.Pendown`** &mdash; *Method*.



Pendown. Put that pen down and start drawing.

```
Pendown(t::Turtle)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Turtle.jl#L78-L82' class='documenter-source'>source</a><br>

<a id='Luxor.Penup-Tuple{Luxor.Turtle}' href='#Luxor.Penup-Tuple{Luxor.Turtle}'>#</a>
**`Luxor.Penup`** &mdash; *Method*.



Penup. Pick that pen up and stop drawing.

```
Penup(t::Turtle)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Turtle.jl#L86-L90' class='documenter-source'>source</a><br>

<a id='Luxor.Penwidth-Tuple{Luxor.Turtle,Any}' href='#Luxor.Penwidth-Tuple{Luxor.Turtle,Any}'>#</a>
**`Luxor.Penwidth`** &mdash; *Method*.



Penwidth: set the width of the line.

```
Penwidth(t::Turtle, w)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Turtle.jl#L192-L196' class='documenter-source'>source</a><br>

<a id='Luxor.Randomize_saturation-Tuple{Luxor.Turtle}' href='#Luxor.Randomize_saturation-Tuple{Luxor.Turtle}'>#</a>
**`Luxor.Randomize_saturation`** &mdash; *Method*.



Randomize saturation of the turtle's pen color

```
Randomize_saturation(t::Turtle)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Turtle.jl#L159-L163' class='documenter-source'>source</a><br>

<a id='Luxor.Rectangle-Tuple{Luxor.Turtle,Any,Any}' href='#Luxor.Rectangle-Tuple{Luxor.Turtle,Any,Any}'>#</a>
**`Luxor.Rectangle`** &mdash; *Method*.



Rectangle: draw a filled rectangle centred at the current position with the given radius.

```
Rectangle(t::Turtle, width, height)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Turtle.jl#L105-L110' class='documenter-source'>source</a><br>

<a id='Luxor.Reposition-Tuple{Luxor.Turtle,Any,Any}' href='#Luxor.Reposition-Tuple{Luxor.Turtle,Any,Any}'>#</a>
**`Luxor.Reposition`** &mdash; *Method*.



Reposition: pick the turtle up and place it at another position:

```
Reposition(t::Turtle, x, y)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Turtle.jl#L182-L186' class='documenter-source'>source</a><br>

<a id='Luxor.Turn-Tuple{Luxor.Turtle,Any}' href='#Luxor.Turn-Tuple{Luxor.Turtle,Any}'>#</a>
**`Luxor.Turn`** &mdash; *Method*.



Turn: increase the turtle's rotation by `r` radians. See also `Orientation`.

```
Turn(t::Turtle, r)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Turtle.jl#L62-L66' class='documenter-source'>source</a><br>

<a id='Luxor.arc' href='#Luxor.arc'>#</a>
**`Luxor.arc`** &mdash; *Function*.



Add an arc to the current path from `angle1` to `angle2` going clockwise.

```
arc(xc, yc, radius, angle1, angle2, action=:nothing)
```

Angles are defined relative to the x-axis, positive clockwise.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L379-L385' class='documenter-source'>source</a><br>

<a id='Luxor.axes-Tuple{}' href='#Luxor.axes-Tuple{}'>#</a>
**`Luxor.axes`** &mdash; *Method*.



Draw two axes lines centered at 0/0.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L201-L203' class='documenter-source'>source</a><br>

<a id='Luxor.background-Tuple{String}' href='#Luxor.background-Tuple{String}'>#</a>
**`Luxor.background`** &mdash; *Method*.



```
background(color)
```

Fill the canvas with color.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L221-L226' class='documenter-source'>source</a><br>

<a id='Luxor.box' href='#Luxor.box'>#</a>
**`Luxor.box`** &mdash; *Function*.



Create a rectangle between the first two points of an array of Points.

```
box(points::Array, action=:nothing)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L437-L441' class='documenter-source'>source</a><br>

<a id='Luxor.box' href='#Luxor.box'>#</a>
**`Luxor.box`** &mdash; *Function*.



Create a rectangle between two points and do an action.

```
box(cornerpoint1, cornerpoint2, action=:nothing)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L427-L432' class='documenter-source'>source</a><br>

<a id='Luxor.carc' href='#Luxor.carc'>#</a>
**`Luxor.carc`** &mdash; *Function*.



Add an arc to the current path from `angle1` to `angle2` going counterclockwise.

```
carc(xc, yc, radius, angle1, angle2, action=:nothing)
```

Angles are defined relative to the x-axis, positive clockwise.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L392-L398' class='documenter-source'>source</a><br>

<a id='Luxor.circle' href='#Luxor.circle'>#</a>
**`Luxor.circle`** &mdash; *Function*.



Draw a circle centred at `pt`.

```
circle(pt, r, action)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L371-L376' class='documenter-source'>source</a><br>

<a id='Luxor.circle' href='#Luxor.circle'>#</a>
**`Luxor.circle`** &mdash; *Function*.



Draw a circle centred at `x`/`y`.

```
circle(x, y, r, action)
```

`action` is one of the actions applied by `do_action`.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L356-L362' class='documenter-source'>source</a><br>

<a id='Luxor.clip-Tuple{}' href='#Luxor.clip-Tuple{}'>#</a>
**`Luxor.clip`** &mdash; *Method*.



Establish a new clip region by intersecting the current clip region with the current path and then clearing the current path.

```
clip()
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L335-L339' class='documenter-source'>source</a><br>

<a id='Luxor.clippreserve-Tuple{}' href='#Luxor.clippreserve-Tuple{}'>#</a>
**`Luxor.clippreserve`** &mdash; *Method*.



Establishes a new clip region by intersecting the current clip region with the current path, but keep the current path.

```
clippreserve()
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L342-L346' class='documenter-source'>source</a><br>

<a id='Luxor.clipreset-Tuple{}' href='#Luxor.clipreset-Tuple{}'>#</a>
**`Luxor.clipreset`** &mdash; *Method*.



Reset the clip region to the current drawing's extent.

```
clipreset()
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L349-L353' class='documenter-source'>source</a><br>

<a id='Luxor.closepath-Tuple{}' href='#Luxor.closepath-Tuple{}'>#</a>
**`Luxor.closepath`** &mdash; *Method*.



```
closepath()
```

This is Cairo's `close_path()` function.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L255-L259' class='documenter-source'>source</a><br>

<a id='Luxor.curve-Tuple{Any,Any,Any,Any,Any,Any}' href='#Luxor.curve-Tuple{Any,Any,Any,Any,Any,Any}'>#</a>
**`Luxor.curve`** &mdash; *Method*.



Create a cubic Bézier spline curve.

```
- `curve(x1, y1, x2, y2, x3, y3)`

- `curve(p1, p2, p3)`
```

The spline starts at the current position, finishing at `x3/y3` (`p3`), following two control points `x1/y1` (`p1`) and `x2/y2` (`p2`)


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L572-L581' class='documenter-source'>source</a><br>

<a id='Luxor.do_action-Tuple{Any}' href='#Luxor.do_action-Tuple{Any}'>#</a>
**`Luxor.do_action`** &mdash; *Method*.



```
do_action(action)
```

This is usually called by other graphics functions, actions for graphics commands include :fill, :stroke, :clip, :fillstroke, :fillpreserve, :strokepreserve and :path.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L310-L315' class='documenter-source'>source</a><br>

<a id='Luxor.fillpreserve-Tuple{}' href='#Luxor.fillpreserve-Tuple{}'>#</a>
**`Luxor.fillpreserve`** &mdash; *Method*.



Fill the current path with current settings, but then keep the path current.

```
fillpreserve()
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L294-L299' class='documenter-source'>source</a><br>

<a id='Luxor.fillstroke-Tuple{}' href='#Luxor.fillstroke-Tuple{}'>#</a>
**`Luxor.fillstroke`** &mdash; *Method*.



Fill and stroke the current path.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L302-L304' class='documenter-source'>source</a><br>

<a id='Luxor.finish-Tuple{}' href='#Luxor.finish-Tuple{}'>#</a>
**`Luxor.finish`** &mdash; *Method*.



```
finish()
```

Finish drawing, and close the file. The filename is still available in `currentdrawing.filename`, and you may be able to open it using `preview()`.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L149-L153' class='documenter-source'>source</a><br>

<a id='Luxor.getmatrix-Tuple{}' href='#Luxor.getmatrix-Tuple{}'>#</a>
**`Luxor.getmatrix`** &mdash; *Method*.



Get the current matrix.

```
getmatrix()
```

Return current Cairo matrix as an array.

In Cairo and Luxor, a matrix is an array of 6 float64 numbers:

  * xx component of the affine transformation
  * yx component of the affine transformation
  * xy component of the affine transformation
  * yy component of the affine transformation
  * x0 translation component of the affine transformation
  * y0 translation component of the affine transformation


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L942-L957' class='documenter-source'>source</a><br>

<a id='Luxor.getpath-Tuple{}' href='#Luxor.getpath-Tuple{}'>#</a>
**`Luxor.getpath`** &mdash; *Method*.



Get the current path (thanks Andreas Lobinger!)

Returns a CairoPath which is an array of .element_type and .points.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L649-L653' class='documenter-source'>source</a><br>

<a id='Luxor.getpathflat-Tuple{}' href='#Luxor.getpathflat-Tuple{}'>#</a>
**`Luxor.getpathflat`** &mdash; *Method*.



Get the current path but flattened.

Returns a CairoPath which is an array of .element_type and .points.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L656-L660' class='documenter-source'>source</a><br>

<a id='Luxor.grestore-Tuple{}' href='#Luxor.grestore-Tuple{}'>#</a>
**`Luxor.grestore`** &mdash; *Method*.



Replace the current graphics state with the one on top of the stack.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L601-L603' class='documenter-source'>source</a><br>

<a id='Luxor.gsave-Tuple{}' href='#Luxor.gsave-Tuple{}'>#</a>
**`Luxor.gsave`** &mdash; *Method*.



Save the current graphics state on the stack.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L590-L592' class='documenter-source'>source</a><br>

<a id='Luxor.intersection-Tuple{Any,Any,Any,Any}' href='#Luxor.intersection-Tuple{Any,Any,Any,Any}'>#</a>
**`Luxor.intersection`** &mdash; *Method*.



Find intersection of two lines `p1`-`p2` and `p3`-`p4`

```
intersection(p1, p2, p3, p4)
```

returns (false, 0) or (true, Point)


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/polygons.jl#L61-L67' class='documenter-source'>source</a><br>

<a id='Luxor.isinside-Tuple{Luxor.Point,Array}' href='#Luxor.isinside-Tuple{Luxor.Point,Array}'>#</a>
**`Luxor.isinside`** &mdash; *Method*.



Is a point `p` inside a polygon `pl`?

```
isinside(p, pl)
```

Returns true or false.

This is an implementation of Hormann-Agathos (2001) Point in Polygon algorithm


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/polygons.jl#L333-L341' class='documenter-source'>source</a><br>

<a id='Luxor.line' href='#Luxor.line'>#</a>
**`Luxor.line`** &mdash; *Function*.



Make a line between two points, `pt1` and `pt2`.

```
line(pt1::Point, pt2::Point, action=:nothing)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L547-L552' class='documenter-source'>source</a><br>

<a id='Luxor.line-Tuple{Any,Any}' href='#Luxor.line-Tuple{Any,Any}'>#</a>
**`Luxor.line`** &mdash; *Method*.



Create a line from the current position to the `x/y` position and optionally apply an action:

```
- `line(x, y)`

- `line(x, y, :action)`

- `line(pt)`
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L534-L543' class='documenter-source'>source</a><br>

<a id='Luxor.midpoint-Tuple{Array}' href='#Luxor.midpoint-Tuple{Array}'>#</a>
**`Luxor.midpoint`** &mdash; *Method*.



Find midpoint between the first two elements of an array of points.

```
midpoint(p1, p2)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/polygons.jl#L53-L57' class='documenter-source'>source</a><br>

<a id='Luxor.midpoint-Tuple{Luxor.Point,Luxor.Point}' href='#Luxor.midpoint-Tuple{Luxor.Point,Luxor.Point}'>#</a>
**`Luxor.midpoint`** &mdash; *Method*.



Find midpoint between two points.

```
midpoint(p1, p2)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/polygons.jl#L45-L49' class='documenter-source'>source</a><br>

<a id='Luxor.move-Tuple{Any,Any}' href='#Luxor.move-Tuple{Any,Any}'>#</a>
**`Luxor.move`** &mdash; *Method*.



Move to a point.

```
- `move(x, y)`
- `move(pt)`
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L513-L518' class='documenter-source'>source</a><br>

<a id='Luxor.newpath-Tuple{}' href='#Luxor.newpath-Tuple{}'>#</a>
**`Luxor.newpath`** &mdash; *Method*.



```
newpath()
```

This is Cairo's `new_path()` function.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L241-L245' class='documenter-source'>source</a><br>

<a id='Luxor.newsubpath-Tuple{}' href='#Luxor.newsubpath-Tuple{}'>#</a>
**`Luxor.newsubpath`** &mdash; *Method*.



```
newsubpath()
```

This is Cairo's `new_sub_path()` function. It can be used, for example, to make holes in shapes:


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L248-L252' class='documenter-source'>source</a><br>

<a id='Luxor.ngon' href='#Luxor.ngon'>#</a>
**`Luxor.ngon`** &mdash; *Function*.



Draw a regular polygon centred at `p`:

```
ngon(centerpos, radius, sides, orientation, action; close=true, reversepath=false)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/polygons.jl#L278-L283' class='documenter-source'>source</a><br>

<a id='Luxor.ngon' href='#Luxor.ngon'>#</a>
**`Luxor.ngon`** &mdash; *Function*.



Draw a regular polygon centred at `x`, `y`:

```
ngon(x, y,      radius, sides, orientation, action; close=true, reversepath=false)
```

Use `ngonv()` to return the points of a polygon.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/polygons.jl#L267-L273' class='documenter-source'>source</a><br>

<a id='Luxor.ngonv' href='#Luxor.ngonv'>#</a>
**`Luxor.ngonv`** &mdash; *Function*.



Return the vertices of a regular polygon centred at `x`, `y`:

```
ngonv(x, y, radius, sides, orientation)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/polygons.jl#L248-L252' class='documenter-source'>source</a><br>

<a id='Luxor.ngonv' href='#Luxor.ngonv'>#</a>
**`Luxor.ngonv`** &mdash; *Function*.



Return the vertices of a regular polygon centred at `p`:

```
ngonv(p, radius, sides, orientation)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/polygons.jl#L259-L263' class='documenter-source'>source</a><br>

<a id='Luxor.origin-Tuple{}' href='#Luxor.origin-Tuple{}'>#</a>
**`Luxor.origin`** &mdash; *Method*.



```
origin()
```

Set the 0/0 origin at the center of the drawing (otherwise it will stay at the top left corner).


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L180-L184' class='documenter-source'>source</a><br>

<a id='Luxor.paint-Tuple{}' href='#Luxor.paint-Tuple{}'>#</a>
**`Luxor.paint`** &mdash; *Method*.



Paint the current clip region with the current settings.

```
paint()
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L278-L283' class='documenter-source'>source</a><br>

<a id='Luxor.placeimage-Tuple{Cairo.CairoSurface,Any,Any,Any}' href='#Luxor.placeimage-Tuple{Cairo.CairoSurface,Any,Any,Any}'>#</a>
**`Luxor.placeimage`** &mdash; *Method*.



Place a PNG image on the drawing using alpha transparency.

```
placeimage(img, xpos, ypos, 0.5) # alpha
```

Place an image previously loaded using `readpng()`.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L1038-L1044' class='documenter-source'>source</a><br>

<a id='Luxor.placeimage-Tuple{Cairo.CairoSurface,Any,Any}' href='#Luxor.placeimage-Tuple{Cairo.CairoSurface,Any,Any}'>#</a>
**`Luxor.placeimage`** &mdash; *Method*.



Place a PNG image on the drawing.

```
placeimage(img, xpos, ypos)
```

Place an image previously loaded using `readpng()`.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L1025-L1031' class='documenter-source'>source</a><br>

<a id='Luxor.poly' href='#Luxor.poly'>#</a>
**`Luxor.poly`** &mdash; *Function*.



Draw a polygon.

```
poly(pointlist::Array, action = :nothing; close=false, reversepath=false)
```

A polygon is an Array of Points

By default doesn't close or fill, to allow for clipping.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/polygons.jl#L3-L11' class='documenter-source'>source</a><br>

<a id='Luxor.polybbox-Tuple{Array}' href='#Luxor.polybbox-Tuple{Array}'>#</a>
**`Luxor.polybbox`** &mdash; *Method*.



Find the bounding box of a polygon (array of points).

```
polybbox(pointlist::Array)
```

Return the two opposite corners (suitable for `box`, for example).


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/polygons.jl#L87-L93' class='documenter-source'>source</a><br>

<a id='Luxor.polycentroid-Tuple{Any}' href='#Luxor.polycentroid-Tuple{Any}'>#</a>
**`Luxor.polycentroid`** &mdash; *Method*.



Find the centroid of simple polygon.

```
polycentroid(pointlist)
```

Only works for simple (non-intersecting) polygons. Come on, this isn't a CAD system...! :)

Returns a point.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/polygons.jl#L107-L115' class='documenter-source'>source</a><br>

<a id='Luxor.polysortbyangle' href='#Luxor.polysortbyangle'>#</a>
**`Luxor.polysortbyangle`** &mdash; *Function*.



Sort the points of a polygon into order. Points are sorted according to the angle they make with a specified point.

```
polysortbyangle(parray, parray[1])
```

The `refpoint` can be chosen, minimum point is usually OK:

```
polysortbyangle(parray, polycentroid(parray))
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/polygons.jl#L157-L166' class='documenter-source'>source</a><br>

<a id='Luxor.polysortbydistance-Tuple{Any,Luxor.Point}' href='#Luxor.polysortbydistance-Tuple{Any,Luxor.Point}'>#</a>
**`Luxor.polysortbydistance`** &mdash; *Method*.



Sort a polygon by finding the nearest point to the starting point, then the nearest point to that, and so on.

```
polysortbydistance(p, starting::Point)
```

You can end up with convex (self-intersecting) polygons, unfortunately.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/polygons.jl#L176-L183' class='documenter-source'>source</a><br>

<a id='Luxor.polysplit-Tuple{Any,Any,Any}' href='#Luxor.polysplit-Tuple{Any,Any,Any}'>#</a>
**`Luxor.polysplit`** &mdash; *Method*.



Split a polygon into two where it intersects with a line:

```
polysplit(p, p1, p2)
```

This doesn't always work, of course. (Tell me you're not surprised.) For example, a polygon the shape of the letter "E" might end up being divided into more than two parts.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/polygons.jl#L380-L387' class='documenter-source'>source</a><br>

<a id='Luxor.prettypoly' href='#Luxor.prettypoly'>#</a>
**`Luxor.prettypoly`** &mdash; *Function*.



Draw the polygon defined by points in `pl`, possibly closing and reversing it, using the current parameters, and then evaluate the expression at every vertex of the polygon. For example, you can mark each vertex of a polygon with a circle scaled to 0.1.

```
prettypoly(pointlist::Array, action = :nothing, vertex_action::Expr = :(); close=false, reversepath=false)
```

Example:

prettypoly(pl, :fill, :(scale(0.1, 0.1);                           circle(0, 0, 10, :fill)                          ),              close=false)

The expression can't use definitions that are not in scope, eg you can't pass a variable in from the calling function and expect this function to know about it. I don't think I like this, but...


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/polygons.jl#L428-L444' class='documenter-source'>source</a><br>

<a id='Luxor.preview-Tuple{}' href='#Luxor.preview-Tuple{}'>#</a>
**`Luxor.preview`** &mdash; *Method*.



```
preview()
```

On macOS, opens the file, which probably uses the default app, Preview.app On Unix, open the file with xdg-open. On Windows, pass the filename to the shell.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L163-L169' class='documenter-source'>source</a><br>

<a id='Luxor.randomcolor-Tuple{}' href='#Luxor.randomcolor-Tuple{}'>#</a>
**`Luxor.randomcolor`** &mdash; *Method*.



Set a random color.

  * `randomcolor()` choose a random color

This may change the current alpha opacity too.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L930-L937' class='documenter-source'>source</a><br>

<a id='Luxor.randomhue-Tuple{}' href='#Luxor.randomhue-Tuple{}'>#</a>
**`Luxor.randomhue`** &mdash; *Method*.



Set a random hue.

  * `randomhue()`

Choose a random color without changing the current alpha opacity.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L920-L926' class='documenter-source'>source</a><br>

<a id='Luxor.randompoint-Tuple{Any,Any,Any,Any}' href='#Luxor.randompoint-Tuple{Any,Any,Any,Any}'>#</a>
**`Luxor.randompoint`** &mdash; *Method*.



Return a random point somewhere inside the rectangle defined by the four coordinates:

```
randompoint(lowx, lowy, highx, highy)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/point.jl#L48-L53' class='documenter-source'>source</a><br>

<a id='Luxor.randompoint-Tuple{Any,Any}' href='#Luxor.randompoint-Tuple{Any,Any}'>#</a>
**`Luxor.randompoint`** &mdash; *Method*.



Return a random point somewhere inside the rectangle defined by the two points:

```
randompoint(lowpt, highpt)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/point.jl#L58-L62' class='documenter-source'>source</a><br>

<a id='Luxor.randompointarray-Tuple{Any,Any,Any,Any,Any}' href='#Luxor.randompointarray-Tuple{Any,Any,Any,Any,Any}'>#</a>
**`Luxor.randompointarray`** &mdash; *Method*.



Return an array of `n` random points somewhere inside the rectangle defined by the four coordinates:

```
randompointarray(lowx, lowy, highx, highy, n)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/point.jl#L66-L70' class='documenter-source'>source</a><br>

<a id='Luxor.randompointarray-Tuple{Any,Any,Any}' href='#Luxor.randompointarray-Tuple{Any,Any,Any}'>#</a>
**`Luxor.randompointarray`** &mdash; *Method*.



Return an array of `n` random points somewhere inside the rectangle defined by two points:

```
randompointarray(lowpt, highpt, n)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/point.jl#L79-L83' class='documenter-source'>source</a><br>

<a id='Luxor.readpng-Tuple{Any}' href='#Luxor.readpng-Tuple{Any}'>#</a>
**`Luxor.readpng`** &mdash; *Method*.



Read a PNG file into Cairo.

```
readpng(pathname)
```

This returns a Cairo.CairoSurface, suitable for placing on the current drawing with `placeimage()`. You can access its width and height properties.

```
image = readpng("/tmp/test-image.png")
w = image.width
h = image.height
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L1006-L1016' class='documenter-source'>source</a><br>

<a id='Luxor.rect' href='#Luxor.rect'>#</a>
**`Luxor.rect`** &mdash; *Function*.



Create a rectangle with one corner at (`xmin`/`ymin`) with width `w` and height `h` and do an action.

```
rect(xmin, ymin, w, h, action)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L404-L408' class='documenter-source'>source</a><br>

<a id='Luxor.rect-Tuple{Luxor.Point,Any,Any,Any}' href='#Luxor.rect-Tuple{Luxor.Point,Any,Any,Any}'>#</a>
**`Luxor.rect`** &mdash; *Method*.



Create a rectangle with one corner at `cornerpoint` with width `w` and height `h` and do an action.

```
rect(cornerpoint, w, h, action)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L418-L422' class='documenter-source'>source</a><br>

<a id='Luxor.rescale-Tuple{Any,Any,Any,Any,Any}' href='#Luxor.rescale-Tuple{Any,Any,Any,Any,Any}'>#</a>
**`Luxor.rescale`** &mdash; *Method*.



Convert or rescale a value between oldmin/oldmax to equivalent value between newmin/newmax.

For example, to convert 42 that used to lie between 0 and 100 to the equivalent number between 1 and 0 (inverting the direction):

```
rescale(42, 0, 100, 1, 0)
```

returns 0.5800000000000001


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L190-L198' class='documenter-source'>source</a><br>

<a id='Luxor.rline-Tuple{Any,Any}' href='#Luxor.rline-Tuple{Any,Any}'>#</a>
**`Luxor.rline`** &mdash; *Method*.



Create a line relative to the current position to the `x/y` position and optionally apply an action:

```
- `rline(x, y)`

- `rline(x, y, :action)`

- `rline(pt)`
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L559-L567' class='documenter-source'>source</a><br>

<a id='Luxor.rmove-Tuple{Any,Any}' href='#Luxor.rmove-Tuple{Any,Any}'>#</a>
**`Luxor.rmove`** &mdash; *Method*.



Move by an amount from the current point. Move relative to current position by `x` and `y`:

```
- `rmove(x, y)`
```

Move relative to current position by the `pt`'s x and y:

```
- `rmove(pt)`
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L522-L530' class='documenter-source'>source</a><br>

<a id='Luxor.rotate-Tuple{Any}' href='#Luxor.rotate-Tuple{Any}'>#</a>
**`Luxor.rotate`** &mdash; *Method*.



Rotate by `a` radians.

```
rotate(a)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L627-L632' class='documenter-source'>source</a><br>

<a id='Luxor.sector' href='#Luxor.sector'>#</a>
**`Luxor.sector`** &mdash; *Function*.



```
sector(innerradius, outerradius, startangle, endangle, action=:none)
```

Draw a track/sector based at 0/0.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L446-L450' class='documenter-source'>source</a><br>

<a id='Luxor.setcolor' href='#Luxor.setcolor'>#</a>
**`Luxor.setcolor`** &mdash; *Function*.



Set the current color and transparency.

setcolor(r, g, b, a=1)

Set the color to r, g, b, a.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L849-L855' class='documenter-source'>source</a><br>

<a id='Luxor.setcolor-Tuple{ColorTypes.Colorant}' href='#Luxor.setcolor-Tuple{ColorTypes.Colorant}'>#</a>
**`Luxor.setcolor`** &mdash; *Method*.



Set the current color.

  * `setcolor(color)`
  * `setcolor(convert(Colors.HSV, Colors.RGB(0.5, 1, 1)))`
  * `setcolor(r, g, b, alpha)`
  * `setcolor(.2, .3, .4, .5)`
  * `setcolor(r, g, b)`
  * `setcolor(col::ColorTypes.Colorant)`
  * `setcolor(convert(Color.HSV, Color.RGB(0.5, 1, 1)))`

    for i in 1:15:360      setcolor(convert(Color.RGB, Color.HSV(i, 1, 1)))      ...   end


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L822-L843' class='documenter-source'>source</a><br>

<a id='Luxor.setcolor-Tuple{String}' href='#Luxor.setcolor-Tuple{String}'>#</a>
**`Luxor.setcolor`** &mdash; *Method*.



```
setcolor(col::String)
```

Set the current color. This relies on Colors.jl to convert a string to RGBA eg setcolor("gold") # or "green", "darkturquoise", "lavender" or what have you. The list is at `Colors.color_names`.

Use `sethue()` for changing colors without changing current opacity level.

```
`setcolor("gold")`

`setcolor("darkturquoise")`
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L802-L814' class='documenter-source'>source</a><br>

<a id='Luxor.setdash-Tuple{Any}' href='#Luxor.setdash-Tuple{Any}'>#</a>
**`Luxor.setdash`** &mdash; *Method*.



Set the dash pattern to one of: "solid", "dotted", "dot", "dotdashed", "longdashed", "shortdashed", "dash", "dashed", "dotdotdashed", "dotdotdotdashed"

```
setlinedash("dot")
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L504-L508' class='documenter-source'>source</a><br>

<a id='Luxor.sethue-Tuple{String}' href='#Luxor.sethue-Tuple{String}'>#</a>
**`Luxor.sethue`** &mdash; *Method*.



Set the color. `sethue()` is like `setcolor()`, but (like Mathematica) we sometimes want to change the current 'color' without changing alpha/opacity. Using `sethue()` rather than `setcolor()` doesn't change the current alpha opacity.

```
sethue("black")
sethue(0.3,0.7,0.9)
```

  * `sethue(color)` like `setcolor()`
  * `sethue(r, g, b)` like `setcolor()` but doesn't change opacity


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L878-L887' class='documenter-source'>source</a><br>

<a id='Luxor.setline-Tuple{Any}' href='#Luxor.setline-Tuple{Any}'>#</a>
**`Luxor.setline`** &mdash; *Method*.



Set the line width.

```
setline(n)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L462-L467' class='documenter-source'>source</a><br>

<a id='Luxor.setlinecap' href='#Luxor.setlinecap'>#</a>
**`Luxor.setlinecap`** &mdash; *Function*.



Set the line ends. `s` can be "butt" (default), "square", or "round".

```
setlinecap(s)

setlinecap("round")
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L470-L476' class='documenter-source'>source</a><br>

<a id='Luxor.setlinejoin' href='#Luxor.setlinejoin'>#</a>
**`Luxor.setlinejoin`** &mdash; *Function*.



Set the line join, ie how to render the junction of two lines when stroking.

```
setlinejoin("round")
setlinejoin("miter")
setlinejoin("bevel")
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L487-L493' class='documenter-source'>source</a><br>

<a id='Luxor.setmatrix-Tuple{Array}' href='#Luxor.setmatrix-Tuple{Array}'>#</a>
**`Luxor.setmatrix`** &mdash; *Method*.



Change the current Cairo matrix to matrix `m`.

```
setmatrix(m::Array)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L964-L968' class='documenter-source'>source</a><br>

<a id='Luxor.setopacity-Tuple{Any}' href='#Luxor.setopacity-Tuple{Any}'>#</a>
**`Luxor.setopacity`** &mdash; *Method*.



Set the current opacity to a value between 0 and 1.

```
setopacity(alpha)
```

This modifies the alpha value of the current color.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L907-L913' class='documenter-source'>source</a><br>

<a id='Luxor.simplify-Tuple{Array,Any}' href='#Luxor.simplify-Tuple{Array,Any}'>#</a>
**`Luxor.simplify`** &mdash; *Method*.



Simplify a polygon:

```
simplify(pointlist::Array, detail)
```

`detail` is probably the smallest permitted distance between two points.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/polygons.jl#L236-L242' class='documenter-source'>source</a><br>

<a id='Luxor.star' href='#Luxor.star'>#</a>
**`Luxor.star`** &mdash; *Function*.



Draw a star:

```
star(centerpos, radius, npoints, ratio=0.5, orientation=0, action=:nothing, close=true, reversepath=false)
```

Use `starv()` to return the vertices of a star.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/polygons.jl#L323-L329' class='documenter-source'>source</a><br>

<a id='Luxor.star' href='#Luxor.star'>#</a>
**`Luxor.star`** &mdash; *Function*.



Draw a star:

```
star(xcenter, ycenter, radius, npoints, ratio=0.5, orientation=0, action=:nothing, close=true, reversepath=false)
```

Use `starv()` to return the vertices of a star.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/polygons.jl#L312-L318' class='documenter-source'>source</a><br>

<a id='Luxor.starv' href='#Luxor.starv'>#</a>
**`Luxor.starv`** &mdash; *Function*.



Make a star, returning its vertices:

```
starv(xcenter, ycenter, radius, npoints, ratio=0.5, orientation=0, close=true, reversepath=false)
```

Use `star()` to draw a star.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/polygons.jl#L287-L293' class='documenter-source'>source</a><br>

<a id='Luxor.stroke-Tuple{}' href='#Luxor.stroke-Tuple{}'>#</a>
**`Luxor.stroke`** &mdash; *Method*.



Stroke the current path with current line width, line join, line cap, and dash settings. The current path is then cleared.

```
stroke()
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L262-L267' class='documenter-source'>source</a><br>

<a id='Luxor.strokepreserve-Tuple{}' href='#Luxor.strokepreserve-Tuple{}'>#</a>
**`Luxor.strokepreserve`** &mdash; *Method*.



Stroke the current path with current line width, line join, line cap, and dash settings, but then keep the path current.

```
strokepreserve()
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L286-L291' class='documenter-source'>source</a><br>

<a id='Luxor.text' href='#Luxor.text'>#</a>
**`Luxor.text`** &mdash; *Function*.



```
text(str, x, y)
text(str, pt)
```

Draw text in string `str` at `x`/`y` or `pt`.

Text doesn't affect the current point!


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L702-L709' class='documenter-source'>source</a><br>

<a id='Luxor.textcentred' href='#Luxor.textcentred'>#</a>
**`Luxor.textcentred`** &mdash; *Function*.



```
textcentred(str, x, y)
textcentred(str, pt)
```

Draw text in string `str` centered at `x`/`y` or `pt`.

Text doesn't affect the current point!


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L720-L727' class='documenter-source'>source</a><br>

<a id='Luxor.textcurve-Tuple{Any,Any,Any,Any,Any}' href='#Luxor.textcurve-Tuple{Any,Any,Any,Any,Any}'>#</a>
**`Luxor.textcurve`** &mdash; *Method*.



Text on a curve. Place a string of text on a curve. It can spiral in or out. `start_angle` is relative to +ve x-axis, arc/circle is centred on `(x_pos,y_pos)` with radius `start_radius`.

```
textcurve(the_text,
  start_angle,
  start_radius,
  x_pos,
  y_pos;
  # optional keyword arguments
  spiral_ring_step = 0,   # step out or in by this amount
  letter_spacing = 0,     # tracking/space between chars, tighter is (-), looser is (+)
  spiral_in_out_shift = 0 # + values go outwards, - values spiral inwards
  )
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L745-L760' class='documenter-source'>source</a><br>

<a id='Luxor.textextents-Tuple{Any}' href='#Luxor.textextents-Tuple{Any}'>#</a>
**`Luxor.textextents`** &mdash; *Method*.



```
textextents(str)
```

Return the measurements of string `str`:

```
x_bearing
y_bearing
width
height
x_advance
y_advance
```

The bearing is the displacement from the reference point to the upper-left corner of the bounding box. It is often zero or a small positive value for x displacement, but can be negative x for characters like j as shown; it's almost always a negative value for y displacement. The width and height then describe the size of the bounding box. The advance takes you to the suggested reference point for the next letter. Note that bounding boxes for subsequent blocks of text can overlap if the bearing is negative, or the advance is smaller than the width would suggest.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L680-L698' class='documenter-source'>source</a><br>

<a id='Luxor.textpath-Tuple{Any}' href='#Luxor.textpath-Tuple{Any}'>#</a>
**`Luxor.textpath`** &mdash; *Method*.



```
textpath(t)
```

Convert the text in string `t` to a new path, for subsequent filling...


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L736-L740' class='documenter-source'>source</a><br>

<a id='Luxor.transform-Tuple{Array}' href='#Luxor.transform-Tuple{Array}'>#</a>
**`Luxor.transform`** &mdash; *Method*.



Modify the current matrix by multiplying it by matrix `a`.

```
transform(a::Array)
```

For example, to skew the current state by 45 degrees in x and move by 20 in y direction:

```
transform([1, 0, tand(45), 1, 0, 20])
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L985-L993' class='documenter-source'>source</a><br>

<a id='Luxor.translate-Tuple{Any,Any}' href='#Luxor.translate-Tuple{Any,Any}'>#</a>
**`Luxor.translate`** &mdash; *Method*.



Translate to new location.

```
translate(x, y)
```

or

```
translate(point)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L636-L644' class='documenter-source'>source</a><br>

<a id='Luxor.Drawing' href='#Luxor.Drawing'>#</a>
**`Luxor.Drawing`** &mdash; *Type*.



Create a new drawing.

  * `Drawing()`

create a drawing, defaulting to PNG format, default filename "/tmp/luxor-drawing.png", default size 800 pixels square

  * `Drawing(300,300)`

create a drawing 300 by 300 pixels, defaulting to PNG format, default filename "/tmp/luxor-drawing.png",

  * `Drawing(300,300, "/tmp/my-drawing.pdf")`

create a PDF drawing in the file "/tmp/my-drawing.pdf", 300 by 300 pixels

  * `Drawing(800,800, "/tmp/my-drawing.svg")`

create an SVG drawing in the file "/tmp/my-drawing.svg", 800 by 800 pixels

  * `Drawing(800,800, "/tmp/my-drawing.eps")`

create an EPS drawing in the file "/tmp/my-drawing.eps", 800 by 800 pixels

  * `Drawing("A4")`

create the drawing in ISO A4 size. Other sizes available are:  "A0", "A1", "A2", "A3", "A4", "A5", "A6", "Letter", "Legal", "A", "B", "C", "D", "E". Append "landscape" to get the landscape version.

  * `Drawing("A4landscape")`

create the drawing A4 landscape size.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L108-L138' class='documenter-source'>source</a><br>

<a id='Luxor.Point' href='#Luxor.Point'>#</a>
**`Luxor.Point`** &mdash; *Type*.



The Point type holds two coordinates.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/point.jl#L4-L6' class='documenter-source'>source</a><br>

<a id='Luxor.Turtle' href='#Luxor.Turtle'>#</a>
**`Luxor.Turtle`** &mdash; *Type*.



Turtle lets you run a turtle doing turtle graphics.

Once created, you can command it using the functions Forward, Turn, Circle, Orientation, Rectangle, Pendown, Penup, Pencolor, Penwidth, and Reposition.

There are also some other functions. To see how they might be used, see Lindenmayer.jl.


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Turtle.jl#L19-L26' class='documenter-source'>source</a><br>

<a id='Base.LinAlg.norm-Tuple{Luxor.Point,Luxor.Point}' href='#Base.LinAlg.norm-Tuple{Luxor.Point,Luxor.Point}'>#</a>
**`Base.LinAlg.norm`** &mdash; *Method*.



norm of two points. Two argument form.

```
norm(p1::Point, p2::Point)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/point.jl#L91-L95' class='documenter-source'>source</a><br>

<a id='Luxor.douglas_peucker-Tuple{Array,Any,Any,Any}' href='#Luxor.douglas_peucker-Tuple{Array,Any,Any,Any}'>#</a>
**`Luxor.douglas_peucker`** &mdash; *Method*.



Use a non-recursive Douglas-Peucker algorithm to simplify a polygon. Used by `simplify()`.

```
douglas_peucker(pointlist::Array, start_index, last_index, epsilon)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/polygons.jl#L199-L203' class='documenter-source'>source</a><br>

<a id='Luxor.point_line_distance-Tuple{Luxor.Point,Luxor.Point,Luxor.Point}' href='#Luxor.point_line_distance-Tuple{Luxor.Point,Luxor.Point,Luxor.Point}'>#</a>
**`Luxor.point_line_distance`** &mdash; *Method*.



Find the distance between a point `p` and a line between two points `a` and `b`.

```
point_line_distance(p::Point, a::Point, b::Point)
```


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/polygons.jl#L29-L34' class='documenter-source'>source</a><br>


There's a `rescale()` function which is just a utility function for converting a number from one range to another.

<a id='Luxor.rescale' href='#Luxor.rescale'>#</a>
**`Luxor.rescale`** &mdash; *Function*.



Convert or rescale a value between oldmin/oldmax to equivalent value between newmin/newmax.

For example, to convert 42 that used to lie between 0 and 100 to the equivalent number between 1 and 0 (inverting the direction):

```
rescale(42, 0, 100, 1, 0)
```

returns 0.5800000000000001


<a target='_blank' href='https://github.com/cormullion/Luxor.jl/tree/8f19ef9dc7de74fe3195cc9e06ae745b54ff62fd/src/Luxor.jl#L190-L198' class='documenter-source'>source</a><br>

