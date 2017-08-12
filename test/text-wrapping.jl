#!/usr/bin/env julia

using Luxor

using Base.Test

loremipsum = """Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc placerat lorem ullamcorper, sagittis massa et, elementum dui. Sed dictum ipsum vel commodo pellentesque. Aliquam erat volutpat. Nam est dolor, vulputate a molestie aliquet, rutrum quis lectus. Sed lectus mauris, tristique et tempor id, accumsan pharetra lacus. Donec quam magna, accumsan a quam quis, mattis hendrerit nunc. Nullam vehicula leo ac leo tristique, a condimentum tortor faucibus. Interdum et malesuada fames ac ante ipsum primis in faucibus. Mauris condimentum dui et mattis malesuada. In quis ornare velit, non dictum odio. Ut quis quam ut enim lobortis maximus nec at lectus. Integer condimentum rhoncus suscipit. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Proin a hendrerit magna."""

function text_wrapping_tests(fname)
    Drawing(800, 1200, fname)
    origin()
    setopacity(0.8)
    sethue("black")
    srand(42)
    tiles = Tiler(800, 1200, 4, 4, margin=10)
    for (pos, n) in tiles
        fontface(["Georgia", "Arial", "Menlo"][rand(1:end)])
        sethue(["black", "darkmagenta", "royalblue2"][rand(1:end)])
        gsave()
        translate(pos)
        fontsize(4+n)
        # top left:
        op =  Point(-tiles.tilewidth/2, -tiles.tileheight/2)
        box(op, Point(tiles.tilewidth/2, tiles.tileheight/2), :clip)
        textwrap(loremipsum, tiles.tilewidth, op, rightgutter=6)
        clipreset()
        grestore()
    end
    @test finish() == true
    println("...finished test: output in $(fname)")
end

text_wrapping_tests("text-wrapping-tests.png")
