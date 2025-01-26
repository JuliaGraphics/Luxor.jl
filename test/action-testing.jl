using Luxor
using Test

# testing that functions that accept eg `:fill` also can be used with keyword `action=:fill`

const expressions = [
:(arc(O, 70, 0, π/2, :stroke)),
:(arc(O, 70, 0, π/2, action=:stroke)),

:(arc(O, 30, 0, π/2, :fill)),
:(arc(O, 30, 0, π/2, action=:fill)),

:(arc2r(O, Point(-30, 50), Point(20, 40), :stroke)),
:(arc2r(O, Point(-30, 50), Point(20, 40), action=:stroke)),

:(arc2sagitta(Point(30, 50), Point(20, 50), 40, :stroke)),
:(arc2sagitta(Point(30, 50), Point(20, 50), 40, action=:stroke)),

:(box(-30, -30, 50, 50, :fill)),
:(box(-30, -30, 50, 50, action=:fill)),

:(box([O, Point(24, 20), Point(20, 30)], :fill)),
:(box([O, Point(24, 20), Point(20, 30)], action=:fill)),

:(box(BoundingBox(box([O, Point(24, 20), Point(20, 30)])), :fill)),
:(box(BoundingBox(box([O, Point(24, 20), Point(20, 30)])), action=:fill)),

:(begin
    t = Table(3, 3)
    pts = box(t, 2, 1, action=:stroke, vertices=false, reversepath=true)
    pts = box(t, 2, 1, :stroke, vertices=false, reversepath=true)
    t = Tiler(50, 50, 3, 3)
    pts = box(t, 5, action=:stroke, vertices=false, reversepath=true)
    pts = box(t, 5, :stroke, vertices=false, reversepath=true)
end),

:(box(Point(-30, -50), Point(20, 50), :fill)),
:(box(Point(-25, -20), Point(23, 20), action=:fill)),

:(box(O, 30, 60, 10, :stroke)),
:(box(O, 35, 60, 10, action = :stroke)),

:(box(O, 30, 80, [10, 10, 20, 20], :stroke)),
:(box(O, 35, 80, [10, 10, 20, 20], action = :stroke)),

:(pts = box(O, 20, 20, :stroke; reversepath=true, vertices=true); poly(pts, :fill)),
:(pts = box(O, 20, 20, action=:stroke; reversepath=true, vertices=true); poly(pts, action=:fill)),

:(carc(O, 60, π, π/3, :stroke)),
:(carc(O, 60, π, π/3, action=:stroke)),

:(carc(O, 50, π, π/3, :stroke)),
:(carc(O, 50, π, π/3, action=:stroke)),

:(carc2r(O, Point(30, 30), Point(-20, -20), :stroke)),
:(carc2r(O, Point(30, 30), Point(-20, -20), action=:stroke)),

:(carc2sagitta(Point(-20, -20), Point(30, 30), 30, :stroke)),
:(carc2sagitta(Point(-20, -20), Point(30, 30), 30, action=:stroke)),
:(circle(O, 30, :stroke)),
:(circle(O, 30, action=:stroke)),
:(circle(20, 10, 30, :stroke)),
:(circle(20, 10, 30, action=:stroke)),
:(circle(O, Point(20, -20), :stroke)),
:(circle(O, Point(20, -20), action=:stroke)),
:(circle(O, Point(20, -20), Point(-10, 30), :stroke)),
:(circle(O, Point(20, -20), Point(-10, 30), action=:stroke)),
:(circlepath(O, 20, :stroke; reversepath=true)),
:(circlepath(O, 20, action=:stroke; reversepath=true)),
:(crescent(Point(10, 10), 18, 25, :stroke; vertices=false, reversepath=true, steps=20)),
:(crescent(Point(10, 10), 18, 25, action=:stroke; vertices=false, reversepath=true, steps=20)),
:(crescent(O, 20, Point(30, 30), 30, :stroke; vertices=false, reversepath=true)),
:(crescent(O, 20, Point(30, 30), 30, action=:stroke; vertices=false, reversepath=true)),

:(ellipse(10, 20, 30, 40, :stroke)),
:(ellipse(10, 20, 30, 40, action=:stroke)),

:(ellipse(O, 40, 50, :stroke)),
:(ellipse(O, 30, 30, action=:stroke)),

:(ellipse(O - (10, 10), O - (10, 10), 50, :stroke; stepvalue=π/30, vertices=false, reversepath=true)),
:(ellipse(O - (10, 10), O - (10, 10), 50, action=:stroke; stepvalue=π/30, vertices=false, reversepath=true)),

:(ellipse(O - (10, 10), O - (10, 10), O, :stroke; stepvalue=π/13, vertices=false, reversepath=true)),
:(ellipse(O - (10, 10), O - (10, 10), O, action=:stroke; stepvalue=π/13, vertices=false, reversepath=true)),

:(epitrochoid(41, 7, 23, :stroke; close=false, stepby=π/60, vertices=false)),
:(epitrochoid(41, 7, 23, action=:stroke; close=false, stepby=π/60, vertices=false)),

:(hypotrochoid(44, 7, 27, :stroke; close=false, stepby=π/39, vertices=false)),
:(hypotrochoid(44, 7, 27, action=:stroke; close=false, stepby=π/39, vertices=false)),

:(line(O, Point(30, -40), :stroke)),
:(line(O, Point(30, -40), action=:stroke)),

:(ngon(20, 10, 20, 5, :stroke)),
:(ngon(20, 10, 20, 5, action=:stroke)),
:(ngon(20, 20, 20, 6, π/3, :stroke)),
:(ngon(20, 20, 20, 6, π/3, action=:stroke)),
:(ngon(O, 23, 7, π/3, :fill, vertices=false, reversepath=true)),
:(ngon(O, 23, 7, π/3, action=:fill, vertices=false, reversepath=true)),

:(ngonside(O, 50, 7, π/3, :stroke)),
:(ngonside(O, 50, 7, π/3, action=:stroke)),
:(ngonside(O, 30, 7, :stroke)),
:(ngonside(O, 30, 7, action=:stroke)),

:(pie(O, 23, 0, π, :fill)),
:(pie(O, 23, 0, π, action=:fill)),
:(pie(20, 10, 50, π/3, 0, :stroke)),
:(pie(20, 10, 50, π/3, 0, action=:stroke)),
:(pie(50, 0, π/2, :stroke)),
:(pie(50, 0, π/2, action=:stroke)),

:(poly(BoundingBox(box(O, 20, 20)), :stroke)),
:(poly(BoundingBox(box(O, 20, 20)), action=:stroke)),

:(poly(ngon(O, 50, 7), :stroke, close=true, reversepath=false)),
:(poly(ngon(O, 50, 7), action=:stroke, close=true, reversepath=false)),

:(polycross(O, 23, 3, 0.7, π/3, :fill, vertices=false, reversepath=true)),
:(polycross(O, 23, 3, 0.7, π/3, action=:fill, vertices=false, reversepath=true)),

:(prettypoly(box(O, 20, 20), close=true, :stroke)),
:(prettypoly(box(O, 20, 20), action=:stroke, close=true)),

:(prettypoly(ngon(O, 30, 5, vertices=true), close=true, :none, () -> (star(O, 16, 7, 0.4, 0.0, action=:stroke)))),
:(prettypoly(ngon(O, 30, 5, vertices=true), close=true, action=:none, () -> (star(O, 16, 7, 0.4, 0.0, action=:stroke)))),

:(prettypoly(BoundingBox() * 0.05, :fill)),
:(prettypoly(BoundingBox() * 0.05, action=:fill)),

:(rect(-20, -30, 15, 29, :stroke)),
:(rect(-20, -30, 15, 29, action=:stroke)),

:(rect(O, 26, 31, :stroke; reversepath=true, vertices=false)),
:(rect(O, 26, 31, action=:stroke; reversepath=true, vertices=false)),

:(sector(O, 28, 45, 0, 3π/2, :stroke)),
:(sector(O, 28, 45, 0, 3π/2, action=:stroke)),

:(sector(18, 40, 0, 3π/2, :stroke)),
:(sector(18, 40, 0, 3π/2, action=:stroke)),

:(sector(O, 18, 45, 0, 3π/2, 10, :stroke)),
:(sector(O, 18, 45, 0, 3π/2, 10, action=:stroke)),

:(sector(18, 25, 0, 3π/2, 10, :stroke)),
:(sector(18, 25, 0, 3π/2, 10, action=:stroke)),

:(spiral(20, -2, :stroke; stepby=π/30, period=12π, vertices=false, log=false)),
:(spiral(20, -2, action=:stroke; stepby=π/30, period=12π, vertices=false, log=false)),

:(squircle(O, 23, 23, :stroke; rt=0.6, vertices=false, stepby=π/30, reversepath=true)),
:(squircle(O, 23, 23, action=:stroke; rt=0.6, vertices=false, stepby=π/30, reversepath=true)),

:(star(20, 10, 23, 6, 0.5, 0.0, :fill; vertices=false, reversepath=true)),
:(star(20, 10, 23, 6, 0.5, 0.0, action=:fill; vertices=false, reversepath=true)),

:(star(O, 33, 7, 0.3, π, :stroke; vertices=false, reversepath=true)),
:(star(O, 33, 7, 0.3, π, action=:stroke; vertices=false, reversepath=true)),

:(textoutlines("text", Point(0, 0), action=:path; halign=:left, valign=:middle, startnewpath=true); fillpath()),
:(textoutlines("text", Point(0, 0), :stroke, halign=:left, valign=:middle, startnewpath=true)),
]

fname = "/tmp/action-dispatch-tests.png"
Drawing(2000, 2000, fname)
origin()
background("black")
fontsize(10)
tiles = Tiler(2000, 2000, 12, 12)
for (pos, n) in tiles
    @layer begin
        translate(pos)
        if n <= length(expressions)
            textwrap(string(expressions[n]), tiles.tilewidth * 0.7, O - (tiles.tilewidth/2, tiles.tileheight/2), leading=10)
            sethue("gold")
            eval(expressions[n])
        end
    end
end

@test finish() == true
println("...finished test: output in $(fname)")
