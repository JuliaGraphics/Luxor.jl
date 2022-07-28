using Luxor, Test, LaTeXStrings, MathTeXEngine

using MathTeXEngine


@testset "latex" begin
    d = Drawing(200,200,:svg)
    origin()
    fontsize(18)
    t = L"\sum^N_{n=1} \frac{x}{n}"

    for halign in [:left,:right,:center], valign in [:baseline, :bottom, :top, :middle]
        text(t, halign=halign, valign=valign)

        @test round.(latextextsize(t);digits=2) == (36.99, 46.69)

        if halign === :left
            @test round(latexboundingbox(t, halign=halign, valign=valign)[1][1];digits=2) == 0.0
            @test round(latexboundingbox(t, halign=halign, valign=valign)[2][1];digits=2) == 36.99
        elseif halign === :right
            @test round(latexboundingbox(t, halign=halign, valign=valign)[1][1];digits=2) == -36.99
            @test round(latexboundingbox(t, halign=halign, valign=valign)[2][1];digits=2) == 0.0
        elseif halign === :center
            @test round(latexboundingbox(t, halign=halign, valign=valign)[1][1];digits=2) == -36.98/2
            @test round(latexboundingbox(t, halign=halign, valign=valign)[2][1];digits=2) == 36.98/2
        end
        
        if valign === :baseline || valign === :bottom 
            @test round(latexboundingbox(t, halign=halign, valign=valign)[1][2];digits=2) == 18.72
            @test round(latexboundingbox(t, halign=halign, valign=valign)[2][2];digits=2) == -27.97
        elseif valign === :top
            @test round(latexboundingbox(t, halign=halign, valign=valign)[1][2];digits=2) == 46.69
            @test round(latexboundingbox(t, halign=halign, valign=valign)[2][2];digits=2) == 0.0
        elseif valign === :middle
            @test round(latexboundingbox(t, halign=halign, valign=valign)[1][2];digits=2) == 46.70/2
            @test round(latexboundingbox(t, halign=halign, valign=valign)[2][2];digits=2) == -46.70/2
        end
    end

    @test round(rawlatexboundingbox(t)[1][1]; digits=2) == 0.0
    @test round(rawlatexboundingbox(t)[1][2]; digits=2) == round(18.72/get_fontsize(); digits=2)
    @test round(rawlatexboundingbox(t)[2][1]; digits=2) == round(36.90/get_fontsize(); digits=2)
    @test round(rawlatexboundingbox(t)[2][2]; digits=2) == round(-27.90/get_fontsize(); digits=2)

    finish()
end
