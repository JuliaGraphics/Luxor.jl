using Base.Test

println("clipping")            ; include("clipping-test.jl")

# this test doesn't fail on its own but fails when run as part of a batch of tests
#println("copy_path")           ; include("copy_path.jl")

println("luxor-test1")         ; include("luxor-test1.jl")

println("matrix-tests")        ; include("matrix-tests.jl")

println("palette")             ; include("palette_test.jl")

println("point inside polygon"); include("point-inside-polygon.jl")

println("polygon")             ; include("polygon-test.jl")

println("sierpinski")          ; include("sierpinski.jl")

println("simplify-polygons")   ; include("simplify-polygons.jl")

println("turtle")   ; include("turtle.jl")
