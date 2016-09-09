# Introduction to Luxor

Luxor provides basic vector drawing functions and utilities for working with shapes, polygons, clipping masks, PNG images, and turtle graphics.

The idea of Luxor is that it's easier to use than [Cairo.jl](https://github.com/JuliaLang/Cairo.jl), with shorter names, fewer underscores, default contexts, utilities, and simplified functions. It's for when you just want to draw something without too much ceremony.

[Colors.jl](https://github.com/JuliaGraphics/Colors.jl) provides excellent color definitions.

## Current status

Luxor currently runs on Julia version 0.5, using Cairo.jl and Colors.jl.

Please submit issues and pull requests on [github](https://github.com/cormullion/Luxor.jl)!

## Installation and basic usage

Since the package is currently unregistered, install it as follows:

```
Pkg.clone("https://github.com/cormullion/Luxor.jl")
```

and to use it:

```
using Luxor
```

In most of the examples in this documentation, it's assumed that you have added:

```
using Luxor, Colors
```

before the graphics commands.
