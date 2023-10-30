# using algorithms from PolygonAlgorithms.jl

#= which exports" 
Point2D, Polygon2D, Segment2D, Line2D get_orientation, Orientation, on_segment
area_polygon, first_moment, centroid_polygon, is_counter_clockwise, is_clockwise
point_in_polygon do_intersect, intersect_geometry, intersect_edges
intersect_convex convex_hull
=# 

@inline _point_to_tuple(pt::Point) = (pt.x, pt.y)
@inline _points_to_tuples(pts::Vector{Point}) = _point_to_tuple.(pts)
@inline _tuples_to_points(t::Vector{Tuple{Float64,Float64}}) = [Point(t[1], t[2]) for t in t]

"""
    polyarea(plist::Array{Point,1}))

Find the area of a simple polygon. It works only for polygons that don't
self-intersect. See also `polyorientation()`.
"""
polyarea(p::Array{Point,1}) = PA.area_polygon(_points_to_tuples(p))

"""
    isinside(p::Point, pointlist::Array{Point,1}
        allowonedge = false)

Is a point `p` inside a polygon `pointlist`? 

If `allowonedge` is false, a point lying on the polygon is not inside.

Returns true if it does, or false.
"""
isinside(pt::Point, pgon::Array{Point,1}; allowonedge = false) = 
    PA.point_in_polygon(_point_to_tuple(pt), _points_to_tuples(pgon);
        on_border_is_inside = allowonedge)

"""
    polyhull(ptspgon::Array{Point,1})

Find all points in `pts` that form a convex hull around the
points in `pts`, and return them.

This uses the Graham Scan algorithm.
"""
function polyhull(pgon::Array{Point,1};
    algorithm=PA.GrahamScanAlg())
    # in PA alg can either be GiftWrappingAlg() or GrahamScanAlg().
    return pgon[PA.convex_hull(_points_to_tuples(pgon), algorithm)]
end

"""
    polycentroid(pts::Array{Point,1}))

Find the centroid of a simple polygon.

Returns a point. This only works for simple (non-intersecting) polygons.

You could test the point using `isinside()`.
"""
function polycentroid(pts::Array{Point,1})
    return Point(PA.centroid_polygon(_points_to_tuples(pts)))
end

# the PA version gives the opposite value... :) 
# ispolyclockwise(pts::Array{Point,1}) = PA.is_clockwise(_points_to_tuples(pts))

"""
    polyintersectconvex(p1::AbstractArray{Point,1}, p2::AbstractArray{Point,1})

Use `polyintersect()`.
"""
function polyintersectconvex(p1::AbstractArray{Point,1}, p2::AbstractArray{Point,1})
    # `alg` can either be `ChasingEdgesAlg()`, `PointSearchAlg()` or `WeilerAthertonAlg()`.
    return _tuples_to_points(
        PA.intersect_convex(_points_to_tuples(p1), _points_to_tuples(p2)))
end

"""
    polyintersect(pgon1::AbstractArray{Point, 1}, pgon2::AbstractArray{Point, 1};
        closed=true)

Return an array (possibly empty) containing the polygon(s) that define  
the intersection between the two polygons, `pgon1` and `pgon2`.

The `pgon1` and `pgon2` polygons must not have holes, and cannot be 
self-intersecting.
"""
function polyintersect(pgon1::AbstractArray{Point,1}, pgon2::AbstractArray{Point,1})
    return _tuples_to_points.(
        PA.intersect_geometry(_points_to_tuples(pgon1), _points_to_tuples(pgon2))
    )
end

polyintersections(S::Array{Point,1}, C::Array{Point,1}) = 
    polyintersect(S, C)
