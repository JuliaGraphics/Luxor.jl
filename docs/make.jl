using Documenter, Luxor

makedocs(
  modules = [Luxor],
  format = Documenter.Formats.HTML,
  sitename = "Luxor"
  )

# after this has built the files, they need to be moved up from build/ into docs/ so
# that they're served at http://cormullion.github.io/Luxor.jl/
