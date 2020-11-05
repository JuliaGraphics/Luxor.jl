macro play(w, h, body)
    quote
        window = mfb_open_ex("julia:clock", $w, $h, MiniFB.WF_RESIZABLE)
        buffer = zeros(UInt32, $w, $h)
        while true
            Drawing($w, $h, :image)
            origin()
            $(esc(body))
            m = permutedims(image_as_matrix!(buffer), (2, 1))
            finish()
            state = mfb_update(window, m)
            if state != MiniFB.STATE_OK
                break
            end
        end
        mfb_close(window)
    end
end
