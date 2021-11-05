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

struct PathClose
end

const PathElement = Union{PathCurve, PathMove, PathLine, PathClose}

"""
A Path object contains, in the `.path` field, a vector of
`PathElement`s (`PathCurve`, `PathMove`, `PathLine`,
`PathClose`) that describe a Cairo path. Use `drawpath()` to
draw it.

```
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
function Path(ptlist::Vector{Point}; close=false)
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
        return (first(cp.path), 1)
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

Base.getindex(cp::Path, r::Union{LinRange, UnitRange, StepRangeLen}) = getindex(cp.path, r)
Base.lastindex(cp::Path) = length(cp.path)

function Base.show(io::IO, cp::Path)
    println(io, "Path([")
    for p in cp.path[1:end-1]
        println(io, " $(p),")
    end
    println(io, " $(cp.path[end])")
    println(io, "])\n")
end

drawpath(cpe::PathMove) = move(cpe.pt1)
drawpath(cpe::PathLine) = line(cpe.pt1)
drawpath(cpe::PathCurve) = curve(cpe.pt1, cpe.pt2, cpe.pt3)
drawpath(cpe::PathClose) = closepath()

"""
    storepath()

Obtain the current Cairo path and make a Luxor Path object,
which is an array of PathElements.

Returns the Path object.

See also getpath and getpathflat.
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

Make the Luxor Path object stored in `cp` and apply the `action`.

By default, `startnewpath=true`, which starts a new path, discarding any existing path.
"""
function drawpath(cp::Path; action=:none, startnewpath=true)
    startnewpath && newpath()
    for p in cp
          drawpath(p)
    end
    do_action(action)
end

drawpath(cp::Path, action::Symbol; startnewpath=true) = drawpath(cp::Path; action=action, startnewpath=startnewpath)

"""
    polytopath(ptlist)

Convert a polygon to a Path object.
```julia
@draw drawpath(polytopath(ngon(O, 145, 5, vertices=true)), action=:fill)
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
@draw drawpath(polytopath(ngon(O, 145, 5, vertices=true)), action=:fill)
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
