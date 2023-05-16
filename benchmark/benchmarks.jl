using BenchmarkTools
using Random
using Luxor

# load some benchmarking functions
include("simple-benchmarks.jl")

# Define a parent BenchmarkGroup to contain our suite

SUITE = BenchmarkGroup()

# Add some child groups to our benchmark suite

SUITE["string"] = BenchmarkGroup(["string"])
SUITE["graphics"] = BenchmarkGroup(["graphics"])

# add some benchmarking calls ?

SUITE["string"]["tiletext"] = @benchmarkable bm_text()
SUITE["string"]["tiletextoutlines"] = @benchmarkable bm_text_outlines()
SUITE["graphics"]["tilegraphics"] = @benchmarkable bm_graphics()
