#!/usr/bin/env julia

using Luxor

# some of these tests produce errors on Linux versions of Cairo
# but no errors on MacOS X Cairo.

function matrix_tests()
    # matrix tests

    # translate(dx,dy) =	transform([1,  0, 0,  1, dx, dy])                shift by
    # scale(fx, fy)    =    transform([fx, 0, 0, fy,  0, 0])                 scale by
    # rotate(A)        =    transform([c, s, -c, c,   0, 0])                 rotate to A radians
    # x-skew(a)        =    transform([1,  0, tan(a), 1,   0, 0])            xskew by A
    # y-skew(a)        =    transform([1, tan(a), 0, 1, 0, 0])               yskew by A
    # flip HV          =    transform([fx, 0, 0, fy, cx(*1-fx), cy* (fy-1)]) flip

    Drawing(1000,1000, "/tmp/matrix-tests.pdf")

    # absolute position 200,250 relative to top left origin (0, 0)
    setmatrix([1, 0, 0, 1, 200, 250.0])
    sethue("red")
    fontsize(20)
    text("hello world")

    sethue("green")
    # absolute position 400,500 from top left origin (0, 0)
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
        rotate(pi/2)
        text("hello world")
    end

    # rotate by angle, around current position
    # absolute move to 500 across 500 down
    setmatrix([1, 0, 0, 1, 300.0, 600])
    fontsize(20)
    sethue("cyan")
    n = 10
    angle = 2pi/n
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
    transform([fx, 0, 0, fy, cx * (1-fx), cy * (fy-1)])
    text("hello world")

    finish()
    preview()
end

matrix_tests()


