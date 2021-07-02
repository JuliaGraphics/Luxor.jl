using Documenter, Luxor

makedocs(
    modules = [Luxor],
    sitename = "Luxor",
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true",
        assets = ["assets/luxor-docs.css"],
        collapselevel=1,
        ),
    pages    = [
        "Introduction to Luxor"            =>  "index.md",
        "Tutorials" => [
            "A first tutorial"             =>  "tutorial/basictutorial.md",
            "Design a logo"                =>  "tutorial/design-a-logo.md",
            "Simple animations"            =>  "tutorial/simple-animation.md",
            ],
        "Examples" => [
            "Simple examples"              =>  "example/examples.md",
            "More examples"                =>  "example/moreexamples.md",
            ],
        "How to guides" => [
            "Create drawings"              =>  "howto/createdrawings.md",
            "Draw simple shapes"           =>  "howto/simplegraphics.md",
            "Use geometry tools"           =>  "howto/geometrytools.md",
            "Work with tables and grids"   =>  "howto/tables-grids.md",
            "Use colors and styles"        =>  "howto/colors-styles.md",
            "Work with polygons"           =>  "howto/polygons.md",
            "Add text"                     =>  "howto/text.md",
            "Clip graphics"                =>  "howto/clipping.md",
            "Placing images"                       =>  "howto/images.md",
            "Turtle graphics"              =>  "howto/turtle.md",
            "Make animations"              =>  "howto/animation.md",
            "Live graphics and snapshots"  =>  "howto/livegraphics.md",
            ],
        "Explanations" => [
            "Basic concepts"               =>  "explanation/basics.md",
            "Image matrix"                 =>  "explanation/imagematrix.md",
            "Transforms and matrices"      =>  "explanation/transforms.md",
            "Contributing"                 =>  "explanation/contributing.md",
            ],
        "Reference" => [
            "Alphabetical function list"   =>  "reference/functionindex.md"
            "Function reference"           =>  "reference/api.md"
            ],
        ]
    )

deploydocs(
    repo = "github.com/JuliaGraphics/Luxor.jl.git",
    target = "build"
)
