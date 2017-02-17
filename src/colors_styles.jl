"""
    setcolor("gold")
    setcolor("darkturquoise")

Set the current color to a named color. This use the definitions in Colors.jl to convert a
string to RGBA eg `setcolor("gold")` or "green", "darkturquoise", "lavender", etc. The list
is at `Colors.color_names`.

Use `sethue()` for changing colors without changing current opacity level.

`sethue()` and `setcolor()` return the three or four values that were used:

    julia> setcolor(sethue("red")..., .8)

    (1.0,0.0,0.0,0.8)

    julia> sethue(setcolor("red")[1:3]...)

    (1.0,0.0,0.0)
"""
function setcolor(col::String)
    temp = parse(RGBA, col)
    currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue,
        currentdrawing.alpha = temp.r, temp.g, temp.b, temp.alpha
    Cairo.set_source_rgba(currentdrawing.cr, currentdrawing.redvalue,
        currentdrawing.greenvalue, currentdrawing.bluevalue, temp.alpha)
    return (currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue, currentdrawing.alpha)
end

"""
    setcolor(r, g, b)
    setcolor(r, g, b, alpha)
    setcolor(color)
    setcolor(col::ColorTypes.Colorant)

Set the current color.

Examples:

    setcolor(convert(Colors.HSV, Colors.RGB(0.5, 1, 1)))
    setcolor(.2, .3, .4, .5)
    setcolor(convert(Colors.HSV, Colors.RGB(0.5, 1, 1)))

    for i in 1:15:360
       setcolor(convert(Colors.RGB, Colors.HSV(i, 1, 1)))
       ...
    end
"""
function setcolor(col::ColorTypes.Colorant)
  temp = convert(RGBA, col)
  setcolor(temp.r, temp.g, temp.b)
  return (currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue, currentdrawing.alpha)
end

function setcolor(r, g, b, a=1)
    currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue,
      currentdrawing.alpha = r, g, b, a
    Cairo.set_source_rgba(currentdrawing.cr, r, g, b, a)
    return (r, g, b, a)
end

"""
Set the current color to a string.

For example:

    setcolor"red"
"""
macro setcolor_str(ex)
    isa(ex, String) || error("colorant requires literal strings")
    col = parse(RGBA, ex)
    quote
    currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue,
      currentdrawing.alpha = $col.r, $col.g, $col.b, $col.alpha
    Cairo.set_source_rgba(currentdrawing.cr, currentdrawing.redvalue,
      currentdrawing.greenvalue, currentdrawing.bluevalue, $col.alpha)
    end
end

"""
    sethue("black")
    sethue(0.3,0.7,0.9)

Set the color without changing opacity.

`sethue()` is like `setcolor()`, but we sometimes want to change the current color without
changing alpha/opacity. Using `sethue()` rather than `setcolor()` doesn't change the current
alpha opacity.
"""
function sethue(col::String)
    temp = parse(RGBA,  col)
    currentdrawing.redvalue, currentdrawing.greenvalue,
        currentdrawing.bluevalue = temp.r, temp.g, temp.b
    # use current alpha, not incoming one
    Cairo.set_source_rgba(currentdrawing.cr, currentdrawing.redvalue,
        currentdrawing.greenvalue, currentdrawing.bluevalue, currentdrawing.alpha)
    return (currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue)
end

"""
    sethue(col::ColorTypes.Colorant)

Set the color without changing the current alpha/opacity:
"""
function sethue(col::ColorTypes.Colorant)
    temp = convert(RGBA,  col)
    currentdrawing.redvalue, currentdrawing.greenvalue,
        currentdrawing.bluevalue = temp.r, temp.g, temp.b
    # use current alpha
    Cairo.set_source_rgba(currentdrawing.cr, temp.r, temp.g, temp.b, currentdrawing.alpha)
    return (currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue)
end

"""
    sethue(0.3, 0.7, 0.9)

Set the color's `r`, `g`, `b` values. Use `setcolor(r,g,b,a)` to set transparent colors.
"""
function sethue(r, g, b)
    currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue = r, g, b
    # use current alpha
    Cairo.set_source_rgba(currentdrawing.cr, r, g, b, currentdrawing.alpha)
    return (currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue)
end

"""
    setopacity(alpha)

Set the current opacity to a value between 0 and 1. This modifies the alpha value of the
current color.
"""
function setopacity(a)
    # use current RGB values
    currentdrawing.alpha = a
    Cairo.set_source_rgba(currentdrawing.cr, currentdrawing.redvalue,
        currentdrawing.greenvalue, currentdrawing.bluevalue, currentdrawing.alpha)
    return a
end

"""
    setgray(n)
    setgrey(n)

Set the color to a gray level of `n`, where `n` is between 0 and 1.

"""
setgray(n) = sethue(n, n, n)
setgrey(n) = setgray(n)

"""
    randomhue()

Set a random hue, without changing the current alpha opacity.
"""
function randomhue()
  rrand, grand, brand = rand(3)
  sethue(rrand, grand, brand)
  return (currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue)
end

"""
    randomcolor()

Set a random color. This may change the current alpha opacity too.
"""
function randomcolor()
  rrand, grand, brand, arand = rand(4)
  setcolor(rrand, grand, brand, arand)
  return (currentdrawing.redvalue, currentdrawing.greenvalue, currentdrawing.bluevalue, currentdrawing.alpha)
end

# compositing operators
const blendingmodes = ["clear", "source", "over", "in", "out", "atop", "dest", "dest_over", "dest_in", "dest_out", "dest_atop", "xor", "add", "saturate", "multiply", "screen", "overlay", "darken", "lighten"]

const blendingoperators = [Cairo.OPERATOR_CLEAR, Cairo.OPERATOR_SOURCE, Cairo.OPERATOR_OVER, Cairo.OPERATOR_IN, Cairo.OPERATOR_OUT, Cairo.OPERATOR_ATOP, Cairo.OPERATOR_DEST, Cairo.OPERATOR_DEST_OVER, Cairo.OPERATOR_DEST_IN, Cairo.OPERATOR_DEST_OUT, Cairo.OPERATOR_DEST_ATOP, Cairo.OPERATOR_XOR, Cairo.OPERATOR_ADD, Cairo.OPERATOR_SATURATE, Cairo.OPERATOR_MULTIPLY, Cairo.OPERATOR_SCREEN, Cairo.OPERATOR_OVERLAY, Cairo.OPERATOR_DARKEN, Cairo.OPERATOR_LIGHTEN]

#=
Not yet supported in Cairo.jl?

Cairo.OPERATOR_COLOR_DODGE, Cairo.OPERATOR_COLOR_BURN, Cairo.OPERATOR_HARD_LIGHT, Cairo.OPERATOR_SOFT_LIGHT, Cairo.OPERATOR_DIFFERENCE, Cairo.OPERATOR_EXCLUSION, Cairo.OPERATOR_HSL_HUE, Cairo.OPERATOR_HSL_SATURATION, Cairo.OPERATOR_HSL_COLOR, Cairo.OPERATOR_HSL_LUMINOSITY
=#

"""
    setmode(mode::String)

Set the compositing/blending mode. `mode` can be one of:

- `"clear"` Where the second object is drawn, the first is completely removed.
- `"source"` The second object is drawn as if nothing else were below.
- `"over"` The default mode: like two transparent slides overlapping.
- `"in"` The first object is removed completely, the second is only drawn where the first was.
- `"out"` The second object is drawn only where the first one wasn't.
- `"atop"` The first object is mostly intact, but mixes both objects in the overlapping area. The second object object is not drawn elsewhere.
- `"dest"` Discard the second object completely.
- `"dest_over"` Like "over" but draw second object below the first
- `"dest_in"` Keep the first object whereever the second one overlaps.
- `"dest_out"` The second object is used to reduce the visibility of the first where they overlap.
- `"dest_atop"` Like "over" but draw second object below the first.
- `"xor"` XOR where the objects overlap
- `"add"` Add the overlapping areas together
- `"saturate"` Increase Saturation where objects overlap
- `"multiply"` Multiply where objects overlap
- `"screen"` Input colors are complemented and multiplied, the product is complemented again. The result is at least as light as the lighter of the input colors.
- `"overlay"` Multiplies or screens colors, depending on the lightness of the destination color.
- `"darken"` Selects the darker of the color values in each component.
- `"lighten"` Selects the lighter of the color values in each component.

See the [Cairo documentation](https://www.cairographics.org/operators/) for details.
"""
function setmode(operator::String)
    indx = findfirst(blendingmodes, operator)
    if indx != 0
        Cairo.set_operator(currentdrawing.cr, blendingoperators[indx])
    end
end

"""
    getmode()

Get the compositing/blending mode.
"""
function getmode()
    return findfirst(blendingmodes, Cairo.get_operator(currentdrawing.cr))
end
