# Introduction to Luxor

Luxor provides basic vector drawing functions and utilities for working with shapes, polygons, clipping masks, PNG images, and turtle graphics. It's intended to be an easy interface to [Cairo.jl](https://github.com/JuliaLang/Cairo.jl).

## Current status

Luxor currently runs on Julia version 0.5, using Cairo.jl and Colors.jl.

Please submit issues and pull requests on [github](https://github.com/cormullion/Luxor.jl)!

## Installation and basic usage

Install the package as follows:

```
Pkg.add("Luxor.jl")
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
