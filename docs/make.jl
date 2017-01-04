using Documenter, Luxor

makedocs(
  modules = [Luxor],
  format = :html,
  sitename = "Luxor",
  pages    = Any[
    "Introduction to Luxor"   => "index.md",
    "A few examples"          => "examples.md",
    "Basic graphics"          => "basics.md",
    "Styling"                 => "styling.md",
    "Polygons"                => "polygons.md",
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
    deps = nothing,
    make = nothing,
)
