#!/usr/bin/env julia -

using Luxor

using Test

function svgstring_test()
    @testset "svg string test" begin
        Drawing(400, 800, :svg)
        origin()
        juliacircles()
        @test finish() == true
        svgsource = svgstring()
        matches = collect(eachmatch(r"<.*?>", svgsource))
        @test first(matches).match == """<?xml version="1.0" encoding="UTF-8"?>"""
        @test last(matches).match == "</svg>"
    end
    println("...finished svgstring_test")
end

function place_svgtest(fnamein, fnameout)
    svgin = readsvg(fnamein)
    @testset "readsvg" begin
        @test svgin.xpos == 400
        @test svgin.ypos == 400
        @test svgin.width == 400
        @test svgin.height == 400
    end
    @testset "placeimage" begin
        Drawing(400, 800, fnameout)
        origin()
        background("green")
        placeimage(svgin, O, centered = true)
        @test finish() == true
        svgin2 = readsvg(fnameout)
        @test svgin2.xpos == 400
        @test svgin2.ypos == 800
        @test svgin2.width == 400
        @test svgin2.height == 800
    end
    println("...finished test: output in $(fnameout)")
end

function svg_rec_format()
    # Checking for specific expectations when using recordings (:rec) and svg snapshots.
    # These tests are especially intended to help in case cairo changes the svg elements
    # which are used to tweak the result by function adjust_background_rects(buffer) in drawings.jl
    Drawing(NaN, NaN, :rec)
    background("deepskyblue2")
    setcolor("grey")
    rect(-140,-140,280,280, :fill)
    setcolor("black")
    circle(O, 100, :stroke)
    circle(O, 100, :clip)
    background("magenta")
    # now doing what
    #   snapshot(;fname="test.svg",cb=BoundingBox(Point(-150,-150),Point(150,150)))
    # does without the adjust_background_rects(buffer) tweak
    fname="test.svg"
    cb=BoundingBox(Point(-150,-150),Point(150,150))
    scalefactor = 1.0
    rd = currentdrawing()
    rs = Luxor.current_surface()
    Luxor.Cairo.flush(rs)
    rma = getmatrix()
    rmai = juliatocairomatrix(cairotojuliamatrix(rma)^-1)
    rtlxu, rtlyu = boxtopleft(cb)
    rtlxd, rtlyd, _ = cairotojuliamatrix(rma) * [rtlxu, rtlyu, 1]
    x, y = -rtlxd, -rtlyd
    nw = Float64(round(scalefactor * boxwidth(cb)))
    nh = Float64(round(scalefactor * boxheight(cb)))
    nm = scalefactor.* [rmai[1], rmai[2], rmai[3], rmai[4], 0.0, 0.0]
    nd = Drawing(round(nw), round(nh), fname)
    setmatrix(nm)
    Luxor.set_source(nd.cr, rs, x, y)
    paint()
    # now doing what
    #   finish()
    # does without the adjust_background_rects(buffer) tweak
    Luxor.Cairo.finish(Luxor.current_surface())
    Luxor.Cairo.destroy(Luxor.current_surface())
    buffer=copy(Luxor.current_bufferdata())
    Luxor._current_drawing()[Luxor._current_drawing_index()] = rd
    finish()

    testsvg=String(buffer)
    # check if the SVG contains lines like
    #   <use xlink:href="#surface31" transform="matrix(1,0,0,1,150,150)"/>
    # or
    #   <use href="#surface31" transform="matrix(1,0,0,1,150,150)"/>
    # after </defs>
    m=match(r"</defs\s*?>(.*)$"is,testsvg)
    @test length(m) == 1
    if length(m) == 1
        testsvg_part=m[1]
        m=match(r"<use[^>]*?(xlink:)*?href=\"#(.*?)\"[^>]*?transform=\"matrix\((.+?),(.+?),(.+?),(.+?),(.+?),(.+?)\)\"/>"is,testsvg_part)
        @test !isnothing(m) && length(m) == 8
        id=m[2]
        # check if the SVG contains line like
        #   <g id="surface31" clip-path="url(#clip1)">
        m=match(Regex("<g\\s+?[^>]*?id=\"($(id))\".*?>","is"),testsvg)
        @test !isnothing(m) && m[1] == id
        # check if <g id="$id">...</g> is extracted correct
        group="<g id=\"other\"></g><g id=\""*id*"\"><g><g></g></g><g></g></g><g id=\"other\"></g>"
        (head,mid,tail,split_ok)=Luxor.split_string_into_head_mid_tail(group,id)
        @test split_ok == true
        @test head == "<g id=\"other\"></g>"
        @test mid == "<g id=\""*id*"\"><g><g></g></g><g></g></g>"
        @test tail == "<g id=\"other\"></g>"
        # split_string_into_head_mid_tail(group,id) needs to be robust
        # do nothing if split fails
        group="</g><g id=\"other\"></g><g id=\""*id*"\"><g><g></g></g>"
        (head,mid,tail,split_ok)=Luxor.split_string_into_head_mid_tail(group,id)
        @test split_ok == false
        group="</g></g><g><g id=\""*id*"\">"
        (head,mid,tail,split_ok)=Luxor.split_string_into_head_mid_tail(group,id)
        @test split_ok == false
        group="<g><g id=\"other\"></g></g>"
        (head,mid,tail,split_ok)=Luxor.split_string_into_head_mid_tail(group,id)
        @test split_ok == false
        group="<g><g><g id=\""*id*"\"></g></g>"
        (head,mid,tail,split_ok)=Luxor.split_string_into_head_mid_tail(group,id)
        @test split_ok == false
    end
    return
end

svgstring_test()
place_svgtest("polysample.svg", "place-svg.svg")
svg_rec_format()
