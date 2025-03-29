using Luxor
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
