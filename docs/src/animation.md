# Animation helper functions

Luxor provides some functions to help you create animations—at least, it provides some assistance in creating lots of individual frames that can later be stitched together to form a moving animation, such as a GIF or MP4.

There are four steps to creating an animation.

1 Use `Movie` to create a Movie object which determines the title and dimensions.

2 Define some functions that draw the graphics for specific frames.

3 Define one or more Scenes that call these functions for specific frames.

4 Call the `animate(movie::Movie, scenes)` function, passing in the scenes. This creates all the frames and saves them in a temporary directory. Optionally, you can ask for `ffmpeg` (if it's installed) to make an animated GIF for you.

## Example

```julia
using Luxor

demo = Movie(400, 400, "test")

function backdrop(scene, framenumber)
    background("black")
end

function frame(scene, framenumber)
    sethue(Colors.HSV(framenumber, 1, 1))
    eased_n = scene.easingfunction(framenumber, 0, 1, scene.framerange.stop)
    circle(polar(100, -pi/2 - (eased_n * 2pi)), 80, :fill)
    text(string("frame $framenumber of $(scene.framerange.stop)"),
        Point(O.x, O.y-190),
        halign=:center)
end

animate(demo, [
    Scene(demo, backdrop, 0:359),
    Scene(demo, frame, 0:359, easingfunction=easeinoutcubic)
    ],
    creategif=true)
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

    function backgroundfunction(scene::Scene, framenumber)
        background("black")
    end

A `nightskyfunction` draws the night sky:

    function nightskyfunction(scene::Scene, framenumber)
        sethue("midnightblue")
        box(O, 400, 400, :fill)
    end

A `dayskyfunction` draws the daytime sky:

    function dayskyfunction(scene::Scene, framenumber)
        sethue("skyblue")
        box(O, 400, 400, :fill)
    end

The `sunfunction` draws a sun at 24 positions during the day:

    function sunfunction(scene::Scene, framenumber)
        i = rescale(framenumber, 0, 23, 2pi, 0)
        gsave()
        sethue("yellow")
        circle(polar(150, i), 20, :fill)
        grestore()
    end

Finally a `groundfunction` draws the ground:

    function groundfunction(scene::Scene, framenumber)
        gsave()
        sethue("brown")
        box(Point(O.x, O.y + 100), 400, 200, :fill)
        grestore()
        sethue("white")
    end

Now define a group of Scenes that make up the movie. The scenes specify which functions are to be used to create graphics, and for which frames:

    backdrop  = Scene(sun24demo, backgroundfunction, 0:23)
    nightsky  = Scene(sun24demo, nightskyfunction, 0:6)
    nightsky1 = Scene(sun24demo, nightskyfunction, 17:23)
    daysky    = Scene(sun24demo, dayskyfunction, 5:19)
    sun       = Scene(sun24demo, sunfunction, 6:18)
    ground    = Scene(sun24demo, groundfunction, 0:23)

Finally, the `animate` function scans the scenes in the scenelist for a movie, and calls the functions for each frame to build the animation:

    animate(sun24demo, [backdrop, nightsky, nightsky1, daysky, sun, ground],
        framerate=5,
        creategif=true)

![sun24 animation](assets/figures/sun24.gif)

Notice that for some frames, such as frame 0, 1, or 23, three of the functions are called: for others, such as 7 and 8, four or more functions are called. The order of scenes and the use of backgrounds can be important.

## Easing functions

Transitions for animations often use non-constant and non-linear motions, and these are usually provided by *easing* functions. Luxor defines some of the basic easing functions and they're listed in the (unexported) array `Luxor.easingfunctions`. Each scene can have one easing function.

Most easing functions have names constructed like this:

    ease[in|out|inout][expo|circ|quad|cubic|quart|quint]

One way to use an easing function in a frame-making function is like this:

     function moveobject(scene, framenumber)
        background("white")
        ...
        easedframenumber = scene.easingfunction(framenumber, 0, 1, scene.framerange.stop)
        ...

This takes the current frame number, compares it with the end frame number of the scene, then adjusts it.

In the next example, the purple dot has sinusoidal motion, the green has cubic, and the red has quintic. They all traverse the drawing in the same time, but have different accelerations and decelerations.

![animation easing example](assets/figures/animation-easing.gif)

```julia
fastandfurious = Movie(400, 100, "easingtests")
backdrop(scene, framenumber) =  background("black")
function frame1(scene, framenumber)
    sethue("purple")
    eased_n = scene.easingfunction(framenumber, 0, 1, scene.framerange.stop)
    circle(Point(-180 + (360 * eased_n), -20), 10, :fill)
end
function frame2(scene, framenumber)
    sethue("green")
    eased_n = scene.easingfunction(framenumber, 0, 1, scene.framerange.stop)
    circle(Point(-180 + (360 * eased_n), 0), 10, :fill)
end
function frame3(scene, framenumber)
    sethue("red")
    eased_n = scene.easingfunction(framenumber, 0, 1, scene.framerange.stop)
    circle(Point(-180 + (360 * eased_n), 20), 10, :fill)
end
animate(fastandfurious, [
    Scene(fastandfurious, backdrop, 0:200),
    Scene(fastandfurious, frame1,   0:200, easingfunction=easeinsine),
    Scene(fastandfurious, frame2,   0:200, easingfunction=easeinoutcubic),
    Scene(fastandfurious, frame3,   0:200, easingfunction=easeinoutquint)
    ],
    creategif=true)
```

A typical easing function is this one:

    function easeoutquad(t, b, c, d)
       t /= d
       return -c * t * (t - 2) + b
    end

Here:

- `t` is the current framenumber of the transition

- `b` is the beginning value of the property

- `c` is the change between the beginning and destination value of the property

- `d` is the total time of the transition
