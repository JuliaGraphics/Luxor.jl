"""
The `Movie` and `Scene` types and the `animate()` function are designed to help you
create the frames that can be used to make an animated GIF or movie.

1 Provide width, height, title, and optionally a frame range to the Movie constructor:

    demo = Movie(400, 400, "test", 1:500)

2 Define one or more scenes and scene-drawing functions.

3 Run the `animate()` function, calling those scenes.

Example

```
bang = Movie(400, 100, "bang")

backdrop(scene, framenumber) =  background("black")

function frame1(scene, framenumber)
    background("white")
    sethue("black")
    eased_n = scene.easingfunction(framenumber, 0, 1, scene.framerange.stop)
    circle(O, 40 * eased_n, :fill)
end

animate(bang, [
    Scene(bang, backdrop, 0:200),
    Scene(bang, frame1, 0:200, easingfunction=easeinsine)],
    creategif=true,
    pathname="/tmp/animationtest.gif")

```
"""
struct Movie
    width::Float64
    height::Float64
    movietitle::AbstractString
    movieframerange::AbstractRange
end

"""
    Movie(width, height, movietitle)

Define a movie, specifying the width, height, and a title. The title will be used to
make the output file name. The range defaults to `1:250`.
"""
Movie(width, height, movietitle::AbstractString) = Movie(width, height, movietitle, 1:250)

"""default linear transition - no easing, no acceleration"""
function lineartween(t, b, c, d)
   return c * t/d + b
end

"""
The Scene type defines a function to be used to render a range of frames in a movie.

- the `movie` created by Movie()
- the `framefunction` is a function taking two arguments: the scene and the framenumber.
- the `framerange` determines which frames are processed by the function. Defaults to the entire movie.
- the optional `easingfunction` can be accessed by the framefunction to vary the transition speed
- the optional `opts` which is a single argument of an abstract type which can be accessed within the framefunction
"""
mutable struct Scene
    movie::Movie
    framefunction::Function
    framerange::AbstractRange
    easingfunction::Function
    opts::Any
end

"""
    Scene(movie, function, range;
        easingfunction=easinoutquad,
        optarg=nothing)

Use the Scene() constructor function to create a scene. Supply a movie, a function
to generate the scene, and a range of frames. Optionally you can supply an
easing function, and other information, in `optarg`, which can be accessed as
`scene.opts`.

### Example

```
function initial(scene, framenumber)
    balls = scene.opts
    ...
end

animate(poolmovie, [
    Scene(poolmovie, initial, optarg=balls,   1:20),
    ...
    ])
```

To use an easing function inside the frame-generating function, you can create a normalized
value with, for example:

```
eased_n = scene.easingfunction(framenumber, 0, 1, scene.framerange.stop)
```

Or, if the scene doesn't start at frame 1, calculate normalized easing function like this:

```
eased_n = scene.easingfunction(framenumber - scene.framerange.start,
    0, 1, scene.framerange.stop - scene.framerange.start)
```
"""
Scene(movie::Movie, framefunction::Function;
    easingfunction=lineartween, optarg=nothing) =
    Scene(movie, framefunction, movie.movieframerange, easingfunction, optarg)
Scene(movie::Movie, framefunction::Function, framerange::AbstractRange;
    easingfunction=lineartween, optarg=nothing) =
    Scene(movie, framefunction, framerange, easingfunction, optarg)

"Wraps the location of an animated gif so that it can be displayed"
struct AnimatedGif
    filename::String
end

"""
    animate(movie::Movie, scenelist::Array{Scene, 1};
        creategif=false,
        framerate=30,
        pathname="",
        tempdirectory="",
        usenewffmpeg=true)

Create the movie defined in `movie` by rendering the frames define in the array of scenes
in `scenelist`.

If `creategif` is `true`, the function attempts to call the `ffmpeg` utility on
the resulting frames to build a GIF animation. This will be stored in `pathname`
(an existing file will be overwritten; use a ".gif" suffix), or in
`(movietitle).gif` in a temporary directory. `ffmpeg` should be installed and
available, of course, if this is to work.

In suitable environments, the resulting animation is displayed in the Plots window.

### Example

```
animate(bang, [
    Scene(bang, backdrop, 0:200),
    Scene(bang, frame1, 0:200, easingfunction=easeinsine)],
    creategif=true,
    pathname="/tmp/animationtest.gif")
```

The `usenewffmpeg` option, `true` by default, uses single-pass palette
generation and more complex filtering provided by recent versions of the
`ffmpeg` utility, mainly to cope with transparent backgrounds. If set to
`false`, the behavior is the same as in previous versions of Luxor.

If you prefer to use the FFMPEG package, use code such as this:

```julia
using FFMPEG

...

tempdirectory = "/tmp/temp/"

animate(movie, [
        Scene(movie, frame, 1:50)
    ], creategif=false, tempdirectory=tempdirectory)

FFMPEG.ffmpeg_exe(`-r 30 -f image2 -i \$(tempdirectory)/%10d.png -c:v libx264 -r 30 -pix_fmt yuv420p -y /tmp/animation.mp4`)

```
"""
function animate(movie::Movie, scenelist::Array{Scene, 1};
        creategif=false,
        framerate=30,
        pathname="",
        tempdirectory="",
        usenewffmpeg=true,
        debug=false)

    if isdir(pathname)
        suggestedpathname = joinpath(pathname, "myanimation.gif")
        @error("Parameter pathname=$pathname points to a directory. Please pass a filename like '$suggestedpathname' as pathname parameter!")
        return false
    end

    if tempdirectory == ""
        tempdirectory = mktempdir()
    else
        if !isdir(tempdirectory)
            @info "$(tempdirectory) does not exist, using an autogenerated one."
            tempdirectory = mktempdir()
        end
    end
    @info("Frames for animation \"$(movie.movietitle)\" are being stored in directory: \n\t $(tempdirectory)")
    filecounter = 1
    rangelist = 0:-1
    for scene in scenelist
        rangelist = vcat(rangelist, collect(scene.framerange))
    end
    rangelist = unique(rangelist) # remove shared frames
    if rangelist[end] < movie.movieframerange.stop
        @warn("Movie framerange is longer than scene frame range: \n\t $(movie.movieframerange) > $(rangelist[end])")
    end
    for currentframe in rangelist[1]:rangelist[end]
        Drawing(movie.width, movie.height, "$(tempdirectory)/$(lpad(filecounter, 10, "0")).png")
        origin()
        # this frame needs doing, see if each of the scenes defines it
        for scene in scenelist
            if currentframe in scene.framerange
                scene.framefunction(scene, currentframe)
            end
        end
        finish()
        filecounter += 1
    end
    @info("... $(filecounter-1) frames saved in directory:\n\t $(tempdirectory)")
    if creategif == false
        return true # we're done
    end
    if !usenewffmpeg
        create_gif_older_version(tempdirectory, movie.movietitle, framerate)
    else
        # the latest version of ffmpeg uses built-in palettes and allegedly does transparency using complex filters ¯\\\_(ツ)_/¯
        if debug
            @info "$(framerate)"
            @info "$(tempdirectory)"
            @info "$(tempdirectory)/$(movie.movietitle).gif"
            create_gif_newer_version(tempdirectory, movie.movietitle, framerate)
        else
            create_gif_newer_version_reduced_verbosity(tempdirectory, movie.movietitle, framerate)
        end
    end

    if ! isempty(pathname)
        mv("$(tempdirectory)/$(movie.movietitle).gif", pathname, force=true)
        @info("GIF is: $pathname")
        giffn  = pathname
    else
        @info("GIF is: $(tempdirectory)/$(movie.movietitle).gif")
        giffn  = tempdirectory * "/" * movie.movietitle * ".gif"
    end
    AnimatedGif(giffn)
end

"""
    animate(movie::Movie, scene::Scene; creategif=false, framerate=30)

Create the movie defined in `movie` by rendering the frames define in `scene`.
"""
animate(movie::Movie, scene::Scene; kwargs...) = animate(movie, [scene]; kwargs...)

# write out the HTML to view the gif
function Base.show(io::IO, ::MIME"text/html", agif::AnimatedGif)
    ext = last(splitext(agif.filename))
    if ext == ".gif"
        html = "<img src=\"data:image/gif;base64," * base64encode(read(agif.filename)) * "\" />"
    elseif ext in (".mov", ".mp4")
        mimetype = ext == ".mov" ? "video/quicktime" : "video/mp4"
        html = "<video controls><source src=\"data:$mimetype;base64," *
               base64encode(read(agif.filename)) *
               "\" type = \"$mimetype\"></video>"
    else
        error("Cannot show animation with extension $ext: $agif")
    end

    write(io, html)
    return nothing
end

# Only gifs can be shown via image/gif
Base.showable(::MIME"image/gif", agif::AnimatedGif) = lowercase(last(splitext(agif.filename))) == ".gif"

function Base.show(io::IO, ::MIME"image/gif", agif::AnimatedGif)
    open(fio -> write(io, fio), agif.filename)
end

"""
    easingflat(t, b, c, d)

A flat easing function, same as `lineartween()`.

For all easing functions, the four parameters are:

- `t` time, ie the current framenumber
- `b` beginning position or bottom value of the range
- `c` total change in position or top value of the range
- `d` duration, ie a framecount

1. `t/d` or `t/=d` normalizes `t` to between 0 and 1
2. `... * c` scales up to the required range value
3. `... + b` adds the initial offset

"""
function easingflat(t, b, c, d)
    return c * t / d + b
end

"""
    easeinquad(t, b, c, d)

quadratic easing in - accelerating from zero velocity
"""
function easeinquad(t, b, c, d)
   t /= d
   return c * t * t + b
end

"""
    easeoutquad(t, b, c, d)

quadratic easing out - decelerating to zero velocity
"""
function easeoutquad(t, b, c, d)
   t /= d
   return -c * t * (t - 2) + b
end

"""
    easeinoutquad(t, b, c, d)

quadratic easing in/out - acceleration until halfway, then deceleration
"""
function easeinoutquad(t, b, c, d)
   t /= d/2
   if t < 1
      return  (c/2) * t * t + b
    end
   t -= 1
   return -(c/2) * (t * (t - 2) - 1) + b
end

"""
    easeincubic(t, b, c, d)

cubic easing in - accelerating from zero velocity
"""
function easeincubic(t, b, c, d)
   t /= d
   return c * t * t * t + b
end

"""
    easeoutcubic(t, b, c, d)

cubic easing out - decelerating to zero velocity
"""
function easeoutcubic(t, b, c, d)
   t /= d
   t -= 1
   return c * (t * t * t + 1) + b
end

"""
    easeinoutcubic(t, b, c, d)

cubic easing in/out - acceleration until halfway, then deceleration
"""
function easeinoutcubic(t, b, c, d)
   t /= d/2
   if t < 1
       return c/2 * t * t * t + b
   end
   t -= 2
   return c/2 * (t * t * t + 2) + b
end

"""
    easeinquart(t, b, c, d)

quartic easing in - accelerating from zero velocity
"""
function easeinquart(t, b, c, d)
   t /= d
   return c * t * t * t * t + b
end

"""
    easeoutquart(t, b, c, d)

quartic easing out - decelerating to zero velocity
"""
function easeoutquart(t, b, c, d)
   t /= d
   t -= 1
   return -c * (t * t * t * t - 1) + b
end

"""
    easeinoutquart(t, b, c, d)

quartic easing in/out - acceleration until halfway, then deceleration
"""
function easeinoutquart(t, b, c, d)
   t /= d/2
   if t < 1
       return c/2 * t * t * t * t + b
   end
   t -= 2
   return -c/2 * (t * t * t * t - 2) + b
end

"""
    easeinquint(t, b, c, d)

quintic easing in - accelerating from zero velocity
"""
function easeinquint(t, b, c, d)
   t /= d
   return c * t * t * t * t * t + b
end

"""
    easeoutquint(t, b, c, d)

quintic easing out - decelerating to zero velocity
"""
function easeoutquint(t, b, c, d)
   t /= d
   t -= 1
   return c * (t * t * t * t * t + 1) + b
end

"""
    easeinoutquint(t, b, c, d)

quintic easing in/out - acceleration until halfway, then deceleration
"""
function easeinoutquint(t, b, c, d)
   t /= d/2
   if t < 1
       return c/2 * t * t * t * t * t + b
   end
   t -= 2
   return c/2 * (t * t * t * t * t + 2) + b
end

"""
    easeinsine(t, b, c, d)

sinusoidal easing in - accelerating from zero velocity
"""
function easeinsine(t, b, c, d)
   return -c * cos(t/d * (pi/2)) + c + b
end

"""
    easeoutsine(t, b, c, d)

sinusoidal easing out - decelerating to zero velocity
"""
function easeoutsine(t, b, c, d)
   return c * sin(t/d * (pi/2)) + b
end

"""
    easeinoutsine(t, b, c, d)

sinusoidal easing in/out - accelerating until halfway, then decelerating
"""
function easeinoutsine(t, b, c, d)
   return -c/2 * (cos(pi * t/d) - 1) + b
end

"""
    easeinexpo(t, b, c, d)

exponential easing in - accelerating from zero velocity
"""
function easeinexpo(t, b, c, d)
    if isapprox(t, 0.0, atol=1e-3)
        return 0.0
    else
        return c * 2 ^ (10 * (t/d - 1)) + b
    end
end

"""
    easeoutexpo(t, b, c, d)

exponential easing out - decelerating to zero velocity
"""
function easeoutexpo(t, b, c, d)
   return c * (-(2 ^ (-10 * t/d)) + 1) + b
end

"""
    easeinoutexpo(t, b, c, d)

exponential easing in/out - accelerating until halfway, then decelerating
"""
function easeinoutexpo(t, b, c, d)
   t /= d/2
   if t < 1
       return c/2 * 2 ^ (10 * (t - 1)) + b
   end
   t -= 1
   return c/2 * (-(2 ^ (-10 * t)) + 2) + b
end

"""
    easeincirc(t, b, c, d)

circular easing in - accelerating from zero velocity
"""
function easeincirc(t, b, c, d)
   t /= d
   return -c * (sqrt(abs((1 - t * t))) - 1) + b
end

"""
    easeoutcirc(t, b, c, d)

circular easing out - decelerating to zero velocity
"""
function easeoutcirc(t, b, c, d)
   t /= d
   t -= 1
   return c * sqrt(abs((1 - t * t))) + b
end

"""
    easeinoutcirc(t, b, c, d)

circular easing in/out - acceleration until halfway, then deceleration
"""
function easeinoutcirc(t, b, c, d)
   t /= d/2
   if (t < 1)
       return -c/2 * ((sqrt(abs(1 - t * t))) - 1) + b
   end
   t -= 2
   return c/2 * (sqrt(abs(1 - t * t)) + 1) + b
end

"""
    easeinoutinversequad(t, b, c, d)

ease in, then slow down, then speed up, and ease out
"""
function easeinoutinversequad(t, b, c, d)
   t /= d/2
   if t <= 1
      return -(c/2) * (t * (t - 2)) + b
    end
   t -= 1
   return c/2 * (t * t * t + 1) + b
end

"""
    easeinoutbezier(t, b, c, d, cpt1, cpt2)

This easing function takes six arguments, the usual `t`, `b`, `c`, and `d`, but
also two points. These are the normalized control points of a Bezier curve drawn
between `Point(0, 0)` to `Point(1.0, 1.0)`. The `y` value of the Bezier is the
eased value for `t`.

In your `frame()` generating function, if a Scene specifies the `easeinoutbezier` easing function, you can use this:

```
...
lineareasing = rescale(framenumber, 1, scene.framerange.stop)
beziereasing = scene.easingfunction(lineareasing, 0, 1, 1,
    Point(0.25, 0.25), Point(0.75, 0.75))
...
```

These two control points lie on the line between `0/0` and `1/1`, so it's equivalent to a linear easing (`lineartween()` or `easingflat`).

However, in the next example, the two control points define a wave-like curve
that changes direction before changing back. When animating with this easing
function, an object will 'go retrograde' for a while.

```
lineareasing = rescale(framenumber, 1, scene.framerange.stop)
beziereasing = scene.easingfunction(lineareasing, 0, 1, 1,
    Point(0.01, 1.99), Point(0.99, -1.5))
```

"""
function easeinoutbezier(t, b, c, d, cpt1::Point=Point(0.25, 0.25), cpt2::Point=Point(0.75, 0.75))
    t /= d + b
    bez = bezier(t, Point(0, 0), cpt1, cpt2, Point(1.0, 1.0))
    return bez.y * c
end

easingfunctions = [lineartween,
                    easeinquad,
                    easeoutquad,
                    easeinoutquad,
                    easeincubic,
                    easeoutcubic,
                    easeinoutcubic,
                    easeinquart,
                    easeoutquart,
                    easeinoutquart,
                    easeinquint,
                    easeoutquint,
                    easeinoutquint,
                    easeinsine,
                    easeoutsine,
                    easeinoutsine,
                    easeinexpo,
                    easeoutexpo,
                    easeinoutexpo,
                    easeincirc,
                    easeoutcirc,
                    easeinoutcirc,
                    easingflat,
                    easeinoutinversequad,
                    easeinoutbezier]
