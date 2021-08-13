# Luxor and Cairo

The aim of Luxor is to provide an easy to use
"scripting-like" interface to Cairo.jl.

As an example of how this looks, compare the two scripts
below. On the left below is one of the original examples in
the Cairo.jl repository. On the right is a fairly literal
conversion into a Luxor script.

![luxor and cairo](../assets/figures/luxor-cairo.png)

which produce this image:

![sample arc](../assets/figures/sample_arc.png)

For convenience, Luxor introduces `Point`s and dispenses
with `Context`s.  Both Cairo and Luxor use the same
coordinate system, although the Luxor macros position the origin
at the center of the canvas. So although Cairo has to calculate
the midpoint of the drawing in line 13, Luxor has to
calculate the position of the top left corner in line 28.

A more idiomatic version of the code would be:

```
using Luxor

@png begin
    background(0.8, 0.8, 0.8)

    setline(10)
    setcolor("black")
    arc(centerpt, 100, π/4, π, :stroke)

    setcolor(1, 0.2, 0.2, 0.6)
    setline(6.0)

    circle(centerpt, 10.0, :fill)

    poly([polar(100, π), O, polar(100, π/4)], :stroke)

    setcolor("black")
    text(Libc.strftime(time()), boxtopleft(BoundingBox()) + (0,12))

end 256 256 "/tmp/sample_arc_luxor_2.png"
```

If you want to know more about how drawing in Cairo and
Luxor works, refer to the [Cairo
documentation](https://cairographics.org/documentation/).

!!! note

    Luxor.jl doesn't implement every function provided in
    Cairo.jl, and Cairo.jl doesn't implement every function
    provided by the Cairo API. If you'd like to see more
    features, consider making a Pull Request.
