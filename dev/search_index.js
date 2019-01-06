var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "Introduction to Luxor",
    "title": "Introduction to Luxor",
    "category": "page",
    "text": "DocTestSetup = quote\n    using Luxor, Dates, Colors\nend"
},

{
    "location": "#Introduction-to-Luxor-1",
    "page": "Introduction to Luxor",
    "title": "Introduction to Luxor",
    "category": "section",
    "text": "Luxor is a Julia package for drawing simple static vector graphics. It provides basic drawing functions and utilities for working with shapes, polygons, clipping masks, PNG images, turtle graphics, animations, and shapefiles.The focus of Luxor is on simplicity and ease of use: it should be easier to use than plain Cairo.jl, with shorter names, fewer underscores, default contexts, and simplified functions.Luxor is thoroughly procedural and static: your code issues a sequence of simple graphics \'commands\' until you\'ve completed a drawing, then the results are saved into a PDF, PNG, SVG, or EPS file.There are some Luxor-related videos on YouTube, and some Luxor-related blog posts at cormullion.github.io/.Luxor isn\'t interactive: for interactive graphics, look at Gtk.jl, GLVisualize, and Makie.Please submit issues and pull requests on GitHub. Original version by cormullion, much improved with contributions from the Julia community."
},

{
    "location": "#Installation-and-basic-usage-1",
    "page": "Introduction to Luxor",
    "title": "Installation and basic usage",
    "category": "section",
    "text": "Install the package using the package manager:] add LuxorCairo.jl and Colors.jl will be installed if necessary.To use Luxor, type:using LuxorTo test:julia> @svg juliacircles()orjulia> @png juliacircles()"
},

{
    "location": "#Documentation-1",
    "page": "Introduction to Luxor",
    "title": "Documentation",
    "category": "section",
    "text": "The documentation was built using Documenter.jl.using Dates # hide\nprintln(\"Documentation built $(Dates.now()) with Julia $(VERSION)\") # hide"
},

{
    "location": "examples/#",
    "page": "A few examples",
    "title": "A few examples",
    "category": "page",
    "text": "DocTestSetup = quote\n    using Luxor, Colors\n    end"
},

{
    "location": "examples/#Examples-1",
    "page": "A few examples",
    "title": "Examples",
    "category": "section",
    "text": ""
},

{
    "location": "examples/#The-obligatory-\"Hello-World\"-1",
    "page": "A few examples",
    "title": "The obligatory \"Hello World\"",
    "category": "section",
    "text": "Here\'s the \"Hello world\":(Image: \"Hello world\")using Luxor\nDrawing(1000, 1000, \"hello-world.png\")\norigin()\nbackground(\"black\")\nsethue(\"red\")\nfontsize(50)\ntext(\"hello world\")\nfinish()\npreview()Drawing(1000, 1000, \"hello-world.png\") defines the width, height, location, and type of the finished image. origin() moves the 0/0 point to the centre of the drawing surface (by default it\'s at the top left corner). Thanks to Colors.jl we can specify colors by name as well as by numeric value: background(\"black\") defines the color of the background of the drawing. text(\"helloworld\") draws the text. It\'s placed at the current 0/0 point and left-justified if you don\'t specify otherwise. finish() completes the drawing and saves the PNG image in the file. preview() tries to open the saved file using some other application (eg Preview on macOS).The macros @png, @svg, and @pdf provide shortcuts for making and previewing graphics without having to provide the usual set-up and finish instructions:# using Luxor\n\n@png begin\n        fontsize(50)\n        circle(O, 150, :stroke)\n        text(\"hello world\", halign=:center, valign=:middle)\n     end(Image: background)@svg begin\n    sethue(\"red\")\n    randpoint = Point(rand(-200:200), rand(-200:200))\n    circle(randpoint, 2, :fill)\n    sethue(\"black\")\n    foreach(f -> arrow(f, between(f, randpoint, .1), arrowheadlength=6),\n        first.(collect(Table(fill(20, 15), fill(20, 15)))))\nend(Image: background)"
},

{
    "location": "examples/#The-Julia-logos-1",
    "page": "A few examples",
    "title": "The Julia logos",
    "category": "section",
    "text": "Luxor contains built-in functions that draw the Julia logo, either in color or a single color, and the three Julia circles.using Luxor\nDrawing(600, 400, \"assets/figures/julia-logos.png\")\norigin()\nbackground(\"white\")\nfor theta in range(0, step=pi/8, length=16)\n    gsave()\n    scale(0.25)\n    rotate(theta)\n    translate(250, 0)\n    randomhue()\n    julialogo(action=:fill, color=false)\n    grestore()\nend\n\ngsave()\nscale(0.3)\njuliacircles()\ngrestore()\n\ntranslate(200, -150)\nscale(0.3)\njulialogo()\nfinish()\nnothing # hide(Image: background)The gsave() function saves the current drawing parameters, and any subsequent changes such as the scale() and rotate() operations are discarded by the next grestore() function.Use the extension to specify the format: for example change julia-logos.png to julia-logos.svg or julia-logos.pdf or julia-logos.eps to produce SVG, PDF, or EPS format output."
},

{
    "location": "examples/#Something-a-bit-more-complicated:-a-Sierpinski-triangle-1",
    "page": "A few examples",
    "title": "Something a bit more complicated: a Sierpinski triangle",
    "category": "section",
    "text": "Here\'s a version of the Sierpinski recursive triangle, clipped to a circle.(Image: Sierpinski)# Subsequent examples will omit these setup and finishing functions:\n#\n# using Luxor, Colors\n# Drawing()\n# background(\"white\")\n# origin()\n\nfunction triangle(points, degree)\n    sethue(cols[degree])\n    poly(points, :fill)\nend\n\nfunction sierpinski(points, degree)\n    triangle(points, degree)\n    if degree > 1\n        p1, p2, p3 = points\n        sierpinski([p1, midpoint(p1, p2),\n                        midpoint(p1, p3)], degree-1)\n        sierpinski([p2, midpoint(p1, p2),\n                        midpoint(p2, p3)], degree-1)\n        sierpinski([p3, midpoint(p3, p2),\n                        midpoint(p1, p3)], degree-1)\n    end\nend\n\nfunction draw(n)\n    circle(O, 75, :clip)\n    points = ngon(O, 150, 3, -pi/2, vertices=true)\n    sierpinski(points, n)\nend\n\ndepth = 8 # 12 is ok, 20 is right out (on my computer, at least)\ncols = distinguishable_colors(depth) # from Colors.jl\ndraw(depth)\n\n# finish()\n# preview()The Point type is an immutable composite type containing x and y fields that specify a 2D point."
},

{
    "location": "examples/#Working-in-Jupyter-and-Juno-1",
    "page": "A few examples",
    "title": "Working in Jupyter and Juno",
    "category": "section",
    "text": "You can use an environment such as a Jupyter notebook or the Juno IDE, and load Luxor at the start of a session. The first drawing will take a few seconds, because the Cairo graphics engine needs to warm up. Subsequent drawings are then much quicker. (This is true of much graphics and plotting work. Julia compiles each function when it first encounters it, and then calls the compiled versions thereafter.)(Image: Jupyter)"
},

{
    "location": "examples/#More-examples-1",
    "page": "A few examples",
    "title": "More examples",
    "category": "section",
    "text": ""
},

{
    "location": "examples/#Maps-1",
    "page": "A few examples",
    "title": "Maps",
    "category": "section",
    "text": "Luxor can read polygons from shapefiles, so you can create simple maps. For example, here\'s part of a map of the world built from a single shapefile, together with the locations of most airports read in from a text file and overlaid.(Image: \"simple world map detail\")The latitude and longitude coordinates are converted directly to drawing coordinates. The latitude coordinates have to be negated because y-coordinates in Luxor typically increase down the page, whereas latitude values increase as you travel North.This is the full map:(Image: \"simple world map\")You\'ll need to install the Shapefile package before running the code:using Shapefile, Luxor\ninclude(joinpath(dirname(pathof(Luxor)), \"readshapefiles.jl\"))\nfunction drawairportmap(outputfilename, countryoutlines, airportdata)\n    Drawing(4000, 2000, outputfilename)\n    origin()\n    scale(10, 10)\n    setline(1.0)\n    fontsize(0.075)\n    gsave()\n    setopacity(0.25)\n    for shape in countryoutlines.shapes\n        randomhue()\n        pgons, bbox = convert(Array{Luxor.Point, 1}, shape)\n        for pgon in pgons\n            poly(pgon, :fill)\n        end\n    end\n    grestore()\n    sethue(\"black\")\n    for airport in airportdata\n        city, country, lat, long = split(chomp(airport), \",\")\n        location = Point(Meta.parse(long), -Meta.parse(lat)) # flip y-coordinate\n        circle(location, .01, :fill)\n        text(string(city), location.x, location.y - 0.02)\n    end\n    finish()\n    preview()\nend\nworldshapefile = joinpath(dirname(pathof(Luxor)), \"../docs/src/assets/examples/outlines-of-world-countries.shp\")\nairportdata = readlines(joinpath(dirname(pathof(Luxor)), \"../docs/src/assets/examples/airports.csv\"))\n\nworldshapes = open(worldshapefile) do f\n    read(f, Shapefile.Handle)\nend\ndrawairportmap(\"/tmp/airport-map.pdf\", worldshapes, airportdata)link to Julia source | link to PDF map"
},

{
    "location": "examples/#Sector-chart-1",
    "page": "A few examples",
    "title": "Sector chart",
    "category": "section",
    "text": "(Image: \"benchmark sector chart\")This sector chart takes raw benchmark scores for a number of languages (from the Julia website and tries to render them literally as radiating sectors. The larger the sector area, the slower the performance; it\'s difficult to see the Julia scores sometimes...!link to PDF | link to Julia source"
},

{
    "location": "examples/#Ampersands-1",
    "page": "A few examples",
    "title": "Ampersands",
    "category": "section",
    "text": "Here are a few ampersands collected together, mainly of interest to typomaniacs and fontophiles. It was necessary to vary the font size of each font, since they\'re naturally different.(Image: \"iloveampersands\")link to PDF original | link to Julia source"
},

{
    "location": "examples/#Moon-phases-1",
    "page": "A few examples",
    "title": "Moon phases",
    "category": "section",
    "text": "Looking upwards again, this moon phase chart shows the calculated phase of the moon for every day in a year.(Image: \"benchmark sector chart\")link to PDF original | link to github repository"
},

{
    "location": "examples/#Misc-images-1",
    "page": "A few examples",
    "title": "Misc images",
    "category": "section",
    "text": "Sometimes you just want to take a line for a walk:(Image: \"pointless\")"
},

{
    "location": "tutorial/#",
    "page": "Tutorial",
    "title": "Tutorial",
    "category": "page",
    "text": "DocTestSetup = quote\n    using Luxor, Colors\n    end"
},

{
    "location": "tutorial/#Tutorial-1",
    "page": "Tutorial",
    "title": "Tutorial",
    "category": "section",
    "text": "Experienced Julia users and programmers fluent in other languages and graphics systems should have no problem using Luxor by referring to the rest of the documentation. For others, here is a short tutorial to help you get started."
},

{
    "location": "tutorial/#What-you-need-1",
    "page": "Tutorial",
    "title": "What you need",
    "category": "section",
    "text": "If you\'ve already downloaded Julia, and have added the Luxor package successfully (using ] add Luxor):$ julia\n               _\n   _       _ _(_)_     |  Documentation: https://docs.julialang.org\n  (_)     | (_) (_)    |\n   _ _   _| |_  __ _   |  Type \"?\" for help, \"]?\" for Pkg help.\n  | | | | | | |/ _` |  |\n  | | |_| | | | (_| |  |  Version 1.0.0 (2018-08-08)\n _/ |\\__\'_|_|_|\\__\'_|  |  Official https://julialang.org/ release\n|__/                   |\n\n(v1.0) pkg>  add Luxorthen you\'re ready to start.You can work in a Jupyter notebook, or perhaps use the Atom/Juno editor/development environment. It\'s also possible to work in a text editor (make sure you know how to run a file of Julia code), or, at a pinch, you could use the Julia REPL directly.Ready? Let\'s begin. The goal of this tutorial is to do a bit of basic \'compass and ruler\' Euclidean geometry, to introduce the basic concepts of Luxor drawings."
},

{
    "location": "tutorial/#First-steps-1",
    "page": "Tutorial",
    "title": "First steps",
    "category": "section",
    "text": "We\'ll have to load just one package for this tutorial:using LuxorHere\'s an easy shortcut for making drawings in Luxor. It\'s a Julia macro, and it\'s a good way to test that your system\'s working. Evaluate this code:@png begin\n    text(\"Hello world\")\n    circle(Point(0, 0), 200, :stroke)\nendusing Luxor\nDrawing(725, 600, \"assets/figures/tutorial-hello-world.png\")\nbackground(\"white\")\norigin()\nsethue(\"black\")\ntext(\"Hello world\")\ncircle(Point(0, 0), 200, :stroke)\nfinish()What happened? Can you see this image somewhere?(Image: point example)If you\'re using Juno, the image should appear in the Plots window. If you\'re working in a Jupyter notebook, the image should appear below the code. If you\'re using Julia in a terminal or text editor, the image should have opened up in some other application, or, at the very least, it should have been saved in your current working directory (as luxor-drawing-(time stamp).png). If nothing happened, or if something bad happened, we\'ve got some set-up or installation issues probably unrelated to Luxor...Let\'s press on. The @png macro is an easy way to make a drawing; all it does is save a bit of typing. (The macro expands to enclose your drawing commands with calls to the Document(), origin(), finish(), and preview() functions.) There are also @svg and @pdf macros, which do a similar thing. PNGs and SVGs are good because they show up in Juno and Jupyter. SVGs are usually higher quality too, but they\'re text-based so can become very large and difficult to load if the image is complex. PDF documents are always higher quality, and usually open up in a separate application.This example illustrates a few things about Luxor drawings:There are default values which you don\'t have to set if you don\'t want to (file names, colors, font sizes, and so on).\nPositions on the drawing are specified with x and y coordinates stored in the Point type, and you can sometimes omit positions altogether.\nThe text was placed at the origin point (0/0), and by default it\'s left aligned.\nThe circle wasn\'t filled, but stroked. We passed the :stroke symbol as an action to the circle() function. Many drawing functions expect some action, such as :fill or :stroke, and sometimes :clip or :fillstroke.\nDid the first drawing takes a few seconds to appear? The Cairo drawing engine takes a little time to warm up. Once it\'s running, drawings appear much faster.Once more, with more black, and some rulers:@png begin\n    text(\"Hello again, world!\", Point(0, 250))\n    circle(Point(0, 0), 200, :fill)\n    rulers()\nendusing Luxor\nDrawing(725, 502, \"assets/figures/tutorial-hello-world-2.png\")\nbackground(\"white\")\norigin()\nsethue(\"black\")\ntext(\"Hello again, world!\", Point(0, 250))\ncircle(Point(0, 0), 200, :fill)\nrulers()\nfinish()(Image: point example)The x-coordinates usually run from left to right, the y-coordinates from top to bottom. So here, Point(0, 250) is a point at the left/right center, but at the bottom of the drawing."
},

{
    "location": "tutorial/#Euclidean-eggs-1",
    "page": "Tutorial",
    "title": "Euclidean eggs",
    "category": "section",
    "text": "For the main section of this tutorial, we\'ll attempt to draw Euclid\'s egg, which involves a bit of geometry.For now, you can continue to store all the drawing instructions between the @png macro\'s begin and end markers. Technically, however, working like this at the top-level in Julia (ie without storing instructions in functions which Julia can compile) isn\'t considered to be \'best practice\', because the unit of compilation in Julia is the function. (Look up \'global scope\' in the documentation.)@png beginand first define the variable radius to hold a value of 80 units (there are 72 units in a traditional inch):    radius=80Select gray dotted lines. To specify a color you can supply RGB (or HSB or LAB or LUV) values or use named colors, such as \"red\" or \"green\". \"gray0\" is black, and \"gray100\" is white. (For more information about colors, see Colors.jl.)    setdash(\"dot\")\n    sethue(\"gray30\")(You can use setcolor() instead of sethue() — the latter doesn\'t affect the current opacity setting.)Next, make two points, A and B, which will lie either side of the origin point. This line uses an array comprehension - notice the square brackets enclosing a for loop.    A, B = [Point(x, 0) for x in [-radius, radius]]x uses two values from the inner array, and a Point using each value is created and stored in a new array. It seems hardly worth doing for two points, but it shows how you can assign more than one variable at the same time, and also how to generate more than two points.With two points defined, draw a line from A to B, and stroke it.    line(A, B, :stroke)Draw a stroked circle too. The center of the circle is placed at the origin. You can use the letter O as a short cut for Origin, ie the Point(0, 0).    circle(O, radius, :stroke)\nendusing Luxor\nDrawing(725, 300, \"assets/figures/tutorial-egg-1.png\")\nbackground(\"white\")\norigin()\nradius=80\nsetdash(\"dot\")\nsethue(\"gray30\")\nA, B = [Point(x, 0) for x in [-radius, radius]]\nline(A, B, :stroke)\ncircle(O, radius, :stroke)\nfinish()\nnothing(Image: point example)"
},

{
    "location": "tutorial/#Labels-and-dots-1",
    "page": "Tutorial",
    "title": "Labels and dots",
    "category": "section",
    "text": "It\'s a good idea to label points in geometrical constructions, and to draw small dots to indicate their location clearly. For the latter task, small filled circles will do. For labels, there\'s a special label() function we can use, which positions a text string close to a point, using angles or points of the compass, so :N places the label to the north of a point.Edit your previous code by adding instructions to draw some labels and circles:@png begin\n    radius=80\n    setdash(\"dot\")\n    sethue(\"gray30\")\n    A, B = [Point(x, 0) for x in [-radius, radius]]\n    line(A, B, :stroke)\n    circle(O, radius, :stroke)\n# >>>>\n    label(\"A\", :NW, A)\n    label(\"O\", :N,  O)\n    label(\"B\", :NE, B)\n\n    circle.([A, O, B], 2, :fill)\n    circle.([A, B], 2radius, :stroke)\nendusing Luxor\nDrawing(725, 400, \"assets/figures/tutorial-egg-2.png\")\nbackground(\"white\")\norigin()\nradius=80\nsetdash(\"dot\")\nsethue(\"gray30\")\n\nA, B = [Point(x, 0) for x in [-radius, radius]]\nline(A, B, :stroke)\ncircle(O, radius, :stroke)\nlabel(\"A\", :NW, A)\nlabel(\"O\", :N, O)\nlabel(\"B\", :NE, B)\ncircle.([A, O, B], 2, :fill)\ncircle.([A, B], 2radius, :stroke)\nfinish()(Image: point example)While we could have drawn all the circles as usual, we\'ve taken the opportunity to introduce a powerful Julia feature called broadcasting. The dot (.) just after the function name in the last two circle() function calls tells Julia to apply the function to all the arguments. We supplied an array of three points, and filled circles were placed at each one. Then we supplied an array of two points and stroked circles were placed there. Notice that we didn\'t have to supply an array of radius values or an array of actions — in each case Julia did the necessary broadcasting (from scalar to vector) for us."
},

{
    "location": "tutorial/#Intersect-this-1",
    "page": "Tutorial",
    "title": "Intersect this",
    "category": "section",
    "text": "We\'re now ready to tackle the job of finding the coordinates of the two points where two circles intersect. There\'s a Luxor function called intersectionlinecircle() that finds the point or points where a line intersects a circle. So we can find the two points where one of the circles crosses an imaginary vertical line drawn through O. Because of the symmetry, we\'ll only have to do circle A.@png begin\n    # as before\n    radius=80\n    setdash(\"dot\")\n    sethue(\"gray30\")\n    A, B = [Point(x, 0) for x in [-radius, radius]]\n    line(A, B, :stroke)\n    circle(O, radius, :stroke)\n\n    label(\"A\", :NW, A)\n    label(\"O\", :N,  O)\n    label(\"B\", :NE, B)\n\n    circle.([A, O, B], 2, :fill)\n    circle.([A, B], 2radius, :stroke)The intersectionlinecircle() takes four arguments: two points to define the line and a point/radius pair to define the circle. It returns the number of intersections (probably 0, 1, or 2), followed by the two points.The line is specified with two points with an x value of 0 and y values of ± twice the radius, written in Julia\'s math-friendly style. The circle is centered at A and has a radius of AB (which is 2radius). Assuming that there are two intersections, we feed these to circle() and label() for drawing and labeling using our new broadcasting superpowers.# >>>>\n    nints, C, D =\n        intersectionlinecircle(Point(0, -2radius), Point(0, 2radius), A, 2radius)\n\n    if nints == 2\n        circle.([C, D], 2, :fill)\n        label.([\"D\", \"C\"], :N, [D, C])\n    end\n\nendusing Luxor\nDrawing(725, 400, \"assets/figures/tutorial-egg-3.png\")\nbackground(\"white\")\norigin()\nradius=80\nsetdash(\"dot\")\nsethue(\"gray30\")\n\nA, B = [Point(x, 0) for x in [-radius, radius]]\nline(A, B, :stroke)\ncircle(O, radius, :stroke)\nlabel(\"A\", :NW, A)\nlabel(\"O\", :N, O)\nlabel(\"B\", :NE, B)\ncircle.([A, O, B], 2, :fill)\ncircle.([A, B], 2radius, :stroke)\n\nnints, C, D = intersectionlinecircle(Point(0, -2radius), Point(0, 2radius), A, 2radius)\nif nints == 2\n    circle.([C, D], 2, :fill)\n    label.([\"D\", \"C\"], :N, [D, C])\nend\n\nfinish()(Image: point example)"
},

{
    "location": "tutorial/#The-upper-circle-1",
    "page": "Tutorial",
    "title": "The upper circle",
    "category": "section",
    "text": "Now for the trickiest part of this construction: a small circle whose center point sits on top of the inner circle and that meets the two larger circles near the point D.Finding this new center point C1 is easy enough, because we can again use intersectionlinecircle() to find the point where the central circle crosses a line from O to D.Add some more lines to your code:@png begin\n\n# >>>>\n\n    nints, C1, C2 = intersectionlinecircle(O, D, O, radius)\n    if nints == 2\n        circle(C1, 3, :fill)\n        label(\"C1\", :N, C1)\n    end\n\nendusing Luxor\nDrawing(725, 400, \"assets/figures/tutorial-egg-4.png\")\nbackground(\"white\")\norigin()\nradius=80\nsetdash(\"dot\")\nsethue(\"gray30\")\n\nA, B = [Point(x, 0) for x in [-radius, radius]]\nline(A, B, :stroke)\ncircle(O, radius, :stroke)\nlabel(\"A\", :NW, A)\nlabel(\"O\", :N, O)\nlabel(\"B\", :NE, B)\ncircle.([A, O, B], 2, :fill)\ncircle.([A, B], 2radius, :stroke)\n\nnints, C, D = intersectionlinecircle(Point(0, -2radius), Point(0, 2radius), A, 2radius)\nif nints == 2\n    circle.([C, D], 2, :fill)\n    label.([\"D\", \"C\"], :N, [D, C])\nend\n\nnints, C1, C2 = intersectionlinecircle(O, D, O, radius)\nif nints == 2\n    circle(C1, 3, :fill)\n    label(\"C1\", :N, C1)\nend\nfinish()(Image: point example)The two other points that define this circle lie on the intersections of the large circles with imaginary lines through points A and B passing through the center point C1. We\'re looking for the lines A-C1-ip, where ip is somewhere on the circle between D and B, and B-C1-ip, where ip is somewhere between A and D.To find (and draw) these points is straightforward. We\'ll mark these as intermediate for now, because there are in fact four intersection points but we want just the two nearest the top:# >>>>\n\n    nints, I3, I4 = intersectionlinecircle(A, C1, A, 2radius)\n    nints, I1, I2 = intersectionlinecircle(B, C1, B, 2radius)\n\n    circle.([I1, I2, I3, I4], 2, :fill)So we can use the distance() function to find the distance between two points, and it\'s simple enough to compare the values and choose the shortest.\n# >>>>\n\n    if distance(C1, I1) < distance(C1, I2)\n       ip1 = I1\n    else\n       ip1 = I2\n    end\n    if distance(C1, I3) < distance(C1, I4)\n       ip2 = I3\n    else\n       ip2 = I4\n    end\n\n    label(\"ip1\", :N, ip1)\n    label(\"ip2\", :N, ip2)\n    circle(C1, distance(C1, ip1), :stroke)\n\nendusing Luxor\nDrawing(725, 400, \"assets/figures/tutorial-egg-5.png\")\nbackground(\"white\")\norigin()\nradius=80\nsetdash(\"dot\")\nsethue(\"gray30\")\n\nA, B = [Point(x, 0) for x in [-radius, radius]]\nline(A, B, :stroke)\ncircle(O, radius, :stroke)\nlabel(\"A\", :NW, A)\nlabel(\"O\", :N, O)\nlabel(\"B\", :NE, B)\ncircle.([A, O, B], 2, :fill)\ncircle.([A, B], 2radius, :stroke)\n\nnints, C, D = intersectionlinecircle(Point(0, -2radius), Point(0, 2radius), A, 2radius)\nif nints == 2\n    circle.([C, D], 2, :fill)\n    label.([\"D\", \"C\"], :N, [D, C])\nend\n\nnints, C1, C2 = intersectionlinecircle(O, D, O, radius)\nif nints == 2\n    circle(C1, 3, :fill)\n    label(\"C1\", :N, C1)\nend\n\n# finding two more points on the circumference\n\nnints, I3, I4 = intersectionlinecircle(A, C1, A, 2radius)\nnints, I1, I2 = intersectionlinecircle(B, C1, B, 2radius)\n\ncircle.([I1, I2, I3, I4], 2, :fill)\n\nif distance(C1, I1) < distance(C1, I2)\n    ip1 = I1\nelse\n   ip1 = I2\nend\nif distance(C1, I3) < distance(C1, I4)\n   ip2    = I3\nelse\n   ip2 = I4\nend\n\nlabel(\"ip1\", :N, ip1)\nlabel(\"ip2\", :N, ip2)\ncircle(C1, distance(C1, ip1), :stroke)\n\nfinish()(Image: point example)"
},

{
    "location": "tutorial/#Eggs-at-the-ready-1",
    "page": "Tutorial",
    "title": "Eggs at the ready",
    "category": "section",
    "text": "We now know all the points on the egg\'s perimeter, and the centers of the circular arcs. To draw the outline, we\'ll use the arc2r() function four times. This function takes: a center point and two points that together define a circular arc, plus an action.The shape consists of four curves, so we\'ll use the :path action. Instead of immediately drawing the shape, like the :fill and :stroke actions do, this action adds a section to the current path.\n    label(\"ip1\", :N, ip1)\n    label(\"ip2\", :N, ip2)\n    circle(C1, distance(C1, ip1), :stroke)\n\n# >>>>\n\n    setline(5)\n    setdash(\"solid\")\n\n    arc2r(B,    A,  ip1, :path) # centered at B, from A to ip1\n    arc2r(C1, ip1,  ip2, :path)\n    arc2r(A,  ip2,    B, :path)\n    arc2r(O,    B,    A, :path)Finally, once we\'ve added all four sections to the path we can stroke and fill it. If you want to use separate styles for the stroke and fill, you can use a preserve version of the first action. This applies the action but keeps the path available for more actions.    strokepreserve()\n    setopacity(0.8)\n    sethue(\"ivory\")\n    fillpath()\nendusing Luxor\nDrawing(725, 400, \"assets/figures/tutorial-egg-6.png\")\nbackground(\"white\")\norigin()\nradius=80\nsetdash(\"dot\")\nsethue(\"gray30\")\n\nA, B = [Point(x, 0) for x in [-radius, radius]]\nline(A, B, :stroke)\ncircle(O, radius, :stroke)\nlabel(\"A\", :NW, A)\nlabel(\"O\", :N, O)\nlabel(\"B\", :NE, B)\ncircle.([A, O, B], 2, :fill)\ncircle.([A, B], 2radius, :stroke)\n\nnints, C, D =\n    intersectionlinecircle(Point(0, -2radius), Point(0, 2radius), A, 2radius)\nif nints == 2\n    circle.([C, D], 2, :fill)\n    label.([\"D\", \"C\"], :N, [D, C])\nend\n\nnints, C1, C2 = intersectionlinecircle(O, D, O, radius)\nif nints == 2\n    circle(C1, 3, :fill)\n    label(\"C1\", :N, C1)\nend\n\n# finding two more points on the circumference\n\nnints, I3, I4 = intersectionlinecircle(A, C1, A, 2radius)\nnints, I1, I2 = intersectionlinecircle(B, C1, B, 2radius)\n\ncircle.([I1, I2, I3, I4], 2, :fill)\n\nif distance(C1, I1) < distance(C1, I2)\n    ip1 = I1\nelse\n   ip1 = I2\nend\nif distance(C1, I3) < distance(C1, I4)\n   ip2    = I3\nelse\n   ip2 = I4\nend\n\nlabel(\"ip1\", :N, ip1)\nlabel(\"ip2\", :N, ip2)\ncircle(C1, distance(C1, ip1), :stroke)\n\nsetline(5)\nsetdash(\"solid\")\n\narc2r(B, A, ip1, :path)\narc2r(C1, ip1, ip2, :path)\narc2r(A, ip2, B, :path)\narc2r(O, B, A, :path)\nstrokepreserve()\nsetopacity(0.8)\nsethue(\"ivory\")\nfillpath()\nfinish()(Image: point example)"
},

{
    "location": "tutorial/#Egg-stroke-1",
    "page": "Tutorial",
    "title": "Egg stroke",
    "category": "section",
    "text": "To be more generally useful, the above code can be boiled into a single function.function egg(radius, action=:none)\n    A, B = [Point(x, 0) for x in [-radius, radius]]\n    nints, C, D =\n        intersectionlinecircle(Point(0, -2radius), Point(0, 2radius), A, 2radius)\n\n    flag, C1 = intersectionlinecircle(C, D, O, radius)\n    nints, I3, I4 = intersectionlinecircle(A, C1, A, 2radius)\n    nints, I1, I2 = intersectionlinecircle(B, C1, B, 2radius)\n\n    if distance(C1, I1) < distance(C1, I2)\n        ip1 = I1\n    else\n        ip1 = I2\n    end\n    if distance(C1, I3) < distance(C1, I4)\n        ip2 = I3\n    else\n        ip2 = I4\n    end\n\n    newpath()\n    arc2r(B, A, ip1, :path)\n    arc2r(C1, ip1, ip2, :path)\n    arc2r(A, ip2, B, :path)\n    arc2r(O, B, A, :path)\n    closepath()\n\n    do_action(action)\nendThis keeps all the intermediate code and calculations safely hidden away, and it\'s now possible to draw a Euclidean egg by calling egg(100, :stroke), for example, where 100 is the required width (radius), and :stroke is the required actions.(Of course, there\'s no error checking. This should be added if the function is to be used for any serious applications...!)Notice that this function doesn\'t define anything about what color it is, or where it\'s placed. When called, the function inherits the current drawing environment: scale, rotation, position of the origin, line thickness, color, style, and so on. This lets us write code like this:@png begin\n    setopacity(0.7)\n    for theta in range(0, step=pi/6, length=12)\n        @layer begin\n            rotate(theta)\n            translate(0, -150)\n            egg(50, :path)\n            setline(10)\n            randomhue()\n            fillpreserve()\n\n            randomhue()\n            strokepath()\n        end\n    end\nend 800 800 \"/tmp/eggstravaganza.png\"using Luxor, Random\nRandom.seed!(42)\nDrawing(725, 500, \"assets/figures/tutorial-egg-7.png\")\nfunction egg(radius, action=:none)\n    A, B = [Point(x, 0) for x in [-radius, radius]]\n    nints, C, D =\n        intersectionlinecircle(Point(0, -2radius), Point(0, 2radius), A, 2radius)\n\n    flag, C1 = intersectionlinecircle(C, D, O, radius)\n    nints, I3, I4 = intersectionlinecircle(A, C1, A, 2radius)\n    nints, I1, I2 = intersectionlinecircle(B, C1, B, 2radius)\n\n    if distance(C1, I1) < distance(C1, I2)\n        ip1 = I1\n    else\n        ip1 = I2\n    end\n    if distance(C1, I3) < distance(C1, I4)\n        ip2 = I3\n    else\n        ip2 = I4\n    end\n\n    newpath()\n    arc2r(B, A, ip1, :path)\n    arc2r(C1, ip1, ip2, :path)\n    arc2r(A, ip2, B, :path)\n    arc2r(O, B, A, :path)\n    closepath()\n    do_action(action)\nend\nbackground(\"white\")\norigin()\nsetopacity(0.7)\nfor theta in range(0, step=pi/6, length=12)\n    @layer begin\n        rotate(theta)\n        translate(0, -150)\n        egg(50, :path)\n        setline(10)\n        randomhue()\n        fillpreserve()\n\n        randomhue()\n        strokepath()\n    end\nend\nfinish()(Image: point example)The loop runs 12 times, with theta increasing from 0 upwards in steps of π/6. But before each egg is drawn, the entire drawing environment is rotated by theta radians and then shifted along the y-axis away from the origin by -150 units (the y-axis values usually increase downwards, so, before any rotation takes place, a shift of -150 looks like an upwards shift). The randomhue() function does what you expect, and the egg() function is passed the :fill action and the radius.Notice that the four drawing instructions are encased in a @layer begin...end shell. Any change made to the drawing environment inside this shell is discarded after the end. This allows us to make temporary changes to the scale and rotation, etc. and discard them easily once the shapes have been drawn.Rotations and angles are typically specified in radians. The positive x-axis (a line from the origin increasing in x) starts off heading due east from the origin, and the y-axis due south, and positive angles are clockwise (ie from the positive x-axis towards the positive y-axis). So the second egg in the previous example was drawn after the axes were rotated by π/6 radians clockwise.If you look closely you can tell which egg was drawn first — it\'s overlapped on each side by subsequent eggs."
},

{
    "location": "tutorial/#Thought-experiments-1",
    "page": "Tutorial",
    "title": "Thought experiments",
    "category": "section",
    "text": "What would happen if the translation was translate(0, 150) rather than translate(0, -150)?\nWhat would happen if the translation was translate(150, 0) rather than translate(0, -150)?\nWhat would happen if you translated each egg before you rotated the drawing environment?Some useful tools for investigating the important aspects of coordinates and transformations include:rulers() to draw the current x and y axes\ngetrotation() to get the current rotation\ngetscale() to get the current scale"
},

{
    "location": "tutorial/#Polyeggs-1",
    "page": "Tutorial",
    "title": "Polyeggs",
    "category": "section",
    "text": "As well as stroke and fill actions, you can use the path as a clipping region (:clip), or as the basis for more shape shifting.The egg() function creates a path and lets you apply an action to it. It\'s also possible to convert the path into a polygon (an array of points), which lets you do more things with it. The following code converts the egg\'s path into a polygon, and then moves every other point of the polygon halfway towards the centroid.@png begin\n    egg(160, :path)\n    pgon = first(pathtopoly())The pathtopoly() function converts the current path made by egg(160, :path) into a polygon. Those smooth curves have been approximated by a series of straight line segments. The first() function is used because pathtopoly() returns an array of one or more polygons (paths can consist of a series of loops), and we know that we need only the single path here.    pc = polycentroid(pgon)\n    circle(pc, 5, :fill)polycentroid() finds the centroid of the new polygon.This loop steps through the points and moves every odd-numbered one halfway towards the centroid. between() finds a point midway between two specified points. Finally the poly() function draws the array of points.    for pt in 1:2:length(pgon)\n        pgon[pt] = between(pc, pgon[pt], 0.5)\n    end\n    poly(pgon, :stroke)\nendusing Luxor\nDrawing(725, 500, \"assets/figures/tutorial-egg-8.png\")\nfunction egg(radius, action=:none)\n    A, B = [Point(x, 0) for x in [-radius, radius]]\n    nints, C, D =\n        intersectionlinecircle(Point(0, -2radius), Point(0, 2radius), A, 2radius)\n\n    flag, C1 = intersectionlinecircle(C, D, O, radius)\n    nints, I3, I4 = intersectionlinecircle(A, C1, A, 2radius)\n    nints, I1, I2 = intersectionlinecircle(B, C1, B, 2radius)\n\n    if distance(C1, I1) < distance(C1, I2)\n        ip1 = I1\n    else\n        ip1 = I2\n    end\n    if distance(C1, I3) < distance(C1, I4)\n        ip2    = I3\n    else\n        ip2 = I4\n    end\n\n    newpath()\n    arc2r(B, A, ip1, :path)\n    arc2r(C1, ip1, ip2, :path)\n    arc2r(A, ip2, B, :path)\n    arc2r(O, B, A, :path)\n    closepath()\n    do_action(action)\nend\nbackground(\"white\")\norigin()\negg(160, :path)\nsethue(\"black\")\npgon = first(pathtopoly())\npc = polycentroid(pgon)\ncircle(pc, 5, :fill)\n\nfor pt in 1:2:length(pgon)\n    pgon[pt] = between(pc, pgon[pt], 0.5)\nend\npoly(pgon, :stroke)\nfinish()(Image: point example)The uneven appearance of the interior points here looks to be a result of the default line join settings. Experiment with setlinejoin(\"round\") to see if this makes the geometry look tidier.For a final experiment with our egg() function, here\'s Luxor\'s offsetpoly() function struggling to draw around the spiky egg-based polygon.@png begin\n    egg(80, :path)\n    pgon = first(pathtopoly())\n    pc = polycentroid(pgon)\n\n    for pt in 1:2:length(pgon)\n        pgon[pt] = between(pc, pgon[pt], 0.8)\n    end\n\n    for i in 30:-3:-8\n        randomhue()\n        op = offsetpoly(pgon, i)\n        poly(op, :stroke, close=true)\n    end\nend 800 800 \"/tmp/spike-egg.png\"using Luxor, Random\nDrawing(725, 600, \"assets/figures/tutorial-egg-9.png\")\nfunction egg(radius, action=:none)\n    A, B = [Point(x, 0) for x in [-radius, radius]]\n    nints, C, D =\n        intersectionlinecircle(Point(0, -2radius), Point(0, 2radius), A, 2radius)\n\n    flag, C1 = intersectionlinecircle(C, D, O, radius)\n    nints, I3, I4 = intersectionlinecircle(A, C1, A, 2radius)\n    nints, I1, I2 = intersectionlinecircle(B, C1, B, 2radius)\n\n    if distance(C1, I1) < distance(C1, I2)\n        ip1 = I1\n    else\n        ip1 = I2\n    end\n    if distance(C1, I3) < distance(C1, I4)\n        ip2    = I3\n    else\n        ip2 = I4\n    end\n\n    newpath()\n    arc2r(B, A, ip1, :path)\n    arc2r(C1, ip1, ip2, :path)\n    arc2r(A, ip2, B, :path)\n    arc2r(O, B, A, :path)\n    closepath()\n    do_action(action)\nend\nbackground(\"white\")\norigin()\nRandom.seed!(42)\negg(80, :path)\npgon = first(pathtopoly())\npc = polycentroid(pgon)\ncircle(pc, 5, :fill)\n\nfor pt in 1:2:length(pgon)\n    pgon[pt] = between(pc, pgon[pt], 0.8)\nend\n\nfor i in 30:-3:-8\n    randomhue()\n    op = offsetpoly(pgon, i)\n    poly(op, :stroke, close=true)\nend\n\nfinish()(Image: point example)The small changes in the regularity of the points created by the path-to-polygon conversion and the varying number of samples it made are continually amplified in successive outlinings."
},

{
    "location": "tutorial/#Clipping-1",
    "page": "Tutorial",
    "title": "Clipping",
    "category": "section",
    "text": "A useful feature of Luxor is that you can use shapes as a clipping mask. Graphics can be hidden when they stray outside the boundaries of the mask.In this example, the egg (assuming you\'re still in the same Julia session in which you\'ve defined the egg() function) isn\'t drawn, but is defined to act as a clipping mask. Every graphic shape that you draw now is clipped where it crosses the mask. This is specified by the :clip action which is passed to the doaction() function at the end of the egg().Here, the graphics are provided by the ngon() function, which draws regular n-sided polygons.using Luxor, Colors\n@svg begin\n    setopacity(0.5)\n    eg(a) = egg(150, a)\n    sethue(\"gold\")\n    eg(:fill)\n    eg(:clip)\n    @layer begin\n       for i in 360:-4:1\n           sethue(Colors.HSV(i, 1.0, 0.8))\n           rotate(pi/30)\n           ngon(O, i, 5, 0, :stroke)\n       end\n    end\n    clipreset()\n    sethue(\"red\")\n    eg(:stroke)\nendusing Luxor, Colors\nDrawing(725, 620, \"assets/figures/tutorial-egg-10.png\")\norigin()\nbackground(\"white\")\nfunction egg(radius, action=:none)\n    A, B = [Point(x, 0) for x in [-radius, radius]]\n    nints, C, D =\n        intersectionlinecircle(Point(0, -2radius), Point(0, 2radius), A, 2radius)\n\n    flag, C1 = intersectionlinecircle(C, D, O, radius)\n    nints, I3, I4 = intersectionlinecircle(A, C1, A, 2radius)\n    nints, I1, I2 = intersectionlinecircle(B, C1, B, 2radius)\n\n    if distance(C1, I1) < distance(C1, I2)\n        ip1 = I1\n    else\n        ip1 = I2\n    end\n    if distance(C1, I3) < distance(C1, I4)\n        ip2    = I3\n    else\n        ip2 = I4\n    end\n\n    newpath()\n    arc2r(B, A, ip1, :path)\n    arc2r(C1, ip1, ip2, :path)\n    arc2r(A, ip2, B, :path)\n    arc2r(O, B, A, :path)\n    closepath()\n    do_action(action)\nend\nsetopacity(0.5)\neg(a) = egg(150, a)\nsethue(\"gold\")\neg(:fill)\neg(:clip)\n@layer begin\n   for i in 360:-4:1\n       sethue(Colors.HSV(i, 1.0, 0.8))\n       rotate(pi/30)\n       ngon(O, i, 5, 0, :stroke)\n   end\nend\nclipreset()\nsethue(\"red\")\neg(:stroke)\nfinish()(Image: clip example)It\'s good practice to add a matching clipreset() after the clipping has been completed. Unbalanced clipping can lead to unpredictable results.Good luck with your explorations!"
},

{
    "location": "basics/#",
    "page": "Basic concepts",
    "title": "Basic concepts",
    "category": "page",
    "text": "DocTestSetup = quote\n    using Luxor, Colors\n    end"
},

{
    "location": "basics/#The-basics-1",
    "page": "Basic concepts",
    "title": "The basics",
    "category": "section",
    "text": "The underlying drawing model is that you make shapes, and add points to paths, and these are filled and/or stroked, using the current graphics state, which specifies colors, line thicknesses, and opacity. You can modify the current graphics state by transforming/rotating/scaling it, and setting style parameters, and so on. Subsequent graphics use the new state, but the graphics you\'ve already drawn are unchanged.You can specify points on the drawing surface using Point(x, y). The default origin is at the top left of the drawing area, but you can reposition it at any time. Many of the drawing functions have an action argument. This can be :nothing, :fill, :stroke, :fillstroke, :fillpreserve, :strokepreserve, :clip, or :path. The default is :nothing.Y coordinates increase downwards, so Point(0, 100) is below Point(0, 0). This is the preferred coordinate system for computer graphics software, but mathematicians and scientists may well be used to the y-axis increasing upwards...The main types you\'ll encounter in Luxor are:Name of type Purpose\nDrawing holds the current drawing\nPoint specifies 2D points\nBoundingBox defines a bounding box\nTable defines a table with different column widths and row  heights\nPartition defines a table defined by cell width and height\nTiler defines a rectangular grid of tiles\nBezierPathSegment a Bezier path segment defined by 4 points\nBezierPath contains a series of BezierPathSegments\nGridRect defines a rectangular grid\nGridHex defines a hexagonal grid\nScene used to define a scene for an animation\nTurtle represents a turtle for drawing turtle graphics"
},

{
    "location": "basics/#Points-and-coordinates-1",
    "page": "Basic concepts",
    "title": "Points and coordinates",
    "category": "section",
    "text": "The Point type holds two coordinates, x and y. For example:julia> P = Point(12.0, 13.0)\nLuxor.Point(12.0, 13.0)\n\njulia> P.x\n12.0\n\njulia> P.y\n13.0Points are immutable, so you can\'t change P\'s x or y values directly. But it\'s easy to make new points based on existing ones.Points can be added together:julia> Q = Point(4, 5)\nLuxor.Point(4.0, 5.0)\n\njulia> P + Q\nLuxor.Point(16.0, 18.0)You can add or multiply Points and scalars:julia> 10P\nLuxor.Point(120.0, 130.0)\n\njulia> P + 100\nLuxor.Point(112.0, 113.0)You can also make new points by mixing Points and tuples:julia> P + (10, 0)\nLuxor.Point(22.0, 13.0)\n\njulia> Q * (0.5, 0.5)\nLuxor.Point(2.0, 2.5)You can use the letter O as a shortcut to refer to the current Origin, Point(0, 0).using Luxor # hide\nDrawing(600, 300, \"assets/figures/point-ex.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"blue\") # hide\nrulers()\nbox.([O + (i, 0) for i in range(0, stop=200, length=5)], 20, 20, :stroke)\nfinish() # hide\nnothing # hide(Image: point example)Angles are usually supplied in radians, measured starting at the positive x-axis turning towards the positive y-axis (which usually points \'down\' the page or canvas, so \'clockwise\'). (The main exception is for turtle graphics, which conventionally let you supply angles in degrees.)Coordinates are interpreted as PostScript points, where a point is 1/72 of an inch.Because Julia allows you to combine numbers and variables directly, you can supply units with dimensions and have them converted to points (assuming the current scale is 1:1):inch (in is unavailable, being used by for syntax)\ncm   (centimeters)\nmm   (millimeters)For example:rect(Point(20mm, 2cm), 5inch, (22/7)inch, :fill)"
},

{
    "location": "basics/#Drawings-1",
    "page": "Basic concepts",
    "title": "Drawings",
    "category": "section",
    "text": ""
},

{
    "location": "basics/#Luxor.Drawing",
    "page": "Basic concepts",
    "title": "Luxor.Drawing",
    "category": "type",
    "text": "Create a new drawing, and optionally specify file type (PNG, PDF, SVG, or EPS) and dimensions.\n\nDrawing()\n\ncreates a drawing, defaulting to PNG format, default filename \"luxor-drawing.png\", default size 800 pixels square.\n\nYou can specify the dimensions, and assume the default output filename:\n\nDrawing(400, 300)\n\ncreates a drawing 400 pixels wide by 300 pixels high, defaulting to PNG format, default filename \"luxor-drawing.png\".\n\nDrawing(400, 300, \"my-drawing.pdf\")\n\ncreates a PDF drawing in the file \"my-drawing.pdf\", 400 by 300 pixels.\n\nDrawing(1200, 800, \"my-drawing.svg\")`\n\ncreates an SVG drawing in the file \"my-drawing.svg\", 1200 by 800 pixels.\n\nDrawing(width, height, surfacetype, [filename])\n\ncreates a new drawing of the given surface type (e.g. :svg, :png), storing the image only in memory if no filename is provided.\n\nDrawing(1200, 1200/Base.Mathconstants.golden, \"my-drawing.eps\")\n\ncreates an EPS drawing in the file \"my-drawing.eps\", 1200 wide by 741.8 pixels (= 1200 ÷ ϕ) high. Only for PNG files must the dimensions be integers.\n\nDrawing(\"A4\", \"my-drawing.pdf\")\n\ncreates a drawing in ISO A4 size (595 wide by 842 high) in the file \"my-drawing.pdf\". Other sizes available are:  \"A0\", \"A1\", \"A2\", \"A3\", \"A4\", \"A5\", \"A6\", \"Letter\", \"Legal\", \"A\", \"B\", \"C\", \"D\", \"E\". Append \"landscape\" to get the landscape version.\n\nDrawing(\"A4landscape\")\n\ncreates the drawing A4 landscape size.\n\nPDF files default to a white background, but PNG defaults to transparent, unless you specify one using background().\n\n\n\n\n\n"
},

{
    "location": "basics/#Luxor.paper_sizes",
    "page": "Basic concepts",
    "title": "Luxor.paper_sizes",
    "category": "constant",
    "text": "paper_sizes\n\nThe paper_sizes Dictionary holds a few paper sizes, width is first, so default is Portrait:\n\n\"A0\"      => (2384, 3370),\n\"A1\"      => (1684, 2384),\n\"A2\"      => (1191, 1684),\n\"A3\"      => (842, 1191),\n\"A4\"      => (595, 842),\n\"A5\"      => (420, 595),\n\"A6\"      => (298, 420),\n\"A\"       => (612, 792),\n\"Letter\"  => (612, 792),\n\"Legal\"   => (612, 1008),\n\"Ledger\"  => (792, 1224),\n\"B\"       => (612, 1008),\n\"C\"       => (1584, 1224),\n\"D\"       => (2448, 1584),\n\"E\"       => (3168, 2448))\n\n\n\n\n\n"
},

{
    "location": "basics/#Luxor.finish",
    "page": "Basic concepts",
    "title": "Luxor.finish",
    "category": "function",
    "text": "finish()\n\nFinish the drawing, and close the file. You may be able to open it in an external viewer application with preview().\n\n\n\n\n\n"
},

{
    "location": "basics/#Luxor.preview",
    "page": "Basic concepts",
    "title": "Luxor.preview",
    "category": "function",
    "text": "preview()\n\nIf working in Jupyter (IJulia), display a PNG or SVG file in the notebook.\n\nIf working in Juno, display a PNG or SVG file in the Plot pane.\n\nOtherwise:\n\non macOS, open the file in the default application, which is probably the Preview.app for PNG and PDF, and Safari for SVG\non Unix, open the file with xdg-open\non Windows, pass the filename to explorer.\n\n\n\n\n\n"
},

{
    "location": "basics/#Drawings-and-files-1",
    "page": "Basic concepts",
    "title": "Drawings and files",
    "category": "section",
    "text": "To create a drawing, and optionally specify the filename, type, and dimensions, use the Drawing constructor function.Drawing\npaper_sizesTo finish a drawing and close the file, use finish(), and, to launch an external application to view it, use preview().If you\'re using Jupyter (IJulia), preview() tries to display PNG and SVG files in the next notebook cell.(Image: jupyter)If you\'re using Juno, then PNG and SVG files should appear in the Plots pane.(Image: juno)finish\npreview"
},

{
    "location": "basics/#Luxor.@svg",
    "page": "Basic concepts",
    "title": "Luxor.@svg",
    "category": "macro",
    "text": "@svg drawing-instructions [width] [height] [filename]\n\nCreate and preview an SVG drawing, optionally specifying width and height (the default is 600 by 600). The file is saved in the current working directory as filename if supplied, or luxor-drawing-(timestamp).svg.\n\nExamples\n\n@svg circle(O, 20, :fill)\n\n@svg circle(O, 20, :fill) 400\n\n@svg circle(O, 20, :fill) 400 1200\n\n@svg circle(O, 20, :fill) 400 1200 \"images/test.svg\"\n\n@svg begin\n        setline(10)\n        sethue(\"purple\")\n        circle(O, 20, :fill)\n     end\n\n\n@svg begin\n        setline(10)\n        sethue(\"purple\")\n        circle(O, 20, :fill)\n     end 1200, 1200\n\n\n\n\n\n"
},

{
    "location": "basics/#Luxor.@png",
    "page": "Basic concepts",
    "title": "Luxor.@png",
    "category": "macro",
    "text": "@png drawing-instructions [width] [height] [filename]\n\nCreate and preview an PNG drawing, optionally specifying width and height (the default is 600 by 600). The file is saved in the current working directory as filename, if supplied, or luxor-drawing(timestamp).png.\n\nExamples\n\n@png circle(O, 20, :fill)\n\n@png circle(O, 20, :fill) 400\n\n@png circle(O, 20, :fill) 400 1200\n\n@png circle(O, 20, :fill) 400 1200 \"images/round.png\"\n\n@png begin\n        setline(10)\n        sethue(\"purple\")\n        circle(O, 20, :fill)\n     end\n\n\n@png begin\n        setline(10)\n        sethue(\"purple\")\n        circle(O, 20, :fill)\n     end 1200 1200\n\n\n\n\n\n"
},

{
    "location": "basics/#Luxor.@pdf",
    "page": "Basic concepts",
    "title": "Luxor.@pdf",
    "category": "macro",
    "text": "@pdf drawing-instructions [width] [height] [filename]\n\nCreate and preview an PDF drawing, optionally specifying width and height (the default is 600 by 600). The file is saved in the current working directory as filename if supplied, or luxor-drawing(timestamp).pdf.\n\nExamples\n\n@pdf circle(O, 20, :fill)\n\n@pdf circle(O, 20, :fill) 400\n\n@pdf circle(O, 20, :fill) 400 1200\n\n@pdf circle(O, 20, :fill) 400 1200 \"images/A0-version.pdf\"\n\n@pdf begin\n        setline(10)\n        sethue(\"purple\")\n        circle(O, 20, :fill)\n     end\n\n@pdf begin\n        setline(10)\n        sethue(\"purple\")\n        circle(O, 20, :fill)\n     end 1200, 1200\n\n\n\n\n\n"
},

{
    "location": "basics/#Quick-drawings-with-macros-1",
    "page": "Basic concepts",
    "title": "Quick drawings with macros",
    "category": "section",
    "text": "The @svg, @png, and @pdf macros are designed to let you quickly create graphics without having to provide the usual boiler-plate functions. For example, the Julia code:@svg circle(O, 20, :stroke) 50 50expands toDrawing(50, 50, \"luxor-drawing-(timestamp).png\")\norigin()\nbackground(\"white\")\nsethue(\"black\")\ncircle(O, 20, :stroke)\nfinish()\npreview()They just save a bit of typing. You can omit the width and height (defaulting to 600 by 600), and you don\'t have to specify a filename. For multiple lines, use either:@svg begin\n    setline(10)\n    sethue(\"purple\")\n    circle(O, 20, :fill)\nendor@svg (setline(10);\n      sethue(\"purple\");\n      circle(O, 20, :fill)\n     )@svg\n@png\n@pdfIf you don\'t specify a size, the defaults are 600 by 600. If you don\'t specify a file name, files create with the macros are created in your current working directory as luxor-drawing- followed by a time stamp.If you want to create drawings with transparent backgrounds, use the longer form for creating drawings, rather than the macros:Drawing()\nbackground(1, 1, 1, 0)\norigin()\nsetline(30)\nsetcolor(\"green\")\nbox(BoundingBox() - 50, :stroke)\nfinish()\npreview()(Image: transparent background)"
},

{
    "location": "basics/#Drawings-in-memory-1",
    "page": "Basic concepts",
    "title": "Drawings in memory",
    "category": "section",
    "text": "You can choose to store the drawing in memory. The advantage to this is that in-memory drawings are quicker, and can be passed as Julia data. This syntax for the Drawing() function:Drawing(width, height, surfacetype, [filename])lets you supply surfacetype as a symbol (:svg or :png). This creates a new drawing of the given surface type and stores the image only in memory if no filename is supplied."
},

{
    "location": "basics/#Luxor.background",
    "page": "Basic concepts",
    "title": "Luxor.background",
    "category": "function",
    "text": "background(color)\n\nFill the canvas with a single color. Returns the (red, green, blue, alpha) values.\n\nExamples:\n\nbackground(\"antiquewhite\")\nbackground(\"ivory\")\n\nIf Colors.jl is installed:\n\nbackground(RGB(0, 0, 0))\nbackground(Luv(20, -20, 30))\n\nIf you don\'t specify a background color for a PNG drawing, the background will be transparent. You can set a partly or completely transparent background for PNG files by passing a color with an alpha value, such as this \'transparent black\':\n\nbackground(RGBA(0, 0, 0, 0))\n\n\n\n\n\n"
},

{
    "location": "basics/#Luxor.rulers",
    "page": "Basic concepts",
    "title": "Luxor.rulers",
    "category": "function",
    "text": "rulers()\n\nDraw and label two rulers starting at O, the current 0/0, and continuing out along the current positive x and y axes.\n\n\n\n\n\n"
},

{
    "location": "basics/#Luxor.origin",
    "page": "Basic concepts",
    "title": "Luxor.origin",
    "category": "function",
    "text": "origin()\n\nReset the current matrix, and then set the 0/0 origin to the center of the drawing (otherwise it will stay at the top left corner, the default).\n\nYou can refer to the 0/0 point as O. (O = Point(0, 0)),\n\n\n\n\n\norigin(pt:Point)\n\nReset the current matrix, then move the 0/0 position to pt.\n\n\n\n\n\n"
},

{
    "location": "basics/#The-drawing-surface-1",
    "page": "Basic concepts",
    "title": "The drawing surface",
    "category": "section",
    "text": "The origin (0/0) starts off at the top left: the x axis runs left to right across the page, and the y axis runs top to bottom down the page.The origin() function moves the 0/0 point to the center of the drawing. It\'s often convenient to do this at the beginning of a program.You can use functions like scale(), rotate(), and translate() to change the coordinate system.background() fills the drawing with a color, covering any previous contents. By default, PDF drawings have a white background, whereas PNG drawings have no background so that the background appears transparent in other applications. If there is a current clipping region, background() fills just that region. In the next example, the first background() fills the entire drawing with magenta, but the calls in the loop fill only the active clipping region, a table cell defined by the Table iterator:using Luxor # hide\nDrawing(600, 400, \"assets/figures/backgrounds.png\") # hide\nbackground(\"magenta\")\norigin()\ntable = Table(5, 5, 100, 50)\nfor (pos, n) in table\n    box(pos,\n        table.colwidths[table.currentcol],\n        table.rowheights[table.currentrow],\n        :clip)\n    background(randomhue()...)\n    clipreset()\nend\nfinish() # hide\nnothing # hide(Image: background)The rulers() function draws a couple of rulers to indicate the position and orientation of the current axes.using Luxor # hide\nDrawing(400, 400, \"assets/figures/axes.png\") # hide\nbackground(\"gray80\")\norigin()\nrulers()\nfinish() # hide\nnothing # hide(Image: axes)background\nrulers\norigin"
},

{
    "location": "basics/#Luxor.gsave",
    "page": "Basic concepts",
    "title": "Luxor.gsave",
    "category": "function",
    "text": "gsave()\n\nSave the current color settings on the stack.\n\n\n\n\n\n"
},

{
    "location": "basics/#Luxor.grestore",
    "page": "Basic concepts",
    "title": "Luxor.grestore",
    "category": "function",
    "text": "grestore()\n\nReplace the current graphics state with the one on top of the stack.\n\n\n\n\n\n"
},

{
    "location": "basics/#Save-and-restore-1",
    "page": "Basic concepts",
    "title": "Save and restore",
    "category": "section",
    "text": "gsave() saves a copy of the current graphics settings (current axis rotation, position, scale, line and text settings, color, and so on). When the next grestore() is called, all changes you\'ve made to the graphics settings will be discarded, and the previous settings are restored, so things return to how they were when you last used gsave(). gsave() and grestore() should always be balanced in pairs.The @layer macro is a synonym for a gsave()...grestore() pair.@svg begin\n    circle(O, 100, :stroke)\n    @layer (sethue(\"red\"); rule(O); rule(O, pi/2))\n    circle(O, 200, :stroke)\nendor@svg begin\n    circle(O, 100, :stroke)\n    @layer begin\n        sethue(\"red\")\n        rule(O)\n        rule(O, pi/2)\n    end\n    circle(O, 200, :stroke)\nendgsave\ngrestore"
},

{
    "location": "simplegraphics/#",
    "page": "Simple shapes",
    "title": "Simple shapes",
    "category": "page",
    "text": "DocTestSetup = quote\n    using Luxor, Colors, Random\n    end"
},

{
    "location": "simplegraphics/#Simple-graphics-1",
    "page": "Simple shapes",
    "title": "Simple graphics",
    "category": "section",
    "text": "In Luxor, there are different ways of working with graphical items. You can either draw them immediately (ie place them on the drawing, and they\'re then fixed). Or you can construct geometric objects as lists of points for further processing. Watch out for a vertices=true option, which returns coordinate data rather than draws a shape."
},

{
    "location": "simplegraphics/#Luxor.rect",
    "page": "Simple shapes",
    "title": "Luxor.rect",
    "category": "function",
    "text": "rect(xmin, ymin, w, h, action)\n\nCreate a rectangle with one corner at (xmin/ymin) with width w and height h and then do an action.\n\nSee box() for more ways to do similar things, such as supplying two opposite corners, placing by centerpoint and dimensions.\n\n\n\n\n\nrect(cornerpoint, w, h, action)\n\nCreate a rectangle with one corner at cornerpoint with width w and height h and do an action.\n\n\n\n\n\n"
},

{
    "location": "simplegraphics/#Luxor.box",
    "page": "Simple shapes",
    "title": "Luxor.box",
    "category": "function",
    "text": "box(cornerpoint1, cornerpoint2, action=:nothing; vertices=false)\n\nCreate a rectangle between two points and do an action. Use vertices=true to return an array of the four corner points rather than draw the box.\n\n\n\n\n\nbox(points::AbstractArray, action=:nothing)\n\nCreate a box/rectangle using the first two points of an array of Points to defined opposite corners.\n\n\n\n\n\nbox(pt::Point, width, height, action=:nothing; vertices=false)\n\nCreate a box/rectangle centered at point pt with width and height. Use vertices=true to return an array of the four corner points rather than draw the box.\n\n\n\n\n\nbox(x, y, width, height, action=:nothing)\n\nCreate a box/rectangle centered at point x/y with width and height.\n\n\n\n\n\nbox(x, y, width, height, cornerradius, action=:nothing)\n\nCreate a box/rectangle centered at point x/y with width and height. Round each corner by cornerradius.\n\n\n\n\n\nbox(t::Table, r::Int, c::Int, action::Symbol=:nothing)\n\nDraw a box in table t at row r and column c.\n\n\n\n\n\nbox(t::Table, cellnumber::Int, action::Symbol=:nothing; vertices=false)\n\nDraw box cellnumber in table t.\n\n\n\n\n\nbox(bbox::BoundingBox, :action)\n\nMake a box using the bounds in bbox.\n\n\n\n\n\nbox(tile::BoxmapTile, action::Symbol=:nothing; vertices=false)\n\nUse a Boxmaptile to make or draw a rectangular box. Use vertices=true to obtain the coordinates.\n\nCreate boxmaps using boxmap().\n\n\n\n\n\n"
},

{
    "location": "simplegraphics/#Rectangles-and-boxes-1",
    "page": "Simple shapes",
    "title": "Rectangles and boxes",
    "category": "section",
    "text": "The simple rectangle and box shapes can be made in different ways.using Luxor # hide\nDrawing(400, 220, \"assets/figures/basicrects.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nrulers()\nsethue(\"red\")\nrect(O, 100, 100, :stroke)\nsethue(\"blue\")\nbox(O, 100, 100, :stroke)\nfinish() # hide\nnothing # hide(Image: rect vs box)rect() rectangles are positioned by a corner, but a box made with box() can either be defined by its center and dimensions, or by two opposite corners.(Image: rects)If you want the coordinates of the corners of a box, rather than draw one immediately, use:box(centerpoint, width, height, vertices=true)orbox(corner1,  corner2, vertices=true)box is also able to draw some of the other Luxor objects, such as BoundingBoxes and Table cells.rect\nboxFor regular polygons, triangles, pentagons, and so on, see the next section on Polygons."
},

{
    "location": "simplegraphics/#Luxor.circle",
    "page": "Simple shapes",
    "title": "Luxor.circle",
    "category": "function",
    "text": "circle(x, y, r, action=:nothing)\n\nMake a circle of radius r centered at x/y.\n\naction is one of the actions applied by do_action, defaulting to :nothing. You can also use ellipse() to draw circles and place them by their centerpoint.\n\n\n\n\n\ncircle(pt, r, action=:nothing)\n\nMake a circle centered at pt.\n\n\n\n\n\ncircle(pt1::Point, pt2::Point, action=:nothing)\n\nMake a circle that passes through two points that define the diameter:\n\n\n\n\n\n"
},

{
    "location": "simplegraphics/#Luxor.center3pts",
    "page": "Simple shapes",
    "title": "Luxor.center3pts",
    "category": "function",
    "text": "center3pts(a::Point, b::Point, c::Point)\n\nFind the radius and center point for three points lying on a circle.\n\nreturns (centerpoint, radius) of a circle. Then you can use circle() to place a circle, or arc() to draw an arc passing through those points.\n\nIf there\'s no such circle, then you\'ll see an error message in the console and the function returns (Point(0,0), 0).\n\n\n\n\n\n"
},

{
    "location": "simplegraphics/#Luxor.ellipse",
    "page": "Simple shapes",
    "title": "Luxor.ellipse",
    "category": "function",
    "text": "ellipse(xc, yc, w, h, action=:none)\n\nMake an ellipse, centered at xc/yc, fitting in a box of width w and height h.\n\n\n\n\n\nellipse(cpt, w, h, action=:none)\n\nMake an ellipse, centered at point c, with width w, and height h.\n\n\n\n\n\nellipse(focus1::Point, focus2::Point, k, action=:none;\n        stepvalue=pi/100,\n        vertices=false,\n        reversepath=false)\n\nBuild a polygon approximation to an ellipse, given two points and a distance, k, which is the sum of the distances to the focii of any points on the ellipse (or the shortest length of string required to go from one focus to the perimeter and on to the other focus).\n\n\n\n\n\n"
},

{
    "location": "simplegraphics/#Luxor.circlepath",
    "page": "Simple shapes",
    "title": "Luxor.circlepath",
    "category": "function",
    "text": "circlepath(center::Point, radius, action=:none;\n    reversepath=false,\n    kappa = 0.5522847498307936)\n\nDraw a circle using Bézier curves.\n\nThe magic value, kappa, is 4.0 * (sqrt(2.0) - 1.0) / 3.0.\n\n\n\n\n\n"
},

{
    "location": "simplegraphics/#Circles-and-ellipses-1",
    "page": "Simple shapes",
    "title": "Circles and ellipses",
    "category": "section",
    "text": "There are various ways to make circles, including by center and radius, or passing through two points:using Luxor # hide\nDrawing(400, 200, \"assets/figures/circles.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsetline(2) # hide\np1 = O\np2 = Point(100, 0)\nsethue(\"red\")\ncircle(p1, 40, :fill)\nsethue(\"green\")\ncircle(p1, p2, :stroke)\nsethue(\"black\")\narrow(O, Point(0, -40))\nmap(p -> circle(p, 4, :fill), [p1, p2])\nfinish() # hide\nnothing # hide(Image: circles)Or passing through three points. The center3pts() function returns the center position and radius of a circle passing through three points:using Luxor, Random # hide\nDrawing(400, 200, \"assets/figures/center3.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsetline(3) # hide\nsethue(\"black\")\np1 = Point(0, -50)\np2 = Point(100, 0)\np3 = Point(0, 65)\nmap(p -> circle(p, 4, :fill), [p1, p2, p3])\nsethue(\"orange\")\ncircle(center3pts(p1, p2, p3)..., :stroke)\nfinish() # hide\nnothing # hide(Image: center and radius of 3 points)circle\ncenter3ptsWith ellipse() you can place ellipses and circles by defining the center point and the width and height.using Luxor, Random # hide\nDrawing(500, 300, \"assets/figures/ellipses.png\") # hide\nbackground(\"white\") # hide\nfontsize(11) # hide\nRandom.seed!(1) # hide\norigin() # hide\ntiles = Tiler(500, 300, 5, 5)\nwidth = 20\nheight = 25\nfor (pos, n) in tiles\n    global width, height\n    randomhue()\n    ellipse(pos, width, height, :fill)\n    sethue(\"black\")\n    label = string(round(width/height, digits=2))\n    textcentered(label, pos.x, pos.y + 25)\n    width += 2\nend\nfinish() # hide\nnothing # hide(Image: ellipses)ellipse() can also construct polygons that are approximations to ellipses. You supply two focal points and a length which is the sum of the distances of a point on the perimeter to the two focii.using Luxor, Random # hide\nDrawing(400, 220, \"assets/figures/ellipses_1.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\n\nRandom.seed!(42) # hide\nsethue(\"black\") # hide\nsetline(1) # hide\nfontface(\"Menlo\")\n\nf1 = Point(-100, 0)\nf2 = Point(100, 0)\n\ncircle.([f1, f2], 3, :fill)\n\nepoly = ellipse(f1, f2, 250, vertices=true)\npoly(epoly, :stroke,  close=true)\n\npt = epoly[rand(1:end)]\n\npoly([f1, pt, f2], :stroke)\n\nlabel(\"f1\", :W, f1, offset=10)\nlabel(\"f2\", :E, f2, offset=10)\n\nlabel(string(round(distance(f1, pt), digits=1)), :SE, midpoint(f1, pt))\nlabel(string(round(distance(pt, f2), digits=1)), :SW, midpoint(pt, f2))\n\nlabel(\"ellipse(f1, f2, 250)\", :S, Point(0, 75))\n\nfinish() # hide\nnothing # hide(Image: more ellipses)The advantage of this method is that there\'s a vertices=true option, allowing further scope for polygon manipulation.using Luxor # hide\nDrawing(500, 450, \"assets/figures/ellipses_2.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"gray30\") # hide\nsetline(1) # hide\nf1 = Point(-100, 0)\nf2 = Point(100, 0)\nellipsepoly = ellipse(f1, f2, 170, :none, vertices=true)\n[ begin\n    setgray(rescale(c, 150, 1, 0, 1))\n    poly(offsetpoly(ellipsepoly, c), close=true, :fill);\n    rotate(pi/20)\n  end\n     for c in 150:-10:1 ]\nfinish() # hide\nnothing # hide(Image: even more ellipses)ellipsecirclepath() constructs a circular path from Bézier curves, which allows you to use circles as paths.using Luxor # hide\nDrawing(600, 250, \"assets/figures/circle-path.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"black\") # hide\nsetline(4)\ntiles = Tiler(600, 250, 1, 5)\nfor (pos, n) in tiles\n    randomhue()\n    circlepath(pos, tiles.tilewidth/2, :path)\n    newsubpath()\n    circlepath(pos, rand(5:tiles.tilewidth/2 - 1), :fill, reversepath=true)\nend\nfinish() # hide\nnothing # hide(Image: circles as paths)circlepath"
},

{
    "location": "simplegraphics/#Luxor.circletangent2circles",
    "page": "Simple shapes",
    "title": "Luxor.circletangent2circles",
    "category": "function",
    "text": "circletangent2circles(radius, circle1center::Point, circle1radius, circle2center::Point, circle2radius)\n\nFind the centers of up to two circles of radius radius that are tangent to the two circles defined by circle1... and circle2.... These two circles can overlap, but one can\'t be inside the other.\n\n(0, O, O)      - no such circles exist\n(1, pt1, O)    - 1 circle exists, centered at pt1\n(2, pt1, pt2)  - 2 circles exist, with centers at pt1 and pt2\n\n(The O are just dummy points so that three values are always returned.)\n\n\n\n\n\n"
},

{
    "location": "simplegraphics/#Luxor.circlepointtangent",
    "page": "Simple shapes",
    "title": "Luxor.circlepointtangent",
    "category": "function",
    "text": "circlepointtangent(through::Point, radius, targetcenter::Point, targetradius)\n\nFind the centers of up to two circles of radius radius that pass through point through and are tangential to a circle that has radius targetradius and center targetcenter.\n\nThis function returns a tuple:\n\n(0, O, O)      - no circles exist\n(1, pt1, O)    - 1 circle exists, centered at pt1\n(2, pt1, pt2)  - 2 circles exist, with centers at pt1 and pt2\n\n(The O are just dummy points so that three values are always returned.)\n\n\n\n\n\n"
},

{
    "location": "simplegraphics/#Circles-and-tangents-1",
    "page": "Simple shapes",
    "title": "Circles and tangents",
    "category": "section",
    "text": "Functions to make circles that are tangential to other circles include:circletangent2circles() makes circles of a particular radius tangential to two circles\ncirclepointtangent() makes circles of a particular radius passing through a point and tangential to another circleThese functions can return 0, 1, or 2 points (since there are often two solutions to a specific geometric layout).circletangent2circles() takes the required radius and two existing circles:using Luxor # hide\nDrawing(600, 250, \"assets/figures/circle-tangents.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"black\") # hide\nsetline(1) # hide\n\ncircle1 = (Point(-100, 0), 90)\ncircle(circle1..., :stroke)\ncircle2 = (Point(100, 0), 90)\ncircle(circle2..., :stroke)\n\nrequiredradius = 25\nncandidates, p1, p2 = circletangent2circles(requiredradius, circle1..., circle2...)\n\nif ncandidates==2\n    sethue(\"orange\")\n    circle(p1, requiredradius, :fill)\n    sethue(\"green\")\n    circle(p2, requiredradius, :fill)\n    sethue(\"purple\")\n    circle(p1, requiredradius, :stroke)\n    circle(p2, requiredradius, :stroke)\nend\n\n# the circles are 10 apart, so there should be just one circle\n# that fits there\n\nrequiredradius = 10\nncandidates, p1, p2 = circletangent2circles(requiredradius, circle1..., circle2...)\n\nif ncandidates==1\n    sethue(\"blue\")\n    circle(p1, requiredradius, :fill)\n    sethue(\"cyan\")\n    circle(p1, requiredradius, :stroke)\nend\n\nfinish() # hide\nnothing # hide(Image: circle tangents)circlepointtangent() looks for circles of a specified radius that pass through a point and are tangential to a circle. There are usually two candidates.using Luxor # hide\nDrawing(600, 250, \"assets/figures/circle-point-tangent.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"black\") # hide\nsetline(1) # hide\n\ncircle1 = (Point(-100, 0), 90)\ncircle(circle1..., :stroke)\n\nrequiredradius = 50\nrequiredpassthrough = O + (80, 0)\nncandidates, p1, p2 = circlepointtangent(requiredpassthrough, requiredradius, circle1...)\n\nif ncandidates==2\n    sethue(\"orange\")\n    circle(p1, requiredradius, :stroke)\n    sethue(\"green\")\n    circle(p2, requiredradius, :stroke)\nend\n\nsethue(\"black\")\ncircle(requiredpassthrough, 4, :fill)\n\nfinish() # hide\nnothing # hide(Image: circle tangents 2)circletangent2circles\ncirclepointtangent"
},

{
    "location": "simplegraphics/#Luxor.sector",
    "page": "Simple shapes",
    "title": "Luxor.sector",
    "category": "function",
    "text": "sector(centerpoint::Point, innerradius, outerradius, startangle, endangle, action:none)\n\nDraw an annular sector centered at centerpoint.\n\n\n\n\n\nsector(innerradius::Real, outerradius::Real, startangle::Real, endangle::Real,\n   action::Symbol=:none)\n\nDraw an annular sector centered at the origin.\n\n\n\n\n\nsector(centerpoint::Point, innerradius, outerradius, startangle, endangle,\n    cornerradius, action:none)\n\nDraw an annular sector with rounded corners, basically a bent sausage shape, centered at centerpoint.\n\nTODO: The results aren\'t 100% accurate at the moment. There are small discontinuities where the curves join.\n\nThe cornerradius is reduced from the supplied value if neceesary to prevent overshoots.\n\n\n\n\n\nsector(innerradius::Real, outerradius::Real, startangle::Real, endangle::Real,\n   cornerradius::Real, action::Symbol=:none)\n\nDraw an annular sector with rounded corners, centered at the current origin.\n\n\n\n\n\n"
},

{
    "location": "simplegraphics/#Luxor.pie",
    "page": "Simple shapes",
    "title": "Luxor.pie",
    "category": "function",
    "text": "pie(x, y, radius, startangle, endangle, action=:none)\n\nDraw a pie shape centered at x/y. Angles start at the positive x-axis and are measured clockwise.\n\n\n\n\n\npie(centerpoint, radius, startangle, endangle, action=:none)\n\nDraw a pie shape centered at centerpoint.\n\nAngles start at the positive x-axis and are measured clockwise.\n\n\n\n\n\npie(radius, startangle, endangle, action=:none)\n\nDraw a pie shape centered at the origin\n\n\n\n\n\n"
},

{
    "location": "simplegraphics/#Luxor.spiral",
    "page": "Simple shapes",
    "title": "Luxor.spiral",
    "category": "function",
    "text": "spiral(a, b, action::Symbol=:none;\n                 stepby = 0.01,\n                 period = 4pi,\n                 vertices = false,\n                 log=false)\n\nMake a spiral. The two primary parameters a and b determine the start radius, and the tightness.\n\nFor linear spirals (log=false), b values are:\n\nlituus: -2\n\nhyperbolic spiral: -1\n\nArchimedes\' spiral: 1\n\nFermat\'s spiral: 2\n\nFor logarithmic spirals (log=true):\n\ngolden spiral: b = ln(phi)/ (pi/2) (about 0.30)\n\nValues of b around 0.1 produce tighter, staircase-like spirals.\n\n\n\n\n\n"
},

{
    "location": "simplegraphics/#Luxor.squircle",
    "page": "Simple shapes",
    "title": "Luxor.squircle",
    "category": "function",
    "text": "squircle(center::Point, hradius, vradius, action=:none;\n    rt = 0.5, stepby = pi/40, vertices=false)\n\nMake a squircle or superellipse (basically a rectangle with rounded corners). Specify the center position, horizontal radius (distance from center to a side), and vertical radius (distance from center to top or bottom):\n\nThe root (rt) option defaults to 0.5, and gives an intermediate shape. Values less than 0.5 make the shape more rectangular. Values above make the shape more round. The horizontal and vertical radii can be different.\n\n\n\n\n\n"
},

{
    "location": "simplegraphics/#More-curved-shapes:-sectors,-spirals,-and-squircles-1",
    "page": "Simple shapes",
    "title": "More curved shapes: sectors, spirals, and squircles",
    "category": "section",
    "text": "A sector (technically an \"annular sector\") has an inner and outer radius, as well as start and end angles.using Luxor # hide\nDrawing(600, 200, \"assets/figures/sector.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"tomato\")\nsector(50, 90, pi/2, 0, :fill)\nsethue(\"olive\")\nsector(Point(O.x + 200, O.y), 50, 90, 0, pi/2, :fill)\nfinish() # hide\nnothing # hide(Image: sector)You can also supply a value for a corner radius. The same sector is drawn but with rounded corners.using Luxor # hide\nDrawing(600, 200, \"assets/figures/sectorrounded.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"tomato\")\nsector(50, 90, pi/2, 0, 15, :fill)\nsethue(\"olive\")\nsector(Point(O.x + 200, O.y), 50, 90, 0, pi/2, 15, :fill)\nfinish() # hide\nnothing # hide(Image: sector)sectorA pie (or wedge) has start and end angles.using Luxor # hide\nDrawing(400, 300, \"assets/figures/pie.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"magenta\") # hide\npie(0, 0, 100, pi/2, pi, :fill)\nfinish() # hide\nnothing # hide(Image: pie)pieTo construct spirals, use the spiral() function. These can be drawn directly, or used as polygons. The default is to draw Archimedean (non-logarithmic) spirals.using Luxor # hide\nDrawing(600, 300, \"assets/figures/spiral.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"black\") # hide\nsetline(.5) # hide\nfontface(\"Avenir-Heavy\") # hide\nfontsize(15) # hide\n\nspiraldata = [\n  (-2, \"Lituus\",      50),\n  (-1, \"Hyperbolic\", 100),\n  ( 1, \"Archimedes\",   1),\n  ( 2, \"Fermat\",       5)]\n\ngrid = GridRect(O - (200, 0), 130, 50)\n\nfor aspiral in spiraldata\n    @layer begin\n        translate(nextgridpoint(grid))\n        spiral(last(aspiral), first(aspiral), period=20pi, :stroke)\n        label(aspiral[2], :S, offset=100)\n    end\nend\n\nfinish() # hide\nnothing # hide(Image: spiral)Use the log=true option to draw logarithmic (Bernoulli or Fibonacci) spirals.using Luxor # hide\nDrawing(600, 400, \"assets/figures/spiral-log.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsetline(.5) # hide\nsethue(\"black\") # hide\nfontface(\"Avenir-Heavy\") # hide\nfontsize(15) # hide\n\nspiraldata = [\n    (10,  0.05),\n    (4,   0.10),\n    (0.5, 0.17)]\n\ngrid = GridRect(O - (200, 0), 175, 50)\nfor aspiral in spiraldata\n    @layer begin\n        translate(nextgridpoint(grid))\n        spiral(first(aspiral), last(aspiral), log=true, period=10pi, :stroke)\n        label(string(aspiral), :S, offset=100)\n    end\nend\n\nfinish() # hide\nnothing # hideModify the stepby and period parameters to taste, or collect the vertices for further processing.(Image: spiral log)spiralA squircle is a cross between a square and a circle. You can adjust the squariness and circularity of it to taste by supplying a value for the root (keyword rt):using Luxor # hide\nDrawing(600, 250, \"assets/figures/squircle.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nfontsize(20) # hide\nsetline(2)\ntiles = Tiler(600, 250, 1, 3)\nfor (pos, n) in tiles\n    sethue(\"lavender\")\n    squircle(pos, 80, 80, rt=[0.3, 0.5, 0.7][n], :fillpreserve)\n    sethue(\"grey20\")\n    strokepath()\n    textcentered(\"rt = $([0.3, 0.5, 0.7][n])\", pos)\nend\nfinish() # hide\nnothing # hide(Image: squircles)squircleTo draw a simple rounded rectangle, supply a corner radius:using Luxor # hide\nDrawing(600, 250, \"assets/figures/round-rect-1.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"black\") # hide\nsetline(4)\nbox(O, 200, 150, 10, :stroke)\nfinish() # hide\nnothing # hide(Image: rounded rect 1)Or you could smooth the corners of a box, like so:using Luxor # hide\nDrawing(600, 250, \"assets/figures/round-rect.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"black\") # hide\nsetline(4)\npolysmooth(box(O, 200, 150, vertices=true), 10, :stroke)\nfinish() # hide\nnothing # hide(Image: rounded rect)"
},

{
    "location": "simplegraphics/#Luxor.move",
    "page": "Simple shapes",
    "title": "Luxor.move",
    "category": "function",
    "text": "move(pt)\n\nMove to a point.\n\n\n\n\n\n"
},

{
    "location": "simplegraphics/#Luxor.rmove",
    "page": "Simple shapes",
    "title": "Luxor.rmove",
    "category": "function",
    "text": "rmove(pt)\n\nMove relative to current position by the pt\'s x and y:\n\n\n\n\n\n"
},

{
    "location": "simplegraphics/#Luxor.newpath",
    "page": "Simple shapes",
    "title": "Luxor.newpath",
    "category": "function",
    "text": "newpath()\n\nCreate a new path. This is Cairo\'s new_path() function.\n\n\n\n\n\n"
},

{
    "location": "simplegraphics/#Luxor.newsubpath",
    "page": "Simple shapes",
    "title": "Luxor.newsubpath",
    "category": "function",
    "text": "newsubpath()\n\nAdd a new subpath to the current path. This is Cairo\'s new_sub_path() function. It can be used for example to make holes in shapes.\n\n\n\n\n\n"
},

{
    "location": "simplegraphics/#Luxor.closepath",
    "page": "Simple shapes",
    "title": "Luxor.closepath",
    "category": "function",
    "text": "closepath()\n\nClose the current path. This is Cairo\'s close_path() function.\n\n\n\n\n\n"
},

{
    "location": "simplegraphics/#Paths-and-positions-1",
    "page": "Simple shapes",
    "title": "Paths and positions",
    "category": "section",
    "text": "A path is a sequence of lines and curves. You can add lines and curves to the current path, then use closepath() to join the last point to the first.A path can have subpaths, created withnewsubpath(), which can form holes.There is a \'current position\' which you can set with move(), and can use implicitly in functions like line(), rline(), text(), arc() and curve().move\nrmove\nnewpath\nnewsubpath\nclosepath"
},

{
    "location": "simplegraphics/#Luxor.line",
    "page": "Simple shapes",
    "title": "Luxor.line",
    "category": "function",
    "text": "line(pt)\n\nDraw a line from the current position to the pt.\n\n\n\n\n\nline(pt1::Point, pt2::Point, action=:nothing)\n\nMake a line between two points, pt1 and pt2 and do an action.\n\n\n\n\n\n"
},

{
    "location": "simplegraphics/#Luxor.rline",
    "page": "Simple shapes",
    "title": "Luxor.rline",
    "category": "function",
    "text": "rline(pt)\n\nDraw a line relative to the current position to the pt.\n\n\n\n\n\n"
},

{
    "location": "simplegraphics/#Luxor.rule",
    "page": "Simple shapes",
    "title": "Luxor.rule",
    "category": "function",
    "text": "rule(pos, theta;\n    boundingbox=BoundingBox())\n\nDraw a straight line through pos at an angle theta from the x axis.\n\nBy default, the line spans the entire drawing, but you can supply a BoundingBox to change the extent of the line.\n\nrule(O)       # draws an x axis\nrule(O, pi/2) # draws a  y axis\n\nThe function:\n\nrule(O, pi/2, boundingbox=BoundingBox()/2)\n\ndraws a line that spans a bounding box half the width and height of the drawing.\n\n\n\n\n\n"
},

{
    "location": "simplegraphics/#Lines-1",
    "page": "Simple shapes",
    "title": "Lines",
    "category": "section",
    "text": "Use line() and rline() to draw straight lines. line(pt1, pt2, action) draws a line between two points. line(pt) adds a line to the current path going from the current position to the point. rline(pt) adds a line relative to the current position.line\nrlineYou can use rule() to draw a line through a point, optionally at an angle to the current x-axis.using Luxor # hide\nDrawing(700, 200, \"assets/figures/rule.png\") # hide\nbackground(\"white\") # hide\nsethue(\"black\") # hide\nsetline(0.5) # hide\ny = 10\nfor x in 10 .^ range(0, length=100, stop=3)\n    global y\n    circle(Point(x, y), 2, :fill)\n    rule(Point(x, y), -pi/2, boundingbox=BoundingBox(centered=false))\n    y += 2\nend\n\nfinish() # hide\nnothing # hide(Image: arc)Use the boundingbox keyword argument to crop the ruled lines with a BoundingBox.using Luxor # hide\nDrawing(700, 200, \"assets/figures/rulebbox.png\") # hide\norigin()\nbackground(\"white\") # hide\nsethue(\"black\") # hide\nsetline(0.75) # hide\nbox(BoundingBox() * 0.9, :stroke)\nfor x in 10 .^ range(0, length=100, stop=3)\n    rule(Point(x, 0), pi/2,  boundingbox=BoundingBox() * 0.9)\n    rule(Point(-x, 0), pi/2, boundingbox=BoundingBox() * 0.9)\nend\nfinish() # hide(Image: arc)rule"
},

{
    "location": "simplegraphics/#Luxor.arc",
    "page": "Simple shapes",
    "title": "Luxor.arc",
    "category": "function",
    "text": "arc(xc, yc, radius, angle1, angle2, action=:nothing)\n\nAdd an arc to the current path from angle1 to angle2 going clockwise, centered at xc, yc.\n\nAngles are defined relative to the x-axis, positive clockwise.\n\n\n\n\n\narc(centerpoint::Point, radius, angle1, angle2, action=:nothing)\n\nAdd an arc to the current path from angle1 to angle2 going clockwise, centered at centerpoint.\n\n\n\n\n\n"
},

{
    "location": "simplegraphics/#Luxor.arc2r",
    "page": "Simple shapes",
    "title": "Luxor.arc2r",
    "category": "function",
    "text": "  arc2r(c1::Point, p2::Point, p3::Point, action=:nothing)\n\nAdd a circular arc centered at c1 that starts at p2 and ends at p3, going clockwise, to the current path.\n\nc1-p2 really determines the radius. If p3 doesn\'t lie on the circular path,  it will be used only as an indication of the arc\'s length, rather than its position.\n\n\n\n\n\n"
},

{
    "location": "simplegraphics/#Luxor.carc",
    "page": "Simple shapes",
    "title": "Luxor.carc",
    "category": "function",
    "text": "carc(xc, yc, radius, angle1, angle2, action=:nothing)\n\nAdd an arc to the current path from angle1 to angle2 going counterclockwise, centered at xc/yc.\n\nAngles are defined relative to the x-axis, positive clockwise.\n\n\n\n\n\ncarc(centerpoint::Point, radius, angle1, angle2, action=:nothing)\n\nAdd an arc centered at centerpoint to the current path from angle1 to angle2, going counterclockwise.\n\n\n\n\n\n"
},

{
    "location": "simplegraphics/#Luxor.carc2r",
    "page": "Simple shapes",
    "title": "Luxor.carc2r",
    "category": "function",
    "text": "carc2r(c1::Point, p2::Point, p3::Point, action=:nothing)\n\nAdd a circular arc centered at c1 that starts at p2 and ends at p3, going counterclockwise, to the current path.\n\nc1-p2 really determines the radius. If p3 doesn\'t lie on the circular path, it will be used only as an indication of the arc\'s length, rather than its position.\n\n\n\n\n\n"
},

{
    "location": "simplegraphics/#Luxor.curve",
    "page": "Simple shapes",
    "title": "Luxor.curve",
    "category": "function",
    "text": "curve(x1, y1, x2, y2, x3, y3)\ncurve(p1, p2, p3)\n\nAdd a Bézier curve.\n\nThe spline starts at the current position, finishing at x3/y3 (p3), following two control points x1/y1 (p1) and x2/y2 (p2).\n\n\n\n\n\n"
},

{
    "location": "simplegraphics/#Arcs-and-curves-1",
    "page": "Simple shapes",
    "title": "Arcs and curves",
    "category": "section",
    "text": "There are a few standard arc-drawing commands, such as curve(), arc(), carc(), and arc2r(). Because these are often used when building complex paths, they usually add arc sections to the current path. To construct a sequence of lines and arcs, use the :path action, followed by a final :stroke or similar.curve() constructs Bézier curves from control points:using Luxor # hide\nDrawing(600, 275, \"assets/figures/curve.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\n\nsethue(\"black\") # hide\n\nsetline(.5)\npt1 = Point(0, -125)\npt2 = Point(200, 125)\npt3 = Point(200, -125)\n\nlabel.(string.([\"O\", \"control point 1\", \"control point 2\", \"control point 3\"]),\n    :e,\n    [O, pt1, pt2, pt3])\n\nsethue(\"red\")\nmap(p -> circle(p, 4, :fill), [O, pt1, pt2, pt3])\n\nline(O, pt1, :stroke)\nline(pt2, pt3, :stroke)\n\nsethue(\"black\")\nsetline(3)\n\n# start a path\nmove(O)\ncurve(pt1, pt2, pt3) #  add to current path\nstrokepath()\n\nfinish()  # hide\nnothing # hide(Image: curve)arc2r() draws a circular arc centered at a point that passes through two other points:using Luxor, Random # hide\nDrawing(700, 200, \"assets/figures/arc2r.png\") # hide\norigin() # hide\nRandom.seed!(42) # hide\nbackground(\"white\") # hide\ntiles = Tiler(700, 200, 1, 6)\nfor (pos, n) in tiles\n    c1, pt2, pt3 = ngon(pos, rand(10:50), 3, rand(0:pi/12:2pi), vertices=true)\n    sethue(\"black\")\n    map(pt -> circle(pt, 4, :fill), [c1, pt3])\n    sethue(\"red\")\n    circle(pt2, 4, :fill)\n    randomhue()\n    arc2r(c1, pt2, pt3, :stroke)\nend\nfinish() # hide\nnothing # hide(Image: arc)arc\narc2r\ncarc\ncarc2r\ncurve"
},

{
    "location": "moregraphics/#",
    "page": "More graphics",
    "title": "More graphics",
    "category": "page",
    "text": "DocTestSetup = quote\n    using Luxor, Colors, Random\n    end"
},

{
    "location": "moregraphics/#More-graphics-1",
    "page": "More graphics",
    "title": "More graphics",
    "category": "section",
    "text": ""
},

{
    "location": "moregraphics/#Luxor.julialogo",
    "page": "More graphics",
    "title": "Luxor.julialogo",
    "category": "function",
    "text": "julialogo(;action=:fill, color=true)\n\nDraw the Julia logo. The default action is to fill the logo and use the colors:\n\njulialogo()\n\nIf color is false, the logo will use the current color, and the dots won\'t be colored in the usual way.\n\nThe logo\'s dimensions are about 330 wide and 240 high, and the 0/0 point is at the bottom left corner. To place the logo by locating its center, do this:\n\ngsave()\ntranslate(-165, -120)\njulialogo() # locate center at 0/0\ngrestore()\n\nTo use the logo as a clipping mask:\n\njulialogo(action=:clip)\n\n(In this case the color setting is automatically ignored.)\n\n\n\n\n\n"
},

{
    "location": "moregraphics/#Luxor.juliacircles",
    "page": "More graphics",
    "title": "Luxor.juliacircles",
    "category": "function",
    "text": "juliacircles(radius=100)\n\nDraw the three Julia circles in color centered at the origin.\n\nThe distance of the centers of the circles from the origin is radius. The optional keyword arguments outercircleratio (default 0.75) and innercircleratio (default 0.65) control the radius of the individual colored circles relative to the radius. So you can get relatively smaller or larger circles by adjusting the ratios.\n\n\n\n\n\n"
},

{
    "location": "moregraphics/#Julia-logos-1",
    "page": "More graphics",
    "title": "Julia logos",
    "category": "section",
    "text": "A couple of functions in Luxor provide you with instant access to the Julia logo, and the three colored circles:using Luxor, Random # hide\nDrawing(750, 250, \"assets/figures/julia-logo.png\")  # hide\nRandom.seed!(42) # hide\norigin()  # hide\nbackground(\"white\") # hide\n\nfor (pos, n) in Tiler(750, 250, 1, 2)\n    gsave()\n    translate(pos - Point(150, 100))\n    if n == 1\n        julialogo()\n    elseif n == 2\n        julialogo(action=:clip)\n        for i in 1:500\n            gsave()\n            translate(rand(0:400), rand(0:250))\n            juliacircles(10)\n            grestore()\n        end\n        clipreset()\n    end\n    grestore()\nend\nfinish() # hide\nnothing # hide(Image: get path)julialogo\njuliacircles"
},

{
    "location": "moregraphics/#Luxor.hypotrochoid",
    "page": "More graphics",
    "title": "Luxor.hypotrochoid",
    "category": "function",
    "text": "hypotrochoid(R, r, d, action=:none;\n        stepby=0.01,\n        period=0.0,\n        vertices=false)\n\nMake a hypotrochoid with short line segments. (Like a Spirograph.) The curve is traced by a point attached to a circle of radius r rolling around the inside  of a fixed circle of radius R, where the point is a distance d from  the center of the interior circle. Things get interesting if you supply non-integral values.\n\nSpecial cases include the hypocycloid, if d = r, and an ellipse, if R = 2r.\n\nstepby, the angular step value, controls the amount of detail, ie the smoothness of the polygon,\n\nIf period is not supplied, or 0, the lowest period is calculated for you.\n\nThe function can return a polygon (a list of points), or draw the points directly using the supplied action. If the points are drawn, the function returns a tuple showing how many points were drawn and what the period was (as a multiple of pi).\n\n\n\n\n\n"
},

{
    "location": "moregraphics/#Luxor.epitrochoid",
    "page": "More graphics",
    "title": "Luxor.epitrochoid",
    "category": "function",
    "text": "epitrochoid(R, r, d, action=:none;\n        stepby=0.01,\n        period=0,\n        vertices=false)\n\nMake a epitrochoid with short line segments. (Like a Spirograph.) The curve is traced by a point attached to a circle of radius r rolling around the outside of a fixed circle of radius R, where the point is a distance d from the center of the circle. Things get interesting if you supply non-integral values.\n\nstepby, the angular step value, controls the amount of detail, ie the smoothness of the polygon.\n\nIf period is not supplied, or 0, the lowest period is calculated for you.\n\nThe function can return a polygon (a list of points), or draw the points directly using the supplied action. If the points are drawn, the function returns a tuple showing how many points were drawn and what the period was (as a multiple of pi).\n\n\n\n\n\n"
},

{
    "location": "moregraphics/#Hypotrochoids-1",
    "page": "More graphics",
    "title": "Hypotrochoids",
    "category": "section",
    "text": "hypotrochoid() makes hypotrochoids. The result is a polygon. You can either draw it directly, or pass it on for further polygon fun, as here, which uses offsetpoly() to trace round it a few times.using Luxor # hide\nDrawing(500, 300, \"assets/figures/hypotrochoid.png\")  # hide\norigin()\nbackground(\"grey15\")\nsethue(\"antiquewhite\")\nsetline(1)\np = hypotrochoid(100, 25, 55, :stroke, stepby=0.01, vertices=true)\nfor i in 0:3:15\n    poly(offsetpoly(p, i), :stroke, close=true)\nend\nfinish() # hide\nnothing # hide(Image: hypotrochoid)There\'s a matching epitrochoid() function.hypotrochoid\nepitrochoid"
},

{
    "location": "moregraphics/#Luxor.cropmarks",
    "page": "More graphics",
    "title": "Luxor.cropmarks",
    "category": "function",
    "text": "cropmarks(center, width, height)\n\nDraw cropmarks (also known as trim marks).\n\n\n\n\n\n"
},

{
    "location": "moregraphics/#Cropmarks-1",
    "page": "More graphics",
    "title": "Cropmarks",
    "category": "section",
    "text": "If you want cropmarks (aka trim marks), use the cropmarks() function, supplying the centerpoint, followed by the width and height:cropmarks(O, 1200, 1600)\ncropmarks(O, paper_sizes[\"A0\"]...)using Luxor # hide\nDrawing(700, 250, \"assets/figures/cropmarks.png\")  # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"red\")\nbox(O, 150, 150, :stroke)\ncropmarks(O, 150, 150)\nfinish() # hide\nnothing # hide(Image: cropmarks)cropmarks"
},

{
    "location": "moregraphics/#Luxor.bars",
    "page": "More graphics",
    "title": "Luxor.bars",
    "category": "function",
    "text": "bars(values::AbstractArray;\n        yheight = 200,\n        xwidth = 25,\n        labels = true,\n        barfunction = f,\n        labelfunction = f,\n    )\n\nDraw some bars where each bar is the height of a value in the array. The bars will fit in a box yheight high (even if there are negative values).\n\nTo control the drawing of the text and bars, define functions that process the end points:\n\nmybarfunction(bottom::Point, top::Point, value; extremes=[a, b], barnumber=0, bartotal=0)\n\nmylabelfunction(bottom::Point, top::Point, value; extremes=[a, b], barnumber=0, bartotal=0)\n\nand pass them like this:\n\nbars(v, yheight=10, xwidth=10, barfunction=mybarfunction)\nbars(v, xwidth=15, yheight=10, labelfunction=mylabelfunction)\n\nor:\n\nbars(v, labelfunction = (args...; extremes=[], barnumber=0, bartotal=0) ->  setgray(rand()))\n\nTo suppress the text labels, use optional keyword labels=false.\n\n\n\n\n\n"
},

{
    "location": "moregraphics/#Bars-1",
    "page": "More graphics",
    "title": "Bars",
    "category": "section",
    "text": "For simple bars, use the bars() function, supplying an array of numbers:using Luxor # hide\nDrawing(800, 420, \"assets/figures/bars.png\")  # hide\norigin() # hide\nbackground(\"white\") # hide\nfontsize(7)\nsethue(\"black\")\ntranslate(-350, 0) # hide\nv = rand(-100:100, 25)\nbars(v)\nfinish() # hide\nnothing # hide(Image: bars)To change the way the bars and labels are drawn, define some functions and pass them as keyword arguments to bars():using Luxor, Colors, Random # hide\nDrawing(800, 450, \"assets/figures/bars1.png\")  # hide\nRandom.seed!(2) # hide\norigin() # hide\nbackground(\"white\") # hide\nsetopacity(0.8) # hide\nfontsize(8) # hide\nfontface(\"Helvetica-Bold\") # hide\nsethue(\"black\") # hide\ntranslate(-350, 100) # hide\n\nfunction mybarfunction(low::Point, high::Point, value;\n    extremes=[0, 1], barnumber=0, bartotal=0)\n    @layer begin\n        sethue(Colors.HSB(rescale(value, extremes[1], extremes[2], 0, 360), 1.0, 0.5))\n        csize = rescale(value, extremes[1], extremes[2], 5, 25)\n        circle(high, csize, :fill)\n        setline(1)\n        sethue(\"blue\")\n        line(Point(low.x, 0), high + (0, csize), :stroke)\n        sethue(\"white\")\n        text(string(value), high, halign=:center, valign=:middle)\n    end\nend\n\nfunction mylabelfunction(low::Point, high::Point, value;\n    extremes=[0, 1], barnumber=0, bartotal=0)\n    @layer begin\n        translate(low)\n        text(string(value), O + (0, 10), halign=:center, valign=:middle)\n    end\nend\n\nv = rand(1:100, 25)\nbars(v, xwidth=25, barfunction=mybarfunction, labelfunction=mylabelfunction)\n\nfinish() # hide\nnothing # hide(Image: bars 1)bars"
},

{
    "location": "moregraphics/#Luxor.boxmap",
    "page": "More graphics",
    "title": "Luxor.boxmap",
    "category": "function",
    "text": "boxmap(A::AbstractArray, pt, w, h)\n\nBuild a box map of the values in A with one corner at pt and width w and height h. There are length(A) boxes. The areas of the boxes are proportional to the original values, scaled as necessary.\n\nThe return value is an array of BoxmapTiles. For example:\n\n[BoxmapTile(0.0, 0.0, 10.0, 20.0)\n BoxmapTile(10.0, 0.0, 10.0, 13.3333)\n BoxmapTile(10.0, 13.3333, 10.0, 6.66667)]\n\nwith each tile containing (x, y, w, h). box() and BoundingBox() can work with BoxmapTiles as well.\n\nExample\n\nusing Luxor\n@svg begin\n    fontsize(16)\n    fontface(\"HelveticaBold\")\n    pt = Point(-200, -200)\n    a = rand(10:200, 15)\n    tiles = boxmap(a, Point(-200, -200), 400, 400)\n    for (n, t) in enumerate(tiles)\n        randomhue()\n        bb = BoundingBox(t)\n        box(bb - 2, :stroke)\n        box(bb - 5, :fill)\n        sethue(\"white\")\n        text(string(n), midpoint(bb[1], bb[2]), halign=:center)\n    end\nend 400 400 \"/tmp/boxmap.svg\"\n\n\n\n\n\n"
},

{
    "location": "moregraphics/#Box-maps-1",
    "page": "More graphics",
    "title": "Box maps",
    "category": "section",
    "text": "The boxmap() function divides a rectangular area into a sorted arrangement of smaller boxes or tiles based on the values of elements in an array.This example uses the Fibonacci sequence to determine the area of the boxes. Notice that the values are sorted in reverse, and are scaled to fit in the available area.using Luxor, Colors, Random # hide\nDrawing(800, 450, \"assets/figures/boxmap.png\")  # hide\nRandom.seed!(13) # hide\norigin() # hide\nbackground(\"white\") # hide\n\nfib = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144]\n\n# make a boxmap and store the tiles\ntiles = boxmap(fib, BoundingBox()[1], 800, 450)\n\nfor (n, t) in enumerate(tiles)\n    randomhue()\n    bb = BoundingBox(t)\n    sethue(\"black\")\n    box(bb - 5, :stroke)\n\n    randomhue()\n    box(bb - 8, :fill)\n\n    # text labels\n    sethue(\"white\")\n\n    # rescale text to fit better\n    fontsize(boxwidth(bb) > boxheight(bb) ? boxheight(bb)/4 : boxwidth(bb)/4)\n    text(string(sort(fib, rev=true)[n]),\n        midpoint(bb[1], bb[2]),\n        halign=:center,\n            valign=:middle)\nend\n\nfinish() # hide\nnothing # hide(Image: boxmap)boxmap"
},

{
    "location": "geometrytools/#",
    "page": "Geometry tools",
    "title": "Geometry tools",
    "category": "page",
    "text": "DocTestSetup = quote\n    using Luxor, Colors, Random\n    end"
},

{
    "location": "geometrytools/#Geometry-tools-1",
    "page": "Geometry tools",
    "title": "Geometry tools",
    "category": "section",
    "text": ""
},

{
    "location": "geometrytools/#Luxor.midpoint",
    "page": "Geometry tools",
    "title": "Luxor.midpoint",
    "category": "function",
    "text": "midpoint(p1, p2)\n\nFind the midpoint between two points.\n\n\n\n\n\nmidpoint(a)\n\nFind midpoint between the first two elements of an array of points.\n\n\n\n\n\nmidpoint(bb::BoundingBox)\n\nReturns the point midway between the two points of the BoundingBox. This should also be the center, unless I\'ve been very stupid...\n\n\n\n\n\n"
},

{
    "location": "geometrytools/#Luxor.between",
    "page": "Geometry tools",
    "title": "Luxor.between",
    "category": "function",
    "text": "between(p1::Point, p2::Point, x)\nbetween((p1::Point, p2::Point), x)\n\nFind the point between point p1 and point p2 for x, where x is typically between 0 and 1. between(p1, p2, 0.5) is equivalent to midpoint(p1, p2).\n\n\n\n\n\nbetween(bb::BoundingBox, x)\n\nFind a point between the two corners of a BoundingBox corresponding to x, where x is typically between 0 and 1.\n\n\n\n\n\n"
},

{
    "location": "geometrytools/#Luxor.distance",
    "page": "Geometry tools",
    "title": "Luxor.distance",
    "category": "function",
    "text": "distance(p1::Point, p2::Point)\n\nFind the distance between two points (two argument form).\n\n\n\n\n\n"
},

{
    "location": "geometrytools/#Luxor.getnearestpointonline",
    "page": "Geometry tools",
    "title": "Luxor.getnearestpointonline",
    "category": "function",
    "text": "getnearestpointonline(pt1::Point, pt2::Point, startpt::Point)\n\nGiven a line from pt1 to pt2, and startpt is the start of a perpendicular heading to meet the line, at what point does it hit the line?\n\n\n\n\n\n"
},

{
    "location": "geometrytools/#Luxor.pointlinedistance",
    "page": "Geometry tools",
    "title": "Luxor.pointlinedistance",
    "category": "function",
    "text": "pointlinedistance(p::Point, a::Point, b::Point)\n\nFind the distance between a point p and a line between two points a and b.\n\n\n\n\n\n"
},

{
    "location": "geometrytools/#Luxor.slope",
    "page": "Geometry tools",
    "title": "Luxor.slope",
    "category": "function",
    "text": "slope(pointA::Point, pointB::Point)\n\nFind angle of a line starting at pointA and ending at pointB.\n\nReturn a value between 0 and 2pi. Value will be relative to the current axes.\n\nslope(O, Point(0, 100)) |> rad2deg # y is positive down the page\n90.0\n\nslope(Point(0, 100), O) |> rad2deg\n270.0\n\n\n\n\n\n"
},

{
    "location": "geometrytools/#Luxor.perpendicular",
    "page": "Geometry tools",
    "title": "Luxor.perpendicular",
    "category": "function",
    "text": "perpendicular(p1, p2, k)\n\nReturn a point p3 that is k units away from p1, such that a line p1 p3 is perpendicular to p1 p2.\n\nConvention? to the right?\n\n\n\n\n\nperpendicular(p::Point)\n\nReturns point Point(p.y, -p.x).\n\n\n\n\n\n"
},

{
    "location": "geometrytools/#Luxor.dotproduct",
    "page": "Geometry tools",
    "title": "Luxor.dotproduct",
    "category": "function",
    "text": "dotproduct(a::Point, b::Point)\n\nReturn the scalar dot product of the two points.\n\n\n\n\n\n"
},

{
    "location": "geometrytools/#Luxor.@polar",
    "page": "Geometry tools",
    "title": "Luxor.@polar",
    "category": "macro",
    "text": "@polar (p)\n\nConvert a tuple of two numbers to a Point of x, y Cartesian coordinates.\n\n@polar (10, pi/4)\n@polar [10, pi/4]\n\nproduces\n\nLuxor.Point(7.0710678118654755,7.071067811865475)\n\n\n\n\n\n"
},

{
    "location": "geometrytools/#Luxor.polar",
    "page": "Geometry tools",
    "title": "Luxor.polar",
    "category": "function",
    "text": "polar(r, theta)\n\nConvert point in polar form (radius and angle) to a Point.\n\npolar(10, pi/4)\n\nproduces\n\nLuxor.Point(7.071067811865475,7.0710678118654755)\n\n\n\n\n\n"
},

{
    "location": "geometrytools/#Luxor.ispointonline",
    "page": "Geometry tools",
    "title": "Luxor.ispointonline",
    "category": "function",
    "text": "ispointonline(pt::Point, pt1::Point, pt2::Point;\n    extended = false,\n    atol = 10E-5)\n\nReturn true if the point pt lies on a straight line between pt1 and pt2.\n\nIf extended is false (the default) the point must lie on the line segment between pt1 and pt2. If extended is true, the point lies on the line if extended in either direction.\n\n\n\n\n\n"
},

{
    "location": "geometrytools/#Lines-and-distances-1",
    "page": "Geometry tools",
    "title": "Lines and distances",
    "category": "section",
    "text": "You can find the midpoint between two points using midpoint().The following code places a small pentagon (using ngon()) at the midpoint of each side of a larger pentagon:using Luxor # hide\nDrawing(700, 220, \"assets/figures/midpoint.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"red\")\nngon(O, 100, 5, 0, :stroke)\n\nsethue(\"darkgreen\")\np5 = ngon(O, 100, 5, 0, vertices=true)\n\nfor i in eachindex(p5)\n    pt1 = p5[mod1(i, 5)]\n    pt2 = p5[mod1(i + 1, 5)]\n    ngon(midpoint(pt1, pt2), 20, 5, 0, :fill)\nend\nfinish() # hide\nnothing # hide(Image: arc)A more general function, between(), finds for a value x between 0 and 1 the corresponding point on a line defined by two points. So midpoint(p1, p2) and between(p1, p2, 0.5) should return the same point.using Luxor # hide\nDrawing(700, 150, \"assets/figures/betweenpoint.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"red\")\np1 = Point(-150, 0)\np2 = Point(150, 40)\nline(p1, p2)\nstrokepath()\nfor i in -0.5:0.1:1.5\n    randomhue()\n    circle(between(p1, p2, i), 5, :fill)\nend\nfinish() # hide\nnothing # hide(Image: arc)Values less than 0.0 and greater than 1.0 appear to work well too, placing the point on the line if extended.midpoint\nbetweencenter3pts() finds the radius and center point of a circle passing through three points which you can then use with functions such as circle() or arc2r().getnearestpointonline() finds perpendiculars.using Luxor # hide\nDrawing(700, 200, \"assets/figures/perpendicular.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"darkmagenta\") # hide\nend1, end2, pt3 = ngon(O, 100, 3, vertices=true)\ncircle.([end1, end2, pt3], 5, :fill)\nline(end1, end2, :stroke)\narrow(pt3, getnearestpointonline(end1, end2, pt3))\nfinish() # hide\nnothing # hide(Image: arc)distance\ngetnearestpointonline\npointlinedistance\nslope\nperpendicular\ndotproduct\n@polar\npolar\nispointonline"
},

{
    "location": "geometrytools/#Luxor.intersection",
    "page": "Geometry tools",
    "title": "Luxor.intersection",
    "category": "function",
    "text": "intersection(p1::Point, p2::Point, p3::Point, p4::Point;\n    commonendpoints = false,\n    crossingonly = false,\n    collinearintersect = false)\n\nFind intersection of two lines p1-p2 and p3-p4\n\nThis returns a tuple: (boolean, point(x, y)).\n\nKeyword options and default values:\n\ncrossingonly = false\n\nIf crossingonly = true, lines must actually cross. The function returns (false, intersectionpoint) if the lines don\'t actually cross, but would eventually intersect at intersectionpoint if continued beyond their current endpoints.\n\nIf false, the function returns (true, Point(x, y)) if the lines intersect somewhere eventually at intersectionpoint.\n\ncommonendpoints = false\n\nIf commonendpoints= true, will return (false, Point(0, 0)) if the lines share a common end point (because that\'s not so much an intersection, more a meeting).\n\nFunction returns (false, Point(0, 0)) if the lines are undefined.\n\nIf you want collinear points to be considered to intersect, set collinearintersect to true, although it defaults to false.\n\n\n\n\n\n"
},

{
    "location": "geometrytools/#Luxor.intersectionlinecircle",
    "page": "Geometry tools",
    "title": "Luxor.intersectionlinecircle",
    "category": "function",
    "text": "intersectionlinecircle(p1::Point, p2::Point, cpoint::Point, r)\n\nFind the intersection points of a line (extended through points p1 and p2) and a circle.\n\nReturn a tuple of (n, pt1, pt2)\n\nwhere\n\nn is the number of intersections, 0, 1, or 2\npt1 is first intersection point, or Point(0, 0) if none\npt2 is the second intersection point, or Point(0, 0) if none\n\nThe calculated intersection points won\'t necessarily lie on the line segment between p1 and p2.\n\n\n\n\n\n"
},

{
    "location": "geometrytools/#Luxor.intersection2circles",
    "page": "Geometry tools",
    "title": "Luxor.intersection2circles",
    "category": "function",
    "text": "intersection2circles(pt1, r1, pt2, r2)\n\nFind the area of intersection between two circles, the first centered at pt1 with radius r1, the second centered at pt2 with radius r2.\n\n\n\n\n\n"
},

{
    "location": "geometrytools/#Luxor.intersectioncirclecircle",
    "page": "Geometry tools",
    "title": "Luxor.intersectioncirclecircle",
    "category": "function",
    "text": "intersectioncirclecircle(cp1, r1, cp2, r2)\n\nFind the two points where two circles intersect, if they do. The first circle is centered at cp1 with radius r1, and the second is centered at cp1 with radius r1.\n\nReturns\n\n(flag, ip1, ip2)\n\nwhere flag is a Boolean true if the circles intersect at the points ip1 and ip2. If the circles don\'t intersect at all, or one is completely inside the other, flag is false and the points are both Point(0, 0).\n\nUse intersection2circles() to find the area of two overlapping circles.\n\nIn the pure world of maths, it must be possible that two circles \'kissing\' only have a single intersection point. At present, this unromantic function reports that two kissing circles have no intersection points.\n\n\n\n\n\n"
},

{
    "location": "geometrytools/#Intersections-1",
    "page": "Geometry tools",
    "title": "Intersections",
    "category": "section",
    "text": "intersection() finds the intersection of two lines.using Luxor # hide\nDrawing(700, 220, \"assets/figures/intersection.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\n\nsethue(\"black\")\nP1, P2, P3, P4 = ngon(O, 100, 5, vertices=true)\nlabel.([\"P1\", \"P2\", \"P3\", \"P4\"], :N, [P1, P2, P3, P4])\nline(P1, P2, :stroke)\nline(P4, P3, :stroke)\n\nflag, ip =  intersection(P1, P2, P4, P3)\nif flag\n    circle(ip, 5, :fill)\nend\n\nfinish() # hide\nnothing # hide(Image: arc)Notice that the order in which the points define the lines is important (P1 to P2, P4 to P3). The collinearintersect=true option may also help.intersectionlinecircle() finds the intersection of a line and a circle. There can be 0, 1, or 2 intersection points.using Luxor # hide\nDrawing(700, 220, \"assets/figures/intersection_line_circle.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"chocolate2\") # hide\nl1 = Point(-100.0, -75.0)\nl2 = Point(300.0, 100.0)\nrad = 100\ncpoint = Point(0, 0)\nline(l1, l2, :stroke)\nsethue(\"darkgreen\") # hide\ncircle(cpoint, rad, :stroke)\nnints, ip1, ip2 =  intersectionlinecircle(l1, l2, cpoint, rad)\nsethue(\"black\")\nif nints == 2\n    circle(ip1, 8, :stroke)\n    circle(ip2, 8, :stroke)\nend\nfinish() # hide\nnothing # hide(Image: arc)intersection2circles() finds the area of the intersection of two circles, and intersectioncirclecircle() finds the points where they cross.This example shows the areas of two circles, and the area of their intersection.using Luxor # hide\nDrawing(700, 310, \"assets/figures/intersection2circles.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nfontsize(14) # hide\nsethue(\"black\") # hide\n\nc1 = (O, 150)\nc2 = (O + (100, 0), 150)\n\ncircle(c1... , :stroke)\ncircle(c2... , :stroke)\n\nsethue(\"purple\")\ncircle(c1... , :clip)\ncircle(c2... , :fill)\nclipreset()\n\nsethue(\"black\")\n\ntext(string(150^2 * pi |> round), c1[1] - (125, 0))\ntext(string(150^2 * pi |> round), c2[1] + (100, 0))\nsethue(\"white\")\ntext(string(intersection2circles(c1..., c2...) |> round),\n     midpoint(c1[1], c2[1]), halign=:center)\n\nsethue(\"red\")\nflag, C, D = intersectioncirclecircle(c1..., c2...)\nif flag\n    circle.([C, D], 5, :fill)\nend\nfinish() # hide\nnothing # hide(Image: intersection of two circles)intersection\nintersectionlinecircle\nintersection2circles\nintersectioncirclecircle"
},

{
    "location": "geometrytools/#Luxor.arrow",
    "page": "Geometry tools",
    "title": "Luxor.arrow",
    "category": "function",
    "text": "arrow(startpoint::Point, endpoint::Point;\n    linewidth = 1.0,\n    arrowheadlength = 10,\n    arrowheadangle = pi/8)\n\nDraw a line between two points and add an arrowhead at the end. The arrowhead length will be the length of the side of the arrow\'s head, and the arrowhead angle is the angle between the sloping side of the arrowhead and the arrow\'s shaft.\n\nArrows don\'t use the current linewidth setting (setline()), and defaults to 1, but you can specify another value. It doesn\'t need stroking/filling, the shaft is stroked and the head filled with the current color.\n\n\n\n\n\narrow(centerpos::Point, radius, startangle, endangle;\n    linewidth = 1.0,\n    arrowheadlength = 10,\n    arrowheadangle = pi/8)\n\nDraw a curved arrow, an arc centered at centerpos starting at startangle and ending at endangle with an arrowhead at the end. Angles are measured clockwise from the positive x-axis.\n\nArrows don\'t use the current linewidth setting (setline()); you can specify the linewidth.\n\n\n\n\n\n"
},

{
    "location": "geometrytools/#Arrows-1",
    "page": "Geometry tools",
    "title": "Arrows",
    "category": "section",
    "text": "You can draw lines or arcs with arrows at the end with arrow(). For straight arrows, supply the start and end points. For arrows as circular arcs, you provide center, radius, and start and finish angles. You can optionally provide dimensions for the arrowheadlength and arrowheadangle of the tip of the arrow (angle in radians between side and center). The default line weight is 1.0, equivalent to setline(1)), but you can specify another.using Luxor # hide\nDrawing(400, 250, \"assets/figures/arrow.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"steelblue4\") # hide\nsetline(2) # hide\narrow(O, Point(0, -65))\narrow(O, Point(100, -65), arrowheadlength=20, arrowheadangle=pi/4, linewidth=.3)\narrow(O, 100, pi, pi/2, arrowheadlength=25,   arrowheadangle=pi/12, linewidth=1.25)\nfinish() # hide\nnothing # hide(Image: arrows)arrow"
},

{
    "location": "geometrytools/#Bounding-boxes-1",
    "page": "Geometry tools",
    "title": "Bounding boxes",
    "category": "section",
    "text": "The BoundingBox type allows you to use rectangular extents to organize and interact with the 2D drawing area. A BoundingBox holds two points, the opposite corners of a bounding box.You can make a BoundingBox from the current drawing, two points, a text string, an existing polygon, or by modifying an existing one.BoundingBox() without arguments defines an extent that encloses the drawing (assuming that the origin is at the center of the drawing—see origin()). Use centered=false if the drawing origin is still at the top left corner.This example draws circles at three points: at two of the drawing\'s corners and the midway point between them:using Luxor # hide\nDrawing(700, 400, \"assets/figures/bbox.png\") # hide\nbackground(\"white\") # hide\n\norigin()\n\nbb = BoundingBox()\nsetline(10)\nsethue(\"orange\")\n\ncircle(bb[1], 150, :stroke) # first corner\n\ncircle(bb[2], 150, :stroke) # second corner\n\ncircle(midpoint(bb...), 150, :stroke) # midpoint\n\nsethue(\"blue\")\ncircle.([bb[1], midpoint(bb[1:2]), bb[2]], 130, :fill)\n\nsethue(\"red\")\ncircle.([first(bb), midpoint(bb...), last(bb)], 100, :fill)\n\nfinish() # hide\nnothing # hide(Image: bounding box)You can make a bounding box from a polygon:using Luxor # hide\nDrawing(400, 200, \"assets/figures/bboxpoly.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\n\np = star(O, 100, 5, 0.1, pi/3.3, vertices=true)\nsethue(\"antiquewhite\")\nbox(BoundingBox(p), :fill)\n\nsethue(\"black\")\npoly(p, :stroke, close=true)\n\nfinish() # hide\nnothing # hide(Image: bounding box of polygon)The resulting bounding box objects can be passed to box() or poly() to be drawn.Pass a bounding box to midpoint() to find its center point. The functions boxbottom(), boxheight(), boxtop(), boxaspectratio(), boxdiagonal(), and  boxwidth() return information about a bounding box.To convert a bounding box b into a box, use box(b, vertices=true) or convert(Vector{Point}, BoundingBox()).You can also do some arithmetic on bounding boxes. In the next example, the bounding box is created from the text \"good afternoon\". The bounding box is filled with purple, then increased by 40 units on all sides (blue), also scaled by 1.3 (green), and also shifted by (0, 100) (orange).using Luxor # hide\nDrawing(500, 300, \"assets/figures/bbox2.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\n\ntranslate(-130,0)\nfontsize(40)\nstr = \"good afternoon\"\nsethue(\"purple\")\nbox(BoundingBox(str), :fill)\nsethue(\"white\")\ntext(str)\n\nsethue(\"blue\")\nmodbox = BoundingBox(str) + 40 # add 40 units to all sides\npoly(modbox, :stroke, close=true)\n\nsethue(\"green\")\nmodbox = BoundingBox(str) * 1.3\npoly(modbox, :stroke, close=true)\n\nsethue(\"orange\")\nmodbox = BoundingBox(str) + (0, 100)\npoly(modbox, :fill, close=true)\n\nfinish() # hide\nnothing # hide(Image: bounding boxes 2)You can find the union and intersection of BoundingBoxes, and also find whether a point lies inside one. The following code creates, shrinks, and shifts two bounding boxes (colored yellow and pink), and then draws: their union (a bounding box that includes both), in black outline; and their intersection (a bounding box of their common areas), in red. Then some random points are created and drawn differently depending on whether they\'re inside the intersection or outside.using Luxor, Random # hide\nDrawing(600, 400, \"assets/figures/bbox3.png\") # hide\nbackground(\"white\") # hide\nRandom.seed!(42) # hide\n\norigin()\nsetopacity(0.75)\nsetline(8)\n\nbbox1 = BoundingBox()/2 - (50, 30)\nsethue(\"yellow\")\nbox(bbox1, :fill)\n\nbbox2 = BoundingBox()/2  + (50, 30)\nsethue(\"pink\")\nbox(bbox2, :fill)\n\nsethue(\"black\")\nbox(bbox1 + bbox2, :stroke)\n\nsethue(\"red\")\nbothboxes = intersectboundingboxes(bbox1, bbox2)\nbox(bothboxes, :fill)\n\nfor i in 1:500\n    pt = randompoint(bbox1 + bbox2...)\n    if isinside(pt, bothboxes)\n        sethue(\"white\")\n        circle(pt, 3, :fill)\n    else\n        sethue(\"black\")\n        circle(pt, 2, :fill)\n    end\nend\n\nfinish() # hide\nnothing # hide(Image: intersecting bounding boxes)boxaspectratio\nboxdiagonal\nboxwidth\nboxheight\nintersectboundingboxes\nboxtop\nboxbottom"
},

{
    "location": "geometrytools/#Luxor.noise",
    "page": "Geometry tools",
    "title": "Luxor.noise",
    "category": "function",
    "text": "noise(x, y = 1, z = 1;\n    detail::Int64 = 1,\n    persistence   = 0.0)\n\nGenerate a noise value between 0.0 and 1.0 corresponding to the x, y, and z values.\n\nThe detail value is an integer specifying how many octaves of noise you want.\n\nThe persistence value, typically between 0.0 and 1.0, controls how quickly the amplitude diminishes for each successive octave for values of detail greater than 1.\n\n\n\n\n\n"
},

{
    "location": "geometrytools/#Luxor.seednoise",
    "page": "Geometry tools",
    "title": "Luxor.seednoise",
    "category": "function",
    "text": "seednoise(a::Array{Int64}))\n\nChange the initial values for noise generation. a is an array of 512 integers between 1 and 12 inclusive.\n\nseednoise(rand(1:3, 512))\n\nThere\'s Luxor.initnoise() to restore the original values.\n\n\n\n\n\n"
},

{
    "location": "geometrytools/#Noise-1",
    "page": "Geometry tools",
    "title": "Noise",
    "category": "section",
    "text": "For artistic graphics you might prefer noisy input values to purely random ones. Use the noise() function to obtain smoothly changing random values corresponding to input coordinates. The returned values wander slowly rather than jump about everywhere.In this example, the gray value varies gradually as the noise() function returns values between 0 and 1 depending on the location of the two input values pos.x and pos.y.The top two quadrants use a lower value for the detail keyword argument, an integer specifying how many \"octaves\" of noise you want. You can see that the detail level is low.The left two quadrants use a lower value for the persistence keyword argument, a floating point number specifying how quickly the amplitude diminishes for each successive level of detail. There is more fine detail when the persistence is higher, particularly when the detail setting is also high.using Luxor, Colors # hide\nDrawing(800, 400, \"assets/figures/noise.png\") # hide\n\nbackground(\"white\") # hide\norigin() # hide\n\ntiles = Tiler(800, 400, 200, 200)\nsethue(\"black\")\nfor (pos, n) in tiles\n    freq = 0.005\n    pos.y < 0 ? d = 2 : d = 4\n    pos.x < 0 ? pers = 0.35 : pers = 1.25\n    ns = noise(freq * pos.x, freq * pos.y, detail=d, persistence=pers)\n    setgray(ns)\n    box(pos, tiles.tilewidth, tiles.tileheight, :fillstroke)\nend\n\nfinish() # hide\nnothing # hide(Image: noise)noise\nseednoise"
},

{
    "location": "tables-grids/#",
    "page": "Tables and grids",
    "title": "Tables and grids",
    "category": "page",
    "text": "DocTestSetup = quote\n    using Luxor, Colors\n    end"
},

{
    "location": "tables-grids/#Tables-and-grids-1",
    "page": "Tables and grids",
    "title": "Tables and grids",
    "category": "section",
    "text": "You often want to position graphics at regular locations on the drawing. The positions can be provided by:Tiler: a rectangular grid which you specify by enclosing area, and the number of rows and columns\nPartition: a rectangular grid which you specify by enclosing area, and the width and height of each cell\nGrid and GridHex a rectangular or hexagonal grid, on demand\nTable: a rectangular grid which you specify by providing row and column numbers, row heights and column widthsThese are types which act as iterators."
},

{
    "location": "tables-grids/#Luxor.Tiler",
    "page": "Tables and grids",
    "title": "Luxor.Tiler",
    "category": "type",
    "text": "tiles = Tiler(areawidth, areaheight, nrows, ncols, margin=20)\n\nA Tiler is an iterator that, for each iteration, returns a tuple of:\n\nthe x/y point of the center of each tile in a set of tiles that divide up a rectangular space such as a page into rows and columns (relative to current 0/0)\nthe number of the tile\n\nareawidth and areaheight are the dimensions of the area to be tiled, nrows/ncols are the number of rows and columns required, and margin is applied to all four edges of the area before the function calculates the tile sizes required.\n\nTiler and Partition are similar:\n\nPartition lets you specify the width and height of a cell\nTiler lets you specify how many rows and columns of cells you want, and a margin:\n\ntiles = Tiler(1000, 800, 4, 5, margin=20)\nfor (pos, n) in tiles\n    # the point pos is the center of the tile\nend\n\nYou can access the calculated tile width and height like this:\n\ntiles = Tiler(1000, 800, 4, 5, margin=20)\nfor (pos, n) in tiles\n    ellipse(pos.x, pos.y, tiles.tilewidth, tiles.tileheight, :fill)\nend\n\nIt\'s sometimes useful to know which row and column you\'re currently on. tiles.currentrow and tiles.currentcol should have that information for you.\n\nTo use a Tiler to make grid points:\n\nfirst.(collect(Tiler(800, 800, 4, 4))\n\nwhich returns an array of points that are the center points of the grid.\n\n\n\n\n\n"
},

{
    "location": "tables-grids/#Luxor.Partition",
    "page": "Tables and grids",
    "title": "Luxor.Partition",
    "category": "type",
    "text": "p = Partition(areawidth, areaheight, tilewidth, tileheight)\n\nA Partition is an iterator that, for each iteration, returns a tuple of:\n\nthe x/y point of the center of each tile in a set of tiles that divide up a\n\nrectangular space such as a page into rows and columns (relative to current 0/0)\n\nthe number of the tile\n\nareawidth and areaheight are the dimensions of the area to be tiled, tilewidth/tileheight are the dimensions of the tiles.\n\nTiler and Partition are similar:\n\nPartition lets you specify the width and height of a cell\nTiler lets you specify how many rows and columns of cells you want, and a margin\n\ntiles = Partition(1200, 1200, 30, 30)\nfor (pos, n) in tiles\n    # the point pos is the center of the tile\nend\n\nYou can access the calculated tile width and height like this:\n\ntiles = Partition(1200, 1200, 30, 30)\nfor (pos, n) in tiles\n    ellipse(pos.x, pos.y, tiles.tilewidth, tiles.tileheight, :fill)\nend\n\nIt\'s sometimes useful to know which row and column you\'re currently on:\n\ntiles.currentrow\ntiles.currentcol\n\nshould have that information for you.\n\nUnless the tilewidth and tileheight are exact multiples of the area width and height, you\'ll see a border at the right and bottom where the tiles won\'t fit.\n\n\n\n\n\n"
},

{
    "location": "tables-grids/#Tiles-and-partitions-1",
    "page": "Tables and grids",
    "title": "Tiles and partitions",
    "category": "section",
    "text": "The drawing area (or any other area) can be divided into rectangular tiles (as rows and columns) using the Tiler and Partition iterators.The Tiler iterator returns the center point and tile number of each tile in turn.In this example, every third tile is divided up into subtiles and colored:using Luxor, Random # hide\nDrawing(800, 500, \"assets/figures/tiler.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nRandom.seed!(1) # hide\nfontsize(20) # hide\ntiles = Tiler(800, 500, 4, 5, margin=5)\nfor (pos, n) in tiles\n    randomhue()\n    box(pos, tiles.tilewidth, tiles.tileheight, :fill)\n    if n % 3 == 0\n        gsave()\n        translate(pos)\n        subtiles = Tiler(tiles.tilewidth, tiles.tileheight, 4, 4, margin=5)\n\n        @show tiles[n]\n        for (pos1, n1) in subtiles\n            randomhue()\n            box(pos1, subtiles.tilewidth, subtiles.tileheight, :fill)\n        end\n        grestore()\n    end\n    sethue(\"white\")\n    textcentered(string(n), pos + Point(0, 5))\nend\nfinish() # hide\nnothing # hide(Image: tiler)Partition is like Tiler, but you specify the width and height of the tiles, rather than how many rows and columns of tiles you want.Tiler\nPartitionYou can obtain the centerpoints of all the tiles in one go with:first.(collect(tiles))or obtain ranges with:tiles[1:2:end]"
},

{
    "location": "tables-grids/#Tables-1",
    "page": "Tables and grids",
    "title": "Tables",
    "category": "section",
    "text": "The Table iterator can be used to define tables: rectangular grids with a specific number of rows and columns. The columns can have different widths, and the rows can have different heights. Tables don\'t store data, but are designed to help you draw tabular data.To create a simple table with 3 rows and 4 columns, using the default width and height (100):julia> t = Table(3, 4);When you use this as an iterator, you can get the coordinates of the center of each cell, and its number:julia> for i in t\n           println(\"row: $(t.currentrow), column: $(t.currentcol), center: $(i[1])\")\n       end\nrow: 1, column: 1, center: Luxor.Point(-150.0, -100.0)\nrow: 1, column: 2, center: Luxor.Point(-50.0, -100.0)\nrow: 1, column: 3, center: Luxor.Point(50.0, -100.0)\nrow: 1, column: 4, center: Luxor.Point(150.0, -100.0)\nrow: 2, column: 1, center: Luxor.Point(-150.0, 0.0)\nrow: 2, column: 2, center: Luxor.Point(-50.0, 0.0)\nrow: 2, column: 3, center: Luxor.Point(50.0, 0.0)\nrow: 2, column: 4, center: Luxor.Point(150.0, 0.0)\nrow: 3, column: 1, center: Luxor.Point(-150.0, 100.0)\nrow: 3, column: 2, center: Luxor.Point(-50.0, 100.0)\nrow: 3, column: 3, center: Luxor.Point(50.0, 100.0)\nrow: 3, column: 4, center: Luxor.Point(150.0, 100.0)You can also access row and column information:julia> for r in 1:size(t)[1]\n           for c in 1:size(t)[2]\n               @show t[r, c]\n           end\n       end\nt[r, c] = Luxor.Point(-150.0, -100.0)\nt[r, c] = Luxor.Point(-50.0, -100.0)\nt[r, c] = Luxor.Point(50.0, -100.0)\nt[r, c] = Luxor.Point(150.0, -100.0)\nt[r, c] = Luxor.Point(-150.0, 0.0)\nt[r, c] = Luxor.Point(-50.0, 0.0)\nt[r, c] = Luxor.Point(50.0, 0.0)\nt[r, c] = Luxor.Point(150.0, 0.0)\nt[r, c] = Luxor.Point(-150.0, 100.0)\nt[r, c] = Luxor.Point(-50.0, 100.0)\nt[r, c] = Luxor.Point(50.0, 100.0)\nt[r, c] = Luxor.Point(150.0, 100.0)The next example creates a table with 10 rows and 10 columns, where each cell is 50 units wide and 35 high.using Luxor, Random # hide\nDrawing(600, 400, \"assets/figures/table2.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nRandom.seed!(42) # hide\nfontface(\"Helvetica-Bold\") # hide\nfontsize(20) # hide\nsethue(\"black\")\n\nt = Table(10, 10, 50, 35) # 10 rows, 10 columns, 50 wide, 35 high\n\nhundred = 1:100\n\nfor n in 1:length(t)\n   text(string(hundred[n]), t[n], halign=:center, valign=:middle)\nend\n\nsetopacity(0.5)\nsethue(\"thistle\")\ncircle.(t[3, :], 20, :fill) # row 3, every column\n\nfinish() # hide\nnothing # hide(Image: table 2)You can access rows or columns in the usual Julian way.Notice that the table is drawn row by row, whereas 2D Julia arrays are usually accessed column by column."
},

{
    "location": "tables-grids/#Varying-row-heights-and-column-widths-1",
    "page": "Tables and grids",
    "title": "Varying row heights and column widths",
    "category": "section",
    "text": "To specify varying row heights and column widths, supply arrays or ranges to the Table constructor. The next example has logarithmically increasing row heights, and four columns of width 130 points:using Luxor # hide\nDrawing(600, 400, \"assets/figures/table1.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\n\nt = Table(10 .^ range(0.7, length=25, stop=1.5), fill(130, 4))\n\nfor (pt, n) in t\n    setgray(rescale(n, 1, length(t), 0, 1))\n    box(pt, t.colwidths[t.currentcol], t.rowheights[t.currentrow], :fill)\n    sethue(\"white\")\n    fontsize(t.rowheights[t.currentrow])\n    text(string(n), pt, halign=:center, valign=:middle)\nend\n\nfinish() # hide\nnothing # hide(Image: table 1)To fill table cells, it\'s useful to be able to access the table\'s row and column specifications (using the colwidths and rowheights fields), and iteration can also provide information about the current row and column being processed (currentrow and currentcol).To ensure that graphic elements don\'t stray outside the cell walls, you can use a clipping region."
},

{
    "location": "tables-grids/#Luxor.Table",
    "page": "Tables and grids",
    "title": "Luxor.Table",
    "category": "type",
    "text": "t = Table(nrows, ncols)\nt = Table(nrows, ncols, colwidth, rowheight)\nt = Table(rowheights, columnwidths)\n\nTables are centered at O, but you can supply a point after the specifications.\n\nt = Table(nrows, ncols, centerpoint)\nt = Table(nrows, ncols, colwidth, rowheight, centerpoint)\nt = Table(rowheights, columnwidths, centerpoint)\n\nExamples\n\nSimple tables\n\nt = Table(4, 3) # 4 rows and 3 cols, default is 100w, 50 h\nt = Table(4, 3, 80, 30)   # 4 rows of 30pts high, 3 cols of 80pts wide\nt = Table(4, 3, (80, 30)) # same\nt = Table((4, 3), (80, 30)) # same\n\nSpecify row heights and column widths instead of quantities:\n\nt = Table([60, 40, 100], 50) # 3 different height rows, 1 column 50 wide\nt = Table([60, 40, 100], [100, 60, 40]) # 3 rows, 3 columns\nt = Table(fill(30, (10)), [50, 50, 50]) # 10 rows 30 high, 3 columns 10 wide\nt = Table(50, [60, 60, 60]) # just 1 row (50 high), 3 columns 60 wide\nt = Table([50], [50]) # just 1 row, 1 column, both 50 units wide\nt = Table(50, 50, 10, 5) # 50 rows, 50 columns, 10 units wide, 5 units high\nt = Table([6, 11, 16, 21, 26, 31, 36, 41, 46], [6, 11, 16, 21, 26, 31, 36, 41, 46])\nt = Table(15:5:55, vcat(5:2:15, 15:-2:5))\n #  table has 108 cells, with:\n #  row heights: 15 20 25 30 35 40 45 50 55\n #  col widths:  5 7 9 11 13 15 15 13 11 9 7 5\nt = Table(vcat(5:10:60, 60:-10:5), vcat(5:10:60, 60:-10:5))\nt = Table(vcat(5:10:60, 60:-10:5), 50) # 1 column 50 units wide\nt = Table(vcat(5:10:60, 60:-10:5), 1:5:50)\n\nA Table is an iterator that, for each iteration, returns a tuple of:\n\nthe x/y point of the center of cells arranged in rows and columns (relative to current 0/0)\nthe number of the cell (left to right, then top to bottom)\n\nnrows/ncols are the number of rows and columns required.\n\nIt\'s sometimes useful to know which row and column you\'re currently on while iterating:\n\nt.currentrow\nt.currentcol\n\nand row heights and column widths are available in:\n\nt.rowheights\nt.colwidths\n\nbox(t::Table, r, c) can be used to fill table cells:\n\n@svg begin\n    for (pt, n) in (t = Table(8, 3, 30, 15))\n        randomhue()\n        box(t, t.currentrow, t.currentcol, :fill)\n        sethue(\"white\")\n        text(string(n), pt)\n    end\nend\n\nor without iteration, using cellnumber:\n\n@svg begin\n    t = Table(8, 3, 30, 15)\n    for n in eachindex(t)\n        randomhue()\n        box(t, n, :fill)\n        sethue(\"white\")\n        text(string(n), t[n])\n    end\nend\n\nTo use a Table to make grid points:\n\njulia> first.(collect(Table(10, 6)))\n60-element Array{Luxor.Point,1}:\n Luxor.Point(-10.0, -18.0)\n Luxor.Point(-6.0, -18.0)\n Luxor.Point(-2.0, -18.0)\n ⋮\n Luxor.Point(2.0, 18.0)\n Luxor.Point(6.0, 18.0)\n Luxor.Point(10.0, 18.0)\n\nwhich returns an array of points that are the center points of the cells in the table.\n\n\n\n\n\n"
},

{
    "location": "tables-grids/#Drawing-arrays-and-dataframes-1",
    "page": "Tables and grids",
    "title": "Drawing arrays and dataframes",
    "category": "section",
    "text": "With a little bit of extra work you can write code that draws objects like arrays and dataframes combining text with graphic features. For example, this code draws arrays visually and numerically.using Luxor, Random # hide\nfunction drawbar(t::Table, data, row, column, minvalue, maxvalue, barheight)\n    setline(1.5)\n    cellwidth = t.colwidths[column] - 10\n    leftmargin = t[row, column] - (cellwidth/2, 0)\n    sethue(\"gray70\")\n    box(leftmargin - (0, barheight/2), leftmargin + (cellwidth, barheight/2), :fill)\n    boxwidth = rescale(data[row, column], minvalue, maxvalue, 0, cellwidth)\n    sethue(\"thistle\")\n    box(leftmargin - (0, barheight/2), leftmargin + (boxwidth, barheight/2), :fill)\n    sethue(\"black\")\n    line(leftmargin + (boxwidth, -barheight/2),\n         leftmargin + (boxwidth, +barheight/2),\n         :stroke)\n    text(string(round(data[row, column], digits=3)), t[row, column] - (cellwidth/2, 10),\n         halign=:left)\nend\n\nDrawing(700, 250, \"assets/figures/arraytable.png\")  # hide\norigin() # hide\nbackground(\"white\") # hide\nRandom.seed!(42) # hide\nA = rand(6, 6)\nl, h = extrema(A)\nrt, ct = size(A)\nt = Table(size(A), (80, 30))\nfontface(\"Georgia\")\nfontsize(12)\nfor r in 1:rt\n    for c in 1:ct\n        drawbar(t, A, r, c, l, h, 10)\n    end\nend\nfinish() # hide\nnothing # hide(Image: array table)Table"
},

{
    "location": "tables-grids/#Luxor.GridRect",
    "page": "Tables and grids",
    "title": "Luxor.GridRect",
    "category": "type",
    "text": "GridRect(startpoint, xspacing, yspacing, width, height)\n\nDefine a rectangular grid, to start at startpoint and proceed along the x-axis in steps of xspacing, then along the y-axis in steps of yspacing.\n\nGridRect(startpoint, xspacing=100.0, yspacing=100.0, width=1200.0, height=1200.0)\n\nFor a column, set the xspacing to 0:\n\ngrid = GridRect(O, 0, 40)\n\nTo get points from the grid, use nextgridpoint(g::Grid).\n\njulia> grid = GridRect(O, 0, 40);\njulia> nextgridpoint(grid)\nLuxor.Point(0.0,0.0)\n\njulia> nextgridpoint(grid)\nLuxor.Point(0.0,40.0)\n\nWhen you run out of grid points, you\'ll wrap round and start again.\n\n\n\n\n\n"
},

{
    "location": "tables-grids/#Luxor.GridHex",
    "page": "Tables and grids",
    "title": "Luxor.GridHex",
    "category": "type",
    "text": "GridHex(startpoint, radius, width=1200.0, height=1200.0)\n\nDefine a hexagonal grid, to start at startpoint and proceed along the x-axis and then along the y-axis, radius is the radius of a circle that encloses each hexagon. The distance in x between the centers of successive hexagons is:\n\nfracsqrt(3) radius2\n\nTo get the next point from the grid, use nextgridpoint(g::Grid).\n\nWhen you run out of grid points, you\'ll wrap round and start again.\n\n\n\n\n\n"
},

{
    "location": "tables-grids/#Luxor.nextgridpoint",
    "page": "Tables and grids",
    "title": "Luxor.nextgridpoint",
    "category": "function",
    "text": "nextgridpoint(g::GridRect)\n\nReturns the next available (or even the first) grid point of a grid.\n\n\n\n\n\nnextgridpoint(g::GridHex)\n\nReturns the next available grid point of a hexagonal grid.\n\n\n\n\n\n"
},

{
    "location": "tables-grids/#Grids-1",
    "page": "Tables and grids",
    "title": "Grids",
    "category": "section",
    "text": "You might also find a use for a grid. Luxor provides a simple grid utility. Grids are lazy: they\'ll supply the next point on the grid when you ask for it.Define a rectangular grid with GridRect, and a hexagonal grid with GridHex. Get the next grid point from a grid with nextgridpoint(grid).using Luxor, Random # hide\nDrawing(700, 250, \"assets/figures/grids.png\")  # hide\nbackground(\"white\") # hide\nfontsize(14) # hide\ntranslate(50, 50) # hide\nRandom.seed!(42) # hide\ngrid = GridRect(O, 40, 80, (10 - 1) * 40)\nfor i in 1:20\n    randomhue()\n    p = nextgridpoint(grid)\n    squircle(p, 20, 20, :fill)\n    sethue(\"white\")\n    text(string(i), p, halign=:center)\nend\nfinish() # hide\nnothing # hide(Image: grids)using Luxor, Random # hide\nDrawing(700, 400, \"assets/figures/grid-hex.png\")  # hide\nbackground(\"white\") # hide\nfontsize(22) # hide\nRandom.seed!(42)\ntranslate(100, 100) # hide\nradius = 70\ngrid = GridHex(O, radius, 600)\n\nfor i in 1:15\n    randomhue()\n    p = nextgridpoint(grid)\n    ngon(p, radius-5, 6, pi/2, :fillstroke)\n    sethue(\"white\")\n    text(string(i), p, halign=:center)\nend\nfinish() # hide\nnothing # hide(Image: hex grid)GridRect\nGridHex\nnextgridpoint"
},

{
    "location": "colors-styles/#",
    "page": "Colors and styles",
    "title": "Colors and styles",
    "category": "page",
    "text": "DocTestSetup = quote\n    using Luxor, Colors\n    end"
},

{
    "location": "colors-styles/#Colors-and-styles-1",
    "page": "Colors and styles",
    "title": "Colors and styles",
    "category": "section",
    "text": ""
},

{
    "location": "colors-styles/#Luxor.sethue",
    "page": "Colors and styles",
    "title": "Luxor.sethue",
    "category": "function",
    "text": "sethue(\"black\")\nsethue(0.3, 0.7, 0.9)\nsetcolor(sethue(\"red\")..., .2)\n\nSet the color without changing opacity.\n\nsethue() is like setcolor(), but we sometimes want to change the current color without changing alpha/opacity. Using sethue() rather than setcolor() doesn\'t change the current alpha opacity.\n\nSee also setcolor.\n\n\n\n\n\nsethue(col::ColorTypes.Colorant)\n\nSet the color without changing the current alpha/opacity:\n\n\n\n\n\nsethue(0.3, 0.7, 0.9)\n\nSet the color\'s r, g, b values. Use setcolor(r,g,b,a) to set transparent colors.\n\n\n\n\n\nsethue((r, g, b))\n\nSet the color to the tuple\'s values.\n\n\n\n\n\nsethue((r, g, b, a))\n\nSet the color to the tuple\'s values.\n\n\n\n\n\n"
},

{
    "location": "colors-styles/#Luxor.setcolor",
    "page": "Colors and styles",
    "title": "Luxor.setcolor",
    "category": "function",
    "text": "setcolor(\"gold\")\nsetcolor(\"darkturquoise\")\n\nSet the current color to a named color. This use the definitions in Colors.jl to convert a string to RGBA eg setcolor(\"gold\") or \"green\", \"darkturquoise\", \"lavender\", etc. The list is at Colors.color_names.\n\nUse sethue() for changing colors without changing current opacity level.\n\nsethue() and setcolor() return the three or four values that were used:\n\njulia> setcolor(sethue(\"red\")..., .8)\n\n(1.0,0.0,0.0,0.8)\n\njulia> sethue(setcolor(\"red\")[1:3]...)\n\n(1.0,0.0,0.0)\n\nYou can also do:\n\nusing Colors\nsethue(colorant\"red\")\n\nSee also setcolor.\n\n\n\n\n\nsetcolor(r, g, b)\nsetcolor(r, g, b, alpha)\nsetcolor(color)\nsetcolor(col::ColorTypes.Colorant)\nsetcolor(sethue(\"red\")..., .2)\n\nSet the current color.\n\nExamples:\n\nsetcolor(convert(Colors.HSV, Colors.RGB(0.5, 1, 1)))\nsetcolor(.2, .3, .4, .5)\nsetcolor(convert(Colors.HSV, Colors.RGB(0.5, 1, 1)))\n\nfor i in 1:15:360\n   setcolor(convert(Colors.RGB, Colors.HSV(i, 1, 1)))\n   ...\nend\n\nSee also sethue.\n\n\n\n\n\nsetcolor((r, g, b))\n\nSet the color to the tuple\'s values.\n\n\n\n\n\nsetcolor((r, g, b, a))\n\nSet the color to the tuple\'s values.\n\n\n\n\n\n"
},

{
    "location": "colors-styles/#Luxor.setgray",
    "page": "Colors and styles",
    "title": "Luxor.setgray",
    "category": "function",
    "text": "setgray(n)\nsetgrey(n)\n\nSet the color to a gray level of n, where n is between 0 and 1.\n\n\n\n\n\n"
},

{
    "location": "colors-styles/#Luxor.setopacity",
    "page": "Colors and styles",
    "title": "Luxor.setopacity",
    "category": "function",
    "text": "setopacity(alpha)\n\nSet the current opacity to a value between 0 and 1. This modifies the alpha value of the current color.\n\n\n\n\n\n"
},

{
    "location": "colors-styles/#Luxor.randomhue",
    "page": "Colors and styles",
    "title": "Luxor.randomhue",
    "category": "function",
    "text": "randomhue()\n\nSet a random hue, without changing the current alpha opacity.\n\n\n\n\n\n"
},

{
    "location": "colors-styles/#Luxor.randomcolor",
    "page": "Colors and styles",
    "title": "Luxor.randomcolor",
    "category": "function",
    "text": "randomcolor()\n\nSet a random color. This may change the current alpha opacity too.\n\n\n\n\n\n"
},

{
    "location": "colors-styles/#Luxor.setblend",
    "page": "Colors and styles",
    "title": "Luxor.setblend",
    "category": "function",
    "text": "setblend(blend)\n\nStart using the named blend for filling graphics.\n\nThis aligns the original coordinates of the blend definition with the current axes.\n\n\n\n\n\n"
},

{
    "location": "colors-styles/#Color-and-opacity-1",
    "page": "Colors and styles",
    "title": "Color and opacity",
    "category": "section",
    "text": "For color definitions and conversions, you can use Colors.jl.setcolor() and sethue() apply a single solid or transparent color to shapes.setblend() applies a smooth transition between two or more colors.setmesh() applies a color mesh.The difference between the setcolor() and sethue() functions is that sethue() is independent of alpha opacity, so you can change the hue without changing the current opacity value.Named colors, such as \"gold\", or \"lavender\", can be found in Colors.color_names.using Luxor, Colors # hide\nDrawing(800, 800, \"assets/figures/colors.svg\") # hide\n\norigin() # hide\nbackground(\"white\") # hide\nfontface(\"AvenirNextCondensed-Regular\") # hide\nfontsize(8)\ncols = sort(collect(Colors.color_names))\nncols = 15\nnrows = convert(Int, ceil(length(cols) / ncols))\ntable = Table(nrows, ncols, 800/ncols, 800/nrows)\ngamma = 2.2\nfor n in 1:length(cols)\n    col = cols[n][1]\n    r, g, b = sethue(col)\n    box(table[n], table.colwidths[1], table.rowheights[1], :fill)\n    luminance = 0.2126 * r^gamma + 0.7152 * g^gamma + 0.0722 * b^gamma\n    (luminance > 0.5^gamma) ? sethue(\"black\") : sethue(\"white\")\n    text(string(cols[n][1]), table[n], halign=:center, valign=:middle)\nend\nfinish() # hide\n\nnothing #hide(Image: line endings)(To make the label stand out against the background, the luminance is calculated, then used to choose the label\'s color.)sethue\nsetcolor\nsetgray\nsetopacity\nrandomhue\nrandomcolor\nsetblend"
},

{
    "location": "colors-styles/#Luxor.setline",
    "page": "Colors and styles",
    "title": "Luxor.setline",
    "category": "function",
    "text": "setline(n)\n\nSet the line width.\n\n\n\n\n\n"
},

{
    "location": "colors-styles/#Luxor.setlinecap",
    "page": "Colors and styles",
    "title": "Luxor.setlinecap",
    "category": "function",
    "text": "setlinecap(s)\n\nSet the line ends. s can be \"butt\" (the default), \"square\", or \"round\".\n\n\n\n\n\n"
},

{
    "location": "colors-styles/#Luxor.setlinejoin",
    "page": "Colors and styles",
    "title": "Luxor.setlinejoin",
    "category": "function",
    "text": "setlinejoin(\"miter\")\nsetlinejoin(\"round\")\nsetlinejoin(\"bevel\")\n\nSet the line join style, or how to render the junction of two lines when stroking.\n\n\n\n\n\n"
},

{
    "location": "colors-styles/#Luxor.setdash",
    "page": "Colors and styles",
    "title": "Luxor.setdash",
    "category": "function",
    "text": "setlinedash(\"dot\")\n\nSet the dash pattern to one of: \"solid\", \"dotted\", \"dot\", \"dotdashed\", \"longdashed\", \"shortdashed\", \"dash\", \"dashed\", \"dotdotdashed\", \"dotdotdotdashed\"\n\n\n\n\n\n"
},

{
    "location": "colors-styles/#Luxor.fillstroke",
    "page": "Colors and styles",
    "title": "Luxor.fillstroke",
    "category": "function",
    "text": "fillstroke()\n\nFill and stroke the current path.\n\n\n\n\n\n"
},

{
    "location": "colors-styles/#Luxor.strokepath",
    "page": "Colors and styles",
    "title": "Luxor.strokepath",
    "category": "function",
    "text": "strokepath()\n\nStroke the current path with the current line width, line join, line cap, and dash settings. The current path is then cleared.\n\n\n\n\n\n"
},

{
    "location": "colors-styles/#Luxor.fillpath",
    "page": "Colors and styles",
    "title": "Luxor.fillpath",
    "category": "function",
    "text": "fillpath()\n\nFill the current path according to the current settings. The current path is then cleared.\n\n\n\n\n\n"
},

{
    "location": "colors-styles/#Luxor.strokepreserve",
    "page": "Colors and styles",
    "title": "Luxor.strokepreserve",
    "category": "function",
    "text": "strokepreserve()\n\nStroke the current path with current line width, line join, line cap, and dash settings, but then keep the path current.\n\n\n\n\n\n"
},

{
    "location": "colors-styles/#Luxor.fillpreserve",
    "page": "Colors and styles",
    "title": "Luxor.fillpreserve",
    "category": "function",
    "text": "fillpreserve()\n\nFill the current path with current settings, but then keep the path current.\n\n\n\n\n\n"
},

{
    "location": "colors-styles/#Luxor.paint",
    "page": "Colors and styles",
    "title": "Luxor.paint",
    "category": "function",
    "text": "paint()\n\nPaint the current clip region with the current settings.\n\n\n\n\n\n"
},

{
    "location": "colors-styles/#Luxor.do_action",
    "page": "Colors and styles",
    "title": "Luxor.do_action",
    "category": "function",
    "text": "do_action(action)\n\nThis is usually called by other graphics functions. Actions for graphics commands include :fill, :stroke, :clip, :fillstroke, :fillpreserve, :strokepreserve, :none, and :path.\n\n\n\n\n\n"
},

{
    "location": "colors-styles/#Line-styles-1",
    "page": "Colors and styles",
    "title": "Line styles",
    "category": "section",
    "text": "There are set- functions for controlling subsequent lines\' width, end shapes, join behavior, and dash patterns:using Luxor # hide\nDrawing(400, 250, \"assets/figures/line-ends.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\ntranslate(-100, -60) # hide\nfontsize(18) # hide\nfor l in 1:3\n    sethue(\"black\")\n    setline(20)\n    setlinecap([\"butt\", \"square\", \"round\"][l])\n    textcentred([\"butt\", \"square\", \"round\"][l], 80l, 80)\n    setlinejoin([\"round\", \"miter\", \"bevel\"][l])\n    textcentred([\"round\", \"miter\", \"bevel\"][l], 80l, 120)\n    poly(ngon(Point(80l, 0), 20, 3, 0, vertices=true), :strokepreserve, close=false)\n    sethue(\"white\")\n    setline(1)\n    strokepath()\nend\nfinish() # hide\nnothing # hide(Image: line endings)using Luxor # hide\nDrawing(600, 250, \"assets/figures/dashes.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nfontsize(14) # hide\nsethue(\"black\") # hide\n\npatterns = [\"solid\", \"dotted\", \"dot\", \"dotdashed\", \"longdashed\",\n  \"shortdashed\", \"dash\", \"dashed\", \"dotdotdashed\", \"dotdotdotdashed\"]\nsetline(12)\n\ntable = Table(fill(20, length(patterns)), [50, 300])\ntext.(patterns, table[:, 1], halign=:right, valign=:middle)\n\nfor p in 1:length(patterns)\n    setdash(patterns[p])\n    pt = table[p, 2]\n    line(pt - (150, 0), pt + (150, 0), :stroke)\nend\nfinish() # hide\nnothing # hide(Image: dashes)setline\nsetlinecap\nsetlinejoin\nsetdash\nfillstroke\nstrokepath\nfillpath\nstrokepreserve\nfillpreserve\npaint\ndo_actionSoon you\'ll be able to define dash patterns in Luxor. For now:dashes = [50.0,  # ink\n          10.0,  # skip\n          10.0,  # ink\n          10.0   # skip\n          ]\noffset = -50.0\nCairo.set_dash(get_current_cr()(), dashes, offset)"
},

{
    "location": "colors-styles/#Luxor.blend",
    "page": "Colors and styles",
    "title": "Luxor.blend",
    "category": "function",
    "text": "blend(from::Point, to::Point)\n\nCreate an empty linear blend.\n\nA blend is a specification of how one color changes into another. Linear blends are defined by two points: parallel lines through these points define the start and stop locations of the blend. The blend is defined relative to the current axes origin. This means that you should be aware of the current axes when you define blends, and when you use them.\n\nTo add colors, use addstop().\n\n\n\n\n\nblend(centerpos1, rad1, centerpos2, rad2, color1, color2)\n\nCreate a radial blend.\n\nExample:\n\nredblue = blend(\n    pos, 0,                   # first circle center and radius\n    pos, tiles.tilewidth/2,   # second circle center and radius\n    \"red\",\n    \"blue\"\n    )\n\n\n\n\n\nblend(pt1::Point, pt2::Point, color1, color2)\n\nCreate a linear blend.\n\nExample:\n\nredblue = blend(pos, pos, \"red\", \"blue\")\n\n\n\n\n\nblend(from::Point, startradius, to::Point, endradius)\n\nCreate an empty radial blend.\n\nRadial blends are defined by two circles that define the start and stop locations. The first point is the center of the start circle, the first radius is the radius of the first circle.\n\nA new blend is empty. To add colors, use addstop().\n\n\n\n\n\n"
},

{
    "location": "colors-styles/#Luxor.addstop",
    "page": "Colors and styles",
    "title": "Luxor.addstop",
    "category": "function",
    "text": "addstop(b::Blend, offset, col)\naddstop(b::Blend, offset, (r, g, b, a))\naddstop(b::Blend, offset, string)\n\nAdd a color stop to a blend. The offset specifies the location along the blend\'s \'control vector\', which varies between 0 (beginning of the blend) and 1 (end of the blend). For linear blends, the control vector is from the start point to the end point. For radial blends, the control vector is from any point on the start circle, to the corresponding point on the end circle.\n\nExamples:\n\nblendredblue = blend(Point(0, 0), 0, Point(0, 0), 1)\naddstop(blendredblue, 0, setcolor(sethue(\"red\")..., .2))\naddstop(blendredblue, 1, setcolor(sethue(\"blue\")..., .2))\naddstop(blendredblue, 0.5, sethue(randomhue()...))\naddstop(blendredblue, 0.5, setcolor(randomcolor()...))\n\n\n\n\n\n"
},

{
    "location": "colors-styles/#Blends-1",
    "page": "Colors and styles",
    "title": "Blends",
    "category": "section",
    "text": "A blend is a color gradient. Use setblend() to select a blend in the same way that you\'d use setcolor() and sethue() to select a solid color.You can make linear or radial blends. Use blend() in either case.To create a simple linear blend between two colors, supply two points and two colors to blend():using Luxor # hide\nDrawing(600, 200, \"assets/figures/color-blends-basic.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\norangeblue = blend(Point(-200, 0), Point(200, 0), \"orange\", \"blue\")\nsetblend(orangeblue)\nbox(O, 400, 100, :fill)\nrulers()\nfinish() # hide\nnothing # hide(Image: linear blend)And for a radial blend, provide two point/radius pairs, and two colors:using Luxor # hide\nDrawing(600, 200, \"assets/figures/color-blends-radial.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\ngreenmagenta = blend(Point(0, 0), 5, Point(0, 0), 150, \"green\", \"magenta\")\nsetblend(greenmagenta)\nbox(O, 400, 200, :fill)\nrulers()\nfinish() # hide\nnothing # hide(Image: radial blends)You can also use blend() to create an empty blend. Then you use addstop() to define the locations of specific colors along the blend, where 0 is the start, and 1 is the end.using Luxor # hide\nDrawing(600, 200, \"assets/figures/color-blends-scratch.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\ngoldblend = blend(Point(-200, 0), Point(200, 0))\naddstop(goldblend, 0.0,  \"gold4\")\naddstop(goldblend, 0.25, \"gold1\")\naddstop(goldblend, 0.5,  \"gold3\")\naddstop(goldblend, 0.75, \"darkgoldenrod4\")\naddstop(goldblend, 1.0,  \"gold2\")\nsetblend(goldblend)\nbox(O, 400, 200, :fill)\nrulers()\nfinish() # hide\nnothing # hide(Image: blends from scratch)When you define blends, the location of the axes (eg the current workspace as defined by translate(), etc.), is important. In the first of the two following examples, the blend is selected before the axes are moved with translate(pos). The blend \'samples\' the original location of the blend\'s definition.using Luxor # hide\nDrawing(600, 200, \"assets/figures/color-blends-translate-1.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\ngoldblend = blend(Point(0, 0), Point(200, 0))\naddstop(goldblend, 0.0,  \"gold4\")\naddstop(goldblend, 0.25, \"gold1\")\naddstop(goldblend, 0.5,  \"gold3\")\naddstop(goldblend, 0.75, \"darkgoldenrod4\")\naddstop(goldblend, 1.0,  \"gold2\")\nsetblend(goldblend)\ntiles = Tiler(600, 200, 1, 5, margin=10)\nfor (pos, n) in tiles\n    gsave()\n    setblend(goldblend)\n    translate(pos)\n    ellipse(O, tiles.tilewidth, tiles.tilewidth, :fill)\n    grestore()\nend\nfinish() # hide\nnothing # hide(Image: blends 1)Outside the range of the original blend\'s definition, the same color is used, no matter how far away from the origin you go (there are Cairo options to change this). But in the next example, the blend is relocated to the current axes, which have just been moved to the center of the tile. The blend refers to 0/0 each time, which is at the center of shape.using Luxor # hide\nDrawing(600, 200, \"assets/figures/color-blends-translate-2.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\ngoldblend = blend(Point(0, 0), Point(200, 0))\naddstop(goldblend, 0.0,  \"gold4\")\naddstop(goldblend, 0.25, \"gold1\")\naddstop(goldblend, 0.5,  \"gold3\")\naddstop(goldblend, 0.75, \"darkgoldenrod4\")\naddstop(goldblend, 1.0,  \"gold2\")\nsetblend(goldblend)\ntiles = Tiler(600, 200, 1, 5, margin=10)\nfor (pos, n) in tiles\n    gsave()\n    translate(pos)\n    setblend(goldblend)\n    ellipse(O, tiles.tilewidth, tiles.tilewidth, :fill)\n    grestore()\nend\nfinish() # hide\nnothing # hide(Image: blends 2)blend\naddstop"
},

{
    "location": "colors-styles/#Luxor.blendadjust",
    "page": "Colors and styles",
    "title": "Luxor.blendadjust",
    "category": "function",
    "text": "blendadjust(ablend, center::Point, xscale, yscale, rot=0)\n\nModify an existing blend by scaling, translating, and rotating it so that it will fill a shape properly even if the position of the shape is nowhere near the original location of the blend\'s definition.\n\nFor example, if your blend definition was this (notice the 1)\n\nblendgoldmagenta = blend(\n        Point(0, 0), 0,                   # first circle center and radius\n        Point(0, 0), 1,                   # second circle center and radius\n        \"gold\",\n        \"magenta\"\n        )\n\nyou can use it in a shape that\'s 100 units across and centered at pos, by calling this:\n\nblendadjust(blendgoldmagenta, Point(pos.x, pos.y), 100, 100)\n\nthen use setblend():\n\nsetblend(blendgoldmagenta)\n\n\n\n\n\n"
},

{
    "location": "colors-styles/#Using-blendadjust()-1",
    "page": "Colors and styles",
    "title": "Using blendadjust()",
    "category": "section",
    "text": "You can use blendadjust() to modify the blend so that objects scaled and positioned after the blend was defined are rendered correctly.using Luxor # hide\nDrawing(600, 250, \"assets/figures/blend-adjust.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsetline(20)\n\n# first line\nblendgoldmagenta = blend(Point(-100, 0), Point(100, 0), \"gold\", \"magenta\")\nsetblend(blendgoldmagenta)\nline(Point(-100, -50), Point(100, -50))\nstrokepath()\n\n# second line\nblendadjust(blendgoldmagenta, Point(50, 0), 0.5, 0.5)\nline(O, Point(100, 0))\nstrokepath()\n\n# third line\nblendadjust(blendgoldmagenta, Point(-50, 50), 0.5, 0.5)\nline(Point(-100, 50), Point(0, 50))\nstrokepath()\n\n# fourth line\ngsave()\ntranslate(0, 100)\nscale(0.5, 0.5)\nsetblend(blendgoldmagenta)\nline(Point(-100, 0), Point(100, 0))\nstrokepath()\ngrestore()\n\nfinish() # hide\nnothing # hide(Image: blends adjust)The blend is defined to span 200 units, horizontally centered at 0/0. The top line is also 200 units long and centered horizontally at 0/0, so the blend is rendered exactly as you\'d hope.The second line is only half as long, at 100 units, centered at 50/0, so blendadjust() is used to relocate the blend\'s center to the point 50/0 and scale it by 0.5 (100/200).The third line is also 100 units long, centered at -50/0, so again blendadjust() is used to relocate the blend\'s center and scale it.The fourth line shows that you can translate and scale the axes instead of adjusting the blend, if you use setblend() again in the new scene.blendadjust"
},

{
    "location": "colors-styles/#Luxor.setmode",
    "page": "Colors and styles",
    "title": "Luxor.setmode",
    "category": "function",
    "text": "setmode(mode::AbstractString)\n\nSet the compositing/blending mode. mode can be one of:\n\n\"clear\" Where the second object is drawn, the first is completely removed.\n\"source\" The second object is drawn as if nothing else were below.\n\"over\" The default mode: like two transparent slides overlapping.\n\"in\" The first object is removed completely, the second is only drawn where the first was.\n\"out\" The second object is drawn only where the first one wasn\'t.\n\"atop\" The first object is mostly intact, but mixes both objects in the overlapping area. The second object object is not drawn elsewhere.\n\"dest\" Discard the second object completely.\n\"dest_over\" Like \"over\" but draw second object below the first\n\"dest_in\" Keep the first object whereever the second one overlaps.\n\"dest_out\" The second object is used to reduce the visibility of the first where they overlap.\n\"dest_atop\" Like \"over\" but draw second object below the first.\n\"xor\" XOR where the objects overlap\n\"add\" Add the overlapping areas together\n\"saturate\" Increase Saturation where objects overlap\n\"multiply\" Multiply where objects overlap\n\"screen\" Input colors are complemented and multiplied, the product is complemented again. The result is at least as light as the lighter of the input colors.\n\"overlay\" Multiplies or screens colors, depending on the lightness of the destination color.\n\"darken\" Selects the darker of the color values in each component.\n\"lighten\" Selects the lighter of the color values in each component.\n\nSee the Cairo documentation for details.\n\n\n\n\n\n"
},

{
    "location": "colors-styles/#Luxor.getmode",
    "page": "Colors and styles",
    "title": "Luxor.getmode",
    "category": "function",
    "text": "getmode()\n\nReturn the current compositing/blending mode as a string.\n\n\n\n\n\n"
},

{
    "location": "colors-styles/#Blending-(compositing)-operators-1",
    "page": "Colors and styles",
    "title": "Blending (compositing) operators",
    "category": "section",
    "text": "Graphics software provides ways to modify how the virtual \"ink\" is applied to existing graphic elements. In PhotoShop and other software products the compositing process is done using blend modes.Use setmode() to set the blending mode of subsequent graphics.using Luxor # hide\nDrawing(600, 600, \"assets/figures/blendmodes.png\") # hide\norigin()\n# transparent, no background\nfontsize(15)\nsetline(1)\ntiles = Tiler(600, 600, 4, 5, margin=30)\nmodes = length(Luxor.blendingmodes)\nsetcolor(\"black\")\nfor (pos, n) in tiles\n    n > modes && break\n    gsave()\n    translate(pos)\n    box(O, tiles.tilewidth-10, tiles.tileheight-10, :clip)\n\n    # calculate points for circles\n    diag = (Point(-tiles.tilewidth/2, -tiles.tileheight/2),\n            Point(tiles.tilewidth/2,  tiles.tileheight/2))\n    upper = between(diag, 0.4)\n    lower = between(diag, 0.6)\n\n    # first red shape uses default blend operator\n    setcolor(0.7, 0, 0, .8)\n    circle(upper, tiles.tilewidth/4, :fill)\n\n    # second blue shape shows results of blend operator\n    setcolor(0, 0, 0.9, 0.4)\n    blendingmode = Luxor.blendingmodes[mod1(n, modes)]\n    setmode(blendingmode)\n    circle(lower, tiles.tilewidth/4, :fill)\n\n    clipreset()\n    grestore()\n\n    gsave()\n    translate(pos)\n    text(Luxor.blendingmodes[mod1(n, modes)], O.x, O.y + tiles.tilewidth/2, halign=:center)\n    grestore()\nend\nfinish() # hide\nnothing # hide(Image: blend modes)Notice in this example that clipping was used to restrict the area affected by the blending process.In Cairo these blend modes are called operators. A source for a more detailed explanation can be found here.You can access the list of modes with the unexported symbol Luxor.blendingmodes.setmode\ngetmode"
},

{
    "location": "colors-styles/#Luxor.mesh",
    "page": "Colors and styles",
    "title": "Luxor.mesh",
    "category": "function",
    "text": "mesh(bezierpath::BezierPath,\n     colors=AbstractArray{ColorTypes.Colorant, 1})\n\nCreate a mesh. The first three or four elements of the supplied bezierpath define the three or four sides of the mesh shape.\n\nThe colors array define the color of each corner point. Colors are reused if necessary. At least one color should be supplied.\n\nUse setmesh() to select the mesh, which will be used to fill shapes.\n\nExample\n\n@svg begin\n    bp = makebezierpath(ngon(O, 50, 4, 0, vertices=true))\n    mesh1 = mesh(bp, [\n        \"red\",\n        Colors.RGB(0, 1, 0),\n        Colors.RGB(0, 1, 1),\n        Colors.RGB(1, 0, 1)\n        ])\n    setmesh(mesh1)\n    box(O, 500, 500, :fill)\nend\n\n\n\n\n\nmesh(points::AbstractArray{Point},\n     colors=AbstractArray{ColorTypes.Colorant, 1})\n\nCreate a mesh.\n\nCreate a mesh. The first three or four sides of the supplied points polygon define the three or four sides of the mesh shape.\n\nThe colors array define the color of each corner point. Colors are reused if necessary. At least one color should be supplied.\n\nExample\n\n@svg begin\n    pl = ngon(O, 250, 3, pi/6, vertices=true)\n    mesh1 = mesh(pl, [\n        \"purple\",\n        Colors.RGBA(0.0, 1.0, 0.5, 0.5),\n        \"yellow\"\n        ])\n    setmesh(mesh1)\n    setline(180)\n    ngon(O, 250, 3, pi/6, :strokepreserve)\n    setline(5)\n    sethue(\"black\")\n    strokepath()\nend\n\n\n\n\n\n"
},

{
    "location": "colors-styles/#Luxor.setmesh",
    "page": "Colors and styles",
    "title": "Luxor.setmesh",
    "category": "function",
    "text": "setmesh(mesh::Mesh)\n\nSelect a mesh previously created with mesh() for filling shapes.\n\n\n\n\n\n"
},

{
    "location": "colors-styles/#Meshes-1",
    "page": "Colors and styles",
    "title": "Meshes",
    "category": "section",
    "text": "A mesh provides smooth shading between three or four colors across a region defined by lines or curves.To create a mesh, use the mesh() function and save the result as a mesh object. To use a mesh, supply the mesh object to the setmesh() function.The mesh() function accepts either an array of Bézier paths or a polygon.This basic example obtains a polygon from the drawing area using box(BoundingBox()... and uses the four corners of the mesh and the four colors in the array to build the mesh. The paint() function fills the drawing.using Luxor, Colors # hide\nDrawing(600, 600, \"assets/figures/mesh-basic.png\") # hide\norigin() # hide\n\ngarishmesh = mesh(\n    box(BoundingBox(), vertices=true),\n    [\"purple\", \"green\", \"yellow\", \"red\"])\n\nsetmesh(garishmesh)\n\npaint()\n\nsetline(2)\nsethue(\"white\")\nhypotrochoid(180, 81, 130, :stroke)\nfinish() # hide\nnothing # hide(Image: mesh 1)The next example uses a Bézier path conversion of a square as the outline of the mesh. Because the box to be filled is larger than the mesh\'s outlines, not all the box is filled.using Luxor, Colors # hide\nDrawing(600, 600, \"assets/figures/mesh1.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsetcolor(\"grey50\")\ncircle.([Point(x, y) for x in -200:25:200, y in -200:25:200], 10, :fill)\n\nbp = makebezierpath(box(O, 300, 300, vertices=true), smoothing=.4)\nsetline(3)\nsethue(\"black\")\n\ndrawbezierpath(bp, :stroke)\nmesh1 = mesh(bp, [\n    Colors.RGBA(1, 0, 0, 1),   # bottom left, red\n    Colors.RGBA(1, 1, 1, 0.0), # top left, transparent\n    Colors.RGB(0, 0, 1),      # top right, blue\n    Colors.RGB(1, 0, 1)        # bottom right, purple\n    ])\nsetmesh(mesh1)\nbox(O, 500, 500, :fillpreserve)\nsethue(\"grey50\")\nstrokepath()\n\nfinish() # hide\nnothing # hide(Image: mesh 1)The second example uses a polygon defined by ngon() as the outline of the mesh. The mesh is drawn when the path is stroked.using Luxor # hide\nDrawing(600, 600, \"assets/figures/mesh2.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\npl = ngon(O, 250, 3, pi/6, vertices=true)\nmesh1 = mesh(pl, [\n    \"purple\",\n    \"green\",\n    \"yellow\"\n    ])\nsetmesh(mesh1)\nsetline(180)\npoly(pl, :strokepreserve, close=true)\nsetline(5)\nsethue(\"black\")\nstrokepath()\nfinish() # hide\nnothing # hide(Image: mesh 2)mesh\nsetmesh"
},

{
    "location": "polygons/#",
    "page": "Polygons and paths",
    "title": "Polygons and paths",
    "category": "page",
    "text": "DocTestSetup = quote\n    using Luxor, Colors, Random\n    end"
},

{
    "location": "polygons/#Polygons-and-paths-1",
    "page": "Polygons and paths",
    "title": "Polygons and paths",
    "category": "section",
    "text": "For drawing shapes, Luxor provides polygons and paths.A polygon is an ordered collection of Points stored in an array.A path is a sequence of one or more straight and curved (circular arc or Bézier curve) segments. Paths can consist of subpaths. Luxor maintains a \'current path\', to which you can add lines and curves until you finish with a stroke or fill instruction.Luxor also provides a BezierPath type, which is an array of four-point tuples, each of which is a Bézier cubic curve section.using Luxor, DelimitedFiles\nDrawing(800, 275, \"assets/figures/polytable.png\")\nbackground(\"white\")\norigin()\ntabledata = readdlm(IOBuffer(\n\"\"\"\n-             create                convert               draw               info              other             \npolygon       ngon()                polysmooth()          poly()             isinside()        simplify()\n-             ngonside()            -                     prettypoly()       polyperimeter()   polysplit()\n-             star()                -                     polysmooth()       polyarea()        polyportion()\n-             offsetpoly()          -                     -                  polycentroid()    polyremainder()\n-             polyfit()             -                     -                  boundingbox()     polysortbyangle()\n-             hyptrochoid()         -                     -                  -                 polysortbydistance()\n-             epitrochoid()         -                     -                  -                 polyintersections()\npath          getpath()             pathtopoly()          -                  -                 -\n-             getpathflat()         -                     -                  -                 -  \nbezierpath    makebezierpath()      pathtobezierpaths()   drawbezierpath()   -                 -\n-             pathtobezierpaths()   bezierpathtopoly()    brush()            -                 -  \n-             BezierPath()          -                     -                  -                 -\n-             BezierPathSegment()   -                     -                  -                 -\n\"\"\"))\n\n# find the widths of the columns\nnrows, ncols = size(tabledata)\nfontsize(12)\nfontface(\"Menlo\")\nwidths = Float64[]\nmargin=4\nfor c in 1:ncols\n    temp = []\n    for r in 1:nrows\n        te = textextents(tabledata[r, c])[3]\n        push!(temp, te + 10)\n    end\n    push!(widths, maximum(temp))\nend\n\n# draw table using the widths\nt = Table(fill(20, nrows), widths)\nfor r in 1:size(t)[1]\n   for c in 1:size(t)[2]\n        @layer begin\n        sethue(\"thistle1\")\n        if r >= 2 && c >= 2\n            if isodd(c)\n                setopacity(0.5)\n            else\n                setopacity(0.75)\n            end\n            box(t, r, c, :fill)\n        end\n        end\n        sethue(\"black\")\n        if tabledata[r, c] != \"-\"\n            text(string(tabledata[r, c]), t[r, c] - (t.colwidths[c]/2 - margin, 0))\n        end\n    end\nend\nfinish()\nnothing(Image: polygons etc)"
},

{
    "location": "polygons/#Luxor.ngon",
    "page": "Polygons and paths",
    "title": "Luxor.ngon",
    "category": "function",
    "text": "ngon(x, y, radius, sides=5, orientation=0, action=:nothing;\n    vertices=false, reversepath=false)\n\nFind the vertices of a regular n-sided polygon centered at x, y with circumradius radius.\n\nngon() draws the shapes: if you just want the raw points, use keyword argument vertices=true, which returns the array of points instead. Compare:\n\nngon(0, 0, 4, 4, 0, vertices=true) # returns the polygon\'s points:\n\n    4-element Array{Luxor.Point,1}:\n    Luxor.Point(2.4492935982947064e-16,4.0)\n    Luxor.Point(-4.0,4.898587196589413e-16)\n    Luxor.Point(-7.347880794884119e-16,-4.0)\n    Luxor.Point(4.0,-9.797174393178826e-16)\n\nwhereas\n\nngon(0, 0, 4, 4, 0, :close) # draws a polygon\n\n\n\n\n\nngon(centerpos, radius, sides=5, orientation=0, action=:nothing;\n    vertices=false,\n    reversepath=false)\n\nDraw a regular polygon centered at point centerpos:\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.ngonside",
    "page": "Polygons and paths",
    "title": "Luxor.ngonside",
    "category": "function",
    "text": "ngonside(centerpoint::Point, sidelength::Real, sides::Int=5, orientation=0,\n    action=:nothing; kwargs...)\n\nDraw a regular polygon centered at centerpoint with sides sides of length sidelength.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Regular-polygons-(\"ngons\")-1",
    "page": "Polygons and paths",
    "title": "Regular polygons (\"ngons\")",
    "category": "section",
    "text": "A polygon is an array of points. The points can be joined with straight lines.You can make regular polygons — from triangles, pentagons, hexagons, septagons, heptagons, octagons, nonagons, decagons, and on-and-on-agons — with ngon().(Image: n-gons)using Luxor, Colors\nDrawing(1200, 1400)\n\norigin()\ncols = diverging_palette(60, 120, 20) # hue 60 to hue 120\nbackground(cols[1])\nsetopacity(0.7)\nsetline(2)\n\n# circumradius of 500\nngon(0, 0, 500, 8, 0, :clip)\n\nfor y in -500:50:500\n    for x in -500:50:500\n        setcolor(cols[rand(1:20)])\n        ngon(x, y, rand(20:25), rand(3:12), 0, :fill)\n        setcolor(cols[rand(1:20)])\n        ngon(x, y, rand(10:20), rand(3:12), 0, :stroke)\n    end\nend\n\nfinish()\npreview()If you want to specify the side length rather than the circumradius, use ngonside().using Luxor # hide\nDrawing(500, 600, \"assets/figures/ngonside.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\n\nsetline(2) # hide\nfor i in 20:-1:3\n    sethue(i/20, 0.5, 0.7)\n    ngonside(O, 75, i, 0, :fill)\n    sethue(\"black\")\n    ngonside(O, 75, i, 0, :stroke)\nend\n\nfinish() # hide\nnothing # hide(Image: stars)ngon\nngonside"
},

{
    "location": "polygons/#Luxor.star",
    "page": "Polygons and paths",
    "title": "Luxor.star",
    "category": "function",
    "text": "star(xcenter, ycenter, radius, npoints=5, ratio=0.5, orientation=0, action=:nothing;\n    vertices = false,\n    reversepath=false)\n\nMake a star. ratio specifies the height of the smaller radius of the star relative to the larger.\n\nUse vertices=true to return the vertices of a star instead of drawing it.\n\n\n\n\n\nstar(center, radius, npoints=5, ratio=0.5, orientation=0, action=:nothing;\n    vertices = false, reversepath=false)\n\nDraw a star centered at a position:\n\n\n\n\n\n"
},

{
    "location": "polygons/#Stars-1",
    "page": "Polygons and paths",
    "title": "Stars",
    "category": "section",
    "text": "Use star() to make a star. You can draw it immediately, or use the points it can create.using Luxor # hide\nDrawing(500, 300, \"assets/figures/stars.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\ntiles = Tiler(400, 300, 4, 6, margin=5)\nfor (pos, n) in tiles\n    randomhue()\n    star(pos, tiles.tilewidth/3, rand(3:8), 0.5, 0, :fill)\nend\nfinish() # hide\nnothing # hide(Image: stars)The ratio determines the length of the inner radius compared with the outer.using Luxor # hide\nDrawing(500, 250, \"assets/figures/star-ratios.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"black\") # hide\nsetline(2) # hide\ntiles = Tiler(500, 250, 1, 6, margin=10)\nfor (pos, n) in tiles\n    star(pos, tiles.tilewidth/2, 5, rescale(n, 1, 6, 1, 0), 0, :stroke)\nend\nfinish() # hide\nnothing # hide(Image: stars)star"
},

{
    "location": "polygons/#Luxor.poly",
    "page": "Polygons and paths",
    "title": "Luxor.poly",
    "category": "function",
    "text": "Draw a polygon.\n\npoly(pointlist::AbstractArray{Point, 1}, action = :nothing;\n    close=false,\n    reversepath=false)\n\nA polygon is an Array of Points. By default poly() doesn\'t close or fill the polygon, to allow for clipping.\n\n\n\n\n\npoly(bbox::BoundingBox, :action; kwargs...)\n\nMake a polygon around the BoundingBox in bbox.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.prettypoly",
    "page": "Polygons and paths",
    "title": "Luxor.prettypoly",
    "category": "function",
    "text": "prettypoly(points::AbstractArray{Point, 1}, action=:nothing, vertexfunction = () -> circle(O, 2, :stroke);\n    close=false,\n    reversepath=false,\n    vertexlabels = (n, l) -> ()\n    )\n\nDraw the polygon defined by points, possibly closing and reversing it, using the current parameters, and then evaluate the vertexfunction function at every vertex of the polygon.\n\nThe default vertexfunction draws a 2 pt radius circle.\n\nTo mark each vertex of a polygon with a randomly colored filled circle:\n\np = star(O, 70, 7, 0.6, 0, vertices=true)\nprettypoly(p, :fill, () ->\n    begin\n        randomhue()\n        circle(O, 10, :fill)\n    end,\n    close=true)\n\nThe optional keyword argument vertexlabels lets you supply a function with two arguments that can access the current vertex number and the total number of vertices at each vertex. For example, you can label the vertices of a triangle \"1 of 3\", \"2 of 3\", and \"3 of 3\" using:\n\nprettypoly(triangle, :stroke,\n    vertexlabels = (n, l) -> (text(string(n, \" of \", l))))\n\nTODO Does it render paths with no points correctly ?!\n\n\n\n\n\nprettypoly(bbox::BoundingBox, :action; kwargs...)\n\nMake a decorated polygon around the BoundingBox in bbox.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.simplify",
    "page": "Polygons and paths",
    "title": "Luxor.simplify",
    "category": "function",
    "text": "Simplify a polygon:\n\nsimplify(pointlist::AbstractArray, detail=0.1)\n\ndetail is the smallest permitted distance between two points in pixels.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.isinside",
    "page": "Polygons and paths",
    "title": "Luxor.isinside",
    "category": "function",
    "text": "isinside(p, pol; allowonedge=false)\n\nIs a point p inside a polygon pol? Returns true if it does, or false.\n\nThis is an implementation of the Hormann-Agathos (2001) Point in Polygon algorithm.\n\nThe classification of points lying on the edges of the target polygon, or coincident with its vertices is not clearly defined, due to rounding errors or arithmetical inadequacy. By default these will generate errors, but you can suppress these by setting allowonedge to true.\n\n\n\n\n\nisinside(p::Point, bb:BoundingBox)\n\nReturns true if pt is inside bounding box bb.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.randompoint",
    "page": "Polygons and paths",
    "title": "Luxor.randompoint",
    "category": "function",
    "text": "randompoint(lowpt, highpt)\n\nReturn a random point somewhere inside the rectangle defined by the two points.\n\n\n\n\n\nrandompoint(lowx, lowy, highx, highy)\n\nReturn a random point somewhere inside a rectangle defined by the four values.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.randompointarray",
    "page": "Polygons and paths",
    "title": "Luxor.randompointarray",
    "category": "function",
    "text": "randompointarray(lowpt, highpt, n)\n\nReturn an array of n random points somewhere inside the rectangle defined by two points.\n\n\n\n\n\nrandompointarray(lowx, lowy, highx, highy, n)\n\nReturn an array of n random points somewhere inside the rectangle defined by the four coordinates.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.polysplit",
    "page": "Polygons and paths",
    "title": "Luxor.polysplit",
    "category": "function",
    "text": "polysplit(p, p1, p2)\n\nSplit a polygon into two where it intersects with a line. It returns two polygons:\n\n(poly1, poly2)\n\nThis doesn\'t always work, of course. For example, a polygon the shape of the letter \"E\" might end up being divided into more than two parts.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.polysortbydistance",
    "page": "Polygons and paths",
    "title": "Luxor.polysortbydistance",
    "category": "function",
    "text": "Sort a polygon by finding the nearest point to the starting point, then the nearest point to that, and so on.\n\npolysortbydistance(p, starting::Point)\n\nYou can end up with convex (self-intersecting) polygons, unfortunately.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.polysortbyangle",
    "page": "Polygons and paths",
    "title": "Luxor.polysortbyangle",
    "category": "function",
    "text": "Sort the points of a polygon into order. Points are sorted according to the angle they make with a specified point.\n\npolysortbyangle(pointlist::AbstractArray, refpoint=minimum(pointlist))\n\nThe refpoint can be chosen, but the minimum point is usually OK too:\n\npolysortbyangle(parray, polycentroid(parray))\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.polycentroid",
    "page": "Polygons and paths",
    "title": "Luxor.polycentroid",
    "category": "function",
    "text": "Find the centroid of simple polygon.\n\npolycentroid(pointlist)\n\nReturns a point. This only works for simple (non-intersecting) polygons.\n\nYou could test the point using isinside().\n\n\n\n\n\n"
},

{
    "location": "polygons/#Polygons-1",
    "page": "Polygons and paths",
    "title": "Polygons",
    "category": "section",
    "text": "Use poly() to draw lines connecting the points and/or just fill the area:using Luxor, Random # hide\nDrawing(600, 250, \"assets/figures/simplepoly.png\") # hide\nbackground(\"white\") # hide\nRandom.seed!(42) # hide\norigin() # hide\nsethue(\"orchid4\") # hide\ntiles = Tiler(600, 250, 1, 2, margin=20)\ntile1, tile2 = collect(tiles)\n\nrandompoints = [Point(rand(-100:100), rand(-100:100)) for i in 1:10]\n\ngsave()\ntranslate(tile1[1])\npoly(randompoints, :stroke)\ngrestore()\n\ngsave()\ntranslate(tile2[1])\npoly(randompoints, :fill)\ngrestore()\n\nfinish() # hide\nnothing # hide(Image: simple poly)polyA polygon can contain holes. The reversepath keyword changes the direction of the polygon. The following piece of code uses ngon() to make and draw two paths, the second forming a hole in the first, to make a hexagonal bolt shape:using Luxor # hide\nDrawing(400, 250, \"assets/figures/holes.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsetline(5)\nsethue(\"gold\")\nline(Point(-200, 0), Point(200, 0), :stroke)\nsethue(\"orchid4\")\nngon(0, 0, 60, 6, 0, :path)\nnewsubpath()\nngon(0, 0, 40, 6, 0, :path, reversepath=true)\nfillstroke()\nfinish() # hide\nnothing # hide(Image: holes)The prettypoly() function can place graphics at each vertex of a polygon. After the polygon action, the supplied vertexfunction function is evaluated at each vertex. For example, to mark each vertex of a polygon with a randomly-colored circle:using Luxor # hide\nDrawing(400, 250, \"assets/figures/prettypolybasic.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"steelblue4\") # hide\n\napoly = star(O, 70, 7, 0.6, 0, vertices=true)\nprettypoly(apoly, :fill, () ->\n        begin\n            randomhue()\n            circle(O, 10, :fill)\n        end,\n    close=true)\nfinish() # hide\nnothing # hide(Image: prettypoly)An optional keyword argument vertexlabels lets you pass a function that can number each vertex. The function can use two arguments, the current vertex number, and the total number of points in the polygon:using Luxor # hide\nDrawing(400, 250, \"assets/figures/prettypolyvertex.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"steelblue4\") # hide\n\napoly = star(O, 80, 5, 0.6, 0, vertices=true)\nprettypoly(apoly,\n    :stroke,\n    vertexlabels = (n, l) -> (text(string(n, \" of \", l), halign=:center)),\n    close=true)\nfinish() # hide\nnothing # hide(Image: prettypoly)prettypolyRecursive decoration is possible:using Luxor, Random # hide\nDrawing(400, 260, \"assets/figures/prettypolyrecursive.png\") # hide\nbackground(\"white\") # hide\nRandom.seed!(42) # hide\norigin() # hide\nsethue(\"magenta\") # hide\nsetopacity(0.5) # hide\n\ndecorate(pos, p, level) = begin\n    if level < 4\n        randomhue()\n        scale(0.25, 0.25)\n        prettypoly(p, :fill, () -> decorate(pos, p, level+1), close=true)\n    end\nend\n\napoly = star(O, 100, 7, 0.6, 0, vertices=true)\nprettypoly(apoly, :fill, () -> decorate(O, apoly, 1), close=true)\nfinish() # hide\nnothing # hide(Image: prettypoly)Polygons can be simplified using the Douglas-Peucker algorithm (non-recursive version), via simplify().using Luxor # hide\nDrawing(600, 500, \"assets/figures/simplify.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"black\") # hide\nsetline(1) # hide\nfontsize(20) # hide\ntranslate(0, -120) # hide\nsincurve = [Point(6x, 80sin(x)) for x in -5pi:pi/20:5pi]\nprettypoly(collect(sincurve), :stroke,\n    () -> begin\n            sethue(\"red\")\n            circle(O, 3, :fill)\n          end)\ntext(string(\"number of points: \", length(collect(sincurve))), 0, 100)\ntranslate(0, 200)\nsimplercurve = simplify(collect(sincurve), 0.5)\nprettypoly(simplercurve, :stroke,\n    () -> begin\n            sethue(\"red\")\n            circle(O, 3, :fill)\n          end)\ntext(string(\"number of points: \", length(simplercurve)), 0, 100)\nfinish() # hide\nnothing # hide(Image: simplify)simplifyThe isinside() function returns true if a point is inside a polygon.using Luxor # hide\nDrawing(500, 500, \"assets/figures/isinside.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\n\napolygon = star(O, 200, 8, 0.5, 0, vertices=true)\nfor pt in collect(first.(Table(30, 30, 15, 15)))\n    sethue(noise(pt.x/600, pt.y/600), noise(pt.x/300, pt.y/300), noise(pt.x/250, pt.y/250))\n    isinside(pt, apolygon, allowonedge=true) ? circle(pt, 8, :fill) : circle(pt, 3, :fill)\nend\n\nfinish() # hide\nnothing # hide(Image: isinside)isinsideYou can use randompoint() and randompointarray() to create a random Point or list of Points.using Luxor, Random # hide\nDrawing(400, 250, \"assets/figures/randompoints.png\") # hide\nbackground(\"white\") # hide\nRandom.seed!(42) # hide\norigin() # hide\n\npt1 = Point(-100, -100)\npt2 = Point(100, 100)\n\nsethue(\"gray80\")\nmap(pt -> circle(pt, 6, :fill), (pt1, pt2))\nbox(pt1, pt2, :stroke)\n\nsethue(\"red\")\ncircle(randompoint(pt1, pt2), 7, :fill)\n\nsethue(\"blue\")\nmap(pt -> circle(pt, 2, :fill), randompointarray(pt1, pt2, 100))\n\nfinish() # hide\nnothing # hide(Image: isinside)randompoint\nrandompointarrayThere are some experimental polygon functions. These don\'t work well for polygons that aren\'t simple or where the sides intersect each other, but they sometimes do a reasonable job. For example, here\'s polysplit():using Luxor, Random # hide\nDrawing(400, 150, \"assets/figures/polysplit.png\") # hide\norigin() # hide\nsetopacity(0.7) # hide\nRandom.seed!(42) # hide\nsethue(\"black\") # hide\ns = squircle(O, 60, 60, vertices=true)\npt1 = Point(0, -120)\npt2 = Point(0, 120)\nline(pt1, pt2, :stroke)\npoly1, poly2 = polysplit(s, pt1, pt2)\nrandomhue()\npoly(poly1, :fill)\nrandomhue()\npoly(poly2, :fill)\nfinish() # hide\nnothing # hide(Image: polysplit)polysplit\npolysortbydistance\npolysortbyangle\npolycentroid"
},

{
    "location": "polygons/#Luxor.polysmooth",
    "page": "Polygons and paths",
    "title": "Luxor.polysmooth",
    "category": "function",
    "text": "polysmooth(points, radius, action=:action; debug=false)\n\nMake a closed path from the points and round the corners by making them arcs with the given radius. Execute the action when finished.\n\nThe arcs are sometimes different sizes: if the given radius is bigger than the length of the shortest side, the arc can\'t be drawn at its full radius and is therefore drawn as large as possible (as large as the shortest side allows).\n\nThe debug option also draws the construction circles at each corner.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Smoothing-polygons-1",
    "page": "Polygons and paths",
    "title": "Smoothing polygons",
    "category": "section",
    "text": "Because polygons can have sharp corners, the experimental polysmooth() function attempts to insert arcs at the corners and draw the result.The original polygon is shown in red; the smoothed polygon is shown on top:using Luxor, Random # hide\nDrawing(600, 250, \"assets/figures/polysmooth.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsetopacity(0.5) # hide\nRandom.seed!(42) # hide\nsetline(0.7) # hide\ntiles = Tiler(600, 250, 1, 5, margin=10)\nfor (pos, n) in tiles\n    p = star(pos, tiles.tilewidth/2 - 2, 5, 0.3, 0, vertices=true)\n    setdash(\"dot\")\n    sethue(\"red\")\n    prettypoly(p, close=true, :stroke)\n    setdash(\"solid\")\n    sethue(\"black\")\n    polysmooth(p, n * 2, :fill)\nend\n\nfinish() # hide\nnothing # hide(Image: polysmooth)The final polygon shows that you can get unexpected results if you attempt to smooth corners by more than the possible amount. The debug=true option draws the circles if you want to find out what\'s going wrong, or if you want to explore the effect in more detail.using Luxor, Random # hide\nDrawing(600, 250, \"assets/figures/polysmooth-pathological.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsetopacity(0.75) # hide\nRandom.seed!(42) # hide\nsetline(1) # hide\np = star(O, 60, 5, 0.35, 0, vertices=true)\nsetdash(\"dot\")\nsethue(\"red\")\nprettypoly(p, close=true, :stroke)\nsetdash(\"solid\")\nsethue(\"black\")\npolysmooth(p, 40, :fill, debug=true)\nfinish() # hide\nnothing # hide(Image: polysmooth)polysmooth"
},

{
    "location": "polygons/#Luxor.offsetpoly",
    "page": "Polygons and paths",
    "title": "Luxor.offsetpoly",
    "category": "function",
    "text": "offsetpoly(path::AbstractArray{Point, 1}, d)\n\nReturn a polygon that is offset from a polygon by d units.\n\nThe incoming set of points path is treated as a polygon, and another set of points is created, which form a polygon lying d units away from the source poly.\n\nPolygon offsetting is a topic on which people have written PhD theses and published academic papers, so this short brain-dead routine will give good results for simple polygons up to a point (!). There are a number of issues to be aware of:\n\nvery short lines tend to make the algorithm \'flip\' and produce larger lines\nsmall polygons that are counterclockwise and larger offsets may make the new polygon appear the wrong side of the original\nvery sharp vertices will produce even sharper offsets, as the calculated intersection point veers off to infinity\nduplicated adjacent points might cause the routine to scratch its head and wonder how to draw a line parallel to them\n\n\n\n\n\n"
},

{
    "location": "polygons/#Offsetting-polygons-1",
    "page": "Polygons and paths",
    "title": "Offsetting polygons",
    "category": "section",
    "text": "The experimental offsetpoly() function constructs an outline polygon outside or inside an existing polygon. In the following example, the dotted red polygon is the original, the black polygons have positive offsets and surround the original, the cyan polygons have negative offsets and run inside the original. Use poly() to draw the result returned by offsetpoly().using Luxor, Random # hide\nDrawing(600, 250, \"assets/figures/polyoffset-simple.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nRandom.seed!(42) # hide\nsetline(1.5) # hide\n\np = star(O, 45, 5, 0.5, 0, vertices=true)\nsethue(\"red\")\nsetdash(\"dot\")\npoly(p, :stroke, close=true)\nsetdash(\"solid\")\nsethue(\"black\")\n\npoly(offsetpoly(p, 20), :stroke, close=true)\npoly(offsetpoly(p, 25), :stroke, close=true)\npoly(offsetpoly(p, 30), :stroke, close=true)\npoly(offsetpoly(p, 35), :stroke, close=true)\n\nsethue(\"darkcyan\")\n\npoly(offsetpoly(p, -10), :stroke, close=true)\npoly(offsetpoly(p, -15), :stroke, close=true)\npoly(offsetpoly(p, -20), :stroke, close=true)\nfinish() # hide\nnothing # hide(Image: offset poly)The function is intended for simple cases, and it can go wrong if pushed too far. Sometimes the offset distances can be larger than the polygon segments, and things will start to go wrong. In this example, the offset goes so far negative that the polygon overshoots the origin, becomes inverted and starts getting larger again.(Image: offset poly problem)offsetpoly"
},

{
    "location": "polygons/#Luxor.polyfit",
    "page": "Polygons and paths",
    "title": "Luxor.polyfit",
    "category": "function",
    "text": "polyfit(plist::AbstractArray, npoints=30)\n\nBuild a polygon that constructs a B-spine approximation to it. The resulting list of points makes a smooth path that runs between the first and last points.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Fitting-splines-1",
    "page": "Polygons and paths",
    "title": "Fitting splines",
    "category": "section",
    "text": "The experimental polyfit() function constructs a B-spline that follows the points approximately.using Luxor, Random # hide\nDrawing(600, 250, \"assets/figures/polyfit.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nRandom.seed!(42) # hide\n\npts = [Point(x, rand(-100:100)) for x in -280:30:280]\nsetopacity(0.7)\nsethue(\"red\")\nprettypoly(pts, :none, () -> circle(O, 5, :fill))\nsethue(\"darkmagenta\")\npoly(polyfit(pts, 200), :stroke)\n\nfinish() # hide\nnothing # hide(Image: offset poly)polyfit"
},

{
    "location": "polygons/#Luxor.pathtopoly",
    "page": "Polygons and paths",
    "title": "Luxor.pathtopoly",
    "category": "function",
    "text": "pathtopoly()\n\nConvert the current path to an array of polygons.\n\nReturns an array of polygons.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.getpath",
    "page": "Polygons and paths",
    "title": "Luxor.getpath",
    "category": "function",
    "text": "getpath()\n\nGet the current path and return a CairoPath object, which is an array of element_type and points objects. With the results you can step through and examine each entry:\n\no = getpath()\nfor e in o\n      if e.element_type == Cairo.CAIRO_PATH_MOVE_TO\n          (x, y) = e.points\n          move(x, y)\n      elseif e.element_type == Cairo.CAIRO_PATH_LINE_TO\n          (x, y) = e.points\n          # straight lines\n          line(x, y)\n          strokepath()\n          circle(x, y, 1, :stroke)\n      elseif e.element_type == Cairo.CAIRO_PATH_CURVE_TO\n          (x1, y1, x2, y2, x3, y3) = e.points\n          # Bezier control lines\n          circle(x1, y1, 1, :stroke)\n          circle(x2, y2, 1, :stroke)\n          circle(x3, y3, 1, :stroke)\n          move(x, y)\n          curve(x1, y1, x2, y2, x3, y3)\n          strokepath()\n          (x, y) = (x3, y3) # update current point\n      elseif e.element_type == Cairo.CAIRO_PATH_CLOSE_PATH\n          closepath()\n      else\n          error(\"unknown CairoPathEntry \" * repr(e.element_type))\n          error(\"unknown CairoPathEntry \" * repr(e.points))\n      end\n  end\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.getpathflat",
    "page": "Polygons and paths",
    "title": "Luxor.getpathflat",
    "category": "function",
    "text": "getpathflat()\n\nGet the current path, like getpath() but flattened so that there are no Bèzier curves.\n\nReturns a CairoPath which is an array of element_type and points objects.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Converting-paths-to-polygons-1",
    "page": "Polygons and paths",
    "title": "Converting paths to polygons",
    "category": "section",
    "text": "You can convert the current path to an array of polygons, using pathtopoly().In the next example, the path consists of a number of paths, some of which are subpaths, which form the holes.using Luxor # hide\nDrawing(800, 300, \"assets/figures/path-to-poly.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nfontsize(60) # hide\ntranslate(-300, -50) # hide\ntextpath(\"get polygons from paths\")\nplist = pathtopoly()\nsetline(0.5) # hide\nfor (n, pgon) in enumerate(plist)\n    randomhue()\n    prettypoly(pgon, :stroke, close=true)\n    gsave()\n    translate(0, 100)\n    poly(polysortbyangle(pgon, polycentroid(pgon)), :stroke, close=true)\n    grestore()\nend\nfinish() # hide\nnothing # hide(Image: path to polygon)The pathtopoly() function calls getpathflat() to convert the current path to an array of polygons, with each curved section flattened to line segments.The getpath() function gets the current path as an array of elements, lines, and unflattened curves.pathtopoly\ngetpath\ngetpathflat"
},

{
    "location": "polygons/#Polygons-to-Bézier-paths-and-back-again-1",
    "page": "Polygons and paths",
    "title": "Polygons to Bézier paths and back again",
    "category": "section",
    "text": "Use the makebezierpath() and drawbezierpath() functions to make and draw Bézier paths, and pathtobezierpaths() to convert the current path to an array of Bézier paths.  A BezierPath type contains a sequence of BezierPathSegments; each curve segment is defined by four points: two end points and their control points.    (Point(-129.904, 75.0),        # start point\n     Point(-162.38, 18.75),        # ^ control point\n     Point(-64.9519, -150.0),      # v control point\n     Point(-2.75546e-14, -150.0)), # end point\n    (Point(-2.75546e-14, -150.0),\n     Point(64.9519, -150.0),\n     Point(162.38, 18.75),\n     Point(129.904, 75.0)),\n    (Point(129.904, 75.0),\n     Point(97.4279, 131.25),\n     Point(-97.4279, 131.25),\n     Point(-129.904, 75.0)\n     ),\n     ...Bézier paths are different from ordinary paths in that they don\'t usually contain straight line segments. However, by setting the two control points to be the same as their matching start/end points, you create straight line sections.makebezierpath() takes the points in a polygon and converts each line segment into one Bézier curve. drawbezierpath() draws the resulting sequence.using Luxor # hide\nDrawing(600, 320, \"assets/figures/abezierpath.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsetline(1.5) # hide\nsetgray(0.5) # hide\npts = ngon(O, 150, 3, pi/6, vertices=true)\nbezpath = makebezierpath(pts)\npoly(pts, :stroke)\nfor (p1, c1, c2, p2) in bezpath[1:end-1]\n    circle.([p1, p2], 4, :stroke)\n    circle.([c1, c2], 2, :fill)\n    line(p1, c1, :stroke)\n    line(p2, c2, :stroke)\nend\nsethue(\"black\")\nsetline(3)\ndrawbezierpath(bezpath, :stroke, close=false)\nfinish() # hide\nnothing # hide(Image: path to polygon)using Luxor, Random # hide\nDrawing(600, 320, \"assets/figures/bezierpaths.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nRandom.seed!(3) # hide\ntiles = Tiler(600, 300, 1, 4, margin=20)\nfor (pos, n) in tiles\n    @layer begin\n        translate(pos)\n        pts = polysortbyangle(\n                randompointarray(\n                    Point(-tiles.tilewidth/2, -tiles.tilewidth/2),\n                    Point(tiles.tilewidth/2, tiles.tilewidth/2),\n                    4))\n        setopacity(0.7)\n        sethue(\"black\")\n        prettypoly(pts, :stroke, close=true)\n        randomhue()\n        drawbezierpath(makebezierpath(pts), :fill)\n    end\nend\nfinish() # hide\nnothing # hide(Image: path to polygon)You can convert a Bézier path to a polygon (an array of points), using the bezierpathtopoly() function. This chops up the curves into a series of straight line segments. An optional steps keyword lets you specify how many line segments are used to approximate each Bézier segment.In this example, the original star is drawn in a dotted gray line, then converted to a Bézier path (drawn in orange), then the Bézier path is converted (with low resolution) to a polygon but offset by 20 units before being drawn (in blue).using Luxor, Random # hide\nDrawing(600, 600, \"assets/figures/bezierpathtopoly.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nRandom.seed!(3) # hide\n\npgon = star(O, 250, 5, 0.6, 0, vertices=true)\n\n@layer begin\n setgrey(0.5)\n setdash(\"dot\")\n poly(pgon, :stroke, close=true)\n setline(5)\nend\n\nsetline(4)\n\nsethue(\"orangered\")\n\nnp = makebezierpath(pgon)    \ndrawbezierpath(np, :stroke)\n\nsethue(\"steelblue\")\np = bezierpathtopoly(np, steps=3)    \n\nq1 = offsetpoly(p, 20)\nprettypoly(q1, :stroke, close=true)\n\nfinish() # hide\nnothing # hide(Image: path to polygon)You can convert the current path to an array of BezierPaths using the pathtobezierpaths() function.In the next example, the letter \"a\" is placed at the current position (set by move()) and then converted to an array of Bézier paths. Each Bézier path is drawn first of all in gray, then the control points of segment are drawn (in orange) showing how they affect the curvature.using Luxor # hide\nDrawing(600, 400, \"assets/figures/pathtobezierpaths.png\") # hide\nbackground(\"ivory\") # hide\norigin() # hide\nst = \"a\"\nthefontsize = 500\nfontsize(thefontsize)\nsethue(\"red\")\ntex = textextents(st)\nmove(-tex[3]/2, tex[4]/2)\ntextpath(st)\nnbps = pathtobezierpaths()\nsetline(1.5)\nfor nbp in nbps\n    sethue(\"grey80\")\n    drawbezierpath(nbp, :stroke)\n    for p in nbp\n        sethue(\"darkorange\")\n        circle(p[2], 2.0, :fill)\n        circle(p[3], 2.0, :fill)\n        line(p[2], p[1], :stroke)\n        line(p[3], p[4], :stroke)\n        if p[1] != p[4]\n            sethue(\"black\")\n            circle(p[1], 2.0, :fill)\n            circle(p[4], 2.0, :fill)\n        end\n    end\nend\nfinish() # hide\nnothing # hide(Image: path to polygon)"
},

{
    "location": "polygons/#Luxor.bezier",
    "page": "Polygons and paths",
    "title": "Luxor.bezier",
    "category": "function",
    "text": "bezier(t, A::Point, A1::Point, B1::Point, B::Point)\n\nReturn the result of evaluating the Bezier cubic curve function, t going from 0 to 1, starting at A, finishing at B, control points A1 (controlling A), and B1 (controlling B).\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.bezier′",
    "page": "Polygons and paths",
    "title": "Luxor.bezier′",
    "category": "function",
    "text": "bezier′(t, A::Point, A1::Point, B1::Point, B::Point)\n\nReturn the first derivative of the Bezier function.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.bezier′′",
    "page": "Polygons and paths",
    "title": "Luxor.bezier′′",
    "category": "function",
    "text": "bezier′(t, A::Point, A1::Point, B1::Point, B::Point)\n\nReturn the second derivative of Bezier function.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.beziercurvature",
    "page": "Polygons and paths",
    "title": "Luxor.beziercurvature",
    "category": "function",
    "text": "beziercurvature(t, A::Point, A1::Point, B1::Point, B::Point)\n\nReturn the curvature of the Bezier curve at t ([0-1]), given start and end points A and B, and control points A1 and B1. The value (kappa) will typically be a value between -0.001 and 0.001 for points with coordinates in the 100-500 range.\n\nκ(t) is the curvature of the curve at point t, which for a parametric planar curve is:\n\nbeginequation\nkappa = fracmid dotxddoty-dotyddotxmid\n    (dotx^2 + doty^2)^frac32\nndequation\n\nThe radius of curvature, or the radius of an osculating circle at a point, is 1/κ(t). Values of 1/κ will typically be in the range -1000 to 1000 for points with coordinates in the 100-500 range.\n\nTODO Fix overshoot...\n\n...The value of kappa can sometimes collapse near 0, returning NaN (and Inf for radius of curvature).\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.bezierfrompoints",
    "page": "Polygons and paths",
    "title": "Luxor.bezierfrompoints",
    "category": "function",
    "text": "bezierfrompoints(startpoint::Point, pointonline1::Point,\n    pointonline2::Point, endpoint::Point)\n\nGiven four points, return the Bezier curve that passes through all four points, starting at startpoint and ending at endpoint. The two middle points of the returned BezierPathSegment are the two control points that make the curve pass through the two middle points supplied.\n\n\n\n\n\nbezierfrompoints(ptslist::Array{Point, 1})\n\nGiven four points, return the Bezier curve that passes through all four points.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.bezierpathtopoly",
    "page": "Polygons and paths",
    "title": "Luxor.bezierpathtopoly",
    "category": "function",
    "text": "bezierpathtopoly(bezierpath::BezierPath; steps=10)\n\nConvert a Bezier path (an array of Bezier segments, where each segment is a tuple of four points: anchor1, control1, control2, anchor2) to a polygon.\n\nTo make a Bezier path, use makebezierpath() on a polygon.\n\nThe steps optional keyword determines how many line sections are used for each path.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.bezierstroke",
    "page": "Polygons and paths",
    "title": "Luxor.bezierstroke",
    "category": "function",
    "text": "bezierstroke(point1, point2, width=0.0)\n\nReturn a BezierPath, a stroked version of a straight line between two points.\n\nIt wil have 2 or 6 Bezier path segments that define a brush or pen shape. If width is 0, the brush shape starts and ends at a point. Otherwise the brush shape starts and ends with the thick end.\n\nTo draw it, use eg drawbezierpath(..., :fill).\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.beziertopoly",
    "page": "Polygons and paths",
    "title": "Luxor.beziertopoly",
    "category": "function",
    "text": "beziertopoly(bpseg::BezierPathSegment; steps=10)\n\nConvert a Bezier segment to a polygon (an array of points).\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.drawbezierpath",
    "page": "Polygons and paths",
    "title": "Luxor.drawbezierpath",
    "category": "function",
    "text": "drawbezierpath(bezierpath::BezierPath, action=:none;\n    close=true)\n\nDraw the Bézier path, and apply the action, such as :none, :stroke, :fill, etc. By default the path is closed.\n\n\n\n\n\ndrawbezierpath(bps::BezierPathSegment, action=:none;\n    close=false)\n\nDraw the Bézier path segment, and apply the action, such as :none, :stroke, :fill, etc. By default the path is open.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.makebezierpath",
    "page": "Polygons and paths",
    "title": "Luxor.makebezierpath",
    "category": "function",
    "text": "makebezierpath(pgon::AbstractArray{Point, 1}; smoothing=1)\n\nReturn a Bézier path (a BezierPath) that represents a polygon (an array of points). The Bézier path is an array of segments (tuples of 4 points); each segment contains the four points that make up a section of the entire Bézier path. smoothing determines how closely the curve follows the polygon. A value of 0 returns a straight-sided path; as values move above 1 the paths deviate further from the original polygon\'s edges.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.pathtobezierpaths",
    "page": "Polygons and paths",
    "title": "Luxor.pathtobezierpaths",
    "category": "function",
    "text": "pathtobezierpaths(\n    ; flat=true)\n\nConvert the current path (which may consist of one or more paths) to an array of Bezier paths. Each Bezier path is, in turn, an array of path segments. Each path segment is a tuple of four points. A straight line is converted to a Bezier segment in which the control points are set to be the same as the end points.\n\nIf flat is true, use getpathflat() rather than getpath().\n\nExample\n\nThis code draws the Bezier segments and shows the control points as \"handles\", like a vector-editing program might.\n\n@svg begin\n    fontface(\"MyanmarMN-Bold\")\n    st = \"goo\"\n    thefontsize = 100\n    fontsize(thefontsize)\n    sethue(\"red\")\n    fontsize(thefontsize)\n    textpath(st)\n    nbps = pathtobezierpaths()\n    for nbp in nbps\n        setline(.15)\n        sethue(\"grey50\")\n        drawbezierpath(nbp, :stroke)\n        for p in nbp\n            sethue(\"red\")\n            circle(p[2], 0.16, :fill)\n            circle(p[3], 0.16, :fill)\n            line(p[2], p[1], :stroke)\n            line(p[3], p[4], :stroke)\n            if p[1] != p[4]\n                sethue(\"black\")\n                circle(p[1], 0.26, :fill)\n                circle(p[4], 0.26, :fill)\n            end\n        end\n    end\nend\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.setbezierhandles",
    "page": "Polygons and paths",
    "title": "Luxor.setbezierhandles",
    "category": "function",
    "text": "setbezierhandles(bps::BezierPathSegment;\n        angles  = [0.05, -0.1],\n        handles = [0.3, 0.3])\n\nReturn a new Bezier path segment with new locations for the Bezier control points in the Bezier path segment bps.\n\nangles are the two angles that the \"handles\" make with the line direciton.\n\nhandles are the lengths of the \"handles\". 0.3 is a typical value.\n\n\n\n\n\nsetbezierhandles(bezpath::BezierPath;\n        angles=[0 .05, -0.1],\n        handles=[0.3, 0.3])\n\nReturn a new Bezierpath with new locations for the Bezier control points in every Bezier path segment of the BezierPath in bezpath.\n\nangles are the two angles that the \"handles\" make with the line direciton.\n\nhandles are the lengths of the \"handles\". 0.3 is a typical value.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.shiftbezierhandles",
    "page": "Polygons and paths",
    "title": "Luxor.shiftbezierhandles",
    "category": "function",
    "text": "shiftbezierhandles(bps::BezierPathSegment;\n    angles=[0.1, -0.1], handles=[1.1, 1.1])\n\nReturn a new BezierPathSegment that modifies the Bezier path in bps by moving the control handles. The values in angles increase the angle of the handles; the values in handles modifies the lengths: 1 preserves the length, 0.5 halves the length of the  handles, 2 doubles them.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.findbeziercontrolpoints",
    "page": "Polygons and paths",
    "title": "Luxor.findbeziercontrolpoints",
    "category": "function",
    "text": "findbeziercontrolpoints(previouspt::Point,\n    pt1::Point,\n    pt2::Point,\n    nextpt::Point;\n    smooth_value=0.5)\n\nFind the Bézier control points for the line between pt1 and pt2, where the point before pt1 is previouspt and the next point after pt2 is nextpt.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.brush",
    "page": "Polygons and paths",
    "title": "Luxor.brush",
    "category": "function",
    "text": "brush(pt1, pt2, width=10;\n    strokes=10,\n    minwidth=0.01,\n    maxwidth=0.03,\n    twist = -1,\n    lowhandle  = 0.3,\n    highhandle = 0.7,\n    randomopacity = true,\n    tidystart = false,\n    action = :fill)\n\nDraw a composite brush stroke made up of some randomized individual filled Bezier paths.\n\nnote: Note\nThere is a lot of randomness in this function. Results are unpredictable.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Brush-strokes-1",
    "page": "Polygons and paths",
    "title": "Brush strokes",
    "category": "section",
    "text": "using Luxor, Random # hide\nDrawing(600, 250, \"assets/figures/brush.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nRandom.seed!(42) # hide\nsethue(\"black\") # hide\nbrush(Point(-250, 0), Point(250, 0), 20,\n    strokes=15,\n    tidystart=true,\n    twist=-5,\n    lowhandle=-0.5,\n    highhandle=0.5)\nfinish() # hide\nnothing # hide(Image: brush)For more information (and more than you probably wanted to know) about Luxor\'s Bézier paths, visit https://cormullion.github.io/blog/2018/06/21/bezier.html.bezier\nbezier′\nbezier′′\nbeziercurvature\nbezierfrompoints\nbezierpathtopoly\nbezierstroke\nbeziertopoly\ndrawbezierpath\nmakebezierpath\npathtobezierpaths\nsetbezierhandles\nshiftbezierhandles\nLuxor.findbeziercontrolpoints\nbrush"
},

{
    "location": "polygons/#Polygon-information-1",
    "page": "Polygons and paths",
    "title": "Polygon information",
    "category": "section",
    "text": "polyperimeter calculates the length of a polygon\'s perimeter.using Luxor, Random # hide\nDrawing(600, 250, \"assets/figures/polyperimeter.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nRandom.seed!(42) # hide\nsetline(1.5) # hide\nsethue(\"black\") # hide\nfontsize(20) # hide\np = box(O, 50, 50, vertices=true)\npoly(p, :stroke)\ntext(string(round(polyperimeter(p, closed=false))), O.x, O.y + 60)\n\ntranslate(200, 0)\n\npoly(p, :stroke, close=true)\ntext(string(round(polyperimeter(p, closed=true))), O.x, O.y + 60)\n\nfinish() # hide\nnothing # hide(Image: polyperimeter)"
},

{
    "location": "polygons/#Luxor.polysample",
    "page": "Polygons and paths",
    "title": "Luxor.polysample",
    "category": "function",
    "text": "polysample(p::AbstractArray{Point, 1}, npoints::Int64;\n        closed=true)\n\nSample the polygon p, returning a polygon with npoints to represent it. The first sampled point is:\n\n 1/`npoints` * `perimeter of p`\n\naway from the original first point of p.\n\nIf npoints is the same as length(p) the returned polygon is the same as the original, but the first point finishes up at the end (so new=circshift(old, 1)).\n\nIf closed is true, the entire polygon (including the edge joining the last point to the first point) is sampled.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Polygon-resampling-1",
    "page": "Polygons and paths",
    "title": "Polygon resampling",
    "category": "section",
    "text": "Luxor functions can return the first part or last part of a polygon. Or you can ask for a resampling of a polygon, choosing either to increase the number of points (which places new points to the \"lines\" joining the vertices) or decrease them (which changes the shape of the polygon).polyportion() and polyremainder() return part of a polygon depending on the fraction you supply. For example, polyportion(p, 0.5) returns the first half of polygon p, polyremainder(p, .75) returns the last quarter of it.using Luxor, Random # hide\nDrawing(600, 250, \"assets/figures/polyportion.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nRandom.seed!(42) # hide\nsetline(1.5) # hide\nsethue(\"black\") # hide\nfontsize(20) # hide\n\np = ngon(O, 100, 7, 0, vertices=true)\npoly(p, :stroke, close=true)\nsetopacity(0.75)\n\nsetline(20)\nsethue(\"red\")\npoly(polyportion(p, 0.25), :stroke)\n\nsetline(10)\nsethue(\"green\")\npoly(polyportion(p, 0.5), :stroke)\n\nsetline(5)\nsethue(\"blue\")\npoly(polyportion(p, 0.75), :stroke)\n\nsetline(1)\ncircle(polyremainder(p, 0.75)[1], 5, :stroke) # first point\n\nfinish() # hide\nnothing # hide(Image: polyportion)To resample a polygon, use polysample(). In this example, the same four-sided polygon is sampled at multiples of 4, with different circle radii at each multiple. This adds more points to the original polygon.using Luxor # hide\nDrawing(600, 250, \"assets/figures/polysample.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsetline(1) # hide\nsethue(\"black\") # hide\n\npts = ngon(O, 100, 4, vertices=true)\nfor (n, npoints) in enumerate(reverse([4, 8, 16, 32, 48]))\n    prettypoly(polysample(pts, npoints),\n        :stroke, close=true,\n        () -> begin\n                circle(O, 2n, :stroke)\n              end)\nend    \n\nfinish() # hide\nnothing # hide(Image: polysampling)There is a closed option, which determines whether or not the final edge (the one that would join the final vertex to the first), is included in the sampling. In the following example, the original polygon is first sampled as a closed polygon, then as a non-closed one.using Luxor # hide\nDrawing(600, 250, \"assets/figures/polysample2.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsetline(1) # hide\nsethue(\"black\") # hide\nfontsize(8) # hide\n\ntranslate(0, -50) # hide\nsetline(1) # hide\nsethue(\"black\") # hide\n\nnumbervertices(l, n) = label(string(l), :N, O)\ndrawvertices() = ngon(O, 3, 4, 0, :fill)\n\npts = [Point(30x, 20sin(x)) for x in -2pi:pi/6:2pi]\n\nprettypoly(pts, \"stroke\", drawvertices, vertexlabels = numbervertices)\n\ntranslate(0, 50)\n\nnpoints = 40\n\nsethue(\"cornflowerblue\")\nprettypoly(polysample(pts, npoints, closed=true), :stroke, drawvertices,\n    vertexlabels = numbervertices)\n\ntranslate(0, 50)\n\nsethue(\"magenta\")\nprettypoly(polysample(pts, npoints, closed=false), :stroke, drawvertices,\n    vertexlabels = numbervertices)\n\n\nfinish() # hide\nnothing # hide(Image: polysampling 2)polysample"
},

{
    "location": "polygons/#Polygon-side-lengths-1",
    "page": "Polygons and paths",
    "title": "Polygon side lengths",
    "category": "section",
    "text": "polydistances returns an array of the accumulated side lengths of a polygon.julia> p = ngon(O, 100, 7, 0, vertices=true);\njulia> polydistances(p)\n8-element Array{Real,1}:\n   0.0000\n  86.7767\n 173.553\n 260.33\n 347.107\n 433.884\n 520.66\n 607.437It\'s used by polyportion() and polyremainder(), and you can pre-calculate and pass them to these functions via keyword arguments for performance. By default the result includes the final closing segment (closed=true).These functions also make use of the nearestindex(), which returns a tuple of: the index of the nearest value in an array of distances to a given value; and the excess value.In this example, we want to find a point halfway round the perimeter of a triangle. Use nearestindex() to find the index of the nearest vertex (nidx, 2), and the surplus length, (over, 100).using Luxor # hide\nDrawing(650, 250, \"assets/figures/nearestindex.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\n\nsethue(\"black\") # hide\nsetline(0.5) # hide\n\np = ngonside(O, 200, 3, vertices=true)\nprettypoly(p, :stroke, close=true, vertexlabels = (n, l) -> label(string(n), :NW, offset=10))\n\n# distances array\nda = polydistances(p)\n\nnidx, over = nearestindex(da, polyperimeter(p)/2)\n\nsethue(\"red\")\ncircle(p[nidx], 5, :stroke)\n\narrow(p[nidx],\n      between(p[nidx], p[nidx+1], over/distance(p[nidx], p[nidx+1])),\n      linewidth=2)\n\nfinish() # hide\nnothing # hide(Image: nearestindex)Of course, it\'s much easier to do polyportion(p, 0.5)."
},

{
    "location": "polygons/#Luxor.polyperimeter",
    "page": "Polygons and paths",
    "title": "Luxor.polyperimeter",
    "category": "function",
    "text": "polyperimeter(p::AbstractArray{Point, 1}; closed=true)\n\nFind the total length of the sides of polygon p.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.polyportion",
    "page": "Polygons and paths",
    "title": "Luxor.polyportion",
    "category": "function",
    "text": "polyportion(p::AbstractArray{Point, 1}, portion=0.5; closed=true, pdist=[])\n\nReturn a portion of a polygon, starting at a value between 0.0 (the beginning) and 1.0 (the end). 0.5 returns the first half of the polygon, 0.25 the first quarter, 0.75 the first three quarters, and so on.\n\nIf you already have a list of the distances between each point in the polygon (the \"polydistances\"), you can pass them in pdist, otherwise they\'ll be calculated afresh, using polydistances(p, closed=closed).\n\nUse the complementary polyremainder() function to return the other part.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.polyremainder",
    "page": "Polygons and paths",
    "title": "Luxor.polyremainder",
    "category": "function",
    "text": "polyremainder(p::AbstractArray{Point, 1}, portion=0.5; closed=true, pdist=[])\n\nReturn the rest of a polygon, starting at a value between 0.0 (the beginning) and 1.0 (the end). 0.5 returns the last half of the polygon, 0.25 the last three quarters, 0.75 the last quarter, and so on.\n\nIf you already have a list of the distances between each point in the polygon (the \"polydistances\"), you can pass them in pdist, otherwise they\'ll be calculated afresh, using polydistances(p, closed=closed).\n\nUse the complementary polyportion() function to return the other part.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.polydistances",
    "page": "Polygons and paths",
    "title": "Luxor.polydistances",
    "category": "function",
    "text": "polydistances(p::AbstractArray{Point, 1}; closed=true)\n\nReturn an array of the cumulative lengths of a polygon.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.nearestindex",
    "page": "Polygons and paths",
    "title": "Luxor.nearestindex",
    "category": "function",
    "text": "nearestindex(polydistancearray, value)\n\nReturn a tuple of the index of the largest value in polydistancearray less than value, and the difference value. Array is assumed to be sorted.\n\n(Designed for use with polydistances()).\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.polyarea",
    "page": "Polygons and paths",
    "title": "Luxor.polyarea",
    "category": "function",
    "text": "polyarea(p::AbstractArray)\n\nFind the area of a simple polygon. It works only for polygons that don\'t self-intersect.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Area-of-polygon-1",
    "page": "Polygons and paths",
    "title": "Area of polygon",
    "category": "section",
    "text": "Use polyarea() to find the area of a polygon. Of course, this only works for simple polygons; polygons that intersect themselves or have holes are not correctly processed.This code draws some regular polygons and calculates their area, perimeter, and shows how near the ratio of perimeter over radius approaches 2π.using Luxor # hide\nDrawing(650, 500, \"assets/figures/polyarea.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nfontsize(13) # hide\nfontface(\"Georgia\")\nsethue(\"black\")\nsetline(0.25)\nouterframe = Table([500], [400, 200])\ntotal = 30\nproperties = Table(fill(15, total), [20, 85, 85], outerframe[1, 2])\nradius = 55\nsethue(\"grey20\")\nfor i in 3:total\n    global radius\n    text(string(i), properties[i, 1], halign=:right)\n    p = ngon(outerframe[1], radius, i, 0, vertices=true)\n    prettypoly(p, :stroke, close=true, () -> (sethue(\"red\"); circle(O, 2, :fill)))\n    pa = polyarea(p)\n    pp = polyperimeter(p)\n    ppoverradius = pp/radius\n    text(string(Int(round(pa, digits=0))), properties[i, 2], halign=:left)\n    text(string(round(ppoverradius, digits=6)), properties[i, 3], halign=:left)\n    radius += 5\nend\n\nfontsize(10)\n[text([\"Sides\", \"Area\", \"Perimeter/Radius\"][n], pt, halign=:center)\n    for (pt, n) in Table([20], [20, 85, 85], outerframe[2] - (0, 220))]\n\nfinish() # hide\nnothing # hide(Image: poly area)polyperimeter\npolyportion\npolyremainder\npolydistances\nnearestindex\npolyarea"
},

{
    "location": "polygons/#Luxor.intersectlinepoly",
    "page": "Polygons and paths",
    "title": "Luxor.intersectlinepoly",
    "category": "function",
    "text": "intersectlinepoly(pt1::Point, pt2::Point, C)\n\nReturn an array of the points where a line between pt1 and pt2 crosses polygon C.\n\n\n\n\n\n"
},

{
    "location": "polygons/#Luxor.polyintersections",
    "page": "Polygons and paths",
    "title": "Luxor.polyintersections",
    "category": "function",
    "text": "polyintersections(S::AbstractArray{Point, 1}, C::AbstractArray{Point, 1})\n\nReturn an array of the points in polygon S plus the points where polygon S crosses polygon C. Calls intersectlinepoly().\n\n\n\n\n\n"
},

{
    "location": "polygons/#Polygon-intersections-(WIP)-1",
    "page": "Polygons and paths",
    "title": "Polygon intersections (WIP)",
    "category": "section",
    "text": "intersectlinepoly(pt1, pt2, polygon) returns an array containing the points where a line from pt1 to pt2 crosses the perimeter of the polygon.using Luxor, Random # hide\nDrawing(600, 550, \"assets/figures/linepolyintersections.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nRandom.seed!(5) # hide\nsetline(0.3)\nsethue(\"thistle\")\nc = star(O, 120, 7, 0.2, vertices=true)\npoly(c, :fillstroke, close=true)\nfor n in 1:15\n    pt1 = Point(rand(-250:250, 2)...)\n    pt2 = Point(rand(-250:250, 2)...)\n    ips = intersectlinepoly(pt1, pt2, c)\n    if !isempty(ips)\n            sethue(\"grey20\")\n            line(pt1, pt2, :stroke)\n            randomhue()\n            circle.(ips, 2, :fill)\n    else\n        sethue(\"grey80\")\n        line(pt1, pt2, :stroke)\n    end\nend\nfinish() # hide\nnothing # hide(Image: line/polygon intersections)polyintersections calculates the intersection points of two polygons.using Luxor # hide\nDrawing(600, 550, \"assets/figures/polyintersections.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"grey60\") # hide\nsetopacity(0.8) # hide\npentagon = ngon(O, 250, 5, vertices=true)\nsquare = box(O + (80, 20), 280, 280, vertices=true)\n\npoly(pentagon, :stroke, close=true)\npoly(square, :stroke, close=true)\n\nsethue(\"orange\")\ncircle.(polyintersections(pentagon, square), 8, :fill)\n\nsethue(\"green\")\ncircle.(polyintersections(square, pentagon), 4, :fill)\n\nfinish() # hide\nnothing # hide(Image: polygon intersections)The returned polygon includes all the points in the first (source) polygon plus the points where the source polygon overlaps the target polygon.intersectlinepoly\npolyintersections"
},

{
    "location": "text/#",
    "page": "Text",
    "title": "Text",
    "category": "page",
    "text": "DocTestSetup = quote\n    using Luxor, Colors\n    end"
},

{
    "location": "text/#Text-and-fonts-1",
    "page": "Text",
    "title": "Text and fonts",
    "category": "section",
    "text": ""
},

{
    "location": "text/#A-tale-of-two-APIs-1",
    "page": "Text",
    "title": "A tale of two APIs",
    "category": "section",
    "text": "There are two ways to draw text in Luxor. You can use either the so-called \'toy\' API or the \'pro\' API.Both have their advantages and disadvantages, and, given that trying to write anything definitive about font usage on three very different operating systems is an impossibility, trial and error will eventually lead to code patterns that work for you, if not other people."
},

{
    "location": "text/#The-Toy-API-1",
    "page": "Text",
    "title": "The Toy API",
    "category": "section",
    "text": "Use:text(string, [position]) to place text at a position, otherwise at 0/0, and optionally specify the horizontal and vertical alignment\nfontface(fontname) to specify the fontname\nfontsize(fontsize) to specify the fontsize in pointsusing Luxor # hide\nDrawing(600, 100, \"assets/figures/toy-text-example.png\") # hide\norigin() # hide\nbackground(\"azure\") # hide\nsethue(\"black\") # hide\nfontsize(18)\nfontface(\"Georgia-Bold\")\ntext(\"Georgia: a serif typeface designed in 1993 by Matthew Carter.\", halign=:center)\nfinish() # hide\nnothing # hide(Image: text placement)The label() function also uses the Toy API."
},

{
    "location": "text/#The-Pro-API-1",
    "page": "Text",
    "title": "The Pro API",
    "category": "section",
    "text": "Use:setfont(fontname, fontsize) to specify the fontname and size in points\nsettext(text, [position]) to place the text at a position, and optionally specify horizontal and vertical alignment, rotation (in degrees counterclockwise!), and the presence of any Pango-flavored markup.using Luxor # hide\nDrawing(600, 100, \"assets/figures/pro-text-example.png\") # hide\norigin() # hide\nbackground(\"azure\") # hide\nsethue(\"black\") # hide\nsetfont(\"Georgia Bold\", 18)\nsettext(\"Georgia: a serif typeface designed in 1993 by Matthew Carter.\", halign=\"center\")\nfinish() # hide\nnothing # hide(Image: text placement)"
},

{
    "location": "text/#Luxor.fontface",
    "page": "Text",
    "title": "Luxor.fontface",
    "category": "function",
    "text": "fontface(fontname)\n\nSelect a font to use. (Toy API)\n\n\n\n\n\n"
},

{
    "location": "text/#Luxor.fontsize",
    "page": "Text",
    "title": "Luxor.fontsize",
    "category": "function",
    "text": "fontsize(n)\n\nSet the font size to n points. The default size is 10 points. (Toy API)\n\n\n\n\n\n"
},

{
    "location": "text/#Specifying-the-font-(\"Toy\"-API)-1",
    "page": "Text",
    "title": "Specifying the font (\"Toy\" API)",
    "category": "section",
    "text": "Use fontface(fontname) to choose a font, and fontsize(n) to set the font size in points.fontface\nfontsize"
},

{
    "location": "text/#Luxor.setfont",
    "page": "Text",
    "title": "Luxor.setfont",
    "category": "function",
    "text": "setfont(family, fontsize)\n\nSelect a font and specify the size in points.\n\nExample:\n\nsetfont(\"Helvetica\", 24)\nsettext(\"Hello in Helvetica 24 using the Pro API\", Point(0, 10))\n\n\n\n\n\n"
},

{
    "location": "text/#Specifying-the-font-(\"Pro\"-API)-1",
    "page": "Text",
    "title": "Specifying the font (\"Pro\" API)",
    "category": "section",
    "text": "To select a font in the Pro text API, use setfont() and supply both the font name and a size.setfont"
},

{
    "location": "text/#Luxor.text",
    "page": "Text",
    "title": "Luxor.text",
    "category": "function",
    "text": "text(str)\ntext(str, pos)\ntext(str, pos, angle=pi/2)\ntext(str, x, y)\ntext(str, pos, halign=:left)\ntext(str, valign=:baseline)\ntext(str, valign=:baseline, halign=:left)\ntext(str, pos, valign=:baseline, halign=:left)\n\nDraw the text in the string str at x/y or pt, placing the start of the string at the point. If you omit the point, it\'s placed at the current 0/0. In Luxor, placing text doesn\'t affect the current point.\n\nangle specifies the rotation of the text relative to the current x-axis.\n\nHorizontal alignment halign can be :left, :center, (also :centre) or :right.  Vertical alignment valign can be :baseline, :top, :middle, or :bottom.\n\nThe default alignment is :left, :baseline.\n\nThis uses Cairo\'s Toy text API.\n\n\n\n\n\n"
},

{
    "location": "text/#Placing-text-(\"Toy\"-API)-1",
    "page": "Text",
    "title": "Placing text (\"Toy\" API)",
    "category": "section",
    "text": "Use text() to place text.using Luxor # hide\nDrawing(400, 150, \"assets/figures/text-placement.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nfontsize(80) # hide\nsethue(\"black\") # hide\npt1 = Point(-100, 0)\npt2 = Point(0, 0)\npt3 = Point(100, 0)\nsethue(\"black\")\ntext(\"1\",  pt1, halign=:left,   valign = :bottom)\ntext(\"2\",  pt2, halign=:center, valign = :bottom)\ntext(\"3\",  pt3, halign=:right,  valign = :bottom)\ntext(\"4\",  pt1, halign=:left,   valign = :top)\ntext(\"5 \", pt2, halign=:center, valign = :top)\ntext(\"6\",  pt3, halign=:right,  valign = :top)\nsethue(\"red\")\nmap(p -> circle(p, 4, :fill), [pt1, pt2, pt3])\nfinish() # hide\nnothing # hide(Image: text placement)using Luxor # hide\nDrawing(400, 300, \"assets/figures/text-rotation.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"black\") # hide\nfontsize(10)\nfontface(\"Georgia\")\n[text(string(theta), Point(40cos(theta), 40sin(theta)), angle=theta)\n  for theta in 0:pi/12:47pi/24]\nfinish() # hide\nnothing # hide(Image: text rotation)text"
},

{
    "location": "text/#Luxor.settext",
    "page": "Text",
    "title": "Luxor.settext",
    "category": "function",
    "text": "settext(text, pos;\n    halign = \"left\",\n    valign = \"bottom\",\n    angle  = 0, # degrees!\n    markup = false)\n\nsettext(text;\n    kwargs)\n\nDraw the text at pos (if omitted defaults to 0/0). If no font is specified, on macOS the default font is Times Roman.\n\nTo align the text, use halign, one of \"left\", \"center\", or \"right\", and valign, one of \"top\", \"center\", or \"bottom\".\n\nangle is the rotation - in counterclockwise degrees, rather than Luxor\'s default clockwise (+x-axis to +y-axis) radians.\n\nIf markup is true, then the string can contain some HTML-style markup. Supported tags include:\n\n<b>, <i>, <s>, <sub>, <sup>, <small>, <big>, <u>, <tt>, and <span>\n\nThe <span> tag can contains things like this:\n\n<span font=\'26\' background=\'green\' foreground=\'red\'>unreadable text</span>\n\n\n\n\n\n"
},

{
    "location": "text/#Placing-text-(\"Pro\"-API)-1",
    "page": "Text",
    "title": "Placing text (\"Pro\" API)",
    "category": "section",
    "text": "Use settext() to place text. You can include some pseudo-HTML markup.using Luxor # hide\nDrawing(400, 150, \"assets/figures/pro-text-placement.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nrulers()\nsethue(\"black\")\nsettext(\"<span font=\'26\' background =\'green\' foreground=\'red\'> Hey</span>\n    <i>italic</i> <b>bold</b> <sup>superscript</sup>\n    <tt>monospaced</tt>\",\n    halign=\"center\",\n    markup=true,\n    angle=10) # degrees counterclockwise!\nfinish() # hide\nnothing # hide(Image: pro text placement)settext"
},

{
    "location": "text/#Notes-on-fonts-1",
    "page": "Text",
    "title": "Notes on fonts",
    "category": "section",
    "text": "On macOS, the fontname required by the Toy API\'s fontface() should be the PostScript name of a currently activated font. You can find this out using, for example, the FontBook application.On macOS, a list of currently activated fonts can be found (after a while) with the shell command:system_profiler SPFontsDataTypeFonts currently activated by a Font Manager can be found and used by the Toy API but not by the Pro API (at least on my macOS computer currently).On macOS, you can obtain a list of fonts that fontconfig considers are installed and available for use (via the Pro Text API with setfont()) using the shell command:fc-list | cut -f 2 -d \":\"although typically this lists only those fonts in /System/Library/Fonts and /Library/Fonts, and not ~/Library/Fonts.(There is a Julia interface to fontconfig at Fontconfig.jl.)In the Pro API, the default font is Times Roman (on macOS). In the Toy API, the default font is Helvetica (on macOS).Cairo (and hence Luxor) doesn\'t support emoji currently. 😢"
},

{
    "location": "text/#Luxor.textoutlines",
    "page": "Text",
    "title": "Luxor.textoutlines",
    "category": "function",
    "text": "textoutlines(s::AbstractString, pos::Point=O, action::Symbol=:none;\n    halign=:left,\n    valign=:baseline)\n\nConvert text to a graphic path and apply action.\n\n\n\n\n\n"
},

{
    "location": "text/#Luxor.textpath",
    "page": "Text",
    "title": "Luxor.textpath",
    "category": "function",
    "text": "textpath(t)\n\nConvert the text in string t to a new path, for subsequent filling/stroking etc...\n\nTypically you\'ll have to use pathtopoly() or getpath() or getpathflat() then work through the one or more path(s). Or use textoutlines().\n\n\n\n\n\n"
},

{
    "location": "text/#Text-to-paths-1",
    "page": "Text",
    "title": "Text to paths",
    "category": "section",
    "text": "textoutlines(string, position, action) converts the text into graphic path(s), places them starting at position, and applies the action.using Luxor # hide\nDrawing(400, 400, \"assets/figures/textoutlines.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nfontface(\"Times-Roman\")\nfontsize(500)\nsetline(4)\nsethue(\"maroon2\")\ntextoutlines(\"&\", O, :fill, valign=:middle, halign=:center)\nsethue(\"black\")\ntextoutlines(\"&\", O, :stroke, valign=:middle, halign=:center)\nfinish() # hide\nnothing # hide(Image: text outlines)textoutlinestextpath() converts the text into graphic paths suitable for further manipulation.textpath"
},

{
    "location": "text/#Luxor.textextents",
    "page": "Text",
    "title": "Luxor.textextents",
    "category": "function",
    "text": "textextents(str)\n\nReturn an array of six Float64s containing the measurements of the string str when set using the current font settings (Toy API):\n\n1 x_bearing\n\n2 y_bearing\n\n3 width\n\n4 height\n\n5 x_advance\n\n6 y_advance\n\nThe x and y bearings are the displacement from the reference point to the upper-left corner of the bounding box. It is often zero or a small positive value for x displacement, but can be negative x for characters like \"j\"; it\'s almost always a negative value for y displacement.\n\nThe width and height then describe the size of the bounding box. The advance takes you to the suggested reference point for the next letter. Note that bounding boxes for subsequent blocks of text can overlap if the bearing is negative, or the advance is smaller than the width would suggest.\n\nExample:\n\ntextextents(\"R\")\n\nreturns\n\n[1.18652; -9.68335; 8.04199; 9.68335; 9.74927; 0.0]\n\n\n\n\n\n"
},

{
    "location": "text/#Font-dimensions-(\"Toy\"-API)-1",
    "page": "Text",
    "title": "Font dimensions (\"Toy\" API)",
    "category": "section",
    "text": "The textextents(str) function gets an array of dimensions of the string str, given the current font.(Image: textextents)The green dot is the text placement point and reference point for the font, the yellow circle shows the text block\'s x and y bearings, and the blue dot shows the advance point where the next character should be placed.textextents"
},

{
    "location": "text/#Luxor.label",
    "page": "Text",
    "title": "Luxor.label",
    "category": "function",
    "text": "label(txt::AbstractString, alignment::Symbol=:N, pos::Point=O;\n    offset=5,\n    leader=false)\n\nAdd a text label at a point, positioned relative to that point, for example, :N signifies North and places the text directly above that point.\n\nUse one of :N, :S, :E, :W, :NE, :SE, :SW, :NW to position the label relative to that point.\n\nlabel(\"text\")          # positions text at North (above), relative to the origin\nlabel(\"text\", :S)      # positions text at South (below), relative to the origin\nlabel(\"text\", :S, pt)  # positions text South of pt\nlabel(\"text\", :N, pt, offset=20)  # positions text North of pt, offset by 20\n\nThe default offset is 5 units.\n\nIf leader is true, draw a line as well.\n\nTODO: Negative offsets don\'t give good results.\n\n\n\n\n\nlabel(txt::AbstractString, rotation::Float64, pos::Point=O;\n    offset=5,\n    leader=false,\n    leaderoffsets=[0.0, 1.0])\n\nAdd a text label at a point, positioned relative to that point, for example, 0.0 is East, pi is West.\n\nlabel(\"text\", pi)          # positions text to the left of the origin\n\n\n\n\n\n"
},

{
    "location": "text/#Labels-1",
    "page": "Text",
    "title": "Labels",
    "category": "section",
    "text": "The label() function places text relative to a specific point, and you can use compass points to indicate where it should be. So :N (for North) places a text label directly above the point.using Luxor # hide\nDrawing(400, 350, \"assets/figures/labels.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"black\")\nfontsize(15)\noctagon = ngon(O, 100, 8, 0, vertices=true)\n\ncompass = [:SE, :S, :SW, :W, :NW, :N, :NE, :E, :SE]\n\nfor i in 1:8\n    circle(octagon[i], 5, :fill)\n    label(string(compass[i]), compass[i], octagon[i], leader=true, leaderoffsets=[0.2, 0.9], offset=50)\nend\n\nfinish() # hide\nnothing # hide(Image: labels)label"
},

{
    "location": "text/#Luxor.textcurve",
    "page": "Text",
    "title": "Luxor.textcurve",
    "category": "function",
    "text": "Place a string of text on a curve. It can spiral in or out.\n\ntextcurve(the_text, start_angle, start_radius, x_pos = 0, y_pos = 0;\n          # optional keyword arguments:\n          spiral_ring_step = 0,    # step out or in by this amount\n          letter_spacing = 0,      # tracking/space between chars, tighter is (-), looser is (+)\n          spiral_in_out_shift = 0, # + values go outwards, - values spiral inwards\n          clockwise = true\n          )\n\nstart_angle is relative to +ve x-axis, arc/circle is centered on (x_pos,y_pos) with radius start_radius.\n\n\n\n\n\n"
},

{
    "location": "text/#Luxor.textcurvecentered",
    "page": "Text",
    "title": "Luxor.textcurvecentered",
    "category": "function",
    "text": "textcurvecentered(the_text, the_angle, the_radius, center::Point;\n      clockwise = true,\n      letter_spacing = 0,\n      baselineshift = 0\n\nThis version of the textcurve() function is designed for shorter text strings that need positioning around a circle. (A cheesy effect much beloved of hipster brands and retronauts.)\n\nletter_spacing adjusts the tracking/space between chars, tighter is (-), looser is (+)).  baselineshift moves the text up or down away from the baseline.\n\ntextcurvecentred (UK spelling) is a synonym\n\n\n\n\n\n"
},

{
    "location": "text/#Text-on-a-curve-1",
    "page": "Text",
    "title": "Text on a curve",
    "category": "section",
    "text": "Use textcurve(str) to draw a string str on a circular arc or spiral.using Luxor # hide\nDrawing(1800, 1800, \"assets/figures/text-spiral.png\") # hide\norigin() # hide\nbackground(\"ivory\") # hide\nfontsize(16) # hide\nfontface(\"Menlo\") # hide\nsethue(\"royalblue4\") # hide\ntextstring = join(names(Base), \" \")\ntextcurve(\"this spiral contains every word in julia names(Base): \" * textstring,\n    -pi/2,\n    800, 0, 0,\n    spiral_in_out_shift = -18.0,\n    letter_spacing = 0,\n    spiral_ring_step = 0)\nfontsize(35)\nfontface(\"Avenir-Black\")\ntextcentered(\"julia names(Base)\", 0, 0)\nfinish() # hide\nnothing # hide(Image: text on a curve or spiral)For shorter strings, textcurvecentered() tries to place the text on a circular arc by its center point.using Luxor # hide\nDrawing(400, 250, \"assets/figures/text-centered.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nfontface(\"Arial-Black\")\nfontsize(24) # hide\nsethue(\"black\") # hide\nsetdash(\"dot\") # hide\nsetline(0.25) # hide\ncircle(O, 100, :stroke)\ntextcurvecentered(\"hello world\", -pi/2, 100, O;\n    clockwise = true,\n    letter_spacing = 0,\n    baselineshift = -20\n    )\ntextcurvecentered(\"hello world\", pi/2, 100, O;\n    clockwise = false,\n    letter_spacing = 0,\n    baselineshift = 10\n    )\nfinish() # hide\nnothing # hide(Image: text centered on curve)textcurve\ntextcurvecentered"
},

{
    "location": "text/#Text-clipping-1",
    "page": "Text",
    "title": "Text clipping",
    "category": "section",
    "text": "You can use newly-created text paths as a clipping region - here the text paths are filled with names of randomly chosen Julia functions:(Image: text clipping)using Luxor\n\ncurrentwidth = 1250 # pts\ncurrentheight = 800 # pts\nDrawing(currentwidth, currentheight, \"/tmp/text-path-clipping.png\")\n\norigin()\nbackground(\"darkslategray3\")\n\nfontsize(600)                             # big fontsize to use for clipping\nfontface(\"Agenda-Black\")\nstr = \"julia\"                             # string to be clipped\nw, h = textextents(str)[3:4]              # get width and height\n\ntranslate(-(currentwidth/2) + 50, -(currentheight/2) + h)\n\ntextpath(str)                             # make text into a path\nsetline(3)\nsetcolor(\"black\")\nfillpreserve()                            # fill but keep\nclip()                                    # and use for clipping region\n\nfontface(\"Monaco\")\nfontsize(10)\nnamelist = map(x->string(x), names(Base)) # get list of function names in Base.\n\nx = -20\ny = -h\nwhile y < currentheight\n    sethue(rand(7:10)/10, rand(7:10)/10, rand(7:10)/10)\n    s = namelist[rand(1:end)]\n    text(s, x, y)\n    se = textextents(s)\n    x += se[5]                            # move to the right\n    if x > w\n       x = -20                            # next row\n       y += 10\n    end\nend\n\nfinish()\npreview()"
},

{
    "location": "text/#Luxor.textwrap",
    "page": "Text",
    "title": "Luxor.textwrap",
    "category": "function",
    "text": "textwrap(s::T where T<:AbstractString, width::Real, pos::Point;\n    rightgutter=5,\n    leading=0)\ntextwrap(s::T where T<:AbstractString, width::Real, pos::Point, linefunc::Function;\n    rightgutter=5,\n    leading=0)\n\nDraw the string in s by splitting it at whitespace characters into lines, so that each line is no longer than width units. The text starts at pos such that the first line of text is drawn entirely below a line drawn horizontally through that position. Each line is aligned on the left side, below pos.\n\nSee also textbox().\n\nIf you don\'t supply a value for leading, the font\'s built-in extents are used.\n\nText with no whitespace characters won\'t wrap. You can write a simple chunking function to split a string or array into chunks:\n\nchunk(x, n) = [x[i:min(i+n-1,length(x))] for i in 1:n:length(x)]\n\n\n\n\n\n"
},

{
    "location": "text/#Luxor.textbox",
    "page": "Text",
    "title": "Luxor.textbox",
    "category": "function",
    "text": "textbox(lines::Array, pos::Point=O;\n    leading = 12,\n    linefunc::Function = (linenumber, linetext, startpos, height) -> (),\n    alignment=:left)\n\nDraw the strings in the array lines vertically downwards. leading controls the spacing between each line (default 12), and alignment determines the horizontal alignment (default :left).\n\nOptionally, before each line, execute the function linefunc(linenumber, linetext, startpos, height).\n\nSee also textwrap(), which modifies the text so that the lines fit into a specified width.\n\n\n\n\n\ntextbox(s::AbstractString, pos::Point=O;\n    leading = 12,\n    linefunc::Function = (linenumber, linetext, startpos, height) -> (),\n    alignment=:left)\n\n\n\n\n\n"
},

{
    "location": "text/#Luxor.splittext",
    "page": "Text",
    "title": "Luxor.splittext",
    "category": "function",
    "text": "splittext(s)\n\nSplit the text in string s into an array, but keep all the separators attached to the preceding word.\n\n\n\n\n\n"
},

{
    "location": "text/#Text-blocks,-boxes,-and-wrapping-1",
    "page": "Text",
    "title": "Text blocks, boxes, and wrapping",
    "category": "section",
    "text": "Longer lines of text can be made to wrap inside an imaginary rectangle with textwrap(). Specify the required width of the rectangle, and the location of the top left corner.\nusing Luxor # hide\nDrawing(500, 400, \"assets/figures/text-wrapping.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nfontface(\"Georgia\")\nfontsize(12) # hide\nsethue(\"black\") # hide\n\nloremipsum = \"\"\"Lorem ipsum dolor sit amet, consectetur\nadipiscing elit. Nunc placerat lorem ullamcorper,\nsagittis massa et, elementum dui. Sed dictum ipsum vel\ncommodo pellentesque. Aliquam erat volutpat. Nam est\ndolor, vulputate a molestie aliquet, rutrum quis lectus.\nSed lectus mauris, tristique et tempor id, accumsan\npharetra lacus. Donec quam magna, accumsan a quam\nquis, mattis hendrerit nunc. Nullam vehicula leo ac\nleo tristique, a condimentum tortor faucibus.\"\"\"\n\nsetdash(\"dot\")\nbox(O, 200, 200, :stroke)\ntextwrap(loremipsum, 200, O - (200/2, 200/2))\n\nfinish() # hide\nnothing # hide(Image: text wrapping)textwrap() accepts a function that allows you to insert code that responds to the next line\'s linenumber, contents, position, and height.using Luxor, Colors # hide\nDrawing(500, 400, \"assets/figures/text-wrapping-1.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nfontface(\"Georgia\")\nfontsize(12) # hide\nsethue(\"black\") # hide\n\nloremipsum = \"\"\"Lorem ipsum dolor sit amet, consectetur\nadipiscing elit. Nunc placerat lorem ullamcorper,\nsagittis massa et, elementum dui. Sed dictum ipsum vel\ncommodo pellentesque. Aliquam erat volutpat. Nam est\ndolor, vulputate a molestie aliquet, rutrum quis lectus.\nSed lectus mauris, tristique et tempor id, accumsan\npharetra lacus. Donec quam magna, accumsan a quam\nquis, mattis hendrerit nunc. Nullam vehicula leo ac\nleo tristique, a condimentum tortor faucibus.\"\"\"\n\ntextwrap(loremipsum, 200, O - (200/2, 200/2),\n    (lnumber, str, pt, h) -> begin\n        sethue(Colors.HSB(rescale(lnumber, 1, 15, 0, 360), 1, 1))\n        text(string(\"line \", lnumber), pt - (50, 0))\n    end)\n\nfinish() # hide\nnothing # hide(Image: text wrapped)The textbox() function also draws text inside a box, but doesn\'t alter the lines, and doesn\'t force the text to a specific width. Supply an array of strings and the top left position. The leading argument specifies the distance between the lines, so should be set relative to the current font size (as set with fontsize()).This example counts the number of characters drawn, using a simple closure.using Luxor, Colors # hide\nDrawing(600, 300, \"assets/figures/textbox.png\") # hide\norigin() # hide\nbackground(\"ivory\") # hide\nsethue(\"black\") # hide\nfontface(\"Georgia\")\nfontsize(30)\n\nloremipsum = \"\"\"Lorem ipsum dolor sit amet, consectetur\nadipiscing elit. Nunc placerat lorem ullamcorper,\nsagittis massa et, elementum dui. Sed dictum ipsum vel\ncommodo pellentesque. Aliquam erat volutpat. Nam est\ndolor, vulputate a molestie aliquet, rutrum quis lectus.\nSed lectus mauris, tristique et tempor id, accumsan\npharetra lacus. Donec quam magna, accumsan a quam\nquis, mattis hendrerit nunc. Nullam vehicula leo ac\nleo tristique, a condimentum tortor faucibus.\"\"\"\n\n_counter() = (a = 0; (n) -> a += n)\ncounter = _counter()\n\ntranslate(Point(-600/2, -300/2) + (50, 50))\nfontface(\"Georgia\")\nfontsize(20)\n\ntextbox(filter(!isempty, split(loremipsum, \"\\n\")),\n    O,\n    leading = 28,\n    linefunc = (lnumber, str, pt, h) -> begin\n        text(string(lnumber), pt - (30, 0))\n        counter(length(str))\n    end)\n\nfontsize(10)\ntext(string(counter(0), \" characters\"), O + (0, 230))\n\nfinish() # hide\nnothing # hide(Image: textbox)textwrap\ntextbox\nsplittext"
},

{
    "location": "transforms/#",
    "page": "Transforms and matrices",
    "title": "Transforms and matrices",
    "category": "page",
    "text": "DocTestSetup = quote\n    using Luxor, Colors\n    end"
},

{
    "location": "transforms/#Luxor.scale",
    "page": "Transforms and matrices",
    "title": "Luxor.scale",
    "category": "function",
    "text": "scale(x, y)\n\nScale workspace by x and y.\n\nExample:\n\nscale(0.2, 0.3)\n\n\n\n\n\nscale(f)\n\nScale workspace by f in both x and y.\n\n\n\n\n\n"
},

{
    "location": "transforms/#Luxor.rotate",
    "page": "Transforms and matrices",
    "title": "Luxor.rotate",
    "category": "function",
    "text": "rotate(a::Float64)\n\nRotate workspace by a radians clockwise (from positive x-axis to positive y-axis).\n\n\n\n\n\n"
},

{
    "location": "transforms/#Luxor.translate",
    "page": "Transforms and matrices",
    "title": "Luxor.translate",
    "category": "function",
    "text": "translate(point)\ntranslate(x::Real, y::Real)\n\nTranslate the workspace to x and y or to pt.\n\n\n\n\n\n"
},

{
    "location": "transforms/#Transforms-and-matrices-1",
    "page": "Transforms and matrices",
    "title": "Transforms and matrices",
    "category": "section",
    "text": "For basic transformations of the drawing space, use scale(sx, sy), rotate(a), and translate(tx, ty).translate() shifts the current axes by the specified amounts in x and y. It\'s relative and cumulative, rather than absolute:using Luxor, Colors, Random # hide\nDrawing(600, 200, \"assets/figures/translate.png\") # hide\nbackground(\"white\") # hide\nRandom.seed!(1) # hide\nsetline(1) # hide\norigin()\nfor i in range(0, step=30, length=6)\n    sethue(HSV(i, 1, 1)) # from Colors\n    setopacity(0.5)\n    circle(0, 0, 40, :fillpreserve)\n    setcolor(\"black\")\n    strokepath()\n    translate(50, 0)\nend\nfinish() # hide\nnothing # hide(Image: translate)scale(x, y) or scale(n) scales the current workspace by the specified amounts. Again, it\'s relative to the current scale, not to the document\'s original.using Luxor, Colors, Random # hide\nDrawing(400, 200, \"assets/figures/scale.png\") # hide\nbackground(\"white\") # hide\nRandom.seed!(1) # hide\nsetline(1) # hide\norigin()\nfor i in range(0, step=30, length=6)\n    sethue(HSV(i, 1, 1)) # from Colors\n    circle(0, 0, 90, :fillpreserve)\n    setcolor(\"black\")\n    strokepath()\n    scale(0.8, 0.8)\nend\nfinish() # hide\nnothing # hide(Image: scale)rotate() rotates the current workspace by the specifed amount about the current 0/0 point. It\'s relative to the previous rotation, not to the document\'s original.using Luxor, Random # hide\nDrawing(400, 200, \"assets/figures/rotate.png\") # hide\nbackground(\"white\") # hide\nRandom.seed!(1) # hide\nsetline(1) # hide\norigin()\nsetopacity(0.7) # hide\nfor i in 1:8\n    randomhue()\n    squircle(Point(40, 0), 20, 30, :fillpreserve)\n    sethue(\"black\")\n    strokepath()\n    rotate(pi/4)\nend\nfinish() # hide\nnothing # hide(Image: rotate)To return home after many changes, you can use setmatrix([1, 0, 0, 1, 0, 0]) to reset the matrix to the default. origin() resets the matrix then moves the origin to the center of the page.rescale() is a convenient utility function for linear interpolation, also called a \"lerp\".scale\nrotate\ntranslate"
},

{
    "location": "transforms/#Luxor.getmatrix",
    "page": "Transforms and matrices",
    "title": "Luxor.getmatrix",
    "category": "function",
    "text": "getmatrix()\n\nGet the current matrix. Returns an array of six float64 numbers:\n\nxx component of the affine transformation\nyx component of the affine transformation\nxy component of the affine transformation\nyy component of the affine transformation\nx0 translation component of the affine transformation\ny0 translation component of the affine transformation\n\nSome basic matrix transforms:\n\ntranslate\n\ntransform([1, 0, 0, 1, dx, dy]) shifts by dx, dy\n\nscale\n\ntransform([fx 0 0 fy 0 0]) scales by fx and fy\n\nrotate\n\ntransform([cos(a), -sin(a), sin(a), cos(a), 0, 0]) rotates around to a radians\n\nrotate around O: [c -s s c 0 0]\n\nshear\n\ntransform([1 0 a 1 0 0]) shears in x direction by a\n\nshear in y: [1  B 0  1 0 0]\nx-skew\n\ntransform([1, 0, tan(a), 1, 0, 0]) skews in x by a\n\ny-skew\n\ntransform([1, tan(a), 0, 1, 0, 0]) skews in y by a\n\nflip\n\ntransform([fx, 0, 0, fy, centerx * (1 - fx), centery * (fy-1)]) flips with center at centerx/centery\n\nreflect\n\ntransform([1 0 0 -1 0 0]) reflects in xaxis\n\ntransform([-1 0 0 1 0 0]) reflects in yaxis\n\nWhen a drawing is first created, the matrix looks like this:\n\ngetmatrix() = [1.0, 0.0, 0.0, 1.0, 0.0, 0.0]\n\nWhen the origin is moved to 400/400, it looks like this:\n\ngetmatrix() = [1.0, 0.0, 0.0, 1.0, 400.0, 400.0]\n\nTo reset the matrix to the original:\n\nsetmatrix([1.0, 0.0, 0.0, 1.0, 0.0, 0.0])\n\n\n\n\n\n"
},

{
    "location": "transforms/#Luxor.setmatrix",
    "page": "Transforms and matrices",
    "title": "Luxor.setmatrix",
    "category": "function",
    "text": "setmatrix(m::AbstractArray)\n\nChange the current matrix to matrix m. Use getmatrix() to get the current matrix.\n\n\n\n\n\n"
},

{
    "location": "transforms/#Luxor.transform",
    "page": "Transforms and matrices",
    "title": "Luxor.transform",
    "category": "function",
    "text": "transform(a::AbstractArray)\n\nModify the current matrix by multiplying it by matrix a.\n\nFor example, to skew the current state by 45 degrees in x and move by 20 in y direction:\n\ntransform([1, 0, tand(45), 1, 0, 20])\n\nUse getmatrix() to get the current matrix.\n\n\n\n\n\n"
},

{
    "location": "transforms/#Luxor.crossproduct",
    "page": "Transforms and matrices",
    "title": "Luxor.crossproduct",
    "category": "function",
    "text": "crossproduct(p1::Point, p2::Point)\n\nThis is the perp dot product, really, not the crossproduct proper (which is 3D):\n\n\n\n\n\n"
},

{
    "location": "transforms/#Luxor.blendmatrix",
    "page": "Transforms and matrices",
    "title": "Luxor.blendmatrix",
    "category": "function",
    "text": "blendmatrix(b::Blend, m)\n\nSet the matrix of a blend.\n\nTo apply a sequence of matrix transforms to a blend:\n\nA = [1 0 0 1 0 0]\nAj = cairotojuliamatrix(A)\nSj = scalingmatrix(2, .2) * Aj\nTj = translationmatrix(10, 0) * Sj\nA1 = juliatocairomatrix(Tj)\nblendmatrix(b, As)\n\n\n\n\n\n"
},

{
    "location": "transforms/#Luxor.rotationmatrix",
    "page": "Transforms and matrices",
    "title": "Luxor.rotationmatrix",
    "category": "function",
    "text": "rotationmatrix(a)\n\nReturn a 3x3 Julia matrix that will apply a rotation through a radians.\n\n\n\n\n\n"
},

{
    "location": "transforms/#Luxor.scalingmatrix",
    "page": "Transforms and matrices",
    "title": "Luxor.scalingmatrix",
    "category": "function",
    "text": "scalingmatrix(sx, sy)\n\nReturn a 3x3 Julia matrix that will apply a scaling by sx and sy.\n\n\n\n\n\n"
},

{
    "location": "transforms/#Luxor.translationmatrix",
    "page": "Transforms and matrices",
    "title": "Luxor.translationmatrix",
    "category": "function",
    "text": "translationmatrix(x, y)\n\nReturn a 3x3 Julia matrix that will apply a translation in x and y.\n\n\n\n\n\n"
},

{
    "location": "transforms/#Luxor.getscale",
    "page": "Transforms and matrices",
    "title": "Luxor.getscale",
    "category": "function",
    "text": "getscale(R::Matrix)\ngetscale()\n\nGet the current scale of a Julia 3x3 matrix, or the current Luxor scale.\n\nReturns a tuple of x and y values.\n\n\n\n\n\n"
},

{
    "location": "transforms/#Luxor.gettranslation",
    "page": "Transforms and matrices",
    "title": "Luxor.gettranslation",
    "category": "function",
    "text": "gettranslation(R::Matrix)\ngettranslation()\n\nGet the current translation of a Julia 3x3 matrix, or the current Luxor translation.\n\nReturns a tuple of x and y values.\n\n\n\n\n\n"
},

{
    "location": "transforms/#Luxor.getrotation",
    "page": "Transforms and matrices",
    "title": "Luxor.getrotation",
    "category": "function",
    "text": "getrotation(R::Matrix)\ngetrotation()\n\nGet the rotation of a Julia 3x3 matrix, or the current Luxor rotation.\n\nbeginbmatrix\na  b  tx \nc  d  ty \n0  0  1  \nendbmatrix\n\nThe rotation angle is atan(-b, a) or atan(c, d).\n\n\n\n\n\n"
},

{
    "location": "transforms/#Luxor.cairotojuliamatrix",
    "page": "Transforms and matrices",
    "title": "Luxor.cairotojuliamatrix",
    "category": "function",
    "text": "cairotojuliamatrix(c)\n\nReturn a 3x3 Julia matrix that\'s the equivalent of the six-element matrix in c.\n\n\n\n\n\n"
},

{
    "location": "transforms/#Luxor.juliatocairomatrix",
    "page": "Transforms and matrices",
    "title": "Luxor.juliatocairomatrix",
    "category": "function",
    "text": "juliatocairomatrix(c)\n\nReturn a six-element matrix that\'s the equivalent of the 3x3 Julia matrix in c.\n\n\n\n\n\n"
},

{
    "location": "transforms/#Matrices-and-transformations-1",
    "page": "Transforms and matrices",
    "title": "Matrices and transformations",
    "category": "section",
    "text": "In Luxor, there\'s always a current matrix. It\'s a six element array:beginbmatrix\n1  0  0 \n0  1  0 \nendbmatrixwhich is usually handled in Julia/Cairo/Luxor as a simple vector/array:julia> getmatrix()\n6-element Array{Float64,1}:\n   1.0\n   0.0\n   0.0\n   1.0\n   0.0\n   0.0transform(a) transforms the current workspace by \'multiplying\' the current matrix with matrix a. For example, transform([1, 0, xskew, 1, 50, 0]) skews the current matrix by xskew radians and moves it 50 in x and 0 in y.using Luxor # hide\nfname = \"assets/figures/transform.png\" # hide\npagewidth, pageheight = 450, 100 # hide\nDrawing(pagewidth, pageheight, fname) # hide\norigin() # hide\nbackground(\"white\") # hide\ntranslate(-200, 0) # hide\n\nfunction boxtext(p, t)\n    sethue(\"grey30\")\n    box(p, 30, 50, :fill)\n    sethue(\"white\")\n    textcentered(t, p)\nend\n\nfor i in 0:5\n    xskew = tand(i * 5.0)\n    transform([1, 0, xskew, 1, 50, 0])\n    boxtext(O, string(round(rad2deg(xskew), digits=1), \"°\"))\nend\n\nfinish() # hide\nnothing # hide(Image: transform)getmatrix() gets the current matrix, setmatrix(a) sets the matrix to array a.getmatrix\nsetmatrix\ntransform\ncrossproduct\nblendmatrix\nrotationmatrix\nscalingmatrix\ntranslationmatrixUse the getscale(), gettranslation(), and getrotation() functions to find the current values of the current matrix. These can also find the values of arbitrary 3x3 matrices.getscale\ngettranslation\ngetrotationYou can convert between the 6-element and 3x3 versions of a transformation matrix using the functions cairotojuliamatrix() and juliatocairomatrix().cairotojuliamatrix\njuliatocairomatrix"
},

{
    "location": "clipping/#",
    "page": "Clipping",
    "title": "Clipping",
    "category": "page",
    "text": "DocTestSetup = quote\n    using Luxor, Colors\n    end"
},

{
    "location": "clipping/#Luxor.clip",
    "page": "Clipping",
    "title": "Luxor.clip",
    "category": "function",
    "text": "clip()\n\nEstablish a new clipping region by intersecting the current clipping region with the current path and then clearing the current path.\n\n\n\n\n\n"
},

{
    "location": "clipping/#Luxor.clippreserve",
    "page": "Clipping",
    "title": "Luxor.clippreserve",
    "category": "function",
    "text": "clippreserve()\n\nEstablish a new clipping region by intersecting the current clipping region with the current path, but keep the current path.\n\n\n\n\n\n"
},

{
    "location": "clipping/#Luxor.clipreset",
    "page": "Clipping",
    "title": "Luxor.clipreset",
    "category": "function",
    "text": "clipreset()\n\nReset the clipping region to the current drawing\'s extent.\n\n\n\n\n\n"
},

{
    "location": "clipping/#Clipping-1",
    "page": "Clipping",
    "title": "Clipping",
    "category": "section",
    "text": "Use clip() to turn the current path into a clipping region, masking any graphics outside the path. clippreserve() keeps the current path, but also uses it as a clipping region. clipreset() resets it. :clip is also an action for drawing functions like circle().using Luxor # hide\nDrawing(400, 250, \"assets/figures/simpleclip.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsetline(3) # hide\nsethue(\"grey50\")\nsetdash(\"dotted\")\ncircle(O, 100, :stroke)\ncircle(O, 100, :clip)\nsethue(\"magenta\")\nbox(O, 125, 200, :fill)\nfinish() # hide\nnothing # hide(Image: simple clip)clip\nclippreserve\nclipresetThis example uses the built-in function that draws the Julia logo. The clip action lets you use the shapes as a mask for clipping subsequent graphics, which in this example are randomly-colored circles:(Image: julia logo mask)function draw(x, y)\n    foregroundcolors = Colors.diverging_palette(rand(0:360), rand(0:360), 200, s = 0.99, b=0.8)\n    gsave()\n    translate(x-100, y)\n    julialogo(action=:clip)\n    for i in 1:500\n        sethue(foregroundcolors[rand(1:end)])\n        circle(rand(-50:350), rand(0:300), 15, :fill)\n    end\n    grestore()\nend\n\ncurrentwidth = 500 # pts\ncurrentheight = 500 # pts\nDrawing(currentwidth, currentheight, \"/tmp/clipping-tests.pdf\")\norigin()\nbackground(\"white\")\nsetopacity(.4)\ndraw(0, 0)\nfinish()\npreview()"
},

{
    "location": "images/#",
    "page": "Images",
    "title": "Images",
    "category": "page",
    "text": "DocTestSetup = quote\n    using Luxor, Colors\n    end"
},

{
    "location": "images/#Images-1",
    "page": "Images",
    "title": "Images",
    "category": "section",
    "text": ""
},

{
    "location": "images/#Luxor.readpng",
    "page": "Images",
    "title": "Luxor.readpng",
    "category": "function",
    "text": "readpng(pathname)\n\nRead a PNG file.\n\nThis returns a image object suitable for placing on the current drawing with placeimage(). You can access its width and height fields:\n\nimage = readpng(\"/tmp/test-image.png\")\nw = image.width\nh = image.height\n\n\n\n\n\n"
},

{
    "location": "images/#Luxor.placeimage",
    "page": "Images",
    "title": "Luxor.placeimage",
    "category": "function",
    "text": "placeimage(img, xpos, ypos; centered=false)\n\nPlace a PNG image on the drawing at (xpos/ypos). The image img has been previously loaded using readpng().\n\nUse keyword centered=true to place the center of the image at the position.\n\n\n\n\n\nplaceimage(img, pos; centered=false)\n\nPlace the top left corner of the PNG image on the drawing at pos.\n\nUse keyword centered=true to place the center of the image at the position.\n\n\n\n\n\nplaceimage(img, xpos, ypos, a; centered=false)\n\nPlace a PNG image on the drawing at (xpos/ypos) with transparency a.\n\nUse keyword centered=true to place the center of the image at the position.\n\n\n\n\n\nplaceimage(img, pos, a; centered=false)\n\nPlace a PNG image on the drawing at pos with transparency a.\n\nUse keyword centered=true to place the center of the image at the position.\n\n\n\n\n\n"
},

{
    "location": "images/#Placing-images-1",
    "page": "Images",
    "title": "Placing images",
    "category": "section",
    "text": "There is some limited support for placing PNG images on the drawing. First, load a PNG image using readpng(filename).Then use placeimage() to place it by its top left corner at point x/y or pt. Access the image\'s dimensions with .width and .height.using Luxor # hide\nDrawing(600, 350, \"assets/figures/images.png\") # hide\norigin() # hide\nbackground(\"grey40\") # hide\nimg = readpng(\"assets/figures/julia-logo-mask.png\")\nw = img.width\nh = img.height\nrulers()\nscale(0.3, 0.3)\nrotate(pi/4)\nplaceimage(img, -w/2, -h/2, .5)\nsethue(\"red\")\ncircle(-w/2, -h/2, 15, :fill)\nfinish() # hide\nnothing # hide(Image: \"Images\")readpng\nplaceimage"
},

{
    "location": "images/#Clipping-images-1",
    "page": "Images",
    "title": "Clipping images",
    "category": "section",
    "text": "You can clip images. The following script repeatedly places the image using a circle to define a clipping path:(Image: \"Images\")using Luxor\n\nwidth, height = 4000, 4000\nmargin = 500\n\nfname = \"/tmp/test-image.pdf\"\nDrawing(width, height, fname)\norigin()\nbackground(\"grey25\")\n\nsetline(5)\nsethue(\"green\")\n\nimage = readpng(dirname(@__FILE__) * \"assets/figures/julia-logo-mask.png\")\n\nw = image.width\nh = image.height\n\npagetiles = Tiler(width, height, 7, 9)\ntw = pagetiles.tilewidth/2\nfor (pos, n) in pagetiles\n    circle(pos, tw, :stroke)\n    circle(pos, tw, :clip)\n    gsave()\n    translate(pos)\n    scale(.95, .95)\n    rotate(rand(0.0:pi/8:2pi))\n    placeimage(image, O, centered=true)\n    grestore()\n    clipreset()\nend\n\nfinish()"
},

{
    "location": "images/#Transforming-images-1",
    "page": "Images",
    "title": "Transforming images",
    "category": "section",
    "text": "You can transform images by setting the current matrix, either with scale() and rotate() and similar, or by modifying it directly. This code skews the image and scales and rotates it in a circle:using Luxor # hide\nDrawing(600, 400, \"assets/figures/transform-images.png\") # hide\norigin() # hide\nimg = readpng(\"assets/figures/clipping-tests.png\")\nw = img.width\nh = img.height\nfor theta in 0:pi/6:2pi\n    gsave()\n        scale(.5, .5)\n        rotate(theta)\n        transform([1, 0, -pi/4, 1, 250, 0])\n        placeimage(img, -w/2, -h/2, .75)\n    grestore()\nend\n\nfinish() # hide\nnothing # hide(Image: transforming images)"
},

{
    "location": "images/#Drawing-on-images-1",
    "page": "Images",
    "title": "Drawing on images",
    "category": "section",
    "text": "You sometimes want to draw over images, for example to annotate them with text or vector graphics. The things to be aware of are mostly to do with coordinates and transforms.In these examples, we\'ll annotate a PNG file.using Luxor # hide\n\nimage = readpng(\"assets/figures/julia-logo-mask.png\")\n\nw = image.width\nh = image.height\n\n# create a drawing surface of the same size\n\nfname = \"drawing_on_images.png\"\nDrawing(w, h, fname)\n\n# place the image on the Drawing - it\'s positioned by its top/left corner\n\nplaceimage(image, 0, 0)\n\n# now you can annotate the image. The (0/0) is at the top left.\n\nsethue(\"red\")\nsetline(1)\nfontsize(16)\ncircle(Point(150, 50), 2, :fill)\nlabel(\"(150/50)\", :NE, Point(150, 50), leader=true, offset=25)\n\narrow(Point(w/2, 90), Point(0, 90))\narrow(Point(w/2, 90), Point(w, 90))\ntext(\"width $w\", Point(w/2, 70), halign=:center)\n\n# to divide up the image into rectangular areas and number them,\n# temporarily position the axes at the center:\n\n@layer begin\n  setline(0.5)\n  sethue(\"green\")\n  fontsize(12)\n  translate(w/2, h/2)\n  tiles = Tiler(w, h, 8, 8, margin=0)\n  for (pos, n) in tiles\n      box(pos, tiles.tilewidth, tiles.tileheight, :stroke)\n      text(string(n-1), pos, halign=:center)\n  end\nend\nfinish() # hide\nnothing # hide(Image: drawing on images)"
},

{
    "location": "images/#Adding-text-to-transformed-images-1",
    "page": "Images",
    "title": "Adding text to transformed images",
    "category": "section",
    "text": "The above approach works well, but suppose you want to locate the working origin at the lower left of the image, ie you want all coordinates to be relative to the bottom left corner of the image?To do this, use translate() and transform() to modify the drawing space:using Luxor # hide\n\nimage = readpng(\"assets/figures/julia-logo-mask.png\")\nw = image.width\nh = image.height\nfname = \"drawing_on_images_2.png\"\nDrawing(w, h, fname)\nplaceimage(image, 0, 0)\n\n# Move the axes to the bottom:\n\ntranslate(0, h)\n\n# and reflect in the x-axis\n\ntransform([1 0 0 -1 0 0])\n\n# now 0/0 is at the bottom left corner, and 100/100 is up and to the right.\n\nsethue(\"blue\")\narrow(Point(200, 300), Point(160, 300))\n\n# However, don\'t draw text while flipped, because it will be reversed!\n\nfontsize(20)\nsethue(\"black\")\ntext(\"Oh no!\", Point(30, 250))\n\n# To work around this, define a text function\n# that flips the workspace over the x-axis just for the text:\n\nfunction textoverlay(t, pos; kwargs...)\n    @layer begin\n        translate(pos)\n        transform([1 0 0 -1 0 0])\n        text(t, O; kwargs...)\n    end\nend\n\ntextoverlay(\"a tittle!\", Point(200, 300), halign=:left, valign=:middle)\ntextoverlay(\"0/0\", O)\narrow(Point(130, 400), Point(130, 340))\n\nfinish() # hide\n\nfinish() # hide\nnothing # hide(Image: drawing on transformed images)"
},

{
    "location": "images/#Image-compositing-1",
    "page": "Images",
    "title": "Image compositing",
    "category": "section",
    "text": "You should be using Images.jl for most tasks involving image editing. But if you just need to composite images together, you can use the blending modes provided by setmode().using Luxor # hide\nDrawing(600, 400, \"assets/figures/image-compositing.png\") # hide\norigin() # hide\nimg = readpng(\"assets/figures/textcurvecenteredexample.png\")\nw = img.width\nh = img.height\n\nplaceimage(img, -w/2, -h/2, .5)\nsetmode(\"saturate\")\ntranslate(50, 0)\nplaceimage(img, -w/2, -h/2, .5)\n\nfinish() # hide\nnothing # hide(Image: transforming images)"
},

{
    "location": "turtle/#",
    "page": "Turtle graphics",
    "title": "Turtle graphics",
    "category": "page",
    "text": "DocTestSetup = quote\n    using Luxor, Colors\n    end"
},

{
    "location": "turtle/#Luxor.Turtle",
    "page": "Turtle graphics",
    "title": "Luxor.Turtle",
    "category": "type",
    "text": "Turtle()\nTurtle(O)\nTurtle(0, 0)\nTurtle(O, pendown=true, orientation=0, pencolor=(1.0, 0.25, 0.25))\n\nCreate a Turtle. You can command a turtle to move and draw \"turtle graphics\".\n\nThe commands (unusually for Julia) start with a capital letter, and angles are specified in degrees.\n\nBasic commands are Forward(), Turn(), Pendown(), Penup(), Pencolor(), Penwidth(), Circle(), Orientation(), Rectangle(), and Reposition().\n\nOthers include Push(), Pop(), Message(), HueShift(), Randomize_saturation(), Reposition(), and Pen_opacity_random().\n\n\n\n\n\n"
},

{
    "location": "turtle/#Luxor.Forward",
    "page": "Turtle graphics",
    "title": "Luxor.Forward",
    "category": "function",
    "text": "Forward(t::Turtle, d=1)\n\nMove the turtle forward by d units. The stored position is updated.\n\n\n\n\n\n"
},

{
    "location": "turtle/#Luxor.Turn",
    "page": "Turtle graphics",
    "title": "Luxor.Turn",
    "category": "function",
    "text": "Turn(t::Turtle, r=5.0)\n\nIncrease the turtle\'s rotation by r degrees. See also Orientation.\n\n\n\n\n\n"
},

{
    "location": "turtle/#Luxor.Circle",
    "page": "Turtle graphics",
    "title": "Luxor.Circle",
    "category": "function",
    "text": "Circle(t::Turtle, radius=1.0)\n\nDraw a filled circle centered at the current position with the given radius.\n\n\n\n\n\n"
},

{
    "location": "turtle/#Luxor.HueShift",
    "page": "Turtle graphics",
    "title": "Luxor.HueShift",
    "category": "function",
    "text": "HueShift(t::Turtle, inc=1.0)\n\nShift the Hue of the turtle\'s pen forward by inc. Hue values range between 0 and 360.\n\n\n\n\n\n"
},

{
    "location": "turtle/#Luxor.Message",
    "page": "Turtle graphics",
    "title": "Luxor.Message",
    "category": "function",
    "text": "Message(t::Turtle, txt)\n\nWrite some text at the current position.\n\n\n\n\n\n"
},

{
    "location": "turtle/#Luxor.Orientation",
    "page": "Turtle graphics",
    "title": "Luxor.Orientation",
    "category": "function",
    "text": "Orientation(t::Turtle, r=0.0)\n\nSet the turtle\'s orientation to r degrees. See also Turn.\n\n\n\n\n\n"
},

{
    "location": "turtle/#Luxor.Randomize_saturation",
    "page": "Turtle graphics",
    "title": "Luxor.Randomize_saturation",
    "category": "function",
    "text": "Randomize_saturation(t::Turtle)\n\nRandomize the saturation of the turtle\'s pen color.\n\n\n\n\n\n"
},

{
    "location": "turtle/#Luxor.Rectangle",
    "page": "Turtle graphics",
    "title": "Luxor.Rectangle",
    "category": "function",
    "text": "Rectangle(t::Turtle, width=10.0, height=10.0)\n\nDraw a filled rectangle centered at the current position with the given radius.\n\n\n\n\n\n"
},

{
    "location": "turtle/#Luxor.Pen_opacity_random",
    "page": "Turtle graphics",
    "title": "Luxor.Pen_opacity_random",
    "category": "function",
    "text": "Pen_opacity_random(t::Turtle)\n\nChange the opacity of the pen to some value at random.\n\n\n\n\n\n"
},

{
    "location": "turtle/#Luxor.Pendown",
    "page": "Turtle graphics",
    "title": "Luxor.Pendown",
    "category": "function",
    "text": "Pendown(t::Turtle)\n\nPut that pen down and start drawing.\n\n\n\n\n\n"
},

{
    "location": "turtle/#Luxor.Penup",
    "page": "Turtle graphics",
    "title": "Luxor.Penup",
    "category": "function",
    "text": "Penup(t::Turtle)\n\nPick that pen up and stop drawing.\n\n\n\n\n\n"
},

{
    "location": "turtle/#Luxor.Pencolor",
    "page": "Turtle graphics",
    "title": "Luxor.Pencolor",
    "category": "function",
    "text": "Pencolor(t::Turtle, r, g, b)\n\nSet the Red, Green, and Blue colors of the turtle.\n\n\n\n\n\n"
},

{
    "location": "turtle/#Luxor.Penwidth",
    "page": "Turtle graphics",
    "title": "Luxor.Penwidth",
    "category": "function",
    "text": "Penwidth(t::Turtle, w)\n\nSet the width of the line drawn.\n\n\n\n\n\n"
},

{
    "location": "turtle/#Luxor.Point",
    "page": "Turtle graphics",
    "title": "Luxor.Point",
    "category": "type",
    "text": "The Point type holds two coordinates. It\'s immutable, you can\'t change the values of the x and y values directly.\n\n\n\n\n\n"
},

{
    "location": "turtle/#Luxor.Pop",
    "page": "Turtle graphics",
    "title": "Luxor.Pop",
    "category": "function",
    "text": "Pop(t::Turtle)\n\nLift the turtle\'s position and orientation off a stack.\n\n\n\n\n\n"
},

{
    "location": "turtle/#Luxor.Push",
    "page": "Turtle graphics",
    "title": "Luxor.Push",
    "category": "function",
    "text": "Push(t::Turtle)\n\nSave the turtle\'s position and orientation on a stack.\n\n\n\n\n\n"
},

{
    "location": "turtle/#Luxor.Reposition",
    "page": "Turtle graphics",
    "title": "Luxor.Reposition",
    "category": "function",
    "text": "Reposition(t::Turtle, pos::Point)\nReposition(t::Turtle, x, y)\n\nReposition: pick the turtle up and place it at another position.\n\n\n\n\n\n"
},

{
    "location": "turtle/#Turtle-graphics-1",
    "page": "Turtle graphics",
    "title": "Turtle graphics",
    "category": "section",
    "text": "Some simple \"turtle graphics\" functions are included. Functions to control the turtle begin with a capital letter: Forward, Turn, Circle, Orientation, Rectangle, Pendown, Penup, Pencolor, Penwidth, and Reposition, and so on, and angles are specified in degrees.using Luxor, Colors\nDrawing(600, 400, \"assets/figures/turtles.png\")  \norigin()  \nbackground(\"midnightblue\")  \n\n🐢 = Turtle() # you can type the turtle emoji with \\:turtle:\nPencolor(🐢, \"cyan\")\nPenwidth(🐢, 1.5)\nn = 5\nfor i in 1:400\n    global n\n    Forward(🐢, n)\n    Turn(🐢, 89.5)\n    HueShift(🐢)\n    n += 0.75\nend\nfontsize(20)\nMessage(🐢, \"finished\")\nfinish()  \nnothing # hide(Image: turtles)The turtle commands expect a reference to a turtle as the first argument (it doesn\'t have to be a turtle emoji!), and you can have any number of turtles active at a time.using Luxor, Colors # hide\nDrawing(800, 800, \"assets/figures/manyturtles.svg\") # hide\norigin() # hide\nbackground(\"white\") # hide\nquantity = 9\nturtles = [Turtle(O, true, 2pi * rand(), (rand(), rand(), 0.5)...) for i in 1:quantity]\nReposition.(turtles, first.(collect(Tiler(800, 800, 3, 3))))\nn = 10\nPenwidth.(turtles, 0.5)\nfor i in 1:300\n    global n\n    Forward.(turtles, n)\n    HueShift.(turtles)\n    Turn.(turtles, [60.1, 89.5, 110, 119.9, 120.1, 135.1, 145.1, 176, 190])\n    n += 0.5\nend\nfinish() # hide  \nnothing # hide(Image: many turtles)Turtle\nForward\nTurn\nCircle\nHueShift\nMessage\nOrientation\nRandomize_saturation\nRectangle\nPen_opacity_random\nPendown\nPenup\nPencolor\nPenwidth\nPoint\nPop\nPush\nReposition"
},

{
    "location": "animation/#",
    "page": "Animation",
    "title": "Animation",
    "category": "page",
    "text": "DocTestSetup = quote\n    using Luxor, Colors\n    end"
},

{
    "location": "animation/#Animation-helper-functions-1",
    "page": "Animation",
    "title": "Animation helper functions",
    "category": "section",
    "text": "Luxor provides some functions to help you create animations—at least, it provides some assistance in creating lots of individual frames that can later be stitched together to form a moving animation, such as a GIF or MP4.There are four steps to creating an animation.1 Use Movie to create a Movie object which determines the title and dimensions.2 Define some functions that draw the graphics for specific frames.3 Define one or more Scenes that call these functions for specific frames.4 Call the animate(movie::Movie, scenes) function, passing in the scenes. This creates all the frames and saves them in a temporary directory. Optionally, you can ask for ffmpeg (if it\'s installed) to make an animated GIF for you."
},

{
    "location": "animation/#Luxor.Movie",
    "page": "Animation",
    "title": "Luxor.Movie",
    "category": "type",
    "text": "The Movie and Scene types and the animate() function are designed to help you create the frames that can be used to make an animated GIF or movie.\n\n1 Provide width, height, title, and optionally a frame range to the Movie constructor:\n\ndemo = Movie(400, 400, \"test\", 1:500)\n\n2 Define one or more scenes and scene-drawing functions.\n\n3 Run the animate() function, calling those scenes.\n\nExample\n\nbang = Movie(400, 100, \"bang\")\n\nbackdrop(scene, framenumber) =  background(\"black\")\n\nfunction frame1(scene, framenumber)\n    background(\"white\")\n    sethue(\"black\")\n    eased_n = scene.easingfunction(framenumber, 0, 1, scene.framerange.stop)\n    circle(O, 40 * eased_n, :fill)\nend\n\nanimate(bang, [\n    Scene(bang, backdrop, 0:200),\n    Scene(bang, frame1, 0:200, easingfunction=easeinsine)],\n    creategif=true,\n    pathname=\"/tmp/animationtest.gif\")\n\n\n\n\n\n\n"
},

{
    "location": "animation/#Luxor.Scene",
    "page": "Animation",
    "title": "Luxor.Scene",
    "category": "type",
    "text": "The Scene type defines a function to be used to render a range of frames in a movie.\n\nthe movie created by Movie()\nthe framefunction is a function taking two arguments: the scene and the framenumber.\nthe framerange determines which frames are processed by the function. Defaults to the entire movie.\nthe optional easingfunction can be accessed by the framefunction to vary the transition speed\n\n\n\n\n\n"
},

{
    "location": "animation/#Luxor.animate",
    "page": "Animation",
    "title": "Luxor.animate",
    "category": "function",
    "text": "animate(movie::Movie, scenelist::AbstractArray{Scene, 1};\n        creategif=false,\n        pathname=\"\"\n        framerate=30,\n        tempdirectory=\".\")\n\nCreate the movie defined in movie by rendering the frames define in the array of scenes in scenelist.\n\nIf creategif is true, the function tries to call ffmpeg on the resulting frames to build a GIF animation. This will be stored in pathname (an existing file will be overwritten; use a \".gif\" suffix), or in (movietitle).gif in a temporary directory.\n\nExample\n\nanimate(bang, [\n    Scene(bang, backdrop, 0:200),\n    Scene(bang, frame1, 0:200, easingfunction=easeinsine)],\n    creategif=true,\n    pathname=\"/tmp/animationtest.gif\")\n\n\n\n\n\nanimate(movie::Movie, scene::Scene; creategif=false, framerate=30)\n\nCreate the movie defined in movie by rendering the frames define in scene.\n\n\n\n\n\n"
},

{
    "location": "animation/#Example-1",
    "page": "Animation",
    "title": "Example",
    "category": "section",
    "text": "using Luxor, Colors\n\ndemo = Movie(400, 400, \"test\")\n\nfunction backdrop(scene, framenumber)\n    background(\"black\")\nend\n\nfunction frame(scene, framenumber)\n    sethue(Colors.HSV(framenumber, 1, 1))\n    eased_n = scene.easingfunction(framenumber, 0, 1, scene.framerange.stop)\n    circle(polar(100, -pi/2 - (eased_n * 2pi)), 80, :fill)\n    text(string(\"frame $framenumber of $(scene.framerange.stop)\"),\n        Point(O.x, O.y-190),\n        halign=:center)\nend\n\nanimate(demo, [\n    Scene(demo, backdrop, 0:359),\n    Scene(demo, frame, 0:359, easingfunction=easeinoutcubic)\n    ],\n    creategif=true)(Image: animation example)In this example, for each frame numbered 0 to 359, the graphics are drawn by the backdrop() and frame() functions, in that order. A drawing is automatically created (in PNG format) and centered (origin()) so you can start drawing immediately. The finish() function is automatically called when all the drawing functions in the scenes have completed, and the process starts afresh for the next frame.Movie\nScene\nanimate"
},

{
    "location": "animation/#Making-the-animation-1",
    "page": "Animation",
    "title": "Making the animation",
    "category": "section",
    "text": "For best results, you\'ll have to learn how to use something like ffmpeg, with its hundreds of options, which include codec selection, framerate adjustment and color palette tweaking. The creategif option for the animate function makes an attempt at running ffmpeg and assumes that it\'s already installed. Inside animate(), the first pass creates a GIF color palette, the second builds the file:run(`ffmpeg -f image2 -i $(tempdirectory)/%10d.png -vf palettegen -y $(seq.stitle)-palette.png`)\n\nrun(`ffmpeg -framerate 30 -f image2 -i $(tempdirectory)/%10d.png -i $(seq.stitle)-palette.png -lavfi paletteuse -y /tmp/$(seq.stitle).gif`)Many movie editing programs, such as Final Cut Pro, will also let you import sequences of still images into a movie timeline."
},

{
    "location": "animation/#Using-scenes-1",
    "page": "Animation",
    "title": "Using scenes",
    "category": "section",
    "text": "Sometimes you want to construct an animation that has different components, layers, or scenes. To do this, you can specify scenes that are drawn only for specific frames.As an example, consider a simple example showing the sun for each hour of a 24 hour day.sun24demo = Movie(400, 400, \"sun24\", 0:23)The backgroundfunction() draws a background that\'s used for all frames (animated GIFs like constant backgrounds):function backgroundfunction(scene::Scene, framenumber)\n    background(\"black\")\nendA nightskyfunction() draws the night sky:function nightskyfunction(scene::Scene, framenumber)\n    sethue(\"midnightblue\")\n    box(O, 400, 400, :fill)\nendA dayskyfunction() draws the daytime sky:function dayskyfunction(scene::Scene, framenumber)\n    sethue(\"skyblue\")\n    box(O, 400, 400, :fill)\nendThe sunfunction() draws a sun at 24 positions during the day:function sunfunction(scene::Scene, framenumber)\n    i = rescale(framenumber, 0, 23, 2pi, 0)\n    gsave()\n    sethue(\"yellow\")\n    circle(polar(150, i), 20, :fill)\n    grestore()\nendFinally a groundfunction() draws the ground:function groundfunction(scene::Scene, framenumber)\n    gsave()\n    sethue(\"brown\")\n    box(Point(O.x, O.y + 100), 400, 200, :fill)\n    grestore()\n    sethue(\"white\")\nendNow define a group of Scenes that make up the movie. The scenes specify which functions are to be used, and for which frames:backdrop  = Scene(sun24demo, backgroundfunction, 0:23)   # every frame\nnightsky  = Scene(sun24demo, nightskyfunction, 0:6)      # midnight to 06:00\nnightsky1 = Scene(sun24demo, nightskyfunction, 17:23)    # 17:00 to 23:00\ndaysky    = Scene(sun24demo, dayskyfunction, 5:19)       # 05:00 to 19:00\nsun       = Scene(sun24demo, sunfunction, 6:18)          # 06:00 to 18:00\nground    = Scene(sun24demo, groundfunction, 0:23)       # every frameFinally, the animate function scans the scenes in the scenelist for a movie, and calls the functions for each frame to build the animation:animate(sun24demo, [\n   backdrop, nightsky, nightsky1, daysky, sun, ground\n   ],\n   framerate=5,\n   creategif=true)(Image: sun24 animation)Notice that for some frames, such as frame 0, 1, or 23, three of the functions are called: for others, such as 7 and 8, four or more functions are called. Also notice that the order of scenes and the use of backgrounds is important.An alternative approach is to use the incoming framenumber as the master parameter that determines the position and appearance of all the graphics.function frame(scene, framenumber)\n    background(\"black\")\n    n   = rescale(framenumber, scene.framerange.start, scene.framerange.stop, 0, 1)\n    n2π = rescale(n, 0, 1, 0, 2π)\n    sethue(n, 0.5, 0.5)\n    box(BoundingBox(), :fill)\n    if 0.25 < n < 0.75\n        sethue(\"yellow\")\n        circle(polar(150, n2π + π/2), 20, :fill)\n    end\n    if n < 0.25 || n > 0.75\n        sethue(\"white\")\n        circle(polar(150, n2π + π/2), 20, :fill)\n    end\nend"
},

{
    "location": "animation/#Luxor.easingflat",
    "page": "Animation",
    "title": "Luxor.easingflat",
    "category": "function",
    "text": "easingflat(t, b, c, d)\n\nA flat easing function, same as lineartween().\n\nFor all easing functions, the four parameters are:\n\nt time, ie the current framenumber\nb beginning position or bottom value of the range\nc total change in position or top value of the range\nd duration, ie a framecount\n\nt/d or t/=d normalizes t to between 0 and 1\n... * c scales up to the required range value\n... + b adds the initial offset\n\n\n\n\n\n"
},

{
    "location": "animation/#Luxor.lineartween",
    "page": "Animation",
    "title": "Luxor.lineartween",
    "category": "function",
    "text": "default linear transition - no easing, no acceleration\n\n\n\n\n\n"
},

{
    "location": "animation/#Luxor.easeinquad",
    "page": "Animation",
    "title": "Luxor.easeinquad",
    "category": "function",
    "text": "easeinquad(t, b, c, d)\n\nquadratic easing in - accelerating from zero velocity\n\n\n\n\n\n"
},

{
    "location": "animation/#Luxor.easeoutquad",
    "page": "Animation",
    "title": "Luxor.easeoutquad",
    "category": "function",
    "text": "easeoutquad(t, b, c, d)\n\nquadratic easing out - decelerating to zero velocity\n\n\n\n\n\n"
},

{
    "location": "animation/#Luxor.easeinoutquad",
    "page": "Animation",
    "title": "Luxor.easeinoutquad",
    "category": "function",
    "text": "easeinoutquad(t, b, c, d)\n\nquadratic easing in/out - acceleration until halfway, then deceleration\n\n\n\n\n\n"
},

{
    "location": "animation/#Luxor.easeincubic",
    "page": "Animation",
    "title": "Luxor.easeincubic",
    "category": "function",
    "text": "easeincubic(t, b, c, d)\n\ncubic easing in - accelerating from zero velocity\n\n\n\n\n\n"
},

{
    "location": "animation/#Luxor.easeoutcubic",
    "page": "Animation",
    "title": "Luxor.easeoutcubic",
    "category": "function",
    "text": "easeoutcubic(t, b, c, d)\n\ncubic easing out - decelerating to zero velocity\n\n\n\n\n\n"
},

{
    "location": "animation/#Luxor.easeinoutcubic",
    "page": "Animation",
    "title": "Luxor.easeinoutcubic",
    "category": "function",
    "text": "easeinoutcubic(t, b, c, d)\n\ncubic easing in/out - acceleration until halfway, then deceleration\n\n\n\n\n\n"
},

{
    "location": "animation/#Luxor.easeinquart",
    "page": "Animation",
    "title": "Luxor.easeinquart",
    "category": "function",
    "text": "easeinquart(t, b, c, d)\n\nquartic easing in - accelerating from zero velocity\n\n\n\n\n\n"
},

{
    "location": "animation/#Luxor.easeoutquart",
    "page": "Animation",
    "title": "Luxor.easeoutquart",
    "category": "function",
    "text": "easeoutquart(t, b, c, d)\n\nquartic easing out - decelerating to zero velocity\n\n\n\n\n\n"
},

{
    "location": "animation/#Luxor.easeinoutquart",
    "page": "Animation",
    "title": "Luxor.easeinoutquart",
    "category": "function",
    "text": "easeinoutquart(t, b, c, d)\n\nquartic easing in/out - acceleration until halfway, then deceleration\n\n\n\n\n\n"
},

{
    "location": "animation/#Luxor.easeinquint",
    "page": "Animation",
    "title": "Luxor.easeinquint",
    "category": "function",
    "text": "easeinquint(t, b, c, d)\n\nquintic easing in - accelerating from zero velocity\n\n\n\n\n\n"
},

{
    "location": "animation/#Luxor.easeoutquint",
    "page": "Animation",
    "title": "Luxor.easeoutquint",
    "category": "function",
    "text": "easeoutquint(t, b, c, d)\n\nquintic easing out - decelerating to zero velocity\n\n\n\n\n\n"
},

{
    "location": "animation/#Luxor.easeinoutquint",
    "page": "Animation",
    "title": "Luxor.easeinoutquint",
    "category": "function",
    "text": "easeinoutquint(t, b, c, d)\n\nquintic easing in/out - acceleration until halfway, then deceleration\n\n\n\n\n\n"
},

{
    "location": "animation/#Luxor.easeinsine",
    "page": "Animation",
    "title": "Luxor.easeinsine",
    "category": "function",
    "text": "easeinsine(t, b, c, d)\n\nsinusoidal easing in - accelerating from zero velocity\n\n\n\n\n\n"
},

{
    "location": "animation/#Luxor.easeoutsine",
    "page": "Animation",
    "title": "Luxor.easeoutsine",
    "category": "function",
    "text": "easeoutsine(t, b, c, d)\n\nsinusoidal easing out - decelerating to zero velocity\n\n\n\n\n\n"
},

{
    "location": "animation/#Luxor.easeinoutsine",
    "page": "Animation",
    "title": "Luxor.easeinoutsine",
    "category": "function",
    "text": "easeinoutsine(t, b, c, d)\n\nsinusoidal easing in/out - accelerating until halfway, then decelerating\n\n\n\n\n\n"
},

{
    "location": "animation/#Luxor.easeinexpo",
    "page": "Animation",
    "title": "Luxor.easeinexpo",
    "category": "function",
    "text": "easeinexpo(t, b, c, d)\n\nexponential easing in - accelerating from zero velocity\n\n\n\n\n\n"
},

{
    "location": "animation/#Luxor.easeoutexpo",
    "page": "Animation",
    "title": "Luxor.easeoutexpo",
    "category": "function",
    "text": "easeoutexpo(t, b, c, d)\n\nexponential easing out - decelerating to zero velocity\n\n\n\n\n\n"
},

{
    "location": "animation/#Luxor.easeinoutexpo",
    "page": "Animation",
    "title": "Luxor.easeinoutexpo",
    "category": "function",
    "text": "easeinoutexpo(t, b, c, d)\n\nexponential easing in/out - accelerating until halfway, then decelerating\n\n\n\n\n\n"
},

{
    "location": "animation/#Luxor.easeincirc",
    "page": "Animation",
    "title": "Luxor.easeincirc",
    "category": "function",
    "text": "easeincirc(t, b, c, d)\n\ncircular easing in - accelerating from zero velocity\n\n\n\n\n\n"
},

{
    "location": "animation/#Luxor.easeoutcirc",
    "page": "Animation",
    "title": "Luxor.easeoutcirc",
    "category": "function",
    "text": "easeoutcirc(t, b, c, d)\n\ncircular easing out - decelerating to zero velocity\n\n\n\n\n\n"
},

{
    "location": "animation/#Luxor.easeinoutcirc",
    "page": "Animation",
    "title": "Luxor.easeinoutcirc",
    "category": "function",
    "text": "easeinoutcirc(t, b, c, d)\n\ncircular easing in/out - acceleration until halfway, then deceleration\n\n\n\n\n\n"
},

{
    "location": "animation/#Luxor.easeinoutinversequad",
    "page": "Animation",
    "title": "Luxor.easeinoutinversequad",
    "category": "function",
    "text": "easeinoutinversequad(t, b, c, d)\n\nease in, then slow down, then speed up, and ease out\n\n\n\n\n\n"
},

{
    "location": "animation/#Easing-functions-1",
    "page": "Animation",
    "title": "Easing functions",
    "category": "section",
    "text": "Transitions for animations often use non-constant and non-linear motions, and these are usually provided by easing functions. Luxor defines some of the basic easing functions and they\'re listed in the (unexported) array Luxor.easingfunctions. Each scene can have one easing function.Most easing functions have names constructed like this:ease[in|out|inout][expo|circ|quad|cubic|quart|quint]and there\'s an easingflat() linear transition.using Luxor # hide\nfunction draweasingfunction(f, pos, w, h)\n    @layer begin\n        translate(pos)\n        setline(0.5)\n        sethue(\"black\")\n        box(O, w, h, :stroke)\n        sethue(\"purple\")\n        for i in 0:0.005:1.0\n            circle(Point(-w/2, h/2) + Point(w * i, -f(i, 0, h, 1)), 1, :fill)\n        end\n        sethue(\"black\")\n        text(replace(string(f), \"Luxor.\" => \"\"), Point(0, h/2 - 20), halign=:center)\n    end\nend\n\nDrawing(650, 650, \"assets/figures/easingfunctions.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nt = Tiler(650, 650, 5, 5)\nmargin=5\nfontsize(10)\nfontface(\"Menlo\")\nfor (pos, n) in t\n    n > length(Luxor.easingfunctions) && continue\n    draweasingfunction(Luxor.easingfunctions[n], pos, t.tilewidth-margin, t.tileheight-margin)\nend\n\nfinish() # hide\nnothing # hideIn these graphs, the horizontal axis is time (between 0 and 1), and the vertical axis is the parameter value (between 0 and 1).(Image: easing function summary)One way to use an easing function in a frame-making function is like this:function moveobject(scene, framenumber)\n    background(\"white\")\n    ...\n    easedframenumber = scene.easingfunction(framenumber, 0, 1, scene.framerange.stop)\n    ...This takes the current frame number, compares it with the end frame number of the scene, then adjusts it.In the next example, the purple dot has sinusoidal easing motion, the green has cubic, and the red has quintic. They all traverse the drawing in the same time, but have different accelerations and decelerations.(Image: animation easing example)fastandfurious = Movie(400, 100, \"easingtests\")\nbackdrop(scene, framenumber) =  background(\"black\")\nfunction frame1(scene, framenumber)\n    sethue(\"purple\")\n    eased_n = scene.easingfunction(framenumber, 0, 1, scene.framerange.stop)\n    circle(Point(-180 + (360 * eased_n), -20), 10, :fill)\nend\nfunction frame2(scene, framenumber)\n    sethue(\"green\")\n    eased_n = scene.easingfunction(framenumber, 0, 1, scene.framerange.stop)\n    circle(Point(-180 + (360 * eased_n), 0), 10, :fill)\nend\nfunction frame3(scene, framenumber)\n    sethue(\"red\")\n    eased_n = scene.easingfunction(framenumber, 0, 1, scene.framerange.stop)\n    circle(Point(-180 + (360 * eased_n), 20), 10, :fill)\nend\nanimate(fastandfurious, [\n    Scene(fastandfurious, backdrop, 0:200),\n    Scene(fastandfurious, frame1,   0:200, easingfunction=easeinsine),\n    Scene(fastandfurious, frame2,   0:200, easingfunction=easeinoutcubic),\n    Scene(fastandfurious, frame3,   0:200, easingfunction=easeinoutquint)\n    ],\n    creategif=true)Here\'s the definition of one of the easing functions:function easeoutquad(t, b, c, d)\n    t /= d\n    return -c * t * (t - 2) + b\nendHere:t is the current time (framenumber) of the transition\nb is the beginning value of the property\nc is the change between the beginning and destination value of the property\nd is the total length of the transitioneasingflat\nlineartween\neaseinquad\neaseoutquad\neaseinoutquad\neaseincubic\neaseoutcubic\neaseinoutcubic\neaseinquart\neaseoutquart\neaseinoutquart\neaseinquint\neaseoutquint\neaseinoutquint\neaseinsine\neaseoutsine\neaseinoutsine\neaseinexpo\neaseoutexpo\neaseinoutexpo\neaseincirc\neaseoutcirc\neaseinoutcirc\neaseinoutinversequad"
},

{
    "location": "moreexamples/#",
    "page": "More examples",
    "title": "More examples",
    "category": "page",
    "text": "DocTestSetup = quote\n    using Luxor, Colors\nend"
},

{
    "location": "moreexamples/#More-examples-1",
    "page": "More examples",
    "title": "More examples",
    "category": "section",
    "text": "One place to look for examples is the Luxor/test directory.(Image: \"tiled images\")"
},

{
    "location": "moreexamples/#An-early-test-1",
    "page": "More examples",
    "title": "An early test",
    "category": "section",
    "text": "(Image: Luxor test)using Luxor\nDrawing(1200, 1400, \"basic-test.png\") # or PDF/SVG filename for PDF or SVG\norigin()\nbackground(\"purple\")\nsetopacity(0.7)                      # opacity from 0 to 1\nsethue(0.3,0.7,0.9)                  # sethue sets the color but doesn\'t change the opacity\nsetline(20)                          # line width\n\nrect(-400,-400,800,800, :fill)       # or :stroke, :fillstroke, :clip\nrandomhue()\ncircle(0, 0, 460, :stroke)\ncircle(0,-200,400,:clip)             # a circular clipping mask above the x axis\nsethue(\"gold\")\nsetopacity(0.7)\nsetline(10)\nfor i in 0:pi/36:2pi - pi/36\n    move(0, 0)\n    line(cos(i) * 600, sin(i) * 600 )\n    strokepath()\nend\nclipreset()                           # finish clipping/masking\nfontsize(60)\nsetcolor(\"turquoise\")\nfontface(\"Optima-ExtraBlack\")\ntextwidth = textextents(\"Luxor\")[5]\ntextcentred(\"Luxor\", 0, current_height()/2 - 400)\nfontsize(18)\nfontface(\"Avenir-Black\")\n\n# text on curve starting at angle 0 rads centered on origin with radius 550\ntextcurve(\"THIS IS TEXT ON A CURVE \" ^ 14, 0, 550, O)\nfinish()\npreview() # on macOS, opens in Preview"
},

{
    "location": "moreexamples/#Illustrating-this-document-1",
    "page": "More examples",
    "title": "Illustrating this document",
    "category": "section",
    "text": "This documentation was built with Documenter.jl, which is an amazingly powerful and flexible documentation generator written in Julia. The illustrations are mostly created when the HTML pages are built: the Julia source for the image is stored in the Markdown source document, and the code to create the images runs each time the documentation is generated.The Markdown markup looks like this:```@example\nusing Luxor, Random # hide\nDrawing(600, 250, \"assets/figures/polysmooth-pathological.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsetopacity(0.75) # hide\nRandom.seed!(42) # hide\nsetline(1) # hide\np = star(O, 60, 5, 0.35, 0, vertices=true)\nsetdash(\"dot\")\nsethue(\"red\")\nprettypoly(p, close=true, :stroke)\nsetdash(\"solid\")\nsethue(\"black\")\npolysmooth(p, 40, :fill, debug=true)\nfinish() # hide\n```\n\n![polysmooth](assets/figures/polysmooth-pathological.png)and after you run Documenter\'s build process the HTML output looks like this:using Luxor, Random # hide\nDrawing(600, 250, \"assets/figures/polysmoothy.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsetopacity(0.75) # hide\nRandom.seed!(42) # hide\nsetline(1) # hide\np = star(O, 60, 5, 0.35, 0, vertices=true)\nsetdash(\"dot\")\nsethue(\"red\")\nprettypoly(p, close=true, :stroke)\nsetdash(\"solid\")\nsethue(\"black\")\npolysmooth(p, 40, :fill, debug=true)\nfinish() # hide\nnothing # hide(Image: polysmooth)"
},

{
    "location": "moreexamples/#Why-turtles?-1",
    "page": "More examples",
    "title": "Why turtles?",
    "category": "section",
    "text": "An interesting application for turtle-style graphics is for drawing Lindenmayer systems (l-systems). Here\'s an example of how a complex pattern can emerge from a simple set of rules, taken from Lindenmayer.jl:(Image: penrose)The definition of this figure is:penrose = LSystem(Dict(\"X\"  =>  \"PM++QM----YM[-PM----XM]++t\",\n                       \"Y\"  => \"+PM--QM[---XM--YM]+t\",\n                       \"P\"  => \"-XM++YM[+++PM++QM]-t\",\n                       \"Q\"  => \"--PM++++XM[+QM++++YM]--YMt\",\n                       \"M\"  => \"F\",\n                       \"F\"  => \"\"),\n                  \"1[Y]++[Y]++[Y]++[Y]++[Y]\")where some of the characters—eg \"F\", \"+\", \"-\", and \"t\"—issue turtle control commands, and others—\"X,\", \"Y\", \"P\", and \"Q\"—refer to specific components of the design. The execution of the l-system involves replacing every occurrence in the drawing code of every dictionary key with the matching values."
},

{
    "location": "moreexamples/#Strange-1",
    "page": "More examples",
    "title": "Strange",
    "category": "section",
    "text": "It\'s usually better to draw fractals and similar images using pixels and image processing tools. But just for fun it\'s an interesting experiment to render a strange attractor image using vector drawing rather than placing pixels. This version uses about 600,000 circular dots (which is why it\'s better to target PNG rather than SVG or PDF for this example!).using Luxor, Colors\nfunction strange(dotsize, w=800.0)\n    xmin = -2.0; xmax = 2.0; ymin= -2.0; ymax = 2.0\n    Drawing(w, w, \"assets/figures/strange-vector.png\")\n    origin()\n    background(\"white\")\n    xinc = w/(xmax - xmin)\n    yinc = w/(ymax - ymin)\n    # control parameters\n    a = 2.24; b = 0.43; c = -0.65; d = -2.43; e1 = 1.0\n    x = y = z = 0.0\n    wover2 = w/2\n    for j in 1:w\n        for i in 1:w\n            xx = sin(a * y) - z  *  cos(b * x)\n            yy = z * sin(c * x) - cos(d * y)\n            zz = e1 * sin(x)\n            x = xx; y = yy; z = zz\n            if xx < xmax && xx > xmin && yy < ymax && yy > ymin\n                xpos = rescale(xx, xmin, xmax, -wover2, wover2) # scale to range\n                ypos = rescale(yy, ymin, ymax, -wover2, wover2) # scale to range\n                rcolor = rescale(xx, -1, 1, 0.0, .7)\n                gcolor = rescale(yy, -1, 1, 0.2, .5)\n                bcolor = rescale(zz, -1, 1, 0.3, .8)\n                setcolor(convert(Colors.HSV, Colors.RGB(rcolor, gcolor, bcolor)))\n                circle(Point(xpos, ypos), dotsize, :fill)\n            end\n        end\n    end\n    finish()\nend\n\nstrange(.3, 800)\nnothing # hide(Image: strange attractor in vectors)"
},

{
    "location": "moreexamples/#More-animations-1",
    "page": "More examples",
    "title": "More animations",
    "category": "section",
    "text": "(Image: strange attractor in vectors)Most of the animations on this YouTube channel are made with Luxor."
},

{
    "location": "moreexamples/#Hipster-logo:-text-on-curves-1",
    "page": "More examples",
    "title": "Hipster logo: text on curves",
    "category": "section",
    "text": "using Luxor\nfunction hipster(fname, toptext, bottomtext)\n    Drawing(400, 350, fname)\n    origin()\n    rotate(pi/8)\n\n    circle(O, 135, :clip)\n    sethue(\"antiquewhite2\")\n    paint()\n\n    sethue(\"gray20\")\n    setline(3)\n    circle(O, 130, :stroke)\n    circle(O, 135, :stroke)\n    circle(O, 125, :fill)\n\n    sethue(\"antiquewhite2\")\n    circle(O, 85, :fill)\n\n    sethue(\"wheat\")\n    fontsize(20)\n    fontface(\"Helvetica-Bold\")\n    textcurvecentered(toptext, (3pi)/2, 100, O, clockwise=true,  letter_spacing=1, baselineshift = -4)\n    textcurvecentered(bottomtext, pi/2, 100, O, clockwise=false, letter_spacing=2, baselineshift = -15)\n\n    sethue(\"gray20\")\n    map(pt -> star(pt, 40, 3, 0.5, -pi/2, :fill), ngon(O, 40, 3, 0, vertices=true))\n    circle(O.x + 30, O.y - 55, 15, :fill)\n\n    # cheap weathered texture:\n    sethue(\"antiquewhite2\")\n    setline(0.4)\n    setdash(\"dot\")\n    for i in 1:500\n        line(randompoint(Point(-200, -350), Point(200, 350)),\n             randompoint(Point(-200, -350), Point(200, 350)),\n             :stroke)\n    end\n    finish()\nend\n\nhipster(\"assets/figures/textcurvecenteredexample.png\",\n    \"• DRAWN WITH LUXOR • \",\n    \"VECTOR GRAPHICS FOR JULIA\")\n\nnothing # hide(Image: text on a curve)"
},

{
    "location": "functionindex/#",
    "page": "Index",
    "title": "Index",
    "category": "page",
    "text": ""
},

{
    "location": "functionindex/#Index-1",
    "page": "Index",
    "title": "Index",
    "category": "section",
    "text": ""
},

]}
