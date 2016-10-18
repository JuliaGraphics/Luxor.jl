#!/usr/bin/env julia

using Luxor, Base.Test

function get_png_files(folder)
    tempfolder = pwd()
    cd(folder)
    imagelist = filter(f -> !startswith(f, ".") && endswith(f, "png"), readdir(folder))
    imagepathlist = map(realpath, imagelist)
    cd(tempfolder)
    return imagepathlist
end

function addimagetile(imgfile, xcenter, ycenter, tilewidth, tileheight; cropping=true)
    gsave()
    box(xcenter, ycenter, tilewidth, tileheight, :clip)
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

imagelist = get_png_files(dirname(@__FILE__) * "/../docs/figures")

shuffle!(imagelist)

width, height = 1600, 1000
fname = "tiled-images.png"
Drawing(width, height, fname)
origin()
background("grey50")
setopacity(0.5)
pagetiles = Tiler(width, height, 8, 8, margin=50)
for (pos, n) in pagetiles
  if n > length(imagelist) # run out of images
    break
  end
  addimagetile(imagelist[n], pos.x, pos.y, pagetiles.tilewidth, pagetiles.tileheight, cropping=true)
end
@test finish() == true
println("...finished test: output in $(fname)")
