"""
The `Sequence` type and the `animate()` function are designed to help you create the frames
that can be used to make an animated GIF or movie.

Provide width, height, and a title to the Sequence constructor:

    demo = Sequence(400, 400, "test")

Then define suitable backdrop and frame functions.

Finally run the `animate()` function, calling those functions.
"""
type Sequence
    width::Float64
    height::Float64
    stitle::String
    parameters::Dict
    function Sequence(width=800, height=800, stitle="luxor-animation-default", parameters=Dict())
        new(width, height, stitle, parameters)
    end
end

"""
    animate(seq::Sequence, frames::Range, backdrop_func=(seq), frame_func=(seq, n, range);
        createanimation = true)

Create frames in the range `frames`, using a backdrop function and a frame function.

The backdrop function is called for every frame.

    function backdrop_f(demo)
    ...
    end

The frame generating function draws the graphics for a single frame.

    function frame_f(demo, framenumber, framerange)
    ...
    end

Then call `animate()` like this:

    animate(demo, 1:100, backdrop_f, frame_f)

If `createanimation` is `true`, the function tries to call `ffmpeg` on the resulting frames to
build the animation.
"""

function animate(seq::Sequence, frames::Range, backdrop_func=(s, fn), frame_func=(s, fn, fr);
        createanimation = true)
    tempdirectory = mktempdir("/tmp")
    info("storing \"$(seq.stitle)\" in directory; $(tempdirectory)")
    filecounter = 1
    for currentframe in frames
        Drawing(seq.width, seq.height, "$(tempdirectory)/$(lpad(filecounter, 10, "0")).png")
        origin()
        # use invoke() until 0.6?
        invoke(backdrop_func, (typeof(seq),), seq)
        invoke(frame_func, (typeof(seq), typeof(currentframe), typeof(frames)), seq, currentframe, frames)
        finish()
        filecounter += 1
    end
    info("... $(filecounter) frames stored in directory $(tempdirectory)")
    if is_unix() && (createanimation == true)
        # these two commands create a palette and then create animated GIF from the resulting images
        run(`ffmpeg -f image2 -i $(tempdirectory)/%10d.png -vf palettegen -y $(tempdirectory)/$(seq.stitle)-palette.png`)
        run(`ffmpeg -framerate 30 -f image2 -i $(tempdirectory)/%10d.png -i $(tempdirectory)/$(seq.stitle)-palette.png -lavfi paletteuse -y $(tempdirectory)/$(seq.stitle).gif`)
    end
end
