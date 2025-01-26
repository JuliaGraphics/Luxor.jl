"""
The Luxor package provides a set of vector drawing functions for creating graphical documents.

```julia
@draw begin
    circle(Point(0, 0), 100, :stroke)
    text("Hello World")
end
```
"""
module Luxor

using FileIO
using Base64
using Cairo
using Colors
using Dates
using FFMPEG
using Rsvg

import PolygonAlgorithms as PA

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
#set_fill_type, set_font_face, set_font_size, set_line_cap, set_line_join,
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
include("Table.jl")
include("polygonalgorithms.jl")
include("polygons.jl")
include("triangles.jl")
include("hexagons.jl")
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
include("Boxmaptile.jl")
include("noise.jl")
include("deprecations.jl")
include("randompoints.jl")
include("Path.jl")
include("precompile.jl")
include("placeeps.jl")
include("placeholders_for_extensions.jl")
# include("play.jl") # will require MiniFB
# include("shapefile.jl") # don't load unless you've loaded Shapefile.jl

export Drawing,
    cm, inch, mm,
    paper_sizes,
    Tiler, Partition,
    rescale, currentdrawing, finish, preview, snapshot,
    origin, rulers, background, @png, @pdf, @svg, @eps, @draw, @drawsvg, @savesvg,

    # @play,

    newpath, closepath, newsubpath, BezierPath, BezierPathSegment, bezier, bezier′,
    bezier′′, makebezierpath, drawbezierpath,
    bezierpathtopoly, beziertopoly, pathtobezierpaths,
    bezierfrompoints, beziercurvature, bezierstroke,
    setbezierhandles, beziersegmentangles, bezigon,
    shiftbezierhandles, brush, trimbezier, splitbezier, strokepath, fillpath, rect, box, cropmarks, setantialias, setline, getline, setlinecap, setlinejoin, setdash,
    setstrokescale, move, rmove, line, rule, rline, arrow, arrowhead,
    dimension, tickline, BoundingBox, boxwidth, boxheight, boxdiagonal,
    boxaspectratio, boxtop, boxbottom, boxtopleft,
    boxtopcenter, boxtopright, boxmiddleleft,
    boxmiddlecenter, boxmiddleright, boxbottomleft,
    boxbottomcenter, boxbottomright, intersectboundingboxes, boundingboxesintersect,
    pointcrossesboundingbox, BoxmapTile, boxmap, circle, circlepath, circlering, ellipse, hypotrochoid, epitrochoid,
    squircle, squirclepath, polysuper, center3pts, curve, arc, carc, arc2r, carc2r,
    isarcclockwise, arc2sagitta, carc2sagitta, spiral,
    sector, intersection2circles, intersection_line_circle,
    intersectionlinecircle, intersectioncirclecircle,
    ispointonline, ispointonleftofline, ispointonpoly, intersectlinepoly,
    polyintersect, polyintersections, polydifference, polyunion, polyxor,
    polyclip, circlepointtangent,
    circletangent2circles, pointinverse, pointcircletangent,
    circlecircleoutertangents, circlecircleinnertangents,
    ellipseinquad, crescent, ngon, ngonside, star, pie, polycross,
    do_action, paint, paint_with_alpha, fillstroke, AbstractPoint, Point, O, randompoint, randompointarray, midpoint,
    between, slope, intersectionlines, pointlinedistance,
    getnearestpointonline, isinside,
    rotatepoint, perpendicular, crossproduct,
    dotproduct, determinant3, distance, prettypoly, polysmooth, polysplit,
    poly, simplify, polycentroid, polysortbyangle, polyhull,
    polysortbydistance, offsetpoly, polyfit, currentpoint, polybspline,
    hascurrentpoint, getworldposition, anglethreepoints, polyperimeter, polydistances, polyportion,
    polyremainder, nearestindex, polyarea, polysample, polysidelengths, 
    insertvertices!, polymove!, polyscale!, polyrotate!, polyreflect!, @polar, polar, strokepreserve, fillpreserve,
    gsave, grestore, @layer,
    scale, rotate, translate,
    clip, clippreserve, clipreset, getpath, getpathflat, pathtopoly, fontface, fontsize, text, textpath, label, textextents,
    textoutlines, textcurve, textcentred, textcentered,
    textright, textcurvecentred, textcurvecentered,
    get_fontsize, textwrap, textlines, splittext, textbox,
    texttrack, textplace, textfit, textonpoly, textformat, setcolor, setopacity, sethue, setgrey, setgray,
    randomhue, randomcolor, @setcolor_str, getcolor,
    getmatrix, setmatrix, transform, setfont, settext, Blend, setblend, blend, addstop, blendadjust,
    blendmatrix, setblendextend, rotationmatrix, scalingmatrix,
    translationmatrix, cairotojuliamatrix,
    juliatocairomatrix, getrotation, getscale,
    gettranslation, setmode, getmode, GridHex, GridRect, nextgridpoint, 
    EquilateralTriangleGrid, Table,
    highlightcells, getcells, markcells, readpng, readsvg, placeimage, placeeps,
    svgstring, julialogo, juliacircles, barchart, mesh, setmesh, add_mesh_patch, mask,

    # animation
    Movie, Scene, animate, lineartween, easeinquad, easeoutquad, easeinoutquad,
    easeincubic, easeoutcubic, easeinoutcubic, easeinquart,
    easeoutquart, easeinoutquart, easeinquint, easeoutquint,
    easeinoutquint, easeinsine, easeoutsine, easeinoutsine,
    easeinexpo, easeoutexpo, easeinoutexpo, easeincirc,
    easeoutcirc, easeinoutcirc, easingflat,
    easeinoutinversequad, easeinoutbezier,

    # noise
    noise, initnoise,

    # experimental polygon functions
    polyremovecollinearpoints,
    polytriangulate, ispointinsidetriangle, ispolyclockwise,
    polyorientation, ispolyconvex, polymorph,

    # triangles
    trianglecircumcenter, triangleincenter, trianglecenter, triangleorthocenter,

    # hexagons
    HexagonAxial, HexagonCubic, HexagonOffsetOddR, HexagonOffsetEvenR,
    # hexagon,
    hexcenter, hexcube_round, hexcube_linedraw,
    HexagonVertexIterator, hextile, hexspiral,
    HexagonNeighborIterator, hexneighbors,
    HexagonDiagonalIterator, hexdiagonals,
    HexagonDistanceIterator, hexagons_within,
    HexagonRingIterator, hexring, hexnearest_cubic,

    # misc
    image_as_matrix, @imagematrix, image_as_matrix!, @imagematrix!,

    # paths
    Path, PathClose, PathCurve, PathElement, PathLine,
    PathMove, bezierpathtopath, drawpath, storepath,
    polytopath, pathlength, pathsample, setfillrule, getfillrule,

    # experimental
    tidysvg,

    # latex. These always throw errors if Base.get_extension(Luxor, :LuxorExtLatex) isa Nothing
    latextextsize, latexboundingbox, rawlatexboundingbox

# basic unit conversion to Cairo/PostScript points
const inch = 72.0
const cm = 28.3464566929
const mm = 2.83464566929

end # module
