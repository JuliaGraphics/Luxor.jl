```@meta
DocTestSetup = quote
    using Luxor, Colors
    end
```
# Text and fonts

## A tale of two APIs

There are two ways to draw text in Luxor. You can use either the so-called 'toy' API or the 'pro' API.

Both have their advantages and disadvantages, and, given that trying to write anything definitive about font usage on three very different operating systems is an impossibility, trial and error will eventually lead to code patterns that work for you, if not other people.

#### The Toy API

Use:
- `text(string, [position])` to place text at a position, otherwise at `0/0`, and optionally specify the horizontal and vertical alignment
- `fontface(fontname)` to specify the fontname
- `fontsize(fontsize)` to specify the fontsize in points

```@example
using Luxor # hide
Drawing(600, 100, "assets/figures/toy-text-example.png") # hide
origin() # hide
background("azure") # hide
sethue("black") # hide
fontsize(18)
fontface("Georgia-Bold")
text("Georgia: a serif typeface designed in 1993 by Matthew Carter.", halign=:center)
finish() # hide
nothing # hide
```

![text placement](assets/figures/toy-text-example.png)

The `label()` function also uses the Toy API.

#### The Pro API

Use:

- `setfont(fontname, fontsize)` to specify the fontname and size in points
- `settext(text, [position])` to place the text at a position, and optionally specify horizontal and vertical alignment, rotation (in degrees counterclockwise!), and the presence of any Pango-flavored markup.

```@example
using Luxor # hide
Drawing(600, 100, "assets/figures/pro-text-example.png") # hide
origin() # hide
background("azure") # hide
sethue("black") # hide
setfont("Georgia Bold", 18)
settext("Georgia: a serif typeface designed in 1993 by Matthew Carter.", halign="center")
finish() # hide
nothing # hide
```

![text placement](assets/figures/pro-text-example.png)

## Specifying the font ("Toy" API)

Use `fontface(fontname)` to choose a font, and `fontsize(n)` to set the font size in points.

```@docs
fontface
fontsize
```

## Specifying the font ("Pro" API)

To select a font in the Pro text API, use `setfont()` and supply both the font name and a size.

```@docs
setfont
```

## Placing text ("Toy" API)

Use `text()` to place text.

```@example
using Luxor # hide
Drawing(400, 150, "assets/figures/text-placement.png") # hide
origin() # hide
background("white") # hide
fontsize(80) # hide
sethue("black") # hide
pt1 = Point(-100, 0)
pt2 = Point(0, 0)
pt3 = Point(100, 0)
sethue("black")
text("1",  pt1, halign=:left,   valign = :bottom)
text("2",  pt2, halign=:center, valign = :bottom)
text("3",  pt3, halign=:right,  valign = :bottom)
text("4",  pt1, halign=:left,   valign = :top)
text("5 ", pt2, halign=:center, valign = :top)
text("6",  pt3, halign=:right,  valign = :top)
sethue("red")
map(p -> circle(p, 4, :fill), [pt1, pt2, pt3])
finish() # hide
nothing # hide
```

![text placement](assets/figures/text-placement.png)

```@example
using Luxor # hide
Drawing(400, 300, "assets/figures/text-rotation.png") # hide
origin() # hide
background("white") # hide
sethue("black") # hide
fontsize(10)
fontface("Georgia")
[text(string(θ), Point(40cos(θ), 40sin(θ)), angle=θ) for θ in 0:π/12:47π/24]
finish() # hide
nothing # hide
```

![text rotation](assets/figures/text-rotation.png)

```@docs
text
```

## Placing text ("Pro" API)

Use `settext()` to place text. You can include some pseudo-HTML markup.

```@example
using Luxor # hide
Drawing(400, 150, "assets/figures/pro-text-placement.png") # hide
origin() # hide
background("white") # hide
rulers()
sethue("black")
settext("<span font='26' background ='green' foreground='red'> Hey</span>
    <i>italic</i> <b>bold</b> <sup>superscript</sup>
    <tt>monospaced</tt>",
    halign="center",
    markup=true,
    angle=10) # degrees counterclockwise!
finish() # hide
nothing # hide
```

![pro text placement](assets/figures/pro-text-placement.png)

```@docs
settext
```

## Notes on fonts

On macOS, the fontname required by the Toy API's `fontface()` should be the PostScript name of a currently activated font. You can find this out using, for example, the FontBook application.

On macOS, a list of currently activated fonts can be found (after a while) with the shell command:

    system_profiler SPFontsDataType

Fonts currently activated by a Font Manager can be found and used by the Toy API but not by the Pro API (at least on my macOS computer currently).

On macOS, you can obtain a list of fonts that `fontconfig` considers are installed and available for use (via the Pro Text API with `setfont()`) using the shell command:

    fc-list | cut -f 2 -d ":"

although typically this lists only those fonts in `/System/Library/Fonts` and `/Library/Fonts`, and not `~/Library/Fonts`.

(There is a Julia interface to `fontconfig` at [Fontconfig.jl](https://github.com/JuliaGraphics/Fontconfig.jl).)

In the Pro API, the default font is Times Roman (on macOS). In the Toy API, the default font is Helvetica (on macOS).

One difference between `settext()` and `text()` (on macOS) is that many more missing Unicode glyphs are automatically substituted by other fonts when you use the former. 

Cairo (and hence Luxor) doesn't support emoji currently. 😢

## Text to paths

`textoutlines(string, position, action)` converts the text into graphic path(s), places them starting at `position`, and applies the `action`.

```@example
using Luxor # hide
Drawing(400, 400, "assets/figures/textoutlines.png") # hide
origin() # hide
background("white") # hide
fontface("Times-Roman")
fontsize(500)
setline(4)
sethue("maroon2")
textoutlines("&", O, :path, valign=:middle, halign=:center)
fillpreserve()
sethue("black")
strokepath()
finish() # hide
nothing # hide
```

![text outlines](assets/figures/textoutlines.png)

```@docs
textoutlines
```

`textpath()` converts the text into graphic paths suitable for further manipulation.

```@docs
textpath
```

## Font dimensions ("Toy" API)

The `textextents(str)` function gets an array of dimensions of the string `str`, given the current font.

![textextents](assets/figures/textextents.png)

The green dot is the text placement point and reference point for the font, the yellow circle shows the text block's x and y bearings, and the blue dot shows the advance point where the next character should be placed.

```@docs
textextents
```
## Labels

The `label()` function places text relative to a specific point, and you can use compass
points to indicate where it should be. So `:N` (for North) places a text label directly above the point.

```@example
using Luxor # hide
Drawing(400, 350, "assets/figures/labels.png") # hide
origin() # hide
background("white") # hide
sethue("black")
fontsize(15)
octagon = ngon(O, 100, 8, 0, vertices=true)

compass = [:SE, :S, :SW, :W, :NW, :N, :NE, :E, :SE]

for i in 1:8
    circle(octagon[i], 5, :fill)
    label(string(compass[i]), compass[i], octagon[i], leader=true, leaderoffsets=[0.2, 0.9], offset=50)
end

finish() # hide
nothing # hide
```

![labels](assets/figures/labels.png)

```@docs
label
```

## Text on a curve

Use `textcurve(str)` to draw a string `str` on a circular arc or spiral.

```@example
using Luxor # hide
Drawing(1800, 1800, "assets/figures/text-spiral.png") # hide
origin() # hide
background("ivory") # hide
fontsize(16) # hide
fontface("Menlo") # hide
sethue("royalblue4") # hide
textstring = join(names(Base), " ")
textcurve("this spiral contains every word in julia names(Base): " * textstring,
    -π/2,
    800, 0, 0,
    spiral_in_out_shift = -18.0,
    letter_spacing = 0,
    spiral_ring_step = 0)
fontsize(35)
fontface("Avenir-Black")
textcentered("julia names(Base)", 0, 0)
finish() # hide
nothing # hide
```

![text on a curve or spiral](assets/figures/text-spiral.png)

For shorter strings, `textcurvecentered()` tries to place the text on a circular arc by its center point.

```@example
using Luxor # hide
Drawing(400, 250, "assets/figures/text-centered.png") # hide
origin() # hide
background("white") # hide
fontface("Arial-Black")
fontsize(24) # hide
sethue("black") # hide
setdash("dot") # hide
setline(0.25) # hide
circle(O, 100, :stroke)
textcurvecentered("hello world", -π/2, 100, O;
    clockwise = true,
    letter_spacing = 0,
    baselineshift = -20
    )
textcurvecentered("hello world", π/2, 100, O;
    clockwise = false,
    letter_spacing = 0,
    baselineshift = 10
    )
finish() # hide
nothing # hide
```

![text centered on curve](assets/figures/text-centered.png)

```@docs
textcurve
textcurvecentered
```

## Text clipping

You can use newly-created text paths as a clipping region - here the text paths are filled with names of randomly chosen Julia functions:

![text clipping](assets/figures/text-path-clipping.png)

```julia
using Luxor

currentwidth = 1250 # pts
currentheight = 800 # pts
Drawing(currentwidth, currentheight, "/tmp/text-path-clipping.png")

origin()
background("darkslategray3")

fontsize(600)                             # big fontsize to use for clipping
fontface("Agenda-Black")
str = "julia"                             # string to be clipped
w, h = textextents(str)[3:4]              # get width and height

translate(-(currentwidth/2) + 50, -(currentheight/2) + h)

textpath(str)                             # make text into a path
setline(3)
setcolor("black")
fillpreserve()                            # fill but keep
clip()                                    # and use for clipping region

fontface("Monaco")
fontsize(10)
namelist = map(x->string(x), names(Base)) # get list of function names in Base.

x = -20
y = -h
while y < currentheight
    sethue(rand(7:10)/10, rand(7:10)/10, rand(7:10)/10)
    s = namelist[rand(1:end)]
    text(s, x, y)
    se = textextents(s)
    x += se[5]                            # move to the right
    if x > w
       x = -20                            # next row
       y += 10
    end
end

finish()
preview()
```

## Text blocks, boxes, and wrapping

Longer lines of text can be made to wrap inside an imaginary rectangle with `textwrap()`. Specify the required width of the rectangle, and the location of the top left corner.

```@example

using Luxor # hide
Drawing(500, 400, "assets/figures/text-wrapping.png") # hide
origin() # hide
background("white") # hide
fontface("Georgia")
fontsize(12) # hide
sethue("black") # hide

loremipsum = """Lorem ipsum dolor sit amet, consectetur
adipiscing elit. Nunc placerat lorem ullamcorper,
sagittis massa et, elementum dui. Sed dictum ipsum vel
commodo pellentesque. Aliquam erat volutpat. Nam est
dolor, vulputate a molestie aliquet, rutrum quis lectus.
Sed lectus mauris, tristique et tempor id, accumsan
pharetra lacus. Donec quam magna, accumsan a quam
quis, mattis hendrerit nunc. Nullam vehicula leo ac
leo tristique, a condimentum tortor faucibus."""

setdash("dot")
box(O, 200, 200, :stroke)
textwrap(loremipsum, 200, O - (200/2, 200/2))

finish() # hide
nothing # hide
```

![text wrapping](assets/figures/text-wrapping.png)

`textwrap()` accepts a function that allows you to insert code that responds to the next line's linenumber, contents, position, and height.

```@example
using Luxor, Colors # hide
Drawing(500, 400, "assets/figures/text-wrapping-1.png") # hide
origin() # hide
background("white") # hide
fontface("Georgia")
fontsize(12) # hide
sethue("black") # hide

loremipsum = """Lorem ipsum dolor sit amet, consectetur
adipiscing elit. Nunc placerat lorem ullamcorper,
sagittis massa et, elementum dui. Sed dictum ipsum vel
commodo pellentesque. Aliquam erat volutpat. Nam est
dolor, vulputate a molestie aliquet, rutrum quis lectus.
Sed lectus mauris, tristique et tempor id, accumsan
pharetra lacus. Donec quam magna, accumsan a quam
quis, mattis hendrerit nunc. Nullam vehicula leo ac
leo tristique, a condimentum tortor faucibus."""

textwrap(loremipsum, 200, O - (200/2, 200/2),
    (lnumber, str, pt, h) -> begin
        sethue(Colors.HSB(rescale(lnumber, 1, 15, 0, 360), 1, 1))
        text(string("line ", lnumber), pt - (50, 0))
    end)

finish() # hide
nothing # hide
```

![text wrapped](assets/figures/text-wrapping-1.png)

The `textbox()` function also draws text inside a box, but doesn't alter the lines, and doesn't force the text to a specific width. Supply an array of strings and the top left position. The `leading` argument specifies the distance between the lines, so should be set relative to the current font size (as set with `fontsize()`).

This example counts the number of characters drawn, using a simple closure.

```@example
using Luxor, Colors # hide
Drawing(600, 300, "assets/figures/textbox.png") # hide
origin() # hide
background("ivory") # hide
sethue("black") # hide
fontface("Georgia")
fontsize(30)

loremipsum = """Lorem ipsum dolor sit amet, consectetur
adipiscing elit. Nunc placerat lorem ullamcorper,
sagittis massa et, elementum dui. Sed dictum ipsum vel
commodo pellentesque. Aliquam erat volutpat. Nam est
dolor, vulputate a molestie aliquet, rutrum quis lectus.
Sed lectus mauris, tristique et tempor id, accumsan
pharetra lacus. Donec quam magna, accumsan a quam
quis, mattis hendrerit nunc. Nullam vehicula leo ac
leo tristique, a condimentum tortor faucibus."""

_counter() = (a = 0; (n) -> a += n)
counter = _counter()

translate(Point(-600/2, -300/2) + (50, 50))
fontface("Georgia")
fontsize(20)

textbox(filter(!isempty, split(loremipsum, "\n")),
    O,
    leading = 28,
    linefunc = (lnumber, str, pt, h) -> begin
        text(string(lnumber), pt - (30, 0))
        counter(length(str))
    end)

fontsize(10)
text(string(counter(0), " characters"), O + (0, 230))

finish() # hide
nothing # hide
```

![textbox](assets/figures/textbox.png)

```@docs
textwrap
textbox
splittext
```
