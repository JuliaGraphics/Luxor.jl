using Test, Random
Random.seed!(42)

ENV["JULIA_DEBUG"] = Main

function run_all_tests()

    @testset "Basics" begin
        include("basic-test.jl")
    end

    @testset "animation (Unix only)" begin
        if ! Sys.iswindows()
            include("animation-test.jl")
        end
        include("easingfunctions.jl")
    end

    @testset "despatch methds" begin
        include("action-testing.jl")
    end

    @testset "polygons" begin
        include("boxtests.jl")
        include("offset-poly-tests.jl")
        include("path-to-poly.jl")
        include("point-arithmetic.jl")
        include("point-inside-polygon.jl")
        include("point-on-polygon.jl")
        include("point-intersection.jl")
        include("polycross-test.jl")
        include("polyfit-test.jl")
        include("polysample.jl")
        include("polygon-centroid-sort-test.jl")
        include("polygon-test.jl")
        include("polysplit.jl")
        include("polysplit-2.jl")
        include("polysmooth-tests.jl")
        include("pretty-poly-test.jl")
        include("simplify-polygons.jl")
        include("spirals.jl")
        include("star-test-1.jl")
        include("star-test.jl")
        include("test-holes.jl")
        include("morepolytests.jl")
        include("polytriangulate.jl")
        include("pointcircletangent-test.jl")
        include("convexandclockwise.jl")
        include("various-points-tests.jl")
        include("polyhull-test.jl")
    end

    @testset "text" begin
        include("text-alignment.jl")
        include("text-rotations.jl")
        include("pro-text-test.jl")
        include("text-curve-centered.jl")
        include("text-path-clipping.jl")
        include("text-wrapping.jl")
        include("text-boxes.jl")
        include("label-tests.jl")
        include("textfit-tests.jl")
        include("latex.jl")
    end

    @testset "curves" begin
        include("arc-twopoints.jl")
        include("circletests.jl")
        include("circleintersectiontests.jl")
        include("circle-as-path.jl")
        include("randomsinecurves.jl")
        include("sector-test.jl")
        include("sector-rounded.jl")
        include("ellipse-test.jl")
        include("hypertrochoid-test.jl")
        include("epitrochoid-test.jl")
        include("pie-test.jl")
        include("bezierpath.jl")
        include("bezierpathtopoly.jl")
        include("bezierstroke-test.jl")
        include("circletangent-test.jl")
        include("arc-sagitta-test.jl")
        include("circlecircletangent-test.jl")
        include("pointcircletangent-test.jl")
        include("crescent-test.jl")
    end

    @testset "color" begin
        include("color-blend-test.jl")
        include("blendmodes.jl")
        include("palette_test.jl")
        include("meshtest.jl")
    end

    @testset "images" begin
        include("images-with-alpha.jl")
        include("test-image.jl")
#        include("tiling-images.jl")
        include("test-snapshot.jl")
    end

    @testset "imagematrix" begin
        include("imagematrix.jl")
    end

    @testset "arrows and dimensions" begin
        include("arrow-arc-test.jl")
        include("arrow-bezier-test.jl")
        include("arrow-line-test.jl")
        include("dimensioning.jl")
    end

    @testset "paths" begin
        include("get_path.jl")
        include("get_path_flat.jl")
        include("paths.jl")
    end

    @testset "julia logos" begin
        include("heart-julia.jl")
        include("julia-logo-draw-eps.jl")
        include("julia-logo-draw.jl")
        include("julia-logo-testing.jl")
    end

    @testset "rulers" begin
        include("rulers-test.jl")
    end

    @testset "boundingbox" begin
        include("boundingboxtests.jl")
        include("boundingboxpointtests.jl")
    end

    @testset "clipping" begin
        include("clipping-test.jl")
    end

    @testset "tilerstables" begin
        include("pagetiler-test.jl")
        include("table-tests.jl")
    end
    @testset "matrix" begin
        include("matrix-tests.jl")
    end
    @testset "sierpinski" begin
        include("sierpinski-svg.jl")
        include("sierpinski.jl")
    end
    @testset "turtle" begin
        include("turtle-test.jl")
    end
    @testset "intersection" begin
        include("line-intersection-options.jl")
        include("intersection-line-circle.jl")
        include("line-intersections.jl")
        include("polygonintersect-test.jl")
        include("pointcrossesboundingboxtests.jl")
    end
    @testset "misc" begin
        include("luxor-test1.jl")
        include("rules.jl")
        include("barstest.jl")
        include("unit-conversions.jl")
        include("hex-grid-test.jl")
        include("cropmarkstest.jl")
        include("boxmaptest.jl")
        include("noise-test.jl")
        include("dashtests.jl")
        include("triangles.jl")
        include("place-svg.jl")
        include("strokescale-test.jl")
    end
end

if get(ENV, "LUXOR_KEEP_TEST_RESULTS", false) == "true"
        cd(mktempdir(cleanup=false))
        @info("...Keeping the results in: $(pwd())")
        run_all_tests()
        @info("Test images were saved in: $(pwd())")
else
    mktempdir() do tmpdir
        cd(tmpdir) do
            @info("running tests in: $(pwd())")
            @info("but not keeping the results")
            @info("because you didn't do: ENV[\"LUXOR_KEEP_TEST_RESULTS\"] = \"true\"")
            run_all_tests()
            @info("Test images weren't saved. To see the test images, next time do this before running:")
            @info(" ENV[\"LUXOR_KEEP_TEST_RESULTS\"] = \"true\"")
        end
    end
end
