# Transforms and matrices

For basic transformations of the drawing space, use `scale(sx, sy)`, `rotate(a)`, and `translate(tx, ty)`.

`translate()` shifts the current axes by the specified amounts in x and y. It's relative and cumulative, rather than absolute:

```@example
using Luxor, Colors # hide
Drawing(600, 200, "assets/figures/translate.png") # hide
background("white") # hide
srand(1) # hide
setline(1) # hide
origin()
for i in range(0, 30, 6)
    sethue(HSV(i, 1, 1)) # from Colors
    setopacity(0.5)
    circle(0, 0, 40, :fillpreserve)
    setcolor("black")
    strokepath()
    translate(50, 0)
end
finish() # hide
nothing # hide
```

![translate](assets/figures/translate.png)

`scale(x, y)` or `scale(n)` scales the current workspace by the specified amounts. Again, it's relative to the current scale, not to the document's original.

```@example
using Luxor, Colors # hide
Drawing(400, 200, "assets/figures/scale.png") # hide
background("white") # hide
srand(1) # hide
setline(1) # hide
origin()
for i in range(0, 30, 6)
    sethue(HSV(i, 1, 1)) # from Colors
    circle(0, 0, 90, :fillpreserve)
    setcolor("black")
    strokepath()
    scale(0.8, 0.8)
end
finish() # hide
nothing # hide
```

![scale](assets/figures/scale.png)


`rotate()` rotates the current workspace by the specifed amount about the current 0/0 point. It's relative to the previous rotation, not to the document's original.

```@example
using Luxor # hide
Drawing(400, 200, "assets/figures/rotate.png") # hide
background("white") # hide
srand(1) # hide
setline(1) # hide
origin()
setopacity(0.7) # hide
for i in 1:8
    randomhue()
    squircle(Point(40, 0), 20, 30, :fillpreserve)
    sethue("black")
    strokepath()
    rotate(pi/4)
end
finish() # hide
nothing # hide
```

![rotate](assets/figures/rotate.png)

To return home after many changes, you can use `setmatrix([1, 0, 0, 1, 0, 0])` to reset the matrix to the default. `origin()` resets the matrix then moves the origin to the center of the page.

`rescale()` is a convenient utility function for linear interpolation, also called a "lerp".

```@docs
scale
rotate
translate
```

# Matrices and transformations

In Luxor, there's always a *current matrix*. It's a six element array:

```math
\begin{bmatrix}
1 & 0 & 0 \\
0 & 1 & 0 \\
\end{bmatrix}
```

which is usually handled in Julia/Cairo/Luxor as a simple vector/array:

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

`transform(a)` transforms the current workspace by 'multiplying' the current matrix with matrix `a`. For example, `transform([1, 0, xskew, 1, 50, 0])` skews the current matrix by `xskew` radians and moves it 50 in x and 0 in y.

```@example
using Luxor # hide
fname = "assets/figures/transform.png" # hide
pagewidth, pageheight = 450, 100 # hide
Drawing(pagewidth, pageheight, fname) # hide
origin() # hide
background("white") # hide
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
    boxtext(O, string(round(rad2deg(xskew), 1), "°"))
end

finish() # hide
nothing # hide
```

![transform](assets/figures/transform.png)

`getmatrix()` gets the current matrix, `setmatrix(a)` sets the matrix to array `a`.


```@docs
getmatrix
setmatrix
transform
crossproduct
blendmatrix
rotationmatrix
scalingmatrix
translationmatrix
```

Use the `getscale()`, `gettranslation()`, and `getrotation()` functions to find the current values of the current matrix. These can also find the values of arbitrary 3x3 matrices.

```@docs
getscale
gettranslation
getrotation
```

You can convert between the 6-element and 3x3 versions of a transformation matrix using the functions `cairotojuliamatrix()`
and `juliatocairomatrix()`.

```@docs
cairotojuliamatrix
juliatocairomatrix
```
