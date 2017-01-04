<a id='Luxor-1'></a>

[![Luxor](http://pkg.julialang.org/badges/Luxor_0.4.svg)](http://pkg.julialang.org/?pkg=Luxor&ver=0.4)
[![Luxor](http://pkg.julialang.org/badges/Luxor_0.5.svg)](http://pkg.julialang.org/?pkg=Luxor&ver=0.5)
[![Luxor](http://pkg.julialang.org/badges/Luxor_0.6.svg)](http://pkg.julialang.org/?pkg=Luxor&ver=0.6)
[![][codecov-img]][codecov-url]

<!-- ![](docs/figures/luxor-big-logo.png) -->

![](docs/figures/snow30.gif)

Documentation: http://JuliaGraphics.github.io/Luxor.jl/

[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaGraphics.github.io/Luxor.jl/stable)
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://JuliaGraphics.github.io/Luxor.jl/latest)

[![Build Status](https://travis-ci.org/JuliaGraphics/Luxor.jl.svg?branch=master)](https://travis-ci.org/JuliaGraphics/Luxor.jl)

## Luxor

Luxor provides basic vector drawing functions, and utilities for working with shapes, polygons, clipping masks, PNG images, and turtle graphics. The focus of Luxor is on simplicity: it should be easier to use than plain  [Cairo.jl](https://github.com/JuliaLang/Cairo.jl), with shorter names, fewer underscores, default contexts, and simplified functions. The idea is that you issue a sequence of simple graphics 'commands' until you've filled a drawing, then save it into a file. For a more powerful graphics environment, have a look at [Compose.jl](https://github.com/dcjones/Compose.jl). Luxor was designed to be simpler and easier to use than Compose.

[codecov-img]: https://codecov.io/gh/JuliaGraphics/Luxor.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/JuliaGraphics/Luxor.jl
