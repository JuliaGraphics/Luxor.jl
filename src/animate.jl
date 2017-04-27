"""
The `Movie` and `Scene` types and the `animate()` function are designed to help you create
the frames that can be used to make an animated GIF or movie.

1 Provide width, height, title, and frame range to the Movie constructor:

    demo = Movie(400, 400, "test", 1:100)

2 Then define Scenes and scene-drawing functions.

2 Finally, run the `animate()` function, calling those functions.
"""

type Movie
    width::Float64
    height::Float64
    movietitle::String
    movieframerange::Range
end

"""
    Movie(width, height, movietitle)

Define a movie, specifying the width, height, and a title. The title will be used to make
the output file name. The range defaults to `1:100`.
"""

Movie(width, height, movietitle::String) = Movie(width, height, movietitle, 1:100)

"""default linear transition - no easing, no acceleration"""
function lineartween(t, b, c, d)
   return c * t/d + b
end

"""
The Scene type defines a function to be used to render a range of frames in a movie.

- `movie` created by Movie()
- `framefunction` is a function taking two arguments: the movie and the framenumber.
- `framerange` determines which frames are processed by the function. Defaults to the entire movie.
- `easingfunction` can be accessed by the framefunction to vary the transition speed
"""
type Scene
    movie::Movie
    framefunction::Function
    framerange::Range
    easingfunction::Function
    Scene(movie, framefunction, framerange; easingfunction=lineartween) = new(movie, framefunction, framerange, easingfunction)
    # no specific range, use movie's range
    Scene(movie::Movie, framefunction::Function; easingfunction=lineartween) = Scene(movie, framefunction, movie.movieframerange, easingfunction)
    # no specific range or function
    Scene(movie::Movie, framefunction::Function) = Scene(movie, framefunction, movie.movieframerange, easingfunction=lineartween)
end

"""
    animate(movie::Movie, scenelist::Array{Scene, 1};
            creategif=false,
            framerate=30)

Create the movie defined in `movie` by rendering the frames define in the array of scenes
in `scenelist`.

If `creategif` is `true`, the function tries to call `ffmpeg` on the resulting frames to
build a GIF animation.
"""
function animate(movie::Movie, scenelist::Array{Scene, 1};
        creategif=false,
        framerate=30)
    tempdirectory = mktempdir()
    info(" frames for animation \"$(movie.movietitle)\" are being stored in directory $(tempdirectory)")
    filecounter = 1
    rangelist = 0:-1
    for scene in scenelist
        rangelist = vcat(rangelist, collect(scene.framerange))
    end
    rangelist = unique(rangelist) # remove shared frames
    #    if rangelist[end] > movie.movieframerange.stop
    #        error("Movie too short. movie: $(movie.movieframerange) last scene frame: $(rangelist[end])")
    #    end
    if rangelist[end] < movie.movieframerange.stop
        warn("Movie is too long. movie: $(movie.movieframerange) last scene frame: $(rangelist[end])")
    end
    for currentframe in rangelist[1]:rangelist[end]
        Drawing(movie.width, movie.height, "$(tempdirectory)/$(lpad(filecounter, 10, "0")).png")
        origin()
        # this frame needs doing, see if each of the scenes defines it
        for scene in scenelist
            if currentframe in scene.framerange
                # use invoke(), no - changing for v0.6
                # invoke(scene.framefunction,
                #     Tuple{typeof(movie), typeof(currentframe), typeof(easingfunction)},
                #     movie,
                #     currentframe,
                #     easingfunction=scene.easingfunction)
                scene.framefunction(scene, currentframe)
            end
        end
        finish()
        filecounter += 1
    end
    info("... $(filecounter) frames stored in directory $(tempdirectory)")
    if is_unix() && (creategif == true)
        # these two commands create a palette and then create animated GIF from the resulting images
        run(`ffmpeg -loglevel panic -f image2 -i $(tempdirectory)/%10d.png -vf palettegen -y $(tempdirectory)/$(movie.movietitle)-palette.png`)
        run(`ffmpeg -loglevel panic -framerate $(framerate) -f image2 -i $(tempdirectory)/%10d.png -i $(tempdirectory)/$(movie.movietitle)-palette.png -lavfi paletteuse -y $(tempdirectory)/$(movie.movietitle).gif`)
        info("GIF is: $(tempdirectory)/$(movie.movietitle).gif")
    end
    return true
end

"""
    animate(movie::Movie, scene::Scene; creategif=false, framerate=30)

Create the movie defined in `movie` by rendering the frames define in `scene`.
"""
animate(movie::Movie, scene::Scene; kwargs...) = animate(movie, [scene]; kwargs...)

# """
# ## Easing functions
#
#     function animatepoly(scene, framenumber)
#         background("white")
#         ...
#         easedframenumber = scene.easingfunction(framenumber, 0, 1, scene.framerange.stop)
#     ...
#
# `t` is the current framenumber of the transition.
# `b` is the beginning value of the property.
# `c` is the change between the beginning and destination value of the property.
# `d` is the total time of the transition.
# """

"""quadratic easing in - accelerating from zero velocity"""
function easeinquad(t, b, c, d)
   t /= d
   return c * t * t + b
end

"""quadratic easing out - decelerating to zero velocity"""
function easeoutquad(t, b, c, d)
   t /= d
   return -c * t * (t - 2) + b
end

"""quadratic easing in/out - acceleration until halfway, then deceleration"""
function easeinoutquad(t, b, c, d)
   t /= d/2
   if (t < 1)
      return  (c/2) * t * t + b
    end
   t -= 1
   return -(c/2) * (t * (t - 2) - 1) + b
end

"""cubic easing in - accelerating from zero velocity"""
function easeincubic(t, b, c, d)
   t /= d
   return c*t*t*t + b
end

"""cubic easing out - decelerating to zero velocity"""
function easeoutcubic(t, b, c, d)
   t /= d
   t -= 1
   return c*(t*t*t + 1) + b
end

"""cubic easing in/out - acceleration until halfway, then deceleration"""
function easeinoutcubic(t, b, c, d)
   t /= d/2
   if (t < 1)
       return c/2*t*t*t + b
   end
   t -= 2
   return c/2 * (t*t*t + 2) + b
end

"""quartic easing in - accelerating from zero velocity"""
function easeinquart(t, b, c, d)
   t /= d
   return c*t*t*t*t + b
end

"""quartic easing out - decelerating to zero velocity"""
function easeoutquart(t, b, c, d)
   t /= d
   t -= 1
   return -c * (t*t*t*t - 1) + b
end

"""quartic easing in/out - acceleration until halfway, then deceleration"""
function easeinoutquart(t, b, c, d)
   t /= d/2
   if (t < 1)
       return c/2*t*t*t*t + b
   end
   t -= 2
   return -c/2 * (t*t*t*t - 2) + b
end

"""quintic easing in - accelerating from zero velocity"""
function easeinquint(t, b, c, d)
   t /= d
   return c*t*t*t*t*t + b
end

"""quintic easing out - decelerating to zero velocity"""
function easeoutquint(t, b, c, d)
   t /= d
   t -= 1
   return c*(t*t*t*t*t + 1) + b
end

"""quintic easing in/out - acceleration until halfway, then deceleration"""
function easeinoutquint(t, b, c, d)
   t /= d/2
   if (t < 1)
       return c/2*t*t*t*t*t + b
   end
   t -= 2
   return c/2*(t*t*t*t*t + 2) + b
end

"""sinusoidal easing in - accelerating from zero velocity"""
function easeinsine(t, b, c, d)
   return -c * cos(t/d * (pi/2)) + c + b
end

"""sinusoidal easing out - decelerating to zero velocity"""
function easeoutsine(t, b, c, d)
   return c * sin(t/d * (pi/2)) + b
end

"""sinusoidal easing in/out - accelerating until halfway, then decelerating"""
function easeinoutsine(t, b, c, d)
   return -c/2 * (cos(pi*t/d) - 1) + b
end

"""exponential easing in - accelerating from zero velocity"""
function easeinexpo(t, b, c, d)
    if isapprox(t, 0.0)
        return 0.0
    else
        return c * 2 ^ (10 * (t/d - 1)) + b
    end
end

"""exponential easing out - decelerating to zero velocity"""
function easeoutexpo(t, b, c, d)
   return c * (-(2 ^ (-10 * t/d)) + 1) + b
end

"""exponential easing in/out - accelerating until halfway, then decelerating"""
function easeinoutexpo(t, b, c, d)
   t /= d/2
   if t < 1
       return c/2 * 2^(10 * (t - 1)) + b
   end
   t -= 1
   return c/2 * (-(2 ^ (-10 * t)) + 2) + b
end

"""circular easing in - accelerating from zero velocity"""
function easeincirc(t, b, c, d)
   t /= d
   return -c * (sqrt(abs((1 - t*t))) - 1) + b
end

"""circular easing out - decelerating to zero velocity"""
function easeoutcirc(t, b, c, d)
   t /= d
   t -= 1
   return c * sqrt(abs((1 - t*t))) + b
end

"""circular easing in/out - acceleration until halfway, then deceleration"""
function easeinoutcirc(t, b, c, d)
   t /= d/2
   if (t < 1)
       return -c/2 * ((sqrt(abs(1 - t*t))) - 1) + b
   end
   t -= 2
   return c/2 * (sqrt(abs(1 - t*t)) + 1) + b
end

"""easingflat, same as linear tween"""
function easingflat(t, b, c, d)
    return c * t / d + b
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
                    easingflat]


"""deprecated types"""

type Sequence
    width::Float64
    height::Float64
    stitle::String
    parameters::Dict
    function Sequence(width=800, height=800, stitle="luxor-animation-default", parameters=Dict())
        new(width, height, stitle, parameters)
    end
end

function animate(seq::Sequence, frames::Range, backdropfunc, framefunc;
        createanimation = true)
    warn("The sequence-based animate() function is deprecated.")
    tempdirectory = mktempdir()
    info("storing \"$(seq.stitle)\" in directory; $(tempdirectory)")
    info( "ffmpeg will $(createanimation ? "" : "not ")process the frames.")
    filecounter = 1
    for currentframe in frames
        Drawing(seq.width, seq.height, "$(tempdirectory)/$(lpad(filecounter, 10, "0")).png")
        origin()
        # use invoke()? TODO change for v0.6?
        invoke(backdropfunc, Tuple{typeof(seq), typeof(currentframe), typeof(frames)}, seq, currentframe, frames)
        invoke(framefunc, Tuple{typeof(seq), typeof(currentframe), typeof(frames)}, seq, currentframe, frames)
        finish()
        filecounter += 1
    end
    info("... $(filecounter) frames stored in directory $(tempdirectory)")
    if is_unix() && (createanimation == true)
        # these two commands create a palette and then create animated GIF from the resulting images
        run(`ffmpeg -f image2 -i $(tempdirectory)/%10d.png -vf palettegen -y $(tempdirectory)/$(seq.stitle)-palette.png`)
        run(`ffmpeg -framerate 30 -f image2 -i $(tempdirectory)/%10d.png -i $(tempdirectory)/$(seq.stitle)-palette.png -lavfi paletteuse -y $(tempdirectory)/$(seq.stitle).gif`)
    end
    return true
end
