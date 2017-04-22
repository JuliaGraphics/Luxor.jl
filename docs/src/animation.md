# Animation helper functions

Luxor provides some functions to help you create animations—at least, it provides some assistance in creating lots of individual frames that can later be stitched together to form a moving animation, such as a GIF or MP4.

There are four steps to creating an animation.

1 Use `Movie` to create a Movie object which determines the title and dimensions.

2 Define functions that draw the graphics.

3 Define Scenes that display the functions for specific frames.

4 Call the `animate(movie::Movie, scenes)` function, passing in the scenes. This creates all the frames and saves them in a temporary directory. Optionally, you can ask for `ffmpeg` to make an animated GIF.

## Example

```julia
using Luxor

demo = Movie(400, 400, "test", 0:359)

function backdrop(movie, framenumber)
    background("black")
end

function frame(movie, framenumber)
    sethue(Colors.HSV(framenumber, 1, 1))
    circle(polar(100, -pi/2 - (framenumber/360) * 2pi), 80, :fill)
    text(string("frame $framenumber of $(length(movie.movieframerange))"), Point(O.x, O.y-190))
end

animate(demo, [Scene(demo, 0:359,  backdrop), Scene(demo, 0:359,  frame)], creategif=true)
```

![animation example](assets/figures/animation.gif)

```@docs
Movie
Scene
animate
```

## Making the animation

Building an animation such as a GIF or MOV file is best done outside Julia, using something like `ffmpeg`, with its thousands of options, which include frame-rate adjustment and color palette tweaking. The `animate` function has a go at running it on Unix platforms, and assumes that `ffmpeg` is installed. Inside `animate()`, the first pass creates a color palette, the second builds the file:

```julia
run(`ffmpeg -f image2 -i $(tempdirectory)/%10d.png -vf palettegen -y $(seq.stitle)-palette.png`)

run(`ffmpeg -framerate 30 -f image2 -i $(tempdirectory)/%10d.png -i $(seq.stitle)-palette.png -lavfi paletteuse -y /tmp/$(seq.stitle).gif`)
```
## Using scenes

Sometimes you want to construct an animation that has different components, layers, or scenes. To do this, specify scenes that are drawn only for specific frames.

As an example, consider a simple example showing the sun during a 24 hour day.

    sun24demo = Movie(400, 400, "sun24", 0:23)

The `backgroundfunction` draws a background that's used for all frames:

    function backgroundfunction(movie::Movie, framenumber)
        background("black")
    end

A `nightskyfunction` draws the night sky:

    function nightskyfunction(movie::Movie, framenumber)
        sethue("midnightblue")
        box(O, 400, 400, :fill)
    end

A `dayskyfunction` draws the daytime sky:

    function dayskyfunction(movie::Movie, framenumber)
        sethue("skyblue")
        box(O, 400, 400, :fill)
    end

The `sunfunction` draws a sun at 24 positions during the day:

    function sunfunction(movie::Movie, framenumber)
        i = rescale(framenumber, 0, 23, 2pi, 0)
        gsave()
        sethue("yellow")
        circle(polar(150, i), 20, :fill)
        grestore()
    end

Finally a `groundfunction` draws the ground:

    function groundfunction(movie::Movie, framenumber)
        gsave()
        sethue("brown")
        box(Point(O.x, O.y + 100), 400, 200, :fill)
        grestore()
        sethue("white")
    end

Now define a group of Scenes. These specify which functions are to be used to create graphics, and for which frames:

    backdrop  = Scene(sun24demo, 0:23,  backgroundfunction)
    nightsky  = Scene(sun24demo, 0:6,   nightskyfunction)
    nightsky1 = Scene(sun24demo, 17:23, nightskyfunction)
    daysky    = Scene(sun24demo, 5:19,  dayskyfunction)
    sun       = Scene(sun24demo, 6:18,  sunfunction)
    ground    = Scene(sun24demo, 0:23,  groundfunction)

Finally, the `animate` function calls the functions for each frame:

    animate(sun24demo, [backdrop, nightsky, nightsky1, daysky, sun, ground],
        framerate=5,
        creategif=true)

![sun24 animation](assets/figures/sun24.gif)

Notice that for some frames, such as frame 0, 1, or 23, three of the functions are called: for others, such as 7 and 8, five functions are called.
