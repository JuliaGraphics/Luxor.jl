"""
    barchart(values;
            boundingbox = BoundingBox(O + (-250, -120), O + (250, 120)),
            bargap=10,
            margin = 5,
            border=false,
            labels=false,
            labelfunction = (values, i, lowpos, highpos, barwidth, scaledvalue) -> begin
                    label(string(values[i]), :n, highpos, offset=10)
              end,
            barfunction =  (values, i, lowpos, highpos, barwidth, scaledvalue) -> begin
                @layer begin
                    setline(barwidth)
                    line(lowpos, highpos, :stroke)
                end
              end)

Draw a barchart where each bar is the height of a value in the `values` array. The bars
will be scaled to fit in a bounding box.

Text labels are drawn if the keyword `labels=true`.

# Extended help

The function returns a vector of points; each is the bottom center of a bar.

Draw a Fibonacci sequence as a barchart:

```julia
fib(n) = n > 2 ? fib(n - 1) + fib(n - 2) : 1
fibs = fib.(1:15)
@draw begin
    fontsize(12)
    barchart(fibs, labels=true)
end
```
To control the drawing of the text and bars, define functions that process the
end points:

`mybarfunction(values, i, lowpos, highpos, barwidth, scaledvalue)`

`mylabelfunction(values, i, lowpos, highpos, barwidth, scaledvalue)`

and pass them like this:

```julia
barchart(vals, barfunction=mybarfunction)
barchart(vals, labelfunction=mylabelfunction)
```

```julia
function myprologfunction(values, basepoint, minbarrange, maxbarrange, barchartheight)
    @layer begin
        setline(0.2)
        for i in 0:10:maximum(values)
            rule(boxbottomcenter(basepoint) + (0, -(rescale(i, minbarrange, maxbarrange) * barchartheight)))
        end
    end
end
```
"""
function barchart(values;
    boundingbox = BoundingBox(O + (-250, -120), O + (250, 120)),
    bargap=10,
    margin = 5,
    border=false,
    labels=false,
    labelfunction = (values, i, lowpos, highpos, barwidth, scaledvalue) -> begin
        label(string(values[i]), :n, highpos, offset=10)
    end,
    barfunction =  (values, i, lowpos, highpos, barwidth, scaledvalue) -> begin
        @layer begin
            setline(barwidth)
            line(lowpos, highpos, :stroke)
        end
    end,
    prologfunction = (values, basepoint, minbarrange, maxbarrange, barchartheight) -> ()
    )
    minvalue, maxvalue = extrema(values)
    barchartwidth  = boxwidth(boundingbox)  - 2bargap - 2margin
    barchartheight = boxheight(boundingbox) - 2margin
    barwidth = (barchartwidth - 2bargap)/length(values)
    if barwidth < 0.1
        throw(error("barchart() - bars are too small (< 0.1) at $(barwidth)"))
    end
    # if all bars are equal height, this will force a range
    minbarrange = minvalue - abs(minvalue)
    maxbarrange = maxvalue + abs(maxvalue)
    basepoint = boundingbox - (0, margin)
    hpositions = between.(
        Ref(boxbottomleft(basepoint)),
        Ref(boxbottomright(basepoint)),
        # skip first and last, then take every other one, which is at halfway
        range(0.0, stop=1.0, length=2length(values) + 1))[2:2:end-1]
    @layer begin
        if border
            box(boundingbox, :stroke)
        end
        prologfunction(values, basepoint, minbarrange, maxbarrange, barchartheight)
        for i in 1:length(values)
            scaledvalue = rescale(values[i], minbarrange, maxbarrange) * barchartheight
            lowposition = hpositions[i]
            highposition = lowposition - (0, scaledvalue) # -y coord
            barfunction(values, i, lowposition, highposition, barwidth, scaledvalue)
            labels && labelfunction(values, i, lowposition, highposition, barwidth, scaledvalue)
        end
    end
    return (positions = hpositions)
end
