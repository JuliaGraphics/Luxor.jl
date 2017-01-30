"""
    rect(xmin, ymin, w, h, action)

Create a rectangle with one corner at (`xmin`/`ymin`) with width `w` and height `h` and then
do an action.

See `box()` for more ways to do similar things, such as supplying two opposite corners,
placing by centerpoint and dimensions.
"""
function rect(xmin, ymin, w, h, action=:nothing)
    if action != :path
        newpath()
    end
    Cairo.rectangle(currentdrawing.cr, xmin, ymin, w, h)
    do_action(action)
end

"""
    rect(cornerpoint, w, h, action)

Create a rectangle with one corner at `cornerpoint` with width `w` and height `h` and do an
action.
"""
function rect(cornerpoint::Point, w, h, action)
    rect(cornerpoint.x, cornerpoint.y, w, h, action)
end

"""
    box(cornerpoint1, cornerpoint2, action=:nothing)

Create a rectangle between two points and do an action.
"""
function box(corner1::Point, corner2::Point, action=:nothing)
    rect(corner1.x, corner1.y, corner2.x - corner1.x, corner2.y - corner1.y, action)
end

"""
    box(points::Array, action=:nothing)

Create a box/rectangle using the first two points of an array of Points to defined
opposite corners.
"""
function box(bbox::Array, action=:nothing)
    box(bbox[1], bbox[2], action)
end

"""
    box(pt::Point, width, height, action=:nothing; vertices=false)

Create a box/rectangle centered at point `pt` with width and height. Use `vertices=true` to
return an array of the four corner points rather than draw the box.
"""
function box(pt::Point, width, height, action=:nothing; vertices=false)
    if vertices
        return [Point(pt.x - width/2, pt.y + height/2),
                Point(pt.x - width/2, pt.y - height/2),
                Point(pt.x + width/2, pt.y - height/2),
                Point(pt.x + width/2, pt.y + height/2)]
    end
    rect(pt.x - width/2, pt.y - height/2, width, height, action)
end

"""
    box(x, y, width, height, action=:nothing)

Create a box/rectangle centered at point `x/y` with width and height.
"""
function box(x, y, width, height, action=:nothing)
    rect(x - width/2.0, y - height/2.0, width, height, action)
end
