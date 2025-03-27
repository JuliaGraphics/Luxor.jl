using Luxor
using Typstry

function Luxor.text(ts::TypstString, pos::Point;
        preamble=Typstry.typst"")
    io = IOBuffer()
    show(IOContext(io, :preamble => preamble), "image/svg+xml", ts)
    svgimage = readsvg(String(take!(io)))
    placeimage(svgimage, pos)
end
