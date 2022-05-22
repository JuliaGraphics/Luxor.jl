const Mesh = Cairo.CairoPattern

"""
    add_mesh_patch(pattern::Mesh, bezierpath::BezierPath,
        colors=Array{Colors.Colorant, 1})

Add a new patch to the mesh pattern in `pattern`.

The first three or four elements of the supplied `bezierpath`
define the three or four sides of the mesh shape.

The `colors` array define the color of each corner point. Colors are reused
if necessary. At least one color should be supplied.

Use `setmesh()` to select the mesh, which will be used to fill shapes.
"""
function add_mesh_patch(pattern::Mesh, bezierpath::BezierPath, colors=Array{Colors.Colorant, 1})
    Cairo.mesh_pattern_begin_patch(pattern)
    # we must do 3 or 4 vertices, so need 2, 3, and possibly 4
    if length(bezierpath) == 3
        pts = bezierpath[2:3]
        vcount = 3
    elseif length(bezierpath) >= 4
        pts = bezierpath[2:4]
        vcount = 4
    else
        throw(error("_add_mesh_patch(): patch should provide 3 or 4 points, not $(length(bezierpath))"))
    end
    # use first point
    Cairo.mesh_pattern_move_to(pattern, bezierpath[1][1].x, bezierpath[1][1].y)
    # then get next 2 or 3
    for bp in bezierpath
        Cairo.mesh_pattern_curve_to(pattern, bp[2].x, bp[2].y, bp[3].x, bp[3].y, bp[4].x, bp[4].y)
    end

    for n in 1:vcount
        # always use RGBA, even if RGB supplied
        col = convert(Colors.RGBA, parse(Colors.Colorant, colors[mod1(n, length(colors))]))
        Cairo.mesh_pattern_set_corner_color_rgba(pattern, n - 1, col.r, col.g, col.b, col.alpha)
    end
    Cairo.mesh_pattern_end_patch(pattern)
    return pattern
end

"""
    add_mesh_patch(pattern::Mesh, plist::Array{Point}, colors=Array{Colors.Colorant, 1})

Add a new patch to the mesh pattern in `pattern`.

The first three or four sides of the supplied `points` polygon
define the three or four sides of the mesh shape.

The `colors` array define the color of each corner point. Colors are reused
if necessary. At least one color should be supplied.
"""
function add_mesh_patch(pattern::Mesh, plist::Array{Point}, colors=Array{Colors.Colorant, 1})
    Cairo.mesh_pattern_begin_patch(pattern)
    # we must do 3 or 4 vertices, so need 2, 3, and possibly 4
    if length(plist) == 3
        pts = plist[2:3]
        vcount = 3
    elseif length(plist) >= 4
        pts = plist[2:4]
        vcount = 4
    else
        throw(error("_add_mesh_patch(): patch should provide 3 or 4 points, not $(length(plist))"))
    end
    # use first point
    Cairo.mesh_pattern_move_to(pattern, plist[1].x, plist[1].y)
    # then get next 2 or 3
    for pt in pts
        Cairo.mesh_pattern_line_to(pattern, pt.x, pt.y)
    end

    for n in 1:vcount
        # always use RGBA, even if RGB supplied
        col = convert(Colors.RGBA, parse(Colors.Colorant, colors[mod1(n, length(colors))]))
        Cairo.mesh_pattern_set_corner_color_rgba(pattern, n - 1, col.r, col.g, col.b, col.alpha)
    end
    Cairo.mesh_pattern_end_patch(pattern)
    return pattern
end


"""
    mesh(bezierpath::BezierPath,
         colors=Array{Colors.Colorant, 1})

Create a mesh. The first three or four elements of the supplied `bezierpath`
define the three or four sides of the mesh shape.

The `colors` array define the color of each corner point. Colors are reused
if necessary. At least one color should be supplied.

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
function mesh(bezierpath::BezierPath,
              colors=Array{Colors.Colorant, 1})
    pattern = Cairo.CairoPatternMesh()
    return add_mesh_patch(pattern, bezierpath, colors)
end

# old style for compatibility
mesh(bezierpath::Array{NTuple{4, Point}}, colors=Array{Colors.Colorant, 1}) =
    mesh(BezierPath(bezierpath), colors)

"""
    mesh(points::Array{Point},
         colors=Array{Colors.Colorant, 1})

Create a mesh.

The first three or four sides of the supplied `points` polygon
define the three or four sides of the mesh shape.

The `colors` array define the color of each corner point. Colors are reused
if necessary. At least one color should be supplied.

# Example
```
@svg begin
    pl = ngon(O, 250, 3, pi/6, vertices=true)
    mesh1 = mesh(pl, [
        "purple",
        Colors.RGBA(0.0, 1.0, 0.5, 0.5),
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
function mesh(plist::Array{Point}, colors=Array{Colors.Colorant, 1})
    pattern = Cairo.CairoPatternMesh()
    return add_mesh_patch(pattern, plist, colors)
end

"""
    setmesh(mesh::Mesh)

Select a mesh, previously created with `mesh()`, for filling
and stroking subsequent graphics.
"""
function setmesh(m::Mesh)
    Cairo.set_source(Luxor.get_current_cr(), m)
end
