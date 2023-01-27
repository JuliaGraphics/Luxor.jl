#!/usr/bin/env julia

using Luxor

using Test
# some of these tests produce errors on Linux versions of Cairo
# but no errors on MacOS X Cairo.

using Random
Random.seed!(42)

function pointmatrix(fname)
    # transform points using 3 by 3 matrix

    identitym = [1 0 0; 0 1 0; 0 0 1]
    tm = [1 0 50; 0 1 250; 0 0 1] # translate 50 in x, 250 in y
    sm = [2 0 0; 0 0.5 0; 0 0 1] # scale 2 in x 0.5 in y
    θ = π / 4
    rm = [cos(θ) sin(θ) 0; -sin(θ) cos(θ) 0; 0 0 1] # rotate clockwise by θ
    shx = [1 3 0; 0 1 0; 0 0 1] # shear by 3 in x
    shy = [1 0 0; 2 1 0; 0 0 1] # shear by 2 in y
    ro = [-1 0 0; 0 -1 0; 0 0 1] # reflect about origin
    rx = [1 0 0; 0 -1 0; 0 0 1] # reflect in x
    ry = [-1 0 0; 0 1 0; 0 0 1] # reflect in y

    Drawing(1000, 1000, fname)
    origin()
    fontsize(200)
    setopacity(0.6)
    tiles = Tiler(1000, 1000, 3, 3)

    mnames = ["identitym", "tm", "sm", "rm", "shx", "shy", "ro", "rx", "ry"]

    textoutlines("t")
    pts = pathtopoly()[1]
    for (n, mat) in enumerate([identitym, tm, sm, rm, shx, shy, ro, rx, ry])
        @layer begin
            translate(first(tiles[n]))
            pts1 = map(pt -> mat * pt, pts)
            sethue(Luxor.HSB(35n, 0.8, 0.8))
            poly(pts1, :fill, close = true)
            sethue("white")
            fontsize(20)
            text(mnames[n], halign = :center)
        end
    end

    sethue("white")
    # compose matrix multiplications ? 
    poly(map(pt -> sm * tm * ro * shy * pt, pts), :fill)
    poly(map(pt -> sm * inv(tm) * ro * inv(shy) * pt, pts), :fill)

    @test finish() == true
    println("...finished test: output in $(fname)")
end



function matrix_tests(fname)
    # matrix tests

    # translate(dx, dy) =   transform([1,  0, 0,  1, dx, dy])                shift by
    # scale(fx, fy)     =   transform([fx, 0, 0, fy,  0, 0])                 scale by
    # rotate(A)         =   transform([c, s, -c, c,   0, 0])                 rotate to A radians
    # x-skew(a)         =   transform([1,  0, tan(a), 1,   0, 0])            xskew by A
    # y-skew(a)         =   transform([1, tan(a), 0, 1, 0, 0])               yskew by A
    # flip HV           =   transform([fx, 0, 0, fy, cx(*1-fx), cy* (fy-1)]) flip

    Drawing(1000, 1000, fname)

    # get rotation
    @test isapprox(getrotation(cairotojuliamatrix(getmatrix())), 0.0)
    rotate(pi / 2)
    @test isapprox(getrotation(), pi / 2)
    @test isapprox(getrotation(cairotojuliamatrix(getmatrix())), pi / 2)
    origin()
    @test isapprox(getrotation(cairotojuliamatrix(getmatrix())), 0.0)

    # get translation
    tx, ty = gettranslation(cairotojuliamatrix(getmatrix()))
    @test tx == 500.0
    @test ty == 500.0
    translate(5, 10)
    tx, ty = gettranslation()
    @test tx == 505.0
    @test ty == 510.0
    origin()
    tx, ty = gettranslation(cairotojuliamatrix(getmatrix()))
    @test tx == 500.0
    @test ty == 500.0

    # get scale
    sx, sy = getscale(cairotojuliamatrix(getmatrix()))
    @test sx == 1.0
    @test sy == 1.0
    scale(5, 10)
    sx, sy = getscale()
    @test sx == 5.0
    @test sy == 10.0
    origin()
    sx, sy = getscale(cairotojuliamatrix(getmatrix()))
    @test sx == 1.0
    @test sy == 1.0

    original_matrix = getmatrix()

    # absolute position 200, 250 relative to top left origin (0, 0)
    setmatrix([1, 0, 0, 1, 200, 250.0])
    sethue("red")
    fontsize(20)
    text("hello world")

    sethue("green")
    # absolute position 400, 500 from top left origin (0, 0)
    setmatrix([1, 0, 0, 1, 400, 500.0])
    text("hello world")

    sethue("white")
    # absolute position 230 230
    setmatrix([1, 0, 0, 1, 230, 230.0])
    text("hello world")

    # shift relative by 10 x (right) and 20 y (down) after moving to absolute 300 300
    setmatrix([1, 0, 0, 1, 300, 300])
    transform([1, 0, 0, 1, 10, 20])
    sethue("yellow")
    text("hello world")

    setmatrix([1, 0, 0, 1, 300, 300])
    transform([1, 0, 0, 1, 0, 0])
    sethue("gray")
    text("hello world")

    # scale by 2 x (right) and 3 y after moving to 300 300
    setmatrix([1, 0, 0, 1, 300, 300.0])
    transform([2, 0, 0, 3, 0, 0.0])
    sethue("purple")
    text("hello world")

    # using rotate by angle, not using matrix
    # absolute move to 100, 100
    setmatrix([1, 0, 0, 1, 100.0, 100])
    fontsize(20)
    sethue("brown")
    for i in 1:4
        # rotate by pi/2 radians
        rotate(pi / 2)
        text("hello world")
    end

    # rotate by angle, around current position
    # absolute move to 500 across 500 down
    setmatrix([1, 0, 0, 1, 300.0, 600])
    fontsize(20)
    sethue("cyan")
    n = 10
    angle = 2pi / n
    for i in 1:n
        # rotate another 'angle' radians
        transform([cos(angle), sin(angle), -sin(angle), cos(angle), 0, 0])
        text("$i hello world")
    end

    fontsize(20)
    # skew X
    setopacity(0.5)
    sethue("purple")
    # move to 800 across 300 down
    setmatrix([1, 0, 0, 1, 800, 300])
    # Cairo doesn't like tan(90) skews (or the matrix that results)
    for i in 0:5:40
        transform([1, 0, tand(i), 1, 0, 20])    # xskew by i° and move down by 20 for each one
        text("hello world")
    end

    # skew y
    setopacity(0.75)
    sethue("orange")
    setmatrix([1, 0, 0, 1, 800, 500])
    # Cairo doesn't like tan(90) skews
    for i in 0:5:40
        transform([1, tand(i), 0, 1, 0, 20])    # yskew by i° and move down by 20 for each one
        text("hello world")
    end

    # flip hv
    # Flip H/V with center shifted by cx:cy

    sethue("magenta")
    setmatrix([1, 0, 0, 1, 800, 200.0])
    fx = 1
    fy = -1
    cx = cy = 50
    transform([fx, 0, 0, fy, cx * (1 - fx), cy * (fy - 1)])
    text("hello world")

    setmatrix(original_matrix)
    text("0/0", O + 15)

    @test finish() == true
    println("...finished test: output in $(fname)")
end

matrix_tests("matrix-tests.pdf")

pointmatrix("matrix-point-tests.png")
