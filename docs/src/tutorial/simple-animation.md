# Make simple animations

Luxor.jl can help you build simple animations, by assembling a series of PNG images. To make richer animations, you should use [Javis.jl](https://github.com/Wikunia/Javis.jl).

## A Julia spinner

The first thing to do is to create a `Movie` object. This acts as a useful handle that we can pass from function to function.

```julia
mymovie = Movie(400, 400, "mymovie")
```

The resulting animation will be 400×400 pixels.

The `frame()` function (it doesn't have to be called that, but it's a good name), should accept two arguments, a Scene object, and a framenumber (integer).

```julia
function frame(scene::Scene, framenumber::Int64)
    background("white")
    norm_framenumber = rescale(framenumber,
        scene.framerange.start,
        scene.framerange.stop,
        0, 1)
    rotate(norm_framenumber * 2π)
    juliacircles(100)
end
```

This function is responsible for drawing all the graphics for a single frame. The Scene object has details about the number of frames for this scene, and those are used to rescale (normalize) the framenumber to be a value between 0 and 1.

```julia
julia> rescale(1, 1, 60)
0.0

julia> rescale(60, 1, 60)
1.0
```

So for a scene with 60 frames, framenumber 30 will make a value of about 0.5.

The [`animate`](@ref) function takes an array of scenes and builds a GIF.

```julia
animate(mymovie,
        [
            Scene(mymovie, frame, 1:60)
        ],
    creategif=true,
    pathname="juliaspinner.gif")
```

![julia spinner](../assets/figures/juliaspinner.gif)

## Combining scenes

In the next example, we'll construct an animation that organizes frames into different scenes.
Consider this animation showing the sun for each hour of a 24 hour day.

![sun24 animation](../assets/figures/sun24.gif)

Start by creating a movie. This acts as a useful handle that we can pass from function to function. The arguments are width, height, name, and a range that determines how many frames are used.

```
sun24demo = Movie(400, 400, "sun24", 0:23)
```

We'll define a `backgroundfunction` function that draws a background used for all frames (animated GIFs like constant backgrounds):

```
function backgroundfunction(scene::Scene, framenumber)
    background("black")
end
```

A `nightskyfunction` draws the night sky:

```
function nightskyfunction(scene::Scene, framenumber)
    sethue("midnightblue")
    box(O, 400, 400, :fill)
end
```

A `dayskyfunction` draws the daytime sky:

```
function dayskyfunction(scene::Scene, framenumber)
    sethue("skyblue")
    box(O, 400, 400, :fill)
end
```

The `sunfunction` draws a sun at 24 positions during the day. The framenumber will be a number between 0 and 23, which can be easily converted to lie between 0 and 2π.

```
function sunfunction(scene::Scene, framenumber)
    i = rescale(framenumber, 0, 23, 2pi, 0)
    gsave()
        sethue("yellow")
        circle(polar(150, i), 20, :fill)
    grestore()
end
```

Here's a `groundfunction` that draws the ground:

```
function groundfunction(scene::Scene, framenumber)
    gsave()
    sethue("brown")
    box(Point(O.x, O.y + 100), 400, 200, :fill)
    grestore()
    sethue("white")
end
```

To combine these together, define a group of Scenes that make up the movie. The scenes specify which functions are to be used, and for which frames:

```
backdrop  = Scene(sun24demo, backgroundfunction, 0:23)   # every frame
nightsky  = Scene(sun24demo, nightskyfunction, 0:6)      # midnight to 06:00
nightsky1 = Scene(sun24demo, nightskyfunction, 17:23)    # 17:00 to 23:00
daysky    = Scene(sun24demo, dayskyfunction, 5:19)       # 05:00 to 19:00
sun       = Scene(sun24demo, sunfunction, 6:18)          # 06:00 to 18:00
ground    = Scene(sun24demo, groundfunction, 0:23)       # every frame
```

Finally, the `animate` function scans the scenes in the scenelist for a movie, and calls the functions for each frame to build the animation:

```
animate(sun24demo, [
   backdrop, nightsky, nightsky1, daysky, sun, ground
   ],
   framerate=5,
   creategif=true)
```

![sun24 animation](../assets/figures/sun24.gif)

Notice that for some frames, such as frame 0, 1, or 23, three of the functions are called: for others, such as 7 and 8, four or more functions are called.

## An alternative

An alternative approach is to use the incoming framenumber as the master parameter that determines the position and appearance of all the graphics.

```
function frame(scene, framenumber)
    background("black")
    n   = rescale(framenumber, scene.framerange.start, scene.framerange.stop, 0, 1)
    n2π = rescale(n, 0, 1, 0, 2π)
    sethue(n, 0.5, 0.5)
    box(BoundingBox(), :fill)
    if 0.25 < n < 0.75
        sethue("yellow")
        circle(polar(150, n2π + π/2), 20, :fill)
    end
    if n < 0.25 || n > 0.75
        sethue("white")
        circle(polar(150, n2π + π/2), 20, :fill)
    end
end
```
