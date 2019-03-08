using Base: @deprecate

@deprecate intersection(pt1::Point, pt2::Point, pt3::Point, pt4::Point) intersectionlines(pt1::Point, pt2::Point, pt3::Point, pt4::Point)

@deprecate seednoise(a::Array{Int64}) seedpatentednoise()
