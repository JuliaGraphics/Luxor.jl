using Luxor
using Test
using Typstry

function typst_test_1(fname)    
    ty_preamble = typst"""
    #set page(fill: rgb("#aaffdd"), height: 250pt, width: 400pt, margin: 20pt);
    #set text(fill: black, size: 30pt)
    """

    ts = typst""" $a + b/c = sum_i x^i $"""

    Drawing(800, 800, fname)
    origin()
    text(ts, O, preamble = ty_preamble, centered = true)
    return @test finish() == true
end

function typst_test_2(fname)
    ts = typst"""
    #set text(size: 12pt, fill: black)
    #set page(numbering: "1", 
        fill: none, 
        height: 40pt, width: 40pt)
    #lorem(200)
    #rect(width: 1em, height: 1em, fill: red)
    """

    Drawing(800, 800, fname)
    origin()
    pages = render_typst_document(ts)
    centers = first.(Tiler(600, 600, 4, 4))
    for n in eachindex(pages)
        n > length(centers) && break
        @layer begin
            setopacity(0.8)
            randomhue()
            box(centers[n], 100, 100, :fill)
        end
        @layer begin
            placeimage(pages[n], centers[n], centered = true)
        end
    end
    return @test finish() == true
end

fname = "typst_test_1.png"
typst_test_1(fname)
fname = "typst_test_2.png"
println("...finished typst test: output in $(fname)")
typst_test_2(fname)
println("...finished typst test: output in $(fname)")
