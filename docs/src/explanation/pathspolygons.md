# Paths versus polygons

When drawing in Luxor you'll usually be creating _paths_ and _polygons_. It can be easy to confuse the two.

## Paths

In Luxor, a path is something that you manipulate by calling
functions that control Cairo's path-drawing engine. There
isn't a Luxor struct or datatype that contains or maintains
a path (although see below). Cairo keeps track of the
current path, the current point, and the current graphics
state, in response to the functions you call.

A path can contain one or more sequences of straight lines
and Bézier curves. There's always a single active path. It starts off being empty.

The following figure was drawn using this function, which creates a
single path consisting of three separate shapes - a line, a
rectangular box, and a circle:

```
function make_path()
    move(Point(-220, 50))
    line(Point(-170, -50))
    line(Point(-120, 50))
    move(Point(0, 0))
    box(O, 100, 100, :path)
    move(Point(180, 0) + polar(40, 0)) # pt on circumference
    circle(Point(180, 0), 40, :path)
end
```

The [`move()`](@ref) function as used here is essentially a "pick up
the pen and move it elsewhere" instruction.

The top path, in purple, is drawn when [`strokepath()`](@ref)
is applied to this path. Each of the three shapes is
stroked with the same current settings (color, line
thickness, dash pattern, and so on).

The middle row shows a duplicate of this path, and
[`fillpath()`](@ref) has been applied to fill each of the three
shapes in the path with orange.

The duplicate path at the bottom has been followed by the
[`clip()`](@ref) function and then by [`rule()`](@ref) to draw green ruled
lines, which are clipped by the outlines of the shapes in the path.

```@setup pathexample
using Luxor

function make_path()
    move(Point(-220, 50))
    line(Point(-170, -50))
    line(Point(-120, 50))
    move(Point(0, 0))
    box(O, 100, 100, :path)
    move(Point(180, 0) + polar(40, 0))
    circle(Point(180, 0), 40, :path)
end

d = @drawsvg begin
    background("antiquewhite")

    sethue("rebeccapurple")
    translate(0, -120)
    make_path()
    strokepath()

    translate(0, 120)
    sethue("orange")
    make_path()
    fillpath()

    translate(0, 120)
    make_path()
    clip()
    sethue("green")
    rule.(between.(O - (250, 0), O + (250, 0), 0:0.01:1), -π/3)
    end 800 500
```

```@example pathexample
d # hide
```

You can construct paths using functions like [`move()`](@ref),
[`line()`](@ref), [`arc()`](@ref), and [`curve()`](@ref), plus any Luxor function
that lets you specify the `:path` ("add to path") action as a
keyword argument or parameter.

Many functions in Luxor have an `action` keyword argument or
parameter. If you want to add that shape to the current
path, use `:path`. If you want to both add the shape _and_
finish and draw the current path, use one of `stroke`,
`fill`, etc.  

After the path is stroked or filled, it's emptied out, ready
for you to start over again. But you can also use one of the
'-preserve' varsions, [`fillpreserve()`](@ref)/`:fillpreserve` or
[`strokepreserve()`](@ref)/`:strokepreserve` to continue working
with the current defined path after drawing it. You can
convert the path to a clipping path using
`:clip`/[`clip()`](@ref).

A single path can contain multiple separate graphic shapes.
These can make holes. If you want a path to contain holes,
you add the hole shapes to the path after reversing their
direction. For example, to put a square hole inside a
circle, first create a circular path, then draw a square
path inside, making sure that the square path runs in the
opposite direction to the circle.

```@example
using Luxor # hide
d = @drawsvg begin # hide
background("antiquewhite") # hide
sethue("purple")
circle(O, 200, :path)
box(O, 100, 100, :path, reversepath=true)
fillpath()
end 800 500 # hide
d # hide
```

If you're constructing the path from simple path commands,
this is easy, and the functions that provide a `reversepath`
keyword argument can help. If not, you can do things like
this:

```
circle(O, 100, :path)                 # add a circle to the current path
poly(reverse(box(O, 50, 50)), :path)  # create polygon, add to current path after reversing
fillpath()                            # finally fill the two-part path
```

Many methods, including [`box()`](@ref), [`crescent()`](@ref),
[`ellipse()`](@ref), [`epitrochoid()`](@ref),
[`hypotrochoid()`](@ref), [`ngon()`](@ref),
[`polycross()`](@ref), [`rect()`](@ref),
[`squircle()`](@ref), and [`star()`](@ref), offer a
`vertices` keyword argument. With these you can specify
`vertices=true` to return a list of points _instead of_
constructing a path.

Note that methods to functions might vary in how they
operate: whereas `box(Point(0, 0), 50, 50)` returns a
polygon (a list of points), `box(Point(0, 0), 50, 50,
:path)` adds a rectangle to the current path _and_ returns a
polygon. However, `box(Point(0, 0), 50, 50, 5 ... )`
constructs a path with Bézier-curved corners, so this
method doesn't return any vertex information - you'll have
to flatten the Béziers via [`getpathflat()`](@ref) or obtain the
path with intact Béziers via [`getpath()`](@ref).

The Luxor function [`getpath()`](@ref) retrieves the current
Cairo path and returns a _Cairo path object_, which you
could iterate through using code like this:

```
import Cairo
o = getpath()
x, y = currentpoint()
for e in o
    if e.element_type == Cairo.CAIRO_PATH_MOVE_TO
        (x, y) = e.points
        move(x, y)
    elseif e.element_type == Cairo.CAIRO_PATH_LINE_TO
        (x, y) = e.points
        # straight lines
        line(x, y)
        strokepath()
        circle(x, y, 1, :stroke)
    elseif e.element_type == Cairo.CAIRO_PATH_CURVE_TO
        (x1, y1, x2, y2, x3, y3) = e.points
        # Bézier control lines
        circle(x1, y1, 1, :stroke)
        circle(x2, y2, 1, :stroke)
        circle(x3, y3, 1, :stroke)
        move(x, y)
        curve(x1, y1, x2, y2, x3, y3)
        strokepath()
        (x, y) = (x3, y3) # update current point
    elseif e.element_type == Cairo.CAIRO_PATH_CLOSE_PATH
        closepath()
    else
        error("unknown CairoPathEntry " * repr(e.element_type))
        error("unknown CairoPathEntry " * repr(e.points))
    end
end
```

But the current Cairo path isn't otherwise accessible in Luxor.

### Polygons

A polygon isn't an existing Luxor struct or datatype either.
It always appears as a plain Vector (Array) of `Point`s.
There are no lines or curves, just 2D coordinates in the
form of `Point`s. When a polygon is eventually drawn, it's
converted into a path, and the points are usually connected
with short straight lines.

The [`pathtopoly()`](@ref) function extracts the current
path that Cairo is in the process of constructing and
returns an array of Vectors of points - a set of one or more
polygons (remember that a single path can contain multiple
shapes). Internally this function uses
[`getpathflat()`](@ref), which is similar to
[`getpath()`](@ref) but it returns a Cairo path object in
which all Bézier curve segments have been reduced to
sequences of short straight lines.

So:

```
circle(O, 100, :path)
p = pathtopoly()
poly(first(p), :stroke)
```

is more or less equivalent to:

```
ngon(O, 100, 129, 0, :stroke)    # a 129agon with radius 100
```
