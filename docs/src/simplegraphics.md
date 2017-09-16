# Simple graphics

In Luxor, there are different ways of working with graphical items. Some, such as lines, rectangles and circles, are drawn immediately (ie placed on the drawing and then "forgotten"). Others can be constructed and then converted to lists of points for further processing. For these, watch out for a `vertices=true` option.

## Rectangles and boxes

The simple rectangle and box shapes can be made in different ways.

```@example
using Luxor # hide
Drawing(400, 220, "assets/figures/basicrects.png") # hide
background("white") # hide
origin() # hide
axes()
sethue("red")
rect(O, 100, 100, :stroke)
sethue("blue")
box(O, 100, 100, :stroke)
finish() # hide
nothing # hide
```

![rect vs box](assets/figures/basicrects.png)

Whereas `rect()` rectangles are positioned at one corner, a box made with `box()` can either be defined by its center and dimensions, or by two opposite corners.

![rects](assets/figures/rects.png)

If you want the coordinates of the corners of a box, use this form of `box()`:

    box(centerpoint, width, height, vertices=false)


```@docs
rect
box
polybbox
```

For regular polygons, see the next section on Polygons.

## Circles and ellipses

There are various ways to make circles, including by center and radius, or passing through two points:

```@example
using Luxor # hide
Drawing(400, 200, "assets/figures/circles.png") # hide
background("white") # hide
origin() # hide
setline(2) # hide
p1 = O
p2 = Point(100, 0)
sethue("red")
circle(p1, 40, :fill)
sethue("green")
circle(p1, p2, :stroke)
sethue("black")
arrow(O, Point(0, -40))
map(p -> circle(p, 4, :fill), [p1, p2])
finish() # hide
nothing # hide
```

![circles](assets/figures/circles.png)

Or passing through three points. The `center3pts()` function returns the center position and radius of a circle passing through three points:

```@example
using Luxor # hide
Drawing(400, 200, "assets/figures/center3.png") # hide
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
nothing # hide
```

![center and radius of 3 points](assets/figures/center3.png)

With `ellipse()` you can place ellipses (and circles) by defining the center point and the width and height.

```@example
using Luxor # hide
Drawing(500, 300, "assets/figures/ellipses.png") # hide
background("white") # hide
fontsize(11) # hide
srand(1) # hide
origin() # hide
tiles = Tiler(500, 300, 5, 5)
width = 20
height = 25
for (pos, n) in tiles
    randomhue()
    ellipse(pos, width, height, :fill)
    sethue("black")
    label = string(round(width/height, 2))
    textcentered(label, pos.x, pos.y + 25)
    width += 2
end
finish() # hide
nothing # hide
```

![ellipses](assets/figures/ellipses.png)

It's also possible to construct polygons that are approximations to ellipses with two focal points and a distance.

```@example
using Luxor # hide
Drawing(500, 450, "assets/figures/ellipses_1.png") # hide
origin() # hide
background("white") # hide
sethue("gray30") # hide
setline(1) # hide
f1 = Point(-100, 0)
f2 = Point(100, 0)
ellipsepoly = ellipse(f1, f2, 170, :none, vertices=true)
[ begin
    setgray(rescale(c, 150, 1, 0, 1))
    poly(offsetpoly(ellipsepoly, c), close=true, :fill);
    rotate(pi/20)
  end
     for c in 150:-10:1 ]
finish() # hide
nothing # hide
```

![more ellipses](assets/figures/ellipses_1.png)

```@docs
circle
ellipse
```

`circlepath()` constructs a circular path from Bézier curves, which allows you to use circles as paths.

```@example
using Luxor # hide
Drawing(600, 250, "assets/figures/circle-path.png") # hide
origin() # hide
background("white") # hide
sethue("black") # hide
setline(4)
tiles = Tiler(600, 250, 1, 5)
for (pos, n) in tiles
    randomhue()
    circlepath(pos, tiles.tilewidth/2, :path)
    newsubpath()
    circlepath(pos, rand(5:tiles.tilewidth/2 - 1), :fill, reversepath=true)
end
finish() # hide
nothing # hide
```

![circles as paths](assets/figures/circle-path.png)

```@docs
circlepath
```

## More curved shapes: sectors, spirals, and squircles

A sector (technically an "annular sector") has an inner and outer radius, as well as start and end angles.

```@example
using Luxor # hide
Drawing(600, 200, "assets/figures/sector.png") # hide
background("white") # hide
origin() # hide
sethue("tomato")
sector(50, 90, pi/2, 0, :fill)
sethue("olive")
sector(Point(O.x + 200, O.y), 50, 90, 0, pi/2, :fill)
finish() # hide
nothing # hide
```

![sector](assets/figures/sector.png)

You can also supply a value for a corner radius. The same sector is drawn but with rounded corners.

```@example
using Luxor # hide
Drawing(600, 200, "assets/figures/sectorrounded.png") # hide
background("white") # hide
origin() # hide
sethue("tomato")
sector(50, 90, pi/2, 0, 15, :fill)
sethue("olive")
sector(Point(O.x + 200, O.y), 50, 90, 0, pi/2, 15, :fill)
finish() # hide
nothing # hide
```

![sector](assets/figures/sectorrounded.png)

```@docs
sector
```

A pie (or wedge) has start and end angles.

```@example
using Luxor # hide
Drawing(400, 300, "assets/figures/pie.png") # hide
background("white") # hide
origin() # hide
sethue("magenta") # hide
pie(0, 0, 100, pi/2, pi, :fill)
finish() # hide
nothing # hide
```

![pie](assets/figures/pie.png)

```@docs
pie
```

To construct spirals, use the `spiral()` function. These can be drawn directly, or used as polygons. The default is to draw Archimedes (non-logarithmic) spirals.

```@example
using Luxor # hide
Drawing(500, 400, "assets/figures/spiral.png") # hide
background("white") # hide
origin() # hide
sethue("magenta") # hide

sp = spiral(4, 1, stepby=pi/24, period=12pi, vertices=true)

for i in 1:10
    setgray(i/10)
    setline(22-2i)
    poly(sp, :stroke)
end

finish() # hide
nothing # hide
```

![spiral](assets/figures/spiral.png)

Use the `log=true` option to draw logarithmic spirals.

```@example
using Luxor # hide
Drawing(500, 400, "assets/figures/spiral-log.png") # hide
background("white") # hide
origin() # hide
sethue("magenta") # hide

sp = spiral(2, .12, log=true, stepby=pi/24, period=12pi, vertices=true)

for i in 1:10
    setgray(i/10)
    setline(22-2i)
    poly(sp, :stroke)
end

finish() # hide
nothing # hide
```

![spiral log](assets/figures/spiral-log.png)

```@docs
spiral
```

A *squircle* is a cross between a square and a circle. You can adjust the squariness and circularity of it to taste by supplying a value for keyword `rt`:

```@example
using Luxor # hide
Drawing(600, 250, "assets/figures/squircle.png") # hide
background("white") # hide
origin() # hide
fontsize(20) # hide
setline(2)
tiles = Tiler(600, 250, 1, 3)
for (pos, n) in tiles
    sethue("lavender")
    squircle(pos, 80, 80, rt=[0.3, 0.5, 0.7][n], :fillpreserve)
    sethue("grey20")
    strokepath()
    textcentered("rt = $([0.3, 0.5, 0.7][n])", pos)
end
finish() # hide
nothing # hide
```

![squircles](assets/figures/squircle.png)

```@docs
squircle
```

To draw a simple rounded rectangle, supply a corner radius:

```@example
using Luxor # hide
Drawing(600, 250, "assets/figures/round-rect-1.png") # hide
origin() # hide
background("white") # hide
sethue("black") # hide
setline(4)
box(O, 200, 150, 10, :stroke)
finish() # hide
nothing # hide
```

![rounded rect 1](assets/figures/round-rect-1.png)

Or you could smooth the corners of a box, like so:

```@example
using Luxor # hide
Drawing(600, 250, "assets/figures/round-rect.png") # hide
origin() # hide
background("white") # hide
sethue("black") # hide
setline(4)
polysmooth(box(O, 200, 150, vertices=true), 10, :stroke)
finish() # hide
nothing # hide
```
![rounded rect](assets/figures/round-rect.png)

## Paths and positions

A path is a sequence of lines and curves. You can add lines and curves to the current path,
then use `closepath()` to join the last point to the first.

A path can have subpaths, created with` newsubpath()`, which can form holes.

There is a 'current position' which you can set with `move()`, and can use implicitly in functions like `line()`, `text()`, `arc()` and `curve()`.

```@docs
move
rmove
newpath
newsubpath
closepath
```

## Lines

Use `line()` and `rline()` to draw straight lines.

```@docs
line
rline
```

You can use `rule()` to draw a line across the entire drawing through a point, at an angle to the current x-axis.

```@example
using Luxor # hide
Drawing(700, 200, "assets/figures/rule.png") # hide
background("white") # hide
sethue("black") # hide
setline(1) # hide

y = 10
for x in logspace(0, 2.75, 40)
    circle(Point(x, y), 2, :fill)
    rule(Point(x, y), -pi/2)
    y += 2
end

finish() # hide
nothing # hide
```

![arc](assets/figures/rule.png)

```@docs
rule
```

## Arcs and curves

There are a few standard arc-drawing commands, such as `curve()`, `arc()`, `carc()`, and `arc2r()`.

`curve()` constructs Bézier curves from control points:

```@example
using Luxor # hide
Drawing(500, 275, "assets/figures/curve.png") # hide
origin() # hide
background("white") # hide

setline(.5)
pt1 = Point(0, -125)
pt2 = Point(200, 125)
pt3 = Point(200, -125)

sethue("red")
map(p -> circle(p, 4, :fill), [O, pt1, pt2, pt3])

line(O, pt1, :stroke)
line(pt2, pt3, :stroke)

sethue("black")
setline(3)

move(O)
curve(pt1, pt2, pt3)
strokepath()
finish()  # hide
nothing # hide
```

![curve](assets/figures/curve.png)

`arc2r()` draws a circular arc that joins two points:  

```@example
using Luxor # hide
Drawing(700, 200, "assets/figures/arc2r.png") # hide
origin() # hide
srand(42) # hide
background("white") # hide
tiles = Tiler(700, 200, 1, 6)
for (pos, n) in tiles
    c1, pt2, pt3 = ngon(pos, rand(10:50), 3, rand(0:pi/12:2pi), vertices=true)
    sethue("black")
    map(pt -> circle(pt, 4, :fill), [c1, pt3])
    sethue("red")
    circle(pt2, 4, :fill)
    randomhue()
    arc2r(c1, pt2, pt3, :stroke)
end
finish() # hide
nothing # hide
```

![arc](assets/figures/arc2r.png)

```@docs
arc
arc2r
carc
carc2r
curve
```

## Geometry tools ##

You can find the midpoint between two points using `midpoint()`.

The following code places a small pentagon (using `ngon()`) at the midpoint of each side of a larger pentagon:

```@example
using Luxor # hide
Drawing(700, 220, "assets/figures/midpoint.png") # hide
origin() # hide
background("white") # hide
sethue("red")
ngon(O, 100, 5, 0, :stroke)

sethue("darkgreen")
p5 = ngon(O, 100, 5, 0, vertices=true)

for i in eachindex(p5)
    pt1 = p5[mod1(i, 5)]
    pt2 = p5[mod1(i + 1, 5)]
    ngon(midpoint(pt1, pt2), 20, 5, 0, :fill)
end
finish() # hide
nothing # hide
```
![arc](assets/figures/midpoint.png)

A more general function, `between()`, finds for a value `x` between 0 and 1 the corresponding point on a line defined by two points. So `midpoint(p1, p2)` and `between(p1, p2, 0.5)` should return the same point.

```@example
using Luxor # hide
Drawing(700, 150, "assets/figures/betweenpoint.png") # hide
origin() # hide
background("white") # hide
sethue("red")
p1 = Point(-150, 0)
p2 = Point(150, 40)
line(p1, p2)
strokepath()
for i in -0.5:0.1:1.5
    randomhue()
    circle(between(p1, p2, i), 5, :fill)
end
finish() # hide
nothing # hide
```
![arc](assets/figures/betweenpoint.png)

Values less than 0.0 and greater than 1.0 appear to work well too, placing the point on the line if extended.

```@docs
midpoint
between
```

`center3pts()` finds the radius and center point of a circle passing through three points which you can then use with functions such as `circle()` or `arc2r()`.

```@docs
center3pts
```

`intersection()` finds the intersection of two lines.

```@example
using Luxor # hide
Drawing(700, 220, "assets/figures/intersection.png") # hide
origin() # hide
background("white") # hide
sethue("darkmagenta") # hide
pt1, pt2, pt3, pt4 = ngon(O, 100, 5, vertices=true)
text.(string.[pt1, pt2, pt3, pt4], [pt1, pt2, pt3, pt4])
line(pt1, pt2, :stroke)
line(pt4, pt3, :stroke)

flag, ip =  intersection(pt1, pt2, pt3, pt4)
if flag
    circle(ip, 5, :fill)
end
finish() # hide
nothing # hide
```
![arc](assets/figures/intersection.png)

`intersection_line_circle()` finds the intersection of a line and a circle. There can be 0, 1, or 2 intersection points.

```@example
using Luxor # hide
Drawing(700, 220, "assets/figures/intersection_line_circle.png") # hide
origin() # hide
background("white") # hide
sethue("chocolate2") # hide
l1 = Point(-100.0, -75.0)
l2 = Point(300.0, 100.0)
rad = 100
cpoint = Point(0, 0)
line(l1, l2, :stroke)
sethue("darkgreen") # hide
circle(cpoint, rad, :stroke)
nints, ip1, ip2 =  intersection_line_circle(l1, l2, cpoint, rad)
sethue("black")
if nints == 2
    circle(ip1, 8, :stroke)
    circle(ip2, 8, :stroke)
end
finish() # hide
nothing # hide
```
![arc](assets/figures/intersection_line_circle.png)

`intersection2circles()` finds the area of the intersection of two circles, and `intersectioncirclecircle() finds the points where they cross.

This example shows the areas of two circles, and the area of their intersection.

```@example
using Luxor # hide
Drawing(700, 300, "assets/figures/intersection2circles.png") # hide
origin() # hide
background("white") # hide
fontsize(14) # hide
sethue("black") # hide

c1 = (O, 150)
c2 = (O + (100, 0), 150)

circle(c1... , :stroke)
circle(c2... , :stroke)

sethue("purple")
circle(c1... , :clip)
circle(c2... , :fill)
clipreset()

sethue("black")

text(string(150^2 * pi |> round), c1[1] - (125, 0))
text(string(150^2 * pi |> round), c2[1] + (100, 0))
sethue("white")
text(string(intersection2circles(c1..., c2...) |> round),
     midpoint(c1[1], c2[1]), halign=:center)

sethue("red")
flag, C, D = intersectioncirclecircle(c1..., c2...)
if flag
    circle.([C, D], 2, :fill)
end
finish() # hide
nothing # hide
```
![intersection of two circles](assets/figures/intersection2circles.png)

```@docs
intersection
intersection_line_circle
intersection2circles
intersectioncirclecircle
```
`getnearestpointonline()` finds perpendiculars.

```@example
using Luxor # hide
Drawing(700, 200, "assets/figures/perpendicular.png") # hide
origin() # hide
background("white") # hide
sethue("darkmagenta") # hide
end1, end2, pt3 = ngon(O, 100, 3, vertices=true)
map(pt -> circle(pt, 5, :fill), [end1, end2, pt3])
line(end1, end2, :stroke)
arrow(pt3, getnearestpointonline(end1, end2, pt3))
finish() # hide
nothing # hide
```
![arc](assets/figures/perpendicular.png)

```@docs
getnearestpointonline
pointlinedistance
slope
perpendicular
@polar
polar
```

## Arrows

You can draw lines or arcs with arrows at the end with `arrow()`. For straight arrows, supply the start and end points. For arrows as circular arcs, you provide center, radius, and start and finish angles. You can optionally provide dimensions for the `arrowheadlength` and `arrowheadangle` of the tip of the arrow (angle in radians between side and center). The default line weight is 1.0, equivalent to `setline(1)`), but you can specify another.

```@example
using Luxor # hide
Drawing(400, 250, "assets/figures/arrow.png") # hide
background("white") # hide
origin() # hide
sethue("steelblue4") # hide
setline(2) # hide
arrow(O, Point(0, -65))
arrow(O, Point(100, -65), arrowheadlength=20, arrowheadangle=pi/4, linewidth=.3)
arrow(O, 100, pi, pi/2, arrowheadlength=25,   arrowheadangle=pi/12, linewidth=1.25)
finish() # hide
nothing # hide
```
![arrows](assets/figures/arrow.png)

```@docs
arrow
```

## Julia graphics

A couple of functions in Luxor provide you with instant access to the Julia logo, and the three colored circles:

```@example
using Luxor # hide
Drawing(750, 250, "assets/figures/julia-logo.png")  # hide
srand(42) # hide
origin()  # hide
background("white") # hide

for (pos, n) in Tiler(750, 250, 1, 2)
    gsave()
    translate(pos - Point(150, 100))
    if n == 1
        julialogo()
    elseif n == 2
        julialogo(action=:clip)
        for i in 1:500
            gsave()
            translate(rand(0:400), rand(0:250))
            juliacircles(10)
            grestore()
        end
        clipreset()
    end
    grestore()
end
finish() # hide
nothing # hide
```

![get path](assets/figures/julia-logo.png)

```@docs
julialogo
juliacircles
```

## Miscellaneous

### Hypotrochoids

`hypotrochoid()` makes hypotrochoids. The result is a polygon. You can either draw it directly, or pass it on for further polygon fun, as here, which uses `offsetpoly()` to trace round it a few times.

```@example
using Luxor # hide
Drawing(500, 300, "assets/figures/hypotrochoid.png")  # hide
origin()
background("grey15")
sethue("antiquewhite")
setline(1)
p = hypotrochoid(100, 25, 55, :stroke, stepby=0.01, vertices=true)
for i in 0:3:15
    poly(offsetpoly(p, i), :stroke, close=true)
end
finish() # hide
nothing # hide
```

![hypotrochoid](assets/figures/hypotrochoid.png)

There's a matching `epitrochoid()` function.

```@docs
hypotrochoid
epitrochoid
```

### Grids

If you have to position items regularly, you might find a use for a grid. Luxor provides a simple grid utility. Grids are lazy: they'll supply the next point on the grid when you ask for it.

Define a rectangular grid with `GridRect`, and a hexagonal grid with `GridHex`. Get the next grid point from a grid with `nextgridpoint(grid)`.

```@example
using Luxor # hide
Drawing(700, 250, "assets/figures/grids.png")  # hide
background("white") # hide
fontsize(14) # hide
translate(50, 50) # hide
grid = GridRect(O, 40, 80, (10 - 1) * 40)
for i in 1:20
    randomhue()
    p = nextgridpoint(grid)
    squircle(p, 20, 20, :fill)
    sethue("white")
    text(string(i), p, halign=:center)
end
finish() # hide
nothing # hide
```

![grids](assets/figures/grids.png)

```@example
using Luxor # hide
Drawing(700, 400, "assets/figures/grid-hex.png")  # hide
background("white") # hide
fontsize(22) # hide
translate(100, 100) # hide
radius = 70
grid = GridHex(O, radius, 600)

for i in 1:15
    randomhue()
    p = nextgridpoint(grid)
    ngon(p, radius-5, 6, pi/2, :fillstroke)
    sethue("white")
    text(string(i), p, halign=:center)
end
finish() # hide
nothing # hide
```

![grids](assets/figures/grid-hex.png)

```@docs
GridRect
GridHex
nextgridpoint
```

### Cropmarks

If you want cropmarks (aka trim marks), use the `cropmarks()` function, supplying the centerpoint, followed by the width and height:

    cropmarks(O, 1200, 1600)
    cropmarks(O, paper_sizes["A0"]...)

```@example
using Luxor # hide
Drawing(700, 250, "assets/figures/cropmarks.png")  # hide
origin() # hide
background("white") # hide
sethue("red")
box(O, 150, 150, :stroke)
cropmarks(O, 150, 150)
finish() # hide
nothing # hide
```

![cropmarks](assets/figures/cropmarks.png)

```@docs
cropmarks
```

### Bars

For simple bars, use the `bars()` function, supplying an array of numbers:

```@example
using Luxor # hide
Drawing(800, 250, "assets/figures/bars.png")  # hide
origin() # hide
background("white") # hide
fontsize(7)
sethue("black")
translate(-350, 0) # hide
v = rand(-100:100, 60)
bars(v)
finish() # hide
nothing # hide
```

![bars](assets/figures/bars.png)

To change the way the bars and labels are drawn, define some functions and pass them as keyword arguments to `bars()`:

```@example
using Luxor # hide
Drawing(800, 350, "assets/figures/bars1.png")  # hide
origin() # hide
background("white") # hide
fontsize(8) # hide
sethue("black") # hide
translate(-350, 0) # hide

function mybarfunction(low::Point, high::Point, value; extremes=[0, 1])
    @layer begin
        sethue(rescale(value, extremes[1], extremes[2], 0, 1), 0.0, 1.0)
        circle(high, 8, :fill)
        setline(1)
        sethue("blue")
        line(low, high + (0, 8), :stroke)
        sethue("white")
        text(string(value), high, halign=:center, valign=:middle)
    end
end

function mylabelfunction(low::Point, high::Point, value; extremes=[0, 1])
    @layer begin
        translate(low)
        rotate(-pi/2)
        text(string(value,"/", extremes[2]), O - (10, 0), halign=:right, valign=:middle)
    end
end

v = rand(1:200, 30)
bars(v, xwidth=25, barfunction=mybarfunction, labelfunction=mylabelfunction)

finish() # hide
nothing # hide
```

![bars 1](assets/figures/bars1.png)

```@docs
bars
```
