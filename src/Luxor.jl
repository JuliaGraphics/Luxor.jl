"""
The Luxor package provides a set of vector drawing functions for creating graphical documents.

```
@draw begin
    circle(Point(0, 0), 100, :stroke)
    text("Hello World")
end
```
"""
module Luxor

using Juno, Cairo, Colors, FileIO, Base64, Dates, Rsvg, FFMPEG

using Requires

#= from Cairo use: CairoARGBSurface, CairoEPSSurface,
#CairoMatrix, CairoPDFSurface, CairoPattern,
#CairoPatternMesh, CairoSurface, CairoSVGSurface,
#CairoContext, arc, arc_negative, circle, clip,
#clip_preserve, close_path, convert_cairo_path_data,
#copy_path, copy_path_flat, curve_to, destroy, fill,
#fill_preserve, finish, get_matrix, get_operator, height,
#image, line_to, mesh_pattern_begin_patch,
#mesh_pattern_curve_to, mesh_pattern_end_patch,
#mesh_pattern_line_to, mesh_pattern_move_to,
#mesh_pattern_set_corner_color_rgba, move_to, new_path,
#new_sub_path, paint, paint_with_alpha,
#pattern_add_color_stop_rgba, pattern_create_linear,
#pattern_create_radial, pattern_set_extend, read_from_png,
#rectangle, rel_line_to, rel_move_to, reset_clip, restore,
#rotate, save, scale, select_font_face, set_antialias,
#set_font_face, set_font_size, set_line_cap, set_line_join,
#set_dash, set_line_type, set_line_width, set_matrix,
#set_operator, set_source, set_source_rgba,
#set_source_surface, show_text, status, stroke,
#stroke_preserve, text, text_extents, text_path, translate,
#width, write_to_png =#

include("drawings.jl")
include("point.jl")
include("basics.jl")
include("Turtle.jl")
include("shapes.jl")
include("BoundingBox.jl")
include("polygons.jl")
include("triangles.jl")
include("curves.jl")
include("tiles-grids.jl")
include("arrows.jl")
include("text.jl")
include("blends.jl")
include("matrix.jl")
include("juliagraphics.jl")
include("colors_styles.jl")
include("images.jl")
include("animate.jl")
include("bars.jl")
include("bezierpath.jl")
include("mesh.jl")
include("Table.jl")
include("Boxmaptile.jl")
include("noise.jl")
include("deprecations.jl")
include("graphlayout.jl")
include("randompoints.jl")
include("Style.jl")
include("Path.jl")
# include("latex.jl")
# include("play.jl") # will require MiniFB
# include("shapefile.jl") # don't load unless you've loaded Shapefile.jl

function __init__()
    @require MathTeXEngine = "0a4f8689-d25c-4efe-a92b-7142dfc1aa53" begin
        @require LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f" include("latex.jl")
    end
end

export Drawing,
    cm, inch, mm,
    paper_sizes,
    Tiler, Partition,
    rescale,

    currentdrawing,

    finish, preview, snapshot,
    origin, rulers, background,

    @png, @pdf, @svg, @eps, @draw, @drawsvg, @savesvg,

    # @play,

    newpath, closepath, newsubpath,

    BezierPath, BezierPathSegment, bezier, bezier′,
    bezier′′, makebezierpath, drawbezierpath,
    bezierpathtopoly, beziertopoly, pathtobezierpaths,
    bezierfrompoints, beziercurvature, bezierstroke,
    setbezierhandles, beziersegmentangles,
    shiftbezierhandles, brush, trimbezier, splitbezier,

    strokepath, fillpath,

    rect, box, cropmarks,

    setantialias, setline, setlinecap, setlinejoin, setdash,
    setstrokescale,

    move, rmove, line, rule, rline, arrow, arrowhead,
    dimension, tickline,

    BoundingBox, boxwidth, boxheight, boxdiagonal,
    boxaspectratio, boxtop, boxbottom, boxtopleft,
    boxtopcenter, boxtopright, boxmiddleleft,
    boxmiddlecenter, boxmiddleright, boxbottomleft,
    boxbottomcenter, boxbottomright,

    intersectboundingboxes, boundingboxesintersect,
    pointcrossesboundingbox,

    BoxmapTile, boxmap,

    circle, circlepath, ellipse, hypotrochoid, epitrochoid,
    squircle, center3pts, curve, arc, carc, arc2r, carc2r,
    isarcclockwise, arc2sagitta, carc2sagitta, spiral,
    sector, intersection2circles, intersection_line_circle,
    intersectionlinecircle, intersectioncirclecircle,
    ispointonline, ispointonpoly, intersectlinepoly,
    polyintersect, polyintersections, circlepointtangent,
    circletangent2circles, pointinverse, pointcircletangent,
    circlecircleoutertangents, circlecircleinnertangents,
    ellipseinquad, crescent,

    ngon, ngonside, star, pie, polycross,
    do_action, paint, paint_with_alpha, fillstroke,

    AbstractPoint, Point, O, randompoint, randompointarray, midpoint,
    between, slope, intersectionlines, pointlinedistance,
    getnearestpointonline, isinside,
    rotate_point_around_point, perpendicular, crossproduct,
    dotproduct, determinant3, distance, prettypoly, polysmooth, polysplit,
    poly, simplify,  polycentroid, polysortbyangle, polyhull,
    polysortbydistance, offsetpoly, polyfit, currentpoint,
    hascurrentpoint, getworldposition, anglethreepoints,

    polyperimeter, polydistances, polyportion,
    polyremainder, nearestindex, polyarea, polysample,
    insertvertices!,

    polymove!, polyscale!, polyrotate!, polyreflect!,

    @polar, polar,

    strokepreserve, fillpreserve,
    gsave, grestore, @layer,
    scale, rotate, translate,
    clip, clippreserve, clipreset,

    getpath, getpathflat, pathtopoly,

    fontface, fontsize, text, textpath, label, textextents,
    textoutlines, textcurve, textcentred, textcentered,
    textright, textcurvecentred, textcurvecentered,
    get_fontsize, textwrap, textlines, splittext, textbox,
    texttrack, textplace, textfit, textonpoly,

    setcolor, setopacity, sethue, setgrey, setgray,
    randomhue, randomcolor, @setcolor_str,
    getmatrix, setmatrix, transform,

    setfont, settext,

    Blend, setblend, blend, addstop, blendadjust,
    blendmatrix, setblendextend, rotationmatrix, scalingmatrix,
    translationmatrix, cairotojuliamatrix,
    juliatocairomatrix, getrotation, getscale,
    gettranslation,

    setmode, getmode,

    GridHex, GridRect, nextgridpoint,

    Table, highlightcells,

    readpng, readsvg, placeimage, svgstring,

    julialogo, juliacircles,

    barchart,

    mesh, setmesh, add_mesh_patch, mask,

    # animation
    Movie, Scene, animate,

    lineartween, easeinquad, easeoutquad, easeinoutquad,
    easeincubic, easeoutcubic, easeinoutcubic, easeinquart,
    easeoutquart, easeinoutquart, easeinquint, easeoutquint,
    easeinoutquint, easeinsine, easeoutsine, easeinoutsine,
    easeinexpo, easeoutexpo, easeinoutexpo, easeincirc,
    easeoutcirc, easeinoutcirc, easingflat,
    easeinoutinversequad, easeinoutbezier,

    # noise
    noise, initnoise,

    # experimental polygon functions
    polyremovecollinearpoints, polytriangulate!,
    polytriangulate, ispointinsidetriangle, ispolyclockwise,
    polyorientation, ispolyconvex, polymorph, 

    # triangles
    trianglecircumcenter, triangleincenter, trianglecenter, triangleorthocenter,

    # misc
    image_as_matrix, @imagematrix, image_as_matrix!, @imagematrix!,

    # paths

    Path, PathClose, PathCurve, PathElement, PathLine,
    PathMove, bezierpathtopath, drawpath, storepath,
    polytopath, pathlength, pathsample,

    # experimental
    layoutgraph, Style, applystyle,

    tidysvg,

    # latex
    latextextsize, latexboundingbox, rawlatexboundingbox

# basic unit conversion to Cairo/PostScript points
const inch = 72.0
const cm = 28.3464566929
const mm = 2.83464566929

end # module
