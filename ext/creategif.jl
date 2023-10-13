# Functionality that requires FFMPEG.
# Normally invoked by setting argument `create_gif` to `animate` to true.
# Argument checking is considered sufficiently done in `animate`
using FFMEG
import Luxor
import Luxor: create_gif_newer_version, create_gif_older_version

function create_gif_older_version(directory::String, title::String, framerate)
    # version of ffmpeg up to 2.1.3
    # these two commands create a palette and then an animated GIF from the resulting images using the palette
    FFMPEG.ffmpeg_exe(`-loglevel panic -f image2 -i $(directory)/%10d.png -vf palettegen -y $(directory)/$(title)-palette.png`)
    FFMPEG.ffmpeg_exe(`-loglevel panic -framerate $(framerate) -f image2 -i $(directory)/%10d.png -i $(directory)/$(title)-palette.png -lavfi paletteuse -y $(directory)/$(title).gif`)
end
function create_gif_newer_version(directory::String, title::String, framerate)
    @debug "we're running bundled FFMPEG", FFMPEG.exe("-version")
     # the FFMPEG commands create a palette and then create an animated GIF from the resulting images
    FFMPEG.ffmpeg_exe(`-framerate $(framerate) -f image2 -i $(directory)/%10d.png -filter_complex "[0:v] split [a][b]; [a] palettegen=stats_mode=full:reserve_transparent=on:transparency_color=FFFFFF [p]; [b][p] paletteuse=new=1:alpha_threshold=128" -y $(directory)/$(title).gif`)
end
function create_gif_newer_version_reduced_verbosity(directory::String, title::String, framerate)
    @debug "we're running bundled FFMPEG", FFMPEG.exe("-version")
    # the FFMPEG commands create a palette and then create an animated GIF from the resulting images
    FFMPEG.ffmpeg_exe(`-framerate $(framerate) -f image2 -i $(directory)/%10d.png -filter_complex "[0:v] split [a][b]; [a] palettegen=stats_mode=full:reserve_transparent=on:transparency_color=FFFFFF [p]; [b][p] paletteuse=new=1:alpha_threshold=128" -y $(directory)/$(title).gif`)
end
