#!/usr/bin/env julia

using Luxor

using Test

using Random
Random.seed!(42)

function subroutine(🐢::Turtle)
    for i in 1:10
        Forward(🐢, 40)
        Turn(🐢, 51)
        Circle(🐢, 1)
    end
end

function test_turtles(fname)
    Drawing(1200, 1200, fname)
    origin()
    background("black")

    # let's have two turtles
    raphael = Turtle(0, 0, true, 0, (1.0, 0.25, 0.25))
    michaelangelo = Turtle(0, 0, true, 0, (1.0, 0.25, 0.25))

    Pencolor(raphael, 1.0, 0.4, 0.2);       Pencolor(michaelangelo, 0.2, 0.9, 1.0)
    Penwidth(raphael, 0.75);                Penwidth(michaelangelo, 1.5)
    Reposition(raphael, -400, -300);        Reposition(michaelangelo, 0, 200)

    Orientation(raphael, pi);               Orientation(michaelangelo, -pi)

    for 🐢 in [raphael, michaelangelo]
        setlinecap("round")
        setopacity(0.5)
        Penwidth(🐢, .5)
        n = 400
        Penup(🐢)
        Pendown(🐢)
        for i in 1:200
            Forward(🐢, n)
            Turn(🐢, 29)
            🐢 == raphael && HueShift(🐢, 1)
            n += 1.25
            subroutine(🐢)
        end
        Reposition(🐢, O)
        Rectangle(🐢, 10, 10)
    end
    
    for i in 150:250
        Reposition(raphael, Point(300, -2i))
        Towards(raphael, Point(400, -400))
        Forward(raphael, 200)
        HueShift(raphael, 5)
    end

    fontsize(30)
    Reposition(raphael, Point(400, -100));   Reposition(michaelangelo, 400, -50)
    Message(raphael, "Raphael");      Message(michaelangelo, "Michaelangelo")

    Push(raphael)
    Pop(raphael)

    Pencolor(raphael, "white")
    Randomize_saturation(michaelangelo)

    # test warnings
    @info("stack was already empty warning expected...")
    Pop(michaelangelo) # should get "stack empty" warning!
    @test finish() == true
end

fname = "turtles-all-the-way-down.png"
test_turtles(fname)
println("...finished test: output in $(fname)")
