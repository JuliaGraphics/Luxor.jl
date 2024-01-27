using Documenter, Luxor

makedocs(
    modules  = [Luxor],
    sitename = "Luxor",
    warnonly = true,
    format   = Documenter.HTML(
        size_threshold = nothing,
        prettyurls = get(ENV, "CI", nothing) == "true",
        assets = ["assets/luxor-docs.css"],
        collapselevel = 1,
    ),
    pages = [
        "Introduction to Luxor" => "index.md",
        "Tutorials" => [
        "Hello World" => "tutorial/helloworld.md",
        "Basic path building" => "tutorial/basicpath.md",
        "Design a logo"       => "tutorial/quickstart.md",
        "Geometry tutorial"   => "tutorial/basictutorial.md",
        "Playing with pixels" => "tutorial/pixels.md",
        "Simple animation"    => "tutorial/simple-animation.md"
        ],
        "Examples" => [
        "Simple examples" => "example/examples.md",
        "More examples"   => "example/moreexamples.md",
        "Gallery"   => "example/gallery.md",
        ],
        "How to guides" => [
        "Create drawings" => "howto/createdrawings.md",
        "Draw simple shapes" => "howto/simplegraphics.md",
        "Use geometry tools" => "howto/geometrytools.md",
        "Work with tables and grids" => "howto/tables-grids.md",
        "Use colors and styles" => "howto/colors-styles.md",
        "Work with polygons" => "howto/polygons.md",
        "Add text" => "howto/text.md",
        "Clip graphics" => "howto/clipping.md",
        "Placing images" => "howto/images.md",
        "Turtle graphics" => "howto/turtle.md",
        "Make animations" => "howto/animation.md",
        "Snapshots" => "howto/snapshots.md",
        "Interactive graphics and Threads" => "howto/livegraphics.md"
        ],
        "Explanations" => [
        "Basic concepts" => "explanation/basics.md",
        "Paths vs Polygon" => "explanation/pathspolygons.md",
        "Perfect pixels and antialising" => "explanation/perfectpixels.md",
        "Transforms and matrices" => "explanation/transforms.md",
        "Image matrix" => "explanation/imagematrix.md",
        "Fonts on Linux" => "explanation/fonts.md",
        "Luxor and Cairo" => "explanation/luxorcairo.md",
        "Customize strokepath/fillpath" => "explanation/strokepathdispatch.md",
        "Contributing" => "explanation/contributing.md"
        ],
        "Reference" => [
        "Alphabetical function list" => "reference/functionindex.md"
        "Function reference"         => "reference/api.md"
        ]
    ],
)

repo = "github.com/JuliaGraphics/LuxorManual.git"
withenv("GITHUB_REPOSITORY" => repo) do
    deploydocs(
      repo = repo,
      target = "build",
      push_preview = true,
      forcepush = true,
    )
end
