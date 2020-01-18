# these graph layout functions are experimental and mostly for decorative purposes
# adapted from various places, modified for use with Luxor

"""
    layoutgraph(am::Array{T,2}; kwargs...)

Layout the graph in adjacency matrix `am`, using a spring-based method. Returns a tuple of `([xcoords], [ycoords])`, which are scaled according to the supplied BoundingBox.

### Keyword arguments

Lay out the graph in `adjmatrix` using the spring/repulsion model of Fruchterman and Reingold (1991). Returns a tuple of `([xcoords], [ycoords])`.

## Arguments

`am`
    An adjacency matrix of some type. Non-zero of the eltype of the matrix is used to determine if a link exists, but currently no sense of magnitude

`densityconstant`
    Constant to adjust the density of resulting layout. The default value is 2.0.

`maxiterations`
    how many iterations for applying the forces

`initialtemperature`
    the initial temperature controls movement per iteration. The default value is 2.0. Each iteration uses a lower temperature (TEMP = initialtemperature / iter). The idea is that the displacements of vertices are limited to some maximum temperature value, and this decreases over time. As the layout becomes better, the amount of adjustment becomes smaller.

`locs_x`
    the starting x values, between -1 and 1. The default values are randomly selected.

`locs_y`
    the starting y values, between -1 and 1. The default values are randomly selected.

`boundingbox`
    The Luxor BoundingBox into which the graph's coordinates will fit. Defaults to 500 × 500.


"""
layoutgraph(am::Array{T,2} where T; kwargs...) = layout_spring(am; kwargs...)

"""
    layoutgraph(al::AbstractVector; kwargs)

Layout the graph in adjacency list `al`, assuming the graph is a tree layout with a single root node. Return a list of Luxor points that can be used to lay out the nodes of the tree.

### Keyword arguments

```nodesize=ones(size(adjlist, 1)))```

`nodesize` is a vector of values that define the area occupied by each node. No idea how it works yet...

Return a list of Luxor points that can be used to lay out a tree defined in adjacency list `adjlist`.
"""
layoutgraph(al::AbstractVector; kwargs...) = layout_tree(al; kwargs...)

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

# layout algorithm for a simple tree structure

struct TreeLayout{A<:AbstractVector, F}
   nodes::A # []
   mod::F # []
   thread::Vector{Int} # []
   ancestor::Vector{Int} # []
   prelim::F # []
   shift::F # []
   change::F # []
   positions # Point[]
   nodesize::F # []
end

function TreeLayout(tree::AbstractVector, nodesize)
   len = length(tree)
   mod = zeros(len)
   thread = zeros(Int, len)
   prelim = zeros(len)
   shift = zeros(len)
   change = zeros(len)
   ancestor = collect(1:len)
   nodes = copy(tree)
   positions = [Point(0, 0) for i in 1:len]
   t = TreeLayout(nodes, mod, thread, ancestor, prelim, shift, change, positions, nodesize)
   return t
end

"""
   layout_tree(adjlist;
       nodesize=ones(size(am, 1)))
"""
function layout_tree(adjlist::AbstractVector;
   nodesize=ones(size(adjlist, 1)))
   # can check for stuff here
   _layout_tree(adjlist, nodesize)
end

# initialize modifiers, threads, and ancestors, then start the bottom-up
# and top-down traversals of the tree

function _layout_tree(t::AbstractVector, nodesize)
   tree = TreeLayout(t, nodesize)
   _layout_first_walk(1, tree)
   _layout_second_walk(1, -tree.prelim[1], 0.0, tree)
   return tree.positions
end

function _layout_parent(v, t::TreeLayout)
   tree = t.nodes
   for i in 1:length(tree)
       y = findfirst(x -> (x==v), tree[i])
       if !isnothing(y)
           return i
       end
   end
   return nothing
end

# computes a preliminary x-coordinate for v. Before that, FIRSTWALK is applied recursively
# to the children of v, as well as the function APPORTION. After spacing out the children by
# calling EXECUTESHIFTS, the node v is placed to the midpoint of its outermost children.

function _layout_first_walk(v, t::TreeLayout)
   prelim = t.prelim
   mod = t.mod
   tree = t.nodes
   nodesize = t.nodesize
   p = _layout_parent(v,t)
   if p != nothing
       index = findfirst(x -> (x==v), tree[p])
   else
       index = 1
   end
   if length(tree[v]) == 0
       if v != tree[p][1]
         prelim[v] = prelim[tree[p][index-1]] + (nodesize[tree[p][index-1]])
       else
         prelim[v] = 0
       end
   else
       defaultAncestor = tree[v][1]
       for w in tree[v]
           _layout_first_walk(w, t)
           defaultAncestor = _layout_apportion(w, defaultAncestor, t)
       end
       _layout_execute_shifts(v, t)
       midpoint = (prelim[tree[v][1]] + prelim[tree[v][end]]) / 2
       if index > 1
           w = tree[p][index-1]
           prelim[v] = prelim[w] + (nodesize[w] + 1.0)
           mod[v] = prelim[v] - midpoint
       else
           prelim[v] = midpoint
       end
   end
end

# a new subtree is combined with the previous subtrees
function _layout_apportion(v::T, defaultAncestor::T, t::TreeLayout) where {T}
   tree = t.nodes
   ancestor = t.ancestor
   prelim = t.prelim
   mod = t.mod
   thread = t.thread
   p = _layout_parent(v, t)
   nodesize = t.nodesize
   if p != nothing
       index = findfirst(x-> (x==v), tree[p])
   else
       index = 1
   end
   # "threads" are used to traverse the inside and outside contours of the left and right subtree up to the highest common level
   if index > 1
       w = tree[p][index-1]
       v_in_right = v_out_right = v
       v_in_left = w
       v_out_left = tree[_layout_parent(v_in_right, t)][1]
       s_in_right = mod[v_in_right]
       s_out_right = mod[v_out_right]
       s_in_left = mod[v_in_left]
       s_out_left = mod[v_out_left]
       while _layout_next_right(v_in_left, t) !=0 && _layout_next_left(v_in_right, t) !=0
           v_in_left = _layout_next_right(v_in_left, t)
           v_in_right = _layout_next_left(v_in_right, t)
           v_out_left = _layout_next_left(v_out_left, t)
           v_out_right = _layout_next_right(v_out_right, t)
           ancestor[v_out_right] = v
           shift = (prelim[v_in_left] + s_in_left) - (prelim[v_in_right] + s_in_right) + (nodesize[v_in_left])
           if shift > 0
               _layout_move_subtree(_layout_find_ancestor(v_in_left, v, defaultAncestor, t), v, shift, t)
               s_in_right += shift
               s_out_right += shift
           end
           s_in_left +=   mod[v_in_left]
           s_in_right +=  mod[v_in_right]
           s_out_left +=  mod[v_out_left]
           s_out_right += mod[v_out_right]
       end
       if _layout_next_right(v_in_left, t) != 0 && _layout_next_right(v_out_right, t) == 0
           thread[v_out_right] = _layout_next_right(v_in_left, t)
           mod[v_out_right] += s_in_left - s_out_right
       else
           if _layout_next_left(v_in_right,t) != 0 && _layout_next_left(v_out_left,t) == 0
               thread[v_out_left] = _layout_next_left(v_in_right, t)
               mod[v_out_left] += s_in_right - s_out_left
               defaultAncestor = v
           end
       end
   end
   return defaultAncestor
end

function _layout_number(v, t::TreeLayout)
   p = _layout_parent(v, t)
   index = findfirst(x -> (x==v), t.nodes[p])
   return index
end

# Shifting a subtree can be done in linear time..
# Calling MOVESUBTREE(w_ ,w+, shift) first shifts the current subtree, rooted at w+. This
# is done by increasing prelim(w+) and mod(w+) by shift.

function _layout_move_subtree(w_left::T, w_right::T, shift::Float64, t::TreeLayout) where {T}
   change = t.change
   prelim = t.prelim
   tree = t.nodes
   shifttree = t.shift
   mod = t.mod
   n_wl = _layout_number(w_left, t)
   n_wr = _layout_number(w_right, t)
   subtrees = n_wr - n_wl
   change[w_right] -= shift / subtrees
   shifttree[w_right] += shift
   change[w_left] += shift / subtrees
   prelim[w_right] += shift
   mod[w_right] += shift
end

# SECONDWALK is used to compute all real x-coordinates by
# summing up the modifiers recursively

function _layout_second_walk(v, m::Float64, depth::Float64, t::TreeLayout)
   prelim = t.prelim
   mod = t.mod
   positions = t.positions
   nodesize = t.nodesize
   positions[v] = Point(prelim[v] + m, depth)
   if length(t.nodes[v]) != 0
       maxdist = maximum([nodesize[i] for i in t.nodes[v]])
   else
       maxdist = 0
   end
   for w in t.nodes[v]
       _layout_second_walk(w, m + mod[v], Float64(depth + 1 + maxdist), t)
   end
end

# ANCESTOR returns the left one of the greatest uncommon ancestors of
# vi- and its right neighbour

function _layout_find_ancestor(w::T, v::T, defaultAncestor::T, tree::TreeLayout) where {T}
   ancestor = tree.ancestor
   if ancestor[w] in tree.nodes[_layout_parent(v, tree)]
       return ancestor[w]
   else
       return defaultAncestor
   end
end

# EXECUTESHIFTS(v) only needs one traversal of the children of v to execute
# all shifts computed and memorized in MOVESUBTREE

function _layout_execute_shifts(v, t::TreeLayout)
   tree = t.nodes
   shift = t.shift
   change = t.change
   prelim = t.prelim
   mod = t.mod
   shiftnode = 0
   changenode = 0
   for w in reverse(tree[v])
       prelim[w] += shiftnode
       mod[w] += shiftnode
       changenode += change[w]
       shiftnode += shift[w] + changenode
   end
end

function _layout_next_left(v, t::TreeLayout)
   tree = t.nodes
   thread = t.thread
   if length(tree[v]) != 0
       return tree[v][1]
   else
       return thread[v]
   end
end

function _layout_next_right(v, t::TreeLayout)
   tree = t.nodes
   thread = t.thread
   if length(tree[v]) != 0
       return tree[v][end]
   else
       return thread[v]
   end
end
