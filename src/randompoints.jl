function randomordinate(low, high)
    if low > high
      low, high = high, low
    end
    return low + rand() * abs(high - low)
end

"""
    randompoint(lowpt, highpt)

Return a random point somewhere inside the rectangle defined by the two points.
"""
function randompoint(lowpt::Point, highpt::Point)
  Point(randomordinate(lowpt.x, highpt.x), randomordinate(lowpt.y, highpt.y))
end

"""
    randompoint(lowx, lowy, highx, highy)

Return a random point somewhere inside a rectangle defined by the four values.
"""
function randompoint(lowx, lowy, highx, highy)
    Point(randomordinate(lowx, highx), randomordinate(lowy, highy))
end

"""
    randompointarray(lowpt, highpt, n)

Return an array of `n` random points somewhere inside the rectangle defined by two points.
"""
function randompointarray(lowpt::Point, highpt::Point, n)
  array = Point[]
  for i in 1:n
    push!(array, randompoint(lowpt, highpt))
  end
  array
end

"""
    randompointarray(lowx, lowy, highx, highy, n)

Return an array of `n` random points somewhere inside the rectangle defined by the four
coordinates.
"""
function randompointarray(lowx, lowy, highx, highy, n)
    array = Point[]
    for i in 1:n
        push!(array, randompoint(lowx, lowy, highx, highy))
    end
    array
end

# internal function used by Poisson disk sampling below
"""
_empty_neighbourhood(sample, w, h, cellsize, d, points, grid)

Uses entries in `grid` to check whether the `sample`
point is more than `d` units away from any other point
in `points`.

The region we're analyzing lies between the origin and
`Point(w, h)``.
"""
function _empty_neighbourhood(sample::Point, w, h, cellsize, d, points::Array{Point, 1}, grid)
    if sample.x >= 0 &&
            sample.x < w &&
            sample.y >= 0 &&
            sample.y < h
        cellx    = 1 + convert(Int, ceil(sample.x/cellsize))
        celly    = 1 + convert(Int, ceil(sample.y/cellsize))
        _w, _h   = size(grid)
        sstartx  = max(1, cellx - 2)
        sfinishx = min(cellx + 2, _w)
        sstarty  = max(1, celly - 2)
        sfinishy = min(celly + 2, _h)
        for x in sstartx:sfinishx
            for y = sstarty:sfinishy
                ptindex = grid[x, y]
                if ptindex > 0
                    dist = distance(sample, points[ptindex])
                    if dist < d
                        return false
                    end
                end
            end
        end
        return true
    end
    return false
end

"""
    randompointarray(w, h, d; attempts=20)

Return an array of randomly positioned points inside the
rectangle defined by the current origin (0/0) and the
`width` and `height`. `d` determines the minimum
distance between each point. Increase `attempts` if you want
the function to try harder to fill empty spaces; decrease it
if it's taking too long to look for samples that work.

This uses Bridson's Poisson Disk Sampling algorithm:
https://www.cs.ubc.ca/~rbridson/docs/bridson-siggraph07-poissondisk.pdf

## Example

```julia
for pt in randompointarray(BoundingBox(), 20)
    randomhue()
    circle(pt, 10, :fill)
end
```
"""
function randompointarray(w, h, d;
        attempts=20)
    cellsize = d/sqrt(2)
    grid = zeros(Int,
        convert(Int, ceil(w/cellsize)),
        convert(Int, ceil(h/cellsize)))
    points = Point[]
    activepoints = Point[]
    # start with point in middle
    push!(activepoints, Point(w/2, h/2))
    while !isempty(activepoints)
        random_index = rand(1:length(activepoints))
        sample_center = activepoints[random_index]
        sample_added = false
        for i in 1:attempts
            angle = rand() * 2π
            dir = (sin(angle), cos(angle))
            sample = sample_center + dir .* (d + rand() * d)
            if _empty_neighbourhood(sample, w, h, cellsize, d, points, grid)
                push!(points, sample)
                push!(activepoints, sample)
                grid[convert(Int, ceil(sample.x/cellsize)), convert(Int, ceil(sample.y/cellsize))] = length(points)
                sample_added = true
                break
            end
        end
        if !sample_added
            deleteat!(activepoints, random_index)
        end
    end
    return points
end

"""
    randompointarray(bbox::BoundingBox, d; attempts=20)

Return an array of randomly positioned points inside the
bounding box `d` units apart.
"""
function randompointarray(bbox::BoundingBox, d; kwargs...)
    bw = boxwidth(bbox)
    bh = boxheight(bbox)
    return randompointarray(bw, bh, d; kwargs...) .- Ref(Point(bw/2, bh/2))
end
