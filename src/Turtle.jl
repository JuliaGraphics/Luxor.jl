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
simple turtle graphics needed for Lindenmayer systems

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
    the turtle moves forward by `d` units. The stored position is updated.

    Forward(t::Turtle, d)

"""

function Forward(t::Turtle, d)
    move(t.xpos, t.ypos)
    t.xpos = t.xpos + (d * cos(t.orientation))
    t.ypos = t.ypos + (d * sin(t.orientation))
    if t.pendown
        save()
        line(t.xpos, t.ypos)
        sethue(t.pencolor...)
        stroke()
        restore()
    else
        move(t.xpos, t.ypos)
    end
end

"""
    increase rotation by r radians

    Turn(t::Turtle, r)
"""

function Turn(t::Turtle, r)
    t.orientation = mod2pi(t.orientation + deg2rad(r))
end

function Orientation(t::Turtle, r)
    t.orientation = mod2pi(deg2rad(r))
end

function Pendown(t::Turtle)
    t.pendown = true
end

function Penup(t::Turtle)
    t.pendown = false
end

function Circle(t::Turtle, radius)
    save()
    sethue(t.pencolor...)
    circle(t.xpos, t.ypos, radius, :fill)
    restore()
end

function Rectangle(t::Turtle, width, height)
    save()
    sethue(t.pencolor...)
    rect(t.xpos-width/2, t.ypos-height/2, width, height, :fill)
    restore()
end

function Push(t::Turtle)
# save xpos, ypos, turn in a queue
    global queue
    push!(queue, [t.xpos, t.ypos, t.orientation])
end

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

function Message(t::Turtle, txt)
    save()
    sethue(t.pencolor...)
    text(txt, t.xpos, t.ypos)
    restore()
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

function Pencolor(t::Turtle, r, g, b)
    sethue(r, g, b)
    t.pencolor = (r, g, b)
end

function Reposition(t::Turtle, x, y)
    t.xpos = x
    t.ypos = y
end

Penwidth(t::Turtle, w) = setline(w)

Pen_opacity_random(t::Turtle) = setopacity(rand())
