using Luxor, Test

# test all points the same
pt1 = pt2 = pt3 = pt4 = O
flag, _ = intersectionlines(pt1, pt1, pt1, pt1)
@test flag == false

# test all points the same but not 0.0
pt1 = pt2 = pt3 = pt4 = Point(0.5, 0.75)
flag, _ = intersectionlines(pt1, pt1, pt1, pt1)
@test flag == false

#first pair of points the same
pt1 = pt2 = O
pt3 = Point(20, 20)
pt4 = Point(30, 20)
flag, _ = intersectionlines(pt1, pt2, pt3, pt4)
@test flag == false

#last pair of points the same
pt1 = Point(20, 20)
pt2 = Point(30, 20)
pt3 = pt4 = O
flag, _ = intersectionlines(pt1, pt2, pt3, pt4)
@test flag == false

#first point same as one of second pair
pt1 = Point(20, 20)
pt2 = Point(30, 20)
pt3 = Point(20, 20)
pt4 = Point(40, 50)
flag, ip = intersectionlines(pt1, pt2, pt3, pt4)
@test flag == true
@test ip == Point(20.0, 20.0)

# first point same as one of second pair, crossing only
pt1 = Point(20, 20)
pt2 = Point(30, 20)
pt3 = Point(20, 20)
pt4 = Point(40, 50)
flag, ip = intersectionlines(pt1, pt2, pt3, pt4, crossingonly=true)
@test flag == true
@test ip == Point(20.0, 20.0)

#testing overlapping collinear horizontal lines
pt1 = Point(0, 0)
pt2 = Point(100, 0)
pt3 = Point(50, 0)
pt4 = Point(200, 0)
flag, _ = intersectionlines(pt1, pt2, pt3, pt4)
@test flag == false

# testing overlapping collinear horizontal lines, with crossingonly
pt1 = Point(0, 0)
pt2 = Point(100, 0)
pt3 = Point(50, 0)
pt4 = Point(200, 0)
flag, ip = intersectionlines(pt1, pt2, pt3, pt4, crossingonly=true)
@test flag == false

# testing shared endpoints horizontal crossingonly = true
pt1 = Point(0, 0)
pt2 = Point(200, 0)
pt3 = Point(200, 0)
pt4 = Point(100, 40)
flag, ip = intersectionlines(pt1, pt2, pt3, pt4, crossingonly=true)
@test flag == true
@test ip == Point(200.0, 0.0)

# testing shared endpoints vertical
pt1 = Point(0, 0)
pt2 = Point(0, 100)
pt3 = Point(0, 0)
pt4 = Point(0, 200)
flag, ip = intersectionlines(pt1, pt2, pt3, pt4)
@test flag == true
@test ip == O

# testing shared endpoints vertical crossingonly = true
pt1 = Point(0, 0)
pt2 = Point(0, 100)
pt3 = Point(0, 10)
pt4 = Point(0, 100)
flag, ip = intersectionlines(pt1, pt2, pt3, pt4, crossingonly=true)
@test flag == true
@test ip == Point(0.0, 100.0)

# testing nonoverlapping vertical lines
pt1 = Point(0, 0)
pt2 = Point(0, 100)
pt3 = Point(0, 100)
pt4 = Point(0, 200)
flag, ip = intersectionlines(pt1, pt2, pt3, pt4)
@test flag == true
@test ip == Point(0.0, 100.0)

# testing nonoverlapping vertical lines
pt1 = Point(0, 0)
pt2 = Point(0, 100)
pt3 = Point(0, 200)
pt4 = Point(0, 300)
flag, ip = intersectionlines(pt1, pt2, pt3, pt4)
@test flag == false

# testing overlapping vertical lines
pt1 = Point(0, 0)
pt2 = Point(0, 100)
pt3 = Point(0, 50)
pt4 = Point(0, 150)
flag, ip = intersectionlines(pt1, pt2, pt3, pt4)
@test flag == false

# testing overlapping vertical lines crossingonly true"
pt1 = Point(0, 0)
pt2 = Point(0, 100)
pt3 = Point(0, 50)
pt4 = Point(0, 150)
flag, ip = intersectionlines(pt1, pt2, pt3, pt4, crossingonly=true)
@test flag == false

# testing intersecting line segments not crossing"
pt1 = Point(0, 0)
pt2 = Point(150, -150)
pt3 = Point(150, 0)
pt4 = Point(0, -150)
flag, ip = intersectionlines(pt1, pt2, pt3, pt4)
@test flag == true
@test ip == Point(75.0, -75.0)

# testing nearly vertical lines
pt1 = Point(0, 0)
pt2 = Point(0, -1500)
pt3 = Point(1, 0)
pt4 = Point(0.99, -1500)
flag, ip = intersectionlines(pt1, pt2, pt3, pt4)
@test flag == true

# testing nearly vertical lines crossing only
pt1 = Point(0, 0)
pt2 = Point(0, -15000)
pt3 = Point(1, 0)
pt4 = Point(0.999999, -150000)
flag, ip = intersectionlines(pt1, pt2, pt3, pt4, crossingonly=true)
@test flag == false

# testing nearly vertical lines, they meet eventually
pt1 = Point(0, 0)
pt2 = Point(0, -15000)
pt3 = Point(1, 0)
pt4 = Point(0.999999, -150000)
flag, ip = intersectionlines(pt1, pt2, pt3, pt4)
@test isapprox(ip.x, 0.0)
@test flag == true

# parallel vertical lines
pt1 = Point(0, 0)
pt2 = Point(0, -1500)
pt3 = Point(1, 0)
pt4 = Point(1, -1500)
flag, ip = intersectionlines(pt1, pt2, pt3, pt4)
@test flag == false

# parallel vertical lines crossingonly
pt1 = Point(0, 0)
pt2 = Point(0, -1500)
pt3 = Point(1, 0)
pt4 = Point(1, -1500)
flag, ip = intersectionlines(pt1, pt2, pt3, pt4, crossingonly=true)
@test flag == false

# parallel horizontal lines
pt1 = Point(-1000, 0)
pt2 = Point(1000,  0)
pt3 = Point(-1000, -10)
pt4 = Point(1000,  -10)
flag, ip = intersectionlines(pt1, pt2, pt3, pt4)
@test flag == false

# parallel horizontal lines crossingonly
pt1 = Point(-1000, 0)
pt2 = Point(1000,  0)
pt3 = Point(-1000, -10)
pt4 = Point(1000,  -10)
flag, ip = intersectionlines(pt1, pt2, pt3, pt4, crossingonly=true)
@test flag == false

# nearly parallel horizontal lines (they meet eventually)
pt1 = Point(-1000, 0)
pt2 = Point(1000,  0)
pt3 = Point(-1000, -10)
pt4 = Point(1000,  -9.99)
flag, ip = intersectionlines(pt1, pt2, pt3, pt4)
@test flag == true
@test ip.x > 1000.0
@test iszero(ip.y)

# nearly parallel horizontal lines crossing only
pt1 = Point(-100, 0)
pt2 = Point(100,  0)
pt3 = Point(-100, -10)
pt4 = Point(100,  -9.99)
flag, ip = intersectionlines(pt1, pt2, pt3, pt4, crossingonly=true)
@test flag == false
