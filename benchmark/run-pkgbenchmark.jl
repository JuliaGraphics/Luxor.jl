using Pkg
Pkg.add("PkgBenchmark")
using PkgBenchmark

import Luxor
benchmarkpkg("Luxor")


#=

shell> cd benchmark
(@v1.9) pkg> activate .
  Activating project at `~/.julia/dev/Luxor/benchmark`
julia-1.9> include("run-pkgbenchmark.jl")

=#

