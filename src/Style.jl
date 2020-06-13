mutable struct Style
    color::Colorant
    linewidth::Float64
    fontface::String
    fontsize::Float64
    linecap::Symbol
    linejoin::Symbol
    dashpattern::Array
    function Style(color, linewidth, fontface, fontsize, linecap, linejoin, dashpattern)
        new(color, linewidth, fontface, fontsize, linecap, linejoin, dashpattern)
    end
end

# blank
Style() = Style(colorant"black", 1.0, "JuliaMono-Regular", 20,  :butt, :miter, [5, 0])

# color
Style(col::Colorant) = Style(col,  1.0, "JuliaMono-Regular", 20,  :butt, :miter, [5, 0])

# linewidth
Style(lw::Float64) = Style(colorant"black",  lw, "JuliaMono-Regular", 20,  :butt, :miter, [5, 0])

# color linewidth
Style(col::Colorant, lw::Float64) = Style(col, lw, "JuliaMono-Regular", 20,  :butt, :miter, [5, 0])

# font fontsize
Style(ff::String, fs) = Style(colorant"black",  1.0, ff, fs, :butt, :miter, [5, 0])

# color font fontsize
Style(col::Colorant, ff::String, fs) = Style(col, 1.0, ff, fs, :butt, :miter, [5, 0])

function applystyle(style::Style)
    setcolor(style.color)
    setline(style.linewidth)
    fontface(style.fontface)
    fontsize(style.fontsize)
    setlinecap(style.linecap)
    setlinejoin(style.linejoin)
    setdash(style.dashpattern)
end
