using Luxor, Test

p = Point( 1, 2 )
x, y = p
@test x == 1.0
@test y == 2.0

bb = BoundingBox(p,2p)
rp = rand(bb)

@test rp in bb
