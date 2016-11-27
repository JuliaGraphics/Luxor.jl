#!/usr/bin/env julia

using Luxor

if VERSION >= v"0.5.0-dev+7720"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

function drawbbox(apoly)
    gsave()
    setline(0.3)
    setdash("dotted")
    box(polybbox(apoly), :stroke)
    grestore()
end

function test1(p, x, y)
    prettypoly(p, :fill,
        vertexnumberingfunction = (n, l) -> (text(string(n, " of ", l))),
        # all these commands are executed for each vertex of the polygon
        () ->
        begin
            scale(0.5, 0.5)
            randomhue()
            opacity = currentdrawing.alpha
            setopacity(rand(5:10)/10)
            ngon(0, 0, 15, rand(3:12), 0, :fill)
            setopacity(opacity)
            sethue("black")
        end,
    )
end

function test2(p)
    prettypoly(p,
        :fill,
        () ->
        begin
          ## all these commands are executed for each vertex of the polygon
            randomhue()
            scale(0.5, 0.5)
            rotate(pi/2)
            prettypoly(p, :fill,
                () ->
                begin
                # and all these commands are executed for each vertex of that polygon
                randomhue()
                scale(0.25, 0.25)
                rotate(pi/2)
                prettypoly(p, :fill)
                end
            )
        end
    )
end

function get_all_png_files(folder)
    tempfolder = pwd()
    cd(folder)
    imagelist = filter(f -> !startswith(f, ".") && endswith(f, "png"), readdir(folder))
    imagelist = filter(f -> !startswith(f, "tiled-images"), imagelist) # don't recurse... :)
    imagepathlist = map(realpath, imagelist)
    cd(tempfolder)
    return imagepathlist
end

function test3(p)
    imagelist = get_all_png_files(dirname(@__FILE__))
    shuffle!(imagelist)
    img = readpng(imagelist[1])
    w = img.width
    h = img.height
    prettypoly(p,
        :fill,
        () ->
        begin
            ## all these commands are executed for each vertex of the polygon
            placeimage(readpng(imagelist[rand(1:end)]), -w/2, -h/2)
        end
        )
end

function draw_lots_of_polys(pagewidth, pageheight)
    setopacity(0.75)
    pagetiles = Tiler(pagewidth, pageheight, 9, 9, margin=20)
    for (pos, n) in pagetiles
        if rand(Bool)
            p = randompointarray(rand(-140:-10), rand(-140:-10), rand(10:140), rand(10:140), rand(5:12))
        else
            p = ngon(0, 0, rand(50:100), rand(3:12), vertices=true)
        end
        gsave()
        translate(pos)
        setline(1)
        randomhue()
        if n % 3  == 0
            test1(p, pos.x, pos.y)
        elseif n % 3 == 1
            test2(p)
        elseif n % 3 == 2
            test3(p)
        end
        drawbbox(p)
        grestore()
    end
end

function test_pretty_poly(fname)
    width, height = 3000, 3000
    Drawing(width, height, fname)
    origin()
    background("ivory")
    draw_lots_of_polys(width, height)
    @test finish() == true
end

fname = "pretty-poly-test.pdf"
test_pretty_poly(fname)
println("...finished test: output in $(fname)")
