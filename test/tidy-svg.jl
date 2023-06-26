using Luxor, Test

f1 = "f1.svg"
@svg begin
    text("hello")
    text("world")
end 500 500 f1

f2 = "f2.svg"
@svg begin
    text("hello")
    text("world")
end 500 500 f2

tidysvg(f1, "f3.svg")
tidysvg(f2, "f4.svg")

lines_1 = open("f1.svg") do f
    readlines(f)
end
lines_2 = open("f2.svg") do f
    readlines(f)
end
lines_3 = open("f3.svg") do f
    readlines(f)
end
lines_4 = open("f4.svg") do f
    readlines(f)
end

# without running tidysvg(), symbols are the same
for i in eachindex(lines_1)
    if occursin("<symbol", lines_1[i])
        @test lines_1[i] == lines_2[i]
    end
end

# with after running tidysvg(), symbols should be different
for i in eachindex(lines_3)
    if occursin("<symbol", lines_3[i])
        @test lines_3[i] != lines_4[i]
    end
end

println("...finished tidysvg testing")