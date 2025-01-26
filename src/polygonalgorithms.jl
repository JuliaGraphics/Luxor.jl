# using algorithms from PolygonAlgorithms.jl

@inline _point_to_tuple(pt::Point) = (pt.x, pt.y)
@inline _points_to_tuples(pts::Vector{Point}) = _point_to_tuple.(pts)
@inline _tuples_to_points(t::Vector{Tuple{Float64,Float64}}) = [Point(t[1], t[2]) for t in t]

"""
    polyarea(plist::Vector{Point}))

Find the area of a simple polygon. It works only for polygons that don't
self-intersect. See also `polyorientation()`.
"""
polyarea(p::Vector{Point}) = PA.area_polygon(_points_to_tuples(p))

"""
    isinside(p::Point, pointlist::Vector{Point}
        allowonedge = false)

Is a point `p` inside a polygon `pointlist`?

If `allowonedge` is false, a point lying on the polygon is not inside.

Returns true if it does, or false.
"""
isinside(pt::Point, pgon::Vector{Point}; allowonedge = false, rtol=AbstractFloat=1e-10) =
    PA.contains(_points_to_tuples(pgon), _point_to_tuple(pt),
         on_border_is_inside = allowonedge, rtol=rtol)

"""
    polyhull(ptspgon::Vector{Point})

Find all points in `pts` that form a convex hull around the
points in `pts`, and return them.

This uses the Graham Scan algorithm.
"""
function polyhull(pgon::Vector{Point};
    algorithm=PA.GrahamScanAlg())
    # in PA alg can either be GiftWrappingAlg() or GrahamScanAlg().
    return pgon[PA.convex_hull(_points_to_tuples(pgon), algorithm)]
end

"""
    polycentroid(pts::Vector{Point}))

Find the centroid of a simple polygon.

Returns a point. This only works for simple (non-intersecting) polygons.

You could test the point using `isinside()`.
"""
function polycentroid(pts::Vector{Point})
    return Point(PA.centroid_polygon(_points_to_tuples(pts)))
end

# the PA version gives the opposite value... :) 
# ispolyclockwise(pts::Vector{Point}) = PA.is_clockwise(_points_to_tuples(pts))

"""
    polyintersectconvex(p1::AbstractVector{Point}, p2::AbstractVector{Point})

Use `polyintersect()`.
"""
function polyintersectconvex(p1::AbstractVector{Point}, p2::AbstractVector{Point})
    # `alg` can either be `ChasingEdgesAlg()`, `PointSearchAlg()` or `WeilerAthertonAlg()`.
    return _tuples_to_points(
        PA.intersect_convex(_points_to_tuples(p1), _points_to_tuples(p2)))
end

"""
    polyintersect(pgon1::AbstractVector{Point}, pgon2::AbstractVector{Point})

Return an array (possibly empty) containing the polygon(s) that define
the intersection between the two polygons, `pgon1` and `pgon2`.

The `pgon1` and `pgon2` polygons must not have holes, and cannot be
self-intersecting.
"""
function polyintersect(pgon1::AbstractVector{Point}, pgon2::AbstractVector{Point})
    return _tuples_to_points.(
        PA.intersect_geometry(_points_to_tuples(pgon1), _points_to_tuples(pgon2))
    )
end

polyintersections(S::Vector{Point}, C::Vector{Point}) = polyintersect(S, C)

"""
    polydifference(pgon1::AbstractVector{Point}, pgon2::AbstractVector{Point})

Find polygonal areas that are inside `pg1` but not in `pg2`.
"""
function polydifference(pg1::AbstractVector{Point}, pg2::AbstractVector{Point})
    return Luxor._tuples_to_points.(PA.difference_geometry(Luxor._points_to_tuples(pg1),
        Luxor._points_to_tuples(pg2), PA.MartinezRuedaAlg()))
end

"""
    polyunion(pgon1::AbstractVector{Point}, pgon2::AbstractVector{Point})

Find polygonal areas that are inside `pg1` or in `pg2`.

Return an array of polygons.

Boolean Union.
"""
function polyunion(pg1::AbstractVector{Point}, pg2::AbstractVector{Point})
    return Luxor._tuples_to_points.(PA.union_geometry(Luxor._points_to_tuples(pg1),
        Luxor._points_to_tuples(pg2), PA.MartinezRuedaAlg()))
end

"""
    polyxor(pgon1::AbstractVector{Point}, pgon2::AbstractVector{Point})

Find polygon areas that are inside either `pg1` or `pg2`, but not both.

Return an array of polygons.

Boolean XOR.

Possibly returns holes but does not classify them as holes.
"""
function polyxor(pg1, pg2)
    return Luxor._tuples_to_points.(PA.xor_geometry(Luxor._points_to_tuples(pg1),
        Luxor._points_to_tuples(pg2), PA.MartinezRuedaAlg()))
end
