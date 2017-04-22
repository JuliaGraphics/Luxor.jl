![splash image](docs/src/assets/figures/luxor-big-logo.png)

| **Documentation**                       | [**Package Evaluator**][pkgeval-link] | **Build Status**                          | **Code Coverage**               |
|:---------------------------------------:|:-------------------------------------:|:-----------------------------------------:|:-------------------------------:|
| [![][docs-stable-img]][docs-stable-url] | [![][pkg-0.4-img]][pkg-0.4-url]       | [![Build Status][travis-img]][travis-url] | [![][codecov-img]][codecov-url] |
| [![][docs-latest-img]][docs-latest-url] | [![][pkg-0.5-img]][pkg-0.5-url]       | [![Build Status][appvey-img]][appvey-url] |                                 |
|                                         | [![][pkg-0.6-img]][pkg-0.6-url]       |                                           |                                 |

## Luxor

Luxor is a Julia package for drawing simple vector graphics. It provides basic drawing functions and utilities for working with shapes, polygons, clipping masks, PNG images, turtle graphics, animations, and shapefiles. The focus of Luxor is on simplicity and ease of use: it should be easier to use than plain [Cairo.jl](https://github.com/JuliaLang/Cairo.jl), with shorter names, fewer underscores, default contexts, and simplified functions.

Luxor is thoroughly procedural: your code issues a sequence of simple graphics 'commands' until you've completed a drawing, then the results are saved it into a PDF, PNG, SVG, or EPS file.

For interactive graphics, try [Gtk.jl](https://github.com/JuliaGraphics/Gtk.jl) or [GLVisualize](https://github.com/JuliaGL/GLVisualize.jl).

[docs-latest-img]: https://img.shields.io/badge/docs-latest-blue.svg
[docs-latest-url]: http://juliagraphics.github.io/Luxor.jl/latest/

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: http://juliagraphics.github.io/Luxor.jl/stable/

[pkgeval-link]: http://pkg.julialang.org/?pkg=Luxor

[pkg-0.4-img]: http://pkg.julialang.org/badges/Luxor_0.4.svg
[pkg-0.4-url]: http://pkg.julialang.org/detail/Luxor.html

[pkg-0.5-img]: http://pkg.julialang.org/badges/Luxor_0.5.svg
[pkg-0.5-url]: http://pkg.julialang.org/detail/Luxor.html

[pkg-0.6-img]: http://pkg.julialang.org/badges/Luxor_0.6.svg
[pkg-0.6-url]: http://pkg.julialang.org/detail/Luxor.html

[travis-img]: https://travis-ci.org/JuliaGraphics/Luxor.jl.svg?branch=master
[travis-url]: https://travis-ci.org/JuliaGraphics/Luxor.jl

[appvey-img]: https://ci.appveyor.com/api/projects/status/jfa9e54lv92rqd3m?svg=true
[appvey-url]: https://ci.appveyor.com/project/cormullion/luxor-jl/branch/master

[codecov-img]: https://codecov.io/gh/JuliaGraphics/Luxor.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/JuliaGraphics/Luxor.jl
