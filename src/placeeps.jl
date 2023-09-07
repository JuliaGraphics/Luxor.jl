using DataStructures: Stack

"""
    placeeps(epsfile; log=false)

This function loads and interprets an EPS file previously exported by
Cairo. Commands are 'applied' to the current drawing.

The primary intention is to extract some geometry  - points and curves,
etc. - from an EPS vector graphic. 

!!! warning

    This function reads only 'Cairo-flavoured' EPS files. Every application that
    exports EPS files defines its own chosen set of PostScript functions in a
    prolog. There's no standard. The 'Cairo-flavoured' EPS prolog is hard-coded into
    EPS files exported from Cairo so it's predictable, but other EPS exporters
    define their own flavour, defining and calling who knows what PostScript
    functions. So it's unlikely that EPS files from other sources will be
    successfully processed with this function.

Also note:

- ignores clipping for now; I'm not sure how the Cairo->EPS->Cairo transformations work yet

- ignores `rectfill`` commands for now - I think these are often used just for the initial BoundingBoxes/clipping, but if they're used matrix transforms they'll need interpreting somehow

- ignores blends and gradients, embedded images, embedded fonts, among many other things...

Use `log` to print the commands to the REPL as well as execute them. 

## Examples

```julia
@draw begin
    translate(boxtopleft())
    Luxor.placeeps("/tmp/julia.eps")
end
```

You can convert an SVG file to EPS by reading the SVG into Luxor, saving as EPS, then
placing that saved EPS file onto a new drawing:

```julia
svgfile = readsvg("julia.svg")
@eps begin
    placeimage(svgfile, centered = true)
end 800 500 "/tmp/julia.eps"
@draw begin
    translate(boxtopleft())
    placeeps("/tmp/julia.eps")
end
```

If you want to put the list of Luxor commands in a text file for pasting into another file, you could try this (Julia v.1.7 and up). Let's say you have an SVG called `julia.svg`.

```julia
# load an SVG and save as EPS
@eps begin
    svgf = readsvg("julia.svg")
    placeimage(svgf, centered = true)
end 500 500 "/tmp/t.eps"

# convert EPS to Luxor commands
redirect_stdio(stdout = "/tmp/output.jl") do
    placeeps("/tmp/t.eps", log = true)
end

# include Luxor commands and save as a new SVG:
@svg begin
    translate(boxtopleft())
    include("/tmp/output.jl")
end 500 500 "/tmp/julia.svg"
```
"""
function placeeps(epsfile;
        log = false)
    if !isfile(epsfile)
        @warn " $epsfile is not a file that I can find..."
        return false
    end
    lines = readlines(epsfile)
    prolog = false
    s = Stack{Any}() # holds numbers, string commands, etc...
    log && println("# start EPS import")
    for i in lines
        if i == "%%EndPageSetup"
            prolog = false
        end
        if startswith(i, "%%Creator")
            if !occursin("cairo", i)
                @warn "This EPS file was not created with Cairo. Expect disappointment and failure in equal measure."
            end
        end 
        if startswith(i, "%!PS-Adobe-3.0")
            prolog = true
        end
        if prolog == true
            continue
        end
        if startswith(i, "%")
            continue
        end
        tkns = split(i)
        for tkn in tkns
            if length(tkn) > 32
                # long tokens are probably image or font data
                # so ignore them
                continue
            end
            # hopefully there are some numbers in this file?
            n = tryparse(Float64, tkn)
            if !isnothing(tryparse(Float64, tkn))
                # push numbers onto stack
                push!(s, parse(Float64, tkn))
            elseif tkn == "m"
                p1 = pop!(s)
                p2 = pop!(s)
                move(Point(p2, (p1)))
                log && println("move(Point($(p2), $(p1)))") 
            elseif tkn == "l" # lineto 
                p1 = pop!(s)
                p2 = pop!(s)
                line(Point(p2, p1))
                log && println("line(Point($(p2), $(p1)))")
            elseif tkn == "c" # curveto 
                p1 = pop!(s)
                p2 = pop!(s)
                p3 = pop!(s)
                p4 = pop!(s)
                p5 = pop!(s)
                p6 = pop!(s)
                curve(Point(p6, p5), Point(p4, p3), Point(p2, p1))
                log && println("curve(Point($(p6), $(p5)), Point($(p4), $(p3)), Point($(p2), $(p1)))")
            elseif tkn == "h" # closepath
                closepath()
                log && println("closepath()")
            elseif tkn == "S" # stroke 
                strokepath()
                log && println("strokepath()")
            elseif tkn == "f" # fill 
                fillpath()
                log && println("fillpath()")
            elseif tkn == "f*" # eofill 
                log && println("# eofill?")
            elseif tkn == "n" # newpath 
                newpath()
                log && println("newpath()")
            elseif tkn == "g"
                p1 = pop!(s)
                setgray(p1)
                log && println("setgray($(p1))")
            elseif tkn == "rg"
                p1 = pop!(s)
                p2 = pop!(s)
                p3 = pop!(s)
                sethue(p3, p2, p1)
                log && println("sethue($(p3), $(p2), $(p1))")
            elseif tkn == "q" # gsave
                gsave()
                log && println("gsave()")
            elseif tkn == "Q" # grestore
                grestore()
                clipreset() # does clipping get reset by grestore ?
                log && println("grestore(); clipreset()")
            elseif tkn == "cm" # matrix
                p1 = pop!(s)
                p2 = pop!(s)
                p3 = pop!(s)
                p4 = pop!(s)
                p5 = pop!(s)
                p6 = pop!(s)
                m = [p6, p5, p4, p3, p2, p1]
                # matrix transforms ignored")              
                # setmatrix([$p6, $p5, $p4, $p3, $p2, $p1])
                log && println("# setmatrix([$p6, $p5, $p4, $p3, $p2, $p1])")
            elseif tkn == "w" # linewidth
                p1 = pop!(s)
                setline(p1)
                log && println("setline($(p1))")
            elseif tkn == "J"
                # 0 (butt caps), 1 (round caps), or 2 (extended butt caps)
                p1 = convert(Int, pop!(s) + 1)
                v = ["butt", "round", "square"][p1]
                setlinecap("\"$(v)\"")
                log && println("setlinecap(\"$(v)\")")
            elseif tkn == "j"
                # 0 (miter join), 1 (round join), or 2 (bevel join)
                p1 = convert(Int, pop!(s) + 1)
                v = ["miter", "round", "bevel"][p1]
                setlinejoin("\"$(v)\"")
                log && println("setlinejoin(\"$(v)\")")
            elseif tkn == "[]" # tis an empty array
                push!(s, "[")
                push!(s, "]")
            elseif tkn == "d"  # dash patterns are an array of numbers
                darray = Float64[]
                for e in Iterators.reverse(s)
                    if e isa Number
                        push!(darray, e)
                    end
                    if e == "]"
                        break
                    end
                end
                setdash(darray)
            elseif tkn == "W"  # clip
                clip()
            elseif tkn == "M"  # miterlimit
                p1 = pop!(s)
                # setmiterlimit($p1)") # is this in Luxor or Cairo yet?
                log && println("# setmiterlimit($(p1))")
            elseif tkn == "re" # ????
                # 0 0 500 174 re W n
                p1 = pop!(s)
                p2 = pop!(s)
                p3 = pop!(s)
                p4 = pop!(s)
                rect(Point(p4, p3), p2, p1, action = :path)
                log && println("# re command... ")
                log && println(" rect(Point($p4, $p3), $p2, $p1, action = :path)")
            elseif tkn == "rectfill"
                # probably used for the initial crop box, so don't draw
                p1 = pop!(s)
                p2 = pop!(s)
                p3 = pop!(s)
                p4 = pop!(s)
                # rectfill
                # rect(Point($(p4), $(p3)), $(p2), $(p1), action=:stroke)
                log && println("# rect(Point($(p4), $(p3)), $(p2), $(p1), action=:stroke)")
            elseif endswith(tkn, "]")
                val = chop(tkn)
                if tryparse(Float64, val) == true
                    push!(s, parse(Float64, val))
                end
                push!(s, "]")
            elseif tkn == "["
                push!(s, tkn)
            elseif startswith(tkn, "[")
                val = chop(tkn, head = 1, tail = 0)
                push!(s, "[")
                push!(s, parse(Float64, val))
            elseif tkn == "rectclip"
                p1 = pop!(s)
                p2 = pop!(s)
                p3 = pop!(s)
                p4 = pop!(s)
                # a rectclip, will be ignored for now:
                # rect(Point($(p4), $(p3)), $(p2), $(p1), action=:clip)
                log && println("# rectclip ignored ")
                log && println("# rect(Point($(p4), $(p3)), $(p2), $(p1), action=:clip) ")
            elseif tkn == "showpage" || tkn == "end"
                #
            elseif tkn == "cairo_image"
                # AAARGH! file contains image and binary data ...
                log && println("# file contains image data, ignoring... ")
            else
                log && println("# &tkn ")
            end
        end
    end
    log && println("# end EPS import")
    return true # anything better to return?
end