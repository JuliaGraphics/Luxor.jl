```@meta
DocTestSetup = quote
    using Luxor, Colors
    end
```

Graphics are placed on the current workspace according to the *current transformation matrix*. You can either modify this indirectly using functions, or set the matrix directly.

# Transformation functions

For basic transformations, use [`translate(tx, ty)`](@ref), [`scale(sx, sy)`](@ref), and [`rotate(a)`](@ref).

## Translation

`translate(pos)` (and `translate(x, y)`) shift the current origin to `pos` or by the specified amounts in x and y. It's relative and cumulative, rather than absolute:

```@example
using Luxor, Colors, Random # hide
Drawing(800, 200, "../assets/figures/translate.png") # hide
background("antiquewhite") # hide
Random.seed!(1) # hide
setline(1) # hide
origin()  # hide
for i in range(0, step=30, length=6)
    sethue(HSV(i, 1, 1)) # from Colors
    setopacity(0.5)
    circle(Point(0, 0), 40, :fillpreserve)
    setcolor("black")
    strokepath()
    translate(50, 0)
end
finish() # hide
nothing # hide
```

![translate](../assets/figures/translate.png)

## Scaling

`scale(x, y)` and `scale(n)` scale the current workspace by the specified amounts. It's relative to the current scale, not to the drawing's original.

```@example
using Luxor, Colors, Random # hide
Drawing(800, 250, "../assets/figures/scale.png") # hide
background("antiquewhite") # hide
Random.seed!(1) # hide
setline(1) # hide
origin()
for i in range(0, step=30, length=6)
    sethue(HSV(i, 1, 1)) # from Colors
    circle(Point(0, 0), 130, :fillpreserve)
    setcolor("black")
    strokepath()
    scale(0.8)
end
finish() # hide
nothing # hide
```

![scale](../assets/figures/scale.png)

## Rotation

[`rotate`](@ref) rotates the current workspace by the specified amount about the current 0/0 point. It's relative to the previous rotation - "rotate by".

```@example
using Luxor, Random # hide
Drawing(800, 200, "../assets/figures/rotate.png") # hide
background("antiquewhite") # hide
Random.seed!(1) # hide
setline(1) # hide
origin()
setopacity(0.7) # hide
for i in 1:8
    randomhue()
    squircle(Point(40, 0), 20, 30, :fillpreserve)
    sethue("black")
    strokepath()
    rotate(π/4)
end
finish() # hide
nothing # hide
```

![rotate](../assets/figures/rotate.png)

[`origin`](@ref) resets the matrix then moves the origin to the center of the page.

Use the [`getscale`](@ref), [`gettranslation`](@ref), and [`getrotation`](@ref) functions to find the current values.

To return home after many changes, you can use `setmatrix([1, 0, 0, 1, 0, 0])` to reset the matrix to the default.

## Linear interpolation of scalars

[`rescale`](@ref) is a convenient utility function for linear interpolation (also called “lerp”). An easy way to visualize it is by imagining two number lines:

```@setup lerp
using Luxor

reddot(pos) = @layer begin
sethue("red")
circle(pos, 8, :fill)
end

diagram = @drawsvg begin
    background("antiquewhite")
    sethue("black")
    setline(1)
    fontsize(14)

    n = 35
    dot′′ = between(O + (-200, 40), O + (200, 40), rescale(n, 30, 40, 0, 1))
    reddot(dot′′)

    text(string("n = $(n)"), O + (0, -60), halign=:center)
    text("rescale(n, 30, 40, 1, 2) = $(rescale(n, 30, 40, 1, 2))", dot′′ + (0, -60), halign=:center)

    pts = (O + (-200, 40), O + (200, 40))

    tickline(pts...,
        startnumber = 1,
        finishnumber = 2,        
        minor=0,
        major=9)
    tickline(pts...,
        startnumber = 30,
        finishnumber = 40,        
        minor=0,
        major=9,
        major_tick_function = (n, pos; startnumber=30, finishnumber=40, nticks=10) -> begin
            @layer begin
                translate(pos)
                line(O, O + polar(5, 3π/2), :stroke)
                k = rescale(n, 0, nticks - 1, startnumber, finishnumber)
                ticklength = get_fontsize() * 1.3
                text("$(round(k, digits=2))", O + (0, -ticklength), halign=:center, valign=:middle, angle = -getrotation())
            end
        end)
    finish()
end 800 200
```

```@example lerp
diagram # hide
```

## Scaling of line thickness

Line thicknesses are not scaled by default. For example, with a current line thickness set by `setline(1)`, lines drawn before and after `scale(2)` will be the same thickness. If you want line thicknesses to respond to the current scale, so that a line thickness of 1 is scaled by `n` after calls to `scale(n)`, you can call `[setstrokescale(true)`](@ref) to enable stroke scaling, and `setstrokescale(false}` to disable it. You can also enable stroke scaling when creating a new `Drawing` by passing the named argument `strokescale` during `Drawing` construction (i.e., `Drawing(400, 400, strokescale=true)`).

## Matrices

In Luxor, there's always a *current matrix* that determines how coordinates are interpreted in the current workspace. It's a six element array:

```math
\begin{bmatrix}
1 & 0 & 0 \\
0 & 1 & 0 \\
\end{bmatrix}
```

which is usually handled in Julia/Cairo/Luxor as a simple vector (array):

```
julia> getmatrix()
6-element Array{Float64,1}:
   1.0
   0.0
   0.0
   1.0
   0.0
   0.0
```

[`transform(a)`](@ref) transforms the current workspace by 'multiplying' the current matrix with matrix `a`. For example, `transform([1, 0, xskew, 1, 50, 0])` skews the current matrix by `xskew` radians and moves it 50 in x and 0 in y.

```@example
using Luxor # hide
fname = "../assets/figures/transform.png" # hide
pagewidth, pageheight = 800, 100 # hide
Drawing(pagewidth, pageheight, fname) # hide
origin() # hide
background("antiquewhite") # hide
translate(-200, 0) # hide

function boxtext(p, t)
    sethue("grey30")
    box(p, 30, 50, :fill)
    sethue("white")
    textcentered(t, p)
end

for i in 0:5
    xskew = tand(i * 5.0)
    transform([1, 0, xskew, 1, 50, 0])
    boxtext(O, string(round(rad2deg(xskew), digits=1), "°"))
end

finish() # hide
nothing # hide
```

![transform](../assets/figures/transform.png)

[`getmatrix`](@ref) gets the current matrix, `setmatrix(a)` sets the matrix to array `a`.

Other functions include [`getmatrix`](@ref),
[`setmatrix`](@ref), [`transform`](@ref), [`crossproduct`](@ref), [`blendmatrix`](@ref), [`rotationmatrix`](@ref), [`scalingmatrix`](@ref), and [`translationmatrix`](@ref).

Use the [`getscale`](@ref), [`gettranslation`](@ref), and [`getrotation`](@ref) functions to find the current values of the current matrix. These can also find the values of arbitrary 3x3 matrices.

You can convert between the 6-element and 3x3 versions of a transformation matrix using the functions [`cairotojuliamatrix`](@ref)
and [`juliatocairomatrix`](@ref).

## World position

If you use [`translate`](@ref) to move the origin to different places on a drawing, you can use [`getworldposition`](@ref) to find the "true" world coordinates of points. In the following example, we temporarily translate to a random point, and "drop a pin" that remembers the new origin in terms of the drawing's world coordinates. After the temporary translation is over, we have a record of where it was.

```@example
using Luxor, Random # hide
Drawing(600, 400, "../assets/figures/getworldposition.png") # hide
background("antiquewhite") # hide
Random.seed!(3) # hide
setline(1) # hide
origin()

@layer begin
    translate(0.7rand(BoundingBox()))
    pin = getworldposition()
end

label("you went ... ", :n, O, offset = 10)
label("... here", :n, pin, offset = 20)
arrow(O, pin)

finish() # hide
nothing # hide
```

![translate](../assets/figures/getworldposition.png)

## Coordinate conventions

In Luxor, by default, the y axis points downwards, and the x axis points to the right.

There are basically two main conventions for computer graphics:

- mathematical illustrations, such as graphs, figures, Plots.jl, plots, etc., use the "y upwards" convention

- most computer graphics systems (HTML, SVG, Processing, Cairo, Luxor, image processing, most GUIs, etc) use "y downwards" convention

```@setup conventions
using Luxor
diagram = @drawsvg begin
    background("antiquewhite")
    table = Table(1, 2, 300, 400)
    fontsize(16)
    @layer begin
        translate(table[1])
        arrow(O, O  + (0, -200))
        text("y", O  + (20, -200))
        arrow(O, O  + (200, 0))
        text("x", O  + (200, 20))
    end

    @layer begin
        translate(table[2])        
        rulers()
    end

end 800 450
```

```@example conventions
diagram
```

You could use a transformation matrix to reflect the Luxor drawing space in the x-axis.

```@example
using Luxor # hide
@drawsvg begin # hide
    background("antiquewhite") # hide
    table = Table(1, 2, 300, 400) # hide
    fontsize(30) # hide
    pts = (Point(0, 0), Point(50, 100))
    @layer begin
        translate(table[1])
        arrow(pts...)
        rulers()
    end

    @layer begin
        translate(table[2])
        transform([1 0 0 -1 0 0])               # <--
        arrow(pts...)
        rulers()
    end
end 800 450 # hide
```

!!! note

    If you do this, all your text will be incorrectly drawn, so you'd need to use enclose text functions with antoher matrix transformation.

## Advanced transformations

For more powerful transformations, consider using Julia packages which are designed specifically for the purpose.

The following example sets up some transformations, which can then be composed in the correct order to transform points.

```
rawpts = [
    [0.1, 0.1],
    [0.1, -0.1],
    [-0.1, -0.1],
    [-0.1, 0.1]
]

using CoordinateTransformations, Rotations, StaticArrays, LinearAlgebra

function transform_point(pt, transformation)
    x, y, _ = transformation(SVector(pt[1], pt[2], 1.0))
    return Point(x, y)
end

𝕊1 = LinearMap(UniformScaling(60))
𝕋1 = Translation(20, 30, 0)
ℝ1 = LinearMap(RotZ(π/3))
pts = map(pt -> transform_point(pt, 𝕋1 ∘ ℝ1 ∘ 𝕊1), rawpts)
...

```
