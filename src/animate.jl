"""
The `Movie` and `Scene` types and the `animate()` function are designed to help you create the frames
that can be used to make an animated GIF or movie.

- Provide width, height, title, and frame range to the Movie constructor:

    demo = Sequence(400, 400, "test", 1:100)

- Then define Scenes and scene-drawing functions.

- Finally, run the `animate()` function, calling those functions.
"""
type Movie
    width::Float64
    height::Float64
    movietitle::String
    movieframerange::Range
end

"""
The Scene type defines which function should be used to render specific frames in a movie.
"""
type Scene
    movie::Movie
    framerange::Range
    framefunction::Function
end

"""
    animate(movie::Movie, scenelist::Array{Scene, 1};
            creategif=false,
            framerate=30)

Create frames from scenes in `scenelist`.

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
    if rangelist[end] > movie.movieframerange.stop
        error("Movie too short. movie: $(movie.movieframerange) last scene frame: $(rangelist[end])")
    end
    if rangelist[end] < movie.movieframerange.stop
        warn("Movie is too long. movie: $(movie.movieframerange) last scene frame: $(rangelist[end])")
    end
    for currentframe in rangelist[1]:rangelist[end]
        Drawing(movie.width, movie.height, "$(tempdirectory)/$(lpad(filecounter, 10, "0")).png")
        origin()
        # this frame needs doing, see if each of the scenes defines it
        for scene in scenelist
            if currentframe in scene.framerange
                # use invoke()? TODO change for v0.6?
                invoke(scene.framefunction, Tuple{typeof(movie), typeof(currentframe)}, movie, currentframe)
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

# deprecated types

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
