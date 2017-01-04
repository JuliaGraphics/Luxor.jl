# Styling

## Color and opacity

For color definitions and conversions, you can use Colors.jl.

`setcolor()` and `sethue()` apply a single solid or transparent color to shapes. `setblend()` applies a smooth transition between two or more colors.

The difference between the `setcolor()` and `sethue()` functions is that `sethue()` is independent of alpha opacity, so you can change the hue without changing the current opacity value.

Named colors, such as "gold", or "lavender", can be found in Colors.color_names. This code shows the first 600 colors.

```@example
using Luxor, Colors # hide
Drawing(800, 500, "figures/colors.png") # hide
origin()
background("white") # hide
fontsize(5) # hide
cols = collect(Colors.color_names)
tiles = Tiler(800, 500, 30, 20)
for (pos, n) in tiles
    sethue(cols[n][1])
    box(pos, tiles.tilewidth, tiles.tileheight, :fill)
    sethue("black")
    text(string(cols[n][1]), pos, halign=:center)
end
finish() # hide
nothing # hide
```

![line endings](figures/colors.png)

```@docs
sethue
setcolor
setblend
setopacity
randomhue
randomcolor
```

## Line styles

The `set-` functions control subsequent lines' width, end shapes, join behavior, and dash pattern:

```@example
using Luxor # hide
Drawing(400, 250, "figures/line-ends.png") # hide
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
nothing # hide
```

![line endings](figures/line-ends.png)

```@example
using Luxor # hide
Drawing(600, 250, "figures/dashes.png") # hide
background("white") # hide
origin() # hide
fontsize(14) # hide
sethue("black") # hide
setline(12)
patterns = ["solid", "dotted", "dot", "dotdashed", "longdashed",
  "shortdashed", "dash", "dashed", "dotdotdashed", "dotdotdotdashed"]
tiles =  Tiler(400, 250, 10, 1, margin=10)
for (pos, n) in tiles
    setdash(patterns[n])
    textright(patterns[n], pos.x - 20, pos.y + 4)
    line(pos, Point(400, pos.y), :stroke)
end
finish() # hide
nothing # hide
```

![dashes](figures/dashes.png)

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
paint
do_action
```

## Blends

A blend is a color gradient. Use `setblend()` to select a blend in the same way that you'd use `setcolor()` and `sethue()` to select a solid color.

You can make linear or radial blends. Use `blend()` in either case.

To create a simple linear blend between two colors, supply two points and two colors to `blend()`:

```@example
using Luxor # hide
Drawing(600, 200, "figures/color-blends-basic.png") # hide
origin() # hide
background("white") # hide
orangeblue = blend(Point(-200, 0), Point(200, 0), "orange", "blue")
setblend(orangeblue)
box(O, 400, 100, :fill)
axes()
finish() # hide
nothing # hide
```

![linear blend](figures/color-blends-basic.png)

And for a radial blend, provide two point/radius pairs, and two colors:

```@example
using Luxor # hide
Drawing(600, 200, "figures/color-blends-radial.png") # hide
origin() # hide
background("white") # hide
greenmagenta = blend(Point(0, 0), 5, Point(0, 0), 150, "green", "magenta")
setblend(greenmagenta)
box(O, 400, 200, :fill)
axes()
finish() # hide
nothing # hide
```
![radial blends](figures/color-blends-radial.png)

You can also use `blend()` to create an empty blend. Then you use `addstop()` to define the locations of specific colors along the blend, where `0` is the start, and `1` is the end.

```@example
using Luxor # hide
Drawing(600, 200, "figures/color-blends-scratch.png") # hide
origin() # hide
background("white") # hide
goldblend = blend(Point(-200, 0), Point(200, 0))
addstop(goldblend, 0.0,  "gold4")
addstop(goldblend, 0.25, "gold1")
addstop(goldblend, 0.5,  "gold3")
addstop(goldblend, 0.75, "darkgoldenrod4")
addstop(goldblend, 1.0,  "gold2")
setblend(goldblend)
box(O, 400, 200, :fill)
axes()
finish() # hide
nothing # hide
```

![blends from scratch](figures/color-blends-scratch.png)

When you define blends, the location of the axes (eg the current workspace as defined by `translate()`, etc.), is important. In the first of the two following examples, the blend is selected before the axes are moved with `translate(pos)`. The blend 'samples' the original location of the blend's definition.

```@example
using Luxor # hide
Drawing(600, 200, "figures/color-blends-translate-1.png") # hide
origin() # hide
background("white") # hide
goldblend = blend(Point(0, 0), Point(200, 0))
addstop(goldblend, 0.0,  "gold4")
addstop(goldblend, 0.25, "gold1")
addstop(goldblend, 0.5,  "gold3")
addstop(goldblend, 0.75, "darkgoldenrod4")
addstop(goldblend, 1.0,  "gold2")
setblend(goldblend)
tiles = Tiler(600, 200, 1, 5, margin=10)
for (pos, n) in tiles
    gsave()
    setblend(goldblend)
    translate(pos)
    ellipse(O, tiles.tilewidth, tiles.tilewidth, :fill)
    grestore()
end
finish() # hide
nothing # hide
```

![blends 1](figures/color-blends-translate-1.png)

Outside the range of the original blend's definition, the same color is used, no matter how far away from the origin you go (there are Cairo options to change this). But in the next example, the blend is relocated to the current axes, which have just been moved to the center of the tile. The blend refers to `0/0` each time, which is at the center of shape.

```@example
using Luxor # hide
Drawing(600, 200, "figures/color-blends-translate-2.png") # hide
origin() # hide
background("white") # hide
goldblend = blend(Point(0, 0), Point(200, 0))
addstop(goldblend, 0.0,  "gold4")
addstop(goldblend, 0.25, "gold1")
addstop(goldblend, 0.5,  "gold3")
addstop(goldblend, 0.75, "darkgoldenrod4")
addstop(goldblend, 1.0,  "gold2")
setblend(goldblend)
tiles = Tiler(600, 200, 1, 5, margin=10)
for (pos, n) in tiles
    gsave()
    translate(pos)
    setblend(goldblend)
    ellipse(O, tiles.tilewidth, tiles.tilewidth, :fill)
    grestore()
end
finish() # hide
nothing # hide
```
![blends 2](figures/color-blends-translate-2.png)

```@docs
blend
addstop
```

### Using `blendadjust()`

You can use `blendadjust()` to modify the blend so that objects scaled and positioned after the blend was defined are rendered correctly.

```@example
using Luxor # hide
Drawing(600, 250, "figures/blend-adjust.png") # hide
origin() # hide
background("white") # hide
setline(20)

# first line
blendgoldmagenta = blend(Point(-100, 0), Point(100, 0), "gold", "magenta")
setblend(blendgoldmagenta)
line(Point(-100, -50), Point(100, -50))
stroke()

# second line
blendadjust(blendgoldmagenta, Point(50, 0), 0.5, 0.5)
line(O, Point(100, 0))
stroke()

# third line
blendadjust(blendgoldmagenta, Point(-50, 50), 0.5, 0.5)
line(Point(-100, 50), Point(0, 50))
stroke()

# fourth line
gsave()
translate(0, 100)
scale(0.5, 0.5)
setblend(blendgoldmagenta)
line(Point(-100, 0), Point(100, 0))
stroke()
grestore()

finish() # hide
nothing # hide
```

![blends adjust](figures/blend-adjust.png)

The blend is defined to span 200 units, horizontally centered at 0/0. The top line is also 200 units long and centered horizontally at 0/0, so the blend is rendered exactly as you'd hope.

The second line is only half as long, at 100 units, centered at 50/0, so `blendadjust()` is used to relocate the blend's center to the point 50/0 and scale it by 0.5 (`100/200`).

The third line is also 100 units long, centered at -50/0, so again `blendadjust()` is used to relocate the blend's center and scale it.

The fourth line shows that you can translate and scale the axes instead of adjusting the blend, if you use `setblend()` again in the new scene.

```@docs
blendadjust
```
