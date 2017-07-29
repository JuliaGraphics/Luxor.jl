#!/usr/bin/env julia

using Luxor

using Base.Test



function test_turtles(fname)
    Drawing(1200, 1200, fname)
    origin()
    background("black")

    # let's have two turtles
    raphael = Turtle(0, 0, true, 0, (1.0, 0.25, 0.25))
    michaelangelo = Turtle(0, 0, true, 0, (1.0, 0.25, 0.25))

    setopacity(0.95)
    setline(6)

    Pencolor(raphael, 1.0, 0.4, 0.2);       Pencolor(michaelangelo, 0.2, 0.9, 1.0)
    Penwidth(raphael, 0.75);                 Penwidth(michaelangelo, 1.5)

    Reposition(raphael, 500, -200);         Reposition(michaelangelo, 500, 200)
    Message(raphael, "Raphael");            Message(michaelangelo, "Michaelangelo")
    Reposition(raphael, 0, 0);              Reposition(michaelangelo, 0, 0)
    Orientation(raphael, pi);                Orientation(michaelangelo, -pi)

    pace = 5
    for i in 1:2:400
        for turtle in [raphael, michaelangelo]
            Circle(turtle, 3)
            Push(turtle)
            Pop(turtle)
            Penup(turtle)
            Forward(turtle, 1)
            Turn(turtle, 180)
            Pen_opacity_random(turtle)
            Forward(turtle, 1)
            Turn(turtle, 180)
            Pendown(turtle)
            HueShift(turtle, rand())
            Forward(turtle, pace)
            Randomize_saturation(turtle)
            Push(turtle)
            Rectangle(turtle, 6, 2)
            Pop(turtle)
            turtle == raphael       && Turn(turtle, 30.0)
            turtle == michaelangelo && Turn(turtle, -30.0)
            Message(turtle, string(i))
            pace += 1//2
        end
    end

    Reposition(raphael, 500, -180);         Reposition(michaelangelo, 500, 180)
    Message(raphael, "Raphael");            Message(michaelangelo, "Michaelangelo")

    Push(raphael)
    Pop(raphael)

    # test warnings
    Pop(michaelangelo) # warning!
    @test finish() == true
end

fname = "turtles-all-the-way-down.png"
test_turtles(fname)
println("...finished test: output in $(fname)")
