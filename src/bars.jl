"""
    bars(values::AbstractArray;
            yheight = 200,
            xwidth = 25,
            labels = true,
            barfunction = f,
            labelfunction = f,
        )

Draw some bars where each bar is the height of a value in the array. The bars will fit in
a box `yheight` high (even if there are negative values).

To control the drawing of the text and bars, define functions that process the
end points:

`mybarfunction(bottom::Point, top::Point, value; extremes=[a, b], barnumber=0, bartotal=0)`

`mylabelfunction(bottom::Point, top::Point, value; extremes=[a, b], barnumber=0, bartotal=0)`

and pass them like this:

```julia
bars(v, yheight=10, xwidth=10, barfunction=mybarfunction)
bars(v, xwidth=15, yheight=10, labelfunction=mylabelfunction)
```

To suppress the text labels, use optional keyword `labels=false`.
"""
function bars(values::AbstractArray;
    yheight = 200,
    xwidth = 25,
    barfunction   = (bottom::Point, top::Point, value;
        extremes=extrema(values), barnumber=0, bartotal=0) -> begin
                setline(xwidth)
                line(bottom, top, :stroke)
            end,
    labels::Bool=true,
    labelfunction = (bottom::Point, top::Point, value;
        extremes=extrema(values), barnumber=0, bartotal=0) -> begin
            t = string(round(value, digits=2))
            textoffset = textextents(t)[4]
            fontsize(10)
            if top.y < 0
                tp = Point(top.x, min(top.y, bottom.y) - textoffset)
            else
                tp = Point(top.x, max(top.y, bottom.y) + textoffset)
            end
            text(t, tp, halign=:center, valign=:middle)
        end)
    
    x = O.x
    mn, mx = extrema(values)
    isapprox(mn, mx, atol=0.00001) && (mx = mn + 100) # better show something than nothing
    for (n, v) in enumerate(values)
        # remember y increases downwards by default
        bottom = Point(x, -rescale(min(v, 0), min(0, mn), mx, 0, yheight))
        top    = Point(x, -rescale(max(v, 0), min(0, mn), mx, 0, yheight))
        barfunction(bottom, top, v, extremes=extrema(values), barnumber=n, bartotal=length(values))
        labels && labelfunction(bottom, top, v, extremes=extrema(values), barnumber=n, bartotal=length(values))
        x += xwidth
    end
end
