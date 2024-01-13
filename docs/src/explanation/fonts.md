```@meta
DocTestSetup = quote
    using Luxor, Colors
    end
```

# Fonts available on Linux CI systems

When this docmnent is built on Github CI, the following fonts are available.

```@raw html
<details closed><summary>Code for this figure</summary>
```

This code generates the figure below.

```@example fonts
using Luxor

fonts = [
    "DejaVuMathTeXGyre-Regular",
    "DejaVuMathTeXGyre",
    "DejaVuSans-Bold",
    "DejaVuSans-BoldOblique",
    "DejaVuSans-ExtraLight",
    "DejaVuSans-Oblique",
    "DejaVuSans",
    "DejaVuSansBold",
    "DejaVuSansBoldOblique",
    "DejaVuSansCondensed-Bold",
    "DejaVuSansCondensed-BoldOblique",
    "DejaVuSansCondensed-Oblique",
    "DejaVuSansCondensed",
    "DejaVuSansCondensedBold",
    "DejaVuSansCondensedBoldOblique",
    "DejaVuSansCondensedOblique",
    "DejaVuSansExtraLight",
    "DejaVuSansMono-Bold",
    "DejaVuSansMono-BoldOblique",
    "DejaVuSansMono-Oblique",
    "DejaVuSansMono",
    "DejaVuSansMonoBold",
    "DejaVuSansMonoBoldOblique",
    "DejaVuSansMonoOblique",
    "DejaVuSansOblique",
    "DejaVuSerif-Bold",
    "DejaVuSerif-BoldItalic",
    "DejaVuSerif-Italic",
    "DejaVuSerif",
    "DejaVuSerifBold",
    "DejaVuSerifBoldItalic",
    "DejaVuSerifCondensed-Bold",
    "DejaVuSerifCondensed-BoldItalic",
    "DejaVuSerifCondensed-Italic",
    "DejaVuSerifCondensed",
    "DejaVuSerifCondensedBold",
    "DejaVuSerifCondensedBoldItalic",
    "DejaVuSerifCondensedItalic",
    "DejaVuSerifItalic",
    "Lato-Black",
    "Lato-BlackItalic",
    "Lato-Bold",
    "Lato-BoldItalic",
    "Lato-Hairline",
    "Lato-HairlineItalic",
    "Lato-Heavy",
    "Lato-HeavyItalic",
    "Lato-Italic",
    "Lato-Light",
    "Lato-LightItalic",
    "Lato-Medium",
    "Lato-MediumItalic",
    "Lato-Regular",
    "Lato-Semibold",
    "Lato-SemiboldItalic",
    "Lato-Thin",
    "Lato-ThinItalic",
    "LatoBlack",
    "LatoBlackItalic",
    "LatoBold",
    "LatoBoldItalic",
    "LatoHairline",
    "LatoHairlineItalic",
    "LatoHeavy",
    "LatoHeavyItalic",
    "LatoItalic",
    "LatoLight",
    "LatoLightItalic",
    "LatoMedium",
    "LatoMediumItalic",
    "LatoRegular",
    "LatoRegularItalic",
    "LatoSemibold",
    "LatoSemiboldItalic",
    "LatoThin",
    "LatoThinItalic",
    "LiberationMono-Bold",
    "LiberationMono-BoldItalic",
    "LiberationMono-Italic",
    "LiberationMono",
    "LiberationMonoBold",
    "LiberationMonoBoldItalic",
    "LiberationMonoItalic",
    "LiberationMonoRegular",
    "LiberationSans-Bold",
    "LiberationSans-BoldItalic",
    "LiberationSans-Italic",
    "LiberationSans",
    "LiberationSansBold",
    "LiberationSansBoldItalic",
    "LiberationSansItalic",
    "LiberationSansNarrow-Bold",
    "LiberationSansNarrow-BoldItalic",
    "LiberationSansNarrow-Italic",
    "LiberationSansNarrow",
    "LiberationSansNarrowBold",
    "LiberationSansNarrowBoldItalic",
    "LiberationSansNarrowItalic",
    "LiberationSansNarrowRegular",
    "LiberationSansRegular",
    "LiberationSerif-Bold",
    "LiberationSerif-BoldItalic",
    "LiberationSerif-Italic",
    "LiberationSerif",
    "LiberationSerifBold",
    "LiberationSerifBoldItalic",
    "LiberationSerifItalic",
    "LiberationSerifRegular",
]
function drawfonts()
    d = @drawsvg begin
        background("black")
        @layer begin
            translate(-150, 0)
            sethue("white")
            tableheader = Table([5], [400, 400, 400], boxtopcenter() + (0, 50))
            fontsize(30)
            text("fontname", tableheader[1])
            text("Toy API", tableheader[2])
            text("Pro APi", tableheader[3])
            table = Table(fill(30, length(fonts)), [400, 400, 400])
            fsize = 20
            fontsize(fsize)
            n = 1
            for font in fonts
                text(font, table[n], halign=:left)
                @layer begin
                    fontface(font)
                    text(font, table[n+1])
                end
                @layer begin
                    fface = replace(font, "Serif" => " Serif", 
                        "Bold" => " Bold",
                        "Semibold" => " Semibold",
                        "Black" => " Black",
                        "Heavy" => " Heavy",
                        "Medium" => " Medium",
                        "Light" => " Light",
                        "Thin" => " Thin",
                        "Hairline" => " Hairline",
                        "Narrow" => " Narrow",
                        "Regular" => " Regular",
                        "Sans" => " Sans",
                        "Mono" => " Mono",
                        "Italic" => " Italic",
                        "Oblique" => " Oblique",
                        "Condensed" => " Condensed",
                        "Extra" => " Extra",
                        "-" => " ",
                        )
                    setfont(fface, fsize)
                    settext(fface, table[n+2])
                end
                @layer begin
                    setopacity(0.5)
                    line(table[n] + (0, 8), table[n+2] + (table.colwidths[3], 8), :stroke)
                end
                n += 3
            end
        end
        sethue("white")
        fontsize(40)
        text("--------:--------", boxbottomcenter() + (0, -30), halign=:center)
    end 1200 3400
    return d
end
```

```@raw html
</details>
```

```@example fonts
drawfonts()
```
