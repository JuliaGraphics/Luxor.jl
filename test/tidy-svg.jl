using Luxor, Test

f1 = "tidy_svg_testing_1.svg"
@svg begin
    fontsize(100)
    text("hello")
    text("world", O + (0, 100))
end 500 500 f1

f2 = "tidy_svg_testing_2.svg"
@svg begin
    fontsize(100)
    text("hello")
    text("world", O + (0, 100))
end 500 500 f2

tidysvg(f1, "tidy_svg_testing_3.svg")

tidysvg(f2, "tidy_svg_testing_4.svg")

lines_1 = open("tidy_svg_testing_1.svg") do f
    readlines(f)
end

lines_2 = open("tidy_svg_testing_2.svg") do f
    readlines(f)
end

lines_3 = open("tidy_svg_testing_3.svg") do f
    readlines(f)
end

lines_4 = open("tidy_svg_testing_4.svg") do f
    readlines(f)
end

# without running tidysvg(), symbols are the same
for i in eachindex(lines_1)
    if occursin("<symbol", lines_1[i])
        @test lines_1[i] == lines_2[i]
    end
end

# after running tidysvg(), symbols should be different
for i in eachindex(lines_3)
    if occursin("<symbol", lines_3[i])
        @test lines_3[i] != lines_4[i]
    end
end

println("...finished tidysvg testing")