struct PathCurve
    pt1::Point
    pt2::Point
    pt3::Point
end

struct PathMove
    pt1::Point
end

struct PathLine
    pt1::Point
end

struct PathClose end

const PathElement = Union{PathCurve,PathMove,PathLine,PathClose}

"""
A Path object contains, in the `.path` field, a vector of
`PathElement`s (`PathCurve`, `PathMove`, `PathLine`,
`PathClose`) that describe a Cairo path. Use `drawpath()` to
draw it.

```julia
Path([PathMove(Point(2.0, 90.5625)),
      PathCurve(Point(4.08203, 68.16015), Point(11.28, 45.28), Point(24.8828, 26.40234)),
      PathLine(Point(2.0, 90.5625)),
      PathClose()
     ])
```
"""
struct Path
    path::Vector{PathElement}
end

"""
    Path(ptlist::Vector{Point}; close=false))

Create a Path from the points in `ptlist`.
"""
function Path(ptlist::Vector{Point};
    close = false)
    p = Path(PathElement[])
    push!(p.path, PathMove(ptlist[1]))
    for pt in ptlist[2:end]
        push!(p.path, PathLine(pt))
    end
    if close
        push!(p.path, PathClose())
    end
    return p
end

Base.size(cp::Path) = length(cp.path)
Base.length(cp::Path) = length(cp.path)
Base.getindex(cp::Path, i::Int) = cp.path[i]
Base.IndexStyle(cp::Path) = IndexLinear()
Base.setindex!(cp::Path, el, e::Integer) = setindex!(cp.path, el, e)
Base.keys(cp::Path) = keys(cp.path)
Base.eltype(::Type{Path}) = PathElement

function Base.iterate(cp::Path)
    if length(cp.path) != 0
        return (first(cp.path), 2)
    else
        return nothing
    end
end

function Base.iterate(cp::Path, state)
    if state > length(cp.path)
        return nothing
    else
        return (cp.path[state], state + 1)
    end
end

Base.getindex(cp::Path, r::Union{LinRange,UnitRange,StepRangeLen}) = getindex(cp.path, r)
Base.lastindex(cp::Path) = length(cp.path)

function Base.show(io::IO, cp::Path)
    if iszero(length(cp))
        print(io, "Path is empty")
    else
        println(io, "Path([")
        for p in cp.path[1:(end - 1)]
            println(io, " $(p),")
        end
        println(io, " $(cp.path[end])")
        println(io, "])\n")
    end
end

function drawpath(cpe::PathMove)
    move(cpe.pt1)
    return currentpoint()
end

function drawpath(cpe::PathLine)
    line(cpe.pt1)
    return currentpoint()
end

function drawpath(cpe::PathCurve)
    curve(cpe.pt1, cpe.pt2, cpe.pt3)
    return currentpoint()
end

function drawpath(cpe::PathClose)
    closepath()
end

"""
    storepath()

Obtain the current Cairo path and make a Luxor Path object,
which is an array of PathElements.

Returns the Path object.

You can draw stored paths using `drawpath()`.

See also `getpath()`, `getpathflat()`, and `textpath()`.
"""
function storepath()
    path = PathElement[]
    for e in getpath()
        if e.element_type == 0
            (x, y) = e.points
            push!(path, PathMove(Point(x, y)))
        elseif e.element_type == 1
            (x, y) = e.points
            push!(path, PathLine(Point(x, y)))
        elseif e.element_type == 2
            (x1, y1, x2, y2, x3, y3) = e.points
            push!(path, PathCurve(Point(x1, y1), Point(x2, y2), Point(x3, y3)))
        elseif e.element_type == 3
            push!(path, PathClose())
        else
            error("unknown Cairo Path Entry " * repr(e.element_type))
            error("unknown Cairo Path Entry " * repr(e.points))
        end
    end
    return Path(path)
end

"""
    drawpath(cp::Path; action=:none, startnewpath=true)
    drawpath(cp::Path, action; startnewpath=true)

Make the Luxor path stored in `cp` and apply the `action`.

To make paths, follow some path construction functions such
as `move()`, `line()`, and `curve()` with the `storepath()`
function.

By default, `startnewpath=true`, which starts a new path,
discarding any existing path contents.
"""
function drawpath(cp::Path;
    action = :none, startnewpath = true)
    startnewpath && newpath()
    for p in cp
        drawpath(p)
    end
    do_action(action)
    return currentpoint()
end

drawpath(cp::Path, action::Symbol; startnewpath = true) =
    drawpath(cp::Path; action = action, startnewpath = startnewpath)

"""
    polytopath(ptlist)

Convert a polygon to a Path object.

```julia
@draw drawpath(polytopath(ngon(O, 145, 5, vertices = true)), action = :fill)
```
"""
function polytopath(ptlist::Vector{Point})
    path = PathElement[]
    push!(path, PathMove(ptlist[1]))
    for pt in ptlist[2:end]
        push!(path, PathLine(pt))
    end
    push!(path, PathClose())
    return Path(path)
end
"""
    bezierpathtopath(bp::BezierPath)

Convert a Bezier path to a Path object.

```julia
@draw drawpath(polytopath(ngon(O, 145, 5, vertices = true)), action = :fill)
```
"""
function bezierpathtopath(bp::BezierPath)
    path = PathElement[]
    push!(path, PathMove(first(first(bp))))
    for p in bp
        push!(path, PathCurve(p[2], p[3], p[4]))
    end
    return Path(path)
end

"""
    BoundingBox(path::Path)

Find bounding box of a stored Path (made with `storepath()`).
"""
function BoundingBox(path::Path)
    # start with empty bbox, grow it using points in path
    counter = 0
    bbox = BoundingBox(O, O)
    currentpoint = O
    for p in path
        counter += 1
        if p isa PathMove
            if isapprox(boxdiagonal(bbox), 0.0) # bbox empty?
                bbox = BoundingBox(p.pt1, p.pt1)
            else
                bbox += BoundingBox(currentpoint, p.pt1)
            end
            currentpoint = p.pt1
        elseif p isa PathLine
            if isapprox(boxdiagonal(bbox), 0.0) # bbox empty?
                bbox = BoundingBox(currentpoint, p.pt1)
            else
                bbox += BoundingBox(currentpoint, p.pt1)
            end
            currentpoint = p.pt1
        elseif p isa PathCurve
            phbbox = BoundingBox(Luxor.get_bezier_points(BezierPathSegment(currentpoint, p.pt1, p.pt2, p.pt3)))
            if isapprox(boxdiagonal(bbox), 0.0) # bbox empty?
                bbox = phbbox
            else
                bbox += phbbox
            end
            currentpoint = p.pt3
        end
    end
    return bbox
end

"""
    get_bezier_points(bps::BezierPathSegment;
        steps=10)

The flattening: return a list of all the points on the
Bezier curve, including start and end, using `steps` to
determine the accuracy.
"""
function get_bezier_points(bps::BezierPathSegment;
    steps = 10)
    return bezier.(range(0.0, 1.0, length = steps), Ref.(tuple(bps...))...)
end

"""
    get_bezier_length(bps::BezierPathSegment;
        steps=10)

Return the length of a BezierPathSegment, using `steps` to
determine the accuracy, by stepping  through the curve and
finding all the points,  and then measuring between them.

This is obviously just an approximation; the maths to do
it properly is too difficult for me. :(
"""
function get_bezier_length(bps::BezierPathSegment;
    steps = 10)
    LUT = get_bezier_points(bps, steps = steps)
    curvelength = 0.0
    for i in 1:(length(LUT) - 1)
        curvelength += distance(LUT[i], LUT[mod1(i + 1, end)])
    end
    return curvelength
end

"""
    pathlength(path::Path;
        steps=10)

Return the length of a Path.

The `steps` parameter is used when approximating the length of any curve (Bezier) sections.
"""
function pathlength(path::Path;
    steps = 10)
    currentpoint = O
    firstpoint = currentpoint
    plength = 0.0
    for pathelement in path
        if pathelement isa PathMove # pt1
            firstpoint = pathelement.pt1
            currentpoint = pathelement.pt1
        elseif pathelement isa PathCurve # pt1 pt2  pt3
            plength += get_bezier_length(BezierPathSegment(currentpoint, pathelement.pt1, pathelement.pt2, pathelement.pt3), steps = steps)
            currentpoint = pathelement.pt3
        elseif pathelement isa PathLine  # pt1
            plength += distance(currentpoint, pathelement.pt1)
            currentpoint = pathelement.pt1
        elseif pathelement isa PathClose
            # I think Close is just drawing to the point established by previous Move...
            plength += distance(firstpoint, currentpoint)
        end
    end
    return plength
end

"""
    drawpath(path::Path, k::Real;
        steps=10, # used when approximating Bezier curve segments
        action=:none,
        startnewpath=true,
        pathlength = 0.0)

Draw the path in `path` starting at the beginning and
stopping at `k` between 0 and 1. So if `k` is 0.5, half the
path is drawn.

Returns the last point processed.

The function calculates the length of the entire path before
drawing it. If you want to draw a large path more than once,
it might be more efficient to calculate the length of the
path first, and provide it to the `pathlength` keyword.

The `steps` parameter is used when approximating the length of any curve
(Bezier) sections. Higher values will be more accurate.
"""
function drawpath(path::Path, k::Real;
    steps = 20, # used when approximating Bezier curve segments
    action = :none,
    startnewpath = true,
    pathlength = 0.0)
    if iszero(pathlength)
        pathlength = Luxor.pathlength(path)
    end
    requiredlength = clamp(k, 0.0, 1.0) * pathlength
    currentlength = 0
    startnewpath && newpath()
    # firstpoint is the point we will return to for a Close
    # currentposition is our current position
    # mostrecentpoint is the point we last visited
    finished = false
    currentposition = mostrecentpoint = firstpoint = O
    for pathelement in path
        #info "path element is ", pathelement
        currentlength > requiredlength && (finished = true)
        if pathelement isa PathMove # pt1
            currentposition = firstpoint = pathelement.pt1
            drawpath(pathelement)
            # remember how far we've got
            mostrecentpoint = Luxor.currentpoint()
        elseif pathelement isa PathCurve # pt1 pt2 pt3
            plength = Luxor.get_bezier_length(BezierPathSegment(currentposition, pathelement.pt1, pathelement.pt2, pathelement.pt3), steps = steps)
            if (currentlength + plength) > requiredlength
                # we mustn't draw all of this curve, since it overshoots
                # just draw the overshoot fraction of the curve
                overshoot = (requiredlength - currentlength) / plength
                bps = BezierPathSegment(currentposition, pathelement.pt1, pathelement.pt2, pathelement.pt3)
                newbezier = trimbezier(bps, 0, overshoot)
                # using the last three for this Bezier
                # currentposition is the first pt
                drawpath(PathCurve(newbezier[2], newbezier[3], newbezier[4]))
                mostrecentpoint = newbezier[4]
                # don't do any more
                finished = true
            else
                drawpath(pathelement)
                mostrecentpoint = pathelement.pt3
                currentlength += plength
                # update currentposition
                currentposition = mostrecentpoint
            end
        elseif pathelement isa PathLine  # pt1
            plength = distance(currentposition, pathelement.pt1)
            currentlength += plength
            if currentlength > requiredlength
                # we mustn't draw all of this line, since it overshoots
                overshoot = (currentlength - requiredlength) / plength
                # just draw the overshoot fraction of the line
                drawpath(PathLine(between(currentposition, pathelement.pt1, 1 - overshoot)))
                # don't do any more
                finished = true
            else
                drawpath(pathelement)
            end
            mostrecentpoint = Luxor.currentpoint()
            currentposition = pathelement.pt1
        elseif pathelement isa PathClose
            # same as Line, want to animate the closing line too
            plength = distance(currentposition, firstpoint)
            currentlength += plength
            if currentlength > requiredlength
                # we mustn't draw all of this line, since it overshoots
                overshoot = (currentlength - requiredlength) / plength
                # just draw the overshoot fraction of the line
                drawpath(PathLine(between(currentposition, firstpoint, 1 - overshoot)))
            else
                drawpath(PathLine(firstpoint))
                closepath() # ???
            end
            mostrecentpoint = Luxor.currentpoint()
        end
        if finished == true
            break
        end
    end
    do_action(action)
    return mostrecentpoint
end
drawpath(path::Path, k::Real, act::Symbol;
    steps = 10, # used when approximating Bezier curve segments
    startnewpath = true,
    pathlength = 0.0) = drawpath(path, k;
        steps = steps,
        action = act,
        startnewpath = startnewpath,
        pathlength = pathlength)

"""
    pathsample(path::Path, spacing;
        steps=10)

Return a new Path that resamples the `path` such that each
line and curve of the original path is divided into sections
that are approximately `spacing` units long.

The `steps` parameter is used when approximating the length
of any curve (Bezier) sections. For measurement purposes,
each Bezier curve is divided in `steps` straight lines; the
error will be smaller for flatter curves and larger for more
curvy ones.
"""
function pathsample(path::Path, spacing;
    steps = 10)
    isapprox(spacing, 0.0) && throw(error("pathsample(): a spacing of $(spacing) is too close to zero"))
    newpath = PathElement[]
    currentpoint = O
    firstpoint = currentpoint
    for pathelement in path
        if pathelement isa PathMove # pt1
            push!(newpath, pathelement)
            firstpoint = pathelement.pt1
            currentpoint = pathelement.pt1
        elseif pathelement isa PathCurve # pt1 pt2 pt3
            bps = BezierPathSegment(currentpoint,
                pathelement.pt1,
                pathelement.pt2,
                pathelement.pt3)
            plength = Luxor.get_bezier_length(bps, steps = steps)
            _step = spacing / plength
            for i in range(0.0, 1.0 - _step, step = _step)
                bezsegment = trimbezier(bps, i, i + _step)
                push!(newpath, PathCurve(bezsegment.cp1, bezsegment.cp2, bezsegment.p2))
            end
            currentpoint = pathelement.pt3
        elseif pathelement isa PathLine  # pt1
            plength = distance(currentpoint, pathelement.pt1)
            _step = spacing / plength
            for i in range(0.0, 1.0, step = _step)
                push!(newpath, PathLine(between(currentpoint, pathelement.pt1, i)))
            end
            currentpoint = pathelement.pt1
        elseif pathelement isa PathClose
            # I think Close is just drawing to the point established by previous Move...
            plength = distance(currentpoint, firstpoint)
            if !iszero(plength)
                _step = spacing / plength
                for i in range(0.0, 1.0, step = _step)
                    push!(newpath, PathLine(between(currentpoint, firstpoint, i)))
                end
            end
            push!(newpath, PathLine(firstpoint))
        end
    end
    return Path(newpath)
end
