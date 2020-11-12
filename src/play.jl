using MiniFB

function onclick(window, button, mod, isPressed)::Cvoid
    if Bool(isPressed)
        println("mouse clicked")
    end
    mousex = mfb_get_mouse_x(window)
    mousey = mfb_get_mouse_y(window)
    println("x: $mousex y: $mousey")
end

function active_fn(win::Ptr{Cvoid}, is_active::Bool)
    println("Window is now ",  is_active ? "" : "in", "active")
end

macro play(w, h, body)
    quote
        window = mfb_open_ex("Luxor -> Julia", $w, $h, MiniFB.WF_RESIZABLE)

        mfb_set_active_callback(window, active_fn)
        mfb_set_mouse_button_callback(window, onclick)

        buffer = zeros(UInt32, $w, $h)
        while true
            Drawing($w, $h, :image)
            origin()
            $(esc(body))
            m = permutedims(image_as_matrix!(buffer), (2, 1))
            finish()
            state = mfb_update(window, m)
            if state != MiniFB.STATE_OK
                break
            end
        end
        mfb_close(window)
    end
end

#= Examples:

1 clock

using Luxor, Colors, Dates, ColorSchemes

include(dirname(pathof(Luxor)) * "/play.jl")

function clock(cscheme=ColorSchemes.leonardo)
    @play 400 600 begin
        fontface("JuliaMono-Regular")

        sethue(get(cscheme, .0))
        paint()
        fontsize(30)

        sethue(get(cscheme, .2))
        h = Dates.hour(now())
        sector(O, 180, 200, 3π/2, 3π/2 + rescale(h, 0, 24, 0, 2pi), :fill)

        sethue(get(cscheme, .4))
        m = Dates.minute(now())
        sector(O, 160, 180, 3π/2, 3π/2 + rescale(m, 0, 60, 0, 2pi), :fill)

        sethue(get(cscheme, .6))
        s = Dates.second(now())
        sector(O, 140, 160, 3π/2, 3π/2 + rescale(s, 0, 60, 0, 2pi), :fill)

        sethue(get(cscheme, .8))
        ms = Dates.value(Dates.Millisecond(Dates.now()))
        sector(O, 137, 140, 3π/2, 3π/2 + rescale(ms, 0, 1000, 0, 2pi), :fill)

        sethue(get(cscheme, 1.0))
        text(Dates.format(Dates.now(), "HH:MM:SS"), halign=:center)
    end
end

clock(ColorSchemes.botticelli)

=#


#=

2: bezier path thingy

using Luxor, Colors, Dates

function bez()
    j = rand(1:15)
    n = 1
    pgon = [Point(-100, -100), Point(100, 100), Point(100, -50), Point(-50, 100)]
    @play 500 500 begin
        t1 = time_ns()
        background(0, 0, 0)
        sethue(HSB(285, .7, .9))
        k = 3
        #        for i in 1:5
        for s in 1:30
            setopacity(rescale(s, 1, 30, 0.1, 1.0))
            pgon[1] += (k * rand(-1:1), k * rand(-1:1))
            pgon[2] += (k * rand(-1:1), k * rand(-1:1))
            pgon[3] += (k * rand(-1:1), k * rand(-1:1))
            pgon[4] += (k * rand(-1:1), k * rand(-1:1))
            bp = makebezierpath(pgon)
            drawbezierpath(bp, :stroke)
        end
        #        end
        if !isinside(polycentroid(pgon), box(BoundingBox() * 0.8), allowonedge=true)
            pgon = [Point(-100, -100), Point(100, 100), Point(100, -50), Point(-50, 100)]
        end

        n = mod1(n + 1, 200)


        sethue("white")
        fontface("JuliaMono-Black")
        fontsize(20)
        text(Dates.format(now(), "HH:MM:SS"), halign=:center)

        # time calc
        sethue("white")
        t2 = time_ns()
        text(string("fps: ", round(1E9/(t2-t1), digits=2)), boxtopleft(BoundingBox() * 0.9))
        t1 = t2
        sleep(0.1)
    end
end

bez()

=#

#=

3 some balls

using Luxor, Colors, Dates

mutable struct Ball
    position::Point
    velocity::Point
    radius::Float64
    hue::Float64
end

function f()
    balls = [Ball(rand(BoundingBox(Point(-300, -300), Point(300, 300))), rand(BoundingBox(Point(-300, -300), Point(300, 300))), rand(1:10), rand(0:360)) for i in 1:450]
    @play 600 600 begin
        w = 500
        h = 500
        background("black")

        for ball in balls
            sethue(HSB(ball.hue, .8, 0.8))
            circle(ball.position, ball.radius, :fill)

            if !(-w/2 < ball.position.x < w/2)
                ball.velocity = -ball.velocity
                ball.position = Point(-w/2, ball.position.y)
            end
            if !(-h/2 < ball.position.y < h/2)
                ball.velocity = -ball.velocity
                ball.position = Point(ball.position.x, -h/2)
            end
            ball.velocity = Point(rand(-4:4, 2) ...)

            ball.position = ball.position + ball.velocity
        end
        sleep(0.01)
    end
end

f()
=#
