```@meta
DocTestSetup = quote
    using Luxor, Colors
    end
```
# Basic path construction

This tutorial covers the basics of path building in Luxor. If you're familiar with the basics of Cairo, PostScript, or similar graphics applications, you can probably glance at this and move on. And, for a lot more definitive information about how paths work, you could usefully refer to the [Cairo API documentation](https://cairographics.org/manual/cairo-Paths.html); Luxor hides the details behind friendly Julia syntax, but the mechanics are the same.

## How to build a path

Consider this drawing. We'll use the quick `@drawsvg ...end` macro syntax for simplicity, so the point `(0, 0)` is at the center of the drawing, and the y direction is downwards.

```@example 
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

This drawing constructs and renders a path, using the basic building blocks. 

In Luxor, there's always a current path. At the start, just after we set the color to white, the current path is empty. The `move()` function starts the path by moving to (200, 0), ie 200 units in x (right). This sets the current point to `Point(200, 0)`. 

The `line(Point(250, 100))` function adds a straight line from the current point down to (250, 100). The current point becomes (250, 100), and the current path now has two entries. We've reached the bottom right corner of this particular path.

The `curve()` function takes three points, and adds a cubic Bézier curve to the current path. The curve is from the current point to the third point argument, with the first and second point arguments defining the Bézier curve's control points. These influence the shape of the curve. Finally, the current point is set to the point defined by the third argument.

!!! note
    
    To learn about Bézier curves, you can read [A Primer on Bézier Curves](https://pomax.github.io/Bézierinfo/).

The `closepath()` function adds a straight line to the path, and joins the current point to the beginning of the path - more specifically, to the most recent point `move`d to. The current point is updated to this point. 

We could use `line()` rather than `closepath()`, but `closepath()` will make a mitred join between the last and first line segments.

So, we've constructed a path. The final job is to decide what to do with it, unless you want to add more lines to it. `strokepath()` draws the path using a line with the current settings (width, color, etc). `fillpath()` fills the shape with the current color.

At this point, the current path is empty again, and there is no current point.

And that's how you draw paths in Luxor. However, you'd be right if you think it will be a bit tedious to construct every single shape like this. This is why there are so many other functions in Luxor, such as `circle()`, `ngon()`, `star()`, `rect()`, `box()`, to name just a few.

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

But you'll notice that there are two straight lines, not just one. The correct starting point for the arc isn't the same as the current point set by `move(Point(100, 200))`. So a straight line from the current point to the arc's starting point was automatically inserted.

Internally, circular arcs are converted to Bézier curves.

## Relative coordinates

The `move()` and `line()` accept absolute coordinates, which refer to the current origin. You might prefer to define the positions with reference to the current point. Use `rmove()` and `rline()`  to do this.

This drawing draws two boxes with 120 unit sides.

```@example 
using Luxor
@drawsvg begin
background("black")
sethue("white")

move(0, 0)
rline(Point(0, 120))
rline(Point(0, 0))
rline(Point(120, 0))
rline(Point(0, -120))
closepath()

rmove(150, 0)
rline(Point(0, 120))
rline(Point(0, 0))
rline(Point(120, 0))
rline(Point(0, -120))
closepath()

strokepath()
end
```

The current point just before the second `closepath()` runs is `Point(270.0, 0.0)`.

`rmove()` requires a current point to be "relative to", hence the first function is `move()` rather than `rmove()`.

## Subpaths

A path can contain any number of these move-line-curve-arc-closepath sequences. Only when you do a `strokepath()` or `fillpath()` function, when the entire path is drawn, then emptied.

You can create a subpath either by doing a `move()` in the middle of building a path, or with the specific `newsubpath()` function.

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

The first subpath is counterclockwise, the second subpath is clockwise and thus forms a hole when you fill the path.

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
# current path is still active here

# cyan stroke
sethue("cyan")
strokepath()
end 
```

## Translate, scale, rotate

Suppose you want to repeat a path in various places on the drawing. Obviously you don't want to repeat the steps in the path over and over again.

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

The triangle is drawn when you call the `t()` function. The coordinates are interpreted relative to the current (0, 0) position, scale, and orientation.

To draw the triangle in another location, you can use `translate()` to move the (0, 0) to another location.

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

Similarly, you could use `scale()` and `rotate()` which further modify the current state.

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

But, if you experiment with these three functions, you'll notice that the changes are always relative to the previous state. How do you return to a default initial state? You could undo every transformation (in the right order). But a better way is to enclose a set of changes of position, scale, and orientation in a pair of functions (`gsave()` and `grestore()`) that isolate the modifications.

The following code generates a grid of points in a nested loop. At each iteration, `gsave()` saves the current position, scale, and orientation, the graphics are drawn, and then `grestore()` restores the previously saved state.

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

`storepath()` grabs the current path and saves it as a Path object. You can draw a stored path using `drawpath()`.

There's another method for `line()`, which takes two points and a rendering instruction. For example:

```
line(Point(0, 0), Point(100, 100), :stroke)
```

is just a quicker way of typing:

```
move(Point(0, 0))
line(Point(100, 100))
strokepath()
```

## Polygonal thinking

In Luxor, a polygon is an array (a Julia Vector) of Points. You can treat it like any standard array, and then eventually draw it using the `poly()` function. It's all straight lines, no curves, so you might have to draw a lot of them to get shapes that look like curves.

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

It's probably easier to generate polygons using Julia code than it is to generate paths. But, no curves. If you need arcs and Bezier curves, stick to paths.

The `poly()` function simply builds a path with straight lines, and then does the `:fill` or `:stroke` action, depending on which you provide.
