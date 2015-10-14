#!/Applications/Julia-0.4.0.app/Contents/Resources/julia/bin/julia

using Luxor, Colors

Drawing(1200, 1200, "/tmp/turtles.png")
origin()
background("black")

# let's have two turtles
raphael = Turtle(0, 0, true, 0, (1.0, 0.25, 0.25))
michaelangelo = Turtle(0, 0, true, 0, (1.0, 0.25, 0.25))

setopacity(0.95)
setline(6)

Pencolor(raphael, 1.0, 0.4, 0.2);       Pencolor(michaelangelo, 0.2, 0.9, 1.0)
Reposition(raphael, 500, -200);         Reposition(michaelangelo, 500, 200)
Message(raphael, "Raphael");            Message(michaelangelo, "Michaelangelo")
Reposition(raphael, 0, -200);           Reposition(michaelangelo, 0, 200)

pace = 10
for i in 1:5:400
    for turtle in [raphael, michaelangelo]
        Circle(turtle, 3)
        HueShift(turtle, rand())
        Forward(turtle, pace)
        Turn(turtle, 30 - rand())
        Message(turtle, string(i))
        pace += 1
    end
end

finish()
preview()
