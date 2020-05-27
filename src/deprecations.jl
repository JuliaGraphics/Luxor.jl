using Base: @deprecate

@deprecate intersection(pt1::Point, pt2::Point, pt3::Point, pt4::Point) intersectionlines(pt1::Point, pt2::Point, pt3::Point, pt4::Point)

@deprecate polytriangulate!(pt) polytriangulate(pt)

@deprecate bars(v) barchart(v)
