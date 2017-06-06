```@meta
DocTestSetup = quote
    using Luxor
    end
```

# The basics

The underlying drawing model is that you make shapes, or add points to paths, and these are filled and/or stroked, using the current *graphics state*, which specifies colors, line thicknesses, and opacity. You can modify the drawing space by transforming/rotating/scaling it, which affects subsequent graphics but not the ones you've already added.

Many of the drawing functions have an *action* argument. This can be `:nothing`, `:fill`, `:stroke`, `:fillstroke`, `:fillpreserve`, `:strokepreserve`, `:clip`. The default is `:nothing`.

Positions are specified either by x and y coordinates or a `Point(x, y)`. The default origin is at the top left of the drawing area.

Angles are mostly supplied in radians, measured starting at the positive x-axis turning towards the positive y-axis (which usually points 'down' the page or canvas, so 'clockwise').

Coordinates are interpreted as PostScript points, where a point is 1/72 of an inch.

Because Julia allows you to combine numbers and variables directly, you can supply units with dimensions and have them converted to points (assuming the current scale is 1:1):

- inch (`in` is unavailable, being used by `for` syntax)
- cm   (centimeters)
- mm   (millimeters)

For example:

    rect(Point(20mm, 2cm), 5inch, (22/7)inch, :fill)

## Types

The main defined types are `Point`, `Drawing`, and `Tiler`. The Point type holds two coordinates, `x` and `y`:

```
Point(12.0, 13.0)
```

It's immutable, so you want to avoid trying to change the x or y coordinate directly. You can use the letter **O** as a shortcut to refer to the current Origin, `Point(0, 0)`.

`Drawing` is how you create new drawings. You can divide up the drawing area into tiles, using `Tiler`, and define grids, using `GridRect` and `GridHex`.

## Drawings and files

To create a drawing, and optionally specify the filename and type, and dimensions, use the `Drawing` constructor function.

```@docs
Drawing
```

To finish a drawing and close the file, use `finish()`, and, to launch an external application to view it, use `preview()`.

If you're using Jupyter (IJulia), `preview()` tries to display PNG and SVG files in the next notebook cell.

![jupyter](assets/figures/jupyter.png)

If you're using Juno, then PNG and SVG files will appear in the Plots pane.

![juno](assets/figures/juno.png)

```@docs
finish
preview
```

The global variable `currentdrawing` (of type Drawing) stores some parameters related to the current drawing:

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

## The drawing surface

The origin (0/0) starts off at the top left: the x axis runs left to right across the page, and the y axis runs top to bottom down the page.

The `origin()` function moves the 0/0 point to the center of the drawing. It's often convenient to do this at the beginning of a program. You can use functions like `scale()`, `rotate()`, and `translate()` to change the coordinate system.

`background()` fills the drawing with a color, covering any previous contents. By default, PDF drawings have a white background, whereas PNG drawings have no background so that the background appears transparent in other applications. If there is a current clipping region, `background()` fills just that region. In the next example, the first `background()` fills the entire drawing with magenta, but the calls in the loop fill only the active clipping region, a tile defined by the `Tiler` iterator:

```@example
using Luxor # hide
Drawing(600, 400, "assets/figures/backgrounds.png") # hide
background("magenta")
origin() # hide
tiles = Tiler(600, 400, 5, 5, margin=30)
for (pos, n) in tiles
    box(pos, tiles.tilewidth, tiles.tileheight, :clip)
    background(randomhue()...)
    clipreset()
end
finish() # hide
nothing # hide
```

![background](assets/figures/backgrounds.png)

The `axes()` function draws a couple of lines and text labels in light gray to indicate the position and orientation of the current axes.

```@example
using Luxor # hide
Drawing(400, 400, "assets/figures/axes.png") # hide
background("gray80")
origin()
axes()
finish() # hide
nothing # hide
```

![axes](assets/figures/axes.png)

```@docs
background
axes
origin
```

## Tiles

The drawing area (or any other area) can be divided into rectangular tiles (as rows and columns) using the `Tiler` iterator, which returns the center point and tile number of each tile in turn.

In this example, every third tile is divided up into subtiles and colored:

```@example
using Luxor # hide
Drawing(400, 300, "assets/figures/tiler.png") # hide
background("white") # hide
origin() # hide
srand(1) # hide
fontsize(20) # hide
tiles = Tiler(400, 300, 4, 5, margin=5)
for (pos, n) in tiles
    randomhue()
    box(pos, tiles.tilewidth, tiles.tileheight, :fill)
    if n % 3 == 0
        gsave()
        translate(pos)
        subtiles = Tiler(tiles.tilewidth, tiles.tileheight, 4, 4, margin=5)
        for (pos1, n1) in subtiles
            randomhue()
            box(pos1, subtiles.tilewidth, subtiles.tileheight, :fill)
        end
        grestore()
    end
    sethue("white")
    textcentered(string(n), pos + Point(0, 5))
end
finish() # hide
nothing # hide
```

![tiler](assets/figures/tiler.png)

```@docs
Tiler
Partition
```

## Save and restore

`gsave()` saves a copy of the current graphics settings (current axis rotation, position, scale, line and text settings, color, and so on). When the next `grestore()` is called, all changes you've made to the graphics settings will be discarded, and they'll return to how they were when you last used `gsave()`. `gsave()` and `grestore()` should always be balanced in pairs.

```@docs
gsave
grestore
```
