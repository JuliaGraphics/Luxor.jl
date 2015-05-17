using Luxor
using Base.Test

# write your own tests here

tests = filter!(f -> endswith(f, ".jl"), readdir())

deleteat!(tests,findfirst(tests, "runtests.jl")) # don't run this file again.. .:)

for test in tests
    println("running $test")
    include(test)
end
