# Grids and tables

You often want to position graphics at regular locations on the drawing. The positions can be provided by:

- `Tiler`: a rectangular grid which you specify by enclosing area, and the number of rows and columns
- `Partition`: a rectangular grid which you specify by enclosing area, and the width and height of each cell
- `Grid` and `GridHex` a rectangular or hexagonal grid, on demand
- `Table`: a rectangular grid which you specify by providing row and column numbers, row heights and column widths

These are types which act as iterators.

## Tiles and partitions

The drawing area (or any other area) can be divided into rectangular tiles (as rows and columns) using the `Tiler` and `Partition` iterators.

The `Tiler` iterator returns the center point and tile number of each tile in turn.

In this example, every third tile is divided up into subtiles and colored:

```@example
using Luxor # hide
Drawing(400, 300, "assets/figures/tiler.png") # hide
background("white") # hide
origin() # hide
srand(1) # hide
fontsize(20) # hide
tiles = Tiler(400, 300, 4, 5, margin=5)
for (pos, n) in tiles
    randomhue()
    box(pos, tiles.tilewidth, tiles.tileheight, :fill)
    if n % 3 == 0
        gsave()
        translate(pos)
        subtiles = Tiler(tiles.tilewidth, tiles.tileheight, 4, 4, margin=5)
        for (pos1, n1) in subtiles
            randomhue()
            box(pos1, subtiles.tilewidth, subtiles.tileheight, :fill)
        end
        grestore()
    end
    sethue("white")
    textcentered(string(n), pos + Point(0, 5))
end
finish() # hide
nothing # hide
```

![tiler](assets/figures/tiler.png)

`Partition` is like `Tiler`, but you specify the width and height of the tiles, rather than
how many rows and columns of tiles you want.

```@docs
Tiler
Partition
```

## Tables

The `Table` iterator can be used to define tables: rectangular grids with a specific number of rows and columns. The columns can have different widths, and the rows can have different heights.

To create a simple table with 3 rows and 4 columns, using the default width and height (100):

```
julia> t = Table(3, 4);

julia> t[1]
Luxor.Point(-150.0, -100.0)

julia> t[2]
Luxor.Point(-50.0, -100.0)

julia> t[3]
Luxor.Point(50.0, -100.0)

julia> t[4]
Luxor.Point(150.0, -100.0)
```

This example creates a table with 10 rows and 10 columns, where each cell is t0 units wide and 35 high.

```@example
using Luxor # hide
Drawing(600, 400, "assets/figures/table2.png") # hide
background("white") # hide
origin() # hide
srand(42) # hide
fontface("Helvetica-Bold") # hide
fontsize(20) # hide
sethue("black")

t = Table(10, 10, 50, 35) # 10 rows, 10 columns, 50 wide, 35 high

hundred = reshape(shuffle(1:100), 10, 10)

for n in 1:length(t)
   text(string(hundred[n]), t[n], halign=:center, valign=:middle)
end

setopacity(0.5)
sethue("pink")
circle.(t[3, :], 20, :fill) # row 3, every column
finish() # hide
nothing # hide
```

![table 2](assets/figures/table2.png)

You can access rows or columns in the usual Julian way.

To specify varying row heights and column widths, supply arrays or ranges. This table has three rows, of heights 50, 100, and 150 units, and seven columns, with gradually increasing widths:

```@example
using Luxor # hide
Drawing(600, 400, "assets/figures/table1.png") # hide
background("white") # hide
origin() # hide
fontsize(12) # hide
srand(42) # hide

t = Table([50, 100, 150], 15:20:140)

for (pt, n) in t
    randomhue()
    box(pt, t.colwidths[t.currentcol], t.rowheights[t.currentrow], :fill)
    sethue("white")
    text(string(n), pt, halign=:center)
end

finish() # hide
nothing # hide
```

![table 1](assets/figures/table1.png)

To fill table cells, it's useful to be able to access the table's row and column specifications (using the `colwidths` and `rowheights` fields), and iteration can also provide information about the current row and column being processed (`currentrow` and `currentcol`). Use a clipping region to ensure that graphic elements don't stray outside the cell walls.
