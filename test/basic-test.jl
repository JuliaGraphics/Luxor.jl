using Luxor, Test


# test empty drawings

Drawing()
[Drawing() for x in 1:10]
[Drawing(x, x) for x in 1:10]
[Drawing(x, x, :image) for x in 1:10]


p = Point(1, 2)
x, y = p

@test x == 1.0
@test y == 2.0

bb = BoundingBox(p, 2p)

rp = rand(bb)

@test rp in bb

println("...finished basic-test")
