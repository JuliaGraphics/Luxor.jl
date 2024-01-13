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
        fontsize(20)
        sethue("white")
        table = Table(length(fonts), 2, 50, 30)
        n = 1
        for font in fonts
            text(font, table[n], halign=:right)
            @layer begin
                fontface(font)
                text(font, table[n+1])
            end
            n += 2
        end
    end 900 3500
    return d
end
```

```@raw html
</details>
```

```@example fonts
drawfonts()
```
