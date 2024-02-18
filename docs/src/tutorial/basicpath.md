```@meta
DocTestSetup = quote
    using Luxor, Colors
    end
```
# Basic path construction

This tutorial covers the basics of drawing paths in Luxor. If you're familiar with the basics of Cairo, PostScript, Processing, HTML canvas, or similar graphics applications, you can probably glance through these tutorials and then refer to the How To sections. For more information about how paths are built, refer to the [Cairo API documentation](https://cairographics.org/manual/cairo-Paths.html); Luxor hides the details behind friendly Julia syntax, but the underlying mechanics are the same.

## How to build a path

Consider the following drawing. (We'll use the quick `@drawsvg ...end` macro syntax for simplicity.) The point `(0, 0)` is at the center of the drawing canvas, and, as with most graphics software applications, the *y direction is downwards*.

!!! warning

    Mathematicians and people who like making plots say that the y axis goes up the page. Most graphics software is written with the assumption that the y axis goes downwards.

```@setup example_2
using Luxor
svgimage = @drawsvg begin
background("black")

@layer begin
    setopacity(0.8)
    setline(0.5)
    sethue(Luxor.Colors.colorant"green")
    circle(O, 5, :stroke)
    dimension(O, Point(200, 0), offset=0,textgap=0, textrotation = -π/2, texthorizontaloffset=5)
    dimension(Point(200, 0), Point(200, 100), offset=0,textgap=0, textrotation = -π/2, texthorizontaloffset=5)
    dimension(Point(200, 0), Point(250, 0), offset=0,textgap=0, textrotation = -π/2, texthorizontaloffset=5)
    dimension(Point(0, -200), Point(-200, -200), offset=0,textgap=0, textrotation = π/2, texthorizontaloffset=5)
    dimension(Point(-220, 0), Point(-220, -200), offset=0,textgap=10, textrotation = 0, texthorizontaloffset=5)
    circle.([Point(150, 150), Point(0, 100), Point(-200, -200)], 2, :fill)
    line(Point(150, 150), Point(250, 100), :stroke)
    line(Point(0, 100), Point(-200, -200), :stroke)
end
sethue("white")
move(Point(200, 0))
line(Point(250, 100))
curve(Point(150, 150), Point(0, 100), Point(-200, -200))
closepath()

strokepath()
end 520 520
```

```julia
using Luxor
@drawsvg begin
    background("black")

    sethue("white")
    move(Point(200, 0))
    line(Point(250, 100))
    curve(Point(150, 150), Point(0, 100), Point(-200, -200))
    closepath()

    strokepath()
end
```

```@example example_2
svgimage # hide
```

(Some annotations have been added (in green) to help you visualize the coordinate system.)

This drawing constructs and renders a path, using basic building blocks.

In Luxor, there's always a current path. At the start, just after we set the color to white, the current path is empty. The `move()` function call starts the path by moving  from (0, 0) to (200, 0), ie 200 units in x (right). This sets the *current point* to `Point(200, 0)`.

Next, the `line(Point(250, 100))` function call adds a straight line from the current point down to the point (250, 100). The current point is now set to (250, 100), and the current path now has two entries. We've reached the bottom right corner of this particular path.

The `curve()` function takes three point arguments, and adds a cubic Bézier curve to the current path. The curve runs from the current point to the third point argument, with the first and second point arguments defining the Bézier curve's control points. These don't lie on the curve, they just 'influence' the shape of the curve. Finally, the current point is updated to the point supplied as the third argument. We're now at the top left of the path.

!!! note
    
    To learn about Bézier curves, read [A Primer on Bézier Curves](https://pomax.github.io/Bézierinfo/).

Finally, the `closepath()` function adds a straight line to the path, joining the current point to the beginning of the path. (More precisely, it goes to the most recent point that you `move`d to). The current point is then updated to this point.

We could have used `line(Point(200, 0))` rather than `closepath()`, but `closepath()` is usually better than just drawing to the same point, because it will make a mitred join between the two line segments.

So, now we've constructed and finished a path - but now we must decide what to do with it. Above, we used `strokepath()` to draw the path using a line with the current settings (width, color, etc). But an alternative is to use `fillpath()` to fill the shape with the current color. `fillstroke()` does both. To change colors and styles, see [Colors and styles](@ref).

After you've rendered the path by stroking or filling it, the current path is empty again.

And that's how you draw paths in Luxor. 

However, you'd be right if you're thinking that constructing every single shape like this would be a lot of work. This is why there are so many other functions in Luxor, such as `circle()`, `ngon()`, `star()`, `rect()`, `box()`, etc. See [Simple graphics](@ref).

## Arcs

There are `arc()` and `carc()` (counterclockwise arc) functions that provide the ability to add circular arcs to the current path, just as `curve()` adds a Bézier curve. However, these need careful handling. Consider this drawing:

```@example 
using Luxor
@drawsvg begin
    background("black")
    sethue("white")
    move(Point(100, 200))
    arc(Point(0, 0), 70, 0, 3π / 2)
    line(Point(-200, -200))
    strokepath()
end
```

The `arc()` function arguments are: the center point, the radius, the start angle, and the end angle.

But you'll notice that there are two straight lines, not just one. After moving down to (100, 200), the calculated start point for the arc isn't (100, 200), but (70, 0). So a straight line is drawn from the current point (100, 200) back up to the arc's starting point (70, 0) - this was automatically added to the path, even though you didn't specify a line.

Internally, circular arcs are converted to Bézier curves.

## Relative coordinates

The `move()` and `line()` functions require absolute coordinates, which always refer to the current origin, (0, 0). You might prefer to define the positions with reference to the current path's current point. Use `rmove()` and `rline()` to do this.

This drawing draws two boxes with 120 unit sides.

```@example 
using Luxor
@drawsvg begin
    background("black")
    sethue("white")

    move(0, 0)

    rline(Point(120, 0))
    rline(Point(0, 120))
    rline(Point(-120, 0))
    rline(Point(0, -120))

    closepath()

    rmove(150, 0)

    rline(Point(120, 0))
    rline(Point(0, 120))
    rline(Point(-120, 0))
    rline(Point(0, -120))

    closepath()

    strokepath()
end
```

The drawing instructions to make the two shapes are the same, the second is just moved 150 units in x.

`rmove()` requires a current point to be "relative to". This is why the first drawing function is `move()` rather than `rmove()`.

Notice that this code draws two shapes, but there was only one `strokepath()` function call. These two shapes are in fact *subpaths*.

## Subpaths

A path consists of one or more of these move-line-curve-arc-closepath sequences. Each is a subpath. When you call a `strokepath()` or `fillpath()` function, all the subpaths in the entire path are rendered, and then the current path is emptied.

You can create a new subpath either by doing a `move()` or `rmove()` in the middle of building a path (before you render it), or with the specific `newsubpath()` function.

An important feature of subpaths is that they can form holes in paths.

```@example
using Luxor
@drawsvg begin
background("black")
sethue("white")

move(0, 0)
line(Point(0, 100))
line(Point(100, 100))
line(Point(100, 0))
closepath()

newsubpath()
move(25, 25)
line(Point(75, 25))
line(Point(75, 75))
line(Point(25, 75))
closepath()

fillpath()
end
```

The first subpath is counterclockwise, the second subpath is clockwise and thus forms a hole when you fill the path. (See [Nonzero winding rule](https://en.wikipedia.org/wiki/Nonzero-rule) for details.)

## Not just fill and stroke

As well as `strokepath()` or `fillpath()`, you can:

- `fillstroke()`: fill and stroke the path
- `clip()`:  turn the path into a clipping path 
- `strokepreserve()`: stroke the path but don't empty the current path
- `fillpreserve()`: fill the path but don't empty the current path

The `-preserve()` functions are useful for using different styles for fill and stroke:

```@example
using Luxor
@drawsvg begin
background("black")

move(0, 0)
line(Point(0, 100))
line(Point(100, 100))
line(Point(100, 0))
closepath()

# purple fill
sethue("purple")
fillpreserve() 

# current path is still here!

# cyan stroke
sethue("cyan")
strokepath()
end 
```

## Translate, scale, rotate

Suppose you want to repeat a path in various places on the drawing. Obviously you don't want to code the same steps over and over again.

In this example, the `t()` function draws a triangle path.

```@example
using Luxor
function t()
    move(Point(100, 0))
    line(Point(0, -100))
    line(Point(-100, 0))
    closepath()
    strokepath()
end

@drawsvg begin
background("black")
sethue("white")
t()
end
```

Inside `t()`, the coordinates are interpreted relative to the current graphics state: the current origin position (0, 0), scale (1), and rotation (0°).

To draw the triangle in another location, you can first use `translate()` to shift the (0, 0) origin to another location. Now the `move()` and `line()` calls inside the `t()` function all refer to the new location.

```@example
using Luxor
function t()
    move(Point(100, 0))
    line(Point(0, -100))
    line(Point(-100, 0))
    closepath()
    strokepath()
end

@drawsvg begin
background("black")
sethue("white")
t()

translate(Point(150, 150))
t()
end
```

You can also use the `scale()` and `rotate()` functions to modify the current state:

```@example
using Luxor
function t()
    move(Point(100, 0))
    line(Point(0, -100))
    line(Point(-100, 0))
    closepath()
    strokepath()
end

@drawsvg begin
background("black")
sethue("white")
t()

translate(Point(150, 150))
t()

translate(Point(30, 30))
scale(0.5)
t()

translate(Point(120, 120))
rotate(π/3)
t()
end
```

As you experiment with these three functions, you'll notice that the changes are always *relative* to the previous state. So if you do `scale(0.5)` twice, the next path will be drawn a quarter of the size.

So how do you return to a default initial state? You could of course keep a record of each transformation and apply the opposites, making sure you do this in the right order.

But a better way is to enclose a sequence of changes of position, scale, and orientation in a pair of functions (`gsave()` and `grestore()`). After `gsave()`, you can change position, scale, orientation, and set styling information, draw and render as many paths as you want, but then all the changes to position, scale, orientation, etc. will be discarded when you call `grestore()`. 

The following code generates a grid of points in a nested loop. At each iteration:

1. `gsave()` saves the current position, scale, and orientation on an internal stack.

2. The graphics state is translated, scaled, and rotated. 

3. The `t()` function is called, and draws the triangular path with the new settings - scaled, rotated, and translated relative to the current values of the `x` and `y` coordinates defined by the loop variables.

4. `grestore()` discards any changes to position, scale, and rotation, and restores them to the values they had just before the most recent `gsave()`.

```@example
using Luxor

function t()
    move(Point(100, 0))
    line(Point(0, -100))
    line(Point(-100, 0))
    closepath()
    strokepath()
end

@drawsvg begin
    background("black")
    sethue("white")
    for x in -250:20:250, y in -250:20:250
        gsave()
            translate(Point(x, y))
            scale(0.1)
            rotate(rand() * 2π)
            t()
        grestore()
    end
end
```

!!! note

    As an alternative to `gsave()` and `grestore()` you can use the `@layer begin ... end` macro, which does the same thing.

## Useful tools

You can use `currentpoint()` to get the current point. 

`rulers()` is useful for drawing the current x and y axes before you start a path.

`storepath()` grabs the current path and saves it as a Path object. This feature is intended to make Luxor paths more like other Julia objects, which you can save and manipulate before drawing them.

There's another method for `line()` which takes two points and a rendering instruction. For example:

```julia
line(Point(0, 0), Point(100, 100), :stroke)
```

is just a quicker way of typing:

```julia
move(Point(0, 0))
line(Point(100, 100))
strokepath()
```

## Polygonal thinking

In Luxor, a polygon is an array (a standard Julia vector) of Points. You can treat it like any standard Julia array, and then eventually draw it using the `poly()` function. 

It's all straight lines, no curves, so you might have to use a lot of points to get smooth curves.

```@example
using Luxor
@drawsvg begin
    background("black")
    sethue("white")
    pts = 30 .* [Point(x, sin(x)) for x in -2π:0.1:2π]
    poly(pts, :stroke)

    translate(0, 100)

    poly(pts, :fill)
end 
```

You might find it easier to generate polygons using Julia code than to generate paths. But, of course, there are no curves. If you need arcs and Bézier curves, stick to paths.

The `poly()` function simply builds a path with straight lines, and then does the `:fill` or `:stroke` action, depending on which you provide.

There are some Luxor functions that let you modify the points in a polygon in various ways:

- `polymove!(pgon, pt1, pt2)`

move all points by `pt1` -> `pt2`

- `polyreflect!(pgon, pt1, pt2)`

reflect all points in line between `pt1` and `pt2`

- `polyrotate!(pgon, θ)`

rotate all points by `θ`

- `polyscale!(pgon, s)`

scale all points by `s`
