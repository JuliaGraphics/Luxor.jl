using Luxor
using Test
using Random
Random.seed!(42)

function f(pos, str)
    @layer begin
        setline(0.4)
        for i in 10:5:100
            circle(pos, i, :stroke)
        end
    end
end

function textformat_tests(fname)
    Drawing(800, 800, fname)
    origin()
    background("black")
    sethue("white")
    fontsize(40)
    tiles = Tiler(800, 800, 4, 4)
    for (pos, n) in tiles
        @layer begin
            translate(pos)
            n == 1 &&
                textformat("tile 1")
            n == 2 &&
                textformat(
                    (text = "tile 2",
                    color = "green"))
            n == 3 &&
                textformat("tile 3")
            n == 4 &&
                textformat(
                    (text = "tile 4",))
            n == 5 &&
                textformat(
                    (text = "tile 5",
                    color = "red",
                    prolog = f,
                ),)
            n == 6 &&
                textformat(
                    (text = "tile 6",
                    color = "purple",
                    fontsize = 30,
                ),)
            n == 7 &&
                textformat(
                    (text = "tile 7",
                    color = "blue",
                    fontsize = 20,
                    advance = 40,
                ),)
            n == 8 &&
                textformat(
                    (
                    baseline = 50,
                    prolog = f,
                    text = "tile 8",
                    color = "cyan",
                ),)
            n == 9 &&
                textformat(
                    (text = "one",
                        color = "magenta",
                        baseline = 10,
                    ),
                    "two",
                    "three, four,",
                    (text = "five,",
                        color = "magenta",
                    ),
                    fontsize = 30,
                    width = 140,
                )
            n == 10 &&
                textformat(
                    (text = "tile 10",
                    color = "orange",
                ),)
            n == 11 &&
                textformat(
                    (text = "tile 11",
                    color = "yellow",
                ),)
            n == 12 &&
                textformat(
                    (prolog = f,
                    text = "tile 12",
                    fontsize = 24,
                    color = "orange",
                ),)
            n == 13 &&
                textformat(
                    (text = "tile 13",
                    color = "grey70",
                ),)
            n == 14 &&
                textformat(
                    (text = "tile 14",
                    color = "hotpink",
                ),)
            n == 15 &&
                begin
                    pt = textformat(
                        (text = "15",
                        color = "magenta",
                        fontsize = 30,
                        advance = 0,
                    ))

                    pt = textformat("15",
                        position = pt,
                        color = "magenta",
                        fontsize = 30,
                        advance = 0,
                    )
                    textformat("15",
                        position = pt,
                        color = "magenta",
                        fontsize = 30,
                        advance = 0,
                    )
                end
            n == 16 &&
                begin
                    pt = textformat(
                        (text = "tile16",
                        color = "cyan",
                        fontsize = 30,
                        advance = 600), width=400)
                    textformat(
                        (text = "tile 16",
                        color = "cyan",
                        fontsize = 20),
                        position = pt)
                    
                end
        end
    end
    @test finish() == true
    println("...finished test: output in $(fname)")
end

textformat_tests("text-format-tests.png")
