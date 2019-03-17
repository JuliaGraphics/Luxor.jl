# noise, using OpenSimplex algorithm (patent free)

using Random

"""
    seednoise(seed::T=42) where T <: Integer

Change the initial seed value for noise generation.

```
seednoise()
seednoise(12)
```
"""
function seednoise(seed::T=42) where T <: Integer
    initsimplexnoise(seed)
end

"""
    noise(x)          ; detail = 1, persistence = 1.0) # 1D
    noise(x, y)       ; detail = 1, persistence = 1.0) # 2D
    noise(x, y, z)    ; detail = 1, persistence = 1.0) # 3D
    noise(x, y, z, w) ; detail = 1, persistence = 1.0) # 4D

Generate a noise value between 0.0 and 1.0 corresponding to the `x`, `y`,
`z`, and `w` values. An `x` value on its own produces 1D noise, `x` and `y`
make 2D noise, and so on.

The `detail` value is an integer (>= 1) specifying how many octaves of noise
you want.

The `persistence` value, typically between 0.0 and 1.0, controls how quickly the
amplitude diminishes for each successive octave for values of `detail` greater
than 1.
"""
noise(x; detail::T = 1, persistence = 1.0) where T <: Integer =
    _octaves([x], octaves=detail, persistence=persistence)

noise(x, y; detail::T = 1, persistence = 1.0) where T <: Integer =
    _octaves([x, y], octaves=detail, persistence=persistence)

noise(x, y, z; detail::T = 1, persistence = 1.0) where T <: Integer =
    _octaves([x, y, z], octaves=detail, persistence=persistence)

noise(x, y, z, w; detail::T = 1, persistence = 1.0) where T <: Integer =
    _octaves([x, y, z, w], octaves=detail, persistence=persistence)

# call simplexnoise on values in array
# coords is [x] or [x, y] or [x, y, z] or [x, y, z, w]
function _octaves(coords::Array{T, 1} where T <: Real;
        octaves::Int = 1,
        persistence=1.0)
    total     = 0.0
    frequency = 1.0
    amplitude = 1.0
    maxval    = 0.0
    # TODO this seems very clumsy to duplicate the loop code like this?
    l = length(coords)
    if l == 1
        for i in 1:octaves
            total += simplexnoise(coords[1] * frequency) * amplitude
            maxval += amplitude
            amplitude *= persistence
            frequency *= 2
        end
    elseif l == 2
        for i in 1:octaves
            total += simplexnoise(coords[1] * frequency, coords[2] * frequency) * amplitude
            maxval += amplitude
            amplitude *= persistence
            frequency *= 2
        end
    elseif l == 3
        for i in 1:octaves
            total += simplexnoise(coords[1] * frequency, coords[2] * frequency, coords[3] * frequency) * amplitude
            maxval += amplitude
            amplitude *= persistence
            frequency *= 2
        end
    elseif l == 4
        for i in 1:octaves
            total += simplexnoise(coords[1] * frequency, coords[2] * frequency, coords[3] * frequency, coords[4] * frequency) * amplitude
            maxval += amplitude
            amplitude *= persistence
            frequency *= 2
        end
    end
    return total / maxval
end

# The rest of this file is the original OpenSimplexNoise code.
# I converted it to Julia but I don't understand it all... [cormullion]

# OpenSimplex Noise
# by Kurt Spencer
#
# v1.1 (October 5, 2014)
# - Added 2D and 4D implementations.
# - Proper gradient sets for all dimensions, from a
#   dimensionally-generalizable scheme with an actual
#   rhyme and reason behind it.
# - Removed default permutation array in favor of
#   default seed.
# - Changed seed-based constructor to be independent
#   of any particular randomization library, so results
#   will be the same when ported to other languages.

const STRETCH_CONSTANT_2D = -0.211324865405187    # (1/sqrt(2+1)-1)/2
const SQUISH_CONSTANT_2D  =  0.366025403784439    # (sqrt(2+1)-1)/2
const STRETCH_CONSTANT_3D = -0.16666              # (1/sqrt(3+1)-1)/3
const SQUISH_CONSTANT_3D  =  0.333333             # (sqrt(3+1)-1)/3
const STRETCH_CONSTANT_4D = -0.138196601125011    # (1/sqrt(4+1)-1)/4
const SQUISH_CONSTANT_4D  =  0.309016994374947    # (sqrt(4+1)-1)/4

const NORM_CONSTANT_2D    = 47
const NORM_CONSTANT_3D    = 103
const NORM_CONSTANT_4D    = 30

const DEFAULT_SEED        = 0

# Gradients for 2D. They approximate the directions to the
# vertices of an octagon from the center.

const gradients2D = Int8[
 5,  2,    2,  5,
-5,  2,   -2,  5,
 5, -2,    2, -5,
-5, -2,   -2, -5]

# Gradients for 3D. They approximate the directions to the
# vertices of a rhombicuboctahedron from the center, skewed so
# that the triangular and square facets can be inscribed inside
# circles of the same radius.

const gradients3D = Int8[
-11,  4,  4,     -4,  11,  4,    -4,  4,  11,
 11,  4,  4,      4,  11,  4,     4,  4,  11,
-11, -4,  4,     -4, -11,  4,    -4, -4,  11,
 11, -4,  4,      4, -11,  4,     4, -4,  11,
-11,  4, -4,     -4,  11, -4,    -4,  4, -11,
 11,  4, -4,      4,  11, -4,     4,  4, -11,
-11, -4, -4,     -4, -11, -4,    -4, -4, -11,
 11, -4, -4,      4, -11, -4,     4, -4, -11]

# Gradients for 4D. They approximate the directions to the
# vertices of a disprismatotesseractihexadecachoron from the center,
# skewed so that the tetrahedral and cubic facets can be inscribed inside
# spheres of the same radius.

# [yes, a disprismatotesseractihexadecachoron !]

const gradients4D = Int8[
 3,  1,  1,  1,      1,  3,  1,  1,      1,  1,  3,  1,      1,  1,  1,  3,
-3,  1,  1,  1,     -1,  3,  1,  1,     -1,  1,  3,  1,     -1,  1,  1,  3,
 3, -1,  1,  1,      1, -3,  1,  1,      1, -1,  3,  1,      1, -1,  1,  3,
-3, -1,  1,  1,     -1, -3,  1,  1,     -1, -1,  3,  1,     -1, -1,  1,  3,
 3,  1, -1,  1,      1,  3, -1,  1,      1,  1, -3,  1,      1,  1, -1,  3,
-3,  1, -1,  1,     -1,  3, -1,  1,     -1,  1, -3,  1,     -1,  1, -1,  3,
 3, -1, -1,  1,      1, -3, -1,  1,      1, -1, -3,  1,      1, -1, -1,  3,
-3, -1, -1,  1,     -1, -3, -1,  1,     -1, -1, -3,  1,     -1, -1, -1,  3,
 3,  1,  1, -1,      1,  3,  1, -1,      1,  1,  3, -1,      1,  1,  1, -3,
-3,  1,  1, -1,     -1,  3,  1, -1,     -1,  1,  3, -1,     -1,  1,  1, -3,
 3, -1,  1, -1,      1, -3,  1, -1,      1, -1,  3, -1,      1, -1,  1, -3,
-3, -1,  1, -1,     -1, -3,  1, -1,     -1, -1,  3, -1,     -1, -1,  1, -3,
 3,  1, -1, -1,      1,  3, -1, -1,      1,  1, -3, -1,      1,  1, -1, -3,
-3,  1, -1, -1,     -1,  3, -1, -1,     -1,  1, -3, -1,     -1,  1, -1, -3,
 3, -1, -1, -1,      1, -3, -1, -1,      1, -1, -3, -1,      1, -1, -1, -3,
-3, -1, -1, -1,     -1, -3, -1, -1,     -1, -1, -3, -1,     -1, -1, -1, -3]

function extrapolate(xsb::Int, ysb::Int, dx::Float64, dy::Float64)
    index::Int = perm[1 + (perm[1 + xsb & 0xFF] + ysb) & 0xFF] & 0x0E
    return gradients2D[mod1(1 + index, end)]     * dx +
           gradients2D[mod1(1 + index + 1, end)] * dy
end

function extrapolate(xsb::Int, ysb::Int, zsb::Int, dx, dy, dz)
    index::Int = permGradIndex3D[1 + (perm[1 + (perm[1 + xsb & 0xFF] + ysb) & 0xFF] + zsb) & 0xFF]
    return gradients3D[mod1(index, end)]     * dx +
           gradients3D[mod1(1 + index + 1, end)] * dy +
           gradients3D[mod1(1 + index + 2, end)] * dz
end

function extrapolate(xsb::Int, ysb::Int, zsb::Int, wsb::Int, dx, dy, dz, dw)
    index::Int = perm[1 + (perm[1 + (perm[1 + (perm[1 + xsb & 0xFF] + ysb) & 0xFF] + zsb) & 0xFF] + wsb) & 0xFF] & 0xFC
    return gradients4D[mod1(index, end)]  * dx +
           gradients4D[mod1(1 + index + 1, end)] * dy +
           gradients4D[mod1(1 + index + 2, end)] * dz +
           gradients4D[mod1(1 + index + 3, end)] * dw
end

###############################################################################
# Initializing the random stuff

# I couldn't get the original's wacky bit twiddling and overflow random code to
# produce nice results. So I'm just using Julia's standard random number
# generation here...
# TODO Investigate the original Linear Congruential Generators approach to sowing
# seeds...

# Initialize the two main arrays that are used by all noise functions

const perm            = Array{Int8}(undef, 256)
const permGradIndex3D = Array{Int8}(undef, 256)

function initnoise(seed::Int=42)
    for i in 1:256
        perm[i]            = rand(Int8)
        permGradIndex3D[i] = rand(Int8)
    end
end

initnoise()

###############################################################################
#
# 1D OpenSimplex Noise is really 2D noise
simplexnoise(x) = simplexnoise(x, 0)
#
###############################################################################



###############################################################################
#
# 2D OpenSimplex Noise
#
# comments from original Java source
# TODO convert to Julia properly
###############################################################################
function simplexnoise(x, y)
    # Place input coordinates onto grid.
    stretchOffset = (x + y) * STRETCH_CONSTANT_2D
    xs = x + stretchOffset
    ys = y + stretchOffset

    # Floor to get grid coordinates of rhombus (stretched square) super-cell origin.
    xsb = convert(Int, floor(xs))
    ysb = convert(Int, floor(ys))

    # Skew out to get actual coordinates of rhombus origin. We'll need these later.
    squishOffset = (xsb + ysb) * SQUISH_CONSTANT_2D
    xb = xsb + squishOffset
    yb = ysb + squishOffset

    # Compute grid coordinates relative to rhombus origin.
    xins = xs - xsb
    yins = ys - ysb

    # Sum those together to get a value that determines which region we're in.
    inSum = xins + yins

    # Positions relative to origin point.
    dx0 = x - xb
    dy0 = y - yb

    # We'll be defining these inside the next block and using them afterwards.
    # dx_ext, dy_ext, xsv_ext, ysv_ext

    value = 0.0

    # Contribution (1,0)
    dx1 = dx0 - 1 - SQUISH_CONSTANT_2D
    dy1 = dy0 - 0 - SQUISH_CONSTANT_2D
    attn1 = 2 - dx1 * dx1 - dy1 * dy1
    if attn1 > 0
        attn1 *= attn1
        value += attn1 * attn1 * extrapolate(xsb + 1, ysb + 0, dx1, dy1)
    end

    # Contribution (0,1)
    dx2 = dx0 - 0 - SQUISH_CONSTANT_2D
    dy2 = dy0 - 1 - SQUISH_CONSTANT_2D
    attn2 = 2 - dx2 * dx2 - dy2 * dy2
    if attn2 > 0
        attn2 *= attn2
        value += attn2 * attn2 * extrapolate(xsb + 0, ysb + 1, dx2, dy2)
    end

    if inSum <= 1 # We're inside the triangle (2-Simplex) at (0,0)
        zins = 1 - inSum
        if (zins > xins) || (zins > yins) # (0,0) is one of the closest two triangular vertices
            if xins > yins
                xsv_ext = xsb + 1
                ysv_ext = ysb - 1
                dx_ext = dx0 - 1
                dy_ext = dy0 + 1
            else
                xsv_ext = xsb - 1
                ysv_ext = ysb + 1
                dx_ext = dx0 + 1
                dy_ext = dy0 - 1
            end
        else # (1,0) and (0,1) are the closest two vertices.
            xsv_ext = xsb + 1
            ysv_ext = ysb + 1
            dx_ext = dx0 - 1 - 2 * SQUISH_CONSTANT_2D
            dy_ext = dy0 - 1 - 2 * SQUISH_CONSTANT_2D
        end
    else # We're inside the triangle (2-Simplex) at (1,1)
        zins = 2 - inSum
        if (zins < xins) || (zins < yins) # (0,0) is one of the closest two triangular vertices
            if xins > yins
                xsv_ext = xsb + 2
                ysv_ext = ysb + 0
                dx_ext = dx0 - 2 - 2 * SQUISH_CONSTANT_2D
                dy_ext = dy0 + 0 - 2 * SQUISH_CONSTANT_2D
            else
                xsv_ext = xsb + 0
                ysv_ext = ysb + 2
                dx_ext = dx0 + 0 - 2 * SQUISH_CONSTANT_2D
                dy_ext = dy0 - 2 - 2 * SQUISH_CONSTANT_2D
            end
        else  # (1,0) and (0,1) are the closest two vertices.
            dx_ext = dx0
            dy_ext = dy0
            xsv_ext = xsb
            ysv_ext = ysb
        end
        xsb += 1
        ysb += 1
        dx0 = dx0 - 1 - 2 * SQUISH_CONSTANT_2D
        dy0 = dy0 - 1 - 2 * SQUISH_CONSTANT_2D
    end

    # Contribution (0,0) or (1,1)
    attn0 = 2 - dx0 * dx0 - dy0 * dy0
    if attn0 > 0
        attn0 *= attn0
        value += attn0 * attn0 * extrapolate(xsb, ysb, dx0, dy0)
    end

    # Extra Vertex
    attn_ext = 2 - dx_ext * dx_ext - dy_ext * dy_ext
    if attn_ext > 0
        attn_ext *= attn_ext
        value += attn_ext * attn_ext * extrapolate(xsv_ext, ysv_ext, dx_ext, dy_ext)
    end

    # convert to [0, 1]
    res = value / NORM_CONSTANT_2D
    return clamp((res + 1) / 2, 0.0, 1.0)
end

# 3D OpenSimplex Noise.
# TODO convert to Julia properly
function simplexnoise(x, y, z)
    # Place input coordinates on simplectic honeycomb.
    stretchOffset = (x + y + z) * STRETCH_CONSTANT_3D
    xs = x + stretchOffset
    ys = y + stretchOffset
    zs = z + stretchOffset

    # Floor to get simplectic honeycomb coordinates of rhombohedron (stretched cube) super-cell origin.
    xsb = convert(Int, floor(xs))
    ysb = convert(Int, floor(ys))
    zsb = convert(Int, floor(zs))

    # Skew out to get actual coordinates of rhombohedron origin. We'll need these later.
    squishOffset = (xsb + ysb + zsb) * SQUISH_CONSTANT_3D
    xb = xsb + squishOffset
    yb = ysb + squishOffset
    zb = zsb + squishOffset

    # Compute simplectic honeycomb coordinates relative to rhombohedral origin.
    xins = xs - xsb
    yins = ys - ysb
    zins = zs - zsb

    # Sum those together to get a value that determines which region we're in.
    inSum = xins + yins + zins

    # Positions relative to origin point.
    dx0 = x - xb
    dy0 = y - yb
    dz0 = z - zb

    # We'll be defining these inside the next block and using them afterwards.
    # dx_ext0, dy_ext0, dz_ext0
    # dx_ext1, dy_ext1, dz_ext1
    # int xsv_ext0, ysv_ext0, zsv_ext0
    # int xsv_ext1, ysv_ext1, zsv_ext1
    value = 0.0

    if inSum <= 1 # We're inside the tetrahedron (3-Simplex) at (0,0,0)
        # Determine which two of (0,0,1), (0,1,0), (1,0,0) are closest.
        aPoint = 0x01
        aScore = xins
        bPoint = 0x02
        bScore = yins
        if (aScore >= bScore) && (zins > bScore)
            bScore = zins
            bPoint = 0x04
        elseif (aScore < bScore) && (zins > aScore)
            aScore = zins
            aPoint = 0x04
        end
        # Now we determine the two lattice points not part of the tetrahedron that may contribute.
        # This depends on the closest two tetrahedral vertices, including (0,0,0)
        wins = 1 - inSum
        if (wins > aScore) || (wins > bScore) # (0,0,0) is one of the closest two tetrahedral vertices.
            c = (bScore > aScore) ? bPoint : aPoint # Our other closest vertex is the closest out of a and b.
            if (c & 0x01) == 0
                xsv_ext0 = xsb - 1
                xsv_ext1 = xsb
                dx_ext0 = dx0 + 1
                dx_ext1 = dx0
            else
                xsv_ext0 = xsv_ext1 = xsb + 1
                dx_ext0 = dx_ext1 = dx0 - 1
            end
            if (c & 0x02) == 0
                ysv_ext0 = ysv_ext1 = ysb
                dy_ext0 = dy_ext1 = dy0
                if (c & 0x01) == 0
                    ysv_ext1 -= 1
                    dy_ext1 += 1
                else
                    ysv_ext0 -= 1
                    dy_ext0 += 1
                end
            else
                ysv_ext0 = ysv_ext1 = ysb + 1
                dy_ext0 = dy_ext1 = dy0 - 1
            end
            if (c & 0x04) == 0
                zsv_ext0 = zsb
                zsv_ext1 = zsb - 1
                dz_ext0 = dz0
                dz_ext1 = dz0 + 1
            else
                zsv_ext0 = zsv_ext1 = zsb + 1
                dz_ext0 = dz_ext1 = dz0 - 1
            end
        else  # (0,0,0) is not one of the closest two tetrahedral vertices.
            c = (aPoint | bPoint) # Our two extra vertices are determined by the closest two.
            if (c & 0x01) == 0
                xsv_ext0 = xsb
                xsv_ext1 = xsb - 1
                dx_ext0 = dx0 - 2 * SQUISH_CONSTANT_3D
                dx_ext1 = dx0 + 1 - SQUISH_CONSTANT_3D
            else
                xsv_ext0 = xsv_ext1 = xsb + 1
                dx_ext0 = dx0 - 1 - 2 * SQUISH_CONSTANT_3D
                dx_ext1 = dx0 - 1 - SQUISH_CONSTANT_3D
            end
            if (c & 0x02) == 0
                ysv_ext0 = ysb
                ysv_ext1 = ysb - 1
                dy_ext0 = dy0 - 2 * SQUISH_CONSTANT_3D
                dy_ext1 = dy0 + 1 - SQUISH_CONSTANT_3D
            else
                ysv_ext0 = ysv_ext1 = ysb + 1
                dy_ext0 = dy0 - 1 - 2 * SQUISH_CONSTANT_3D
                dy_ext1 = dy0 - 1 - SQUISH_CONSTANT_3D
            end
            if (c & 0x04) == 0
                zsv_ext0 = zsb
                zsv_ext1 = zsb - 1
                dz_ext0 = dz0 - 2 * SQUISH_CONSTANT_3D
                dz_ext1 = dz0 + 1 - SQUISH_CONSTANT_3D
            else
                zsv_ext0 = zsv_ext1 = zsb + 1
                dz_ext0 = dz0 - 1 - 2 * SQUISH_CONSTANT_3D
                dz_ext1 = dz0 - 1 - SQUISH_CONSTANT_3D
            end
        end
        # Contribution (0,0,0)
        attn0 = 2 - dx0 * dx0 - dy0 * dy0 - dz0 * dz0
        if attn0 > 0
            attn0 *= attn0
            value += attn0 * attn0 * extrapolate(xsb + 0, ysb + 0, zsb + 0, dx0, dy0, dz0)
        end
        # Contribution (1,0,0)
        dx1 = dx0 - 1 - SQUISH_CONSTANT_3D
        dy1 = dy0 - 0 - SQUISH_CONSTANT_3D
        dz1 = dz0 - 0 - SQUISH_CONSTANT_3D
        attn1 = 2 - dx1 * dx1 - dy1 * dy1 - dz1 * dz1
        if attn1 > 0
            attn1 *= attn1
            value += attn1 * attn1 * extrapolate(xsb + 1, ysb + 0, zsb + 0, dx1, dy1, dz1)
        end
        # Contribution (0,1,0)
        dx2 = dx0 - 0 - SQUISH_CONSTANT_3D
        dy2 = dy0 - 1 - SQUISH_CONSTANT_3D
        dz2 = dz1
        attn2 = 2 - dx2 * dx2 - dy2 * dy2 - dz2 * dz2
        if attn2 > 0
            attn2 *= attn2
            value += attn2 * attn2 * extrapolate(xsb + 0, ysb + 1, zsb + 0, dx2, dy2, dz2)
        end
        # Contribution (0,0,1)
        dx3 = dx2
        dy3 = dy1
        dz3 = dz0 - 1 - SQUISH_CONSTANT_3D
        attn3 = 2 - dx3 * dx3 - dy3 * dy3 - dz3 * dz3
        if attn3 > 0
            attn3 *= attn3
            value += attn3 * attn3 * extrapolate(xsb + 0, ysb + 0, zsb + 1, dx3, dy3, dz3)
        end
    elseif inSum >= 2  # We're inside the tetrahedron (3-Simplex) at (1,1,1)
        # Determine which two tetrahedral vertices are the closest, out of (1,1,0), (1,0,1), (0,1,1) but not (1,1,1).
        aPoint = 0x06
        aScore = xins
        bPoint = 0x05
        bScore = yins
        if (aScore <= bScore) && (zins < bScore)
            bScore = zins
            bPoint = 0x03
        elseif (aScore > bScore) && (zins < aScore)
            aScore = zins
            aPoint = 0x03
        end
        # Now we determine the two lattice points not part of the tetrahedron that may contribute.
        # This depends on the closest two tetrahedral vertices, including (1,1,1)
        wins = 3 - inSum
        if wins < aScore || wins < bScore  # (1,1,1) is one of the closest two tetrahedral vertices.
            c = (bScore < aScore ? bPoint : aPoint) # Our other closest vertex is the closest out of a and b.
            if (c & 0x01) != 0
                xsv_ext0 = xsb + 2
                xsv_ext1 = xsb + 1
                dx_ext0 = dx0 - 2 - 3 * SQUISH_CONSTANT_3D
                dx_ext1 = dx0 - 1 - 3 * SQUISH_CONSTANT_3D
            else
                xsv_ext0 = xsv_ext1 = xsb
                dx_ext0 = dx_ext1 = dx0 - 3 * SQUISH_CONSTANT_3D
            end
            if (c & 0x02) != 0
                ysv_ext0 = ysv_ext1 = ysb + 1
                dy_ext0 = dy_ext1 = dy0 - 1 - 3 * SQUISH_CONSTANT_3D
                if (c & 0x01) != 0
                    ysv_ext1 += 1
                    dy_ext1 -= 1
                else
                    ysv_ext0 += 1
                    dy_ext0 -= 1
                end
            else
                ysv_ext0 = ysv_ext1 = ysb
                dy_ext0 = dy_ext1 = dy0 - 3 * SQUISH_CONSTANT_3D
            end
            if (c & 0x04) != 0
                zsv_ext0 = zsb + 1
                zsv_ext1 = zsb + 2
                dz_ext0 = dz0 - 1 - 3 * SQUISH_CONSTANT_3D
                dz_ext1 = dz0 - 2 - 3 * SQUISH_CONSTANT_3D
            else
                zsv_ext0 = zsv_ext1 = zsb
                dz_ext0 = dz_ext1 = dz0 - 3 * SQUISH_CONSTANT_3D
            end
        else  # (1,1,1) is not one of the closest two tetrahedral vertices.
            c = (aPoint & bPoint) # Our two extra vertices are determined by the closest two.
            if (c & 0x01) != 0
                xsv_ext0 = xsb + 1
                xsv_ext1 = xsb + 2
                dx_ext0 = dx0 - 1 - SQUISH_CONSTANT_3D
                dx_ext1 = dx0 - 2 - 2 * SQUISH_CONSTANT_3D
            else
                xsv_ext0 = xsv_ext1 = xsb
                dx_ext0 = dx0 - SQUISH_CONSTANT_3D
                dx_ext1 = dx0 - 2 * SQUISH_CONSTANT_3D
            end
            if (c & 0x02) != 0
                ysv_ext0 = ysb + 1
                ysv_ext1 = ysb + 2
                dy_ext0 = dy0 - 1 - SQUISH_CONSTANT_3D
                dy_ext1 = dy0 - 2 - 2 * SQUISH_CONSTANT_3D
            else
                ysv_ext0 = ysv_ext1 = ysb
                dy_ext0 = dy0 - SQUISH_CONSTANT_3D
                dy_ext1 = dy0 - 2 * SQUISH_CONSTANT_3D
            end
            if (c & 0x04) != 0
                zsv_ext0 = zsb + 1
                zsv_ext1 = zsb + 2
                dz_ext0 = dz0 - 1 - SQUISH_CONSTANT_3D
                dz_ext1 = dz0 - 2 - 2 * SQUISH_CONSTANT_3D
            else
                zsv_ext0 = zsv_ext1 = zsb
                dz_ext0 = dz0 - SQUISH_CONSTANT_3D
                dz_ext1 = dz0 - 2 * SQUISH_CONSTANT_3D
            end
        end
        # Contribution (1,1,0)
        dx3 = dx0 - 1 - 2 * SQUISH_CONSTANT_3D
        dy3 = dy0 - 1 - 2 * SQUISH_CONSTANT_3D
        dz3 = dz0 - 0 - 2 * SQUISH_CONSTANT_3D
        attn3 = 2 - dx3 * dx3 - dy3 * dy3 - dz3 * dz3
        if attn3 > 0
            attn3 *= attn3
            value += attn3 * attn3 * extrapolate(xsb + 1, ysb + 1, zsb + 0, dx3, dy3, dz3)
        end
        # Contribution (1,0,1)
        dx2 = dx3
        dy2 = dy0 - 0 - 2 * SQUISH_CONSTANT_3D
        dz2 = dz0 - 1 - 2 * SQUISH_CONSTANT_3D
        attn2 = 2 - dx2 * dx2 - dy2 * dy2 - dz2 * dz2
        if attn2 > 0
            attn2 *= attn2
            value += attn2 * attn2 * extrapolate(xsb + 1, ysb + 0, zsb + 1, dx2, dy2, dz2)
        end
        # Contribution (0,1,1)
        dx1 = dx0 - 0 - 2 * SQUISH_CONSTANT_3D
        dy1 = dy3
        dz1 = dz2
        attn1 = 2 - dx1 * dx1 - dy1 * dy1 - dz1 * dz1
        if attn1 > 0
            attn1 *= attn1
            value += attn1 * attn1 * extrapolate(xsb + 0, ysb + 1, zsb + 1, dx1, dy1, dz1)
        end
        # Contribution (1,1,1)
        dx0 = dx0 - 1 - 3 * SQUISH_CONSTANT_3D
        dy0 = dy0 - 1 - 3 * SQUISH_CONSTANT_3D
        dz0 = dz0 - 1 - 3 * SQUISH_CONSTANT_3D
        attn0 = 2 - dx0 * dx0 - dy0 * dy0 - dz0 * dz0
        if attn0 > 0
            attn0 *= attn0
            value += attn0 * attn0 * extrapolate(xsb + 1, ysb + 1, zsb + 1, dx0, dy0, dz0)
        end
    else # We're inside the octahedron (Rectified 3-Simplex) in between.
        # Decide between point (0,0,1) and (1,1,0) as closest
        p1 = xins + yins
        if p1 > 1
            aScore = p1 - 1
            aPoint = 0x03
            aIsFurtherSide = true
        else
            aScore = 1 - p1
            aPoint = 0x04
            aIsFurtherSide = false
        end
        # Decide between point (0,1,0) and (1,0,1) as closest
        p2 = xins + zins
        if p2 > 1
            bScore = p2 - 1
            bPoint = 0x05
            bIsFurtherSide = true
        else
            bScore = 1 - p2
            bPoint = 0x02
            bIsFurtherSide = false
        end
        # The closest out of the two (1,0,0) and (0,1,1) will replace the furthest out of the two decided above, if closer.
        p3 = yins + zins
        if p3 > 1
            score = p3 - 1
            if (aScore <= bScore) && (aScore < score)
                aScore = score
                aPoint = 0x06
                aIsFurtherSide = true
            elseif (aScore > bScore) && (bScore < score)
                bScore = score
                bPoint = 0x06
                bIsFurtherSide = true
            end
        else
            score = 1 - p3
            if (aScore <= bScore) && (aScore < score)
                aScore = score
                aPoint = 0x01
                aIsFurtherSide = false
            elseif (aScore > bScore) && (bScore < score)
                bScore = score
                bPoint = 0x01
                bIsFurtherSide = false
            end
        end
        # Where each of the two closest points are determines how the extra two vertices are calculated.
        if aIsFurtherSide == bIsFurtherSide
            if aIsFurtherSide # Both closest points on (1,1,1) side
                # One of the two extra points is (1,1,1)
                dx_ext0 = dx0 - 1 - 3 * SQUISH_CONSTANT_3D
                dy_ext0 = dy0 - 1 - 3 * SQUISH_CONSTANT_3D
                dz_ext0 = dz0 - 1 - 3 * SQUISH_CONSTANT_3D
                xsv_ext0 = xsb + 1
                ysv_ext0 = ysb + 1
                zsv_ext0 = zsb + 1
                # Other extra point is based on the shared axis.
                c = aPoint & bPoint
                if (c & 0x01) != 0
                    dx_ext1 = dx0 - 2 - 2 * SQUISH_CONSTANT_3D
                    dy_ext1 = dy0 - 2 * SQUISH_CONSTANT_3D
                    dz_ext1 = dz0 - 2 * SQUISH_CONSTANT_3D
                    xsv_ext1 = xsb + 2
                    ysv_ext1 = ysb
                    zsv_ext1 = zsb
                elseif (c & 0x02) != 0
                    dx_ext1 = dx0 - 2 * SQUISH_CONSTANT_3D
                    dy_ext1 = dy0 - 2 - 2 * SQUISH_CONSTANT_3D
                    dz_ext1 = dz0 - 2 * SQUISH_CONSTANT_3D
                    xsv_ext1 = xsb
                    ysv_ext1 = ysb + 2
                    zsv_ext1 = zsb
                else
                    dx_ext1 = dx0 - 2 * SQUISH_CONSTANT_3D
                    dy_ext1 = dy0 - 2 * SQUISH_CONSTANT_3D
                    dz_ext1 = dz0 - 2 - 2 * SQUISH_CONSTANT_3D
                    xsv_ext1 = xsb
                    ysv_ext1 = ysb
                    zsv_ext1 = zsb + 2
                end
            else # Both closest points on (0,0,0) side
                # One of the two extra points is (0,0,0)
                dx_ext0 = dx0
                dy_ext0 = dy0
                dz_ext0 = dz0
                xsv_ext0 = xsb
                ysv_ext0 = ysb
                zsv_ext0 = zsb
                # Other extra point is based on the omitted axis.
                c = aPoint | bPoint
                if (c & 0x01) == 0 # other extra omitted axis
                    dx_ext1 = dx0 + 1 - SQUISH_CONSTANT_3D
                    dy_ext1 = dy0 - 1 - SQUISH_CONSTANT_3D
                    dz_ext1 = dz0 - 1 - SQUISH_CONSTANT_3D
                    xsv_ext1 = xsb - 1
                    ysv_ext1 = ysb + 1
                    zsv_ext1 = zsb + 1
                elseif (c & 0x02) == 0
                    dx_ext1 = dx0 - 1 - SQUISH_CONSTANT_3D
                    dy_ext1 = dy0 + 1 - SQUISH_CONSTANT_3D
                    dz_ext1 = dz0 - 1 - SQUISH_CONSTANT_3D
                    xsv_ext1 = xsb + 1
                    ysv_ext1 = ysb - 1
                    zsv_ext1 = zsb + 1
                else
                    dx_ext1 = dx0 - 1 - SQUISH_CONSTANT_3D
                    dy_ext1 = dy0 - 1 - SQUISH_CONSTANT_3D
                    dz_ext1 = dz0 + 1 - SQUISH_CONSTANT_3D
                    xsv_ext1 = xsb + 1
                    ysv_ext1 = ysb + 1
                    zsv_ext1 = zsb - 1
                end
            end
        else # One point on (0,0,0) side, one point on (1,1,1) side
            if aIsFurtherSide
                c1 = aPoint
                c2 = bPoint
            else
                c1 = bPoint
                c2 = aPoint
            end
            # One contribution is a permutation of (1,1,-1)
            if c1 & 0x01 == 0
                dx_ext0 = dx0 + 1 - SQUISH_CONSTANT_3D
                dy_ext0 = dy0 - 1 - SQUISH_CONSTANT_3D
                dz_ext0 = dz0 - 1 - SQUISH_CONSTANT_3D
                xsv_ext0 = xsb - 1
                ysv_ext0 = ysb + 1
                zsv_ext0 = zsb + 1
            elseif c1 & 0x02 == 0
                dx_ext0 = dx0 - 1 - SQUISH_CONSTANT_3D
                dy_ext0 = dy0 + 1 - SQUISH_CONSTANT_3D
                dz_ext0 = dz0 - 1 - SQUISH_CONSTANT_3D
                xsv_ext0 = xsb + 1
                ysv_ext0 = ysb - 1
                zsv_ext0 = zsb + 1
            else
                dx_ext0 = dx0 - 1 - SQUISH_CONSTANT_3D
                dy_ext0 = dy0 - 1 - SQUISH_CONSTANT_3D
                dz_ext0 = dz0 + 1 - SQUISH_CONSTANT_3D
                xsv_ext0 = xsb + 1
                ysv_ext0 = ysb + 1
                zsv_ext0 = zsb - 1
            end
            # One contribution is a permutation of (0,0,2)
            dx_ext1 = dx0 - 2 * SQUISH_CONSTANT_3D
            dy_ext1 = dy0 - 2 * SQUISH_CONSTANT_3D
            dz_ext1 = dz0 - 2 * SQUISH_CONSTANT_3D
            xsv_ext1 = xsb
            ysv_ext1 = ysb
            zsv_ext1 = zsb
            if (c2 & 0x01) != 0
                dx_ext1 -= 2
                xsv_ext1 += 2
            elseif (c2 & 0x02) != 0
                dy_ext1 -= 2
                ysv_ext1 += 2
            else
                dz_ext1 -= 2
                zsv_ext1 += 2
            end
        end
        # Contribution (1,0,0)
        dx1 = dx0 - 1 - SQUISH_CONSTANT_3D
        dy1 = dy0 - 0 - SQUISH_CONSTANT_3D
        dz1 = dz0 - 0 - SQUISH_CONSTANT_3D
        attn1 = 2 - dx1 * dx1 - dy1 * dy1 - dz1 * dz1
        if attn1 > 0
            attn1 *= attn1
            value += attn1 * attn1 * extrapolate(xsb + 1, ysb + 0, zsb + 0, dx1, dy1, dz1)
        end

        # Contribution (0,1,0)
        dx2 = dx0 - 0 - SQUISH_CONSTANT_3D
        dy2 = dy0 - 1 - SQUISH_CONSTANT_3D
        dz2 = dz1
        attn2 = 2 - dx2 * dx2 - dy2 * dy2 - dz2 * dz2
        if attn2 > 0
            attn2 *= attn2
            value += attn2 * attn2 * extrapolate(xsb + 0, ysb + 1, zsb + 0, dx2, dy2, dz2)
        end

        # Contribution (0,0,1)
        dx3 = dx2
        dy3 = dy1
        dz3 = dz0 - 1 - SQUISH_CONSTANT_3D
        attn3 = 2 - dx3 * dx3 - dy3 * dy3 - dz3 * dz3
        if attn3 > 0
            attn3 *= attn3
            value += attn3 * attn3 * extrapolate(xsb + 0, ysb + 0, zsb + 1, dx3, dy3, dz3)
        end
        # Contribution (1,1,0)
        dx4 = dx0 - 1 - 2 * SQUISH_CONSTANT_3D
        dy4 = dy0 - 1 - 2 * SQUISH_CONSTANT_3D
        dz4 = dz0 - 0 - 2 * SQUISH_CONSTANT_3D
        attn4 = 2 - dx4 * dx4 - dy4 * dy4 - dz4 * dz4
        if attn4 > 0
            attn4 *= attn4
            value += attn4 * attn4 * extrapolate(xsb + 1, ysb + 1, zsb + 0, dx4, dy4, dz4)
        end
        # Contribution (1,0,1)
        dx5 = dx4
        dy5 = dy0 - 0 - 2 * SQUISH_CONSTANT_3D
        dz5 = dz0 - 1 - 2 * SQUISH_CONSTANT_3D
        attn5 = 2 - dx5 * dx5 - dy5 * dy5 - dz5 * dz5
        if attn5 > 0
            attn5 *= attn5
            value += attn5 * attn5 * extrapolate(xsb + 1, ysb + 0, zsb + 1, dx5, dy5, dz5)
        end
        # Contribution (0,1,1)
        dx6 = dx0 - 0 - 2 * SQUISH_CONSTANT_3D
        dy6 = dy4
        dz6 = dz5
        attn6 = 2 - dx6 * dx6 - dy6 * dy6 - dz6 * dz6
        if attn6 > 0
            attn6 *= attn6
            value += attn6 * attn6 * extrapolate(xsb + 0, ysb + 1, zsb + 1, dx6, dy6, dz6)
        end
    end
    # First extra vertex
    attn_ext0 = 2 - dx_ext0 * dx_ext0 - dy_ext0 * dy_ext0 - dz_ext0 * dz_ext0
    if attn_ext0 > 0
        attn_ext0 *= attn_ext0
        value += attn_ext0 * attn_ext0 * extrapolate(xsv_ext0, ysv_ext0, zsv_ext0, dx_ext0, dy_ext0, dz_ext0)
    end
    # Second extra vertex
    attn_ext1 = 2 - dx_ext1 * dx_ext1 - dy_ext1 * dy_ext1 - dz_ext1 * dz_ext1
    if attn_ext1 > 0
        attn_ext1 *= attn_ext1
        value += attn_ext1 * attn_ext1 * extrapolate(xsv_ext1, ysv_ext1, zsv_ext1, dx_ext1, dy_ext1, dz_ext1)
    end

    res = value / NORM_CONSTANT_3D
    # convert to [0, 1]
    return clamp((res + 1) / 2, 0.0, 1.0)
end

# 4D OpenSimplex Noise.
function simplexnoise(x, y, z, w)
    # TODO convert to Julia properly
    # Place input coordinates on simplectic honeycomb.
    stretchOffset = (x + y + z + w) * STRETCH_CONSTANT_4D
    xs = x + stretchOffset
    ys = y + stretchOffset
    zs = z + stretchOffset
    ws = w + stretchOffset

    # Floor to get simplectic honeycomb coordinates of rhombo-hypercube super-cell origin.
    xsb = convert(Int, floor(xs))
    ysb = convert(Int, floor(ys))
    zsb = convert(Int, floor(zs))
    wsb = convert(Int, floor(ws))

    # Skew out to get actual coordinates of stretched rhombo-hypercube origin. We'll need these later.
    squishOffset = (xsb + ysb + zsb + wsb) * SQUISH_CONSTANT_4D
    xb = xsb + squishOffset
    yb = ysb + squishOffset
    zb = zsb + squishOffset
    wb = wsb + squishOffset

    # Compute simplectic honeycomb coordinates relative to rhombo-hypercube origin.
    xins = xs - xsb
    yins = ys - ysb
    zins = zs - zsb
    wins = ws - wsb

    # Sum those together to get a value that determines which region we're in.
    inSum = xins + yins + zins + wins

    # Positions relative to origin point.
    dx0 = x - xb
    dy0 = y - yb
    dz0 = z - zb
    dw0 = w - wb

    value = 0.0

    if inSum <= 1  # We're inside the pentachoron (4-Simplex) at (0,0,0,0)
        # Determine which two of (0,0,0,1), (0,0,1,0), (0,1,0,0), (1,0,0,0) are closest.
        aPoint = 0x01
        aScore = xins
        bPoint = 0x02
        bScore = yins
        if (aScore >= bScore) && (zins > bScore)
            bScore = zins
            bPoint = 0x04
        elseif (aScore < bScore) && (zins > aScore)
            aScore = zins
            aPoint = 0x04
        end
        if (aScore >= bScore) && (wins > bScore)
            bScore = wins
            bPoint = 0x08
        elseif (aScore < bScore) && (wins > aScore)
            aScore = wins
            aPoint = 0x08
        end
        # Now we determine the three lattice points not part of the pentachoron that may contribute.
        # This depends on the closest two pentachoron vertices, including (0,0,0,0)
        uins = 1 - inSum
        if (uins > aScore) || (uins > bScore)  # (0,0,0,0) is one of the closest two pentachoron vertices.
            c = (bScore > aScore ? bPoint : aPoint) # Our other closest vertex is the closest out of a and b.
            if (c & 0x01) == 0
                xsv_ext0 = xsb - 1
                xsv_ext1 = xsv_ext2 = xsb
                dx_ext0 = dx0 + 1
                dx_ext1 = dx_ext2 = dx0
            else
                xsv_ext0 = xsv_ext1 = xsv_ext2 = xsb + 1
                dx_ext0 = dx_ext1 = dx_ext2 = dx0 - 1
            end
            if (c & 0x02) == 0
                ysv_ext0 = ysv_ext1 = ysv_ext2 = ysb
                dy_ext0 = dy_ext1 = dy_ext2 = dy0
                if (c & 0x01) == 0x01
                    ysv_ext0 -= 1
                    dy_ext0 += 1
                else
                    ysv_ext1 -= 1
                    dy_ext1 += 1
                end
            else
                ysv_ext0 = ysv_ext1 = ysv_ext2 = ysb + 1
                dy_ext0 = dy_ext1 = dy_ext2 = dy0 - 1
            end
            if (c & 0x04) == 0
                zsv_ext0 = zsv_ext1 = zsv_ext2 = zsb
                dz_ext0 = dz_ext1 = dz_ext2 = dz0
                if (c & 0x03) != 0
                    if (c & 0x03) == 0x03
                        zsv_ext0 -= 1
                        dz_ext0 += 1
                    else
                        zsv_ext1 -= 1
                        dz_ext1 += 1
                    end
                else
                    zsv_ext2 -= 1
                    dz_ext2 += 1
                end
            else
                zsv_ext0 = zsv_ext1 = zsv_ext2 = zsb + 1
                dz_ext0 = dz_ext1 = dz_ext2 = dz0 - 1
            end
            if (c & 0x08) == 0
                wsv_ext0 = wsv_ext1 = wsb
                wsv_ext2 = wsb - 1
                dw_ext0 = dw_ext1 = dw0
                dw_ext2 = dw0 + 1
            else
                wsv_ext0 = wsv_ext1 = wsv_ext2 = wsb + 1
                dw_ext0 = dw_ext1 = dw_ext2 = dw0 - 1
            end
        else  # (0,0,0,0) is not one of the closest two pentachoron vertices.
            c = aPoint | bPoint # Our three extra vertices are determined by the closest two.
            if (c & 0x01) == 0
                xsv_ext0 = xsv_ext2 = xsb
                xsv_ext1 = xsb - 1
                dx_ext0 = dx0 - 2 * SQUISH_CONSTANT_4D
                dx_ext1 = dx0 + 1 - SQUISH_CONSTANT_4D
                dx_ext2 = dx0 - SQUISH_CONSTANT_4D
            else
                xsv_ext0 = xsv_ext1 = xsv_ext2 = xsb + 1
                dx_ext0 = dx0 - 1 - 2 * SQUISH_CONSTANT_4D
                dx_ext1 = dx_ext2 = dx0 - 1 - SQUISH_CONSTANT_4D
            end

            if (c & 0x02) == 0
                ysv_ext0 = ysv_ext1 = ysv_ext2 = ysb
                dy_ext0 = dy0 - 2 * SQUISH_CONSTANT_4D
                dy_ext1 = dy_ext2 = dy0 - SQUISH_CONSTANT_4D
                if (c & 0x01) == 0x01
                    ysv_ext1 -= 1
                    dy_ext1 += 1
                else
                    ysv_ext2 -= 1
                    dy_ext2 += 1
                end
            else
                ysv_ext0 = ysv_ext1 = ysv_ext2 = ysb + 1
                dy_ext0 = dy0 - 1 - 2 * SQUISH_CONSTANT_4D
                dy_ext1 = dy_ext2 = dy0 - 1 - SQUISH_CONSTANT_4D
            end

            if (c & 0x04) == 0
                zsv_ext0 = zsv_ext1 = zsv_ext2 = zsb
                dz_ext0 = dz0 - 2 * SQUISH_CONSTANT_4D
                dz_ext1 = dz_ext2 = dz0 - SQUISH_CONSTANT_4D
                if (c & 0x03) == 0x03
                    zsv_ext1 -= 1
                    dz_ext1 += 1
                else
                    zsv_ext2 -= 1
                    dz_ext2 += 1
                end
            else
                zsv_ext0 = zsv_ext1 = zsv_ext2 = zsb + 1
                dz_ext0 = dz0 - 1 - 2 * SQUISH_CONSTANT_4D
                dz_ext1 = dz_ext2 = dz0 - 1 - SQUISH_CONSTANT_4D
            end

            if (c & 0x08) == 0
                wsv_ext0 = wsv_ext1 = wsb
                wsv_ext2 = wsb - 1
                dw_ext0 = dw0 - 2 * SQUISH_CONSTANT_4D
                dw_ext1 = dw0 - SQUISH_CONSTANT_4D
                dw_ext2 = dw0 + 1 - SQUISH_CONSTANT_4D
            else
                wsv_ext0 = wsv_ext1 = wsv_ext2 = wsb + 1
                dw_ext0 = dw0 - 1 - 2 * SQUISH_CONSTANT_4D
                dw_ext1 = dw_ext2 = dw0 - 1 - SQUISH_CONSTANT_4D
            end
        end

        # Contribution (0,0,0,0)
        attn0 = 2 - dx0 * dx0 - dy0 * dy0 - dz0 * dz0 - dw0 * dw0
        if attn0 > 0
            attn0 *= attn0
            value += attn0 * attn0 * extrapolate(xsb + 0, ysb + 0, zsb + 0, wsb + 0, dx0, dy0, dz0, dw0)
        end

        # Contribution (1,0,0,0)
        dx1 = dx0 - 1 - SQUISH_CONSTANT_4D
        dy1 = dy0 - 0 - SQUISH_CONSTANT_4D
        dz1 = dz0 - 0 - SQUISH_CONSTANT_4D
        dw1 = dw0 - 0 - SQUISH_CONSTANT_4D
        attn1 = 2 - dx1 * dx1 - dy1 * dy1 - dz1 * dz1 - dw1 * dw1
        if attn1 > 0
            attn1 *= attn1
            value += attn1 * attn1 * extrapolate(xsb + 1, ysb + 0, zsb + 0, wsb + 0, dx1, dy1, dz1, dw1)
        end

        # Contribution (0,1,0,0)
        dx2 = dx0 - 0 - SQUISH_CONSTANT_4D
        dy2 = dy0 - 1 - SQUISH_CONSTANT_4D
        dz2 = dz1
        dw2 = dw1
        attn2 = 2 - dx2 * dx2 - dy2 * dy2 - dz2 * dz2 - dw2 * dw2
        if attn2 > 0
            attn2 *= attn2
            value += attn2 * attn2 * extrapolate(xsb + 0, ysb + 1, zsb + 0, wsb + 0, dx2, dy2, dz2, dw2)
        end

        # Contribution (0,0,1,0)
        dx3 = dx2
        dy3 = dy1
        dz3 = dz0 - 1 - SQUISH_CONSTANT_4D
        dw3 = dw1
        attn3 = 2 - dx3 * dx3 - dy3 * dy3 - dz3 * dz3 - dw3 * dw3
        if attn3 > 0
            attn3 *= attn3
            value += attn3 * attn3 * extrapolate(xsb + 0, ysb + 0, zsb + 1, wsb + 0, dx3, dy3, dz3, dw3)
        end

        # Contribution (0,0,0,1)
        dx4 = dx2
        dy4 = dy1
        dz4 = dz1
        dw4 = dw0 - 1 - SQUISH_CONSTANT_4D
        attn4 = 2 - dx4 * dx4 - dy4 * dy4 - dz4 * dz4 - dw4 * dw4
        if attn4 > 0
            attn4 *= attn4
            value += attn4 * attn4 * extrapolate(xsb + 0, ysb + 0, zsb + 0, wsb + 1, dx4, dy4, dz4, dw4)
        end
    elseif (inSum >= 3) # We're inside the pentachoron (4-Simplex) at (1,1,1,1)
        # Determine which two of (1,1,1,0), (1,1,0,1), (1,0,1,1), (0,1,1,1) are closest.
        aPoint  = 0x0E
        aScore = xins
        bPoint = 0x0D
        bScore = yins
        if (aScore <= bScore && zins < bScore)
            bScore = zins
            bPoint = 0x0B
        elseif (aScore > bScore && zins < aScore)
            aScore = zins
            aPoint = 0x0B
        end
        if (aScore <= bScore && wins < bScore)
            bScore = wins
            bPoint = 0x07
        elseif (aScore > bScore && wins < aScore)
            aScore = wins
            aPoint = 0x07
        end

        # Now we determine the three lattice points not part of the pentachoron that may contribute.
        # This depends on the closest two pentachoron vertices, including (0,0,0,0)
        uins = 4 - inSum
        if (uins < aScore || uins < bScore)  # (1,1,1,1) is one of the closest two pentachoron vertices.
            c = (bScore < aScore ? bPoint : aPoint) # Our other closest vertex is the closest out of a and b.

            if ((c & 0x01) != 0)
                xsv_ext0 = xsb + 2
                xsv_ext1 = xsv_ext2 = xsb + 1
                dx_ext0 = dx0 - 2 - 4 * SQUISH_CONSTANT_4D
                dx_ext1 = dx_ext2 = dx0 - 1 - 4 * SQUISH_CONSTANT_4D
            else
                xsv_ext0 = xsv_ext1 = xsv_ext2 = xsb
                dx_ext0 = dx_ext1 = dx_ext2 = dx0 - 4 * SQUISH_CONSTANT_4D
            end

            if ((c & 0x02) != 0)
                ysv_ext0 = ysv_ext1 = ysv_ext2 = ysb + 1
                dy_ext0 = dy_ext1 = dy_ext2 = dy0 - 1 - 4 * SQUISH_CONSTANT_4D
                if ((c & 0x01) != 0)
                    ysv_ext1 += 1
                    dy_ext1 -= 1
                else
                    ysv_ext0 += 1
                    dy_ext0 -= 1
                end
            else
                ysv_ext0 = ysv_ext1 = ysv_ext2 = ysb
                dy_ext0 = dy_ext1 = dy_ext2 = dy0 - 4 * SQUISH_CONSTANT_4D
            end

            if ((c & 0x04) != 0)
                zsv_ext0 = zsv_ext1 = zsv_ext2 = zsb + 1
                dz_ext0 = dz_ext1 = dz_ext2 = dz0 - 1 - 4 * SQUISH_CONSTANT_4D
                if ((c & 0x03) != 0x03)
                    if ((c & 0x03) == 0)
                        zsv_ext0 += 1
                        dz_ext0 -= 1
                    else
                        zsv_ext1 += 1
                        dz_ext1 -= 1
                    end
                else
                    zsv_ext2 += 1
                    dz_ext2 -= 1
                end
            else
                zsv_ext0 = zsv_ext1 = zsv_ext2 = zsb
                dz_ext0 = dz_ext1 = dz_ext2 = dz0 - 4 * SQUISH_CONSTANT_4D
            end

            if ((c & 0x08) != 0)
                wsv_ext0 = wsv_ext1 = wsb + 1
                wsv_ext2 = wsb + 2
                dw_ext0 = dw_ext1 = dw0 - 1 - 4 * SQUISH_CONSTANT_4D
                dw_ext2 = dw0 - 2 - 4 * SQUISH_CONSTANT_4D
            else
                wsv_ext0 = wsv_ext1 = wsv_ext2 = wsb
                dw_ext0 = dw_ext1 = dw_ext2 = dw0 - 4 * SQUISH_CONSTANT_4D
            end
        else  # (1,1,1,1) is not one of the closest two pentachoron vertices.
            c = aPoint & bPoint # Our three extra vertices are determined by the closest two.

            if ((c & 0x01) != 0)
                xsv_ext0 = xsv_ext2 = xsb + 1
                xsv_ext1 = xsb + 2
                dx_ext0 = dx0 - 1 - 2 * SQUISH_CONSTANT_4D
                dx_ext1 = dx0 - 2 - 3 * SQUISH_CONSTANT_4D
                dx_ext2 = dx0 - 1 - 3 * SQUISH_CONSTANT_4D
            else
                xsv_ext0 = xsv_ext1 = xsv_ext2 = xsb
                dx_ext0 = dx0 - 2 * SQUISH_CONSTANT_4D
                dx_ext1 = dx_ext2 = dx0 - 3 * SQUISH_CONSTANT_4D
            end

            if (c & 0x02) != 0
                ysv_ext0 = ysv_ext1 = ysv_ext2 = ysb + 1
                dy_ext0 = dy0 - 1 - 2 * SQUISH_CONSTANT_4D
                dy_ext1 = dy_ext2 = dy0 - 1 - 3 * SQUISH_CONSTANT_4D
                if (c & 0x01) != 0
                    ysv_ext2 += 1
                    dy_ext2 -= 1
                else
                    ysv_ext1 += 1
                    dy_ext1 -= 1
                end
            else
                ysv_ext0 = ysv_ext1 = ysv_ext2 = ysb
                dy_ext0 = dy0 - 2 * SQUISH_CONSTANT_4D
                dy_ext1 = dy_ext2 = dy0 - 3 * SQUISH_CONSTANT_4D
            end

            if (c & 0x04) != 0
                zsv_ext0 = zsv_ext1 = zsv_ext2 = zsb + 1
                dz_ext0 = dz0 - 1 - 2 * SQUISH_CONSTANT_4D
                dz_ext1 = dz_ext2 = dz0 - 1 - 3 * SQUISH_CONSTANT_4D
                if (c & 0x03) != 0
                    zsv_ext2 += 1
                    dz_ext2 -= 1
                else
                    zsv_ext1 += 1
                    dz_ext1 -= 1
                end
            else
                zsv_ext0 = zsv_ext1 = zsv_ext2 = zsb
                dz_ext0 = dz0 - 2 * SQUISH_CONSTANT_4D
                dz_ext1 = dz_ext2 = dz0 - 3 * SQUISH_CONSTANT_4D
            end

            if (c & 0x08) != 0
                wsv_ext0 = wsv_ext1 = wsb + 1
                wsv_ext2 = wsb + 2
                dw_ext0 = dw0 - 1 - 2 * SQUISH_CONSTANT_4D
                dw_ext1 = dw0 - 1 - 3 * SQUISH_CONSTANT_4D
                dw_ext2 = dw0 - 2 - 3 * SQUISH_CONSTANT_4D
            else
                wsv_ext0 = wsv_ext1 = wsv_ext2 = wsb
                dw_ext0 = dw0 - 2 * SQUISH_CONSTANT_4D
                dw_ext1 = dw_ext2 = dw0 - 3 * SQUISH_CONSTANT_4D
            end
        end

        # Contribution (1,1,1,0)
        dx4 = dx0 - 1 - 3 * SQUISH_CONSTANT_4D
        dy4 = dy0 - 1 - 3 * SQUISH_CONSTANT_4D
        dz4 = dz0 - 1 - 3 * SQUISH_CONSTANT_4D
        dw4 = dw0 - 3 * SQUISH_CONSTANT_4D
        attn4 = 2 - dx4 * dx4 - dy4 * dy4 - dz4 * dz4 - dw4 * dw4
        if attn4 > 0
            attn4 *= attn4
            value += attn4 * attn4 * extrapolate(xsb + 1, ysb + 1, zsb + 1, wsb + 0, dx4, dy4, dz4, dw4)
        end

        # Contribution (1,1,0,1)
        dx3 = dx4
        dy3 = dy4
        dz3 = dz0 - 3 * SQUISH_CONSTANT_4D
        dw3 = dw0 - 1 - 3 * SQUISH_CONSTANT_4D
        attn3 = 2 - dx3 * dx3 - dy3 * dy3 - dz3 * dz3 - dw3 * dw3
        if attn3 > 0
            attn3 *= attn3
            value += attn3 * attn3 * extrapolate(xsb + 1, ysb + 1, zsb + 0, wsb + 1, dx3, dy3, dz3, dw3)
        end

        # Contribution (1,0,1,1)
        dx2 = dx4
        dy2 = dy0 - 3 * SQUISH_CONSTANT_4D
        dz2 = dz4
        dw2 = dw3
        attn2 = 2 - dx2 * dx2 - dy2 * dy2 - dz2 * dz2 - dw2 * dw2
        if attn2 > 0
            attn2 *= attn2
            value += attn2 * attn2 * extrapolate(xsb + 1, ysb + 0, zsb + 1, wsb + 1, dx2, dy2, dz2, dw2)
        end

        # Contribution (0,1,1,1)
        dx1 = dx0 - 3 * SQUISH_CONSTANT_4D
        dz1 = dz4
        dy1 = dy4
        dw1 = dw3
        attn1 = 2 - dx1 * dx1 - dy1 * dy1 - dz1 * dz1 - dw1 * dw1
        if attn1 > 0
            attn1 *= attn1
            value += attn1 * attn1 * extrapolate(xsb + 0, ysb + 1, zsb + 1, wsb + 1, dx1, dy1, dz1, dw1)
        end

        # Contribution (1,1,1,1)
        dx0 = dx0 - 1 - 4 * SQUISH_CONSTANT_4D
        dy0 = dy0 - 1 - 4 * SQUISH_CONSTANT_4D
        dz0 = dz0 - 1 - 4 * SQUISH_CONSTANT_4D
        dw0 = dw0 - 1 - 4 * SQUISH_CONSTANT_4D
        attn0 = 2 - dx0 * dx0 - dy0 * dy0 - dz0 * dz0 - dw0 * dw0
        if attn0 > 0
            attn0 *= attn0
            value += attn0 * attn0 * extrapolate(xsb + 1, ysb + 1, zsb + 1, wsb + 1, dx0, dy0, dz0, dw0)
        end
    elseif inSum <= 2 # We're inside the first dispentachoron (Rectified 4-Simplex)
        aIsBiggerSide = true
        bIsBiggerSide = true

        # Decide between (1,1,0,0) and (0,0,1,1)
        if (xins + yins) > (zins + wins)
            aScore = xins + yins
            aPoint = 0x03
        else
            aScore = zins + wins
            aPoint = 0x0C
        end

        # Decide between (1,0,1,0) and (0,1,0,1)
        if (xins + zins) > (yins + wins)
            bScore = xins + zins
            bPoint = 0x05
        else
            bScore = yins + wins
            bPoint = 0x0A
        end

        # Closer between (1,0,0,1) and (0,1,1,0) will replace the further of a and b, if closer.
        if (xins + wins > yins + zins)
            score = xins + wins
            if (aScore >= bScore) && (score > bScore)
                bScore = score
                bPoint = 0x09
            elseif (aScore < bScore) && (score > aScore)
                aScore = score
                aPoint = 0x09
            end
        else
            score = yins + zins
            if (aScore >= bScore) && (score > bScore)
                bScore = score
                bPoint = 0x06
            elseif (aScore < bScore) && (score > aScore)
                aScore = score
                aPoint = 0x06
            end
        end

        # Decide if (1,0,0,0) is closer.
        p1 = 2 - inSum + xins
        if (aScore >= bScore) && (p1 > bScore)
            bScore = p1
            bPoint = 0x01
            bIsBiggerSide = false
        elseif (aScore < bScore) && (p1 > aScore)
            aScore = p1
            aPoint = 0x01
            aIsBiggerSide = false
        end

        # Decide if (0,1,0,0) is closer.
        p2 = 2 - inSum + yins
        if (aScore >= bScore) && (p2 > bScore)
            bScore = p2
            bPoint = 0x02
            bIsBiggerSide = false
        elseif (aScore < bScore) && (p2 > aScore)
            aScore = p2
            aPoint = 0x02
            aIsBiggerSide = false
        end
        # Decide if (0,0,1,0) is closer.
        p3 = 2 - inSum + zins
        if (aScore >= bScore) && (p3 > bScore)
            bScore = p3
            bPoint = 0x04
            bIsBiggerSide = false
        elseif (aScore < bScore) && (p3 > aScore)
            aScore = p3
            aPoint = 0x04
            aIsBiggerSide = false
        end
        # Decide if (0,0,0,1) is closer.
        p4 = 2 - inSum + wins
        if (aScore >= bScore) && (p4 > bScore)
            bScore = p4
            bPoint = 0x08
            bIsBiggerSide = false
        elseif (aScore < bScore) && (p4 > aScore)
            aScore = p4
            aPoint = 0x08
            aIsBiggerSide = false
        end
        # Where each of the two closest points are determines how the extra three vertices are calculated.
        if aIsBiggerSide == bIsBiggerSide
            if aIsBiggerSide  # Both closest points on the bigger side
                c1 = aPoint | bPoint
                c2 = aPoint & bPoint
                if (c1 & 0x01) == 0
                    xsv_ext0 = xsb
                    xsv_ext1 = xsb - 1
                    dx_ext0 = dx0 - 3 * SQUISH_CONSTANT_4D
                    dx_ext1 = dx0 + 1 - 2 * SQUISH_CONSTANT_4D
                else
                    xsv_ext0 = xsv_ext1 = xsb + 1
                    dx_ext0 = dx0 - 1 - 3 * SQUISH_CONSTANT_4D
                    dx_ext1 = dx0 - 1 - 2 * SQUISH_CONSTANT_4D
                end

                if (c1 & 0x02) == 0
                    ysv_ext0 = ysb
                    ysv_ext1 = ysb - 1
                    dy_ext0 = dy0 - 3 * SQUISH_CONSTANT_4D
                    dy_ext1 = dy0 + 1 - 2 * SQUISH_CONSTANT_4D
                else
                    ysv_ext0 = ysv_ext1 = ysb + 1
                    dy_ext0 = dy0 - 1 - 3 * SQUISH_CONSTANT_4D
                    dy_ext1 = dy0 - 1 - 2 * SQUISH_CONSTANT_4D
                end

                if (c1 & 0x04) == 0
                    zsv_ext0 = zsb
                    zsv_ext1 = zsb - 1
                    dz_ext0 = dz0 - 3 * SQUISH_CONSTANT_4D
                    dz_ext1 = dz0 + 1 - 2 * SQUISH_CONSTANT_4D
                else
                    zsv_ext0 = zsv_ext1 = zsb + 1
                    dz_ext0 = dz0 - 1 - 3 * SQUISH_CONSTANT_4D
                    dz_ext1 = dz0 - 1 - 2 * SQUISH_CONSTANT_4D
                end

                if (c1 & 0x08) == 0
                    wsv_ext0 = wsb
                    wsv_ext1 = wsb - 1
                    dw_ext0 = dw0 - 3 * SQUISH_CONSTANT_4D
                    dw_ext1 = dw0 + 1 - 2 * SQUISH_CONSTANT_4D
                else
                    wsv_ext0 = wsv_ext1 = wsb + 1
                    dw_ext0 = dw0 - 1 - 3 * SQUISH_CONSTANT_4D
                    dw_ext1 = dw0 - 1 - 2 * SQUISH_CONSTANT_4D
                end

                # One combination is a permutation of (0,0,0,2) based on c2
                xsv_ext2 = xsb
                ysv_ext2 = ysb
                zsv_ext2 = zsb
                wsv_ext2 = wsb
                dx_ext2 = dx0 - 2 * SQUISH_CONSTANT_4D
                dy_ext2 = dy0 - 2 * SQUISH_CONSTANT_4D
                dz_ext2 = dz0 - 2 * SQUISH_CONSTANT_4D
                dw_ext2 = dw0 - 2 * SQUISH_CONSTANT_4D
                if (c2 & 0x01) != 0
                    xsv_ext2 += 2
                    dx_ext2 -= 2
                elseif (c2 & 0x02) != 0
                    ysv_ext2 += 2
                    dy_ext2 -= 2
                elseif (c2 & 0x04) != 0
                    zsv_ext2 += 2
                    dz_ext2 -= 2
                else
                    wsv_ext2 += 2
                    dw_ext2 -= 2
                end
            else  # Both closest points on the smaller side
                # One of the two extra points is (0,0,0,0)
                xsv_ext2 = xsb
                ysv_ext2 = ysb
                zsv_ext2 = zsb
                wsv_ext2 = wsb
                dx_ext2 = dx0
                dy_ext2 = dy0
                dz_ext2 = dz0
                dw_ext2 = dw0

                # Other two points are based on the omitted axes.
                c = aPoint | bPoint

                if (c & 0x01) == 0
                    xsv_ext0 = xsb - 1
                    xsv_ext1 = xsb
                    dx_ext0 = dx0 + 1 - SQUISH_CONSTANT_4D
                    dx_ext1 = dx0 - SQUISH_CONSTANT_4D
                else
                    xsv_ext0 = xsv_ext1 = xsb + 1
                    dx_ext0 = dx_ext1 = dx0 - 1 - SQUISH_CONSTANT_4D
                end

                if (c & 0x02) == 0
                    ysv_ext0 = ysv_ext1 = ysb
                    dy_ext0 = dy_ext1 = dy0 - SQUISH_CONSTANT_4D
                    if (c & 0x01) == 0x01

                        ysv_ext0 -= 1
                        dy_ext0 += 1
                    else
                        ysv_ext1 -= 1
                        dy_ext1 += 1
                    end
                else
                    ysv_ext0 = ysv_ext1 = ysb + 1
                    dy_ext0 = dy_ext1 = dy0 - 1 - SQUISH_CONSTANT_4D
                end

                if (c & 0x04) == 0
                    zsv_ext0 = zsv_ext1 = zsb
                    dz_ext0 = dz_ext1 = dz0 - SQUISH_CONSTANT_4D
                    if (c & 0x03) == 0x03

                        zsv_ext0 -= 1
                        dz_ext0 += 1
                    else
                        zsv_ext1 -= 1
                        dz_ext1 += 1
                    end
                else
                    zsv_ext0 = zsv_ext1 = zsb + 1
                    dz_ext0 = dz_ext1 = dz0 - 1 - SQUISH_CONSTANT_4D
                end

                if (c & 0x08) == 0
                    wsv_ext0 = wsb
                    wsv_ext1 = wsb - 1
                    dw_ext0 = dw0 - SQUISH_CONSTANT_4D
                    dw_ext1 = dw0 + 1 - SQUISH_CONSTANT_4D
                else
                    wsv_ext0 = wsv_ext1 = wsb + 1
                    dw_ext0 = dw_ext1 = dw0 - 1 - SQUISH_CONSTANT_4D
                end

            end
        else  # One point on each "side"
            if aIsBiggerSide
                c1 = aPoint
                c2 = bPoint
            else
                c1 = bPoint
                c2 = aPoint
            end

            # Two contributions are the bigger-sided powith each 0 replaced with -1.
            if (c1 & 0x01) == 0
                xsv_ext0 = xsb - 1
                xsv_ext1 = xsb
                dx_ext0 = dx0 + 1 - SQUISH_CONSTANT_4D
                dx_ext1 = dx0 - SQUISH_CONSTANT_4D
            else
                xsv_ext0 = xsv_ext1 = xsb + 1
                dx_ext0 = dx_ext1 = dx0 - 1 - SQUISH_CONSTANT_4D
            end

            if (c1 & 0x02) == 0
                ysv_ext0 = ysv_ext1 = ysb
                dy_ext0 = dy_ext1 = dy0 - SQUISH_CONSTANT_4D
                if ((c1 & 0x01) == 0x01)
                    ysv_ext0 -= 1
                    dy_ext0 += 1
                else
                    ysv_ext1 -= 1
                    dy_ext1 += 1
                end
            else
                ysv_ext0 = ysv_ext1 = ysb + 1
                dy_ext0 = dy_ext1 = dy0 - 1 - SQUISH_CONSTANT_4D
            end

            if (c1 & 0x04) == 0
                zsv_ext0 = zsv_ext1 = zsb
                dz_ext0 = dz_ext1 = dz0 - SQUISH_CONSTANT_4D
                if (c1 & 0x03) == 0x03
                    zsv_ext0 -= 1
                    dz_ext0 += 1
                else
                    zsv_ext1 -= 1
                    dz_ext1 += 1
                end
            else
                zsv_ext0 = zsv_ext1 = zsb + 1
                dz_ext0 = dz_ext1 = dz0 - 1 - SQUISH_CONSTANT_4D
            end

            if (c1 & 0x08) == 0
                wsv_ext0 = wsb
                wsv_ext1 = wsb - 1
                dw_ext0 = dw0 - SQUISH_CONSTANT_4D
                dw_ext1 = dw0 + 1 - SQUISH_CONSTANT_4D
            else
                wsv_ext0 = wsv_ext1 = wsb + 1
                dw_ext0 = dw_ext1 = dw0 - 1 - SQUISH_CONSTANT_4D
            end

            # One contribution is a permutation of (0,0,0,2) based on the smaller-sided point
            xsv_ext2 = xsb
            ysv_ext2 = ysb
            zsv_ext2 = zsb
            wsv_ext2 = wsb
            dx_ext2 = dx0 - 2 * SQUISH_CONSTANT_4D
            dy_ext2 = dy0 - 2 * SQUISH_CONSTANT_4D
            dz_ext2 = dz0 - 2 * SQUISH_CONSTANT_4D
            dw_ext2 = dw0 - 2 * SQUISH_CONSTANT_4D
            if (c2 & 0x01) != 0
                xsv_ext2 += 2
                dx_ext2 -= 2
            elseif (c2 & 0x02) != 0
                ysv_ext2 += 2
                dy_ext2 -= 2
            elseif (c2 & 0x04) != 0
                zsv_ext2 += 2
                dz_ext2 -= 2
            else
                wsv_ext2 += 2
                dw_ext2 -= 2
            end
        end

        # Contribution (1,0,0,0)
        dx1 = dx0 - 1 - SQUISH_CONSTANT_4D
        dy1 = dy0 - 0 - SQUISH_CONSTANT_4D
        dz1 = dz0 - 0 - SQUISH_CONSTANT_4D
        dw1 = dw0 - 0 - SQUISH_CONSTANT_4D
        attn1 = 2 - dx1 * dx1 - dy1 * dy1 - dz1 * dz1 - dw1 * dw1
        if attn1 > 0
            attn1 *= attn1
            value += attn1 * attn1 * extrapolate(xsb + 1, ysb + 0, zsb + 0, wsb + 0, dx1, dy1, dz1, dw1)
        end

        # Contribution (0,1,0,0)
        dx2 = dx0 - 0 - SQUISH_CONSTANT_4D
        dy2 = dy0 - 1 - SQUISH_CONSTANT_4D
        dz2 = dz1
        dw2 = dw1
        attn2 = 2 - dx2 * dx2 - dy2 * dy2 - dz2 * dz2 - dw2 * dw2
        if attn2 > 0
            attn2 *= attn2
            value += attn2 * attn2 * extrapolate(xsb + 0, ysb + 1, zsb + 0, wsb + 0, dx2, dy2, dz2, dw2)
        end

        # Contribution (0,0,1,0)
        dx3 = dx2
        dy3 = dy1
        dz3 = dz0 - 1 - SQUISH_CONSTANT_4D
        dw3 = dw1
        attn3 = 2 - dx3 * dx3 - dy3 * dy3 - dz3 * dz3 - dw3 * dw3
        if attn3 > 0
            attn3 *= attn3
            value += attn3 * attn3 * extrapolate(xsb + 0, ysb + 0, zsb + 1, wsb + 0, dx3, dy3, dz3, dw3)
        end

        # Contribution (0,0,0,1)
        dx4 = dx2
        dy4 = dy1
        dz4 = dz1
        dw4 = dw0 - 1 - SQUISH_CONSTANT_4D
        attn4 = 2 - dx4 * dx4 - dy4 * dy4 - dz4 * dz4 - dw4 * dw4
        if attn4 > 0
            attn4 *= attn4
            value += attn4 * attn4 * extrapolate(xsb + 0, ysb + 0, zsb + 0, wsb + 1, dx4, dy4, dz4, dw4)
        end

        # Contribution (1,1,0,0)
        dx5 = dx0 - 1 - 2 * SQUISH_CONSTANT_4D
        dy5 = dy0 - 1 - 2 * SQUISH_CONSTANT_4D
        dz5 = dz0 - 0 - 2 * SQUISH_CONSTANT_4D
        dw5 = dw0 - 0 - 2 * SQUISH_CONSTANT_4D
        attn5 = 2 - dx5 * dx5 - dy5 * dy5 - dz5 * dz5 - dw5 * dw5
        if attn5 > 0
            attn5 *= attn5
            value += attn5 * attn5 * extrapolate(xsb + 1, ysb + 1, zsb + 0, wsb + 0, dx5, dy5, dz5, dw5)
        end

        # Contribution (1,0,1,0)
        dx6 = dx0 - 1 - 2 * SQUISH_CONSTANT_4D
        dy6 = dy0 - 0 - 2 * SQUISH_CONSTANT_4D
        dz6 = dz0 - 1 - 2 * SQUISH_CONSTANT_4D
        dw6 = dw0 - 0 - 2 * SQUISH_CONSTANT_4D
        attn6 = 2 - dx6 * dx6 - dy6 * dy6 - dz6 * dz6 - dw6 * dw6
        if attn6 > 0
            attn6 *= attn6
            value += attn6 * attn6 * extrapolate(xsb + 1, ysb + 0, zsb + 1, wsb + 0, dx6, dy6, dz6, dw6)
        end

        # Contribution (1,0,0,1)
        dx7 = dx0 - 1 - 2 * SQUISH_CONSTANT_4D
        dy7 = dy0 - 0 - 2 * SQUISH_CONSTANT_4D
        dz7 = dz0 - 0 - 2 * SQUISH_CONSTANT_4D
        dw7 = dw0 - 1 - 2 * SQUISH_CONSTANT_4D
        attn7 = 2 - dx7 * dx7 - dy7 * dy7 - dz7 * dz7 - dw7 * dw7
        if attn7 > 0
            attn7 *= attn7
            value += attn7 * attn7 * extrapolate(xsb + 1, ysb + 0, zsb + 0, wsb + 1, dx7, dy7, dz7, dw7)
        end

        # Contribution (0,1,1,0)
        dx8 = dx0 - 0 - 2 * SQUISH_CONSTANT_4D
        dy8 = dy0 - 1 - 2 * SQUISH_CONSTANT_4D
        dz8 = dz0 - 1 - 2 * SQUISH_CONSTANT_4D
        dw8 = dw0 - 0 - 2 * SQUISH_CONSTANT_4D
        attn8 = 2 - dx8 * dx8 - dy8 * dy8 - dz8 * dz8 - dw8 * dw8
        if attn8 > 0
            attn8 *= attn8
            value += attn8 * attn8 * extrapolate(xsb + 0, ysb + 1, zsb + 1, wsb + 0, dx8, dy8, dz8, dw8)
        end

        # Contribution (0,1,0,1)
        dx9 = dx0 - 0 - 2 * SQUISH_CONSTANT_4D
        dy9 = dy0 - 1 - 2 * SQUISH_CONSTANT_4D
        dz9 = dz0 - 0 - 2 * SQUISH_CONSTANT_4D
        dw9 = dw0 - 1 - 2 * SQUISH_CONSTANT_4D
        attn9 = 2 - dx9 * dx9 - dy9 * dy9 - dz9 * dz9 - dw9 * dw9
        if attn9 > 0
            attn9 *= attn9
            value += attn9 * attn9 * extrapolate(xsb + 0, ysb + 1, zsb + 0, wsb + 1, dx9, dy9, dz9, dw9)
        end

        # Contribution (0,0,1,1)
        dx10 = dx0 - 0 - 2 * SQUISH_CONSTANT_4D
        dy10 = dy0 - 0 - 2 * SQUISH_CONSTANT_4D
        dz10 = dz0 - 1 - 2 * SQUISH_CONSTANT_4D
        dw10 = dw0 - 1 - 2 * SQUISH_CONSTANT_4D
        attn10 = 2 - dx10 * dx10 - dy10 * dy10 - dz10 * dz10 - dw10 * dw10
        if attn10 > 0
            attn10 *= attn10
            value += attn10 * attn10 * extrapolate(xsb + 0, ysb + 0, zsb + 1, wsb + 1, dx10, dy10, dz10, dw10)
        end
    else  # We're inside the second dispentachoron (Rectified 4-Simplex)
        aIsBiggerSide = true
        bIsBiggerSide = true
        # Decide between (0,0,1,1) and (1,1,0,0)
        if (xins + yins) < (zins + wins)
            aScore = xins + yins
            aPoint = 0x0C
        else
            aScore = zins + wins
            aPoint = 0x03
        end

        # Decide between (0,1,0,1) and (1,0,1,0)
        if (xins + zins) < (yins + wins)
            bScore = xins + zins
            bPoint = 0x0A
        else
            bScore = yins + wins
            bPoint = 0x05
        end

        # Closer between (0,1,1,0) and (1,0,0,1) will replace the further of a and b, if closer.
        if (xins + wins) < (yins + zins)
            score = xins + wins
            if (aScore <= bScore) && (score < bScore)
                bScore = score
                bPoint = 0x06
            elseif (aScore > bScore) && (score < aScore)
                aScore = score
                aPoint = 0x06
            end
        else
            score = yins + zins
            if (aScore <= bScore) && (score < bScore)
                bScore = score
                bPoint = 0x09
            elseif (aScore > bScore) && (score < aScore)
                aScore = score
                aPoint = 0x09
            end
        end

        # Decide if (0,1,1,1) is closer.
        p1 = 3 - inSum + xins
        if (aScore <= bScore) && (p1 < bScore)
            bScore = p1
            bPoint = 0x0E
            bIsBiggerSide = false
        elseif (aScore > bScore) && (p1 < aScore)
            aScore = p1
            aPoint = 0x0E
            aIsBiggerSide = false
        end

        # Decide if (1,0,1,1) is closer.
        p2 = 3 - inSum + yins
        if (aScore <= bScore) && (p2 < bScore)
            bScore = p2
            bPoint = 0x0D
            bIsBiggerSide = false
        elseif (aScore > bScore) && (p2 < aScore)
            aScore = p2
            aPoint = 0x0D
            aIsBiggerSide = false
        end

        # Decide if (1,1,0,1) is closer.
        p3 = 3 - inSum + zins
        if (aScore <= bScore) && (p3 < bScore)
            bScore = p3
            bPoint = 0x0B
            bIsBiggerSide = false
        elseif (aScore > bScore) && (p3 < aScore)
            aScore = p3
            aPoint = 0x0B
            aIsBiggerSide = false
        end

        # Decide if (1,1,1,0) is closer.
        p4 = 3 - inSum + wins
        if (aScore <= bScore) && (p4 < bScore)
            bScore = p4
            bPoint = 0x07
            bIsBiggerSide = false
        elseif (aScore > bScore) && (p4 < aScore)
            aScore = p4
            aPoint = 0x07
            aIsBiggerSide = false
        end

        # Where each of the two closest points are determines how the extra three vertices are calculated.
        if aIsBiggerSide == bIsBiggerSide
            if aIsBiggerSide  # Both closest points on the bigger side
                c1 = aPoint & bPoint
                c2 = aPoint | bPoint
                # Two contributions are permutations of (0,0,0,1) and (0,0,0,2) based on c1
                xsv_ext0 = xsv_ext1 = xsb
                ysv_ext0 = ysv_ext1 = ysb
                zsv_ext0 = zsv_ext1 = zsb
                wsv_ext0 = wsv_ext1 = wsb
                dx_ext0 = dx0 - SQUISH_CONSTANT_4D
                dy_ext0 = dy0 - SQUISH_CONSTANT_4D
                dz_ext0 = dz0 - SQUISH_CONSTANT_4D
                dw_ext0 = dw0 - SQUISH_CONSTANT_4D
                dx_ext1 = dx0 - 2 * SQUISH_CONSTANT_4D
                dy_ext1 = dy0 - 2 * SQUISH_CONSTANT_4D
                dz_ext1 = dz0 - 2 * SQUISH_CONSTANT_4D
                dw_ext1 = dw0 - 2 * SQUISH_CONSTANT_4D
                if (c1 & 0x01) != 0
                    xsv_ext0 += 1
                    dx_ext0 -= 1
                    xsv_ext1 += 2
                    dx_ext1 -= 2
                elseif (c1 & 0x02) != 0
                    ysv_ext0 += 1
                    dy_ext0 -= 1
                    ysv_ext1 += 2
                    dy_ext1 -= 2
                elseif (c1 & 0x04) != 0
                    zsv_ext0 += 1
                    dz_ext0 -= 1
                    zsv_ext1 += 2
                    dz_ext1 -= 2
                else
                    wsv_ext0 += 1
                    dw_ext0 -= 1
                    wsv_ext1 += 2
                    dw_ext1 -= 2
                end

                # One contribution is a permutation of (1,1,1,-1) based on c2
                xsv_ext2 = xsb + 1
                ysv_ext2 = ysb + 1
                zsv_ext2 = zsb + 1
                wsv_ext2 = wsb + 1
                dx_ext2 = dx0 - 1 - 2 * SQUISH_CONSTANT_4D
                dy_ext2 = dy0 - 1 - 2 * SQUISH_CONSTANT_4D
                dz_ext2 = dz0 - 1 - 2 * SQUISH_CONSTANT_4D
                dw_ext2 = dw0 - 1 - 2 * SQUISH_CONSTANT_4D
                if (c2 & 0x01) == 0
                    xsv_ext2 -= 2
                    dx_ext2 += 2
                elseif (c2 & 0x02) == 0
                    ysv_ext2 -= 2
                    dy_ext2 += 2
                elseif (c2 & 0x04) == 0
                    zsv_ext2 -= 2
                    dz_ext2 += 2
                else
                    wsv_ext2 -= 2
                    dw_ext2 += 2
                end
            else  # Both closest points on the smaller side
                # One of the two extra points is (1,1,1,1)
                xsv_ext2 = xsb + 1
                ysv_ext2 = ysb + 1
                zsv_ext2 = zsb + 1
                wsv_ext2 = wsb + 1
                dx_ext2 = dx0 - 1 - 4 * SQUISH_CONSTANT_4D
                dy_ext2 = dy0 - 1 - 4 * SQUISH_CONSTANT_4D
                dz_ext2 = dz0 - 1 - 4 * SQUISH_CONSTANT_4D
                dw_ext2 = dw0 - 1 - 4 * SQUISH_CONSTANT_4D

                # Other two points are based on the shared axes.
                c = aPoint & bPoint

                if (c & 0x01) != 0
                    xsv_ext0 = xsb + 2
                    xsv_ext1 = xsb + 1
                    dx_ext0 = dx0 - 2 - 3 * SQUISH_CONSTANT_4D
                    dx_ext1 = dx0 - 1 - 3 * SQUISH_CONSTANT_4D
                else
                    xsv_ext0 = xsv_ext1 = xsb
                    dx_ext0 = dx_ext1 = dx0 - 3 * SQUISH_CONSTANT_4D
                end

                if (c & 0x02) != 0
                    ysv_ext0 = ysv_ext1 = ysb + 1
                    dy_ext0 = dy_ext1 = dy0 - 1 - 3 * SQUISH_CONSTANT_4D
                    if (c & 0x01) == 0
                        ysv_ext0 += 1
                        dy_ext0 -= 1
                    else
                        ysv_ext1 += 1
                        dy_ext1 -= 1
                    end
                else
                    ysv_ext0 = ysv_ext1 = ysb
                    dy_ext0 = dy_ext1 = dy0 - 3 * SQUISH_CONSTANT_4D
                end

                if (c & 0x04) != 0
                    zsv_ext0 = zsv_ext1 = zsb + 1
                    dz_ext0 = dz_ext1 = dz0 - 1 - 3 * SQUISH_CONSTANT_4D
                    if (c & 0x03) == 0
                        zsv_ext0 += 1
                        dz_ext0 -= 1
                    else
                        zsv_ext1 += 1
                        dz_ext1 -= 1
                    end
                else
                    zsv_ext0 = zsv_ext1 = zsb
                    dz_ext0 = dz_ext1 = dz0 - 3 * SQUISH_CONSTANT_4D
                end

                if (c & 0x08) != 0
                    wsv_ext0 = wsb + 1
                    wsv_ext1 = wsb + 2
                    dw_ext0 = dw0 - 1 - 3 * SQUISH_CONSTANT_4D
                    dw_ext1 = dw0 - 2 - 3 * SQUISH_CONSTANT_4D
                else
                    wsv_ext0 = wsv_ext1 = wsb
                    dw_ext0 = dw_ext1 = dw0 - 3 * SQUISH_CONSTANT_4D
                end
            end
        else  # One point on each "side"
            if aIsBiggerSide
                c1 = aPoint
                c2 = bPoint
            else
                c1 = bPoint
                c2 = aPoint
            end
            # Two contributions are the bigger-sided point with each 1 replaced with 2.
            if (c1 & 0x01) != 0
                xsv_ext0 = xsb + 2
                xsv_ext1 = xsb + 1
                dx_ext0 = dx0 - 2 - 3 * SQUISH_CONSTANT_4D
                dx_ext1 = dx0 - 1 - 3 * SQUISH_CONSTANT_4D
            else
                xsv_ext0 = xsv_ext1 = xsb
                dx_ext0 = dx_ext1 = dx0 - 3 * SQUISH_CONSTANT_4D
            end
            if (c1 & 0x02) != 0
                ysv_ext0 = ysv_ext1 = ysb + 1
                dy_ext0 = dy_ext1 = dy0 - 1 - 3 * SQUISH_CONSTANT_4D
                if (c1 & 0x01) == 0
                    ysv_ext0 += 1
                    dy_ext0 -= 1
                else
                    ysv_ext1 += 1
                    dy_ext1 -= 1
                end
            else
                ysv_ext0 = ysv_ext1 = ysb
                dy_ext0 = dy_ext1 = dy0 - 3 * SQUISH_CONSTANT_4D
            end
            if (c1 & 0x04) != 0
                zsv_ext0 = zsv_ext1 = zsb + 1
                dz_ext0 = dz_ext1 = dz0 - 1 - 3 * SQUISH_CONSTANT_4D
                if ((c1 & 0x03) == 0)
                    zsv_ext0 += 1
                    dz_ext0 -= 1
                else
                    zsv_ext1 += 1
                    dz_ext1 -= 1
                end
            else
                zsv_ext0 = zsv_ext1 = zsb
                dz_ext0 = dz_ext1 = dz0 - 3 * SQUISH_CONSTANT_4D
            end
            if (c1 & 0x08) != 0
                wsv_ext0 = wsb + 1
                wsv_ext1 = wsb + 2
                dw_ext0 = dw0 - 1 - 3 * SQUISH_CONSTANT_4D
                dw_ext1 = dw0 - 2 - 3 * SQUISH_CONSTANT_4D
            else
                wsv_ext0 = wsv_ext1 = wsb
                dw_ext0 = dw_ext1 = dw0 - 3 * SQUISH_CONSTANT_4D
            end

            # One contribution is a permutation of (1,1,1,-1) based on the smaller-sided point
            xsv_ext2 = xsb + 1
            ysv_ext2 = ysb + 1
            zsv_ext2 = zsb + 1
            wsv_ext2 = wsb + 1
            dx_ext2 = dx0 - 1 - 2 * SQUISH_CONSTANT_4D
            dy_ext2 = dy0 - 1 - 2 * SQUISH_CONSTANT_4D
            dz_ext2 = dz0 - 1 - 2 * SQUISH_CONSTANT_4D
            dw_ext2 = dw0 - 1 - 2 * SQUISH_CONSTANT_4D
            if (c2 & 0x01) == 0
                xsv_ext2 -= 2
                dx_ext2 += 2
            elseif (c2 & 0x02) == 0
                ysv_ext2 -= 2
                dy_ext2 += 2
            elseif (c2 & 0x04) == 0
                zsv_ext2 -= 2
                dz_ext2 += 2
            else
                wsv_ext2 -= 2
                dw_ext2 += 2
            end
        end

        # Contribution (1,1,1,0)
        dx4 = dx0 - 1 - 3 * SQUISH_CONSTANT_4D
        dy4 = dy0 - 1 - 3 * SQUISH_CONSTANT_4D
        dz4 = dz0 - 1 - 3 * SQUISH_CONSTANT_4D
        dw4 = dw0 - 3 * SQUISH_CONSTANT_4D
        attn4 = 2 - dx4 * dx4 - dy4 * dy4 - dz4 * dz4 - dw4 * dw4
        if attn4 > 0
            attn4 *= attn4
            value += attn4 * attn4 * extrapolate(xsb + 1, ysb + 1, zsb + 1, wsb + 0, dx4, dy4, dz4, dw4)
        end

        # Contribution (1,1,0,1)
        dx3 = dx4
        dy3 = dy4
        dz3 = dz0 - 3 * SQUISH_CONSTANT_4D
        dw3 = dw0 - 1 - 3 * SQUISH_CONSTANT_4D
        attn3 = 2 - dx3 * dx3 - dy3 * dy3 - dz3 * dz3 - dw3 * dw3
        if attn3 > 0
            attn3 *= attn3
            value += attn3 * attn3 * extrapolate(xsb + 1, ysb + 1, zsb + 0, wsb + 1, dx3, dy3, dz3, dw3)
        end

        # Contribution (1,0,1,1)
        dx2 = dx4
        dy2 = dy0 - 3 * SQUISH_CONSTANT_4D
        dz2 = dz4
        dw2 = dw3
        attn2 = 2 - dx2 * dx2 - dy2 * dy2 - dz2 * dz2 - dw2 * dw2
        if attn2 > 0
            attn2 *= attn2
            value += attn2 * attn2 * extrapolate(xsb + 1, ysb + 0, zsb + 1, wsb + 1, dx2, dy2, dz2, dw2)
        end

        # Contribution (0,1,1,1)
        dx1 = dx0 - 3 * SQUISH_CONSTANT_4D
        dz1 = dz4
        dy1 = dy4
        dw1 = dw3
        attn1 = 2 - dx1 * dx1 - dy1 * dy1 - dz1 * dz1 - dw1 * dw1
        if attn1 > 0
            attn1 *= attn1
            value += attn1 * attn1 * extrapolate(xsb + 0, ysb + 1, zsb + 1, wsb + 1, dx1, dy1, dz1, dw1)
        end

        # Contribution (1,1,0,0)
        dx5 = dx0 - 1 - 2 * SQUISH_CONSTANT_4D
        dy5 = dy0 - 1 - 2 * SQUISH_CONSTANT_4D
        dz5 = dz0 - 0 - 2 * SQUISH_CONSTANT_4D
        dw5 = dw0 - 0 - 2 * SQUISH_CONSTANT_4D
        attn5 = 2 - dx5 * dx5 - dy5 * dy5 - dz5 * dz5 - dw5 * dw5
        if attn5 > 0
            attn5 *= attn5
            value += attn5 * attn5 * extrapolate(xsb + 1, ysb + 1, zsb + 0, wsb + 0, dx5, dy5, dz5, dw5)
        end

        # Contribution (1,0,1,0)
        dx6 = dx0 - 1 - 2 * SQUISH_CONSTANT_4D
        dy6 = dy0 - 0 - 2 * SQUISH_CONSTANT_4D
        dz6 = dz0 - 1 - 2 * SQUISH_CONSTANT_4D
        dw6 = dw0 - 0 - 2 * SQUISH_CONSTANT_4D
        attn6 = 2 - dx6 * dx6 - dy6 * dy6 - dz6 * dz6 - dw6 * dw6
        if attn6 > 0
            attn6 *= attn6
            value += attn6 * attn6 * extrapolate(xsb + 1, ysb + 0, zsb + 1, wsb + 0, dx6, dy6, dz6, dw6)
        end

        # Contribution (1,0,0,1)
        dx7 = dx0 - 1 - 2 * SQUISH_CONSTANT_4D
        dy7 = dy0 - 0 - 2 * SQUISH_CONSTANT_4D
        dz7 = dz0 - 0 - 2 * SQUISH_CONSTANT_4D
        dw7 = dw0 - 1 - 2 * SQUISH_CONSTANT_4D
        attn7 = 2 - dx7 * dx7 - dy7 * dy7 - dz7 * dz7 - dw7 * dw7
        if attn7 > 0
            attn7 *= attn7
            value += attn7 * attn7 * extrapolate(xsb + 1, ysb + 0, zsb + 0, wsb + 1, dx7, dy7, dz7, dw7)
        end

        # Contribution (0,1,1,0)
        dx8 = dx0 - 0 - 2 * SQUISH_CONSTANT_4D
        dy8 = dy0 - 1 - 2 * SQUISH_CONSTANT_4D
        dz8 = dz0 - 1 - 2 * SQUISH_CONSTANT_4D
        dw8 = dw0 - 0 - 2 * SQUISH_CONSTANT_4D
        attn8 = 2 - dx8 * dx8 - dy8 * dy8 - dz8 * dz8 - dw8 * dw8
        if attn8 > 0
            attn8 *= attn8
            value += attn8 * attn8 * extrapolate(xsb + 0, ysb + 1, zsb + 1, wsb + 0, dx8, dy8, dz8, dw8)
        end

        # Contribution (0,1,0,1)
        dx9 = dx0 - 0 - 2 * SQUISH_CONSTANT_4D
        dy9 = dy0 - 1 - 2 * SQUISH_CONSTANT_4D
        dz9 = dz0 - 0 - 2 * SQUISH_CONSTANT_4D
        dw9 = dw0 - 1 - 2 * SQUISH_CONSTANT_4D
        attn9 = 2 - dx9 * dx9 - dy9 * dy9 - dz9 * dz9 - dw9 * dw9
        if attn9 > 0
            attn9 *= attn9
            value += attn9 * attn9 * extrapolate(xsb + 0, ysb + 1, zsb + 0, wsb + 1, dx9, dy9, dz9, dw9)
        end

        # Contribution (0,0,1,1)
        dx10 = dx0 - 0 - 2 * SQUISH_CONSTANT_4D
        dy10 = dy0 - 0 - 2 * SQUISH_CONSTANT_4D
        dz10 = dz0 - 1 - 2 * SQUISH_CONSTANT_4D
        dw10 = dw0 - 1 - 2 * SQUISH_CONSTANT_4D
        attn10 = 2 - dx10 * dx10 - dy10 * dy10 - dz10 * dz10 - dw10 * dw10
        if attn10 > 0
            attn10 *= attn10
            value += attn10 * attn10 * extrapolate(xsb + 0, ysb + 0, zsb + 1, wsb + 1, dx10, dy10, dz10, dw10)
        end
    end

    # First extra vertex
    attn_ext0 = 2 - dx_ext0 * dx_ext0 - dy_ext0 * dy_ext0 - dz_ext0 * dz_ext0 - dw_ext0 * dw_ext0
    if attn_ext0 > 0
        attn_ext0 *= attn_ext0
        value += attn_ext0 * attn_ext0 * extrapolate(xsv_ext0, ysv_ext0, zsv_ext0, wsv_ext0, dx_ext0, dy_ext0, dz_ext0, dw_ext0)
    end

    # Second extra vertex
    attn_ext1 = 2 - dx_ext1 * dx_ext1 - dy_ext1 * dy_ext1 - dz_ext1 * dz_ext1 - dw_ext1 * dw_ext1
    if attn_ext1 > 0
        attn_ext1 *= attn_ext1
        value += attn_ext1 * attn_ext1 * extrapolate(xsv_ext1, ysv_ext1, zsv_ext1, wsv_ext1, dx_ext1, dy_ext1, dz_ext1, dw_ext1)
    end

    # Third extra vertex
    attn_ext2 = 2 - dx_ext2 * dx_ext2 - dy_ext2 * dy_ext2 - dz_ext2 * dz_ext2 - dw_ext2 * dw_ext2
    if attn_ext2 > 0
        attn_ext2 *= attn_ext2
        value += attn_ext2 * attn_ext2 * extrapolate(xsv_ext2, ysv_ext2, zsv_ext2, wsv_ext2, dx_ext2, dy_ext2, dz_ext2, dw_ext2)
    end

    res = value / NORM_CONSTANT_4D
    # convert to [0 -> 1]
    return clamp((res + 1) / 2, 0.0, 1.0)
end
