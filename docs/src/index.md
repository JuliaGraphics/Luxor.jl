```@meta
DocTestSetup = quote
    using Luxor, Dates, Colors
end
```


```@raw html
---
layout: home

hero:
  name: Luxor.jl
  text: Simple vector graphics
  tagline: a simple interface to Cairo.jl - Cairo for tourists!
  actions:
    - theme: brand
      text: Tutorial
      link: /tutorial/helloworld
    - theme: alt
      text: View on GitHub
      link: https://github.com/JuliaGraphics/Luxor.jl
  image:
    src: /assets/logo.svg
    alt: Luxor.jl
    dark: /assets/logo.svg # optional: a variant for dark themes

features:
  - icon:
      light: /figures/icon-1.svg
      dark: /figures/icon-1.svg
      alt: colorful graphic
      wrap: true
    title: Colorful drawings
    details: "With Luxor you can make all kinds of drawings with vector and pixel graphics, static illustrations, diagrams, generative artworks, and simple animations, using colored fills, strokes, patterns, blends, and gradient meshes. There are turtles too, if you like exploring Turtle Graphics."
    link: /tutorial/helloworld
  - icon:
      light: /figures/icon-2.svg
      dark: /figures/icon-2.svg
      alt: colorful graphic
      wrap: true
    title: Graphical toolbox
    details: "Luxor provides lots of graphic primitives: lines, rectangles, circles, ellipses, arcs, polygons, Bézier curves, squircles, hypotrochoids, stars, crescents, pies, sectors, plus options for filling, stroking, clipping, and blending shapes. You can build up complex compositions using coordinate transformations (translation, rotation, and scaling) and Boolean operations."
    link: /howto/simplegraphics
  - icon:
      light: /figures/icon-3.svg
      dark: /figures/icon-3.svg
      alt: text handling
      wrap: true
    title: Text
    details: "Luxor's text handling allows for custom fonts, text alignment, text-on-a-path, and precise placement, useful for annotated diagrams, posters, and typographic experiments in addition to pure geometric art. You can add text to drawings using the LaTEX and Typst text engines."
    link: /howto/text
  - icon:
      light: /figures/icon-4.svg
      dark: /figures/icon-4.svg
      alt: grids 
      wrap: true
    title: Layout
    details: "Luxor includes features for common layout tasks, such as arranging objects in grids and tables, creating tiling patterns, and computing point arrangements along paths."
    link: /howto/tables-grids
  - icon:
      light: /figures/icon-5.png
      dark: /figures/icon-5.png
      alt: mona mona lisa 
      wrap: true
    title: Pixels and noise
    details: "Luxor lets you add pixel-based graphics to drawings, and you can interact with Julia's images-processing package Images.jl. You can freely mix pixel images and vector graphics, and there's noise generation tools too, for making graphics based on procedural noise."
    link: /howto/images
  - icon:
      light: /figures/icon-6.apng
      dark: /figures/icon-6.apng
      alt: output formats
      wrap: true
    title: Output
    details: "You can export drawings to multiple formats, including PNG, SVG, PDF, and EPS, and Luxor integrates well with Jupyter/Pluto notebooks for inline previews. Animations can be exported as animated GIFs and MP4 movies."
    link: /howto/createdrawings
---
```

The focus of Luxor is on simplicity and ease of use: it should be easier to use than plain [Cairo.jl](https://github.com/JuliaLang/Cairo.jl), with shorter names, fewer underscores, default contexts, and simplified functions.

Luxor is thoroughly procedural and static: your code issues a sequence of simple graphics 'commands' until you've completed a drawing, then the results are saved into a PDF, PNG, SVG, or EPS file.

Here's a Luxor drawing showing some of the possibilities:

!["luxor gallery"](assets/figures/luxorgallery.svg)

For more complex and sophisticated graphics in 2D and 3D, [Makie.jl](https://docs.makie.org/stable/) is the best choice.

There are some Luxor-related videos on [YouTube](https://www.youtube.com/channel/UCfd52kTA5JpzOEItSqXLQxg), and some Luxor-related blog posts at [cormullion.github.io/](https://cormullion.github.io/).

Luxor is designed primarily for drawing static pictures and simple animations. If you want to build complex or elaborate animations, use [Javis.jl](https://github.com/JuliaAnimators/Javis.jl) and [Makie](https://docs.makie.org/stable/).

Luxor isn't interactive: for building interactivity, look at [Pluto.jl](https://github.com/fonsp/Pluto.jl) and [Makie](https://docs.makie.org/stable/).

Please submit issues and pull requests on [GitHub](https://github.com/JuliaGraphics/Luxor.jl). Original version by [cormullion](https://github.com/cormullion), much improved with contributions from the Julia community.

## Installation and basic usage

Install the package using the package manager:

```julia-repl
] add Luxor
```

To use Luxor, type:

```julia
using Luxor
```

To test:

```julia-repl
julia> @svg juliacircles()
```

or

```julia-repl
julia> @png juliacircles()
```

which should create a graphic file and possibly also display and/or open it, depending on your environment.

## Documentation

This documentation was built using [Documenter.jl](https://github.com/JuliaDocs).

```@example
using Dates # hide
println("Documentation built $(Dates.now()) with Julia $(VERSION) on $(Sys.KERNEL)") # hide
```
