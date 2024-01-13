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

fonts = ["LatoHairline",
    "LatoHairline",
    "LatoHairlineItalic",
    "LatoThin",
    "LatoThinItalic",
    "LatoLight",
    "LatoLightItalic",
    "LatoSemibold",
    "LatoSemiboldItalic",
    "LatoBold",
    "LatoBoldItalic",
    "LatoItalic",
    "LatoRegular",
    "LatoRegularItalic",
    "LatoMedium",
    "LatoMediumItalic",
    "LatoHeavy",
    "LatoHeavyItalic",
    "LatoBlack",
    "LatoBlackItalic",
    #
    "LiberationMonoRegular",
    "LiberationMonoBold",
    "LiberationMonoBoldItalic",
    "LiberationMonoItalic",
    #
    "LiberationSansRegular",
    "LiberationSansBold",
    "LiberationSansBoldItalic",
    "LiberationSansItalic",
    #
    "LiberationSansNarrowRegular",
    "LiberationSansNarrowBold",
    "LiberationSansNarrowBoldItalic",
    "LiberationSansNarrowItalic",
    #
    "LiberationSerifRegular",
    "LiberationSerifItalic",
    "LiberationSerifBold",
    "LiberationSerifBoldItalic",
    # "DejaVuMathTeXGyre",
    "DejaVuSans",
    "DejaVuSansExtraLight",
    "DejaVuSansBold",
    "DejaVuSansBoldOblique",
    "DejaVuSansOblique",
    #
    "DejaVuSansCondensed",
    "DejaVuSansCondensedOblique",
    "DejaVuSansCondensedBold",
    "DejaVuSansCondensedBoldOblique",
    #
    "DejaVuSansMono",
    "DejaVuSansMonoBold",
    "DejaVuSansMonoBoldOblique",
    "DejaVuSansMonoOblique",
    #
    "DejaVuSerif",
    "DejaVuSerifItalic",
    "DejaVuSerifBold",
    "DejaVuSerifBoldItalic",
    "DejaVuSerifCondensed",
    "DejaVuSerifCondensedItalic",
    "DejaVuSerifCondensedBold",
    "DejaVuSerifCondensedBoldItalic",
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
