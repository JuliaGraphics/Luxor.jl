```@meta
DocTestSetup = quote
    using Luxor, Colors
end
```
# Turtle graphics

Luxor provides some basic "turtle graphics" functions. Functions to control the turtle begin (somewhat unusually) with a capital letter: Forward, Turn, Circle, Orientation, Towards, Rectangle, Pendown, Penup, Pencolor, Penwidth, and Reposition, and so on, and angles are specified in degrees rather than radians.

```@example
using Luxor, Colors
Drawing(600, 400, "../assets/figures/turtles.png")
origin()
background("midnightblue")

🐢 = Turtle() # you can type the turtle emoji with \:turtle:
Pencolor(🐢, "cyan")
Penwidth(🐢, 1.5)
n = 5
for i in 1:400
    global n
    Forward(🐢, n)
    Turn(🐢, 89.5)
    HueShift(🐢)
    n += 0.75
end
fontsize(20)
Message(🐢, "finished")
finish()
nothing # hide
```

![turtles](../assets/figures/turtles.png)

|List of words the turtle knows|Action                                         |
|:---                          |:---                                           |
|[`Forward`](@ref)             | More forward by d units                       |
|[`Turn`](@ref)                | Increase the turtle's rotation by n degrees   |
|[`Circle`](@ref)              | Draw filled circle centered at current pos    |
|[`HueShift`](@ref)            | Shift the Hue of the turtle's pen color by n  |
|[`Message`](@ref)             | Output text                                   |
|[`Orientation`](@ref)         | Set the turtle's orientation to n degrees     |
|[`Pen_opacity_random`](@ref)  | Set opacity to random value                   |
|[`Pencolor`](@ref)            | Set the Red, Green, and Blue values           |
|[`Pendown`](@ref)             | Start drawing                                 |
|[`Penup`](@ref)               | Stop drawing                                  |
|[`Penwidth`](@ref)            | Set the width of the line to n                |
|[`Pop `](@ref)                | Move turtle to the value stored on the stack  |
|[`Push`](@ref)                | Save the turtle's position on the stack       |
|[`Randomize_saturation`](@ref)| Randomize the saturation of the current color |
|[`Rectangle`](@ref)           | Draw filled rectangle centered at current pos |
|[`Reposition`](@ref)          | Place turtle at new position                  |
|[`Towards`](@ref)             | Rotate turtle to face towards a point         |

The turtle commands expect a reference to a turtle as the first argument (it doesn't have to be a turtle emoji!), and you can have any number of turtles active at a time.

```@example
using Luxor, Colors # hide
Drawing(800, 800, "../assets/figures/manyturtles.svg") # hide
origin() # hide
background("white") # hide
quantity = 9
turtles = [Turtle(O, true, 2π * rand(), (rand(), rand(), 0.5)...) for i in 1:quantity]
Reposition.(turtles, first.(collect(Tiler(800, 800, 3, 3))))
n = 10
Penwidth.(turtles, 0.5)
for i in 1:300
    global n
    Forward.(turtles, n)
    HueShift.(turtles)
    Turn.(turtles, [60.1, 89.5, 110, 119.9, 120.1, 135.1, 145.1, 176, 190])
    n += 0.5
end
finish() # hide
nothing # hide
```

![many turtles](../assets/figures/manyturtles.svg)

A turtle graphics approach lends itself well to recursive programming. This short recursive function draws a Hilbert curve.

```@example
using Luxor, Colors # hide
Drawing(400, 400, "../assets/figures/hilbertturtle.svg") # hide
origin() # hide
background("black") # hide

function hilbert(t::Turtle, level, angle, lengthstep)
    level == 0 && return

    HueShift(t, 0.1)

    Turn(t, angle)
    hilbert(t, level-1, -angle, lengthstep)

    Forward(t, lengthstep)
    Turn(t, -angle)
    hilbert(t, level-1, angle, lengthstep)

    Forward(t, lengthstep)
    hilbert(t, level-1, angle, lengthstep)

    Turn(t, -angle)
    Forward(t, lengthstep)
    hilbert(t, level-1, -angle, lengthstep)

    Turn(t, angle)
end

@draw begin
background("black")
setline(2)
setlinecap("round")

hilbert(Turtle(first(BoundingBox()) + (12, 12), true, 0, (1, 0, 0)),
        6,  # level
        90, # turn angle, in degrees
        6   # steplength
        )
end
nothing # hide
```

![hilbert turtle](../assets/figures/hilbertturtle.svg)
