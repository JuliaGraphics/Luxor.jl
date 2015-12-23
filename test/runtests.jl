using Base.Test

println("clipping")            ; include("clipping-test.jl")

#println("copy_path")           ; include("copy_path.jl")

println("luxor-test1")         ; include("luxor-test1.jl")

println("matrix-tests")        ; include("matrix-tests.jl")

println("palette")             ; include("palette_test.jl")

println("point inside polygon"); include("point-inside-polygon.jl")

println("polygon")             ; include("polygon-test.jl")

println("sierpinski")          ; include("sierpinski.jl")

println("sectors")             ; include("sector-test.jl")

println("sierpinski-svg")      ; include("sierpinski-svg.jl")

println("simplify-polygons")   ; include("simplify-polygons.jl")

println("holes")               ; include("test-holes.jl")

println("turtle")              ; include("turtle.jl")
