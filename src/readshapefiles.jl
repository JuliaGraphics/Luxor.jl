#=

Base.convert() methods to convert shapefile geometry to Luxor geometry.

Use `include()` to include this file if you've installed Shapefile.jl.

Luxor y coordinates increase downwards, but maps and shapefile coordinates increase upwards.
In the Northern hemisphere, 0 longitude is North Pole, so we negate y coordinates.

=#

# Convert a Shapefile rectangle to an array of points suitable for a Luxor rectangle
function Base.convert(::Type{Array{Luxor.Point, 1}}, R::Shapefile.Rect)
    return [R.left, R.top, R.right-R.left, R.bottom-R.top]
end

# Convert a Shapefile Point to a Luxor Point (flipping y-coordinates)
function  Base.convert(::Type{Luxor.Point}, pt::Shapefile.Point)
    return Luxor.Point(pt.x, -pt.y)
end

# Convert Shapefile PolyLine to a Luxor poly
function Base.convert(::Type{Array{Luxor.Point, 1}}, pl::Shapefile.Polyline)
    resultbbox = convert(Array{Luxor.Point, 1}, pl.MBR)
    resultpoly = Luxor.Point[]
    for pt in pl.points
        push!(resultpoly, convert(Luxor.Point, pt))
    end
    return resultbbox, resultpoly
end

# Convert Shapefile Polygon to a Luxor poly.
# some Shapefile polygons have multiple parts, but these aren't subpaths, just
# extra polygons. For example, France (in Europe) and French Guiana in (South America)
# belong to the same Shapefile.Polygon and the return value will include these and other
# polygons in the array.

function Base.convert(::Type{Array{Luxor.Point, 1}}, pl::Shapefile.Polygon)
    bbox = [Luxor.Point(pl.MBR.left, -pl.MBR.top), pl.MBR.right - pl.MBR.left, pl.MBR.top - pl.MBR.bottom]
    polygons = Array{Point, 1}[] # to hold all the polygons for a shape
    if length(pl.parts) >= 2
        points = Luxor.Point[]
        for i in 1:length(pl.parts) - 1
            subpolygonpoints = pl.points[pl.parts[i]+1: pl.parts[i + 1]]
            for pt in subpolygonpoints
                push!(points, convert(Luxor.Point, pt))
            end
            push!(polygons, points)
            points = Luxor.Point[]
        end
        # don't forget the rest
        subpolygonpoints = pl.points[pl.parts[end] + 1: end]
        for pt in subpolygonpoints
            push!(points, convert(Luxor.Point, pt))
        end
        push!(polygons, points)
    else
        points = Luxor.Point[]
        for pt in pl.points
            push!(points, convert(Luxor.Point, pt))
        end
        push!(polygons, points)
    end
    return polygons, bbox
end
