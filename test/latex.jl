using Luxor
using Test
using LaTeXStrings
using MathTeXEngine

@testset "latex" begin
    d = Drawing(200, 200, :svg)
    background("black")
    origin()
    fontsize(18)
    sethue("gold")
    t = L"\sum^N_{n=1} \frac{x}{n}"

    for halign in [:left, :right, :center], valign in [:baseline, :bottom, :top, :middle]
        text(t, O, halign=halign, valign=valign)

        @test round.(Luxor.latextextsize(t); digits=2) == (36.99, 46.69)

        if halign === :left
            @test round(Luxor.latexboundingbox(t, halign=halign, valign=valign)[1][1]; digits=2) == 0.0
            @test round(Luxor.latexboundingbox(t, halign=halign, valign=valign)[2][1]; digits=2) == 36.99
        elseif halign === :right
            @test round(Luxor.latexboundingbox(t, halign=halign, valign=valign)[1][1]; digits=2) == -36.99
            @test round(Luxor.latexboundingbox(t, halign=halign, valign=valign)[2][1]; digits=2) == 0.0
        elseif halign === :center
            @test round(Luxor.latexboundingbox(t, halign=halign, valign=valign)[1][1]; digits=2) == -36.98 / 2
            @test round(Luxor.latexboundingbox(t, halign=halign, valign=valign)[2][1]; digits=2) == 36.98 / 2
        end

        if valign === :baseline || valign === :bottom
            @test round(Luxor.latexboundingbox(t, halign=halign, valign=valign)[1][2]; digits=2) == 18.72
            @test round(Luxor.latexboundingbox(t, halign=halign, valign=valign)[2][2]; digits=2) == -27.97
        elseif valign === :top
            @test round(Luxor.latexboundingbox(t, halign=halign, valign=valign)[1][2]; digits=2) == 46.69
            @test round(Luxor.latexboundingbox(t, halign=halign, valign=valign)[2][2]; digits=2) == 0.0
        elseif valign === :middle
            @test round(Luxor.latexboundingbox(t, halign=halign, valign=valign)[1][2]; digits=2) == 46.70 / 2
            @test round(Luxor.latexboundingbox(t, halign=halign, valign=valign)[2][2]; digits=2) == -46.70 / 2
        end
    end

    finish()
end

function latex_test(fname)
    latexstrings = [
        L"\frac{𝔸}{2}",
        L"𝔸𝔹ℂ𝕬𝕭𝕮𝒜ℬ𝒞𝕒𝕓𝕔𝐚𝐛𝐜𝐀𝐁𝐂𝓐𝓑𝓒",
        L"e^x = \sum^\infty_{n=0} \frac{x^n}{n!} = \lim_{n\to\infty}(1+\frac{x}{n})^n",
        L"\sum^N_{n=1} \frac{x}{n}",
        L"Asset policy function $g(a,s)$",
        L"e^{i\pi} + 1 = 0",
        L"e^x = \sum^\infty_{n=0} \frac{x^n}{n!} = \lim_{n\to\infty}(1+\frac{x}{n})^n",
        L"\cos(\theta)",
        L"f(t) = [4\cos(t) + 2\cos(5t), 4\sin(t) + 2\sin(5t)]",
    ]
    Drawing(1600, 1200, fname)
    origin()
    background("black")
    sethue("orange")

    fontsize(30)
    pt = boxtopleft() + (400, 150)
    grid = GridRect(pt, 800, 100, 1600, 1200)
    for l in 1:length(latexstrings)
        randomhue()
        text(latexstrings[l], pt, halign = :center, paths=true)
        fillpath()
        pt = nextgridpoint(grid)
        randomhue()
        text(latexstrings[l], pt, halign = :center, paths=false)
        pt = nextgridpoint(grid)
    end
    @test finish() == true
end

fname = "latex-test.png"
latex_test(fname)
println("...finished latex test: output in $(fname)")
