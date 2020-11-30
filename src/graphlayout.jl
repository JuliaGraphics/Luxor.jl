# these graph layout functions are experimental and mostly for decorative purposes
# adapted from various places, modified for use with Luxor

#= Example of spring layout

using Luxor, LightGraphs, Combinatorics

g = smallgraph(:moebiuskantor)

# spring layout

x, y = layoutgraph(Array(adjacency_matrix(g)),
    densityconstant    = 20,
    maxiterations      = 50,
    initialtemperature = 10)

@draw begin
    pts = Point.(zip(x, y))
    circle.(pts, 15, :fill)
    for p in combinations(pts, 2)
        randomhue()
        arrow(p[1], p[2],  decorate = () -> ngon(O, 10, 3, 0, :fill))
    end
end

=#

"""
    layoutgraph(adj_matrix::Array{T,2}; kwargs...)       <--
    layoutgraph(adj_list::AbstractVector; kwargs...)     not yet implemented

Run one of two graph layout algorithms.

1: Layout the graph in adjacency matrix `adj_matrix`, using
a spring-based method. Returns a tuple of `([xcoords],
[ycoords])`, which are scaled according to the supplied
BoundingBox.

### Keyword arguments

Lay out the graph in `adjmatrix` using the spring/repulsion
model of Fruchterman and Reingold (1991). Returns a tuple of
`([xcoords], [ycoords])`.

## Arguments

`am` An adjacency matrix of some type. Non-zero of the
eltype of the matrix is used to determine if a link exists,
but currently no sense of magnitude

`densityconstant` Constant to adjust the density of
resulting layout. The default value is 2.0.

`maxiterations` how many iterations for applying the forces

`initialtemperature` the initial temperature controls
movement per iteration. The default value is 2.0. Each
iteration uses a lower temperature (TEMP =
initialtemperature / iter). The idea is that the
displacements of vertices are limited to some maximum
temperature value, and this decreases over time. As the
layout becomes better, the amount of adjustment becomes
smaller.

`locs_x` the starting x values, between -1 and 1. The
default values are randomly selected.

`locs_y` the starting y values, between -1 and 1. The
default values are randomly selected.

`boundingbox` The Luxor BoundingBox into which the graph's
coordinates will fit. Defaults to 500 × 500.

"""
layoutgraph(am::Array{T,2} where T; kwargs...) = layout_spring(am; kwargs...)

"""
    layoutgraph(adj_matrix::Array{T,2}; kwargs...)
    layoutgraph(adj_list::AbstractVector; kwargs...)      <--

2: Layout the graph in adjacency list `adj_list`, assuming
the graph is a tree layout with a single root node. Return a
list of Luxor points that can be used to lay out the nodes
of the tree.

### Keyword arguments

```nodesize=ones(size(adjlist, 1)))```

`nodesize` is a vector of values that define the area
occupied by each node. No idea how it works yet...

Return a list of Luxor points that can be used to lay out a
tree defined in adjacency list `adjlist`. """

layoutgraph(al::AbstractVector; kwargs...) = layout_tree(al;
kwargs...)

"""
    layout_spring(adjmatrix::Array{T,2} where T;
        densityconstant = 2.0,
        maxiterations = 100,
        initialtemperature = 2.0,
        boundingbox=BoundingBox(O - (250, 250), O + (250, 250)))

"""
function layout_spring(adjmatrix::Array{T,2} where T;
    densityconstant = 2.0,
    maxiterations = 100,
    initialtemperature = 2.0,
    locs_x = 2rand(size(adjmatrix, 1)) .- 1.0,
    locs_y = 2rand(size(adjmatrix, 1)) .- 1.0,
    boundingbox =  BoundingBox(O - (250, 250), O + (250, 250)))

    N = size(adjmatrix, 1)
    if N != size(adjmatrix, 2)
        error("Adjacency matrix must be square but is $(size(adjmatrix)).")
    end

    # randomize results arrays, normalized to between -1 and 1

    # the optimal distance bewteen normalized vertices
    K = densityconstant * sqrt(4.0 / N)

    # store forces and apply at end of iteration all at once
    force_x = zeros(N)
    force_y = zeros(N)

    @inbounds for iter in 1:maxiterations
        # Calculate forces
        for i in 1:N
            force_vec_x = 0.0
            force_vec_y = 0.0
            for j in 1:N
                i == j && continue
                d_x = locs_x[j] - locs_x[i]
                d_y = locs_y[j] - locs_y[i]
                d   = sqrt(d_x^2 + d_y^2)
                if adjmatrix[i,j] != zero(eltype(adjmatrix)) || adjmatrix[j,i] != zero(eltype(adjmatrix))
                    F_d = d^2 / K
                else
                    # Just repulsive
                    F_d = -K^2 / d
                end
                force_vec_x += F_d * d_x
                force_vec_y += F_d * d_y
            end
            force_x[i] = force_vec_x
            force_y[i] = force_vec_y
        end
        # Cool down
        TEMP = initialtemperature / iter
        # apply but limit to temperature
        for i = 1:N
            force_mag  = sqrt(force_x[i] ^ 2 + force_y[i] ^ 2)
            scale      = min(force_mag, TEMP)/force_mag
            locs_x[i] += force_x[i] * scale
            locs_y[i] += force_y[i] * scale
        end
    end

    # fit to bounding box argument
    min_x, max_x = boxbottomleft(boundingbox).x, boxbottomright(boundingbox).x
    min_y, max_y = boxtopleft(boundingbox).y, boxbottomleft(boundingbox).y

    return (
        rescale.(locs_x, extrema(locs_x)..., min_x, max_x),
        rescale.(locs_y, extrema(locs_y)..., min_y, max_y)
        )
end

"""
   layout_tree(adjlist)

`adj_list` must not be cyclic, otherwise welcome to stack overflow...
"""
function layout_tree(adj_list::AbstractVector)
    return _layout_tree(adj_list)
end
