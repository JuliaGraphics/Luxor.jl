using Documenter, Luxor

makedocs(
  modules = [Luxor],
  format = Documenter.Formats.HTML,
  sitename = "Luxor",
  pages    = Any[
    "Introduction to Luxor"           => "index.md",
    "A few examples"                  => "examples.md",
    "Basic graphics"                  => "basics.md",
    "Transforms and matrices"         => "transforms.md",
    "Clipping"                        => "clipping.md",
    "Images"                          => "images.md",
    "Turtle graphics"                 => "turtle.md",
    "More examples"                   => "moreexamples.md",
    "Index"                           => "functionindex.md"
    ]
  )

#=
after this has built the source files, some of them
need to be moved up from build/ into docs/ so
that they're served at http://cormullion.github.io/Luxor.jl/:

docs
  build
    assets                ->
      documenter.css      -> not moved, we've customized it
      documenter.js       -> moved to docs/assets/documenter
      search.js           -> moved to docs/assets/search.js
      style.css           -> not moved, we've customized it
    index.html            -> moved to docs/index.html
    search_index.js       -> moved to docs/index.html
    search.html           -> moved to docs/index.html

=#

info("moving files")

#mv("build/assets/documenter.js", "assets/documenter.js", remove_destination=true)
#mv("build/assets/search.js", "assets/search.js", remove_destination=true)
#mv("build/assets/logo.png", "assets/logo.png", remove_destination=true)

mv("build/search_index.js", "search_index.js", remove_destination=true)

for f in filter(f -> endswith(f, ".html"), readdir("build/"))
  info("moving $f")
  mv(string("build/", f), f, remove_destination=true)
end
