using Juno, Hiccup

Juno.media(Luxor.Drawing, Media.Plot)

function Juno.render(pane::Juno.PlotPane, img::Luxor.Drawing)
    Juno.render(pane, Hiccup.div(Hiccup.img(src=realpath(img.filename) * "?$(time())")))
end
