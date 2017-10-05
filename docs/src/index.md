```@meta
DocTestSetup = quote
    using Luxor
    function get_os()
        if is_apple()
           osname = "macOS"
        elseif is_unix()
           osname = "UNIX"
        elseif is_linux()
           osname = "Linux"
        elseif is_windows()
           osname = "Windows"
        else
           osname = "unspecified"
        end
        return osname
    end
    function get_os_7()
        if Sys.isapple()
           osname = "macOS"
        elseif Sys.isunix()
           osname = "UNIX"
        elseif Sys.islinux()
           osname = "Linux"
        elseif Sys.iswindows()
           osname = "Windows"
        else
           osname = "unspecified"
        end
        return osname
    end
end
```

# Introduction to Luxor

Luxor provides basic vector drawing functions and utilities for working with shapes, polygons, clipping masks, PNG images, and turtle graphics. It's intended to be an easy interface to [Cairo.jl](https://github.com/JuliaLang/Cairo.jl).

Please submit issues and pull requests on [GitHub](https://github.com/JuliaGraphics/Luxor.jl).

## Current status

Luxor currently runs on Julia versions 0.5 and 0.6, and uses Cairo.jl and Colors.jl.

!!! warning "Deprecations"

    The functions `fill()` and `stroke()` are deprecated in this release, and will be removed in a future release. They should be replaced with `fillpath()` and `strokepath()` respectively.

    The change is because `fill()` clashes with `Base.fill()`, used to fill arrays.

## Installation and basic usage

Install the package as follows:

```
Pkg.add("Luxor")
```

Cairo.jl and Colors.jl will be installed if necessary.

To use Luxor, type:

```
using Luxor
```

Original version by [cormullion](https://github.com/cormullion).

## Documentation

The documentation was built using [Documenter.jl](https://github.com/JuliaDocs).

```@example
using Luxor # hide
function get_os() # hide
    if is_apple() # hide
       osname = "macOS" # hide
    elseif is_unix() # hide
       osname = "UNIX" # hide
    elseif is_linux() # hide
       osname = "Linux" # hide
    elseif is_windows() # hide
       osname = "Windows" # hide
    else # hide
       osname = "unspecified" # hide
    end # hide
    return osname # hide
end # hide
function get_os_7() # hide
    if Sys.isapple() # hide
       osname = "macOS" # hide
    elseif Sys.isunix() # hide
       osname = "UNIX" # hide
    elseif Sys.islinux() # hide
       osname = "Linux" # hide
    elseif Sys.iswindows() # hide
       osname = "Windows" # hide
    else # hide
       osname = "unspecified" # hide
    end # hide
    return osname # hide
end # hide
println("Build date: $(now()), built with Julia $(VERSION) on $(get_os()).") # hide
```
