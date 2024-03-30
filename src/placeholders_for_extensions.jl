# Extensions are modules that depend on Luxor and other modules.
# They are loaded when Luxor and these modules are loaded.
# Extensions (LuxorExt...) cannot however reliably introduce new symbols
# into Luxor. Hence, placeholder functions with catchall argument types:
function latextextsize(catch_all)
    if Base.get_extension(Luxor, :LuxorExtLatex) isa Module
        throw(MethodError(latextextsize, catch_all))
    else
        throw(ErrorException("Modules LaTeXStrings and MathTeXEngine are not loaded. Try `using LaTeXStrings,  MathTeXEngine`!"))
    end
end
function latexboundingbox(catch_all; kwargs...)
    if Base.get_extension(Luxor, :LuxorExtLatex) isa Module
        throw(MethodError(latexboundingbox, catch_all))
    else
        throw(ErrorException("Modules LaTeXStrings and MathTeXEngine are not loaded. Try `using LaTeXStrings,  MathTeXEngine`!"))
    end
end
function rawlatexboundingbox(catch_all)
    if Base.get_extension(Luxor, :LuxorExtLatex) isa Module
        throw(MethodError(rawlatexboundingbox, catch_all))
    else
        throw(ErrorException("Modules LaTeXStrings and MathTeXEngine are not loaded. Try `using LaTeXStrings,  MathTeXEngine`!"))
    end
end
# Placeholders for animation functions.
# Since there are so many similar placeholders, we could use a small macro definition and call. 
# During initial testing, we use more verbose and conceptually simple code instead: 

function create_gif_older_version(catch_all, catch_2, catch_3)
    if Base.get_extension(Luxor, :LuxorExtFFMPEG) isa Module
        throw(MethodError(create_gif_older_version, catch_all))
    else
        throw(ErrorException("Module FFMPEG is not loaded. Try `using FFMPEG`!"))
    end
end
function create_gif_newer_version(catch_all, catch_2, catch_3)
    if Base.get_extension(Luxor, :LuxorExtFFMPEG) isa Module
        throw(MethodError(create_gif_newer_version, catch_all))
    else
        throw(ErrorException("Module FFMPEG is not loaded. Try `using FFMPEG`!"))
    end
end
function create_gif_newer_version_reduced_verbosity(catch_all, catch_2, catch_3)
    if Base.get_extension(Luxor, :LuxorExtFFMPEG) isa Module
        throw(MethodError(create_gif_newer_version, catch_all))
    else
        throw(ErrorException("Module FFMPEG is not loaded. Try `using FFMPEG`!"))
    end
end