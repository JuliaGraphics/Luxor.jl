using Luxor, Test, Random
Random.seed!(42)
function circlecircletangent_test(fname)
    Drawing(800, 800, fname)
    origin()
    background("white")
    setopacity(0.7)
    sethue("black")
    # overlapping circles will return four Os
    c1center = c2center = O
    c1radius = 50
    c2radius = 100
    p1, p2, p3, p4 = circlecircleoutertangents(c1center, c1radius, c2center, c2radius)
    @test all(pt -> isequal(pt, O), (p1, p2, p3, p4)) == true
    for i in 1:30
        randomhue()
        c1center = rand(BoundingBox() * 0.5)
        c2center = rand(BoundingBox() * 0.75)
        c1radius = rand(5:30)
        c2radius = rand(30:50)
        circle(c1center, c1radius, :fill)
        circle(c2center, c2radius, :fill)
        pt1, pt2, pt3, pt4 = circlecircleoutertangents(c1center, c1radius, c2center, c2radius)
        poly([pt1, pt2, pt4, pt3], :fill)
        sethue("black")
        circle(c2center, c2radius, :stroke)
        circle(c1center, c1radius, :stroke)
    end
    @test finish() == true
    println("...finished test: output in $(fname)")
    preview()
end

function circlecircletangent_test2(fname)
    Drawing(800, 800, fname)
    origin()
    background("white")
    setline(0.5)
    sethue("black")
    # overlapping circles will return four Os
    c1center = c2center = O
    c1radius = 50
    c2radius = 100
    p1, p2, p3, p4 = circlecircleinnertangents(c1center, c1radius, c2center, c2radius)
    @test all(pt -> isequal(pt, O), (p1, p2, p3, p4)) == true

    for θ in range(0, step=2π/12, length=12)
        @layer begin
            randomhue()
            c1center = polar(100, θ)
            c2center = polar(300, θ)
            c1radius = 20
            c2radius = rand(50:70)
            circle(c1center, c1radius, :fill)
            circle(c2center, c2radius, :fill)

            pt1, pt2, pt3, pt4 = circlecircleinnertangents(c1center, c1radius, c2center, c2radius)

            if !all(pt -> isequal(pt, O), (pt1, pt2, pt3, pt4))
                sethue("green")
                circle(c2center, c2radius, :stroke)
                circle(c1center, c1radius, :stroke)
                circle.((pt1, pt2, pt3, pt4), 4, :fill)
                sethue("black")
                arrow(pt1, pt2, linewidth=2)
                arrow(pt3, pt4, linewidth=2)
            end

            pt1, pt2, pt3, pt4 = circlecircleoutertangents(c1center, c1radius, c2center, c2radius)

            if !all(pt -> isequal(pt, O), (pt1, pt2, pt3, pt4))
                sethue("red")
                arrow(pt1, pt2, linewidth=2)
                arrow(pt3, pt4, linewidth=2)
                circle.((pt1, pt2, pt3, pt4), 3, :fill)
            end
        end
    end
    @test finish() == true
    println("...finished test: output in $(fname)")
end

circlecircletangent_test("circlecircletangent-outer.png")
circlecircletangent_test2("circlecircletangent-inner.png")
