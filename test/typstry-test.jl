using Luxor
using Test

@testset "notypstryextension" begin
    @test !@isdefined typst
    @test Base.get_extension(Luxor, :LuxorExtTypstry) isa Nothing
 end

using Typstry

@testset "typstryextension" begin
    @test Base.get_extension(Luxor, :LuxorExtTypstry) isa Module
end