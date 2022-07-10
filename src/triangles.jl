"""
    trianglecircumcenter(pt1::Point, pt2::Point, pt3::Point)

Return the circumcenter of the triangle defined by `pt1`,
`pt2`, and `pt3`. The circumcenter is the center of a circle
that passes through the vertices of the triangle.

"""
function trianglecircumcenter(pt1::Point, pt2::Point, pt3::Point)
    d = 2(pt1.x * (pt2.y - pt3.y) + pt2.x * (pt3.y - pt1.y) + pt3.x * (pt1.y - pt2.y))
    x = ((pt1.x^2 + pt1.y^2) * (pt2.y - pt3.y) + (pt2.x^2 + pt2.y^2) * (pt3.y - pt1.y) + (pt3.x^2 + pt3.y * pt3.y) * (pt1.y - pt2.y)) / d
    y = ((pt1.x^2 + pt1.y^2) * (pt3.x - pt2.x) + (pt2.x^2 + pt2.y^2) * (pt1.x - pt3.x) + (pt3.x^2 + pt3.y * pt3.y) * (pt2.x - pt1.x)) / d
    return Point(x, y)
end

"""
    triangleincenter(pt1::Point, pt2::Point, pt3::Point)

Return the incenter of the triangle defined by `pt1`, `pt2`,
and `pt3`. The incenter is the center of a circle inscribed
inside the triangle.
"""
function triangleincenter(pt1::Point, pt2::Point, pt3::Point)
    a = distance(pt2, pt3)
    b = distance(pt1, pt3)
    c = distance(pt1, pt2)
    x = ((a * pt1.x) + (b * pt2.x) + (c * pt3.x)) / (a + b + c)
    y = ((a * pt1.y) + (b * pt2.y) + (c * pt3.y)) / (a + b + c)
    return Point(x, y)
end

"""
    trianglecenter(pt1::Point, pt2::Point, pt3::Point)

Return the centroid of the triangle defined by `pt1`, `pt2`, and `pt3`.
"""
function trianglecenter(pt1::Point, pt2::Point, pt3::Point)
    return 1/3 * (pt1 + pt2  + pt3)
end

"""
    triangleorthocenter(pt1::Point, pt2::Point, pt3::Point)

Return the orthocenter of the triangle defined by `pt1`, `pt2`, and `pt3`.
"""
function triangleorthocenter(pt1::Point, pt2::Point, pt3::Point)
    return pt1 + pt2 + pt3 - 2trianglecircumcenter(pt1, pt2, pt3)
end
