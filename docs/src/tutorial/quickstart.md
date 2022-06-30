```@meta
DocTestSetup = quote
    using Luxor, Colors
    end
```
# Quick start: design a logo

This section is a quick guide to getting started. Install the Luxor.jl package in the usual way:

```julia
julia> ] add Luxor
```

# A first drawing

The new (and currently fictitious) organization JuliaFission
has just asked you to design a new logo for them. They're
something to do with atoms and particles, perhaps? So we'll
design a new logo for them using some basic shapes; perhaps
colored circles in some kind of spiral formation would look
suitably "atomic".

Let's try out some ideas.

```@setup example_1
using Luxor
svgimage = @drawsvg begin
setcolor("red")
circle(Point(0, 0), 100, action = :fill)
end 500 500
```

```julia
using Luxor
Drawing(500, 500, "my-drawing.svg")
origin()
setcolor("red")
circle(Point(0, 0), 100, action = :fill)
finish()
preview()
```

```@example example_1
svgimage # hide
```

This short piece of code does the following things:

- makes a new drawing 500 units square, and will save it in the file "my-drawing.svg" in SVG format.

- moves the zero point from the top left to the center. Graphics applications usually start measuring from the top left (occasionally from the bottom left), but it's easier to work out the positions of things if you start at the center. The `origin()` function moves the `0/0` point to the center of the drawing.

- selects one of the 200 or so named colors (defined in [Colors.jl](http://juliagraphics.github.io/Colors.jl/stable/))

- draws a circle at x = 0, y = 0, with radius 100 units, and fills it with the current color

- finishes the drawing and displays it on the screen

In case you're wondering, the units are *points* (as in font sizes), and there are 72 points in an inch, just over 3 per millimeter. The y-axis points down the page. If you want to be reminded of where the x and y axes are, use the [`rulers`](@ref) function.

The `action=:fill` at the end of [`circle`](@ref) uses one of a set of symbols that let you use the shape you've created in different ways. There's the `:stroke` action, which draws around the edges but doesn't fill the shape with color. You might also meet the `:fillstroke`, `:fillpreserve`, `:strokepreserve`, `:clip`, and `:path` actions.

## Circles in a spiral

We want more than just one circle. We'll define a triangular shape, and place a circle at each corner. The [`ngon`](@ref) function creates regular polygons (eg triangles, squares, pentagons, etc.), and the `vertices=true` keyword doesn't draw the shape, it just provides the corner points - just what we want.

```@setup example_2
using Luxor
svgimage = @drawsvg begin

setcolor("red")
corners = ngon(Point(0, 0), 80, 3, vertices=true)
circle.(corners, 10, action = :fill)

end 500 500
```

```julia
# using Luxor
Drawing(500, 500, "my-drawing.svg")
origin()
setcolor("red")
corners = ngon(Point(0, 0), 80, 3, vertices=true)
circle.(corners, 10, action = :fill)
finish()
preview()
```

```@example example_2
svgimage # hide
```

Notice the "." after `circle`. This broadcasts the `circle()` function over the `corners`, thus drawing a 10-unit red-filled circle at every point.

The arguments to `ngon` are usually centerpoint, radius, and the number of sides. Try changing the third argument from 3 (triangle) to 4 (square) or 31 (traikontagon?).

To create a spiral of circles, we want to repeat this "draw a circle at each vertex of a triangle" procedure more than once. A simple loop will do: we'll rotate the drawing by `i * ` 5° (`deg2rad(5)` radians) each time (so 5°, 10°, 15°, 20°, 25°, and 30°), and at the same time increase the size of the polygon by multiples of 10:

```@setup example_3
using Luxor
svgimage = @drawsvg begin

setcolor("red")
for i in 1:6
    rotate(i * deg2rad(5))
    corners = ngon(Point(0, 0), 80 + 10i, 3, vertices=true)
    circle.(corners, 10, action = :fill)
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
    circle.(corners, 10, action = :fill)
end

finish()
preview()
```

```@example example_3
svgimage # hide
```

## Just add color

The colors used in the Julia logo are available as constants in Luxor, so we can make two changes that cycle through them. The first new line creates the set of Julia colors; then the [`setcolor`](@ref) function then works through them. `mod1` (get the `nth` element of an array) is the 1-based version of the `mod` function, essential for working with Julia and its 1-based indexing, such that `mod1(4, end)` gets the last value of a four element array (whereas `mod(4, end)` would fail, since it would return 0, and `colors[0]` would be an error).

```@setup example_4
using Luxor, Colors
svgimage = @drawsvg begin

const colors = (Luxor.julia_green, Luxor.julia_red,Luxor.julia_purple, Luxor.julia_blue)

for i in 1:6
    setcolor(colors[mod1(i, end)])
    rotate(i * deg2rad(5))
    corners = ngon(Point(0, 0), 80 + 10i, 3, vertices=true)
    circle.(corners, 10, action = :fill)
end

end 500 500
```

```julia
using Luxor
using Colors

Drawing(500, 500, "my-drawing.svg")
origin()

const colors = (Luxor.julia_green, Luxor.julia_red,Luxor.julia_purple, Luxor.julia_blue)

for i in 1:6
    setcolor(colors[mod1(i, end)])
    rotate(i * deg2rad(5))
    corners = ngon(Point(0, 0), 80 + 10i, 3, vertices=true)
    circle.(corners, 10, action = :fill)
end

finish()
preview()

```

```@example example_4
svgimage # hide
```

## Taking particles seriously

The flat circles are a bit dull, so let's write a function
that draws the circles as ‘particles’. The `drawcircle()` function
draws lots of circles on top of each other, but each one is drawn with a slightly
smaller radius and a slightly lighter shade of the incoming
color. The [`rescale`](@ref) function in Luxor provides an
easy way to map or adjust values from one range to another.
Here, numbers between 5 and 1 are mapped to numbers between
0.5 and 3. And the radius is scaled to run between `radius`
and `radius/6`. Also, let's make them get larger as they
spiral outwards, by adding `4i` to the radius when called by
`drawcircle()`.

```@setup example_5
using Luxor, Colors

const colors = (Luxor.julia_green, Luxor.julia_red,Luxor.julia_purple, Luxor.julia_blue)

function drawcircle(pos, radius, n)
    c = colors[mod1(n, end)]
    for i in 5:-0.1:1
        setcolor(rescale(i, 5, 1, 0.5, 3) .* c)
        circle(pos + (i/2, i/2), rescale(i, 5, 1, radius, radius/6), action = :fill)
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
        circle(pos + (i/2, i/2), rescale(i, 5, 1, radius, radius/6), action = :fill)
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

This is looking quite promising. But here’s the thing: in a
parallel universe, you might already have made this in no
time at all using Adobe Illustrator or Inkscape. But with
this Luxor code, you can try all kinds of different
variations with almost immediate results - you can “walk through
the parameter space”, either manually or via code, and see
what effects you get. You don’t have to redraw everything
with different angles and radii...

So here's what a pentagonal theme with more circles looks like:

```@setup example_6
using Luxor, Colors

const colors = (Luxor.julia_green, Luxor.julia_red,Luxor.julia_purple, Luxor.julia_blue)

function drawcircle(pos, radius, n)
    c = colors[mod1(n, end)]
    for i in 5:-0.1:1
        setcolor(rescale(i, 5, 1, 0.5, 3) .* c)
        circle(pos + (i/2, i/2), rescale(i, 5, 1, radius, radius/6), action = :fill)
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

Also, a background for the icon would look good. [`squircle`](@ref) is useful for drawing shapes that occupy the space between pointy dull rectangles and space-inefficient circles.

The complete final script looks like this:

```@setup example_7
using Luxor, Colors

const colors = (Luxor.julia_green, Luxor.julia_red, Luxor.julia_purple, Luxor.julia_blue)

function drawcircle(pos, radius, n)
    c = colors[mod1(n, end)]
    for i in 5:-.1:1
        setcolor(rescale(i, 5, 1, 0.5, 3) .* c)
        circle(pos + (i/2, i/2), rescale(i, 5, 1, radius, radius/6), action = :fill)
    end
end

function main(filename)
    @drawsvg begin
        setcolor(0.2, 0.2, 0.3)
        squircle(O, 240, 240, rt=0.5, action = :fill)
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
        circle(pos + (i/2, i/2), rescale(i, 5, 1, radius, radius/6), action = :fill)
    end
end

function main(filename)
    Drawing(500, 500, filename)
    origin()
    setcolor(0.2, 0.2, 0.3)
    squircle(O, 240, 240, rt=0.5, action = :fill)
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

So, did the JuliaFission organization like their logo? Who
knows? - they may still be debating how accurate the
representation of an atom should be... But if not, we can
always recycle some of these ideas for future projects. 😃

## Extra credit

### 1. Randomize

Try refactoring your code so that you can automatically run through various parameter ranges. You could create many drawings with automatically-generated  filenames...

### 2. Remember the random values

Using random numbers is a great way to find new patterns and
shapes; but unless you know what values were used, you can't
easily reproduce them. It's frustrating to produce something
really good but not know what values were used to make it.
So modify the code so that the random numbers are
remembered, and drawn on the screen (you can use the
`text(string, position)` function),
