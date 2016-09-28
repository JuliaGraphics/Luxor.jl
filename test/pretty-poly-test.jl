#!/usr/bin/env julia

using Luxor

function drawbbox(apoly)
    gsave()
    setline(0.3)
    setdash("dotted")
    box(polybbox(apoly), :stroke)
    grestore()
end

function test1(p, x, y)
    prettypoly(p, :fill,
              # all these commands are executed for each vertex of the polygon
              :(
              scale(0.5, 0.5);
              randomhue();
              opacity = currentdrawing.alpha;
              setopacity(rand(5:10)/10);
              ngon(0, 0, 15, rand(3:12), 0, :fill);
              setopacity(opacity);
              sethue("black");
              # we can pass the origin for the whole polygon into the expression like this
              # but the current vertex is 0/0
              textcentred(string($(x)) * "/" *  string($(y)))))
end

function test2(p)
    prettypoly(p, :fill,
                  :(
                  ## all these commands are executed for each vertex of the polygon
                  randomhue();
                  scale(0.5, 0.5);
                  rotate(pi/2);
                  prettypoly($(p), :fill,
                    :(
                    # and all these commands are executed for each vertex of that polygon
                    randomhue();
                    scale(0.25, 0.25);
                    rotate(pi/2);
                    prettypoly($($(p)), :fill)))))
end

function get_png_files(folder)
    cd(folder)
    imagelist = filter(f -> !startswith(f, ".") && endswith(f, "png"), readdir(folder))
    imagelist = filter(f -> !startswith(f, "tiled-images"), imagelist) # don't recurse... :)
    return map(realpath, imagelist)
end

function test3(p)
    imagelist = get_png_files(dirname(@__FILE__))
    shuffle!(imagelist)
    img = readpng(imagelist[1])
    w = img.width
    h = img.height
    prettypoly(p, :fill,
                  :(
                  ## all these commands are executed for each vertex of the polygon
                  # to make it "through" the expression to the base drawing functions, these have to be made literal using $
                  placeimage($readpng($imagelist[rand(1:end)]), -$w/2, -$h/2)
                  ))
end

function draw_lots_of_polys(pagewidth, pageheight)
    setopacity(0.75)
    pagetiles = Tiler(width, height, 9, 9, margin=20)
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
        @eval [test1($p, $pos.x, $pos.y), test2($p), test3($p)][rand(1:end)] # choose a test at random
        drawbbox(p)
        grestore()
    end
end

width, height = 3000, 3000
fname = "/tmp/pretty-poly-test.pdf"
Drawing(width, height, fname)
origin()
background("ivory")
draw_lots_of_polys(width, height)
finish()
println("finished test: output in $(fname)")
