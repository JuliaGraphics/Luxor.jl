# Clipping

Use `clip()` to turn the current path into a clipping region, masking any graphics outside the path. `clippreserve()` keeps the current path, but also uses it as a clipping region. `clipreset()` resets it. `:clip` is also an action for drawing functions like `circle()`.

```@example
using Luxor, Colors # hide
Drawing(400, 250, "../figures/simpleclip.png") # hide
background("white") # hide
origin() # hide
sethue("grey50")
setdash("dotted")
circle(O, 50, :stroke)
sethue("magenta")
circle(O, 50, :clip)
box(O, 50, 120, :fill)
finish() # hide
```
![simple clip](figures/simpleclip.png)

```@docs
clip
clippreserve
clipreset
```

This example loads a file containing a function that draws the Julia logo. It can create paths but doesn't necessarily apply an action to them; they can therefore be used as a mask for clipping subsequent graphics, which in this example are  randomly-colored circles:

![julia logo mask](figures/julia-logo-mask.png)

```julia
# load functions to draw the Julia logo
include("../test/julia-logo.jl")

function draw(x, y)
    foregroundcolors = diverging_palette(rand(0:360), rand(0:360), 200, s = 0.99, b=0.8)
    gsave()
    translate(x-100, y)
    julialogo(false, true)      # add paths for logo
    clip()                      # use paths for clipping
    for i in 1:500
        sethue(foregroundcolors[rand(1:end)])
        circle(rand(-50:350), rand(0:300), 15, :fill)
    end
    grestore()
end

currentwidth = 500 # pts
currentheight = 500 # pts
Drawing(currentwidth, currentheight, "/tmp/clipping-tests.pdf")
origin()
background("white")
setopacity(.4)
draw(0, 0)

finish()
preview()
```
