# Extensions are modules that depend on Luxor and other modules.
# They are loaded when Luxor and these modules are loaded.
# Extensions (LuxorExt...) cannot however reliably introduce new symbols
# into Luxor. Hence, placeholder functions with catchall argument types:
function latextextsize(catch_all)
    if Base.get_extension(Luxor, :LuxorExtLatex) isa Module
        throw(MethodError(latextextsize, catch_all))
    else
        throw(ErrorException("Modules LaTeXStrings and MathTeXEngine are not loaded."))
    end
end
function latexboundingbox(catch_all; kwargs...)
    if Base.get_extension(Luxor, :LuxorExtLatex) isa Module
        throw(MethodError(latexboundingbox, catch_all))
    else
        throw(ErrorException("Modules LaTeXStrings and MathTeXEngine are not loaded."))
    end
end
function rawlatexboundingbox(catch_all)
    if Base.get_extension(Luxor, :LuxorExtLatex) isa Module
        throw(MethodError(rawlatexboundingbox, catch_all))
    else
        throw(ErrorException("Modules LaTeXStrings and MathTeXEngine are not loaded."))
    end
end
"""
Render the Typst string in `ts` to an array of SVG images, one 
for each page.
"""
function render_typst_document(catch_all)
    if Base.get_extension(Luxor, :LuxorExtTypstry) isa Module
        throw(MethodError(render_typst_document, catch_all))
    else
        throw(ErrorException("Module Typstry is not loaded."))
    end
end