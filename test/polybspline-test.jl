using Luxor

using Test

using Random
Random.seed!(42)

function test_polybspline()
    controlpoints = [Point(rand(), rand()) for _ in 1:10]

    resultClamped = polybspline(controlpoints, 10;clamped = true)
    resultUnClamped = polybspline(controlpoints, 10;clamped = false)
    # Check if the result is an array of the correct length
    @test length(resultClamped) == 10
    @test length(resultUnClamped) == 10

    # Check if the result is an array of Points
    @test all(x -> x isa Point, resultClamped)
    @test all(x -> x isa Point, resultUnClamped)

    # Check that all the values in the result points are non NaN
    @test all(x -> !isnan(x.x) && !isnan(x.y), resultClamped)
    @test all(x -> !isnan(x.x) && !isnan(x.y), resultUnClamped)
    
    # Check that all the result points lie within the bounding box of the control points
    min_x, max_x = extrema(p.x for p in controlpoints)
    min_y, max_y = extrema(p.y for p in controlpoints)

    @test all(min_x <= p.x <= max_x && min_y <= p.y <= max_y for p in resultClamped)
    @test all(min_x <= p.x <= max_x && min_y <= p.y <= max_y for p in resultUnClamped)
end

test_polybspline()
println("...finished polybspline test")