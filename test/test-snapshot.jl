#!/usr/bin/env julia

using Luxor, Test, Random

function drawcircles(Δα)
    @layer begin
        setline(8)
        for r = 0:20:1500
            α = r / 100  + Δα
            circle(O + sqrt(r ) .* (cos(α), sin(α)), r, :stroke)
            settext("<span font = '16' foreground = 'darkblue' > $(string(r)) </span>",
                 O + (0, 8 - r ); markup = true)
        end
    end
end

fna(i, suf) = "test_snap_$i.$suf"

function testsnapshot(fname; cb = missing, scalefactor = missing, kwargs...)
    if ismissing(cb)
        sn = if ismissing(scalefactor)
            snapshot(;fname = fname, kwargs...)
        else
            snapshot(;fname = fname, scalefactor = scalefactor, kwargs...)
        end
        @test typeof(sn) == Drawing
    else
        if ismissing(scalefactor)
            sn = snapshot(;fname = fname, cb = cb, kwargs...)
            @test sn.width == boxwidth(cb) && sn.height == boxheight(cb)
        else
            sn = snapshot(;fname = fname, cb = cb, scalefactor = scalefactor, kwargs...)
            @test sn.width == round(boxwidth(cb) * scalefactor)
            @test sn.height == round(boxheight(cb) * scalefactor)
        end
    end
    println("...finished test: output in $fname")
    sn
end
function circles_then_snapshot(fno, suf; kwargs...)
    drawcircles(0.5 * fno)
    testsnapshot(fna(fno, suf); kwargs...)
end



function frame_then_snapshot(fno, suf, cb; kwargs...)
    @layer begin
        setline(2)
        sethue("red")
        box(cb, :stroke)
    end
    testsnapshot(fna(fno, suf); cb = cb, kwargs...)
end

function ripples_then_snapshot(fno, suf; kwargs...)
    ctm = cairotojuliamatrix(getmatrix())
    # User space coordinates for device top
    midtopx, midtopy, _ = ctm^-1 * [-ctm[1, 3] + currentdrawing().width / 2, -ctm[2, 3], 0.0]
    colos = Luxor.Colors.colormap("blues")
    for ulr in range(0, 1, length = 3 * 577)
        r = 2 * 577 * ulr^1.5
        # phase
        ϕ = 20 * sin(40ulr)
        sethue(colos[80 + Int(round(ϕ))])
        p = Point(midtopx, midtopy + 2ϕ)
        circle(p, r, :stroke)
        # Add some rays for showing shear transformation
        sethue("yellow")
        [circle(p + (r * cos(α), -r * sin(α)), 2, :stroke) for α in [0.25, 0.75, 1.25, 1.75]π]
    end
    testsnapshot(fna(fno, suf); kwargs...)
end

# 1-4: Full drawing snapshot from bounded recording surface
Drawing(640, 480, :rec)
origin(400, 280)
sethue("gold4")
circles_then_snapshot(1, "png")
sethue("gold3")
circles_then_snapshot(2, "pdf")
sethue("gold2")
circles_then_snapshot(3, "svg")
sethue("gold1")
circles_then_snapshot(4, "png", scalefactor = 0.5)

# 5-6: Crop snapshots from bounded recording surface
ptul = -Point(getmatrix()[5:6]...) # origin is not at center
ptbr = ptul + (currentdrawing().width, currentdrawing().height)
cb = BoundingBox(ptul, ptbr) - 50
frame_then_snapshot(5, "png", cb)

cb = BoundingBox(box(Point(10, -115), Point(42, -91), :stroke))
frame_then_snapshot(6, "png", cb)

# 7: Crop and scale up
frame_then_snapshot(7, "png", cb, scalefactor = 20)

# 8: Shrink full image
origin()
cb = BoundingBox()
frame_then_snapshot(8, "png", cb, scalefactor = 0.5)


# 9-10: Crop snapshot from free extents recording surface

# It seems that the svg device called by Cairo fails to find
# a size reference from unbounded recording surfaces. Botched up svgs
# include "-1.#QNAN", or very long strings. This occurs with and
# without 'Pro api' text on the drawing.
# However, it seems that if an svg has previously been rendered from a surface
# with bounds, the svg renderer works normally with unbounded surfaces.

Drawing(NaN, NaN, :rec)
@test snapshot() == false
origin(400, 280)
sethue("gold4")
cb = BoundingBox(Point(-128, -96), Point(128, 96))
circles_then_snapshot(9, :png; cb = cb)

# Large image, more effective storage as vector type svg
cb = BoundingBox(Point(-1280, -960), Point(1280, 960))
circles_then_snapshot(10, "svg"; cb = cb)

# 11-13: Full drawing snapshot from transformed recording surface
Drawing(640, 480, :rec)
origin()
scale(0.5)
ripples_then_snapshot(11, "png")
scale(2)
ripples_then_snapshot(12, "png")
origin()
scale(1, 0.5)
ctm = getmatrix()
ctm[3] = 0.1     # shear y
setmatrix(ctm)
rotate(π / 15)
ripples_then_snapshot(13, "png")

# 14-16: Crop and scale snapshot from transformed recording surface
pul = Point(-240, -380)
fontsize(36)
text("ul", pul, valign = :top)
pur = Point(80, -380)
text("ur", pur, valign = :top)
pbr = Point(80, -140)
text("br", pbr, valign = :top)
pbl = Point(-240, -140)
text("Bottom left", pbl, valign = :bottom)
cb = BoundingBox(pul, pbr)
frame_then_snapshot(14, "png", cb)
frame_then_snapshot(15, "png", cb, scalefactor = 2)
testsnapshot(fna(16, "png"))
finish()
