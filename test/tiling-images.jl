#!/usr/bin/env julia

using Luxor

"""
return center positions as a range and also the calculated width/height for a tile
"""
function tiling(width, height, nrows, ncols)
    w1 = width/ncols
    h1 = height/nrows
    return (
    (-(width/2) + (w1 / 2) : w1 : (width/2) - (w1 / 2), -(height/2) + (h1 / 2): h1 : (height/2) - (h1 / 2)),
    (w1, h1)
    )
end

function get_png_files(folder)
    cd(folder)
    imagelist = filter(f -> !startswith(f, ".") && endswith(f, "png"), readdir(folder))
    imagelist = filter(f -> !startswith(f, "tiled-images"), imagelist) # don't recurse... :)
    return map(realpath, imagelist)
end

function addimagetile(imgfile, xcenter, ycenter, tilewidth, tileheight; cropping=true)
    gsave()
    rect(xcenter-tilewidth/2, ycenter-tileheight/2, tilewidth, tileheight, :clip)
    img = readpng(imgfile)
    w = img.width
    h = img.height
    if cropping == true
        # expand image to fill tile
        if w < h
            scalefactor = max(tilewidth, tileheight)/w
        else
            scalefactor = max(tilewidth, tileheight)/h
        end
    else
        # shrink image to fit inside tile
        if w > h
            scalefactor = min(tilewidth, tileheight)/w
        else
            scalefactor = min(tilewidth, tileheight)/h
        end
    end
    translate(xcenter, ycenter)
    scale(scalefactor, scalefactor)
    placeimage(img, -w/2, -h/2)
    clipreset()
    grestore()
end

imagelist = get_png_files(Pkg.dir("Luxor") * "/examples")
shuffle!(imagelist)

width, height = 1600, 1000
Drawing(width, height, "/tmp/tiled-images.png")
origin()
background("grey50")

centers, (tilewidth, tileheight) = tiling(width, height, 5, 5)
counter = 1

for y in centers[2], x in centers[1] # across first, then down
    addimagetile(imagelist[counter], x, y, tilewidth, tileheight, cropping=true)
    counter += 1
    if counter > length(imagelist) # run out of images
        break
    end
end

finish()
preview()
