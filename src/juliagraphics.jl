# the current julia logo and graphics

# not exported

const julia_blue    = (0.251, 0.388, 0.847)
const julia_purple  = (0.584, 0.345, 0.698)
const julia_green   = (0.22, 0.596, 0.149)
const julia_red     = (0.796, 0.235, 0.2)

# to be deprecated
const darker_blue    = (0.251, 0.388, 0.847)
const lighter_blue   = (0.4, 0.51, 0.878)
const darker_purple  = (0.584, 0.345, 0.698)
const lighter_purple = (0.667, 0.475, 0.757)
const darker_green   = (0.22, 0.596, 0.149)
const lighter_green  = (0.376, 0.678, 0.318)
const darker_red     = (0.796, 0.235, 0.2)
const lighter_red    = (0.835, 0.388, 0.361)
const purples        = (darker_purple, lighter_purple)
const greens         = (darker_green, lighter_green)
const reds           = (darker_red, lighter_red)


"""
    julialogo(;
        action=:fill,
        color=true,
        bodycolor=colorant"black",
        centered=false)

Draw the Julia logo. The default action is to fill the logo and use the colors:

    julialogo()

If `color` is `false`, the `bodycolor` color is used for the logo.

The function uses the current drawing state (position, scale, etc).

The `centered` keyword lets you center the logo at its
mathematical center, but the optical center might lie
somewhere else - it's difficult to position well due to its
asymmetric design.

To use the logo as a clipping mask:

```
julialogo(action=:clip)
```

(In this case the `color` setting is automatically ignored.)

To obtain a stroked (outlined) version:

```
julialogo(action=:path)
sethue("red")
strokepath()
```
"""
function julialogo(;
        action    = :fill,
        color     = true,
        bodycolor = colorant"black",
        centered  = false)

    if centered == true
        translate(-Point(330, 213)/2)
    end

    # save current color
    r, g, b, a = Luxor.get_current_redvalue(), Luxor.get_current_greenvalue(), Luxor.get_current_bluevalue(), Luxor.get_current_alpha()

    # "j" without dot
    _j  =  [
    PathMove(Point(72.87109375, 177.3125)),
    PathCurve(Point(72.87109375, 184.84765625), Point(72.0234375, 190.93359375), Point(70.328125, 195.56640625)),
    PathCurve(Point(68.6328125, 200.203125), Point(66.22265625, 203.80078125), Point(63.09375, 206.36328125)),
    PathCurve(Point(59.96875, 208.92578125), Point(56.21875, 210.640625), Point(51.84765625, 211.5078125)),
    PathCurve(Point(47.4765625, 212.37109375), Point(42.61328125, 212.8046875), Point(37.265625, 212.8046875)),
    PathCurve(Point(30.02734375, 212.8046875), Point(24.48828125, 211.67578125), Point(20.6484375, 209.4140625)),
    PathCurve(Point(16.8046875, 207.15234375), Point(14.8828125, 204.44140625), Point(14.8828125, 201.2734375)),
    PathCurve(Point(14.8828125, 198.63671875), Point(15.953125, 196.4140625), Point(18.1015625, 194.60546875)),
    PathCurve(Point(20.25, 192.796875), Point(23.1328125, 191.89453125), Point(26.75, 191.89453125)),
    PathCurve(Point(29.46484375, 191.89453125), Point(31.6328125, 192.62890625), Point(33.25, 194.09765625)),
    PathCurve(Point(34.87109375, 195.56640625), Point(36.2109375, 197.01953125), Point(37.265625, 198.44921875)),
    PathCurve(Point(38.46875, 200.03125), Point(39.48828125, 201.0859375), Point(40.31640625, 201.61328125)),
    PathCurve(Point(41.14453125, 202.140625), Point(41.8984375, 202.40625), Point(42.578125, 202.40625)),
    PathCurve(Point(44.0078125, 202.40625), Point(45.1015625, 201.55859375), Point(45.85546875, 199.86328125)),
    PathCurve(Point(46.609375, 198.16796875), Point(46.984375, 194.87109375), Point(46.984375, 189.97265625)),
    PathLine(Point(46.984375, 97.05078125)),
    PathLine(Point(72.87109375, 89.9296875)),
    PathClose(),]

    # "u"
    _u = [
    PathMove(Point(109.73828125, 92.4140625)),
    PathLine(Point(109.73828125, 152.21484375)),
    PathCurve(Point(109.73828125, 153.875), Point(110.05859375, 155.4375), Point(110.69921875, 156.90625)),
    PathCurve(Point(111.33984375, 158.375), Point(112.2265625, 159.640625), Point(113.35546875, 160.6953125)),
    PathCurve(Point(114.48828125, 161.75), Point(115.8046875, 162.59765625), Point(117.3125, 163.23828125)),
    PathCurve(Point(118.8203125, 163.87890625), Point(120.44140625, 164.19921875), Point(122.17578125, 164.19921875)),
    PathCurve(Point(124.1328125, 164.19921875), Point(126.359375, 163.1015625), Point(129.0703125, 161.203125)),
    PathCurve(Point(133.36328125, 158.1953125), Point(135.96484375, 156.12890625), Point(135.96484375, 153.68359375)),
    PathCurve(Point(135.96484375, 153.09765625), Point(135.96484375, 92.4140625), Point(135.96484375, 92.4140625)),
    PathLine(Point(161.73828125, 92.4140625)),
    PathLine(Point(161.73828125, 177.3125)),
    PathLine(Point(135.96484375, 177.3125)),
    PathLine(Point(135.96484375, 169.3984375)),
    PathCurve(Point(132.57421875, 172.26171875), Point(128.95703125, 174.55859375), Point(125.11328125, 176.29296875)),
    PathCurve(Point(121.26953125, 178.02734375), Point(117.5390625, 178.89453125), Point(113.921875, 178.89453125)),
    PathCurve(Point(109.703125, 178.89453125), Point(105.78125, 178.1953125), Point(102.1640625, 176.80078125)),
    PathCurve(Point(98.546875, 175.40625), Point(95.3828125, 173.50390625), Point(92.671875, 171.09375)),
    PathCurve(Point(89.95703125, 168.68359375), Point(87.828125, 165.85546875), Point(86.28125, 162.61328125)),
    PathCurve(Point(84.73828125, 159.375), Point(83.96484375, 155.90625), Point(83.96484375, 152.21484375)),
    PathLine(Point(83.96484375, 92.4140625)),
    PathClose()]

    # "l"
    _l = [
    PathMove(Point(197.8828125, 177.3125)),
    PathLine(Point(172.22265625, 177.3125)),
    PathLine(Point(172.22265625, 58.27734375)),
    PathLine(Point(197.8828125, 51.15625)),
    PathClose()]

    #  "u"
    _i = [
    PathMove(Point(208.6015625, 97.05078125)),
    PathLine(Point(234.375, 89.9296875)),
    PathLine(Point(234.375, 177.3125)),
    PathLine(Point(208.6015625, 177.3125)),
    PathClose()]

    _a = [
    PathMove(Point(288.2265625, 133.44921875)),
    PathCurve(Point(285.73828125, 134.5078125), Point(283.23046875, 135.73046875), Point(280.70703125, 137.125)),
    PathCurve(Point(278.18359375, 138.51953125), Point(275.8828125, 140.046875), Point(273.8125, 141.703125)),
    PathCurve(Point(271.73828125, 143.359375), Point(270.0625, 145.1328125), Point(268.78125, 147.015625)),
    PathCurve(Point(267.5, 148.8984375), Point(266.859375, 150.859375), Point(266.859375, 152.89453125)),
    PathCurve(Point(266.859375, 154.4765625), Point(267.06640625, 156.00390625), Point(267.48046875, 157.47265625)),
    PathCurve(Point(267.89453125, 158.94140625), Point(268.48046875, 160.203125), Point(269.234375, 161.2578125)),
    PathCurve(Point(269.98828125, 162.3125), Point(270.81640625, 163.16015625), Point(271.72265625, 163.80078125)),
    PathCurve(Point(272.625, 164.44140625), Point(273.60546875, 164.76171875), Point(274.66015625, 164.76171875)),
    PathCurve(Point(276.76953125, 164.76171875), Point(278.8984375, 164.12109375), Point(281.046875, 162.83984375)),
    PathCurve(Point(283.1953125, 161.55859375), Point(285.5859375, 159.94140625), Point(288.2265625, 157.98046875)),
    PathClose(),
    PathMove(Point(314.109375, 177.3125)),
    PathLine(Point(288.2265625, 177.3125)),
    PathLine(Point(288.2265625, 170.52734375)),
    PathCurve(Point(286.79296875, 171.734375), Point(285.3984375, 172.84765625), Point(284.04296875, 173.86328125)),
    PathCurve(Point(282.6875, 174.87890625), Point(281.16015625, 175.765625), Point(279.46484375, 176.51953125)),
    PathCurve(Point(277.76953125, 177.2734375), Point(275.8671875, 177.85546875), Point(273.75390625, 178.2734375)),
    PathCurve(Point(271.64453125, 178.6875), Point(269.15625, 178.89453125), Point(266.296875, 178.89453125)),
    PathCurve(Point(262.375, 178.89453125), Point(258.8515625, 178.328125), Point(255.7265625, 177.19921875)),
    PathCurve(Point(252.59765625, 176.06640625), Point(249.94140625, 174.5234375), Point(247.7578125, 172.5625)),
    PathCurve(Point(245.5703125, 170.60546875), Point(243.89453125, 168.28515625), Point(242.7265625, 165.609375)),
    PathCurve(Point(241.55859375, 162.9375), Point(240.97265625, 160.015625), Point(240.97265625, 156.8515625)),
    PathCurve(Point(240.97265625, 153.609375), Point(241.59375, 150.671875), Point(242.83984375, 148.03125)),
    PathCurve(Point(244.08203125, 145.39453125), Point(245.77734375, 143.0234375), Point(247.92578125, 140.91015625)),
    PathCurve(Point(250.07421875, 138.80078125), Point(252.578125, 136.91796875), Point(255.44140625, 135.2578125)),
    PathCurve(Point(258.3046875, 133.6015625), Point(261.37890625, 132.07421875), Point(264.65625, 130.6796875)),
    PathCurve(Point(267.93359375, 129.28515625), Point(271.34375, 128.0078125), Point(274.88671875, 126.83984375)),
    PathCurve(Point(278.42578125, 125.671875), Point(281.93359375, 124.55859375), Point(285.3984375, 123.50390625)),
    PathLine(Point(288.2265625, 122.82421875)),
    PathLine(Point(288.2265625, 114.4609375)),
    PathCurve(Point(288.2265625, 109.03515625), Point(287.1875, 105.19140625), Point(285.1171875, 102.9296875)),
    PathCurve(Point(283.04296875, 100.66796875), Point(280.2734375, 99.5390625), Point(276.80859375, 99.5390625)),
    PathCurve(Point(272.73828125, 99.5390625), Point(269.91015625, 100.51953125), Point(268.328125, 102.4765625)),
    PathCurve(Point(266.74609375, 104.4375), Point(265.953125, 106.80859375), Point(265.953125, 109.59765625)),
    PathCurve(Point(265.953125, 111.1796875), Point(265.78515625, 112.7265625), Point(265.4453125, 114.234375)),
    PathCurve(Point(265.109375, 115.7421875), Point(264.5234375, 117.05859375), Point(263.6953125, 118.19140625)),
    PathCurve(Point(262.8671875, 119.3203125), Point(261.6796875, 120.2265625), Point(260.1328125, 120.90234375)),
    PathCurve(Point(258.58984375, 121.58203125), Point(256.6484375, 121.921875), Point(254.3125, 121.921875)),
    PathCurve(Point(250.6953125, 121.921875), Point(247.7578125, 120.8828125), Point(245.49609375, 118.8125)),
    PathCurve(Point(243.234375, 116.73828125), Point(242.10546875, 114.12109375), Point(242.10546875, 110.953125)),
    PathCurve(Point(242.10546875, 108.015625), Point(243.1015625, 105.28515625), Point(245.09765625, 102.76171875)),
    PathCurve(Point(247.09765625, 100.234375), Point(249.7890625, 98.06640625), Point(253.18359375, 96.26171875)),
    PathCurve(Point(256.57421875, 94.44921875), Point(260.4921875, 93.01953125), Point(264.9375, 91.96484375)),
    PathCurve(Point(269.3828125, 90.91015625), Point(274.09375, 90.3828125), Point(279.06640625, 90.3828125)),
    PathCurve(Point(285.171875, 90.3828125), Point(290.4296875, 90.9296875), Point(294.83984375, 92.01953125)),
    PathCurve(Point(299.24609375, 93.11328125), Point(302.8828125, 94.67578125), Point(305.74609375, 96.7109375)),
    PathCurve(Point(308.609375, 98.74609375), Point(310.71875, 101.1953125), Point(312.07421875, 104.05859375)),
    PathCurve(Point(313.43359375, 106.921875), Point(314.109375, 110.12890625), Point(314.109375, 113.66796875)),
    PathClose()]

    _red_dot = [
    PathMove(Point(240.2734375, 68.08984375)),
    PathCurve(Point(240.2734375, 77.7578125), Point(232.4375, 85.58984375), Point(222.7734375, 85.58984375)),
    PathCurve(Point(213.10546875, 85.58984375), Point(205.2734375, 77.7578125), Point(205.2734375, 68.08984375)),
    PathCurve(Point(205.2734375, 58.42578125), Point(213.10546875, 50.58984375), Point(222.7734375, 50.58984375)),
    PathCurve(Point(232.4375, 50.58984375), Point(240.2734375, 58.42578125), Point(240.2734375, 68.08984375)),
    ]

    _blue_dot = [
    PathMove(Point(77.953125, 68.08984375)),
    PathCurve(Point(77.953125, 77.7578125), Point(70.1171875, 85.58984375), Point(60.453125, 85.58984375)),
    PathCurve(Point(50.7890625, 85.58984375), Point(42.953125, 77.7578125), Point(42.953125, 68.08984375)),
    PathCurve(Point(42.953125, 58.42578125), Point(50.7890625, 50.58984375), Point(60.453125, 50.58984375)),
    PathCurve(Point(70.1171875, 50.58984375), Point(77.953125, 58.42578125), Point(77.953125, 68.08984375)),
    ]

    _purple_dot = [
    PathMove(Point(282.3203125, 68.08984375)),
    PathCurve(Point(282.3203125, 77.7578125), Point(274.484375, 85.58984375), Point(264.8203125, 85.58984375)),
    PathCurve(Point(255.15625, 85.58984375), Point(247.3203125, 77.7578125), Point(247.3203125, 68.08984375)),
    PathCurve(Point(247.3203125, 58.42578125), Point(255.15625, 50.58984375), Point(264.8203125, 50.58984375)),
    PathCurve(Point(274.484375, 50.58984375), Point(282.3203125, 58.42578125), Point(282.3203125, 68.08984375)),
    ]

    _green_dot = [
    PathMove(Point(261.30078125, 31.671875)),
    PathCurve(Point(261.30078125, 41.3359375), Point(253.46484375, 49.171875), Point(243.80078125, 49.171875)),
    PathCurve(Point(234.1328125, 49.171875), Point(226.30078125, 41.3359375), Point(226.30078125, 31.671875)),
    PathCurve(Point(226.30078125, 22.0078125), Point(234.1328125, 14.171875), Point(243.80078125, 14.171875)),
    PathCurve(Point(253.46484375, 14.171875), Point(261.30078125, 22.0078125), Point(261.30078125, 31.671875))
    ]

    if action == :clip
        map.(drawpath, (_j, _u, _l, _i, _a))
        map(drawpath, _blue_dot)
        map(drawpath, _green_dot)
        map(drawpath, _purple_dot)
        map(drawpath, _red_dot)
        do_action(:clip)
    elseif action == :path
        map.(drawpath, (_j, _u, _l, _i, _a))
        map(drawpath, _blue_dot)
        map(drawpath, _green_dot)
        map(drawpath, _purple_dot)
        map(drawpath, _red_dot)
    elseif color == true
        setcolor(bodycolor)
        map.(drawpath, (_j, _u, _l, _i, _a))
        do_action(action)

        sethue(Luxor.julia_blue)
        map(drawpath, _blue_dot)
        do_action(action)

        sethue(Luxor.julia_green)
        map(drawpath, _green_dot)
        do_action(action)

        sethue(Luxor.julia_purple)
        map(drawpath, _purple_dot)
        do_action(action)

        sethue(Luxor.julia_red)
        map(drawpath, _red_dot)
        do_action(action)
    else
        sethue(bodycolor)
        map.(drawpath, (_j, _u, _l, _i, _a))
        map(drawpath, _blue_dot)
        map(drawpath, _green_dot)
        map(drawpath, _purple_dot)
        map(drawpath, _red_dot)
        do_action(action)
    end
    # restore saved color
    setcolor(r, g, b, a)

    # and position
    if centered == true
        translate(Point(330, 213)/2)
    end
end

"""
    juliacircles(radius=100;
        outercircleratio=0.75,
        innercircleratio=0.65,
        action=:fill)

Draw the three Julia circles ("dots") in color centered at the origin.

The distance of the centers of each circle from the origin is `radius`.

The optional keyword argument `outercircleratio` (default 0.75) determines the radius of each circle relative to the main radius. So the default is to draw circles of radius 75 points around a larger circle of radius 100.

Return the three centerpoints.

The `innercircleratio` (default 0.65) no longer does anything useful (it used to draw the smaller circles) and will be deprecated.
"""
function juliacircles(radius=100;
        outercircleratio=0.75,
        innercircleratio=0.65,
        action=:fill)
    # clockwise, from bottom left
    color_sequence = [Luxor.julia_red, Luxor.julia_green, Luxor.julia_purple]
    points = ngon(O, radius, 3, pi/6, vertices=true)
    @layer begin
        for (n, p) in enumerate(points)
            setcolor(color_sequence[n]...)
            circle(p, outercircleratio * radius, :path)
            if action != :clip
                do_action(action)
            else
            end
            newsubpath()
        end
    end
    if action == :clip
        do_action(:clip)
    end
    return points
end
