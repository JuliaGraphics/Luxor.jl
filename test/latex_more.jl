using Luxor
using MathTeXEngine
using LaTeXStrings
using Test

#ENV["JULIA_DEBUG"] = "LuxorExtLatex"
ENV["JULIA_DEBUG"] = ""

function latex_test_with_a_vengeance(fname)
    Drawing(800, 800, fname)
    origin()
    translate(boxtopcenter() + (-300, 6))
    background("grey6")
    fontsize(40)
    sethue("white")
    t1 = L"e^{i\pi} + 1 = 0"
    t2 = L"e^x = \sum^\infty_{n=0} \frac{x^n}{n!} = \lim_{n\to\infty}(1+\frac{x}{n})^n"
    t3 = L"\sin(\theta)"
    t4 = L"\cos(\theta)"
    t5 = L"⨟ { } @%&* () -+ !? |~ "
    t6 = L"doublestruck: 𝔸 𝔹 ℂ 𝔻 𝔽 𝔾 ℍ 𝕀 𝕁 𝕂 𝕃 𝕄 ℕ 𝕆 ℙ ℚ ℝ 𝕊 𝕋 𝕌 𝕎 𝕍 𝕏 ℤ "
    t7 = L"fraktur: 𝔄 𝔅 ℭ 𝔇 𝔈 𝔉 𝔊 ℌ ℑ 𝔍 𝔎 𝔏 𝔐 𝔑 𝔒 𝔓 𝔔 ℜ 𝔖 𝔗 𝔘 𝔙 𝔚 𝔛 𝔜 ℨ"
    t8 = L"fraktur: 𝕬 𝕭 𝕮 𝕯 𝕰 𝕱 𝕲 𝕳 𝕴 𝕵 𝕶 𝕷 𝕸 𝕹 𝕺 𝕻 𝕼 𝕽 𝕾 𝕿 𝖀 𝖁 𝖂 𝖃 𝖄 𝖅"
    t9 = L"script: 𝒜 ℬ 𝒞 𝒟 ℰ ℱ 𝒢 ℋ ℐ 𝒥 𝒦 ℒ ℳ 𝒩 𝒪 𝒫 𝒬 ℛ 𝒮 𝒯 𝒰 𝒱 𝒲 𝒳 𝒴 𝒵"
    t10 = L"doublestruck lowercase: 𝕒 𝕓 𝕔 𝕕 𝕖 𝕗 𝕘 𝕙 𝕚 𝕛 𝕜 𝕝 𝕞 𝕟 𝕠 𝕡 𝕢 𝕣 𝕤 𝕥 𝕦 𝕧 𝕩 𝕨 𝕪 𝕫"
    t11 = L"bold: 𝐚 𝐛 𝐜 𝐝 𝐞 𝐟 𝐠 𝐡 𝐢 𝐣 𝐤 𝐥 𝐦 𝐧 𝐨 𝐩 𝐪 𝐫 𝐬 𝐭 𝐮 𝐯 𝐱 𝐰 𝐲 𝐳 "
    t12 = L"bold: 𝐀 𝐁 𝐂 𝐃 𝐄 𝐅 𝐆 𝐇 𝐈 𝐉 𝐊 𝐋 𝐌 𝐍 𝐎 𝐏 𝐐 𝐑 𝐒 𝐓 𝐔 𝐕 𝐗 𝐖 𝐘 𝐙"
    t13 = L"bold script: 𝓐 𝓑 𝓒 𝓓 𝓔 𝓕 𝓖 𝓗 𝓘 𝓙 𝓚 𝓛 𝓜 𝓝 𝓞 𝓟 𝓠 𝓡 𝓢 𝓣 𝓤 𝓥 𝓧 𝓦 𝓨 𝓩"

    for t in [t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13]
        text(t, O, halign = :left, valign = :baseline)
        translate(0, 60)
    end
    @test finish() == true
end

fname = "latex-test-with-a-vengeance.svg"
latex_test_with_a_vengeance(fname)
println("...finished test: output in $(fname)")
