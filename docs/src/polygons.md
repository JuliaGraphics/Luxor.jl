# Polygons and shapes

## Regular polygons ("ngons")

You can make regular polygons — from triangles, pentagons, hexagons, septagons, heptagons, octagons, nonagons, decagons, and on-and-on-agons — with `ngon()`.

![n-gons](figures/n-gon.png)

```julia
using Luxor
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

## Stars

Use `star()` to make a star.

```@example
using Luxor # hide
Drawing(500, 300, "../figures/stars.png") # hide
background("white") # hide
origin() # hide
tiles = Tiler(400, 300, 4, 6, margin=5)
for (pos, n) in tiles
  randomhue()
  star(pos, tiles.tilewidth/3, rand(3:8), 0.5, 0, :fill)
end
finish() # hide
```

![stars](figures/stars.png)

```@docs
star
```

## Polygons

A polygon is an array of Points. Use `poly()` to draw lines connecting the points:

```@example
using Luxor # hide
Drawing(400, 250, "../figures/simplepoly.png") # hide
background("white") # hide
origin() # hide
sethue("orchid4")
poly([Point(rand(-150:150), rand(-100:100)) for i in 1:20], :fill)
finish() # hide
```

![simple poly](figures/simplepoly.png)

```@docs
poly
```

A polygon can contain holes. The `reversepath` keyword changes the direction of the polygon. The following piece of code uses `ngon()` to make two paths, the second forming a hole in the first, to make a hexagonal bolt shape:

```@example
using Luxor # hide
Drawing(400, 250, "../figures/holes.png") # hide
background("white") # hide
origin() # hide
sethue("orchid4") # hide
ngon(0, 0, 60, 6, 0, :path)
newsubpath()
ngon(0, 0, 40, 6, 0, :path, reversepath=true)
fillstroke()
finish() # hide
```
![holes](figures/holes.png)

The `prettypoly()` function can place graphics at each vertex of a polygon. After the polygon action, the `vertex_action` expression is evaluated at each vertex. For example, to mark each vertex of a polygon with a randomly-colored circle:

```@example
using Luxor
Drawing(400, 250, "../figures/prettypolybasic.png") # hide
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

![prettypoly](figures/prettypolybasic.png)

```@docs
prettypoly
```

Introducing recursion is possible, but some of the parameters have to be enclosed with `$()` to protect them on their journey through the evaluation process:

```@example
using Luxor # hide
Drawing(400, 250, "../figures/prettypolyrecursive.png") # hide
background("white") # hide
srand(42) # hide
origin() # hide
sethue("magenta") # hide
setopacity(0.5) # hide

p = star(O, 80, 7, 0.3, 0, vertices=true)
prettypoly(p, :fill,
                  :(
                  ## for each vertex of the mother polygon
                  randomhue();
                  scale(0.5, 0.5);
                  prettypoly($(p), :fill,
                    :(
                    # for each vertex of each daughter polygon
                    randomhue();
                    scale(0.15, 0.15);
                    prettypoly($($(p)), :fill)))))

finish()
```

![prettypoly](figures/prettypolyrecursive.png)

Polygons can be simplified using the Douglas-Peucker algorithm (non-recursive version), via `simplify()`.

```@example
using Luxor # hide
Drawing(600, 500, "../figures/simplify.png") # hide
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
![simplify](figures/simplify.png)

```@docs
simplify
```

The `isinside()` function returns true if a point is inside a polygon.

```@example
using Luxor # hide
Drawing(400, 250, "../figures/isinside.png") # hide
background("white") # hide
origin() # hide
setopacity(0.5)
apolygon = star(O, 100, 5, 0.5, 0, vertices=true)
for n in 1:10000
  apoint = randompoint(Point(-200, -150), Point(200, 150))
  randomhue()
  isinside(apoint, apolygon) && circle(apoint, 3, :fill)
end
finish() # hide
```
![isinside](figures/isinside.png)

```@docs
isinside
```

You can use `randompoint()` and `randompointarray()` to create a random Point or list of Points.

```@example
using Luxor # hide
Drawing(400, 250, "../figures/randompoints.png") # hide
background("white") # hide
srand(42) # hide
origin() # hide

pt1 = Point(-100, -100)
pt2 = Point(100, 100)

sethue("gray80")
map(pt -> circle(pt, 6, :fill), (pt1, pt2))
box(pt1, pt2, :stroke)

sethue("red")
circle(randompoint(pt1, pt2), 7, :fill)

sethue("blue")
map(pt -> circle(pt, 2, :fill), randompointarray(pt1, pt2, 100))

finish() # hide
```

![isinside](figures/randompoints.png)

```@docs
randompoint
randompointarray
```

There are some experimental polygon functions. These don't work well for polygons that aren't simple or where the sides intersect each other, but they sometimes do a reasonable job. For example, here's `polysplit()`:

```@example
using Luxor # hide
Drawing(400, 150, "../figures/polysplit.png") # hide
origin() # hide
setopacity(0.7) # hide
srand(42) # hide
sethue("black") # hide
s = squircle(O, 60, 60, vertices=true)
pt1 = Point(0, -120)
pt2 = Point(0, 120)
line(pt1, pt2, :stroke)
poly1, poly2 = polysplit(s, pt1, pt2)
randomhue()
poly(poly1, :fill)
randomhue()
poly(poly2, :fill)
finish() # hide
```
![polysplit](figures/polysplit.png)

```@docs
polysplit
polysortbydistance
polysortbyangle
polycentroid
```
### Smoothing polygons

Because polygons can have sharp corners, the `polysmooth()` function can attempt to insert
arcs at the corners.

The original polygon is shown in red; the smoothed polygon is drawn on top:

```@example
using Luxor # hide
Drawing(600, 250, "../figures/polysmooth.png") # hide
origin() # hide
background("white") # hide
setopacity(0.5) # hide
srand(42) # hide
setline(0.7) # hide
tiles = Tiler(600, 250, 1, 5, margin=10)
for (pos, n) in tiles
    p = star(pos, tiles.tilewidth/2 - 2, 5, 0.3, 0, vertices=true)
    setdash("dot")
    sethue("red")
    prettypoly(p, close=true, :stroke)
    setdash("solid")
    sethue("black")
    polysmooth(p, n * 2, :fill)
end

finish() # hide
```

![polysmooth](figures/polysmooth.png)

The final polygon shows that  you can get unexpected results if you attempt to smooth corners by more than the possible amount. The `debug=true` option draws the circles if you want to find out what's going wrong, or if you want to explore the effect in more detail.

```@example
using Luxor # hide
Drawing(600, 250, "../figures/polysmooth-pathological.png") # hide
origin() # hide
background("white") # hide
setopacity(0.75) # hide
srand(42) # hide
setline(1) # hide
p = star(O, 60, 5, 0.35, 0, vertices=true)
setdash("dot")
sethue("red")
prettypoly(p, close=true, :stroke)
setdash("solid")
sethue("black")
polysmooth(p, 40, :fill, debug=true)
finish() # hide
```

![polysmooth](figures/polysmooth-pathological.png)

```@docs
polysmooth
```
