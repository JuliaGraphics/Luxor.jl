```@meta
DocTestSetup = quote
    using Luxor, Colors
    end
```
# Playing with pixels

As well as working with PNG, SVG, and PDF drawings, Luxor lets you play directly with pixels, and combine these freely with vector graphics and text.

This section shows a short example of some functions you can use. You'll need the Images.jl package as well as Luxor.jl.

When you create a new Luxor drawing, you can choose to use the contents of an existing Julia array as the drawing surface.

```julia
using Luxor, Colors, Images
A = zeros(ARGB32, 400, 800)
Drawing(A)
```

```@setup example_1
using Luxor, Colors, Images
A = fill(ARGB32(0.1, 0.1, 0.1, 1.0), (400, 800))
Drawing(A)
```

```@example example_1
A # hide
```

The array should be a 2 x 2 matrix, where each element is an ARGB32. ARGB32 is a way of fitting four integers (using 8 bits for alpha, 8 bits for Red, 8 for Green, and 8 for Blue) into a 32-bit number between 0 and 4,294,967,296, ie a 32 bit unsigned integer. The ARGB32 type is provided by the Images.jl and Colors.jl packages.

You can set and get the values of pixels by treating the drawing like a standard Julia array. We can inspect pixels like this:

```julia
julia> A[10, 200]  # row 10, column 200
ARGB32(0.0N0f8,0.0N0f8,0.0N0f8,0.0N0f8)
```

and set them like this:

```julia
julia> A[10, 200] = colorant"red"
RGB{N0f8}(1.0, 0.0, 0.0)
```

or like this:

```julia
julia> A[200:250, 100:250] .= colorant"green"
julia> A[300:350, 50:450] .= colorant"blue"
julia > [A[rand(1:(400 * 800))] = RGB(rand(), rand(), rand()) for i in 1:800]
```

Because this is an array, rather than a PNG/SVG, we use Images.jl to display it:

```julia
using Images
A
```

```@setup example_3
using Luxor, Colors, Images
A = zeros(ARGB32, 400, 800)
Drawing(A)
A[10, 200] = colorant"red"
A[200:250, 100:250] .= colorant"green"
A[300:350, 50:450] .= colorant"blue"
[A[rand(1:(400 * 800))] = RGB(rand(), rand(), rand()) for i in 1:800]
```

```@example example_3
A # hide
```

Here's some code that sets the HSV color of each pixel to the value of some arbitrary maths function operating on complex numbers:

```julia
f(z) = (z + 3)^3 / ((z + 2im) * (z - 2im)^2)

function pixelcolor(r, c;
        rows = 100,
        cols = 100)
    z = rescale(r, 1, rows, -2π, 2π) + rescale(c, 2π, cols, -2π, 2π) * im
    n = f(z)
    h = 360rescale(angle(n), 0, 2π)
    s = abs(sin(π / 2 * real(f(z))))
    v = abs(sin(2π * real(f(z))))
    return HSV(h, s, v)
end
for r in 1:size(A, 1), c in 1:size(A, 2)
    A[r, c] = pixelcolor(r, c, rows = 400, cols = 800)
end
A
```

```@setup example_4
using Luxor, Images
A = zeros(ARGB32, 400, 800)
Drawing(A)
f(z) = (z + 3)^3 / ((z + 2im) * (z - 2im)^2)
function pixelcolor(r, c;
        rows=100,
        cols=100)
    z = rescale(r, 1, rows, -2π, 2π) + rescale(c, 2π, cols, -2π, 2π) * im
    n = f(z)
    h = 360rescale(angle(n), 0, 2π)
    s = abs(sin(π / 2 * real(f(z))))
    v = abs(sin(2π * real(f(z))))
    return HSV(h, s, v)
end
for r in 1:size(A, 1), c in 1:size(A, 2)
    A[r, c] = pixelcolor(r, c, rows=400, cols=800)
end
A
```
```@example example_4
A # hide
```

We can easily add vector graphics to this drawing. But first, let's look at the two coordinate systems that you can use.

## Rows and columns, height and width

Locations in arrays and images are typically specified with row and column values, or perhaps just a single index value. Because arrays are column-major in Julia, the address `[10, 200]` is "row 10, column 200".

Locations on plots and Luxor drawings are typically specified as Cartesian x and y coordinates. So `Point(10, 200)` would identify a point 10 units along the x-axis and 200 along the y-axis (which starts off pointing vertically down on the drawing, like most computer graphics systems). 

The origin point of an array or image is the first pixel - usually drawn at the top left. In Luxor, the origin point (0/0) of a drawing (if created by `Drawing()`) is also at the top left, until you move it, or use the `origin()` function. The `@draw` macros also set the origin at the centre of the drawing, for your convenience.

## The matrix

When you're combining array addresses and drawing coordinates, you might find it useful to define a transformation matrix that applies to all subsequent vector graphics, such that all points are converted from the conventional `x/across/width` - `y/down/height` convention used for vector graphics drawing, to the pixel array's `row/down/height`, `column/across/width` convention, as used for array access and image processing.

The `transform()` function here defines a matrix that flips the x and y coordinates, and shifts the origin to the center of the array. Now we can specify the location of some text (20 units above the bottom center edge of the drawing).

An additional benefit of this is that text is displayed correctly.

```julia
w, h = 800, 400
transform([0 1 1 0 h/2 w/2])
fontsize(18)
sethue("white")
text("f(z) = (z + 3)^3 / ((z + 2im) * (z - 2im)^2)",
    O + (0, h / 2 - 20), halign = :center)
```

```@setup example_5
using Luxor, Images
A = zeros(ARGB32, 400, 800)
Drawing(A)
f(z) = (z + 3)^3 / ((z + 2im) * (z - 2im)^2)
function pixelcolor(r, c;
    rows=100,
    cols=100)
    z = rescale(r, 1, rows, -2π, 2π) + rescale(c, 2π, cols, -2π, 2π) * im
    n = f(z)
    h = 360rescale(angle(n), 0, 2π)
    s = abs(sin(π / 2 * real(f(z)))) # * (sin(π * imag(f(z)))))
    v = abs(sin(2π * real(f(z))))
    return HSV(h, s, v)
end
for r in 1:size(A, 1), c in 1:size(A, 2)
    A[r, c] = pixelcolor(r, c, rows=400, cols=800)
end
w, h = 800, 400
transform([0 1 1 0 h/2 w/2])
fontsize(18)
sethue("white")
text("f(z) = (z + 3)^3 / ((z + 2im) * (z - 2im)^2)",
    O + (0, h / 2 - 20), halign=:center)
A # hide
```
```@example example_5
A # hide
```

A disadvantage is that BoundingBox() functions don't work, because they're not aware of transformation matrices.

## More vectors

You can continue to use the pixel array, while it's still defined. 
For example, create a new drawing, and this time add the array to the drawing using `placeimage()`, suitable for clipping by the Julia logo:

```@example example_5
w, h = 800, 400
Drawing(800, 400, :png)
origin()
placeimage(A, O - (w / 2, h / 2), alpha=0.3)
julialogo(centered=true, action=:clip)
placeimage(A, O - (w / 2, h / 2))
clipreset()
julialogo(centered=true, action=:path)
sethue("white")
strokepath()
finish()
preview()
```
