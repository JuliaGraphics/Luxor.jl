# Transforms and matrices

For basic transformations of the drawing space, use `scale(sx, sy)`, `rotate(a)`, and `translate(tx, ty)`.

```@docs
scale
rotate
translate
```

The current matrix is a six element array, perhaps like this:

```
[1, 0, 0, 1, 0, 0]
```

`getmatrix()` gets the current matrix, `setmatrix(a)` sets the matrix to array `a`, and  `transform(a)` transforms the current matrix by 'multiplying' it with matrix `a`.

```@docs
getmatrix
setmatrix
transform
```
