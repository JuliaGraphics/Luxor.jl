# Extensions are modules that depend on Luxor and other modules.
# They are loaded when Luxor and these modules are loaded.

function latextextsize(arg::Any)
    error("The Modules LaTeXStrings and MathTeXEngine are not loaded.")
end

function latexboundingbox(arg::Any)
    error("The Modules LaTeXStrings and MathTeXEngine are not loaded.")
end

function rawlatexboundingbox(arg::Any)
    error("The Modules LaTeXStrings and MathTeXEngine are not loaded.")
end

# the typstry extension defines this function
"""
    render_typst_document(ts::TypstString)

Render the Typst string in `ts` to an array of SVG images, one 
for each page.

To use Typst:

```julia
using Luxor
using Typstry

@draw begin
    placeimage(
        first(
            render_typst_document(
                typst"
#set text(size: 100pt)
Hello world"
            )
        ), boxtopleft()
    )
end
```
"""
function render_typst_document(arg::Any)
    error("The Typstry module is not loaded.
    Try `using Pkg; Pkg.add(\"Typstry\"); using Typstry` first.
    This function expects a Typst string and returns an array of SVG images.
    ")
end