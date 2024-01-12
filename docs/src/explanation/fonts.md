```@meta
DocTestSetup = quote
    using Luxor, Colors
    end
```

# Fonts available on Linux CI systems

```@raw html
<details closed><summary>Code for this figure</summary>
```

This code generates the figure below.

```@example fonts
using Luxor

fonts = ["Lato-Hairline",
    "Lato-Hairline",
    "Lato-HairlineItalic",
    "Lato-Thin",
    "Lato-ThinItalic",
    "Lato-Light",
    "Lato-LightItalic",
    "Lato-Semibold",
    "Lato-SemiboldItalic",
    "Lato-Bold",
    "Lato-BoldItalic",
    "Lato-Italic",
    "Lato-Regular",
    "Lato-RegularItalic",
    "Lato-Medium",
    "Lato-MediumItalic",
    "Lato-Heavy",
    "Lato-HeavyItalic",
    "Lato-Black",
    "Lato-BlackItalic",
    #
    "LiberationMono-Regular",
    "LiberationMono-Bold",
    "LiberationMono-BoldItalic",
    "LiberationMono-Italic",
    #
    "LiberationSans-Regular",
    "LiberationSans-Bold",
    "LiberationSans-BoldItalic",
    "LiberationSans-Italic",
    #
    "LiberationSansNarrow-Regular",
    "LiberationSansNarrow-Bold",
    "LiberationSansNarrow-BoldItalic",
    "LiberationSansNarrow-Italic",
    #
    "LiberationSerif-Regular",
    "LiberationSerif-Italic",
    "LiberationSerif-Bold",
    "LiberationSerif-BoldItalic",
    # "DejaVuMathTeXGyre",
    "DejaVuSans",
    "DejaVuSans-ExtraLight",
    "DejaVuSans-Bold",
    "DejaVuSans-BoldOblique",
    "DejaVuSans-Oblique",
    #
    "DejaVuSansCondensed",
    "DejaVuSansCondensed-Oblique",
    "DejaVuSansCondensed-Bold",
    "DejaVuSansCondensed-BoldOblique",
    #
    "DejaVuSansMono",
    "DejaVuSansMono-Bold",
    "DejaVuSansMono-BoldOblique",
    "DejaVuSansMono-Oblique",
    #
    "DejaVuSerif",
    "DejaVuSerif-Italic",
    "DejaVuSerif-Bold",
    "DejaVuSerif-BoldItalic",
    "DejaVuSerifCondensed",
    "DejaVuSerifCondensed-Italic",
    "DejaVuSerifCondensed-Bold",
    "DejaVuSerifCondensed-BoldItalic",
]
function drawfonts()
    d = @drawsvg begin
        background("black")
        fontsize(20)
        sethue("white")
        table = Table(length(fonts), 2, 50, 40)
        n = 1
        for font in fonts
            text(font, table[n], halign=:right)
            @layer begin
                fontface(font)
                text(font, table[n+1])
            end 
            n += 2
        end
    end 900 2400
    return d
end
```

```@raw html
</details>
```

```@example fonts
drawfonts()
```
