# the current julia logo and graphics

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
    julialogo(;action=:fill, color=true)

Draw the Julia logo. The default action is to fill the logo and use the colors:

    julialogo()

If `color` is `false`, the logo will use the current color, and the dots won't
be colored in the usual way.

The logo can be difficult to position well due to its asymmetric design.
The `0/0` point is at the top left corner, the total width is 315pt, the total height is 214pts. The optical center is _somewhere_ between 163-180pts in x, and 96-114pts in y. The gap to the left edge of "j"s descender is 16; the distance between the left edge of the "j" (not the descender) and the right edge of the "a" is at 268pts.

So, to place the logo by locating its center at a point, do this:

```
gsave()
# scale() first if required
translate(-165, -114) # anything between (x: -163 to -180, y: -96 to -114)
julialogo()
grestore()
```

To use the logo as a clipping mask:

    julialogo(action=:clip)

(In this case the `color` setting is automatically ignored.)

"""
function julialogo(;action=:fill, color=true)
    # save current color
    r, g, b, a = get_current_redvalue(), get_current_greenvalue(), get_current_bluevalue(), get_current_alpha()
    # "j"
    color && setcolor("black")
    move(72.872, 177.311)
    curve(72.872, 184.847, 72.024, 190.932, 70.329, 195.567)
    curve(68.633, 200.202, 66.222, 203.8, 63.094, 206.362)
    curve(59.967, 208.925, 56.217, 210.639, 51.846, 211.506)
    curve(47.476, 212.373, 42.615, 212.806, 37.264, 212.806)
    curve(30.029, 212.806, 24.49, 211.675, 20.647, 209.414)
    curve(16.803, 207.154, 14.881, 204.441, 14.881, 201.275)
    curve(14.881, 198.638, 15.955, 196.415, 18.103, 194.606)
    curve(20.251, 192.797, 23.134, 191.893, 26.751, 191.893)
    curve(29.464, 191.893, 31.631, 192.628, 33.251, 194.097)
    curve(34.872, 195.567, 36.209, 197.018, 37.264, 198.449)
    curve(38.47, 200.032, 39.487, 201.087, 40.316, 201.615)
    curve(41.145, 202.142, 41.899, 202.406, 42.577, 202.406)
    curve(44.009, 202.406, 45.102, 201.558, 45.855, 199.862)
    curve(46.609, 198.167, 46.985, 194.87, 46.985, 189.971)
    line(46.985, 97.051)
    line(72.872, 89.929)
    line(72.872, 177.311)
    newsubpath()

    "u"
    move(109.739, 92.416)
    line(109.739, 152.215)
    curve(109.739, 153.874, 110.06, 155.437, 110.7, 156.907)
    curve(111.341, 158.376, 112.226, 159.639, 113.357, 160.694)
    curve(114.487, 161.749, 115.806, 162.596, 117.313, 163.237)
    curve(118.821, 163.878, 120.441, 164.198, 122.174, 164.198)
    curve(124.134, 164.198, 126.36, 163.101, 129.069, 161.202)
    curve(133.363, 158.194, 135.965, 156.127, 135.965, 153.685)
    curve(135.965, 153.099, 135.965, 92.416, 135.965, 92.416)
    line(161.738, 92.416)
    line(161.738, 177.311)
    line(135.965, 177.311)
    line(135.965, 169.398)
    curve(132.574, 172.262, 128.956, 174.56, 125.113, 176.293)
    curve(121.27, 178.027, 117.539, 178.893, 113.922, 178.893)
    curve(109.702, 178.893, 105.783, 178.196, 102.165, 176.802)
    curve(98.548, 175.408, 95.383, 173.505, 92.67, 171.093)
    curve(89.957, 168.682, 87.828, 165.856, 86.283, 162.615)
    curve(84.739, 159.375, 83.966, 155.908, 83.966, 152.215)
    line(83.966, 92.416)
    line(109.739, 92.416)
    newsubpath()

    "l"
    move(197.881, 177.311)
    line(172.221, 177.311)
    line(172.221, 58.278)
    line(197.881, 51.156)
    line(197.881, 177.311)
    newsubpath()

    "i"
    move(208.603, 97.051)
    line(234.376, 89.929)
    line(234.376, 177.311)
    line(208.603, 177.311)
    line(208.603, 97.051)
    newsubpath()

    "a"
    move(288.225, 133.451)
    curve(285.738, 134.506, 283.232, 135.731, 280.707, 137.124)
    curve(278.183, 138.519, 275.884, 140.045, 273.812, 141.703)
    curve(271.74, 143.361, 270.062, 145.132, 268.782, 147.015)
    curve(267.501, 148.9, 266.86, 150.859, 266.86, 152.894)
    curve(266.86, 154.476, 267.067, 156.002, 267.481, 157.472)
    curve(267.896, 158.941, 268.48, 160.204, 269.234, 161.259)
    curve(269.988, 162.314, 270.816, 163.162, 271.721, 163.802)
    curve(272.625, 164.443, 273.605, 164.763, 274.66, 164.763)
    curve(276.77, 164.763, 278.899, 164.123, 281.047, 162.841)
    curve(283.194, 161.56, 285.587, 159.94, 288.225, 157.981)
    line(288.225, 133.451)
    newsubpath()
    move(314.111, 177.311)
    line(288.225, 177.311)
    line(288.225, 170.528)
    curve(286.792, 171.734, 285.399, 172.846, 284.042, 173.863)
    curve(282.686, 174.88, 281.16, 175.766, 279.464, 176.519)
    curve(277.768, 177.273, 275.866, 177.857, 273.755, 178.272)
    curve(271.645, 178.686, 269.158, 178.893, 266.295, 178.893)
    curve(262.375, 178.893, 258.853, 178.328, 255.725, 177.198)
    curve(252.597, 176.067, 249.941, 174.522, 247.756, 172.563)
    curve(245.571, 170.604, 243.893, 168.287, 242.725, 165.611)
    curve(241.558, 162.936, 240.973, 160.015, 240.973, 156.85)
    curve(240.973, 153.61, 241.595, 150.671, 242.838, 148.033)
    curve(244.082, 145.396, 245.778, 143.022, 247.925, 140.911)
    curve(250.073, 138.801, 252.579, 136.917, 255.443, 135.259)
    curve(258.306, 133.601, 261.377, 132.075, 264.655, 130.681)
    curve(267.934, 129.287, 271.344, 128.006, 274.886, 126.838)
    curve(278.427, 125.67, 281.932, 124.558, 285.399, 123.503)
    line(288.225, 122.825)
    line(288.225, 114.459)
    curve(288.225, 109.034, 287.188, 105.19, 285.116, 102.929)
    curve(283.044, 100.668, 280.274, 99.538, 276.807, 99.538)
    curve(272.738, 99.538, 269.912, 100.518, 268.329, 102.477)
    curve(266.747, 104.436, 265.955, 106.81, 265.955, 109.599)
    curve(265.955, 111.181, 265.786, 112.726, 265.447, 114.233)
    curve(265.108, 115.741, 264.523, 117.059, 263.695, 118.19)
    curve(262.866, 119.32, 261.679, 120.225, 260.134, 120.903)
    curve(258.589, 121.581, 256.649, 121.92, 254.312, 121.92)
    curve(250.695, 121.92, 247.756, 120.884, 245.495, 118.812)
    curve(243.234, 116.739, 242.104, 114.12, 242.104, 110.955)
    curve(242.104, 108.016, 243.102, 105.284, 245.099, 102.76)
    curve(247.097, 100.235, 249.79, 98.068, 253.182, 96.26)
    curve(256.573, 94.451, 260.492, 93.019, 264.938, 91.964)
    curve(269.384, 90.909, 274.094, 90.382, 279.068, 90.382)
    curve(285.173, 90.382, 290.429, 90.928, 294.838, 92.021)
    curve(299.246, 93.114, 302.883, 94.677, 305.746, 96.712)
    curve(308.609, 98.747, 310.72, 101.196, 312.076, 104.06)
    curve(313.433, 106.923, 314.111, 110.127, 314.111, 113.668)
    line(314.111, 177.311)
    (action == :clip) ? newsubpath() : do_action(action)

    color && setcolor(0.796, 0.235, 0.2) # dark red
    circle(Point(240.272, 68.091), Point(205.272, 68.091), :path)
    (action == :clip) ? newsubpath() : do_action(action)

    color && setcolor(0.835, 0.388, 0.361) # light red
    circle(Point(206.772, 68.091), Point(238.772, 68.091), :path)
    (action == :clip) ? newsubpath() : do_action(action)

    color && setcolor(0.251, 0.388, 0.847) # dark blue
    circle(Point(77.954, 68.091), Point(42.954, 68.091), :path)
    (action == :clip) ? newsubpath() : do_action(action)

    color && setcolor(0.4, 0.51, 0.878) # light blue
    circle(Point(44.454, 68.091), Point(76.454, 68.091), :path)
    (action == :clip) ? newsubpath() : do_action(action)

    color && setcolor(0.584, 0.345, 0.698) # dark purple
    circle(Point(282.321, 68.091), Point(247.321, 68.091), :path)
    (action == :clip) ? newsubpath() : do_action(action)

    color && setcolor(0.667, 0.475, 0.757) # lighter purple
    circle(Point(248.821, 68.091), Point(280.821, 68.091), :path)
    (action == :clip) ? newsubpath() : do_action(action)

    color && setcolor(0.22, 0.596, 0.149) # dark green
    circle(Point(261.299, 31.672), Point(226.299, 31.672), :path)
    (action == :clip) ? newsubpath() : do_action(action)

    color && setcolor(0.376, 0.678, 0.318) # light green
    circle(Point(227.799, 31.672), Point(259.799, 31.672), :path)

    if action == :clip
        clip()
    else
        do_action(action)
    end
    # restore saved color
    setcolor(r, g, b, a)
end

"""
    juliacircles(radius=100)

Draw the three Julia circles in color centered at the origin.

The distance of the centers of the circles from the origin is `radius`.
The optional keyword arguments `outercircleratio` (default 0.75) and `innercircleratio`
(default 0.65) control the radius of the individual colored circles relative to the `radius`.
So you can get relatively smaller or larger circles by adjusting the ratios.
"""
function juliacircles(radius=100; outercircleratio=0.75, innercircleratio=0.65)
    # clockwise, from bottom left
    color_sequence = [reds, greens, purples]

    points = ngon(O, radius, 3, pi/6, vertices=true)

    for (n, p) in enumerate(points)
        setcolor(color_sequence[n][1]...)
        circle(p, outercircleratio * radius, :fill)
        setcolor(color_sequence[n][2]...)
        circle(p, innercircleratio * radius, :fill)
    end
end
