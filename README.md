![luxor splash image](docs/src/assets/figures/luxor-social-media-preview.png)

| **Documentation**                       | **Build Status**                          | **Code Coverage**               |
|:---------------------------------------:|:-----------------------------------------:|:-------------------------------:|
| [![][docs-stable-img]][docs-stable-url] | [![Build Status][ci-img]][ci-url]         | [![][codecov-img]][codecov-url] |
| [![][docs-development-img]][docs-development-url] | [![Build Status][appvey-img]][appvey-url] |                                 |

## Luxor

Luxor is a Julia package for drawing simple static 2D vector graphics. It provides basic drawing functions and utilities for working with shapes, polygons, clipping masks, PNG and SVG images, turtle graphics, and simple animations.

!["luxor gallery"](docs/src/assets/figures/luxorgallery.svg)

The focus of Luxor is on simplicity and ease of use: it should be easier to use than plain [Cairo.jl](https://github.com/JuliaLang/Cairo.jl), with shorter names, fewer underscores, default contexts, and simplified functions. 

For more complex and sophisticated graphics in 2D and 3D, [Makie.jl](https://docs.makie.org/stable/) is the best choice.

Luxor is thoroughly procedural and static: your code issues a sequence of simple graphics ‘commands’ until you’ve completed a drawing, then the results are saved into a PDF, PNG, SVG, or EPS file.

Tutorials can be found in the documentation, which you find by clicking on the badges above:
![where is the documentation?](docs/src/assets/figures/where-is-the-documentation.png)

“stable” describes the current release; “development” contains changes that are still in the master branch and may change before the next release.

There are some Luxor-related videos on [YouTube](https://www.youtube.com/channel/UCfd52kTA5JpzOEItSqXLQxg), and some Luxor-related blog posts at [cormullion.github.io/](https://cormullion.github.io/).

Luxor is designed primarily for drawing static pictures and simple animations. If you want to build complex or elaborate animations, use [Javis.jl](https://github.com/JuliaAnimators/Javis.jl) and [Makie](https://docs.makie.org/stable/). 

Luxor isn't interactive: for building interactivity, look at [Pluto.jl](https://github.com/fonsp/Pluto.jl) and [Makie](https://docs.makie.org/stable/).

[docs-development-img]: https://img.shields.io/badge/docs-development-blue
[docs-development-url]: http://juliagraphics.github.io/Luxor.jl/dev/

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: http://juliagraphics.github.io/Luxor.jl/stable/

[travis-img]: https://travis-ci.org/JuliaGraphics/Luxor.jl.svg?branch=master
[travis-url]: https://travis-ci.org/JuliaGraphics/Luxor.jl

[appvey-img]: https://ci.appveyor.com/api/projects/status/6pq9v30famcoe3dd?svg=true
[appvey-url]: https://ci.appveyor.com/project/cormullion/luxor-jl/branch/master

[codecov-img]: https://codecov.io/gh/JuliaGraphics/Luxor.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/JuliaGraphics/Luxor.jl

[ci-img]: https://github.com/cormullion/Luxor.jl/workflows/CI/badge.svg
[ci-url]: https://github.com/cormullion/Luxor.jl/actions?query=workflow%3ACI
