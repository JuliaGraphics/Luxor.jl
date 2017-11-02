const Mesh = Cairo.CairoPattern

"""
    mesh(bezierpath::AbstractArray{NTuple{4,Point}},
         colors=AbstractArray{ColorTypes.Colorant, 1})

Create a mesh. The first four (or three) points of the `bezierpath` define
the four curves that define the shape of the mesh.

The `colors` array define the color of each corner point.

Use `setmesh()` to select the mesh, which will be used to fill shapes.

# Example

```
@svg begin
    bp = makebezierpath(ngon(O, 50, 4, 0, vertices=true))
    mesh1 = mesh(bp, [
        "red",
        Colors.RGB(0, 1, 0),
        Colors.RGB(0, 1, 1),
        Colors.RGB(1, 0, 1)
        ])
    setmesh(mesh1)
    box(O, 500, 500, :fill)
end
```
"""
function mesh(bezierpath::AbstractArray{NTuple{4,Point}},
              colors=AbstractArray{ColorTypes.Colorant, 1})
    pattern = Cairo.CairoPatternMesh()
    Cairo.mesh_pattern_begin_patch(pattern)
    c = bezierpath[1]
    c1 = c[1]
    Cairo.mesh_pattern_move_to(pattern, c1.x, c1.y)
    for (n, bp) in enumerate(bezierpath)
        n > 4 && break
        c = bp
        c1 = c[1]
        c2 = c[2]
        c3 = c[3]
        c4 = c[4]
        Cairo.mesh_pattern_curve_to(pattern, c2.x, c2.y, c3.x, c3.y, c4.x, c4.y)
    end
    if length(colors) > 0
        for (n, c) in enumerate(colors)
            # always use RGBA
            col = convert(Colors.RGBA, parse(Colors.Colorant, colors[mod1(n, length(colors))]))
            Cairo.mesh_pattern_set_corner_color_rgba(pattern, n - 1, col.r, col.g, col.b, col.alpha)
        end
    end
	Cairo.mesh_pattern_end_patch(pattern)
    return pattern
end

"""
    mesh(points::AbstractArray{Point},
         colors=AbstractArray{ColorTypes.Colorant, 1})

Create a mesh. The points define the sides that define the shape of the mesh.

# Example
```
@svg begin
    pl = ngon(O, 250, 3, pi/6, vertices=true)
    mesh1 = mesh(pl, [
        "purple",
        "green",
        "yellow"
        ])
    setmesh(mesh1)
    setline(180)
    ngon(O, 250, 3, pi/6, :strokepreserve)
    setline(5)
    sethue("black")
    strokepath()
end
```
"""
function mesh(plist::AbstractArray{Point},
              colors=AbstractArray{ColorTypes.Colorant, 1})
    pattern = Cairo.CairoPatternMesh()
    Cairo.mesh_pattern_begin_patch(pattern)
    Cairo.mesh_pattern_move_to(pattern, plist[1].x, plist[1].y)
    for (n, pt) in enumerate(plist[2:end])
        n > 4 && break
        Cairo.mesh_pattern_line_to(pattern, pt.x, pt.y)
    end
    if length(colors) > 0
        for (n, c) in enumerate(colors)
            col = convert(Colors.RGBA, parse(Colors.Colorant, colors[mod1(n, length(colors))]))
            Cairo.mesh_pattern_set_corner_color_rgba(pattern, n - 1, col.r, col.g, col.b, col.alpha)
        end
    end
	Cairo.mesh_pattern_end_patch(pattern)
    return pattern
end

"""
    setmesh(mesh::Mesh)

Select a mesh previously created with `mesh()` for filling shapes.
"""
function setmesh(m::Mesh)
    Cairo.set_source(currentdrawing.cr, m)
end
