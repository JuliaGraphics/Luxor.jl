```@meta
DocTestSetup = quote
    using Luxor, Colors
    end
```
# Tutorial: design a logo

The new (and currently fictitious) organization JuliaFission has just asked you to design a new logo for them. They're something to do with atoms and particles, perhaps? So we'll design a new logo for them using some basic shapes; perhaps colored circles in some kind of spiral formation would look suitably "atomic".

Let's try out some ideas.

## A first drawing

```@setup example_1
using Luxor
svgimage = @drawsvg begin
setcolor("red")
circle(Point(0, 0), 100, :fill)
end 500 500
```

```julia
using Luxor
Drawing(500, 500, "my-drawing.svg")
origin()
setcolor("red")
circle(Point(0, 0), 100, :fill)
finish()
preview()
```

```@example example_1
svgimage # hide
```

This short piece of code does the following things:

- Makes a new drawing 500 units square, and saves it in "my-drawing.svg" in SVG format.

- Moves the zero point from the top left to the center. Graphics applications often start measuring from the top left (or bottom left), but it's easier to work out the positions of things if you start at the center.)

- Selects one of the 200 or so named colors (defined in Colors.jl  [here](http://juliagraphics.github.io/Colors.jl/stable/))

- Draws a circle at x = 0, y = 0, with radius 100 units, and fills it with the current color.)

- Finishes the drawing and displays it on the screen.

In case you're wondering, the units are *points* (as in font sizes), and there are 72 points in an inch, just over 3 per millimeter. The y-axis points down the page, by the way. If you want to be reminded of where the x and y axes are, uses the [`rulers`](@ref) function.

The `:fill` at the end of [`circle`](@ref) is one of a set of symbols that lets you use the shape in different ways. There's `:stroke`, which draws around the edges but doesn't fill the shape with color, and you might also meet `:path`, `:fillstroke`, `:fillpreserve`, `:strokepreserve`, `:clip`, and `:none`.

## Circles in a spiral

We want more than just one circle. We'll define a triangular shape, and place circles at each corner. The [`ngon`](@ref) function creates regular polygon (eg triangles, squares, etc.), and the `vertices=true` keyword returns the corner points - just what we want.

```@setup example_2
using Luxor
svgimage = @drawsvg begin

setcolor("red")
corners = ngon(Point(0, 0), 80, 3, vertices=true)
circle.(corners, 10, :fill)

end 500 500
```

```julia
Drawing(500, 500, "my-drawing.svg")
origin()
setcolor("red")
corners = ngon(Point(0, 0), 80, 3, vertices=true)
circle.(corners, 10, :fill)
finish()
preview()
```

```@example example_2
svgimage # hide
```

Notice the "." after `circle`. This broadcasts the `circle()` function over the `corners`, drawing a red filled circle at every point.

The arguments to `ngon` are centerpoint, radius, and number of sides. Try changing the third argument from 3 to 4 or 33.

To create a spiral of circles, we want to repeat this `ngon`...`circle` part more than once. A simple loop will do: we'll rotate everything by `i * ` 5° (`deg2rad(5)` radians) each time (so 5°, 10°, 15°, 20°, 25°, and 30°), and increase the size of the shape by multiples of 10:

```@setup example_3
using Luxor
svgimage = @drawsvg begin

setcolor("red")
for i in 1:6
    rotate(i * deg2rad(5))
    corners = ngon(Point(0, 0), 80 + 10i, 3, vertices=true)
    circle.(corners, 10, :fill)
end

end 500 500
```

```julia

Drawing(500, 500, "my-drawing.svg")
origin()

setcolor("red")
for i in 1:6
    rotate(i * deg2rad(5))
    corners = ngon(Point(0, 0), 80 + 10i, 3, vertices=true)
    circle.(corners, 10, :fill)
end

finish()
preview()

```

```@example example_3
svgimage # hide
```

## Just add color

The Julia colors are available as constants in Luxor, so we can make two changes that cycle through them. The first line creates the set of colors; the [`setcolor`](@ref) function then works through them. `mod1` is the 1-based version of the `mod` function, essential for working with Julia and its 1-based indexing.

```@setup example_4
using Luxor, Colors
svgimage = @drawsvg begin

const colors = (Luxor.julia_green, Luxor.julia_red,Luxor.julia_purple, Luxor.julia_blue)

for i in 1:6
    setcolor(colors[mod1(i, end)])
    rotate(i * deg2rad(5))
    corners = ngon(Point(0, 0), 80 + 10i, 3, vertices=true)
    circle.(corners, 10, :fill)
end

end 500 500
```

```julia
using Colors

Drawing(500, 500, "my-drawing.svg")
origin()

const colors = (Luxor.julia_green, Luxor.julia_red,Luxor.julia_purple, Luxor.julia_blue)

for i in 1:6
    setcolor(colors[mod1(i, end)])
    rotate(i * deg2rad(5))
    corners = ngon(Point(0, 0), 80 + 10i, 3, vertices=true)
    circle.(corners, 10, :fill)
end


finish()
preview()

```

```@example example_4
svgimage # hide
```

## Taking particles seriously

The flat circles are a bit dull, so let's write a function that takes circles seriously. The `drawcircle()` function draws lots of circles, but each one is drawn with a slightly smaller radius and a slightly lighter shade of the incoming color. The [`rescale`](@ref) function in Luxor provides an easy way to map or adjust values from one range to another; here, numbers between 5 and 1 are mapped to numbers between 0.5 and 3. And the radius is scaled to run between `radius` and `radius/6`. Also, let's make them get larger as they spiral outwards, by adding `4i` to the radius when called by `drawcircle()`.

```@setup example_5
using Luxor, Colors

const colors = (Luxor.julia_green, Luxor.julia_red,Luxor.julia_purple, Luxor.julia_blue)

function drawcircle(pos, radius, n)
    c = colors[mod1(n, end)]
    for i in 5:-0.1:1
        setcolor(rescale(i, 5, 1, 0.5, 3) .* c)
        circle(pos + (i/2, i/2), rescale(i, 5, 1, radius, radius/6), :fill)
    end
end

svgimage = @drawsvg begin
    for i in 1:6
        rotate(i * deg2rad(5))
        corners = ngon(Point(0, 0), 80 + 10i, 3, vertices=true)
        drawcircle.(corners, 10 + 4i, i)
    end
end 500 500
```

```julia
function drawcircle(pos, radius, n)
    c = colors[mod1(n, end)]
    for i in 5:-0.1:1
        setcolor(rescale(i, 5, 1, 0.5, 3) .* c)
        circle(pos + (i/2, i/2), rescale(i, 5, 1, radius, radius/6), :fill)
    end
end

Drawing(500, 500, "my-drawing.svg")
origin()

for i in 1:6
    rotate(i * deg2rad(5))
    corners = ngon(Point(0, 0), 80 + 10i, 3, vertices=true)
    drawcircle.(corners, 10 + 4i, i)
end

finish()
preview()
```

```@example example_5
svgimage # hide
```

This is looking quite promising. But here's the thing: in a parallel universe, you might already have made this in no time at all using Adobe Illustrator or Inkscape. But with this Luxor code, you can try all kinds of different variations with almost immediate results - just walk through the parameter space, either manually or via code, and see what effects you get. You don't have to redraw everything with different angles and radii...

So here's what a pentagonal theme with more circles looks like:

```@setup example_6
using Luxor, Colors

const colors = (Luxor.julia_green, Luxor.julia_red,Luxor.julia_purple, Luxor.julia_blue)

function drawcircle(pos, radius, n)
    c = colors[mod1(n, end)]
    for i in 5:-0.1:1
        setcolor(rescale(i, 5, 1, 0.5, 3) .* c)
        circle(pos + (i/2, i/2), rescale(i, 5, 1, radius, radius/6), :fill)
    end
end

svgimage = @drawsvg begin
    for i in 1:12
        rotate(i * deg2rad(1.5))
        corners = ngon(Point(0, 0), 10 + 12i, 5, vertices=true)
        drawcircle.(corners, 5 + 2i, i)
    end
end 500 500
```

```julia

Drawing(500, 500, "my-drawing.svg")
origin()

for i in 1:12
    rotate(i * deg2rad(1.5))
    corners = ngon(Point(0, 0), 10 + 12i, 5, vertices=true)
    drawcircle.(corners, 5 + 2i, i)
end

finish()
preview()

```

```@example example_6
svgimage # hide
```

To tidy up, it's a good idea to move the code into functions (to avoid running too much in global scope), and do a bit of housekeeping.

Also, a background for the icon would look good. [`squircle`](@ref) is useful for drawing shapes that occupy the space between pointy rectangles and inefficient circles.

The final script looks like this:

```@setup example_7
using Luxor, Colors

const colors = (Luxor.julia_green, Luxor.julia_red,Luxor.julia_purple, Luxor.julia_blue)

function drawcircle(pos, radius, n)
    c = colors[mod1(n, end)]
    for i in 5:-.1:1
        setcolor(rescale(i, 5, 1, 0.5, 3) .* c)
        circle(pos + (i/2, i/2), rescale(i, 5, 1, radius, radius/6), :fill)
    end
end

function main(filename)
    @drawsvg begin
        setcolor(0.2, 0.2, 0.3)
        squircle(O, 240, 240, rt=0.5, :fill)
        for i in 1:12
            rotate(i * deg2rad(1.5))
            corners = ngon(Point(0, 0), 10 + 12i, 5, vertices=true)
            drawcircle.(corners, 5 + 2i, i)
        end
    end 500 500
end

svgimage = main("my-drawing.svg")
```

```julia
const colors = (Luxor.julia_green, Luxor.julia_red,Luxor.julia_purple, Luxor.julia_blue)

function drawcircle(pos, radius, n)
    c = colors[mod1(n, end)]
    for i in 5:-.1:1
        setcolor(rescale(i, 5, 1, 0.5, 3) .* c)
        circle(pos + (i/2, i/2), rescale(i, 5, 1, radius, radius/6), :fill)
    end
end

function main(filename)
    Drawing(500, 500, filename)
    origin()
    setcolor(0.2, 0.2, 0.3)
    squircle(O, 240, 240, rt=0.5, :fill)
    for i in 1:12
        rotate(i * deg2rad(1.5))
        corners = ngon(Point(0, 0), 10 + 12i, 5, vertices=true)
        drawcircle.(corners, 5 + 2i, i)
    end
    finish()
    preview()
end

main("my-drawing.svg")
```

```@example example_7
svgimage # hide
```

So, did the JuliaFission organization like their logo? Who knows!? But if not, we can always recycle some of these ideas for future projects... 😃

## Extra credit

### 1. Remember the random values

Using random numbers is a great way to find new patterns and shapes; but unless you know what the values are, you can't reproduce them. So modify the code so that the random numbers are remembered, and drawn on the screen (you can use the `text(str, position)` function),

### 2. Backgrounds

Because there's no background, the SVG or PNG image created will have a transparent background. This is usually what you want for an icon or logo. But this design might look good against a darker colored background. Use `background()` or `paint()` and experiment.

### 3. Randomize

Try refactoring your code so that you can automatically run through various parameter ranges.
