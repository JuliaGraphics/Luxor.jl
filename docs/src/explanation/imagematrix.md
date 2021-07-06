# Drawing as image matrix

# Images as matrices

While drawing, you can copy the current graphics in a drawing as a matrix of pixels, using the [`image_as_matrix`](@ref) function.

With the [`@imagematrix`](@ref) macro, you can create your drawing with vector graphics in the usual way, but the result is returned as a matrix. This example processes an ampersand in Images.jl.

```
using Luxor, Colors, Images, ImageFiltering

m = @imagematrix begin
        background("black")
        sethue("white")
        fontface("Georgia")
        fontsize(180)
        text("&", halign=:center, valign=:middle)
end 200 200

function convertmatrixtocolors(m)
    return convert.(Colors.RGBA, m)
end

img = convertmatrixtocolors(m)

imfilter(img, Kernel.gaussian(10))
```

![image matrix](../assets/figures/ampersand-matrix.png)

[`image_as_matrix`](@ref) returns a array of ARGB32 values. Each ARGB value encodes the Red, Green, Blue, and Alpha values of a pixel into a single 32 bit integer.

The next example draws a red rectangle, then copies the drawing into a matrix called `mat1`. Then it adds a blue triangle, and copies the updated drawing into `mat2`. In the second drawing, values from the two matrices are tested, and table cells are randomly colored depending on the corresponding values ... this is a primitive Boolean operation.

```@example
using Luxor, Colors, Random # hide
Random.seed!(42) # hide
Drawing(40, 40, :png)
origin()
background("black")
sethue("red")
box(Point(0, 0), 40, 15, :fill)
mat1 = image_as_matrix()
sethue("blue")
setline(10)
setopacity(0.6)
ngon(Point(0, 0), 10, 3, 0, :stroke)
mat2 = image_as_matrix()
finish()

# second drawing

Drawing(400, 400, "../assets/figures/image-drawings.svg")
background("grey20")
origin()
t = Table(40, 40, 4, 4)
sethue("white")
rc = CartesianIndices(mat1)
for i in rc
    r, c = Tuple(i)
    pixel1 = convert(Colors.RGBA, mat1[r, c])
    pixel2 = convert(Colors.RGBA, mat2[r, c])
    if red(pixel1) > .5 && blue(pixel2) > .5
        randomhue()
        box(t, r, c, :fillstroke)
    end
end
finish() # hide
nothing # hide
```

The first image (enlarged) shows the `mat1` matrix as red, `mat2` as blue.

![intermediate](../assets/figures/image-drawing-intermediate.png)

In the second drawing, a table with 1600 squares is colored according to the values in the matrices.

![image drawings](../assets/figures/image-drawings.svg)

(You can use `collect` to gather the re-interpreted values together.)

You can display the matrix using, for example, Images.jl.

```
using Luxor, Images

# in Luxor

Drawing(250, 250, :png)
origin()
background(randomhue()...)
sethue("red")
fontsize(200)
fontface("Georgia")
text("42", halign=:center, valign=:middle)
mat = image_as_matrix()
finish()

# in Images

img = RGB.(mat)
# img = Gray.(mat) # for greyscale

imfilter(img, Kernel.gaussian(10))
```

In Luxor:

![42 image array](../assets/figures/42.png)

In Images:

![42 image array](../assets/figures/42gaussian.png)
