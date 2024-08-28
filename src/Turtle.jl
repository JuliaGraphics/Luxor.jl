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
    xpos::Union{Real, Int}
    ypos::Union{Real, Int}
    pendown::Bool
    orientation::Float64 # stored in radians but set in degrees
    pencolor::NTuple{3, Float64} # it's an RGB turtle
    function Turtle(xpos::Union{Real, Int}, ypos::Union{Real, Int},
                    pendown::Bool, orientation, pencolor=(0.0, 0.0, 0.0))
        new(xpos, ypos, pendown, orientation, pencolor)
    end
end

Turtle(x::Float64, y::Float64) = Turtle(x, y, true, 0, (0, 0, 0))
Turtle(pos::Point=O) = Turtle(pos.x, pos.y, true, 0, (0, 0, 0))
Turtle(pos::Point, pendown::Bool) = Turtle(pos.x, pos.y, pendown, 0, (0, 0, 0))
Turtle(pos::Point, pendown::Bool, orientation::Real) = Turtle(pos.x, pos.y, pendown, orientation, (0, 0, 0))
Turtle(pos::Point, pendown::Bool, orientation::Real, col::NTuple{3, Number}) = Turtle(pos.x, pos.y, pendown, orientation, col)
Turtle(pos::Point, pendown::Bool, orientation::Real, r, g, b) = Turtle(pos.x, pos.y, pendown, orientation, (r, g, b))

function Turtle(pos::Point, col::Colorant)
    r, g, b = getfield.(convert(RGB, col), 1:3)
    Turtle(pos.x, pos.y, true, 0, (r, g, b))
end 

function Turtle(col::Colorant)
    r, g, b = getfield.(convert(RGB, col), 1:3)
    Turtle(0.0, 0.0, true, 0, (r, g, b))
end 

Base.broadcastable(t::Turtle) = Ref(t)

# a stack to hold pushed/popped turtle positions and orientations
const _turtle_stack = Vector{Vector{Float64}}()

# users can define prolog and epilog functions to monitor turtle's progress
function _prolog(t::Turtle)
    if isdefined(Main, :turtleprolog)
        Main.turtleprolog(t)
    end 
end

function _epilog(t::Turtle)
    if isdefined(Main, :turtleepilog)
        Main.turtleepilog(t)
    end 
end

"""
    Forward(t::Turtle, d=1)

Move the turtle forward by `d` units. The stored position is updated.
"""
function Forward(t::Turtle, d=1)
    _prolog(t)
    oldx, oldy = t.xpos, t.ypos
    t.xpos += (d * cos(t.orientation))
    t.ypos += (d * sin(t.orientation))
    if t.pendown
        gsave()
        sethue(t.pencolor...)
        line(Point(oldx, oldy), Point(t.xpos, t.ypos), :stroke)
        grestore()
    end
    _epilog(t)
end

"""
    Turn(t::Turtle, r=5.0)

Increase the turtle's rotation by `r` degrees. See also `Orientation`.
"""
function Turn(t::Turtle, r=5.0)
    _prolog(t)
    t.orientation = mod2pi(t.orientation + deg2rad(r))
    _epilog(t)
end

"""
    Orientation(t::Turtle, r=0.0)

Set the turtle's orientation to `r` degrees. See also `Turn` and `Towards`.
"""
function Orientation(t::Turtle, r=0.0)
    _prolog(t)
    t.orientation = mod2pi(deg2rad(r))
    _epilog(t)
end

"""
    Towards(t::Turtle, pos::Point)

Rotate the turtle to face towards a given point.
"""
function Towards(t::Turtle, pos::Point)
    _prolog(t)
    x, y = pos

    dx = x - t.xpos
    dy = y - t.ypos

    t.orientation = atan(dy, dx)
    _epilog(t)
end

"""
    Pendown(t::Turtle)

Put that pen down and start drawing.
"""
function Pendown(t::Turtle)
    _prolog(t)
    t.pendown = true
    _epilog(t)
end

"""
    Penup(t::Turtle)

Pick that pen up and stop drawing.
"""
function Penup(t::Turtle)
    _prolog(t)
    t.pendown = false
    _epilog(t)
end

"""
    Circle(t::Turtle, radius=1.0)

Draw a filled circle centered at the current position with the given radius.
"""
function Circle(t::Turtle, radius=1.0)
    _prolog(t)
    gsave()
    sethue(t.pencolor...)
    if t.pendown
        circle(t.xpos, t.ypos, radius, :fill)
    end 
    grestore()
    _epilog(t)
end

"""
    Rectangle(t::Turtle, width=10.0, height=10.0)

Draw a filled rectangle centered at the current position with the given radius.
"""
function Rectangle(t::Turtle, width=10.0, height=10.0)
    _prolog(t)
    gsave()
    sethue(t.pencolor...)
    if t.pendown
        rect(t.xpos-width/2, t.ypos-height/2, width, height, :fill)
    end 
    grestore()
    _epilog(t)
end

"""
    Push(t::Turtle)

Save the turtle's position and orientation on the stack. 

Use `Pop()` to restore this position and orientation from the top value on the
stack, discarding the current position and orientation.

Turtles can be sociable creatures; there's just one stack, and it's shared by
all turtles, So it's possible for one turtle to pop the stack values that were
`pushed` by another turtle.
"""
function Push(t::Turtle)
    _prolog(t)
    # save xpos, ypos, turn in a queue
    global _turtle_stack
    push!(_turtle_stack, [t.xpos, t.ypos, t.orientation])
    _epilog(t)
end

"""
    Pop(t::Turtle)

Get the position and orientation off the stack, as previously saved with
`Push()`, and set the turtle to those values, discarding the current position
and orientation.

Turtles can be sociable creatures; there's just one stack, and it's shared by
all turtles, So it's possible for one turtle to pop the stack values that were
`pushed` by another turtle. 
"""
function Pop(t::Turtle)
    _prolog(t)
    # restore xpos, ypos, turn from queue
    global _turtle_stack
    if isempty(_turtle_stack)
        @info("turtle stack was already empty")
        t.xpos, t.ypos, t.orientation = 0.0, 0.0, 0.0
    else
        t.xpos, t.ypos, t.orientation = pop!(_turtle_stack)
    end
    _epilog(t)
end

"""
    Message(t::Turtle, txt)

Write some text at the current position.
"""
function Message(t::Turtle, txt)
    _prolog(t)
    gsave()
    sethue(t.pencolor...)
    if t.pendown
        text(txt, t.xpos, t.ypos)
    end 
    grestore()
    _epilog(t)
end

"""
    HueShift(t::Turtle, inc=1.0)

Shift the Hue of the turtle's pen by `inc`. Hue values range between 0 and 360.

If the turtle's `Pencolor` was "black" to start with, the saturation and
brightness will be 0, so changing just the hue won't make a color that's easily
distinguishable from black. The brightness and saturation of the new color will still be
0.
"""
function HueShift(t::Turtle, inc=1.0)
    _prolog(t)
    r, g, b = t.pencolor
    hsv = convert(Colors.HSV, Colors.RGB(r, g, b))
    newhsv = (mod(hsv.h + inc, 360), hsv.s, hsv.v)
    newrgb = convert(Colors.RGB, Colors.HSV(newhsv[1], newhsv[2], newhsv[3]))
    sethue(newrgb)
    t.pencolor = (newrgb.r, newrgb.g, newrgb.b)
    _epilog(t)
end

"""
    Randomize_saturation(t::Turtle)

Randomize the saturation of the turtle's pen color.
"""
function Randomize_saturation(t::Turtle)
    _prolog(t)
    r, g, b = t.pencolor
    hsv = convert(Colors.HSV, Colors.RGB(r, g, b))
    newhsv = (hsv.h, rand(0.5:0.05:1.0), hsv.v)
    newrgb= convert(Colors.RGB, Colors.HSV(newhsv[1], newhsv[2], newhsv[3]))
    sethue(newrgb)
    t.pencolor = (newrgb.r, newrgb.g, newrgb.b)
    _epilog(t)
end

"""
    Pencolor(t::Turtle, r, g, b)

Set the Red, Green, and Blue colors of the turtle.
"""
function Pencolor(t::Turtle, r, g, b)
    _prolog(t)
    sethue(r, g, b)
    t.pencolor = (r, g, b)
    _epilog(t)
end

function Pencolor(t::Turtle, col::Colors.Colorant)
    _prolog(t)
    temp = convert(RGBA, col)
    Pencolor(t::Turtle, temp.r, temp.g, temp.b)
    _epilog(t)
end

function Pencolor(t::Turtle, col::AbstractString)
    _prolog(t)
    temp = parse(RGBA, col)
    Pencolor(t::Turtle, temp.r, temp.g, temp.b)
    _epilog(t)
end

Pencolor(t::Turtle, col::NTuple{3, Number}) = Pencolor(t, col...)

"""
    Reposition(t::Turtle, pos::Point)
    Reposition(t::Turtle, x, y)

Reposition: pick the turtle up and place it at another position.
"""
function Reposition(t::Turtle, x, y)
    _prolog(t)
    t.xpos = x
    t.ypos = y
    _epilog(t)
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
