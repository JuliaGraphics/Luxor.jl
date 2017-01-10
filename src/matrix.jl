"""
    getmatrix()

Get the current Cairo matrix. Returns an array of six float64 numbers:

- xx component of the affine transformation

- yx component of the affine transformation

- xy component of the affine transformation

- yy component of the affine transformation

- x0 translation component of the affine transformation

- y0 translation component of the affine transformation

Some basic matrix transforms:

- translate

`transform([1, 0, 0, 1, dx, dy])` shifts by `dx`, `dy`

- scale

`transform([fx 0 0 fy 0 0])` scales by `fx` and `fy`

- rotate

`transform([cos(a), -sin(a), sin(a), cos(a), 0, 0])` rotates around to `a` radians

    rotate around O: [c -s s c 0 0]

- shear

`transform([1 0 a 1 0 0])` shears in x direction by `a`
-  shear in y: [1  B 0  1 0 0]

- x-skew

`transform([1, 0, tan(a), 1, 0, 0])` skews in x by `a`

- y-skew

`transform([1, tan(a), 0, 1, 0, 0])` skews in y by `a`

- flip

`transform([fx, 0, 0, fy, centerx * (1 - fx), centery * (fy-1)])` flips with center at `centerx`/`centery`

- reflect

`transform([1 0 0 -1 0 0])` reflects in xaxis

`transform([-1 0 0 1 0 0])` reflects in yaxis

When a drawing is first created, the matrix looks like this:

    getmatrix() = [1.0, 0.0, 0.0, 1.0, 0.0, 0.0]

When the origin is moved to 400/400, it looks like this:

    getmatrix() = [1.0, 0.0, 0.0, 1.0, 400.0, 400.0]

To reset the matrix to the original:

    setmatrix([1.0, 0.0, 0.0, 1.0, 0.0, 0.0])

"""
function getmatrix()
    gm = Cairo.get_matrix(currentdrawing.cr)
    return([gm.xx, gm.yx, gm.xy, gm.yy, gm.x0, gm.y0])
end

"""
    setmatrix(m::Array)

Change the current Cairo matrix to matrix `m`. Use `getmatrix()` to get the current matrix.
"""
function setmatrix(m::Array)
    if eltype(m) != Float64
        m = map(Float64,m)
    end
    # some matrices make Cairo freak out and need reset. Not sure what the rules are yet…
    if length(m) < 6
        throw("didn't like that matrix $m: not enough values")
    elseif countnz(m) == 0
        throw("didn't like that matrix $m: too many zeroes")
    else
        cm = Cairo.CairoMatrix(m[1], m[2], m[3], m[4], m[5], m[6])
        Cairo.set_matrix(currentdrawing.cr, cm)
    end
end

"""
    transform(a::Array)

Modify the current matrix by multiplying it by matrix `a`.

For example, to skew the current state by 45 degrees in x and move by 20 in y direction:

    transform([1, 0, tand(45), 1, 0, 20])

Use `getmatrix()` to get the current matrix.
"""
function transform(a::Array)
    b = Cairo.get_matrix(currentdrawing.cr)
    setmatrix([
        (a[1] * b.xx)  + a[2]  * b.xy,             # xx
        (a[1] * b.yx)  + a[2]  * b.yy,             # yx
        (a[3] * b.xx)  + a[4]  * b.xy,             # xy
        (a[3] * b.yx)  + a[4]  * b.yy,             # yy
        (a[5] * b.xx)  + (a[6] * b.xy) + b.x0,     # x0
        (a[5] * b.yx)  + (a[6] * b.yy) + b.y0      # y0
    ])
end

"""
    rotationmatrix(a)

Return a 3 by 3 Julia matrix that will apply a rotation through `a` radians.
"""
function rotationmatrix(a)
    return ([cos(a)  -sin(a)  0.0 ;
             sin(a)   cos(a)  0.0 ;
             0.0         0.0  1.0 ])
end

"""
    translationmatrix(x, y)

Return a 3 by 3 Julia matrix that will apply a translation in `x` and `y`.
"""
function translationmatrix(x, y)
    return ([1.0   0.0   x ;
             0.0   1.0   y ;
             0.0   0.0   1.0 ])
end

"""
    scalingmatrix(sx, sy)

Return a 3 by 3 Julia matrix that will apply a scaling by `sx` and `sy`.
"""
function scalingmatrix(sx, sy)
    return ([sx 0.0  0.0 ;
           0.0   sy  0.0 ;
           0.0  0.0  1.0])
end

"""
    cairotojuliamatrix(c)

Return a 3 by 3 Julia matrix that's the equivalent of the six-element Cairo matrix in `c`.
"""
function cairotojuliamatrix(c::Array)
    return [c[1] c[3] c[5] ; c[2] c[4] c[6] ; 0.0 0.0 1.0]
end

"""
    juliatocairomatrix(c)

Return a six-element Cairo matrix 3 that's the equivalent of the 3 by 3 Julia matrix in `c`.
"""
function juliatocairomatrix(c::Matrix)
    return [c[1] c[2] c[4] c[5] c[7] c[8]]
end

"""
    getrotation(R::Matrix)

Get rotation of a Julia matrix:

        | a  b  tx |
    R = | c  d  ty |
        | 0  0  1  |

The rotation angle is `atan2(-b, a)` or `atan2(c, d)`.

Get the current Luxor rotation:

    getrotation()

"""
function getrotation(R::Matrix)
    # t = atan2(-R[4], R[1]) # should be the same as:
    t = atan2(R[2], R[5])
    return mod2pi(t)
end

function getrotation()
    getrotation(cairotojuliamatrix(getmatrix()))
end

"""
    getscale(R::Matrix)
    getscale()

Get the current scale of a Julia matrix, or the current Luxor scale.

Returns a tuple of x and y values.

"""
function getscale(R::Matrix)
    sx = hypot(R[1], R[2])
    sy = hypot(R[4], R[5])
    return (sx, sy)
end

function getscale()
    getscale(cairotojuliamatrix(getmatrix()))
end

"""
    gettranslation(R::Matrix)
    gettranslation()

Get the current translation of a Julia matrix, or the current Luxor translation.

Returns a tuple of x and y values.
"""
function gettranslation(R::Matrix)
    return (R[7], R[8])
end

function gettranslation()
    gettranslation(cairotojuliamatrix(getmatrix()))
end
