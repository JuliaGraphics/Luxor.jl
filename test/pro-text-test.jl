#!/usr/bin/env julia

using Luxor

if VERSION >= v"0.5.0-dev+7720"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

function test_pro_text(fname)
    Drawing(1600, 1200, fname)
    sethue("black")
    strings = [
    "<b>This is bold.</b>",
    "<i>This is italic.</i>",
    "<s>This is strikethrough.</s>",
    "<sub>This is subscript.</sub>",
    "<sup>This is superscript.</sup>",
    "<small>This makes the font smaller.</small>",
    "<big>This makes the font larger.</big>",
    "<u>This is underlined text.</u>",
    "<tt>This uses a monospaced font.</tt>",
    "<span foreground='blue'>Blue text!</span>",
    "<span size='x-large'>Extra Large Text</span>",
    "Well, time for a <span font='26' background ='green' foreground='red'>quick fontsize change.</span> I think!"
    ]
    col1 = 100
    col2 = 900
    row = 100

    counter = 1
    for i in 4:30
        # pro api:
        setfont("Helvetica", i)
        settext(
            strings[mod1(counter, length(strings))],
            Point(col1, row),
            halign="left",
            valign="top",
            angle=0,
            markup=true)
        counter += 1

        # toy api:
        fontface("Helvetica")
        fontsize(i)
        text("hello in Helvetica $i using the Toy API", Point(col2, row))
        row += 30
    end
    @test finish() == true
end

fname = "pro-text-test.pdf"
test_pro_text(fname)
println("...finished test: output in $(fname)")
