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
        Reposition

"""
With a Turtle you can command a turtle to move and draw: turtle graphics.

The functions that start with a capital letter are: Forward, Turn,
Circle, Orientation, Rectangle, Pendown, Penup, Pencolor, Penwidth, and Reposition.

There are also some other functions. To see how they might be used, see Lindenmayer.jl.
"""

type Turtle
    xpos::Float64
    ypos::Float64
    pendown::Bool
    orientation::Float64 # stored in radians
    pencolor::Tuple{Float64,Float64,Float64} # it's an RGB turtle
    function Turtle(xpos, ypos, pendown, orientation, pencolor)
        new(xpos, ypos, pendown, orientation, pencolor)
    end
end

# a stack to hold turtle positions
const queue = Array{Array{Float64,1},1}()

"""
Move the turtle forward by `d` units. The stored position is updated.

    Forward(t::Turtle, d)
"""
function Forward(t::Turtle, d)
    move(t.xpos, t.ypos)
    t.xpos = t.xpos + (d * cos(t.orientation))
    t.ypos = t.ypos + (d * sin(t.orientation))
    if t.pendown
        gsave()
        line(t.xpos, t.ypos)
        sethue(t.pencolor...)
        stroke()
        grestore()
    else
        move(t.xpos, t.ypos)
    end
end

"""
Increase the turtle's rotation by `r` radians. See also `Orientation`.

    Turn(t::Turtle, r)
"""
function Turn(t::Turtle, r)
    t.orientation = mod2pi(t.orientation + deg2rad(r))
end
"""
Set the turtle's orientation to `r` radians. See also `Turn`.

    Orientation(t::Turtle, r)
"""
function Orientation(t::Turtle, r)
    t.orientation = mod2pi(deg2rad(r))
end
"""
Put that pen down and start drawing.

    Pendown(t::Turtle)
"""
function Pendown(t::Turtle)
    t.pendown = true
end
"""
Pick that pen up and stop drawing.

    Penup(t::Turtle)
"""
function Penup(t::Turtle)
    t.pendown = false
end
"""
Draw a filled circle centred at the current position with the given radius.

    Circle(t::Turtle, radius)
"""
function Circle(t::Turtle, radius)
    gsave()
    sethue(t.pencolor...)
    circle(t.xpos, t.ypos, radius, :fill)
    grestore()
end
"""
Draw a filled rectangle centred at the current position with the given radius.

    Rectangle(t::Turtle, width, height)

"""
function Rectangle(t::Turtle, width, height)
    gsave()
    sethue(t.pencolor...)
    rect(t.xpos-width/2, t.ypos-height/2, width, height, :fill)
    grestore()
end

"""
Save the turtle's position and orientation on a stack.
"""
function Push(t::Turtle)
# save xpos, ypos, turn in a queue
    global queue
    push!(queue, [t.xpos, t.ypos, t.orientation])
end

"""
Lift the turtle's position and orientation off a stack.
"""
function Pop(t::Turtle)
# restore xpos, ypos, turn from queue
    global queue
    if isempty(queue)
        warn("turtle can't pop")
        t.xpos, t.ypos, t.orientation = 0.0, 0.0, 0.0
    else
        t.xpos, t.ypos, t.orientation = pop!(queue)
    end
end

"""
Write some text at the current position.

    Message(t::Turtle, txt)
"""
function Message(t::Turtle, txt)
    gsave()
    sethue(t.pencolor...)
    text(txt, t.xpos, t.ypos)
    grestore()
end

"""
Shift the Hue of the turtle's pen forward by inc

    HueShift(t::Turtle, inc = 1)
"""
function HueShift(t::Turtle, inc = 1)
    r, g, b = t.pencolor
    hsv = convert(Colors.HSV, Colors.RGB(r, g, b))
    newhsv = ((hsv.h + inc) % 360, hsv.s, hsv.v)
    newrgb= convert(Colors.RGB, Colors.HSV(newhsv[1], newhsv[2], newhsv[3]))
    sethue(newrgb)
    t.pencolor = (newrgb.r, newrgb.g, newrgb.b)
end

"""
Randomize saturation of the turtle's pen color

    Randomize_saturation(t::Turtle)
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
Set the Red, Green, and Blue colors of the turtle:

    Pencolor(t::Turtle, r, g, b)
"""
function Pencolor(t::Turtle, r, g, b)
    sethue(r, g, b)
    t.pencolor = (r, g, b)
end

"""
Reposition: pick the turtle up and place it at another position:

    Reposition(t::Turtle, x, y)
"""
function Reposition(t::Turtle, x, y)
    t.xpos = x
    t.ypos = y
end

"""
Set the width of the line drawn.

    Penwidth(t::Turtle, w)
"""
Penwidth(t::Turtle, w) = setline(w)

"""
Change the opacity of the pen to some value at random.

"""
Pen_opacity_random(t::Turtle) = setopacity(rand())
