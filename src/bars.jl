"""
    bars(values::Array;
            yscale = 100,
            xwidth = 10,
            labels = true,
            barfunction = f,
            labelfunction = f,
        )

Draw some bars where each bar is the height of a value in the array.

To control the drawing of the text and bars, define functions that process the end points:

`mybarfunction(bottom::Point, top::Point, value; extremes=[a, b])`

`mylabelfunction(bottom::Point, top::Point, value; extremes=[a, b])`

and pass them like this:

```julia
bars(v, yscale=10, xwidth=10, barfunction=mybarfunction)
bars(v, xwidth=15, yscale=10, labelfunction=mylabelfunction)
```

To suppress the text labels, use optional keyword `labels=false`.
"""

function bars(values::Array;
    barfunction   = (bottom::Point, top::Point, value;
        extremes=extrema(values)) -> line(bottom, top, :stroke),
    labels::Bool=true,
    labelfunction = (bottom::Point, top::Point, value;
        extremes=extrema(values)) -> begin
            t = string(round(value, 1))
            textoffset = textextents(t)[4]
            if top.y < 0
                tp = Point(top.x, min(top.y, bottom.y) - textoffset)
            else
                tp = Point(top.x, max(top.y, bottom.y) + textoffset)
            end
            text(t, tp, halign=:center, valign=:middle)
            end,
    yscale = 100,
    xwidth = 10)
    x = O.x
    mn, mx = extrema(values)
    isapprox(mn, mx, atol=0.00001) && (mx = mn + 100) # better show something than nothing
    for v in values
        # remember y increases downwards by default
        bottom = Point(x, -rescale(min(v, 0) + mn, mn, mx, 0, yscale))
        top    = Point(x, -rescale(max(v, 0) + mn, mn, mx, 0, yscale))
        barfunction(bottom, top, v, extremes=extrema(values))
        labels && labelfunction(bottom, top, v, extremes=extrema(values))
        x += xwidth
    end
end
