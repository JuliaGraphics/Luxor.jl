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
    movietitle::String
    movieframerange::AbstractRange
end

"""
    Movie(width, height, movietitle)

Define a movie, specifying the width, height, and a title. The title will be used to
make the output file name. The range defaults to `1:250`.
"""
Movie(width, height, movietitle::String) = Movie(width, height, movietitle, 1:250)

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
"""
mutable struct Scene
    movie::Movie
    framefunction::Function
    framerange::AbstractRange
    easingfunction::Function
end

Scene(movie::Movie, framefunction::Function; easingfunction=lineartween) = Scene(movie, framefunction, movie.movieframerange, easingfunction)
Scene(movie, framefunction, framerange; easingfunction=lineartween) = Scene(movie, framefunction, framerange, easingfunction)

"""
    animate(movie::Movie, scenelist::AbstractArray{Scene, 1};
            creategif=false,
            pathname=""
            framerate=30)

Create the movie defined in `movie` by rendering the frames define in the array of scenes
in `scenelist`.

If `creategif` is `true`, the function tries to call `ffmpeg` on the resulting frames to
build a GIF animation. This will be stored in `pathname` (an existing file will be
overwritten; use a ".gif" suffix), or in `(movietitle).gif` in a temporary directory.

Example

```
animate(bang, [
    Scene(bang, backdrop, 0:200),
    Scene(bang, frame1, 0:200, easingfunction=easeinsine)],
    creategif=true,
    pathname="/tmp/animationtest.gif")
```
"""
function animate(movie::Movie, scenelist::AbstractArray{Scene, 1};
        creategif=false,
        framerate=30,
        pathname="")
    tempdirectory = mktempdir()
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
    if creategif == true
        # these two commands create a palette and then create animated GIF from the resulting images
        run(`ffmpeg -loglevel panic -f image2 -i $(tempdirectory)/%10d.png -vf palettegen -y $(tempdirectory)/$(movie.movietitle)-palette.png`)
        run(`ffmpeg -loglevel panic -framerate $(framerate) -f image2 -i $(tempdirectory)/%10d.png -i $(tempdirectory)/$(movie.movietitle)-palette.png -lavfi paletteuse -y $(tempdirectory)/$(movie.movietitle).gif`)
        if ! isempty(pathname)
            mv("$(tempdirectory)/$(movie.movietitle).gif", pathname, remove_destination=true)
            @info("GIF is: $pathname")
        else
            @info("GIF is: $(tempdirectory)/$(movie.movietitle).gif")
        end
    end
    return true
end

"""
    animate(movie::Movie, scene::Scene; creategif=false, framerate=30)

Create the movie defined in `movie` by rendering the frames define in `scene`.
"""
animate(movie::Movie, scene::Scene; kwargs...) = animate(movie, [scene]; kwargs...)

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
                    easeinoutinversequad]
