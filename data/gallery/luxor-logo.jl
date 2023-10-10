# luxor logo
# contibuted by cormullion

using Luxor, Colors

function set_gold_blend()
    gblend = blend(O, 0, O, 220, "gold", "gold3")
    setblend(gblend)
end

function draw_scarab_legs(pos)
    translate(pos)
    # legs
    @layer begin
        for i in 1:2
            move(O)
            rline.((polar(80, -π / 6),
                polar(70, -π / 2),
                polar(12, -5π / 6),
                polar(60, -π / 4)))

            #middle leg
            move(0, 40)
            rline.((
                polar(120, -π / 6),
                polar(40, π / 2)))

            #back leg
            move(0, 100)
            rline.((
                polar(130, -π / 6),
                polar(110, π / 2)))

            # flip for other leg
            transform([-1 0 0 1 0 0])
        end
    end
end

function draw_scarab_body()
    @layer begin
        squircle(Point(0, -25), 26, 75, action = :path)
        squircle(Point(0, 0), 50, 70, action = :path)
        squircle(Point(0, 40), 65, 90, action = :path)
    end
end

function draw(fname)
    Drawing(380, 520, fname)
    origin()
    setline(20)
    setlinecap("butt")
    setlinejoin("round")

    width = currentdrawing().width/2 - 15
    height = currentdrawing().height/2 - 15

    sethue("black")
    squircle(O, width, height - 10, rt = 0.4, action = :fill)
    set_gold_blend()
    squircle(O, width, height - 10, rt = 0.4, action = :path)

    translate(0, 50)
    draw_scarab_legs(O)
    strokepath()

    draw_scarab_body()
    fillpath()

    # julia dots === Ra egyptian sun deity
    @layer begin
        translate(0, -190)
        circle(O, 48, action = :fill)
        juliacircles(20)
    end

    finish()
    preview()
end

fname = dirname(dirname(pathof(Luxor))) * "/docs/src/assets/figures/luxor-logo.svg"

draw(fname)
