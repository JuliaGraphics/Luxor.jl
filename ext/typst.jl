using Luxor
import Luxor: render_typst_document
using Typstry

"""
    text(ts::TypstString, pos::Point=O; 
        centered=false,
        place=true,
        preamble=Typstry.typst"")

Pass the text in `ts` (a TypstString) to the Typst compiler, which returns an SVG image object of type `Luxor.SVGimage`.

If `place` is true, place this image on the drawing at `pos`. Otherwise return the SVG image object. You can later place this image on the drawing using `placeimage()`.

Use keyword `centered=true` to place the center of the image, rather than the top left corner, at the specified position.

## Example

```julia
using Luxor
using Typstry

ts = typst\"\"\"\$a + b/c = sum_i x^i\$\"\"\";
ty_preamble = typst\"\"\"
#set page(fill: rgb("#eeffff"), height: 200pt, width: 300pt, margin: 0pt);
#set text(size: 40pt)
\"\"\"

@draw begin
    si = text(ts, Point(0, 0), preamble=ty_preamble)
end
```
"""
function Luxor.text(ts::TypstString, pos::Point;
        place=true,
        centered=false,
        preamble=Typstry.typst"")
    io = IOBuffer()
    show(IOContext(io, :preamble => preamble), "image/svg+xml", ts)
    svgimage = readsvg(String(take!(io)))
    if place == true
        xpos, ypos = pos
        if centered == true
            w, h = svgimage.width, svgimage.height
            xpos, ypos = xpos - (w / 2), ypos - (h / 2)
        end
        placeimage(svgimage, Point(xpos, ypos))
    else
        return svgimage
    end
end

"""
    render_typst_document(ts::TypstString)

Render the Typst string in `ts` to an array of SVG images, one 
for each page.

## Example

This example takes a Typst string which defines
a three page document. The `pages` array contains
the pages as SVG images. These are placed using
Luxor tiles.

```julia
using Luxor
using Typstry

ts = typst\"\"\"
#set page(fill: white, height:100pt, width: 100pt)
#set text(size: 8pt, fill: black)
#lorem(10)
#pagebreak()
#lorem(10)
#pagebreak()
#lorem(10)
\"\"\"

@draw begin
    pages = render_typst_document(ts)
    tiles = Tiler(500, 200, 1, length(pages))
    for p in eachindex(pages)
        cpos = first(tiles[p])
        w, h = pages[p].width, pages[p].height
        box(cpos, w, h, :stroke)
        placeimage(pages[p], cpos, centered=true)
    end
end
```
"""
function render_typst_document(ts::TypstString)
    path = mktempdir(tempdir(), cleanup = false)
    cd(path)
    write("document{0p}.typ", ts)
    typst("compile document{0p}.typ --format svg")
    result = Luxor.SVGimage[]
    for f in filter(fn -> endswith(fn, "svg"), readdir(path, join = true))
        push!(result, readsvg(f))
    end
    return result
end