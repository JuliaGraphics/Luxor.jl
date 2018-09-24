if Base.HOME_PROJECT[] !== nothing
    # JuliaLang/julia/pull/28625
    Base.HOME_PROJECT[] = abspath(Base.HOME_PROJECT[])
end

using Documenter, Luxor

makedocs(
    modules = [Luxor],
    format = :html,
    sitename = "Luxor",
    pages    = Any[
        "Introduction to Luxor"   => "index.md",
        "A few examples"          => "examples.md",
        "Tutorial"                => "tutorial.md",
        "Basic concepts"          => "basics.md",
        "Simple shapes"           => "simplegraphics.md",
        "More graphics"           => "moregraphics.md",
        "Geometry tools"          => "geometrytools.md",
        "Tables and grids"        => "tables-grids.md",
        "Colors and styles"       => "colors-styles.md",
        "Polygons and paths"      => "polygons.md",
        "Text"                    => "text.md",
        "Transforms and matrices" => "transforms.md",
        "Clipping"                => "clipping.md",
        "Images"                  => "images.md",
        "Turtle graphics"         => "turtle.md",
        "Animation"               => "animation.md",
        "More examples"           => "moreexamples.md",
        "Index"                   => "functionindex.md"
        ]
    )

deploydocs(
    repo = "github.com/JuliaGraphics/Luxor.jl.git",
    target = "build",
    julia  = "1.0",
    osname = "osx",
    deps = nothing,
    make = nothing
)
