using Compat

if @compat is_unix()
  cd("/tmp")
end

info(" running tests in: $(pwd())")

info("starting test arc-twopoints" );               include("arc-twopoints.jl")
info("starting test arrow-arc-test" );              include("arrow-arc-test.jl")
info("starting test arrow-line-test" );             include("arrow-line-test.jl")
info("starting test axes-test" );                   include("axes-test.jl")
info("starting test circletests" );                 include("circletests.jl")
info("starting test clipping-test" );               include("clipping-test.jl")
info("starting test color-blend-test" );            include("color-blend-test.jl")
info("starting test ellipse test" );               include("ellipse-test.jl")

# this test fails when followed by other tests in the same session, but not on its own.
# Presumably there's some pointer or something in Cairo which isn't released properly
# When Cairo is updated the test can be included.
# info("starting test get_path" ); include("get_path.jl")

info("starting test heart-julia" );                include("heart-julia.jl")
info("starting test images_with_alpha" );          include("images-with-alpha.jl")
info("starting test julia_logo_draw_eps" );        include("julia-logo-draw-eps.jl")
info("starting test julia_logo_draw" );            include("julia-logo-draw.jl")
info("starting test line-intersection-options." );            include("line-intersection-options.jl")
info("starting test luxor-test1") ;                include("luxor-test1.jl")
info("starting test matrix-tests" );               include("matrix-tests.jl")
info("starting test palette_test" );               include("palette_test.jl")
info("starting test pie-test" );                   include("pie-test.jl")
info("starting test point-arithmetic" );           include("point-arithmetic.jl")
info("starting test point-inside-polygon" );       include("point-inside-polygon.jl")
info("starting test point-intersection" );         include("point-intersection.jl")
info("starting test polygon-centroid-sort-test" ); include("polygon-centroid-sort-test.jl")
info("starting test polygon-test" );               include("polygon-test.jl")
info("starting test polysplit" );                  include("polysplit.jl")
info("starting test polysmooth-tests" );           include("polysmooth-tests.jl")
info("starting test pretty-poly-test" );           include("pretty-poly-test.jl")
info("starting test randomsinecurves" );           include("randomsinecurves.jl")
info("starting test sector-test" );                include("sector-test.jl")
info("starting test sierpinski-svg" );             include("sierpinski-svg.jl")
info("starting test sierpinski" );                 include("sierpinski.jl")
info("starting test simplify-polygons" );          include("simplify-polygons.jl")
info("starting test star-test-1" );                include("star-test-1.jl")
info("starting test star-test" );                  include("star-test.jl")
info("starting test test-holes" );                 include("test-holes.jl")
info("starting test test-image" );                 include("test-image.jl")
info("starting test text-alignment" );             include("text-alignment.jl")
info("starting test text-curve-centered");         include("text-curve-centered.jl")
info("starting test text-path-clipping" );         include("text-path-clipping.jl")
info("starting test tiling-images" );              include("tiling-images.jl")
info("starting test turtle" );                     include("turtle.jl")

info("all tests finished. Images were saved to $(pwd()).")
