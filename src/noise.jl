# adapted from https://gist.github.com/nowl/

const defaultpermutations = [208, 34, 231, 213, 32, 248, 233, 56, 161, 78, 24, 140,
71, 48, 140, 254, 245, 255, 247, 247, 40,  185, 248, 251, 245, 28, 124, 204,
204, 76, 36, 1, 107, 28, 234, 163, 202, 224, 245, 128, 167, 204,  9, 92, 217,
54, 239, 174, 173, 102, 193, 189, 190, 121, 100, 108, 167, 44, 43, 77, 180, 204,
8, 81,  70, 223, 11, 38, 24, 254, 210, 210, 177, 32, 81, 195, 243, 125, 8, 169,
112, 32, 97, 53, 195, 13,  203, 9, 47, 104, 125, 117, 114, 124, 165, 203, 181,
235, 193, 206, 70, 180, 174, 0, 167, 181, 41,  164, 30, 116, 127, 198, 245, 146,
87, 224, 149, 206, 57, 4, 192, 210, 65, 210, 129, 240, 178, 105, 228, 108, 245,
148, 140, 40, 35, 195, 38, 58, 65, 207, 215, 253, 65, 85, 208, 76, 62, 3, 237,
55, 89,  232, 50, 217, 64, 244, 157, 199, 121, 252, 90, 17, 212, 203, 149, 152,
140, 187, 234, 177, 73, 174,  193, 100, 192, 143, 97, 53, 145, 135, 19, 103, 13,
90, 135, 151, 199, 91, 239, 247, 33, 39, 145, 101, 120, 99, 3, 186, 86, 99, 41,
237, 203, 111, 79, 220, 135, 158, 42, 30, 154, 120, 67, 87, 167,  135, 176, 183,
191, 253, 115, 184, 21, 233, 58, 129, 233, 142, 39, 128, 211, 118, 137, 139,
255,  114, 20, 218, 113, 154, 27, 127, 246, 250, 1, 8, 198, 250, 209, 92, 222,
173, 21, 88, 102, 219]

mutable struct Noise
    table::Vector{Int64}
    seed::Int64
end

"""
    Noise()
    Noise(;seed=0)
    Noise(v; seed=0)

Create a Noise object. It contains:

+ `table` a table of 256 integers
+ `seed`  an integer seed value

If provided, `v` is an array of 256 values. You can use the provided
`initnoise()` function.

`seed` keyword is an integer that seeds the initial noise parameters.

Examples

```julia
Noise()
Noise(;seed=0)
Noise(initnoise(); seed=0)
```
"""
function Noise(v;
        seed=0)
    Noise(v, seed)
end

function Noise(;
        seed=0)
    Noise(defaultpermutations, seed=seed)
end

Base.broadcastable(x::Noise) = Ref(x)

"""
    initnoise()

Return an array of 256 integers between 0 and 255, suitable for use when
creating a Noise object.

For example:

```
Noise(initnoise()
```
"""
function initnoise()
    rand(0:255, 256)
end

function _n2(n::Noise, x::Int64, y::Int64)
    tmp =  n.table[mod1(y + n.seed, 256)]
    return n.table[mod1(tmp + x, 256)]
end

function _linearinterpolate(x, y, s)
    return x + s * (y - x)
end

function _fade(x, y, s)
    return _linearinterpolate(x, y, 6s^5 - 15s^4 + 10s^3)
end

function _getnoise(n::Noise, x, y)
    xt, xf     = fldmod(x, 1)
    yt, yf     = fldmod(y, 1)
    # This can overflow!
    xi = convert(Int64, xt)
    yi = convert(Int64, yt)
    s  = _n2(n, xi, yi)
    t  = _n2(n, xi + 1, yi)
    u  = _n2(n, xi, yi + 1)
    v  = _n2(n, xi + 1, yi + 1)
    l  = _fade(s, t, xf)
    h  = _fade(u, v, xf)
    return _fade(l, h, yf)
end

"""
    noise(n::Noise, x, y;
        frequency = 0.05,
        depth     = 1)

Get a value from the Noise object in `n` corresponding to `x` and `y`. It
returns a value between 0.0 and 1.0.

The keyword `frequency` determines the basic frequency of the noise. Values
around 0.005 give three or four peaks and troughs.

The keyword `depth` is an integer (from 1 up to about 30, you'll get integer
overflow eventually) that specifies the number of levels required. 1 produces
large smooth noise, 10 to 20 add finer detail.
"""
function noise(n::Noise, x, y;
        frequency = 0.05,
        depth     = 1)
    xa            = x * frequency
    ya            = y * frequency
    amplitude     = 1.0
    fin           = 0.0
    dv            = 0.0
    for i in 1:depth
        dv  += 256 * amplitude
        fin += _getnoise(n, xa, ya) * amplitude
        amplitude /= 2
        xa  *= 2
        ya  *= 2
    end
    return fin/dv
end
