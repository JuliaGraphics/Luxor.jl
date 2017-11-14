# Turtle graphics

Some simple "turtle graphics" functions are included. Functions to control the turtle begin with a capital letter: Forward, Turn, Circle, Orientation, Rectangle, Pendown, Penup, Pencolor, Penwidth, and Reposition, and so on, and angles are specified in degrees.

```@example
using Luxor, Colors # hide
Drawing(600, 400, "assets/figures/turtles.png") # hide
origin() # hide
background("midnightblue") # hide

🐢 = Turtle() # you can type the turtle emoji with \:turtle:
Pencolor(🐢, "cyan")
Penwidth(🐢, 1.5)
n = 5
for i in 1:400
    Forward(🐢, n)
    Turn(🐢, 89.5)
    HueShift(🐢)
    n += 0.75
end
fontsize(20)
Message(🐢, "finished")
finish() # hide
nothing # hide
```

![text placement](assets/figures/turtles.png)

```@docs
Turtle
Forward
Turn
Circle
HueShift
Message
Orientation
Randomize_saturation
Rectangle
Pen_opacity_random
Pendown
Penup
Pencolor
Penwidth
Point
Pop
Push
Reposition
```
