import Pkg
using Luxor
using Test

if VERSION < v"1.10"
    @warn "can't test Typstry on Julia versions < 1.10"
else
    @testset "notypstryextension" begin
        @test !@isdefined typst
        @test Base.get_extension(Luxor, :LuxorExtTypstry) isa Nothing
    end

    Pkg.add("Typstry")
    using Typstry

    @testset "typstryextension" begin
        @test Base.get_extension(Luxor, :LuxorExtTypstry) isa Module
    end
end