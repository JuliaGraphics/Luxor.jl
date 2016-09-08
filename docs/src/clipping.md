# Clipping

Use `clip()` to turn the current path into a clipping region, masking any graphics outside the path. `clippreserve()` keeps the current path, but also uses it as a clipping region. `clipreset()` resets it. `:clip` is also an action for drawing functions like `circle()`.

```@docs
clip
clippreserve
clipreset
```

This example loads a file containing a function that draws the Julia logo. It can create paths but doesn't necessarily apply an action to them; they can therefore be used as a mask for clipping subsequent graphics, which in this example are mainly randomly-colored circles:

![julia logo mask](figures/julia-logo-mask.png)

```julia
# load functions to draw the Julia logo
include("../test/julia-logo.jl")

currentwidth = 500 # pts
currentheight = 500 # pts
Drawing(currentwidth, currentheight, "/tmp/clipping-tests.pdf")

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

origin()
background("white")
setopacity(.4)
draw(0, 0)

finish()
preview()
```
