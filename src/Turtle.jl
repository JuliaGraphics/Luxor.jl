export  Turtle,
        Forward,
        Turn,
        Pendown,
        Penup,
        Circle,
        Orientation,
        Rectangle,
        Push,
        Pop,
        Message,
        HueShift,
        Randomize_saturation,
        Pencolor,
        Penwidth,
        Pen_opacity_random,
        Reposition,
        Towards

"""
    Turtle()
    Turtle(O)
    Turtle(0, 0)
    Turtle(O, pendown=true, orientation=0, pencolor=(1.0, 0.25, 0.25))

Create a Turtle. You can command a turtle to move and draw "turtle graphics".

The commands (unusually for Julia) start with a capital letter, and angles are specified in degrees.

Basic commands are `Forward()`, `Turn()`, `Pendown()`, `Penup()`, `Pencolor()`,
`Penwidth()`, `Circle()`, `Orientation()`, `Rectangle()`, and `Reposition()`.

Others include `Push()`, `Pop()`, `Message()`, `HueShift()`, `Randomize_saturation()`,
`Reposition()`, and `Pen_opacity_random()`.
"""
mutable struct Turtle
    xpos::Float64
    ypos::Float64
    pendown::Bool
    orientation::Float64 # stored in radians but set in degrees
    pencolor::Tuple{Float64, Float64, Float64} # it's an RGB turtle
    function Turtle(xpos, ypos, pendown::Bool, orientation, pencolor=(0.0, 0.0, 0.0))
        new(xpos, ypos, pendown, orientation, pencolor)
    end
end

Turtle(x, y) = Turtle(x, y, true, 0, (0, 0, 0))
Turtle(pos::Point=O) = Turtle(pos.x, pos.y, true, 0, (0, 0, 0))
Turtle(pos::Point, pendown::Bool) = Turtle(pos.x, pos.y, pendown, 0, (0, 0, 0))
Turtle(pos::Point, pendown::Bool, orientation) = Turtle(pos.x, pos.y, pendown, orientation, (0, 0, 0))
Turtle(pos::Point, pendown::Bool, orientation, col::NTuple{3, Number}) = Turtle(pos.x, pos.y, pendown, orientation, col)
Turtle(pos::Point, pendown::Bool, orientation, r, g, b) = Turtle(pos.x, pos.y, pendown, orientation, (r, g, b))

Base.broadcastable(t::Turtle) = Ref(t)

# a stack to hold pushed/popped turtle positions
const queue = Array{Array{Float64, 1}, 1}()

"""
    Forward(t::Turtle, d=1)

Move the turtle forward by `d` units. The stored position is updated.
"""
function Forward(t::Turtle, d=1)
    oldx, oldy = t.xpos, t.ypos
    t.xpos += (d * cos(t.orientation))
    t.ypos += (d * sin(t.orientation))
    if t.pendown
        gsave()
        sethue(t.pencolor...)
        line(Point(oldx, oldy), Point(t.xpos, t.ypos), :stroke)
        grestore()
    end
end

"""
    Turn(t::Turtle, r=5.0)

Increase the turtle's rotation by `r` degrees. See also `Orientation`.
"""
function Turn(t::Turtle, r=5.0)
    t.orientation = mod2pi(t.orientation + deg2rad(r))
end

"""
    Orientation(t::Turtle, r=0.0)

Set the turtle's orientation to `r` degrees. See also `Turn`.
"""
function Orientation(t::Turtle, r=0.0)
    t.orientation = mod2pi(deg2rad(r))
end

"""
    Towards(t::Turtle, pos::Point)

Rotate the turtle to face towards a given point.
"""
function Towards(t::Turtle, pos::Point)
    x, y = pos

    dx = x - t.xpos
    dy = y - t.ypos

    t.orientation = atan(dy, dx)
end

"""
    Pendown(t::Turtle)

Put that pen down and start drawing.
"""
function Pendown(t::Turtle)
    t.pendown = true
end

"""
    Penup(t::Turtle)

Pick that pen up and stop drawing.
"""
function Penup(t::Turtle)
    t.pendown = false
end

"""
    Circle(t::Turtle, radius=1.0)

Draw a filled circle centered at the current position with the given radius.
"""
function Circle(t::Turtle, radius=1.0)
    gsave()
    sethue(t.pencolor...)
    circle(t.xpos, t.ypos, radius, :fill)
    grestore()
end

"""
    Rectangle(t::Turtle, width=10.0, height=10.0)

Draw a filled rectangle centered at the current position with the given radius.
"""
function Rectangle(t::Turtle, width=10.0, height=10.0)
    gsave()
    sethue(t.pencolor...)
    rect(t.xpos-width/2, t.ypos-height/2, width, height, :fill)
    grestore()
end

"""
    Push(t::Turtle)

Save the turtle's position and orientation on a stack.
"""
function Push(t::Turtle)
# save xpos, ypos, turn in a queue
    global queue
    push!(queue, [t.xpos, t.ypos, t.orientation])
end

"""
    Pop(t::Turtle)

Lift the turtle's position and orientation off a stack.
"""
function Pop(t::Turtle)
# restore xpos, ypos, turn from queue
    global queue
    if isempty(queue)
        @info("stack was already empty")
        t.xpos, t.ypos, t.orientation = 0.0, 0.0, 0.0
    else
        t.xpos, t.ypos, t.orientation = pop!(queue)
    end
end

"""
    Message(t::Turtle, txt)

Write some text at the current position.
"""
function Message(t::Turtle, txt)
    gsave()
    sethue(t.pencolor...)
    text(txt, t.xpos, t.ypos)
    grestore()
end

"""
    HueShift(t::Turtle, inc=1.0)

Shift the Hue of the turtle's pen forward by `inc`. Hue values range between
0 and 360. (Don't start with black, otherwise the saturation and brightness values
will be black.)
"""
function HueShift(t::Turtle, inc=1.0)
    r, g, b = t.pencolor
    hsv = convert(Colors.HSV, Colors.RGB(r, g, b))
    newhsv = (mod(hsv.h + inc, 360), hsv.s, hsv.v)
    newrgb = convert(Colors.RGB, Colors.HSV(newhsv[1], newhsv[2], newhsv[3]))
    sethue(newrgb)
    t.pencolor = (newrgb.r, newrgb.g, newrgb.b)
end

"""
    Randomize_saturation(t::Turtle)

Randomize the saturation of the turtle's pen color.
"""
function Randomize_saturation(t::Turtle)
    r, g, b = t.pencolor
    hsv = convert(Colors.HSV, Colors.RGB(r, g, b))
    newhsv = (hsv.h, rand(0.5:0.05:1.0), hsv.v)
    newrgb= convert(Colors.RGB, Colors.HSV(newhsv[1], newhsv[2], newhsv[3]))
    sethue(newrgb)
    t.pencolor = (newrgb.r, newrgb.g, newrgb.b)
end

"""
    Pencolor(t::Turtle, r, g, b)

Set the Red, Green, and Blue colors of the turtle.
"""
function Pencolor(t::Turtle, r, g, b)
    sethue(r, g, b)
    t.pencolor = (r, g, b)
end

function Pencolor(t::Turtle, col::Colors.Colorant)
    temp = convert(RGBA, col)
    Pencolor(t::Turtle, temp.r, temp.g, temp.b)
end

function Pencolor(t::Turtle, col::AbstractString)
    temp = parse(RGBA, col)
    Pencolor(t::Turtle, temp.r, temp.g, temp.b)
end

Pencolor(t::Turtle, col::NTuple{3, Number}) = Pencolor(t, col...)

"""
    Reposition(t::Turtle, pos::Point)
    Reposition(t::Turtle, x, y)

Reposition: pick the turtle up and place it at another position.
"""
function Reposition(t::Turtle, x, y)
    t.xpos = x
    t.ypos = y
end

Reposition(t::Turtle, pos::Point) = Reposition(t, pos.x, pos.y)

"""
    Penwidth(t::Turtle, w)

Set the width of the line drawn.
"""
Penwidth(t::Turtle, w) = setline(w)

"""
    Pen_opacity_random(t::Turtle)

Change the opacity of the pen to some value at random.
"""
Pen_opacity_random(t::Turtle) = setopacity(rand())

# end
