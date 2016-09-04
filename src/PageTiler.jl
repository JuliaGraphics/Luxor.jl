"""
A PageTiler is an iterator that returns the `x`/`y` point of the center of each tile
in a set of tiles that divide up a rectangular space into rows and columns.

    pagetiles = PageTiler(areawidth, areaheight, nrows, ncols, margin=20)

where `width`, `height` is the dimensions of the area to be tiled, `nrows`/`ncols`
is the number of rows and columns required, and `margin` is applied to all four
edges of the area before the function calculates the tile sizes required.

    pagetiles = PageTiler(1000, 800, 4, 5, margin=20)
    for (pos, n) in pagetiles
    # the point pos is the center of the tile
    end

You can access the calculated tile width and height like this:

    pagetiles = PageTiler(1000, 800, 4, 5, margin=20)
    for (pos, n) in pagetiles
      ellipse(pos.x, pos.y, pagetiles.tilewidth, pagetiles.tileheight, :fill)
    end
"""
type PageTiler
  width
  height
  tilewidth
  tileheight
  nrows
  ncols
  margin
  function PageTiler(pagewidth, pageheight, nrows::Int, ncols::Int; margin=10)
      tilewidth  = (pagewidth  - 2 * margin)/ncols
      tileheight = (pageheight - 2 * margin)/nrows
      new(pagewidth, pageheight, tilewidth, tileheight, nrows, ncols, margin)
  end
end

function Base.start(pt::PageTiler)
# return the initial state
  x = -(pt.width/2)  + pt.margin + (pt.tilewidth/2)
  y = -(pt.height/2) + pt.margin + (pt.tileheight/2)
  return (Point(x, y), 1)
end

function Base.next(pt::PageTiler, state)
  # Returns the item and the next state
  # state[1] is the Point
  x = state[1].x
  y = state[1].y
  # state[2] is the tilenumber
  tilenumber = state[2]
  x1 = x + pt.tilewidth
  y1 = y
  if x1 > (pt.width/2) - pt.margin
    y1 += pt.tileheight
    x1 = -(pt.width/2) + pt.margin + (pt.tilewidth/2)
  end
  return ((Point(x, y), tilenumber), (Point(x1, y1), tilenumber + 1))
end

function Base.done(pt::PageTiler, state)
  # Tests if there are any items remaining
  state[2] > (pt.nrows * pt.ncols)
end
