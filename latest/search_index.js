var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Introduction to Luxor",
    "title": "Introduction to Luxor",
    "category": "page",
    "text": "DocTestSetup = quote\n    using Luxor\nend"
},

{
    "location": "index.html#Introduction-to-Luxor-1",
    "page": "Introduction to Luxor",
    "title": "Introduction to Luxor",
    "category": "section",
    "text": "Luxor is a Julia package for drawing simple static vector graphics. It provides basic drawing functions and utilities for working with shapes, polygons, clipping masks, PNG images, turtle graphics, animations, and shapefiles.The focus of Luxor is on simplicity and ease of use: it should be easier to use than plain Cairo.jl, with shorter names, fewer underscores, default contexts, and simplified functions.Luxor is thoroughly procedural and static: your code issues a sequence of simple graphics 'commands' until you've completed a drawing, then the results are saved into a PDF, PNG, SVG, or EPS file.There are some Luxor-related videos on YouTube.For interactive graphics, you'll find Gtk.jl, GLVisualize, and the Julia version of the Processing language worth investigating.Please submit issues and pull requests on GitHub. Original version by cormullion, much improved with contributions from the Julia community."
},

{
    "location": "index.html#Installation-and-basic-usage-1",
    "page": "Introduction to Luxor",
    "title": "Installation and basic usage",
    "category": "section",
    "text": "Install the package as follows:Pkg.add(\"Luxor\")Cairo.jl and Colors.jl will be installed if necessary.To use Luxor, type:using LuxorTo test:julia> @png juliacircles()"
},

{
    "location": "index.html#Documentation-1",
    "page": "Introduction to Luxor",
    "title": "Documentation",
    "category": "section",
    "text": "The documentation was built using Documenter.jl.println(\"Documentation built $(now()) with Julia $(VERSION).\") # hide"
},

{
    "location": "examples.html#",
    "page": "A few examples",
    "title": "A few examples",
    "category": "page",
    "text": ""
},

{
    "location": "examples.html#Examples-1",
    "page": "A few examples",
    "title": "Examples",
    "category": "section",
    "text": ""
},

{
    "location": "examples.html#The-obligatory-\"Hello-World\"-1",
    "page": "A few examples",
    "title": "The obligatory \"Hello World\"",
    "category": "section",
    "text": "Here's the \"Hello world\":(Image: \"Hello world\")using Luxor\nDrawing(1000, 1000, \"hello-world.png\")\norigin()\nbackground(\"black\")\nsethue(\"red\")\nfontsize(50)\ntext(\"hello world\")\nfinish()\npreview()Drawing(1000, 1000, \"hello-world.png\") defines the width, height, location, and type of the finished image. origin() moves the 0/0 point to the centre of the drawing surface (by default it's at the top left corner). Thanks to Colors.jl we can specify colors by name as well as by numeric value: background(\"black\") defines the color of the background of the drawing. text(\"helloworld\") draws the text. It's placed at the current 0/0 and left-justified if you don't specify otherwise. finish() completes the drawing and saves the image in the file. preview() tries to open the saved file using some other application (eg Preview on macOS).The macros @png, @svg, and @pdf provide shortcuts for making and previewing graphics without having to provide the set-up and finish instructions:# using Luxor\n\n@png begin\n        fontsize(50)\n        circle(O, 150, :stroke)\n        text(\"hello world\", halign=:center, valign=:middle)\n     end(Image: background)@svg begin\n    g = [Point(3x, 3y) for x in 1:10:100, y in 1:10:100]\n    circle.(g, 4, :fill)\n    label.(string.([(y - 1) * 10 + x for x in 1:10, y in 1:10]), :E, g)\nend(Image: background)"
},

{
    "location": "examples.html#The-Julia-logos-1",
    "page": "A few examples",
    "title": "The Julia logos",
    "category": "section",
    "text": "Luxor contains two functions that draw: the Julia logo, either in color or a single color; and the three Julia circles.using Luxor\nDrawing(600, 400, \"assets/figures/julia-logos.png\")\norigin()\nbackground(\"white\")\nfor theta in range(0, pi/8, 16)\n    gsave()\n    scale(0.25)\n    rotate(theta)\n    translate(250, 0)\n    randomhue()\n    julialogo(action=:fill, color=false)\n    grestore()\nend\n\ngsave()\nscale(0.3)\njuliacircles()\ngrestore()\n\ntranslate(200, -150)\nscale(0.3)\njulialogo()\nfinish()\nnothing # hide(Image: background)The gsave() function saves the current drawing parameters, and any subsequent changes such as the scale() and rotate() operations are discarded by the next grestore() function.Use the extension to specify the format: for example change \"julia-logos.png\" to \"julia-logos.svg\" or \"julia-logos.pdf\" or \"julia-logos.eps\", to produce different formats."
},

{
    "location": "examples.html#Something-a-bit-more-complicated:-a-Sierpinski-triangle-1",
    "page": "A few examples",
    "title": "Something a bit more complicated: a Sierpinski triangle",
    "category": "section",
    "text": "Here's a version of the Sierpinski recursive triangle, clipped to a circle.(Image: Sierpinski)# Subsequent examples will omit these setup and finishing functions:\n#\n# using Luxor, Colors\n# Drawing()\n# background(\"white\")\n# origin()\n\nfunction triangle(points, degree)\n    sethue(cols[degree])\n    poly(points, :fill)\nend\n\nfunction sierpinski(points, degree)\n    triangle(points, degree)\n    if degree > 1\n        p1, p2, p3 = points\n        sierpinski([p1, midpoint(p1, p2),\n                        midpoint(p1, p3)], degree-1)\n        sierpinski([p2, midpoint(p1, p2),\n                        midpoint(p2, p3)], degree-1)\n        sierpinski([p3, midpoint(p3, p2),\n                        midpoint(p1, p3)], degree-1)\n    end\nend\n\nfunction draw(n)\n    circle(O, 75, :clip)\n    my_points = ngon(O, 150, 3, -pi/2, vertices=true)\n    sierpinski(my_points, n)\nend\n\ndepth = 8 # 12 is ok, 20 is right out (on my computer, at least)\ncols = distinguishable_colors(depth)\ndraw(depth)\n\n# finish()\n# preview()The main type (apart from the Drawing) is the Point, an immutable composite type containing x and y fields."
},

{
    "location": "examples.html#Working-in-Jupyter-1",
    "page": "A few examples",
    "title": "Working in Jupyter",
    "category": "section",
    "text": "If you want to work interactively, you can use an environment such as a Jupyter notebook, and load Luxor at the start of a session. The first drawing will take a few seconds, because the Cairo graphics engine needs to warm up. Subsequent drawings are then much quicker. (This is true of much graphics and plotting work, of course. And if you're working in the REPL, after your first drawing subsequent drawings will be much quicker.)(Image: Jupyter)"
},

{
    "location": "examples.html#More-examples-1",
    "page": "A few examples",
    "title": "More examples",
    "category": "section",
    "text": ""
},

{
    "location": "examples.html#Maps-1",
    "page": "A few examples",
    "title": "Maps",
    "category": "section",
    "text": "Luxor can read polygons from shapefiles, so you can create simple maps. For example, here's part of a map of the world built from a single shapefile, together with the locations of most airports read in from a text file and overlaid.(Image: \"simple world map detail\")The latitude and longitude coordinates are converted directly to drawing coordinates. The latitude coordinates have to be negated because y-coordinates in Luxor typically increase down the page, whereas latitude values increase as you travel North.This is the full map:(Image: \"simple world map\")You'll need to install the Shapefile.jl package before running the code:using Shapefile, Luxor\ninclude(Pkg.dir(\"Luxor\") * \"/src/readshapefiles.jl\")\nfunction drawairportmap(outputfilename, countryoutlines, airportdata)\n    Drawing(4000, 2000, outputfilename)\n    origin()\n    scale(10, 10)\n    setline(1.0)\n    fontsize(0.075)\n    gsave()\n    setopacity(0.25)\n    for shape in countryoutlines.shapes\n        randomhue()\n        pgons, bbox = convert(Array{Luxor.Point, 1}, shape)\n        for pgon in pgons\n            poly(pgon, :fill)\n        end\n    end\n    grestore()\n    sethue(\"black\")\n    for airport in airportdata\n        city, country, lat, long = split(chomp(airport), \",\")\n        location = Point(parse(long), -parse(lat)) # flip y-coordinate\n        circle(location, .01, :fill)\n        text(string(city), location.x, location.y - 0.02)\n    end\n    finish()\n    preview()\nend\n\nworldshapefile = Pkg.dir(\"Luxor\") * \"/docs/src/assets/examples/outlines-of-world-countries.shp\"\nairportdata = readlines(Pkg.dir(\"Luxor\") * \"/docs/src/assets/examples/airports.csv\")\nworldshapes = open(worldshapefile) do f\n    read(f, Shapefile.Handle)\nend\ndrawairportmap(\"/tmp/airport-map.pdf\", worldshapes, airportdata)link to Julia source | link to PDF map"
},

{
    "location": "examples.html#Sector-chart-1",
    "page": "A few examples",
    "title": "Sector chart",
    "category": "section",
    "text": "(Image: \"benchmark sector chart\")Sector charts look cool but they aren't always good at their job. This chart takes the raw benchmark scores from the Julia website and tries to render them literally as radiating sectors. The larger the sector, the slower the performance, so it's difficult to see the Julia scores sometimes...!link to PDF original | link to Julia source"
},

{
    "location": "examples.html#Ampersands-1",
    "page": "A few examples",
    "title": "Ampersands",
    "category": "section",
    "text": "Here are a few ampersands collected together, mainly of interest to typomaniacs and fontophiles. It was necessary to vary the font size of each font, since they're naturally different.(Image: \"iloveampersands\")link to PDF original | link to Julia source"
},

{
    "location": "examples.html#Moon-phases-1",
    "page": "A few examples",
    "title": "Moon phases",
    "category": "section",
    "text": "Looking upwards again, this moon phase chart shows the calculated phase of the moon for every day in a year.(Image: \"benchmark sector chart\")link to PDF original | link to github repository"
},

{
    "location": "examples.html#Misc-images-1",
    "page": "A few examples",
    "title": "Misc images",
    "category": "section",
    "text": "Sometimes you just want to take a line for a walk:(Image: \"pointless\")"
},

{
    "location": "tutorial.html#",
    "page": "Tutorial",
    "title": "Tutorial",
    "category": "page",
    "text": ""
},

{
    "location": "tutorial.html#Tutorial-1",
    "page": "Tutorial",
    "title": "Tutorial",
    "category": "section",
    "text": "Experienced Julia users and programmers fluent in other languages and graphics systems should have no problem using Luxor by referring to the rest of the documentation. For others, here is a short tutorial to help you get started."
},

{
    "location": "tutorial.html#What-you-need-1",
    "page": "Tutorial",
    "title": "What you need",
    "category": "section",
    "text": "If you've already downloaded Julia, and have added the Luxor package successfully (like this):Pkg.add(\"Luxor\")then you're ready to start.Presumably you'll be working in a Jupyter notebook, or perhaps using the Atom/Juno editor/development environment. It's also possible to work in a text editor (make sure you know how to run a file of Julia code), or, at a pinch, you could use the Julia REPL directly.Ready? Let's begin. The goal of this tutorial is to do a bit of basic 'compass and ruler' Euclidean geometry, to introduce the basic concepts of Luxor drawings."
},

{
    "location": "tutorial.html#First-steps-1",
    "page": "Tutorial",
    "title": "First steps",
    "category": "section",
    "text": "Have you started a Julia session? Excellent. We'll have to load just one package for this tutorial:using LuxorHere's an easy shortcut for making drawings in Luxor. It's a Julia macro, and it's a good way to test that your system's working. Evaluate this code:@png begin\n    text(\"Hello world\")\n    circle(Point(0, 0), 200, :stroke)\nendusing Luxor\nDrawing(725, 600, \"assets/figures/tutorial-hello-world.png\")\nbackground(\"white\")\norigin()\nsethue(\"black\")\ntext(\"Hello world\")\ncircle(Point(0, 0), 200, :stroke)\nfinish()What happened? Can you see this image somewhere?(Image: point example)If you're using Juno, the image should appear in the Plots window. If you're working in a Jupyter notebook, the image should appear below the code. If you're using Julia in a terminal or text editor, the image should have opened up in some other application, or, at the very least, it should have been saved in your current working directory (as luxor-drawing.png). If nothing happened, or if something bad happened, we've got some set-up or installation issues probably unrelated to Luxor...Let's press on. The @png macro is an easy way to make a drawing; all it does is save a bit of typing. (The macro expands to enclose your drawing commands with calls to the Document(), origin(), finish(), and preview() functions.) There are also @svg and @pdf macros, which do a similar thing. PNGs and SVGs are good because they show up in Juno and Jupyter. PDF documents are often higher quality, but usually open up in a separate application.This example illustrates a few things about Luxor drawings:There are default values which you don't have to set if you don't want to (file names, colors, font sizes, etc).\nPositions on the drawing are specified with coordinates stored in the Point datatype, and you can sometimes omit positions altogether.\nThe text was placed at the origin point (0,0), and by default it's left aligned.\nThe circle wasn't filled, but stroked. We passed the :stroke symbol as an action to the circle() function. Many drawing functions expect some action, such as :fill or :stroke, and sometimes :clip or :fillstroke.\nDid the first drawing takes a few seconds to appear? The Cairo drawing engine has to warm up. Once it's running, it's much faster.Once more, with more black:@png begin\n    text(\"Hello again, world!\", Point(0, 250))\n    circle(Point(0, 0), 200, :fill)\nendusing Luxor\nDrawing(725, 500, \"assets/figures/tutorial-hello-world-2.png\")\nbackground(\"white\")\norigin()\nsethue(\"black\")\ntext(\"Hello again, world!\", Point(0, 250))\ncircle(Point(0, 0), 200, :fill)\nfinish()(Image: point example)"
},

{
    "location": "tutorial.html#Euclidean-eggs-1",
    "page": "Tutorial",
    "title": "Euclidean eggs",
    "category": "section",
    "text": "For the main section of this tutorial, we'll attempt to draw Euclid's egg, which involves a bit of geometry.For now, you can continue to store all the drawing instructions between the @png macro's begin and end markers. Technically, however, working like this at the top-level in Julia (ie without storing instructions in functions) isn't considered to be 'best practice'.@png beginTo start off, define the variable radius to hold a value of 80 units (there are 72 units in a traditional inch):    radius=80Select gray dotted lines. To specify a color you can supply RGB values or use the named colors that Colors.jl provides. gray0 is black, and gray100 is white.    setdash(\"dot\")\n    sethue(\"gray30\")Next, make two points, A and B, which will lie either side of the origin point. This line uses an array comprehension - notice the square brackets enclosing a for loop. x uses two values from the inner array, and a Point using each value is created and stored in a new array. It seems hardly worth doing for two points. But it shows how you can assign more than one variable at the same time, and also how to generate more than two points...    A, B = [Point(x, 0) for x in [-radius, radius]]With two points defined, draw a line from A to B, and \"stroke\" it.    line(A, B, :stroke)Draw a stroked circle too. The center of the circle is placed at the origin. You can use the letter 'O' as a short cut for Origin, ie the Point(0, 0).    circle(O, radius, :stroke)\nendusing Luxor\nDrawing(725, 300, \"assets/figures/tutorial-egg-1.png\")\nbackground(\"white\")\norigin()\nradius=80\nsetdash(\"dot\")\nsethue(\"gray30\")\nA, B = [Point(x, 0) for x in [-radius, radius]]\nline(A, B, :stroke)\ncircle(O, radius, :stroke)\nfinish()\nnothing\n(Image: point example)"
},

{
    "location": "tutorial.html#Labels-and-dots-1",
    "page": "Tutorial",
    "title": "Labels and dots",
    "category": "section",
    "text": "It's a good idea to label points in geometrical constructions, and to draw small dots to indicate their location clearly. For the latter task, small filled circles will do. For labels, there's a special label() function we can use, which positions a text string close to a point, using points of the compass, so :N places the label to the north of a position.Edit your previous code by adding instructions to draw some labels and circles:@png begin\n    radius=80\n    setdash(\"dot\")\n    sethue(\"gray30\")\n    A, B = [Point(x, 0) for x in [-radius, radius]]\n    line(A, B, :stroke)\n    circle(O, radius, :stroke)\n\n    label(\"A\", :NW, A)\n    label(\"O\", :N,  O)\n    label(\"B\", :NE, B)\n\n    circle.([A, O, B], 2, :fill)\n    circle.([A, B], 2radius, :stroke)\nendusing Luxor\nDrawing(725, 400, \"assets/figures/tutorial-egg-2.png\")\nbackground(\"white\")\norigin()\nradius=80\nsetdash(\"dot\")\nsethue(\"gray30\")\n\nA, B = [Point(x, 0) for x in [-radius, radius]]\nline(A, B, :stroke)\ncircle(O, radius, :stroke)\nlabel(\"A\", :NW, A)\nlabel(\"O\", :N, O)\nlabel(\"B\", :NE, B)\ncircle.([A, O, B], 2, :fill)\ncircle.([A, B], 2radius, :stroke)\nfinish()(Image: point example)While we could have drawn all the circles as usual, we've taken the opportunity to introduce a powerful Julia feature called 'broadcasting'. The dot ('.') just after the function name in the last two circle() function calls tells Julia to apply the function to all the arguments. We supplied an array of three points, and filled circles were placed at each one. Then we supplied an array of two points and stroked circles were placed there. Notice that we didn't have to supply an array of radius values or an array of actions — in each case Julia did the necessary broadcasting for us."
},

{
    "location": "tutorial.html#Intersect-this-1",
    "page": "Tutorial",
    "title": "Intersect this",
    "category": "section",
    "text": "We've now ready to tackle the job of finding the coordinates of the two points where two circles intersect. There's a Luxor function called intersectionlinecircle that finds the point or points where a line intersects a circle. So we can find the two points where one of the circles crosses an imaginary vertical line drawn through O. Because of the symmetry, we'll only have to do circle A.@png begin\n    # as before\n    radius=80\n    setdash(\"dot\")\n    sethue(\"gray30\")\n    A, B = [Point(x, 0) for x in [-radius, radius]]\n    line(A, B, :stroke)\n    circle(O, radius, :stroke)\n\n    label(\"A\", :NW, A)\n    label(\"O\", :N,  O)\n    label(\"B\", :NE, B)\n\n    circle.([A, O, B], 2, :fill)\n    circle.([A, B], 2radius, :stroke)\nThe intersectionlinecircle() takes four arguments: two points to define the line and a point/radius pair to define the circle. It returns the number of intersections (probably 0, 1, or 2), followed by the two points.The line is specified with two points with an x value of 0 and y values of ± twice the radius, written in Julia's math-friendly style. The circle is centered at A and has a radius of AB (which is 2radius). Assuming that there are two intersections, we feed these to circle() and label() for drawing and labeling using our new broadcasting superpowers.\n    nints, C, D =\n        intersectionlinecircle(Point(0, -2radius), Point(0, 2radius), A, 2radius)\n\n    if nints == 2\n        circle.([C, D], 2, :fill)\n        label.([\"D\", \"C\"], :N, [D, C])\n    end\n\nendusing Luxor\nDrawing(725, 400, \"assets/figures/tutorial-egg-3.png\")\nbackground(\"white\")\norigin()\nradius=80\nsetdash(\"dot\")\nsethue(\"gray30\")\n\nA, B = [Point(x, 0) for x in [-radius, radius]]\nline(A, B, :stroke)\ncircle(O, radius, :stroke)\nlabel(\"A\", :NW, A)\nlabel(\"O\", :N, O)\nlabel(\"B\", :NE, B)\ncircle.([A, O, B], 2, :fill)\ncircle.([A, B], 2radius, :stroke)\n\nnints, C, D = intersectionlinecircle(Point(0, -2radius), Point(0, 2radius), A, 2radius)\nif nints == 2\n    circle.([C, D], 2, :fill)\n    label.([\"D\", \"C\"], :N, [D, C])\nend\n\nfinish()(Image: point example)"
},

{
    "location": "tutorial.html#The-upper-circle-1",
    "page": "Tutorial",
    "title": "The upper circle",
    "category": "section",
    "text": "Now for the trickiest part of this construction: a small circle whose center point sits on top of the inner circle and that meets the two larger circles near the point D.Finding this new center point C1 is easy enough, because we can again use intersectionlinecircle() to find the point where the central circle crosses a line from O to D.Add some more lines to your code:@png begin\n\n    # ...\n\n    nints, C1, C2 = intersectionlinecircle(O, D, O, radius)\n    if nints == 2\n        circle(C1, 3, :fill)\n        label(\"C1\", :N, C1)\n    end\n\nendusing Luxor\nDrawing(725, 400, \"assets/figures/tutorial-egg-4.png\")\nbackground(\"white\")\norigin()\nradius=80\nsetdash(\"dot\")\nsethue(\"gray30\")\n\nA, B = [Point(x, 0) for x in [-radius, radius]]\nline(A, B, :stroke)\ncircle(O, radius, :stroke)\nlabel(\"A\", :NW, A)\nlabel(\"O\", :N, O)\nlabel(\"B\", :NE, B)\ncircle.([A, O, B], 2, :fill)\ncircle.([A, B], 2radius, :stroke)\n\nnints, C, D = intersectionlinecircle(Point(0, -2radius), Point(0, 2radius), A, 2radius)\nif nints == 2\n    circle.([C, D], 2, :fill)\n    label.([\"D\", \"C\"], :N, [D, C])\nend\n\nnints, C1, C2 = intersectionlinecircle(O, D, O, radius)\nif nints == 2\n    circle(C1, 3, :fill)\n    label(\"C1\", :N, C1)\nend\nfinish()(Image: point example)The two other points that define this circle lie on the intersections of the large circles with imaginary lines through points A and B passing through the center point C1.To find (and draw) these points is straightforward, but we'll mark these as intermediate for now, because there are four intersection points but we want just the two nearest the top:@png begin\n\n    # ...\n\n    nints, I3, I4 = intersectionlinecircle(A, C1, A, 2radius)\n    nints, I1, I2 = intersectionlinecircle(B, C1, B, 2radius)\n\n    circle.([I1, I2, I3, I4], 2, :fill)The norm() function returns the distance between two points, and it's simple enough to compare the distances.    if norm(C1, I1) < norm(C1, I2)\n       ip1 = I1\n    else\n       ip1 = I2\n    end\n    if norm(C1, I3) < norm(C1, I4)\n       ip2 = I3\n    else\n       ip2 = I4\n    end\n\n    label(\"ip1\", :N, ip1)\n    label(\"ip2\", :N, ip2)\n    circle(C1, norm(C1, ip1), :stroke)\n\nendusing Luxor\nDrawing(725, 400, \"assets/figures/tutorial-egg-5.png\")\nbackground(\"white\")\norigin()\nradius=80\nsetdash(\"dot\")\nsethue(\"gray30\")\n\nA, B = [Point(x, 0) for x in [-radius, radius]]\nline(A, B, :stroke)\ncircle(O, radius, :stroke)\nlabel(\"A\", :NW, A)\nlabel(\"O\", :N, O)\nlabel(\"B\", :NE, B)\ncircle.([A, O, B], 2, :fill)\ncircle.([A, B], 2radius, :stroke)\n\nnints, C, D = intersectionlinecircle(Point(0, -2radius), Point(0, 2radius), A, 2radius)\nif nints == 2\n    circle.([C, D], 2, :fill)\n    label.([\"D\", \"C\"], :N, [D, C])\nend\n\nnints, C1, C2 = intersectionlinecircle(O, D, O, radius)\nif nints == 2\n    circle(C1, 3, :fill)\n    label(\"C1\", :N, C1)\nend\n\n# finding two more points on the circumference\n\nnints, I3, I4 = intersectionlinecircle(A, C1, A, 2radius)\nnints, I1, I2 = intersectionlinecircle(B, C1, B, 2radius)\n\ncircle.([I1, I2, I3, I4], 2, :fill)\n\nif norm(C1, I1) < norm(C1, I2)\n    ip1 = I1\nelse\n   ip1 = I2\nend\nif norm(C1, I3) < norm(C1, I4)\n   ip2    = I3\nelse\n   ip2 = I4\nend\n\nlabel(\"ip1\", :N, ip1)\nlabel(\"ip2\", :N, ip2)\ncircle(C1, norm(C1, ip1), :stroke)\n\nfinish()(Image: point example)"
},

{
    "location": "tutorial.html#Eggs-at-the-ready-1",
    "page": "Tutorial",
    "title": "Eggs at the ready",
    "category": "section",
    "text": "We now know all the points on the egg's perimeter, and the centers of the circular arcs. To draw the outline, we'll use the arc2r() function four times. This function takes a center point and two points on a circular arc, plus an action.The shape consists of four curves, so we'll use the :path action. Instead of immediately drawing the shape, like the :stroke action would, this action adds a section to the current path (which is initially empty).@png begin\n\n    # ... as before\n    # Add this:\n\n    setline(5)\n    setdash(\"solid\")\n\n    arc2r(B, A, ip1, :path)\n    arc2r(C1, ip1, ip2, :path)\n    arc2r(A, ip2, B, :path)\n    arc2r(O, B, A, :path)Once we've added all four sections to the path we can stroke and fill it. If you want to use separate styles for the stroke and fill, you can use a 'preserve' version of the first action. This applies the action but keeps the path around for further actions.    strokepreserve()\n    setopacity(0.8)\n    sethue(\"ivory\")\n    fillpath()\nendusing Luxor\nDrawing(725, 400, \"assets/figures/tutorial-egg-6.png\")\nbackground(\"white\")\norigin()\nradius=80\nsetdash(\"dot\")\nsethue(\"gray30\")\n\nA, B = [Point(x, 0) for x in [-radius, radius]]\nline(A, B, :stroke)\ncircle(O, radius, :stroke)\nlabel(\"A\", :NW, A)\nlabel(\"O\", :N, O)\nlabel(\"B\", :NE, B)\ncircle.([A, O, B], 2, :fill)\ncircle.([A, B], 2radius, :stroke)\n\nnints, C, D =\n    intersectionlinecircle(Point(0, -2radius), Point(0, 2radius), A, 2radius)\nif nints == 2\n    circle.([C, D], 2, :fill)\n    label.([\"D\", \"C\"], :N, [D, C])\nend\n\nnints, C1, C2 = intersectionlinecircle(O, D, O, radius)\nif nints == 2\n    circle(C1, 3, :fill)\n    label(\"C1\", :N, C1)\nend\n\n# finding two more points on the circumference\n\nnints, I3, I4 = intersectionlinecircle(A, C1, A, 2radius)\nnints, I1, I2 = intersectionlinecircle(B, C1, B, 2radius)\n\ncircle.([I1, I2, I3, I4], 2, :fill)\n\nif norm(C1, I1) < norm(C1, I2)\n    ip1 = I1\nelse\n   ip1 = I2\nend\nif norm(C1, I3) < norm(C1, I4)\n   ip2    = I3\nelse\n   ip2 = I4\nend\n\nlabel(\"ip1\", :N, ip1)\nlabel(\"ip2\", :N, ip2)\ncircle(C1, norm(C1, ip1), :stroke)\n\nsetline(5)\nsetdash(\"solid\")\n\narc2r(B, A, ip1, :path)\narc2r(C1, ip1, ip2, :path)\narc2r(A, ip2, B, :path)\narc2r(O, B, A, :path)\nstrokepreserve()\nsetopacity(0.8)\nsethue(\"ivory\")\nfillpath()\nfinish()(Image: point example)"
},

{
    "location": "tutorial.html#Egg-stroke-1",
    "page": "Tutorial",
    "title": "Egg stroke",
    "category": "section",
    "text": "To be more generally useful, the above code can be boiled into a function.function egg(radius, action=:none)\n    A, B = [Point(x, 0) for x in [-radius, radius]]\n    nints, C, D =\n        intersectionlinecircle(Point(0, -2radius), Point(0, 2radius), A, 2radius)\n\n    flag, C1 = intersectionlinecircle(C, D, O, radius)\n    nints, I3, I4 = intersectionlinecircle(A, C1, A, 2radius)\n    nints, I1, I2 = intersectionlinecircle(B, C1, B, 2radius)\n\n    if norm(C1, I1) < norm(C1, I2)\n        ip1 = I1\n    else\n        ip1 = I2\n    end\n    if norm(C1, I3) < norm(C1, I4)\n        ip2 = I3\n    else\n        ip2 = I4\n    end\n\n    newpath()\n    arc2r(B, A, ip1, :path)\n    arc2r(C1, ip1, ip2, :path)\n    arc2r(A, ip2, B, :path)\n    arc2r(O, B, A, :path)\n    closepath()\n\n    do_action(action)\nendThis keeps all the intermediate code and calculations safely hidden away, and it's now possible to draw a Euclidean egg by calling egg(100, :stroke), for example, where 100 is the required radius, and :stroke is one of the available actions.(Of course, there's no error checking. This should be added if the function is to be used for any serious applications...!)Notice that this function doesn't define anything about what the shape looks like or where it's placed. When called, the function inherits a lot of the current drawing environment: scale, rotation, position, line thickness, color, style, and so on. This lets us write code like this:@png begin\n    setopacity(0.7)\n    for theta in range(0, pi/6, 12)\n        @layer begin\n            rotate(theta)\n            translate(0, -150)         \n            egg(50, :path)\n            setline(10)\n            randomhue()\n            fillpreserve()\n\n            randomhue()\n            strokepath()\n        end\n    end\nendusing Luxor\nsrand(42)\nDrawing(725, 500, \"assets/figures/tutorial-egg-7.png\")\nfunction egg(radius, action=:none)\n    A, B = [Point(x, 0) for x in [-radius, radius]]\n    nints, C, D =\n        intersectionlinecircle(Point(0, -2radius), Point(0, 2radius), A, 2radius)\n\n    flag, C1 = intersectionlinecircle(C, D, O, radius)\n    nints, I3, I4 = intersectionlinecircle(A, C1, A, 2radius)\n    nints, I1, I2 = intersectionlinecircle(B, C1, B, 2radius)\n\n    if norm(C1, I1) < norm(C1, I2)\n        ip1 = I1\n    else\n        ip1 = I2\n    end\n    if norm(C1, I3) < norm(C1, I4)\n        ip2 = I3\n    else\n        ip2 = I4\n    end\n\n    newpath()\n    arc2r(B, A, ip1, :path)\n    arc2r(C1, ip1, ip2, :path)\n    arc2r(A, ip2, B, :path)\n    arc2r(O, B, A, :path)\n    closepath()\n    do_action(action)\nend\nbackground(\"white\")\norigin()\nsetopacity(0.7)\nfor theta in range(0, pi/6, 12)\n    @layer begin\n        rotate(theta)\n        translate(0, -150)         \n        egg(50, :path)\n        setline(10)\n        randomhue()\n        fillpreserve()\n\n        randomhue()\n        strokepath()\n    end\nend\nfinish()(Image: point example)The loop runs 12 times, with theta increasing from 0 upwards in steps of π/6. But before each egg is drawn, the entire drawing environment is rotated to theta radians and then shifted along the y-axis away from the origin by -150 units (the y-axis values usually increase downwards, so when theta is 0 a shift of -150 looks like an upwards shift). The randomhue() function does what it says, and the egg() function is passed the :fill action and the radius.Notice that the four drawing instructions are encased in a @layer begin...end 'shell'. Any change made to the drawing environment inside this shell is discarded after each end. This allows us to make temporary changes to the scale and rotation, etc. and discard them easily once the shapes have been drawn.Rotations and angles are typically specified in radians. The positive x-axis (a line from the origin increasing in x) starts off heading due east from the origin, and positive angles are clockwise. So the second egg in the previous example was drawn after the axes were rotated π/6 radians clockwise.You can tell which egg was drawn first — it's overlapped on each side by subsequent eggs."
},

{
    "location": "tutorial.html#Thought-experiments-1",
    "page": "Tutorial",
    "title": "Thought experiments",
    "category": "section",
    "text": "What would happen if the translation was translate(0, 150) rather than translate(0, -150)?\nWhat would happen if the translation was translate(150, 0) rather than translate(0, -150)?\nWhat would happen if you translated each egg before you rotated the drawing environment?As well as stroke and fill actions, you can use the path as a clipping region (:clip), or as the basis for more shape shifting."
},

{
    "location": "tutorial.html#Polyeggs-1",
    "page": "Tutorial",
    "title": "Polyeggs",
    "category": "section",
    "text": "The egg() function creates a path and lets you apply an action to it. It's also possible to convert the path into a polygon (an array of points), which lets you do more things with it. The following code converts the egg's path into a polygon, and then moves every other point of the polygon halfway towards the centroid.@png begin\n    egg(160, :path)\n    pgon = first(pathtopoly())The pathtopoly() function converts the current path made by egg(160, :path) into a polygon. Those smooth curves have been approximated by a series of straight line segments. The first() function is used because pathtopoly() returns an array of one or more polygons (paths can consist of a series of loops), and we know that we need only the single path here.    pc = polycentroid(pgon)\n    circle(pc, 5, :fill)polycentroid() finds the centroid of the new polygon.This loop steps through the points and moves every odd-numbered one halfway towards the centroid. between() finds a point midway between two specified points. The poly() function draws the array of points.    for pt in 1:2:length(pgon)\n        pgon[pt] = between(pc, pgon[pt], 0.5)  \n    end\n    poly(pgon, :stroke)\nendusing Luxor\nDrawing(725, 500, \"assets/figures/tutorial-egg-8.png\")\nfunction egg(radius, action=:none)\n    A, B = [Point(x, 0) for x in [-radius, radius]]\n    nints, C, D =\n        intersectionlinecircle(Point(0, -2radius), Point(0, 2radius), A, 2radius)\n\n    flag, C1 = intersectionlinecircle(C, D, O, radius)\n    nints, I3, I4 = intersectionlinecircle(A, C1, A, 2radius)\n    nints, I1, I2 = intersectionlinecircle(B, C1, B, 2radius)\n\n    if norm(C1, I1) < norm(C1, I2)\n        ip1 = I1\n    else\n        ip1 = I2\n    end\n    if norm(C1, I3) < norm(C1, I4)\n        ip2    = I3\n    else\n        ip2 = I4\n    end\n\n    newpath()\n    arc2r(B, A, ip1, :path)\n    arc2r(C1, ip1, ip2, :path)\n    arc2r(A, ip2, B, :path)\n    arc2r(O, B, A, :path)\n    closepath()\n    do_action(action)\nend\nbackground(\"white\")\norigin()\negg(160, :path)\nsethue(\"black\")\npgon = first(pathtopoly())\npc = polycentroid(pgon)\ncircle(pc, 5, :fill)\n\nfor pt in 1:2:length(pgon)\n    pgon[pt] = between(pc, pgon[pt], 0.5)\nend\npoly(pgon, :stroke)\nfinish()(Image: point example)The uneven appearance of the interior points here looks to be a result of the default line join settings. Experiment with setlinejoin(\"round\") to see if this makes the geometry look tidier.For a final experiment with our egg() function, here's Luxor's offsetpoly() function struggling to draw around the spiky egg-based polygon.@png begin\n    egg(80, :path)\n    pgon = first(pathtopoly())\n    pc = polycentroid(pgon)\n    circle(pc, 5, :fill)\n\n    for pt in 1:2:length(pgon)\n        pgon[pt] = between(pc, pgon[pt], 0.8)  \n    end\n\n    for i in 30:-3:-8\n        randomhue()\n        op = offsetpoly(pgon, i)\n        poly(op, :stroke, close=true)\n    end\nendusing Luxor\nDrawing(725, 600, \"assets/figures/tutorial-egg-9.png\")\nfunction egg(radius, action=:none)\n    A, B = [Point(x, 0) for x in [-radius, radius]]\n    nints, C, D =\n        intersectionlinecircle(Point(0, -2radius), Point(0, 2radius), A, 2radius)\n\n    flag, C1 = intersectionlinecircle(C, D, O, radius)\n    nints, I3, I4 = intersectionlinecircle(A, C1, A, 2radius)\n    nints, I1, I2 = intersectionlinecircle(B, C1, B, 2radius)\n\n    if norm(C1, I1) < norm(C1, I2)\n        ip1 = I1\n    else\n        ip1 = I2\n    end\n    if norm(C1, I3) < norm(C1, I4)\n        ip2    = I3\n    else\n        ip2 = I4\n    end\n\n    newpath()\n    arc2r(B, A, ip1, :path)\n    arc2r(C1, ip1, ip2, :path)\n    arc2r(A, ip2, B, :path)\n    arc2r(O, B, A, :path)\n    closepath()\n    do_action(action)\nend\nbackground(\"white\")\norigin()\nsrand(42)\negg(80, :path)\npgon = first(pathtopoly())\npc = polycentroid(pgon)\ncircle(pc, 5, :fill)\n\nfor pt in 1:2:length(pgon)\n    pgon[pt] = between(pc, pgon[pt], 0.8)  \nend\n\nfor i in 30:-3:-8\n    randomhue()\n    op = offsetpoly(pgon, i)\n    poly(op, :stroke, close=true)\nend\n\nfinish()(Image: point example)The slight changes in the regularity of the points (originally created by the path-to-polygon conversion and the varying number of samples it made) are continually amplified in successive outlinings."
},

{
    "location": "tutorial.html#Clipping-1",
    "page": "Tutorial",
    "title": "Clipping",
    "category": "section",
    "text": "A useful feature of Luxor is that you can use shapes as a clipping mask. Graphics can be hidden when they stray outside the boundaries of the mask.In this example, the egg (assuming you're still in the same Julia session in which you've defined the egg() function) isn't drawn, but is defined to act as a clipping mask. Every graphic shape that you draw now is clipped where it crosses the mask. This is specified by the :clip action which is passed to the doaction() function at the end of the egg().Here, the graphics are provided by the ngon() function, which draws regular n-sided polygons.using Luxor, Colors\n@svg begin\n    setopacity(0.5)\n    egg(150, :clip)\n    @layer begin\n        for i in 360:-4:1\n            sethue(Colors.HSV(i, 1.0, 0.8))\n            rotate(pi/30)\n            ngon(O, i, 5, 0, :fill)\n        end\n    end\n    clipreset()\nendusing Luxor, Colors\nDrawing(725, 620, \"assets/figures/tutorial-egg-10.png\")\norigin()\nbackground(\"white\")\nfunction egg(radius, action=:none)\n    A, B = [Point(x, 0) for x in [-radius, radius]]\n    nints, C, D =\n        intersectionlinecircle(Point(0, -2radius), Point(0, 2radius), A, 2radius)\n\n    flag, C1 = intersectionlinecircle(C, D, O, radius)\n    nints, I3, I4 = intersectionlinecircle(A, C1, A, 2radius)\n    nints, I1, I2 = intersectionlinecircle(B, C1, B, 2radius)\n\n    if norm(C1, I1) < norm(C1, I2)\n        ip1 = I1\n    else\n        ip1 = I2\n    end\n    if norm(C1, I3) < norm(C1, I4)\n        ip2    = I3\n    else\n        ip2 = I4\n    end\n\n    newpath()\n    arc2r(B, A, ip1, :path)\n    arc2r(C1, ip1, ip2, :path)\n    arc2r(A, ip2, B, :path)\n    arc2r(O, B, A, :path)\n    closepath()\n    do_action(action)\nend\n\nsetopacity(0.5)\negg(150, :clip)\ngsave()\n    for i in 360:-4:1\n        sethue(Colors.HSV(i, 1.0, 0.8))\n        rotate(pi/30)\n        ngon(O, i, 5, 0, :fill)\n    end\ngrestore()\nclipreset()\nfinish()(Image: clip example)It's usually good practice to add a matching clipreset() after the clipping has been completed.Good luck with your explorations!"
},

{
    "location": "basics.html#",
    "page": "Basic concepts",
    "title": "Basic concepts",
    "category": "page",
    "text": "DocTestSetup = quote\n    using Luxor\n    end"
},

{
    "location": "basics.html#The-basics-1",
    "page": "Basic concepts",
    "title": "The basics",
    "category": "section",
    "text": "The underlying drawing model is that you make shapes, or add points to paths, and these are filled and/or stroked, using the current graphics state, which specifies colors, line thicknesses, and opacity. You can modify the current drawing environment by transforming/rotating/scaling it. This affects subsequent graphics but not the ones you've already drawn.Specify points (positions) using Point(x, y). The default origin is at the top left of the drawing area, but you can reposition it at any time. Many of the drawing functions have an action argument. This can be :nothing, :fill, :stroke, :fillstroke, :fillpreserve, :strokepreserve, :clip. The default is :nothing.The main defined types are Point, Drawing, and Tiler.  Drawing is how you create new drawings. You can divide up the drawing area into tiles, using Tiler, and define grids, using GridRect and GridHex."
},

{
    "location": "basics.html#Points-and-coordinates-1",
    "page": "Basic concepts",
    "title": "Points and coordinates",
    "category": "section",
    "text": "The Point type holds two coordinates, x and y. For example:julia> P = Point(12.0, 13.0)\nLuxor.Point(12.0, 13.0)\n\njulia> P.x\n12.0\n\njulia> P.y\n13.0Points are immutable, so you can't change P's x or y coordinate directly. But it's easy to make new points based on existing ones.Points can be added together:julia> Q = Point(4, 5)\nLuxor.Point(4.0, 5.0)\n\njulia> P + Q\nLuxor.Point(16.0, 18.0)You can add or multiply Points and scalars:julia> 10P\nLuxor.Point(120.0, 130.0)\n\njulia> P + 100\nLuxor.Point(112.0, 113.0)You can also make new points by mixing Points and tuples:julia> P + (10, 0)\nLuxor.Point(22.0, 13.0)\n\njulia> Q * (0.5, 0.5)\nLuxor.Point(2.0, 2.5)You can use the letter O as a shortcut to refer to the current Origin, Point(0, 0).using Luxor # hide\nDrawing(600, 300, \"assets/figures/point-ex.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"blue\") # hide\naxes()\nbox.([O + (i, 0) for i in linspace(0, 200, 5)], 20, 20, :stroke)\nfinish() # hide\nnothing # hide(Image: point example)Angles are usually supplied in radians, measured starting at the positive x-axis turning towards the positive y-axis (which usually points 'down' the page or canvas, so 'clockwise'). (Turtle graphics conventionally let you supply angles in degrees.)Coordinates are interpreted as PostScript points, where a point is 1/72 of an inch.Because Julia allows you to combine numbers and variables directly, you can supply units with dimensions and have them converted to points (assuming the current scale is 1:1):inch (in is unavailable, being used by for syntax)\ncm   (centimeters)\nmm   (millimeters)For example:rect(Point(20mm, 2cm), 5inch, (22/7)inch, :fill)"
},

{
    "location": "basics.html#Drawings-1",
    "page": "Basic concepts",
    "title": "Drawings",
    "category": "section",
    "text": ""
},

{
    "location": "basics.html#Luxor.Drawing",
    "page": "Basic concepts",
    "title": "Luxor.Drawing",
    "category": "Type",
    "text": "Create a new drawing, and optionally specify file type (PNG, PDF, SVG, or EPS) and dimensions.\n\nDrawing()\n\ncreates a drawing, defaulting to PNG format, default filename \"luxor-drawing.png\", default size 800 pixels square.\n\nYou can specify the dimensions, and assume the default output filename:\n\nDrawing(400, 300)\n\ncreates a drawing 400 pixels wide by 300 pixels high, defaulting to PNG format, default filename \"luxor-drawing.png\".\n\nDrawing(400, 300, \"my-drawing.pdf\")\n\ncreates a PDF drawing in the file \"my-drawing.pdf\", 400 by 300 pixels.\n\nDrawing(1200, 800, \"my-drawing.svg\")`\n\ncreates an SVG drawing in the file \"my-drawing.svg\", 1200 by 800 pixels.\n\nDrawing(width, height, surfacetype, [filename])\n\ncreates a new drawing of the given surface type (e.g. :svg, :png), storing the image only in memory if no filename is provided.\n\nDrawing(1200, 1200/golden, \"my-drawing.eps\")\n\ncreates an EPS drawing in the file \"my-drawing.eps\", 1200 wide by 741.8 pixels (= 1200 ÷ ϕ) high. Only for PNG files must the dimensions be integers.\n\nDrawing(\"A4\", \"my-drawing.pdf\")\n\ncreates a drawing in ISO A4 size (595 wide by 842 high) in the file \"my-drawing.pdf\". Other sizes available are:  \"A0\", \"A1\", \"A2\", \"A3\", \"A4\", \"A5\", \"A6\", \"Letter\", \"Legal\", \"A\", \"B\", \"C\", \"D\", \"E\". Append \"landscape\" to get the landscape version.\n\nDrawing(\"A4landscape\")\n\ncreates the drawing A4 landscape size.\n\nPDF files default to a white background, but PNG defaults to transparent, unless you specify one using background().\n\n\n\n"
},

{
    "location": "basics.html#Luxor.finish",
    "page": "Basic concepts",
    "title": "Luxor.finish",
    "category": "Function",
    "text": "finish()\n\nFinish the drawing, and close the file. You may be able to open it in an external viewer application with preview().\n\n\n\n"
},

{
    "location": "basics.html#Luxor.preview",
    "page": "Basic concepts",
    "title": "Luxor.preview",
    "category": "Function",
    "text": "preview()\n\nIf working in Jupyter (IJulia), display a PNG or SVG file in the notebook.\n\nIf working in Juno, display a PNG or SVG file in the Plot pane.\n\nOtherwise:\n\non macOS, open the file in the default application, which is probably the Preview.app for PNG and PDF, and Safari for SVG\non Unix, open the file with xdg-open\non Windows, pass the filename to explorer.\n\n\n\n"
},

{
    "location": "basics.html#Drawings-and-files-1",
    "page": "Basic concepts",
    "title": "Drawings and files",
    "category": "section",
    "text": "To create a drawing, and optionally specify the filename and type, and dimensions, use the Drawing constructor function.DrawingTo finish a drawing and close the file, use finish(), and, to launch an external application to view it, use preview().If you're using Jupyter (IJulia), preview() tries to display PNG and SVG files in the next notebook cell.(Image: jupyter)If you're using Juno, then PNG and SVG files should appear in the Plots pane.(Image: juno)finish\npreviewThe global variable currentdrawing (of type Drawing) stores some parameters related to the current drawing:julia> fieldnames(typeof(currentdrawing))\n10-element Array{Symbol,1}:\n:width\n:height\n:filename\n:surface\n:cr\n:surfacetype\n:redvalue\n:greenvalue\n:bluevalue\n:alpha"
},

{
    "location": "basics.html#Quick-drawings-with-macros-1",
    "page": "Basic concepts",
    "title": "Quick drawings with macros",
    "category": "section",
    "text": "The @svg, @png, and @pdf macros are designed to let you quickly create graphics without having to provide the usual boiler-plate functions. For example, the Julia code:@svg circle(O, 20, :stroke) 50 50expands toDrawing(50, 50, \"luxor-drawing.png\")\norigin()\nbackground(\"white\")\nsethue(\"black\")\ncircle(O, 20, :stroke)\nfinish()\npreview()They just save a bit of typing. You can omit the width and height (defaulting to 600 by 600). For multiple lines, use either:@svg begin\n        setline(10)\n        sethue(\"purple\")\n        circle(O, 20, :fill)\n     endor@svg (setline(10);\n      sethue(\"purple\");\n      circle(O, 20, :fill);\n     )"
},

{
    "location": "basics.html#Drawings-in-memory-1",
    "page": "Basic concepts",
    "title": "Drawings in memory",
    "category": "section",
    "text": "You can choose to store the drawing in memory. The advantage to this is that in-memory drawings are quicker, and can be passed as Julia data. This syntax for the Drawing() function:Drawing(width, height, surfacetype, [filename])lets you supply surfacetype as a symbol (:svg or :png). This creates a new drawing of the given surface type and stores the image only in memory if no filename is supplied. In a Jupyter notebook you can use Interact.jl to provide faster manipulations:using Interact\n\nfunction makecircle(r)\n    d = Drawing(300, 300, :svg)\n    sethue(\"black\")\n    origin()\n    setline(0.5)\n    hypotrochoid(150, 100, r, :stroke)\n    finish()\n    return d\nend\n\n@manipulate for r in 5:150\n    makecircle(r)\nend"
},

{
    "location": "basics.html#Luxor.background",
    "page": "Basic concepts",
    "title": "Luxor.background",
    "category": "Function",
    "text": "background(color)\n\nFill the canvas with a single color. Returns the (red, green, blue, alpha) values.\n\nExamples:\n\nbackground(\"antiquewhite\")\nbackground(\"ivory\")\n\nIf Colors.jl is installed:\n\nbackground(RGB(0, 0, 0))\nbackground(Luv(20, -20, 30))\n\nIf you don't specify a background color for a PNG drawing, the background will be transparent. You can set a partly or completely transparent background for PNG files by passing a color with an alpha value, such as this 'transparent black':\n\nbackground(RGBA(0, 0, 0, 0))\n\n\n\n"
},

{
    "location": "basics.html#Luxor.axes",
    "page": "Basic concepts",
    "title": "Luxor.axes",
    "category": "Function",
    "text": "Draw and label two axes lines starting at O, the current 0/0, and continuing out along the current positive x and y axes.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.origin",
    "page": "Basic concepts",
    "title": "Luxor.origin",
    "category": "Function",
    "text": "origin()\n\nReset the current matrix, and then set the 0/0 origin to the center of the drawing (otherwise it will stay at the top left corner, the default).\n\nYou can refer to the 0/0 point as O. (O = Point(0, 0)),\n\n\n\norigin(x, y)\n\nReset the current matrix, then move the 0/0 position relative to the top left corner of the drawing.\n\n\n\norigin(pt:Point)\n\nReset the current matrix, then move the 0/0 position to pt.\n\n\n\n"
},

{
    "location": "basics.html#The-drawing-surface-1",
    "page": "Basic concepts",
    "title": "The drawing surface",
    "category": "section",
    "text": "The origin (0/0) starts off at the top left: the x axis runs left to right across the page, and the y axis runs top to bottom down the page.The origin() function moves the 0/0 point to the center of the drawing. It's often convenient to do this at the beginning of a program. You can use functions like scale(), rotate(), and translate() to change the coordinate system.background() fills the drawing with a color, covering any previous contents. By default, PDF drawings have a white background, whereas PNG drawings have no background so that the background appears transparent in other applications. If there is a current clipping region, background() fills just that region. In the next example, the first background() fills the entire drawing with magenta, but the calls in the loop fill only the active clipping region, a tile defined by the Tiler iterator:using Luxor # hide\nDrawing(600, 400, \"assets/figures/backgrounds.png\") # hide\nbackground(\"magenta\")\norigin() # hide\ntiles = Tiler(600, 400, 5, 5, margin=30)\nfor (pos, n) in tiles\n    box(pos, tiles.tilewidth, tiles.tileheight, :clip)\n    background(randomhue()...)\n    clipreset()\nend\nfinish() # hide\nnothing # hide(Image: background)The axes() function draws a couple of lines and text labels in light gray to indicate the position and orientation of the current axes.using Luxor # hide\nDrawing(400, 400, \"assets/figures/axes.png\") # hide\nbackground(\"gray80\")\norigin()\naxes()\nfinish() # hide\nnothing # hide(Image: axes)background\naxes\norigin"
},

{
    "location": "basics.html#Luxor.Tiler",
    "page": "Basic concepts",
    "title": "Luxor.Tiler",
    "category": "Type",
    "text": "tiles = Tiler(areawidth, areaheight, nrows, ncols, margin=20)\n\nA Tiler is an iterator that, for each iteration, returns a tuple of:\n\nthe x/y point of the center of each tile in a set of tiles that divide up a rectangular space such as a page into rows and columns (relative to current 0/0)\nthe number of the tile\n\nareawidth and areaheight are the dimensions of the area to be tiled, nrows/ncols are the number of rows and columns required, and margin is applied to all four edges of the area before the function calculates the tile sizes required.\n\nTiler and Partition are similar:\n\nPartition lets you specify the width and height of a cell\nTiler lets you specify how many rows and columns of cells you want, and a margin\ntiles = Tiler(1000, 800, 4, 5, margin=20)   for (pos, n) in tiles       # the point pos is the center of the tile   end\n\nYou can access the calculated tile width and height like this:\n\ntiles = Tiler(1000, 800, 4, 5, margin=20)\nfor (pos, n) in tiles\n    ellipse(pos.x, pos.y, tiles.tilewidth, tiles.tileheight, :fill)\nend\n\nIt's sometimes useful to know which row and column you're currently on:\n\ntiles.currentrow\ntiles.currentcol\n\nshould have that information for you.\n\nTo use a Tiler to make grid points:\n\nfirst.(collect(Tiler(800, 800, 4, 4))\n\nwhich returns an array of points that are the center points of the grid.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.Partition",
    "page": "Basic concepts",
    "title": "Luxor.Partition",
    "category": "Type",
    "text": "p = Partition(areawidth, areaheight, tilewidth, tileheight)\n\nA Partition is an iterator that, for each iteration, returns a tuple of:\n\nthe x/y point of the center of each tile in a set of tiles that divide up a\n\nrectangular space such as a page into rows and columns (relative to current 0/0)\n\nthe number of the tile\n\nareawidth and areaheight are the dimensions of the area to be tiled, tilewidth/tileheight are the dimensions of the tiles.\n\nTiler and Partition are similar:\n\nPartition lets you specify the width and height of a cell\nTiler lets you specify how many rows and columns of cells you want, and a margin\n\ntiles = Partition(1200, 1200, 30, 30)\nfor (pos, n) in tiles\n    # the point pos is the center of the tile\nend\n\nYou can access the calculated tile width and height like this:\n\ntiles = Partition(1200, 1200, 30, 30)\nfor (pos, n) in tiles\n    ellipse(pos.x, pos.y, tiles.tilewidth, tiles.tileheight, :fill)\nend\n\nIt's sometimes useful to know which row and column you're currently on:\n\ntiles.currentrow\ntiles.currentcol\n\nshould have that information for you.\n\nUnless the tilewidth and tileheight are exact multiples of the area width and height, you'll see a border at the right and bottom where the tiles won't fit.\n\n\n\n"
},

{
    "location": "basics.html#Tiles-and-partitions-1",
    "page": "Basic concepts",
    "title": "Tiles and partitions",
    "category": "section",
    "text": "The drawing area (or any other area) can be divided into rectangular tiles (as rows and columns) using the Tiler iterator, which returns the center point and tile number of each tile in turn.In this example, every third tile is divided up into subtiles and colored:using Luxor # hide\nDrawing(400, 300, \"assets/figures/tiler.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsrand(1) # hide\nfontsize(20) # hide\ntiles = Tiler(400, 300, 4, 5, margin=5)\nfor (pos, n) in tiles\n    randomhue()\n    box(pos, tiles.tilewidth, tiles.tileheight, :fill)\n    if n % 3 == 0\n        gsave()\n        translate(pos)\n        subtiles = Tiler(tiles.tilewidth, tiles.tileheight, 4, 4, margin=5)\n        for (pos1, n1) in subtiles\n            randomhue()\n            box(pos1, subtiles.tilewidth, subtiles.tileheight, :fill)\n        end\n        grestore()\n    end\n    sethue(\"white\")\n    textcentered(string(n), pos + Point(0, 5))\nend\nfinish() # hide\nnothing # hide(Image: tiler)Tiler\nPartition"
},

{
    "location": "basics.html#Luxor.gsave",
    "page": "Basic concepts",
    "title": "Luxor.gsave",
    "category": "Function",
    "text": "gsave()\n\nSave the current color settings on the stack.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.grestore",
    "page": "Basic concepts",
    "title": "Luxor.grestore",
    "category": "Function",
    "text": "grestore()\n\nReplace the current graphics state with the one on top of the stack.\n\n\n\n"
},

{
    "location": "basics.html#Save-and-restore-1",
    "page": "Basic concepts",
    "title": "Save and restore",
    "category": "section",
    "text": "gsave() saves a copy of the current graphics settings (current axis rotation, position, scale, line and text settings, color, and so on). When the next grestore() is called, all changes you've made to the graphics settings will be discarded, and they'll return to how they were when you last used gsave(). gsave() and grestore() should always be balanced in pairs.As a convenient shorthand, you can use the macro @layer begin ... end to enclose graphics commands.gsave\ngrestore"
},

{
    "location": "simplegraphics.html#",
    "page": "Simple graphics",
    "title": "Simple graphics",
    "category": "page",
    "text": ""
},

{
    "location": "simplegraphics.html#Simple-graphics-1",
    "page": "Simple graphics",
    "title": "Simple graphics",
    "category": "section",
    "text": "In Luxor, there are different ways of working with graphical items. Some, such as lines, rectangles and circles, are drawn immediately (ie placed on the drawing and then \"forgotten\"). Others can be constructed and then converted to lists of points for further processing. For these, watch out for a vertices=true option."
},

{
    "location": "simplegraphics.html#Luxor.rect",
    "page": "Simple graphics",
    "title": "Luxor.rect",
    "category": "Function",
    "text": "rect(xmin, ymin, w, h, action)\n\nCreate a rectangle with one corner at (xmin/ymin) with width w and height h and then do an action.\n\nSee box() for more ways to do similar things, such as supplying two opposite corners, placing by centerpoint and dimensions.\n\n\n\nrect(cornerpoint, w, h, action)\n\nCreate a rectangle with one corner at cornerpoint with width w and height h and do an action.\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.box",
    "page": "Simple graphics",
    "title": "Luxor.box",
    "category": "Function",
    "text": "box(cornerpoint1, cornerpoint2, action=:nothing)\n\nCreate a rectangle between two points and do an action.\n\n\n\nbox(points::AbstractArray, action=:nothing)\n\nCreate a box/rectangle using the first two points of an array of Points to defined opposite corners.\n\n\n\nbox(pt::Point, width, height, action=:nothing; vertices=false)\n\nCreate a box/rectangle centered at point pt with width and height. Use vertices=true to return an array of the four corner points rather than draw the box.\n\n\n\nbox(x, y, width, height, action=:nothing)\n\nCreate a box/rectangle centered at point x/y with width and height.\n\n\n\nbox(x, y, width, height, cornerradius, action=:nothing)\n\nCreate a box/rectangle centered at point x/y with width and height. Round each corner by cornerradius.\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.polybbox",
    "page": "Simple graphics",
    "title": "Luxor.polybbox",
    "category": "Function",
    "text": "Find the bounding box of a polygon (array of points).\n\npolybbox(pointlist::AbstractArray)\n\nReturn the two opposite corners (suitable for box(), for example).\n\n\n\n"
},

{
    "location": "simplegraphics.html#Rectangles-and-boxes-1",
    "page": "Simple graphics",
    "title": "Rectangles and boxes",
    "category": "section",
    "text": "The simple rectangle and box shapes can be made in different ways.using Luxor # hide\nDrawing(400, 220, \"assets/figures/basicrects.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\naxes()\nsethue(\"red\")\nrect(O, 100, 100, :stroke)\nsethue(\"blue\")\nbox(O, 100, 100, :stroke)\nfinish() # hide\nnothing # hide(Image: rect vs box)Whereas rect() rectangles are positioned at one corner, a box made with box() can either be defined by its center and dimensions, or by two opposite corners.(Image: rects)If you want the coordinates of the corners of a box, use this form of box():box(centerpoint, width, height, vertices=true)rect\nbox\npolybboxFor regular polygons, see the next section on Polygons."
},

{
    "location": "simplegraphics.html#Luxor.circle",
    "page": "Simple graphics",
    "title": "Luxor.circle",
    "category": "Function",
    "text": "circle(x, y, r, action=:nothing)\n\nMake a circle of radius r centered at x/y.\n\naction is one of the actions applied by do_action, defaulting to :nothing. You can also use ellipse() to draw circles and place them by their centerpoint.\n\n\n\ncircle(pt, r, action)\n\nMake a circle centered at pt.\n\n\n\ncircle(pt1::Point, pt2::Point, action=:nothing)\n\nMake a circle that passes through two points that define the diameter:\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.ellipse",
    "page": "Simple graphics",
    "title": "Luxor.ellipse",
    "category": "Function",
    "text": "Make an ellipse, centered at xc/yc, fitting in a box of width w and height h.\n\nellipse(xc, yc, w, h, action=:none)\n\n\n\nMake an ellipse, centered at point c, with width w, and height h.\n\nellipse(cpt, w, h, action=:none)\n\n\n\nellipse(focus1::Point, focus2::Point, k, action=:none;\n        stepvalue=pi/100,\n        vertices=false,\n        reversepath=false)\n\nBuild a polygon approximation to an ellipse, given two points and a distance, k, which is the sum of the distances to the focii of any points on the ellipse (or the shortest length of string required to go from one focus to the perimeter and on to the other focus).\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.circlepath",
    "page": "Simple graphics",
    "title": "Luxor.circlepath",
    "category": "Function",
    "text": "circlepath(center::Point, radius, action=:none;\n    reversepath=false,\n    kappa = 0.5522847)\n\nDraw a circle using Bézier curves.\n\n\n\n"
},

{
    "location": "simplegraphics.html#Circles-and-ellipses-1",
    "page": "Simple graphics",
    "title": "Circles and ellipses",
    "category": "section",
    "text": "There are various ways to make circles, including by center and radius, or passing through two points:using Luxor # hide\nDrawing(400, 200, \"assets/figures/circles.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsetline(2) # hide\np1 = O\np2 = Point(100, 0)\nsethue(\"red\")\ncircle(p1, 40, :fill)\nsethue(\"green\")\ncircle(p1, p2, :stroke)\nsethue(\"black\")\narrow(O, Point(0, -40))\nmap(p -> circle(p, 4, :fill), [p1, p2])\nfinish() # hide\nnothing # hide(Image: circles)Or passing through three points. The center3pts() function returns the center position and radius of a circle passing through three points:using Luxor # hide\nDrawing(400, 200, \"assets/figures/center3.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsetline(3) # hide\nsethue(\"black\")\np1 = Point(0, -50)\np2 = Point(100, 0)\np3 = Point(0, 65)\nmap(p -> circle(p, 4, :fill), [p1, p2, p3])\nsethue(\"orange\") # hide\ncircle(center3pts(p1, p2, p3)..., :stroke)\nfinish() # hide\nnothing # hide(Image: center and radius of 3 points)With ellipse() you can place ellipses (and circles) by defining the center point and the width and height.using Luxor # hide\nDrawing(500, 300, \"assets/figures/ellipses.png\") # hide\nbackground(\"white\") # hide\nfontsize(11) # hide\nsrand(1) # hide\norigin() # hide\ntiles = Tiler(500, 300, 5, 5)\nwidth = 20\nheight = 25\nfor (pos, n) in tiles\n    randomhue()\n    ellipse(pos, width, height, :fill)\n    sethue(\"black\")\n    label = string(round(width/height, 2))\n    textcentered(label, pos.x, pos.y + 25)\n    width += 2\nend\nfinish() # hide\nnothing # hide(Image: ellipses)It's also possible to construct polygons that are approximations to ellipses with two focal points and a distance.using Luxor # hide\nDrawing(500, 450, \"assets/figures/ellipses_1.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"gray30\") # hide\nsetline(1) # hide\nf1 = Point(-100, 0)\nf2 = Point(100, 0)\nellipsepoly = ellipse(f1, f2, 170, :none, vertices=true)\n[ begin\n    setgray(rescale(c, 150, 1, 0, 1))\n    poly(offsetpoly(ellipsepoly, c), close=true, :fill);\n    rotate(pi/20)\n  end\n     for c in 150:-10:1 ]\nfinish() # hide\nnothing # hide(Image: more ellipses)circle\nellipsecirclepath() constructs a circular path from Bézier curves, which allows you to use circles as paths.using Luxor # hide\nDrawing(600, 250, \"assets/figures/circle-path.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"black\") # hide\nsetline(4)\ntiles = Tiler(600, 250, 1, 5)\nfor (pos, n) in tiles\n    randomhue()\n    circlepath(pos, tiles.tilewidth/2, :path)\n    newsubpath()\n    circlepath(pos, rand(5:tiles.tilewidth/2 - 1), :fill, reversepath=true)\nend\nfinish() # hide\nnothing # hide(Image: circles as paths)circlepath"
},

{
    "location": "simplegraphics.html#Luxor.sector",
    "page": "Simple graphics",
    "title": "Luxor.sector",
    "category": "Function",
    "text": "sector(centerpoint::Point, innerradius, outerradius, startangle, endangle, action:none)\n\nDraw an annular sector centered at centerpoint.\n\n\n\nDraw an annular sector centered at the origin.\n\n\n\nsector(centerpoint::Point, innerradius, outerradius, startangle, endangle, cornerradius, action:none)\n\nDraw an annular sector with rounded corners, basically a bent sausage shape, centered at centerpoint.\n\nTODO: The results aren't 100% accurate at the moment. There are small discontinuities where the curves join.\n\nThe cornerradius is reduced from the supplied value if neceesary to prevent overshoots.\n\n\n\nDraw an annular sector with rounded corners, centered at the current origin.\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.pie",
    "page": "Simple graphics",
    "title": "Luxor.pie",
    "category": "Function",
    "text": "pie(x, y, radius, startangle, endangle, action=:none)\n\nDraw a pie shape centered at x/y. Angles start at the positive x-axis and are measured clockwise.\n\n\n\npie(centerpoint, radius, startangle, endangle, action=:none)\n\nDraw a pie shape centered at centerpoint.\n\nAngles start at the positive x-axis and are measured clockwise.\n\n\n\nDraw a pie shape centered at the origin\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.spiral",
    "page": "Simple graphics",
    "title": "Luxor.spiral",
    "category": "Function",
    "text": "spiral(a, b, action::Symbol=:none;\n                 stepby = 0.01,\n                 period = 4pi,\n                 vertices = false,\n                 log=false)\n\nMake a spiral. The two primary parameters a and b determine the start radius, and the tightness.\n\nFor linear spirals (log=false), b values are:\n\nlituus: -2\n\nhyperbolic spiral: -1\n\nArchimedes' spiral: 1\n\nFermat's spiral: 2\n\nFor logarithmic spirals (log=true):\n\ngolden spiral: b = ln(phi)/ (pi/2) (about 0.30)\n\nValues of b around 0.1 produce tighter, staircase-like spirals.\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.squircle",
    "page": "Simple graphics",
    "title": "Luxor.squircle",
    "category": "Function",
    "text": "Make a squircle (basically a rectangle with rounded corners). Specify the center position, horizontal radius (distance from center to a side), and vertical radius (distance from center to top or bottom):\n\nsquircle(center::Point, hradius, vradius, action=:none; rt = 0.5, vertices=false)\n\nThe rt option defaults to 0.5, and gives an intermediate shape. Values less than 0.5 make the shape more square. Values above make the shape more round.\n\n\n\n"
},

{
    "location": "simplegraphics.html#More-curved-shapes:-sectors,-spirals,-and-squircles-1",
    "page": "Simple graphics",
    "title": "More curved shapes: sectors, spirals, and squircles",
    "category": "section",
    "text": "A sector (technically an \"annular sector\") has an inner and outer radius, as well as start and end angles.using Luxor # hide\nDrawing(600, 200, \"assets/figures/sector.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"tomato\")\nsector(50, 90, pi/2, 0, :fill)\nsethue(\"olive\")\nsector(Point(O.x + 200, O.y), 50, 90, 0, pi/2, :fill)\nfinish() # hide\nnothing # hide(Image: sector)You can also supply a value for a corner radius. The same sector is drawn but with rounded corners.using Luxor # hide\nDrawing(600, 200, \"assets/figures/sectorrounded.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"tomato\")\nsector(50, 90, pi/2, 0, 15, :fill)\nsethue(\"olive\")\nsector(Point(O.x + 200, O.y), 50, 90, 0, pi/2, 15, :fill)\nfinish() # hide\nnothing # hide(Image: sector)sectorA pie (or wedge) has start and end angles.using Luxor # hide\nDrawing(400, 300, \"assets/figures/pie.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"magenta\") # hide\npie(0, 0, 100, pi/2, pi, :fill)\nfinish() # hide\nnothing # hide(Image: pie)pieTo construct spirals, use the spiral() function. These can be drawn directly, or used as polygons. The default is to draw Archimedes (non-logarithmic) spirals.using Luxor # hide\nDrawing(500, 400, \"assets/figures/spiral.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"magenta\") # hide\n\nsp = spiral(4, 1, stepby=pi/24, period=12pi, vertices=true)\n\nfor i in 1:10\n    setgray(i/10)\n    setline(22-2i)\n    poly(sp, :stroke)\nend\n\nfinish() # hide\nnothing # hide(Image: spiral)Use the log=true option to draw logarithmic spirals.using Luxor # hide\nDrawing(500, 400, \"assets/figures/spiral-log.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"magenta\") # hide\n\nsp = spiral(2, .12, log=true, stepby=pi/24, period=12pi, vertices=true)\n\nfor i in 1:10\n    setgray(i/10)\n    setline(22-2i)\n    poly(sp, :stroke)\nend\n\nfinish() # hide\nnothing # hide(Image: spiral log)spiralA squircle is a cross between a square and a circle. You can adjust the squariness and circularity of it to taste by supplying a value for keyword rt:using Luxor # hide\nDrawing(600, 250, \"assets/figures/squircle.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nfontsize(20) # hide\nsetline(2)\ntiles = Tiler(600, 250, 1, 3)\nfor (pos, n) in tiles\n    sethue(\"lavender\")\n    squircle(pos, 80, 80, rt=[0.3, 0.5, 0.7][n], :fillpreserve)\n    sethue(\"grey20\")\n    strokepath()\n    textcentered(\"rt = $([0.3, 0.5, 0.7][n])\", pos)\nend\nfinish() # hide\nnothing # hide(Image: squircles)squircleTo draw a simple rounded rectangle, supply a corner radius:using Luxor # hide\nDrawing(600, 250, \"assets/figures/round-rect-1.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"black\") # hide\nsetline(4)\nbox(O, 200, 150, 10, :stroke)\nfinish() # hide\nnothing # hide(Image: rounded rect 1)Or you could smooth the corners of a box, like so:using Luxor # hide\nDrawing(600, 250, \"assets/figures/round-rect.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"black\") # hide\nsetline(4)\npolysmooth(box(O, 200, 150, vertices=true), 10, :stroke)\nfinish() # hide\nnothing # hide(Image: rounded rect)"
},

{
    "location": "simplegraphics.html#Luxor.move",
    "page": "Simple graphics",
    "title": "Luxor.move",
    "category": "Function",
    "text": "move(x, y)\nmove(pt)\n\nMove to a point.\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.rmove",
    "page": "Simple graphics",
    "title": "Luxor.rmove",
    "category": "Function",
    "text": "rmove(x, y)\n\nMove by an amount from the current point. Move relative to current position by x and y:\n\nMove relative to current position by the pt's x and y:\n\nrmove(pt)\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.newpath",
    "page": "Simple graphics",
    "title": "Luxor.newpath",
    "category": "Function",
    "text": "newpath()\n\nCreate a new path. This is Cairo's new_path() function.\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.newsubpath",
    "page": "Simple graphics",
    "title": "Luxor.newsubpath",
    "category": "Function",
    "text": "newsubpath()\n\nAdd a new subpath to the current path. This is Cairo's new_sub_path() function. It can be used for example to make holes in shapes.\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.closepath",
    "page": "Simple graphics",
    "title": "Luxor.closepath",
    "category": "Function",
    "text": "closepath()\n\nClose the current path. This is Cairo's close_path() function.\n\n\n\n"
},

{
    "location": "simplegraphics.html#Paths-and-positions-1",
    "page": "Simple graphics",
    "title": "Paths and positions",
    "category": "section",
    "text": "A path is a sequence of lines and curves. You can add lines and curves to the current path, then use closepath() to join the last point to the first.A path can have subpaths, created withnewsubpath(), which can form holes.There is a 'current position' which you can set with move(), and can use implicitly in functions like line(), text(), arc() and curve().move\nrmove\nnewpath\nnewsubpath\nclosepath"
},

{
    "location": "simplegraphics.html#Luxor.line",
    "page": "Simple graphics",
    "title": "Luxor.line",
    "category": "Function",
    "text": "line(x, y)\nline(x, y, :action)\nline(pt)\n\nCreate a line from the current position to the x/y position and optionally apply an action:\n\n\n\nline(pt1::Point, pt2::Point, action=:nothing)\n\nMake a line between two points, pt1 and pt2 and do an action.\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.rline",
    "page": "Simple graphics",
    "title": "Luxor.rline",
    "category": "Function",
    "text": "rline(x, y)\nrline(x, y, :action)\nrline(pt)\n\nCreate a line relative to the current position to the x/y position and optionally apply an action:\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.rule",
    "page": "Simple graphics",
    "title": "Luxor.rule",
    "category": "Function",
    "text": "rule(pos::Point, theta=0.0)\n\nDraw a line across the entire drawing passing through pos, at an angle of theta to the x-axis. Returns the two points.\n\nThe end points are not calculated exactly, they're just a long way apart.\n\n\n\n"
},

{
    "location": "simplegraphics.html#Lines-1",
    "page": "Simple graphics",
    "title": "Lines",
    "category": "section",
    "text": "Use line() and rline() to draw straight lines.line\nrlineYou can use rule() to draw a line across the entire drawing through a point, at an angle to the current x-axis.using Luxor # hide\nDrawing(700, 200, \"assets/figures/rule.png\") # hide\nbackground(\"white\") # hide\nsethue(\"black\") # hide\nsetline(1) # hide\n\ny = 10\nfor x in logspace(0, 2.75, 40)\n    circle(Point(x, y), 2, :fill)\n    rule(Point(x, y), -pi/2)\n    y += 2\nend\n\nfinish() # hide\nnothing # hide(Image: arc)rule"
},

{
    "location": "simplegraphics.html#Luxor.arc",
    "page": "Simple graphics",
    "title": "Luxor.arc",
    "category": "Function",
    "text": "Add an arc to the current path from angle1 to angle2 going clockwise.\n\narc(xc, yc, radius, angle1, angle2, action=:nothing)\n\nAngles are defined relative to the x-axis, positive clockwise.\n\n\n\nArc with centerpoint.\n\narc(centerpoint::Point, radius, angle1, angle2, action=:nothing)\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.arc2r",
    "page": "Simple graphics",
    "title": "Luxor.arc2r",
    "category": "Function",
    "text": "  arc2r(c1::Point, p2::Point, p3::Point, action=:nothing)\n\nMake a circular arc centered at c1 that starts at p2 and ends at p3, going clockwise.\n\nc1-p2 really determines the radius. If p3 doesn't lie on the circular path, it will be used only as an indication of the arc's length, rather than its position.\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.carc",
    "page": "Simple graphics",
    "title": "Luxor.carc",
    "category": "Function",
    "text": "Add an arc to the current path from angle1 to angle2 going counterclockwise.\n\ncarc(xc, yc, radius, angle1, angle2, action=:nothing)\n\nAngles are defined relative to the x-axis, positive clockwise.\n\n\n\nAdd an arc centered at centerpoint to the current path from angle1 to angle2 going counterclockwise.\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.carc2r",
    "page": "Simple graphics",
    "title": "Luxor.carc2r",
    "category": "Function",
    "text": "carc2r(c1::Point, p2::Point, p3::Point, action=:nothing)\n\nMake a circular arc centered at c1 that starts at p2 and ends at p3, going counterclockwise.\n\nc1-p2 really determines the radius. If p3 doesn't lie on the circular path, it will be used only as an indication of the arc's length, rather than its position.\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.curve",
    "page": "Simple graphics",
    "title": "Luxor.curve",
    "category": "Function",
    "text": "Add a Bézier curve.\n\n curve(x1, y1, x2, y2, x3, y3)\n curve(p1, p2, p3)\n\nThe spline starts at the current position, finishing at x3/y3 (p3), following two  control points x1/y1 (p1) and x2/y2 (p2)\n\n\n\n"
},

{
    "location": "simplegraphics.html#Arcs-and-curves-1",
    "page": "Simple graphics",
    "title": "Arcs and curves",
    "category": "section",
    "text": "There are a few standard arc-drawing commands, such as curve(), arc(), carc(), and arc2r().curve() constructs Bézier curves from control points:using Luxor # hide\nDrawing(500, 275, \"assets/figures/curve.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\n\nsetline(.5)\npt1 = Point(0, -125)\npt2 = Point(200, 125)\npt3 = Point(200, -125)\n\nsethue(\"red\")\nmap(p -> circle(p, 4, :fill), [O, pt1, pt2, pt3])\n\nline(O, pt1, :stroke)\nline(pt2, pt3, :stroke)\n\nsethue(\"black\")\nsetline(3)\n\nmove(O)\ncurve(pt1, pt2, pt3)\nstrokepath()\nfinish()  # hide\nnothing # hide(Image: curve)arc2r() draws a circular arc that joins two points:using Luxor # hide\nDrawing(700, 200, \"assets/figures/arc2r.png\") # hide\norigin() # hide\nsrand(42) # hide\nbackground(\"white\") # hide\ntiles = Tiler(700, 200, 1, 6)\nfor (pos, n) in tiles\n    c1, pt2, pt3 = ngon(pos, rand(10:50), 3, rand(0:pi/12:2pi), vertices=true)\n    sethue(\"black\")\n    map(pt -> circle(pt, 4, :fill), [c1, pt3])\n    sethue(\"red\")\n    circle(pt2, 4, :fill)\n    randomhue()\n    arc2r(c1, pt2, pt3, :stroke)\nend\nfinish() # hide\nnothing # hide(Image: arc)arc\narc2r\ncarc\ncarc2r\ncurve"
},

{
    "location": "simplegraphics.html#Luxor.midpoint",
    "page": "Simple graphics",
    "title": "Luxor.midpoint",
    "category": "Function",
    "text": "midpoint(p1, p2)\n\nFind the midpoint between two points.\n\n\n\nmidpoint(a)\n\nFind midpoint between the first two elements of an array of points.\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.between",
    "page": "Simple graphics",
    "title": "Luxor.between",
    "category": "Function",
    "text": "between(p1::Point, p2::Point, x)\nbetween((p1::Point, p2::Point), x)\n\nFind the point between point p1 and point p2 for x, where x is typically between 0 and 1, so these two should be equivalent:\n\nbetween(p1, p2, 0.5)\n\nand\n\nmidpoint(p1, p2)\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.center3pts",
    "page": "Simple graphics",
    "title": "Luxor.center3pts",
    "category": "Function",
    "text": "center3pts(a::Point, b::Point, c::Point)\n\nFind the radius and center point for three points lying on a circle.\n\nreturns (centerpoint, radius) of a circle. Then you can use circle() to place a circle, or arc() to draw an arc passing through those points.\n\nIf there's no such circle, then you'll see an error message in the console and the function returns (Point(0,0), 0).\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.intersection",
    "page": "Simple graphics",
    "title": "Luxor.intersection",
    "category": "Function",
    "text": "intersection(p1::Point, p2::Point, p3::Point, p4::Point;\n    commonendpoints = false,\n    crossingonly = false,\n    collinearintersect = false)\n\nFind intersection of two lines p1-p2 and p3-p4\n\nThis returns a tuple: (boolean, point(x, y)).\n\nKeyword options and default values:\n\ncrossingonly = false\n\nIf crossingonly = true, lines must actually cross. The function returns (false, intersectionpoint) if the lines don't actually cross, but would eventually intersect at intersectionpoint if continued beyond their current endpoints.\n\nIf false, the function returns (true, Point(x, y)) if the lines intersect somewhere eventually at intersectionpoint.\n\ncommonendpoints = false\n\nIf commonendpoints= true, will return (false, Point(0, 0)) if the lines share a common end point (because that's not so much an intersection, more a meeting).\n\nFunction returns (false, Point(0, 0)) if the lines are undefined.\n\nIf you want collinear points to be considered to intersect, set collinearintersect to true, although it defaults to false.\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.intersectionlinecircle",
    "page": "Simple graphics",
    "title": "Luxor.intersectionlinecircle",
    "category": "Function",
    "text": "intersectionlinecircle(p1::Point, p2::Point, cpoint::Point, r)\n\nFind the intersection points of a line (extended through points p1 and p2) and a circle.\n\nReturn a tuple of (n, pt1, pt2)\n\nwhere\n\nn is the number of intersections, 0, 1, or 2\npt1 is first intersection point, or Point(0, 0) if none\npt2 is the second intersection point, or Point(0, 0) if none\n\nThe calculated intersection points won't necessarily lie on the line segment between p1 and p2.\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.intersection2circles",
    "page": "Simple graphics",
    "title": "Luxor.intersection2circles",
    "category": "Function",
    "text": "intersection2circles(pt1, r1, pt2, r2)\n\nFind the area of intersection between two circles, the first centered at pt1 with radius r1, the second centered at pt2 with radius r2.\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.intersectioncirclecircle",
    "page": "Simple graphics",
    "title": "Luxor.intersectioncirclecircle",
    "category": "Function",
    "text": "intersectioncirclecircle(cp1, r1, cp2, r2)\n\nFind the two points where two circles intersect, if they do. The first circle is centered at cp1 with radius r1, and the second is centered at cp1 with radius r1.\n\nReturns\n\n(flag, ip1, ip2)\n\nwhere flag is a Boolean true if the circles intersect at the points ip1 and ip2. If the circles don't intersect at all, or one is completely inside the other, flag is false and the points are both Point(0, 0).\n\nUse intersection2circles() to find the area of two overlapping circles.\n\nIn the pure world of maths, it must be possible that two circles 'kissing' only have a single intersection point. At present, this unromantic function reports that two kissing circles have no intersection points.\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.bboxesintersect",
    "page": "Simple graphics",
    "title": "Luxor.bboxesintersect",
    "category": "Function",
    "text": "bboxesintersect(acorner1::Point, acorner2::Point, bcorner1::Point, bcorner2::Point)\n\nReturn true if the two bounding boxes defined by acorner1:acorner2 and bcorner1:bcorner2 intersect.\n\nEach pair of points is assumed to define the two opposite corners of a bounding box.\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.getnearestpointonline",
    "page": "Simple graphics",
    "title": "Luxor.getnearestpointonline",
    "category": "Function",
    "text": "getnearestpointonline(pt1::Point, pt2::Point, startpt::Point)\n\nGiven a line from pt1 to pt2, and startpt is the start of a perpendicular heading to meet the line, at what point does it hit the line?\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.pointlinedistance",
    "page": "Simple graphics",
    "title": "Luxor.pointlinedistance",
    "category": "Function",
    "text": "pointlinedistance(p::Point, a::Point, b::Point)\n\nFind the distance between a point p and a line between two points a and b.\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.slope",
    "page": "Simple graphics",
    "title": "Luxor.slope",
    "category": "Function",
    "text": "slope(pointA::Point, pointB::Point)\n\nFind angle of a line starting at pointA and ending at pointB.\n\nReturn a value between 0 and 2pi. Value will be relative to the current axes.\n\nslope(O, Point(0, 100)) |> rad2deg # y is positive down the page\n90.0\n\nslope(Point(0, 100), O) |> rad2deg\n270.0\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.perpendicular",
    "page": "Simple graphics",
    "title": "Luxor.perpendicular",
    "category": "Function",
    "text": "perpendicular(p::Point)\n\nReturns point Point(p.y, -p.x).\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.@polar",
    "page": "Simple graphics",
    "title": "Luxor.@polar",
    "category": "Macro",
    "text": "@polar (p)\n\nConvert a tuple of two numbers to a Point of x, y Cartesian coordinates.\n\n@polar (10, pi/4)\n@polar [10, pi/4]\n\nproduces\n\nLuxor.Point(7.0710678118654755,7.071067811865475)\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.polar",
    "page": "Simple graphics",
    "title": "Luxor.polar",
    "category": "Function",
    "text": "polar(r, theta)\n\nConvert point in polar form (radius and angle) to a Point.\n\npolar(10, pi/4)\n\nproduces\n\nLuxor.Point(7.071067811865475,7.0710678118654755)\n\n\n\n"
},

{
    "location": "simplegraphics.html#Geometry-tools-1",
    "page": "Simple graphics",
    "title": "Geometry tools",
    "category": "section",
    "text": "You can find the midpoint between two points using midpoint().The following code places a small pentagon (using ngon()) at the midpoint of each side of a larger pentagon:using Luxor # hide\nDrawing(700, 220, \"assets/figures/midpoint.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"red\")\nngon(O, 100, 5, 0, :stroke)\n\nsethue(\"darkgreen\")\np5 = ngon(O, 100, 5, 0, vertices=true)\n\nfor i in eachindex(p5)\n    pt1 = p5[mod1(i, 5)]\n    pt2 = p5[mod1(i + 1, 5)]\n    ngon(midpoint(pt1, pt2), 20, 5, 0, :fill)\nend\nfinish() # hide\nnothing # hide(Image: arc)A more general function, between(), finds for a value x between 0 and 1 the corresponding point on a line defined by two points. So midpoint(p1, p2) and between(p1, p2, 0.5) should return the same point.using Luxor # hide\nDrawing(700, 150, \"assets/figures/betweenpoint.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"red\")\np1 = Point(-150, 0)\np2 = Point(150, 40)\nline(p1, p2)\nstrokepath()\nfor i in -0.5:0.1:1.5\n    randomhue()\n    circle(between(p1, p2, i), 5, :fill)\nend\nfinish() # hide\nnothing # hide(Image: arc)Values less than 0.0 and greater than 1.0 appear to work well too, placing the point on the line if extended.midpoint\nbetweencenter3pts() finds the radius and center point of a circle passing through three points which you can then use with functions such as circle() or arc2r().center3ptsintersection() finds the intersection of two lines.using Luxor # hide\nDrawing(700, 220, \"assets/figures/intersection.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"darkmagenta\") # hide\npt1, pt2, pt3, pt4 = ngon(O, 100, 5, vertices=true)\ntext.([\"pt 1\", \"pt 2\", \"pt 3\", \"pt 4\"], [pt1, pt2, pt3, pt4])\nline(pt1, pt2, :stroke)\nline(pt4, pt3, :stroke)\n\nflag, ip =  intersection(pt1, pt2, pt4, pt3)\nif flag\n    circle(ip, 5, :fill)\nend\nfinish() # hide\nnothing # hide(Image: arc)intersectionlinecircle() finds the intersection of a line and a circle. There can be 0, 1, or 2 intersection points.using Luxor # hide\nDrawing(700, 220, \"assets/figures/intersection_line_circle.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"chocolate2\") # hide\nl1 = Point(-100.0, -75.0)\nl2 = Point(300.0, 100.0)\nrad = 100\ncpoint = Point(0, 0)\nline(l1, l2, :stroke)\nsethue(\"darkgreen\") # hide\ncircle(cpoint, rad, :stroke)\nnints, ip1, ip2 =  intersectionlinecircle(l1, l2, cpoint, rad)\nsethue(\"black\")\nif nints == 2\n    circle(ip1, 8, :stroke)\n    circle(ip2, 8, :stroke)\nend\nfinish() # hide\nnothing # hide(Image: arc)intersection2circles() finds the area of the intersection of two circles, and `intersectioncirclecircle() finds the points where they cross.This example shows the areas of two circles, and the area of their intersection.using Luxor # hide\nDrawing(700, 310, \"assets/figures/intersection2circles.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nfontsize(14) # hide\nsethue(\"black\") # hide\n\nc1 = (O, 150)\nc2 = (O + (100, 0), 150)\n\ncircle(c1... , :stroke)\ncircle(c2... , :stroke)\n\nsethue(\"purple\")\ncircle(c1... , :clip)\ncircle(c2... , :fill)\nclipreset()\n\nsethue(\"black\")\n\ntext(string(150^2 * pi |> round), c1[1] - (125, 0))\ntext(string(150^2 * pi |> round), c2[1] + (100, 0))\nsethue(\"white\")\ntext(string(intersection2circles(c1..., c2...) |> round),\n     midpoint(c1[1], c2[1]), halign=:center)\n\nsethue(\"red\")\nflag, C, D = intersectioncirclecircle(c1..., c2...)\nif flag\n    circle.([C, D], 2, :fill)\nend\nfinish() # hide\nnothing # hide(Image: intersection of two circles)intersection\nintersectionlinecircle\nintersection2circles\nintersectioncirclecircle\nbboxesintersectgetnearestpointonline() finds perpendiculars.using Luxor # hide\nDrawing(700, 200, \"assets/figures/perpendicular.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"darkmagenta\") # hide\nend1, end2, pt3 = ngon(O, 100, 3, vertices=true)\nmap(pt -> circle(pt, 5, :fill), [end1, end2, pt3])\nline(end1, end2, :stroke)\narrow(pt3, getnearestpointonline(end1, end2, pt3))\nfinish() # hide\nnothing # hide(Image: arc)getnearestpointonline\npointlinedistance\nslope\nperpendicular\n@polar\npolar"
},

{
    "location": "simplegraphics.html#Luxor.arrow",
    "page": "Simple graphics",
    "title": "Luxor.arrow",
    "category": "Function",
    "text": "arrow(startpoint::Point, endpoint::Point;\n    linewidth = 1.0,\n    arrowheadlength = 10,\n    arrowheadangle = pi/8)\n\nDraw a line between two points and add an arrowhead at the end. The arrowhead length will be the length of the side of the arrow's head, and the arrowhead angle is the angle between the sloping side of the arrowhead and the arrow's shaft.\n\nArrows don't use the current linewidth setting (setline()), and defaults to 1, but you can specify another value. It doesn't need stroking/filling, the shaft is stroked and the head filled with the current color.\n\n\n\narrow(centerpos::Point, radius, startangle, endangle;\n    linewidth = 1.0,\n    arrowheadlength = 10,\n    arrowheadangle = pi/8)\n\nDraw a curved arrow, an arc centered at centerpos starting at startangle and ending at endangle with an arrowhead at the end. Angles are measured clockwise from the positive x-axis.\n\nArrows don't use the current linewidth setting (setline()); you can specify the linewidth.\n\n\n\n"
},

{
    "location": "simplegraphics.html#Arrows-1",
    "page": "Simple graphics",
    "title": "Arrows",
    "category": "section",
    "text": "You can draw lines or arcs with arrows at the end with arrow(). For straight arrows, supply the start and end points. For arrows as circular arcs, you provide center, radius, and start and finish angles. You can optionally provide dimensions for the arrowheadlength and arrowheadangle of the tip of the arrow (angle in radians between side and center). The default line weight is 1.0, equivalent to setline(1)), but you can specify another.using Luxor # hide\nDrawing(400, 250, \"assets/figures/arrow.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"steelblue4\") # hide\nsetline(2) # hide\narrow(O, Point(0, -65))\narrow(O, Point(100, -65), arrowheadlength=20, arrowheadangle=pi/4, linewidth=.3)\narrow(O, 100, pi, pi/2, arrowheadlength=25,   arrowheadangle=pi/12, linewidth=1.25)\nfinish() # hide\nnothing # hide(Image: arrows)arrow"
},

{
    "location": "simplegraphics.html#Luxor.julialogo",
    "page": "Simple graphics",
    "title": "Luxor.julialogo",
    "category": "Function",
    "text": "julialogo(;action=:fill, color=true)\n\nDraw the Julia logo. The default action is to fill the logo and use the colors:\n\njulialogo()\n\nIf color is false, the logo will use the current color, and the dots won't be colored in the usual way.\n\nThe logo's dimensions are about 330 wide and 240 high, and the 0/0 point is at the bottom left corner. To place the logo by locating its center, do this:\n\ngsave()\ntranslate(-165, -120)\njulialogo() # locate center at 0/0\ngrestore()\n\nTo use the logo as a clipping mask:\n\njulialogo(action=:clip)\n\n(In this case the color setting is automatically ignored.)\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.juliacircles",
    "page": "Simple graphics",
    "title": "Luxor.juliacircles",
    "category": "Function",
    "text": "juliacircles(radius=100)\n\nDraw the three Julia circles in color centered at the origin.\n\nThe distance of the centers of the circles from the origin is radius. The optional keyword arguments outercircleratio (default 0.75) and innercircleratio (default 0.65) control the radius of the individual colored circles relative to the radius. So you can get relatively smaller or larger circles by adjusting the ratios.\n\n\n\n"
},

{
    "location": "simplegraphics.html#Julia-graphics-1",
    "page": "Simple graphics",
    "title": "Julia graphics",
    "category": "section",
    "text": "A couple of functions in Luxor provide you with instant access to the Julia logo, and the three colored circles:using Luxor # hide\nDrawing(750, 250, \"assets/figures/julia-logo.png\")  # hide\nsrand(42) # hide\norigin()  # hide\nbackground(\"white\") # hide\n\nfor (pos, n) in Tiler(750, 250, 1, 2)\n    gsave()\n    translate(pos - Point(150, 100))\n    if n == 1\n        julialogo()\n    elseif n == 2\n        julialogo(action=:clip)\n        for i in 1:500\n            gsave()\n            translate(rand(0:400), rand(0:250))\n            juliacircles(10)\n            grestore()\n        end\n        clipreset()\n    end\n    grestore()\nend\nfinish() # hide\nnothing # hide(Image: get path)julialogo\njuliacircles"
},

{
    "location": "simplegraphics.html#Miscellaneous-1",
    "page": "Simple graphics",
    "title": "Miscellaneous",
    "category": "section",
    "text": ""
},

{
    "location": "simplegraphics.html#Luxor.hypotrochoid",
    "page": "Simple graphics",
    "title": "Luxor.hypotrochoid",
    "category": "Function",
    "text": "hypotrochoid(R, r, d, action=:none;\n        stepby=0.01,\n        period=0,\n        vertices=false)\n\nMake a hypotrochoid with short line segments. (Like a Spirograph.) The curve is traced by a point attached to a circle of radius r rolling around the inside  of a fixed circle of radius R, where the point is a distance d from  the center of the interior circle. Things get interesting if you supply non-integral values.\n\nSpecial cases include the hypocycloid, if d = r, and an ellipse, if R = 2r.\n\nstepby, the angular step value, controls the amount of detail, ie the smoothness of the polygon,\n\nIf period is not supplied, or 0, the lowest period is calculated for you.\n\nThe function can return a polygon (a list of points), or draw the points directly using the supplied action. If the points are drawn, the function returns a tuple showing how many points were drawn and what the period was (as a multiple of pi).\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.epitrochoid",
    "page": "Simple graphics",
    "title": "Luxor.epitrochoid",
    "category": "Function",
    "text": "epitrochoid(R, r, d, action=:none;\n        stepby=0.01,\n        period=0,\n        vertices=false)\n\nMake a epitrochoid with short line segments. (Like a Spirograph.) The curve is traced by a point attached to a circle of radius r rolling around the outside of a fixed circle of radius R, where the point is a distance d from the center of the circle. Things get interesting if you supply non-integral values.\n\nstepby, the angular step value, controls the amount of detail, ie the smoothness of the polygon.\n\nIf period is not supplied, or 0, the lowest period is calculated for you.\n\nThe function can return a polygon (a list of points), or draw the points directly using the supplied action. If the points are drawn, the function returns a tuple showing how many points were drawn and what the period was (as a multiple of pi).\n\n\n\n"
},

{
    "location": "simplegraphics.html#Hypotrochoids-1",
    "page": "Simple graphics",
    "title": "Hypotrochoids",
    "category": "section",
    "text": "hypotrochoid() makes hypotrochoids. The result is a polygon. You can either draw it directly, or pass it on for further polygon fun, as here, which uses offsetpoly() to trace round it a few times.using Luxor # hide\nDrawing(500, 300, \"assets/figures/hypotrochoid.png\")  # hide\norigin()\nbackground(\"grey15\")\nsethue(\"antiquewhite\")\nsetline(1)\np = hypotrochoid(100, 25, 55, :stroke, stepby=0.01, vertices=true)\nfor i in 0:3:15\n    poly(offsetpoly(p, i), :stroke, close=true)\nend\nfinish() # hide\nnothing # hide(Image: hypotrochoid)There's a matching epitrochoid() function.hypotrochoid\nepitrochoid"
},

{
    "location": "simplegraphics.html#Luxor.GridRect",
    "page": "Simple graphics",
    "title": "Luxor.GridRect",
    "category": "Type",
    "text": "GridRect(startpoint, xspacing, yspacing, width, height)\n\nDefine a rectangular grid, to start at startpoint and proceed along the x-axis in steps of xspacing, then along the y-axis in steps of yspacing.\n\nGridRect(startpoint, xspacing=100.0, yspacing=100.0, width=1200.0, height=1200.0)\n\nFor a column, set the xspacing to 0:\n\ngrid = GridRect(O, 0, 40)\n\nTo get points from the grid, use nextgridpoint(g::Grid).\n\njulia> grid = GridRect(O, 0, 40);\njulia> nextgridpoint(grid)\nLuxor.Point(0.0,0.0)\n\njulia> nextgridpoint(grid)\nLuxor.Point(0.0,40.0)\n\nWhen you run out of grid points, you'll wrap round and start again.\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.GridHex",
    "page": "Simple graphics",
    "title": "Luxor.GridHex",
    "category": "Type",
    "text": "GridHex(startpoint, radius, width=1200.0, height=1200.0)\n\nDefine a hexagonal grid, to start at startpoint and proceed along the x-axis and then along the y-axis, radius is the radius of a circle that encloses each hexagon. The distance in x between the centers of successive hexagons is:\n\nfracsqrt(3) radius2\n\nTo get the next point from the grid, use nextgridpoint(g::Grid).\n\nWhen you run out of grid points, you'll wrap round and start again.\n\n\n\n"
},

{
    "location": "simplegraphics.html#Luxor.nextgridpoint",
    "page": "Simple graphics",
    "title": "Luxor.nextgridpoint",
    "category": "Function",
    "text": "nextgridpoint(g::GridRect)\n\nReturns the next available (or even the first) grid point of a grid.\n\n\n\nnextgridpoint(g::GridHex)\n\nReturns the next available grid point of a hexagonal grid.\n\n\n\n"
},

{
    "location": "simplegraphics.html#Grids-1",
    "page": "Simple graphics",
    "title": "Grids",
    "category": "section",
    "text": "If you have to position items regularly, you might find a use for a grid. Luxor provides a simple grid utility. Grids are lazy: they'll supply the next point on the grid when you ask for it.Define a rectangular grid with GridRect, and a hexagonal grid with GridHex. Get the next grid point from a grid with nextgridpoint(grid).using Luxor # hide\nDrawing(700, 250, \"assets/figures/grids.png\")  # hide\nbackground(\"white\") # hide\nfontsize(14) # hide\ntranslate(50, 50) # hide\ngrid = GridRect(O, 40, 80, (10 - 1) * 40)\nfor i in 1:20\n    randomhue()\n    p = nextgridpoint(grid)\n    squircle(p, 20, 20, :fill)\n    sethue(\"white\")\n    text(string(i), p, halign=:center)\nend\nfinish() # hide\nnothing # hide(Image: grids)using Luxor # hide\nDrawing(700, 400, \"assets/figures/grid-hex.png\")  # hide\nbackground(\"white\") # hide\nfontsize(22) # hide\ntranslate(100, 100) # hide\nradius = 70\ngrid = GridHex(O, radius, 600)\n\nfor i in 1:15\n    randomhue()\n    p = nextgridpoint(grid)\n    ngon(p, radius-5, 6, pi/2, :fillstroke)\n    sethue(\"white\")\n    text(string(i), p, halign=:center)\nend\nfinish() # hide\nnothing # hide(Image: grids)GridRect\nGridHex\nnextgridpoint"
},

{
    "location": "simplegraphics.html#Luxor.cropmarks",
    "page": "Simple graphics",
    "title": "Luxor.cropmarks",
    "category": "Function",
    "text": "cropmarks(center, width, height)\n\nDraw cropmarks (also known as trim marks).\n\n\n\n"
},

{
    "location": "simplegraphics.html#Cropmarks-1",
    "page": "Simple graphics",
    "title": "Cropmarks",
    "category": "section",
    "text": "If you want cropmarks (aka trim marks), use the cropmarks() function, supplying the centerpoint, followed by the width and height:cropmarks(O, 1200, 1600)\ncropmarks(O, paper_sizes[\"A0\"]...)using Luxor # hide\nDrawing(700, 250, \"assets/figures/cropmarks.png\")  # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"red\")\nbox(O, 150, 150, :stroke)\ncropmarks(O, 150, 150)\nfinish() # hide\nnothing # hide(Image: cropmarks)cropmarks"
},

{
    "location": "simplegraphics.html#Luxor.bars",
    "page": "Simple graphics",
    "title": "Luxor.bars",
    "category": "Function",
    "text": "bars(values::AbstractArray;\n        yscale = 100,\n        xwidth = 10,\n        labels = true,\n        barfunction = f,\n        labelfunction = f,\n    )\n\nDraw some bars where each bar is the height of a value in the array.\n\nTo control the drawing of the text and bars, define functions that process the end points:\n\nmybarfunction(bottom::Point, top::Point, value; extremes=[a, b])\n\nmylabelfunction(bottom::Point, top::Point, value; extremes=[a, b])\n\nand pass them like this:\n\nbars(v, yscale=10, xwidth=10, barfunction=mybarfunction)\nbars(v, xwidth=15, yscale=10, labelfunction=mylabelfunction)\n\nTo suppress the text labels, use optional keyword labels=false.\n\n\n\n"
},

{
    "location": "simplegraphics.html#Bars-1",
    "page": "Simple graphics",
    "title": "Bars",
    "category": "section",
    "text": "For simple bars, use the bars() function, supplying an array of numbers:using Luxor # hide\nDrawing(800, 250, \"assets/figures/bars.png\")  # hide\norigin() # hide\nbackground(\"white\") # hide\nfontsize(7)\nsethue(\"black\")\ntranslate(-350, 0) # hide\nv = rand(-100:100, 60)\nbars(v)\nfinish() # hide\nnothing # hide(Image: bars)To change the way the bars and labels are drawn, define some functions and pass them as keyword arguments to bars():using Luxor # hide\nDrawing(800, 350, \"assets/figures/bars1.png\")  # hide\norigin() # hide\nbackground(\"white\") # hide\nfontsize(8) # hide\nsethue(\"black\") # hide\ntranslate(-350, 0) # hide\n\nfunction mybarfunction(low::Point, high::Point, value; extremes=[0, 1])\n    @layer begin\n        sethue(rescale(value, extremes[1], extremes[2], 0, 1), 0.0, 1.0)\n        circle(high, 8, :fill)\n        setline(1)\n        sethue(\"blue\")\n        line(low, high + (0, 8), :stroke)\n        sethue(\"white\")\n        text(string(value), high, halign=:center, valign=:middle)\n    end\nend\n\nfunction mylabelfunction(low::Point, high::Point, value; extremes=[0, 1])\n    @layer begin\n        translate(low)\n        rotate(-pi/2)\n        text(string(value,\"/\", extremes[2]), O - (10, 0), halign=:right, valign=:middle)\n    end\nend\n\nv = rand(1:200, 30)\nbars(v, xwidth=25, barfunction=mybarfunction, labelfunction=mylabelfunction)\n\nfinish() # hide\nnothing # hide(Image: bars 1)bars"
},

{
    "location": "colors-styles.html#",
    "page": "Colors and styles",
    "title": "Colors and styles",
    "category": "page",
    "text": ""
},

{
    "location": "colors-styles.html#Colors-and-styles-1",
    "page": "Colors and styles",
    "title": "Colors and styles",
    "category": "section",
    "text": ""
},

{
    "location": "colors-styles.html#Luxor.sethue",
    "page": "Colors and styles",
    "title": "Luxor.sethue",
    "category": "Function",
    "text": "sethue(\"black\")\nsethue(0.3, 0.7, 0.9)\nsetcolor(sethue(\"red\")..., .2)\n\nSet the color without changing opacity.\n\nsethue() is like setcolor(), but we sometimes want to change the current color without changing alpha/opacity. Using sethue() rather than setcolor() doesn't change the current alpha opacity.\n\nSee also setcolor.\n\n\n\nsethue(col::ColorTypes.Colorant)\n\nSet the color without changing the current alpha/opacity:\n\n\n\nsethue(0.3, 0.7, 0.9)\n\nSet the color's r, g, b values. Use setcolor(r,g,b,a) to set transparent colors.\n\n\n\nsethue((r, g, b))\n\nSet the color to the tuple's values.\n\n\n\nsethue((r, g, b, a))\n\nSet the color to the tuple's values.\n\n\n\n"
},

{
    "location": "colors-styles.html#Luxor.setcolor",
    "page": "Colors and styles",
    "title": "Luxor.setcolor",
    "category": "Function",
    "text": "setcolor(\"gold\")\nsetcolor(\"darkturquoise\")\n\nSet the current color to a named color. This use the definitions in Colors.jl to convert a string to RGBA eg setcolor(\"gold\") or \"green\", \"darkturquoise\", \"lavender\", etc. The list is at Colors.color_names.\n\nUse sethue() for changing colors without changing current opacity level.\n\nsethue() and setcolor() return the three or four values that were used:\n\njulia> setcolor(sethue(\"red\")..., .8)\n\n(1.0,0.0,0.0,0.8)\n\njulia> sethue(setcolor(\"red\")[1:3]...)\n\n(1.0,0.0,0.0)\n\nYou can also do:\n\nusing Colors\nsethue(colorant\"red\")\n\nSee also setcolor.\n\n\n\nsetcolor(r, g, b)\nsetcolor(r, g, b, alpha)\nsetcolor(color)\nsetcolor(col::ColorTypes.Colorant)\nsetcolor(sethue(\"red\")..., .2)\n\nSet the current color.\n\nExamples:\n\nsetcolor(convert(Colors.HSV, Colors.RGB(0.5, 1, 1)))\nsetcolor(.2, .3, .4, .5)\nsetcolor(convert(Colors.HSV, Colors.RGB(0.5, 1, 1)))\n\nfor i in 1:15:360\n   setcolor(convert(Colors.RGB, Colors.HSV(i, 1, 1)))\n   ...\nend\n\nSee also sethue.\n\n\n\nsetcolor((r, g, b))\n\nSet the color to the tuple's values.\n\n\n\nsetcolor((r, g, b, a))\n\nSet the color to the tuple's values.\n\n\n\n"
},

{
    "location": "colors-styles.html#Luxor.setgray",
    "page": "Colors and styles",
    "title": "Luxor.setgray",
    "category": "Function",
    "text": "setgray(n)\nsetgrey(n)\n\nSet the color to a gray level of n, where n is between 0 and 1.\n\n\n\n"
},

{
    "location": "colors-styles.html#Luxor.setopacity",
    "page": "Colors and styles",
    "title": "Luxor.setopacity",
    "category": "Function",
    "text": "setopacity(alpha)\n\nSet the current opacity to a value between 0 and 1. This modifies the alpha value of the current color.\n\n\n\n"
},

{
    "location": "colors-styles.html#Luxor.randomhue",
    "page": "Colors and styles",
    "title": "Luxor.randomhue",
    "category": "Function",
    "text": "randomhue()\n\nSet a random hue, without changing the current alpha opacity.\n\n\n\n"
},

{
    "location": "colors-styles.html#Luxor.randomcolor",
    "page": "Colors and styles",
    "title": "Luxor.randomcolor",
    "category": "Function",
    "text": "randomcolor()\n\nSet a random color. This may change the current alpha opacity too.\n\n\n\n"
},

{
    "location": "colors-styles.html#Luxor.setblend",
    "page": "Colors and styles",
    "title": "Luxor.setblend",
    "category": "Function",
    "text": "setblend(blend)\n\nStart using the named blend for filling graphics.\n\nThis aligns the original coordinates of the blend definition with the current axes.\n\n\n\n"
},

{
    "location": "colors-styles.html#Color-and-opacity-1",
    "page": "Colors and styles",
    "title": "Color and opacity",
    "category": "section",
    "text": "For color definitions and conversions, you can use Colors.jl.setcolor() and sethue() apply a single solid or transparent color to shapes. setblend() applies a smooth transition between two or more colors. setmesh applies a color mesh.The difference between the setcolor() and sethue() functions is that sethue() is independent of alpha opacity, so you can change the hue without changing the current opacity value.Named colors, such as \"gold\", or \"lavender\", can be found in Colors.color_names. This code shows the first 625 colors.using Luxor, Colors # hide\nDrawing(800, 500, \"assets/figures/colors.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nfontsize(5) # hide\ncols = collect(Colors.color_names)\ntiles = Tiler(800, 500, 25, 25)\nfor (pos, n) in tiles\n    sethue(cols[n][1])\n    box(pos, tiles.tilewidth, tiles.tileheight, :fill)\n    clab = convert(Lab, parse(Colorant, cols[n][1]))\n    labelbrightness = 100 - clab.l\n    sethue(convert(RGB, Lab(labelbrightness, clab.b, clab.a)))\n    text(string(cols[n][1]), pos, halign=:center)\nend\nfinish() # hide\nnothing # hide(Image: line endings)Some fiddling with Lab colors adjusts the label color to make it stand out against the background.sethue\nsetcolor\nsetgray\nsetopacity\nrandomhue\nrandomcolor\nsetblend"
},

{
    "location": "colors-styles.html#Luxor.setline",
    "page": "Colors and styles",
    "title": "Luxor.setline",
    "category": "Function",
    "text": "setline(n)\n\nSet the line width.\n\n\n\n"
},

{
    "location": "colors-styles.html#Luxor.setlinecap",
    "page": "Colors and styles",
    "title": "Luxor.setlinecap",
    "category": "Function",
    "text": "setlinecap(s)\n\nSet the line ends. s can be \"butt\" (the default), \"square\", or \"round\".\n\n\n\n"
},

{
    "location": "colors-styles.html#Luxor.setlinejoin",
    "page": "Colors and styles",
    "title": "Luxor.setlinejoin",
    "category": "Function",
    "text": "setlinejoin(\"miter\")\nsetlinejoin(\"round\")\nsetlinejoin(\"bevel\")\n\nSet the line join style, or how to render the junction of two lines when stroking.\n\n\n\n"
},

{
    "location": "colors-styles.html#Luxor.setdash",
    "page": "Colors and styles",
    "title": "Luxor.setdash",
    "category": "Function",
    "text": "setlinedash(\"dot\")\n\nSet the dash pattern to one of: \"solid\", \"dotted\", \"dot\", \"dotdashed\", \"longdashed\", \"shortdashed\", \"dash\", \"dashed\", \"dotdotdashed\", \"dotdotdotdashed\"\n\n\n\n"
},

{
    "location": "colors-styles.html#Luxor.fillstroke",
    "page": "Colors and styles",
    "title": "Luxor.fillstroke",
    "category": "Function",
    "text": "fillstroke()\n\nFill and stroke the current path.\n\n\n\n"
},

{
    "location": "colors-styles.html#Luxor.strokepath",
    "page": "Colors and styles",
    "title": "Luxor.strokepath",
    "category": "Function",
    "text": "strokepath()\n\nStroke the current path with the current line width, line join, line cap, and dash settings. The current path is then cleared.\n\n\n\n"
},

{
    "location": "colors-styles.html#Luxor.fillpath",
    "page": "Colors and styles",
    "title": "Luxor.fillpath",
    "category": "Function",
    "text": "fillpath()\n\nFill the current path according to the current settings. The current path is then cleared.\n\n\n\n"
},

{
    "location": "colors-styles.html#Luxor.strokepreserve",
    "page": "Colors and styles",
    "title": "Luxor.strokepreserve",
    "category": "Function",
    "text": "strokepreserve()\n\nStroke the current path with current line width, line join, line cap, and dash settings, but then keep the path current.\n\n\n\n"
},

{
    "location": "colors-styles.html#Luxor.fillpreserve",
    "page": "Colors and styles",
    "title": "Luxor.fillpreserve",
    "category": "Function",
    "text": "fillpreserve()\n\nFill the current path with current settings, but then keep the path current.\n\n\n\n"
},

{
    "location": "colors-styles.html#Luxor.paint",
    "page": "Colors and styles",
    "title": "Luxor.paint",
    "category": "Function",
    "text": "paint()\n\nPaint the current clip region with the current settings.\n\n\n\n"
},

{
    "location": "colors-styles.html#Luxor.do_action",
    "page": "Colors and styles",
    "title": "Luxor.do_action",
    "category": "Function",
    "text": "do_action(action)\n\nThis is usually called by other graphics functions. Actions for graphics commands include :fill, :stroke, :clip, :fillstroke, :fillpreserve, :strokepreserve, :none, and :path.\n\n\n\n"
},

{
    "location": "colors-styles.html#Line-styles-1",
    "page": "Colors and styles",
    "title": "Line styles",
    "category": "section",
    "text": "There are set- functions for controlling subsequent lines' width, end shapes, join behavior, and dash patterns:using Luxor # hide\nDrawing(400, 250, \"assets/figures/line-ends.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\ntranslate(-100, -60) # hide\nfontsize(18) # hide\nfor l in 1:3\n    sethue(\"black\")\n    setline(20)\n    setlinecap([\"butt\", \"square\", \"round\"][l])\n    textcentred([\"butt\", \"square\", \"round\"][l], 80l, 80)\n    setlinejoin([\"round\", \"miter\", \"bevel\"][l])\n    textcentred([\"round\", \"miter\", \"bevel\"][l], 80l, 120)\n    poly(ngon(Point(80l, 0), 20, 3, 0, vertices=true), :strokepreserve, close=false)\n    sethue(\"white\")\n    setline(1)\n    strokepath()\nend\nfinish() # hide\nnothing # hide(Image: line endings)using Luxor # hide\nDrawing(600, 250, \"assets/figures/dashes.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nfontsize(14) # hide\nsethue(\"black\") # hide\nsetline(12)\npatterns = [\"solid\", \"dotted\", \"dot\", \"dotdashed\", \"longdashed\",\n  \"shortdashed\", \"dash\", \"dashed\", \"dotdotdashed\", \"dotdotdotdashed\"]\ntiles =  Tiler(600, 250, 10, 1, margin=10)\nfor (pos, n) in tiles\n    setdash(patterns[n])\n    textright(patterns[n], pos.x - 20, pos.y + 4)\n    line(pos, Point(240, pos.y), :stroke)\nend\nfinish() # hide\nnothing # hide(Image: dashes)setline\nsetlinecap\nsetlinejoin\nsetdash\nfillstroke\nstrokepath\nfillpath\nstrokepreserve\nfillpreserve\npaint\ndo_action"
},

{
    "location": "colors-styles.html#Luxor.blend",
    "page": "Colors and styles",
    "title": "Luxor.blend",
    "category": "Function",
    "text": "blend(from::Point, to::Point)\n\nCreate an empty linear blend.\n\nA blend is a specification of how one color changes into another. Linear blends are defined by two points: parallel lines through these points define the start and stop locations of the blend. The blend is defined relative to the current axes origin. This means that you should be aware of the current axes when you define blends, and when you use them.\n\nTo add colors, use addstop().\n\n\n\nblend(centerpos1, rad1, centerpos2, rad2, color1, color2)\n\nCreate a radial blend.\n\nExample:\n\nredblue = blend(\n    pos, 0,                   # first circle center and radius\n    pos, tiles.tilewidth/2,   # second circle center and radius\n    \"red\",\n    \"blue\"\n    )\n\n\n\nblend(pt1::Point, pt2::Point, color1, color2)\n\nCreate a linear blend.\n\nExample:\n\nredblue = blend(pos, pos, \"red\", \"blue\")\n\n\n\nblend(from::Point, startradius, to::Point, endradius)\n\nCreate an empty radial blend.\n\nRadial blends are defined by two circles that define the start and stop locations. The first point is the center of the start circle, the first radius is the radius of the first circle.\n\nA new blend is empty. To add colors, use addstop().\n\n\n\n"
},

{
    "location": "colors-styles.html#Luxor.addstop",
    "page": "Colors and styles",
    "title": "Luxor.addstop",
    "category": "Function",
    "text": "addstop(b::Blend, offset, col)\naddstop(b::Blend, offset, (r, g, b, a))\naddstop(b::Blend, offset, string)\n\nAdd a color stop to a blend. The offset specifies the location along the blend's 'control vector', which varies between 0 (beginning of the blend) and 1 (end of the blend). For linear blends, the control vector is from the start point to the end point. For radial blends, the control vector is from any point on the start circle, to the corresponding point on the end circle.\n\nExamples:\n\nblendredblue = blend(Point(0, 0), 0, Point(0, 0), 1)\naddstop(blendredblue, 0, setcolor(sethue(\"red\")..., .2))\naddstop(blendredblue, 1, setcolor(sethue(\"blue\")..., .2))\naddstop(blendredblue, 0.5, sethue(randomhue()...))\naddstop(blendredblue, 0.5, setcolor(randomcolor()...))\n\n\n\n"
},

{
    "location": "colors-styles.html#Blends-1",
    "page": "Colors and styles",
    "title": "Blends",
    "category": "section",
    "text": "A blend is a color gradient. Use setblend() to select a blend in the same way that you'd use setcolor() and sethue() to select a solid color.You can make linear or radial blends. Use blend() in either case.To create a simple linear blend between two colors, supply two points and two colors to blend():using Luxor # hide\nDrawing(600, 200, \"assets/figures/color-blends-basic.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\norangeblue = blend(Point(-200, 0), Point(200, 0), \"orange\", \"blue\")\nsetblend(orangeblue)\nbox(O, 400, 100, :fill)\naxes()\nfinish() # hide\nnothing # hide(Image: linear blend)And for a radial blend, provide two point/radius pairs, and two colors:using Luxor # hide\nDrawing(600, 200, \"assets/figures/color-blends-radial.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\ngreenmagenta = blend(Point(0, 0), 5, Point(0, 0), 150, \"green\", \"magenta\")\nsetblend(greenmagenta)\nbox(O, 400, 200, :fill)\naxes()\nfinish() # hide\nnothing # hide(Image: radial blends)You can also use blend() to create an empty blend. Then you use addstop() to define the locations of specific colors along the blend, where 0 is the start, and 1 is the end.using Luxor # hide\nDrawing(600, 200, \"assets/figures/color-blends-scratch.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\ngoldblend = blend(Point(-200, 0), Point(200, 0))\naddstop(goldblend, 0.0,  \"gold4\")\naddstop(goldblend, 0.25, \"gold1\")\naddstop(goldblend, 0.5,  \"gold3\")\naddstop(goldblend, 0.75, \"darkgoldenrod4\")\naddstop(goldblend, 1.0,  \"gold2\")\nsetblend(goldblend)\nbox(O, 400, 200, :fill)\naxes()\nfinish() # hide\nnothing # hide(Image: blends from scratch)When you define blends, the location of the axes (eg the current workspace as defined by translate(), etc.), is important. In the first of the two following examples, the blend is selected before the axes are moved with translate(pos). The blend 'samples' the original location of the blend's definition.using Luxor # hide\nDrawing(600, 200, \"assets/figures/color-blends-translate-1.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\ngoldblend = blend(Point(0, 0), Point(200, 0))\naddstop(goldblend, 0.0,  \"gold4\")\naddstop(goldblend, 0.25, \"gold1\")\naddstop(goldblend, 0.5,  \"gold3\")\naddstop(goldblend, 0.75, \"darkgoldenrod4\")\naddstop(goldblend, 1.0,  \"gold2\")\nsetblend(goldblend)\ntiles = Tiler(600, 200, 1, 5, margin=10)\nfor (pos, n) in tiles\n    gsave()\n    setblend(goldblend)\n    translate(pos)\n    ellipse(O, tiles.tilewidth, tiles.tilewidth, :fill)\n    grestore()\nend\nfinish() # hide\nnothing # hide(Image: blends 1)Outside the range of the original blend's definition, the same color is used, no matter how far away from the origin you go (there are Cairo options to change this). But in the next example, the blend is relocated to the current axes, which have just been moved to the center of the tile. The blend refers to 0/0 each time, which is at the center of shape.using Luxor # hide\nDrawing(600, 200, \"assets/figures/color-blends-translate-2.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\ngoldblend = blend(Point(0, 0), Point(200, 0))\naddstop(goldblend, 0.0,  \"gold4\")\naddstop(goldblend, 0.25, \"gold1\")\naddstop(goldblend, 0.5,  \"gold3\")\naddstop(goldblend, 0.75, \"darkgoldenrod4\")\naddstop(goldblend, 1.0,  \"gold2\")\nsetblend(goldblend)\ntiles = Tiler(600, 200, 1, 5, margin=10)\nfor (pos, n) in tiles\n    gsave()\n    translate(pos)\n    setblend(goldblend)\n    ellipse(O, tiles.tilewidth, tiles.tilewidth, :fill)\n    grestore()\nend\nfinish() # hide\nnothing # hide(Image: blends 2)blend\naddstop"
},

{
    "location": "colors-styles.html#Luxor.blendadjust",
    "page": "Colors and styles",
    "title": "Luxor.blendadjust",
    "category": "Function",
    "text": "blendadjust(ablend, center::Point, xscale, yscale, rot=0)\n\nModify an existing blend by scaling, translating, and rotating it so that it will fill a shape properly even if the position of the shape is nowhere near the original location of the blend's definition.\n\nFor example, if your blend definition was this (notice the 1)\n\nblendgoldmagenta = blend(\n        Point(0, 0), 0,                   # first circle center and radius\n        Point(0, 0), 1,                   # second circle center and radius\n        \"gold\",\n        \"magenta\"\n        )\n\nyou can use it in a shape that's 100 units across and centered at pos, by calling this:\n\nblendadjust(blendgoldmagenta, Point(pos.x, pos.y), 100, 100)\n\nthen use setblend():\n\nsetblend(blendgoldmagenta)\n\n\n\n"
},

{
    "location": "colors-styles.html#Using-blendadjust()-1",
    "page": "Colors and styles",
    "title": "Using blendadjust()",
    "category": "section",
    "text": "You can use blendadjust() to modify the blend so that objects scaled and positioned after the blend was defined are rendered correctly.using Luxor # hide\nDrawing(600, 250, \"assets/figures/blend-adjust.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsetline(20)\n\n# first line\nblendgoldmagenta = blend(Point(-100, 0), Point(100, 0), \"gold\", \"magenta\")\nsetblend(blendgoldmagenta)\nline(Point(-100, -50), Point(100, -50))\nstrokepath()\n\n# second line\nblendadjust(blendgoldmagenta, Point(50, 0), 0.5, 0.5)\nline(O, Point(100, 0))\nstrokepath()\n\n# third line\nblendadjust(blendgoldmagenta, Point(-50, 50), 0.5, 0.5)\nline(Point(-100, 50), Point(0, 50))\nstrokepath()\n\n# fourth line\ngsave()\ntranslate(0, 100)\nscale(0.5, 0.5)\nsetblend(blendgoldmagenta)\nline(Point(-100, 0), Point(100, 0))\nstrokepath()\ngrestore()\n\nfinish() # hide\nnothing # hide(Image: blends adjust)The blend is defined to span 200 units, horizontally centered at 0/0. The top line is also 200 units long and centered horizontally at 0/0, so the blend is rendered exactly as you'd hope.The second line is only half as long, at 100 units, centered at 50/0, so blendadjust() is used to relocate the blend's center to the point 50/0 and scale it by 0.5 (100/200).The third line is also 100 units long, centered at -50/0, so again blendadjust() is used to relocate the blend's center and scale it.The fourth line shows that you can translate and scale the axes instead of adjusting the blend, if you use setblend() again in the new scene.blendadjust"
},

{
    "location": "colors-styles.html#Luxor.setmode",
    "page": "Colors and styles",
    "title": "Luxor.setmode",
    "category": "Function",
    "text": "setmode(mode::String)\n\nSet the compositing/blending mode. mode can be one of:\n\n\"clear\" Where the second object is drawn, the first is completely removed.\n\"source\" The second object is drawn as if nothing else were below.\n\"over\" The default mode: like two transparent slides overlapping.\n\"in\" The first object is removed completely, the second is only drawn where the first was.\n\"out\" The second object is drawn only where the first one wasn't.\n\"atop\" The first object is mostly intact, but mixes both objects in the overlapping area. The second object object is not drawn elsewhere.\n\"dest\" Discard the second object completely.\n\"dest_over\" Like \"over\" but draw second object below the first\n\"dest_in\" Keep the first object whereever the second one overlaps.\n\"dest_out\" The second object is used to reduce the visibility of the first where they overlap.\n\"dest_atop\" Like \"over\" but draw second object below the first.\n\"xor\" XOR where the objects overlap\n\"add\" Add the overlapping areas together\n\"saturate\" Increase Saturation where objects overlap\n\"multiply\" Multiply where objects overlap\n\"screen\" Input colors are complemented and multiplied, the product is complemented again. The result is at least as light as the lighter of the input colors.\n\"overlay\" Multiplies or screens colors, depending on the lightness of the destination color.\n\"darken\" Selects the darker of the color values in each component.\n\"lighten\" Selects the lighter of the color values in each component.\n\nSee the Cairo documentation for details.\n\n\n\n"
},

{
    "location": "colors-styles.html#Blending-(compositing)-operators-1",
    "page": "Colors and styles",
    "title": "Blending (compositing) operators",
    "category": "section",
    "text": "Graphics software provides ways to modify how the virtual \"ink\" is applied to existing graphic elements. In PhotoShop and other software products the compositing process is done using blend modes.Use setmode() to set the blending mode of subsequent graphics.using Luxor # hide\nDrawing(600, 600, \"assets/figures/blendmodes.png\") # hide\norigin()\n# transparent, no background\nfontsize(15)\nsetline(1)\ntiles = Tiler(600, 600, 4, 5, margin=30)\nmodes = length(Luxor.blendingmodes)\nsetcolor(\"black\")\nfor (pos, n) in tiles\n    n > modes && break\n    gsave()\n    translate(pos)\n    box(O, tiles.tilewidth-10, tiles.tileheight-10, :clip)\n\n    # calculate points for circles\n    diag = (Point(-tiles.tilewidth/2, -tiles.tileheight/2),\n            Point(tiles.tilewidth/2,  tiles.tileheight/2))\n    upper = between(diag, 0.4)\n    lower = between(diag, 0.6)\n\n    # first red shape uses default blend operator\n    setcolor(0.7, 0, 0, .8)\n    circle(upper, tiles.tilewidth/4, :fill)\n\n    # second blue shape shows results of blend operator\n    setcolor(0, 0, 0.9, 0.4)\n    blendingmode = Luxor.blendingmodes[mod1(n, modes)]\n    setmode(blendingmode)\n    circle(lower, tiles.tilewidth/4, :fill)\n\n    clipreset()\n    grestore()\n\n    gsave()\n    translate(pos)\n    text(Luxor.blendingmodes[mod1(n, modes)], O.x, O.y + tiles.tilewidth/2, halign=:center)\n    grestore()\nend\nfinish() # hide\nnothing # hide(Image: blend modes)Notice in this example that clipping was used to restrict the area affected by the blending process.In Cairo these blend modes are called operators. A source for a more detailed explanation can be found here.You can access the list of modes with the unexported symbol Luxor.blendingmodes.setmode"
},

{
    "location": "colors-styles.html#Luxor.mesh",
    "page": "Colors and styles",
    "title": "Luxor.mesh",
    "category": "Function",
    "text": "mesh(bezierpath::AbstractArray{NTuple{4,Point}},\n     colors=AbstractArray{ColorTypes.Colorant, 1})\n\nCreate a mesh. The first three or four elements of the supplied bezierpath define the three or four sides of the mesh shape.\n\nThe colors array define the color of each corner point. Colors are reused if necessary. At least one color should be supplied.\n\nUse setmesh() to select the mesh, which will be used to fill shapes.\n\nExample\n\n@svg begin\n    bp = makebezierpath(ngon(O, 50, 4, 0, vertices=true))\n    mesh1 = mesh(bp, [\n        \"red\",\n        Colors.RGB(0, 1, 0),\n        Colors.RGB(0, 1, 1),\n        Colors.RGB(1, 0, 1)\n        ])\n    setmesh(mesh1)\n    box(O, 500, 500, :fill)\nend\n\n\n\nmesh(points::AbstractArray{Point},\n     colors=AbstractArray{ColorTypes.Colorant, 1})\n\nCreate a mesh.\n\nCreate a mesh. The first three or four sides of the supplied points polygon define the three or four sides of the mesh shape.\n\nThe colors array define the color of each corner point. Colors are reused if necessary. At least one color should be supplied.\n\nExample\n\n@svg begin\n    pl = ngon(O, 250, 3, pi/6, vertices=true)\n    mesh1 = mesh(pl, [\n        \"purple\",\n        Colors.RGBA(0.0, 1.0, 0.5, 0.5),\n        \"yellow\"\n        ])\n    setmesh(mesh1)\n    setline(180)\n    ngon(O, 250, 3, pi/6, :strokepreserve)\n    setline(5)\n    sethue(\"black\")\n    strokepath()\nend\n\n\n\n"
},

{
    "location": "colors-styles.html#Luxor.setmesh",
    "page": "Colors and styles",
    "title": "Luxor.setmesh",
    "category": "Function",
    "text": "setmesh(mesh::Mesh)\n\nSelect a mesh previously created with mesh() for filling shapes.\n\n\n\n"
},

{
    "location": "colors-styles.html#Meshes-1",
    "page": "Colors and styles",
    "title": "Meshes",
    "category": "section",
    "text": "A mesh is a Cairo feature that provides smooth shading between three or four colors across a region defined by lines or curves.To create a mesh, use the mesh() function and save the result as a mesh object. To use a mesh, supply the mesh object to the setmesh() function.The mesh() function accepts either an array of Bézier paths or a polygon.The first example uses a Bézier path conversion of a square as the outline of the mesh. Because the box to be filled is larger than the mesh's outlines, not all the box is filled.using Luxor, Colors # hide\nDrawing(600, 600, \"assets/figures/mesh1.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\n\nsetcolor(\"grey50\")\ncircle.([Point(x, y) for x in -200:25:200, y in -200:25:200], 10, :fill)\nbp = makebezierpath(ngon(O, 250, 4, pi/4, vertices=true), smoothing=.4)\nmesh1 = mesh(bp, [\n    Colors.RGBA(1, 0, 0, 1),   # bottom left, red\n    Colors.RGBA(1, 1, 1, 0.0), # top left, transparent\n    Colors.RGB(0, 0, 1),      # top right, blue\n    Colors.RGB(1, 0, 1)        # bottom right, purple\n    ])\nsetmesh(mesh1)\nbox(O, 500, 500, :fillpreserve)\nsethue(\"grey50\")\nstrokepath()\n\nfinish() # hide\nnothing # hide(Image: mesh 1)The second example uses a polygon defined by ngon() as the outline of the mesh. The mesh is drawn when the path is stroked.using Luxor # hide\nDrawing(600, 600, \"assets/figures/mesh2.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\npl = ngon(O, 250, 3, pi/6, vertices=true)\nmesh1 = mesh(pl, [\n    \"purple\",\n    \"green\",\n    \"yellow\"\n    ])\nsetmesh(mesh1)\nsetline(180)\npoly(pl, :strokepreserve, close=true)\nsetline(5)\nsethue(\"black\")\nstrokepath()\nfinish() # hide\nnothing # hide(Image: mesh 2)mesh\nsetmesh"
},

{
    "location": "polygons.html#",
    "page": "Polygons and paths",
    "title": "Polygons and paths",
    "category": "page",
    "text": ""
},

{
    "location": "polygons.html#Polygons-and-paths-1",
    "page": "Polygons and paths",
    "title": "Polygons and paths",
    "category": "section",
    "text": "For drawing shapes, Luxor provides polygons and paths.A polygon is an ordered collection of Points stored in an array.A path is one or more straight and curved (Bézier) lines placed on the drawing. Paths can consist of subpaths. Luxor maintains a 'current path', to which you can add lines and curves until you finish with a stroke or fill instruction.Luxor also provides a Bézier-path type, which is an array of four-point tuples, each of which is a Bézier curve section.Functions are provided for converting between polygons and paths."
},

{
    "location": "polygons.html#Luxor.ngon",
    "page": "Polygons and paths",
    "title": "Luxor.ngon",
    "category": "Function",
    "text": "ngon(x, y, radius, sides=5, orientation=0, action=:nothing;\n    vertices=false, reversepath=false)\n\nFind the vertices of a regular n-sided polygon centered at x, y with circumradius radius.\n\nngon() draws the shapes: if you just want the raw points, use keyword argument vertices=true, which returns the array of points instead. Compare:\n\nngon(0, 0, 4, 4, 0, vertices=true) # returns the polygon's points:\n\n    4-element Array{Luxor.Point,1}:\n    Luxor.Point(2.4492935982947064e-16,4.0)\n    Luxor.Point(-4.0,4.898587196589413e-16)\n    Luxor.Point(-7.347880794884119e-16,-4.0)\n    Luxor.Point(4.0,-9.797174393178826e-16)\n\nwhereas\n\nngon(0, 0, 4, 4, 0, :close) # draws a polygon\n\n\n\nngon(centerpos, radius, sides=5, orientation=0, action=:nothing;\n    vertices=false,\n    reversepath=false)\n\nDraw a regular polygon centered at point centerpos:\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.ngonside",
    "page": "Polygons and paths",
    "title": "Luxor.ngonside",
    "category": "Function",
    "text": "ngonside(centerpoint::Point, sidelength::Real, sides::Int=5, orientation=0,\n    action=:nothing; kwargs...)\n\nDraw a regular polygon centered at centerpoint with sides sides of length sidelength.\n\n\n\n"
},

{
    "location": "polygons.html#Regular-polygons-(\"ngons\")-1",
    "page": "Polygons and paths",
    "title": "Regular polygons (\"ngons\")",
    "category": "section",
    "text": "A polygon is an array of points. The points can be joined with straight lines.You can make regular polygons — from triangles, pentagons, hexagons, septagons, heptagons, octagons, nonagons, decagons, and on-and-on-agons — with ngon().(Image: n-gons)using Luxor, Colors\nDrawing(1200, 1400)\n\norigin()\ncols = diverging_palette(60, 120, 20) # hue 60 to hue 120\nbackground(cols[1])\nsetopacity(0.7)\nsetline(2)\n\n# circumradius of 500\nngon(0, 0, 500, 8, 0, :clip)\n\nfor y in -500:50:500\n    for x in -500:50:500\n        setcolor(cols[rand(1:20)])\n        ngon(x, y, rand(20:25), rand(3:12), 0, :fill)\n        setcolor(cols[rand(1:20)])\n        ngon(x, y, rand(10:20), rand(3:12), 0, :stroke)\n    end\nend\n\nfinish()\npreview()If you want to specify the side length rather than the circumradius, use ngonside().using Luxor # hide\nDrawing(500, 600, \"assets/figures/ngonside.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\n\nsetline(2) # hide\nfor i in 20:-1:3\n    sethue(i/20, 0.5, 0.7)\n    ngonside(O, 75, i, 0, :fill)\n    sethue(\"black\")\n    ngonside(O, 75, i, 0, :stroke)\nend\n\nfinish() # hide\nnothing # hide(Image: stars)ngon\nngonside"
},

{
    "location": "polygons.html#Luxor.star",
    "page": "Polygons and paths",
    "title": "Luxor.star",
    "category": "Function",
    "text": "star(xcenter, ycenter, radius, npoints=5, ratio=0.5, orientation=0, action=:nothing;\n    vertices = false,\n    reversepath=false)\n\nMake a star. ratio specifies the height of the smaller radius of the star relative to the larger.\n\nUse vertices=true to return the vertices of a star instead of drawing it.\n\n\n\nstar(center, radius, npoints=5, ratio=0.5, orientation=0, action=:nothing;\n    vertices = false, reversepath=false)\n\nDraw a star centered at a position:\n\n\n\n"
},

{
    "location": "polygons.html#Stars-1",
    "page": "Polygons and paths",
    "title": "Stars",
    "category": "section",
    "text": "Use star() to make a star. You can draw it immediately, or use the points it can create.using Luxor # hide\nDrawing(500, 300, \"assets/figures/stars.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\ntiles = Tiler(400, 300, 4, 6, margin=5)\nfor (pos, n) in tiles\n    randomhue()\n    star(pos, tiles.tilewidth/3, rand(3:8), 0.5, 0, :fill)\nend\nfinish() # hide\nnothing # hide(Image: stars)The ratio determines the length of the inner radius compared with the outer.using Luxor # hide\nDrawing(500, 250, \"assets/figures/star-ratios.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"black\") # hide\nsetline(2) # hide\ntiles = Tiler(500, 250, 1, 6, margin=10)\nfor (pos, n) in tiles\n    star(pos, tiles.tilewidth/2, 5, rescale(n, 1, 6, 1, 0), 0, :stroke)\nend\nfinish() # hide\nnothing # hide(Image: stars)star"
},

{
    "location": "polygons.html#Luxor.poly",
    "page": "Polygons and paths",
    "title": "Luxor.poly",
    "category": "Function",
    "text": "Draw a polygon.\n\npoly(pointlist::AbstractArray{Point, 1}, action = :nothing;\n    close=false,\n    reversepath=false)\n\nA polygon is an Array of Points. By default poly() doesn't close or fill the polygon, to allow for clipping.\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.prettypoly",
    "page": "Polygons and paths",
    "title": "Luxor.prettypoly",
    "category": "Function",
    "text": "prettypoly(points::AbstractArray{Point, 1}, action=:nothing, vertexfunction = () -> circle(O, 2, :stroke);\n    close=false,\n    reversepath=false,\n    vertexlabels = (n, l) -> ()\n    )\n\nDraw the polygon defined by points, possibly closing and reversing it, using the current parameters, and then evaluate the vertexfunction function at every vertex of the polygon.\n\nThe default vertexfunction draws a 2 pt radius circle.\n\nTo mark each vertex of a polygon with a randomly colored filled circle:\n\np = star(O, 70, 7, 0.6, 0, vertices=true)\nprettypoly(p, :fill, () ->\n    begin\n        randomhue()\n        circle(O, 10, :fill)\n    end,\n    close=true)\n\nThe optional keyword argument vertexlabels lets you supply a function with two arguments that can access the current vertex number and the total number of vertices at each vertex. For example, you can label the vertices of a triangle \"1 of 3\", \"2 of 3\", and \"3 of 3\" using:\n\nprettypoly(triangle, :stroke,\n    vertexlabels = (n, l) -> (text(string(n, \" of \", l))))\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.simplify",
    "page": "Polygons and paths",
    "title": "Luxor.simplify",
    "category": "Function",
    "text": "Simplify a polygon:\n\nsimplify(pointlist::AbstractArray, detail=0.1)\n\ndetail is the smallest permitted distance between two points in pixels.\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.isinside",
    "page": "Polygons and paths",
    "title": "Luxor.isinside",
    "category": "Function",
    "text": "isinside(p, pol; allowonedge=false)\n\nIs a point p inside a polygon pol? Returns true if it does, or false.\n\nThis is an implementation of the Hormann-Agathos (2001) Point in Polygon algorithm.\n\nThe classification of points lying on the edges of the target polygon, or coincident with its vertices is not clearly defined, due to rounding errors or arithmetical inadequacy. By default these will generate errors, but you can suppress these by setting allowonedge to true.\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.randompoint",
    "page": "Polygons and paths",
    "title": "Luxor.randompoint",
    "category": "Function",
    "text": "randompoint(lowpt, highpt)\n\nReturn a random point somewhere inside the rectangle defined by the two points.\n\n\n\nrandompoint(lowx, lowy, highx, highy)\n\nReturn a random point somewhere inside a rectangle defined by the four values.\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.randompointarray",
    "page": "Polygons and paths",
    "title": "Luxor.randompointarray",
    "category": "Function",
    "text": "randompointarray(lowpt, highpt, n)\n\nReturn an array of n random points somewhere inside the rectangle defined by two points.\n\n\n\nrandompointarray(lowx, lowy, highx, highy, n)\n\nReturn an array of n random points somewhere inside the rectangle defined by the four coordinates.\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.polysplit",
    "page": "Polygons and paths",
    "title": "Luxor.polysplit",
    "category": "Function",
    "text": "polysplit(p, p1, p2)\n\nSplit a polygon into two where it intersects with a line. It returns two polygons:\n\n(poly1, poly2)\n\nThis doesn't always work, of course. For example, a polygon the shape of the letter \"E\" might end up being divided into more than two parts.\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.polysortbydistance",
    "page": "Polygons and paths",
    "title": "Luxor.polysortbydistance",
    "category": "Function",
    "text": "Sort a polygon by finding the nearest point to the starting point, then the nearest point to that, and so on.\n\npolysortbydistance(p, starting::Point)\n\nYou can end up with convex (self-intersecting) polygons, unfortunately.\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.polysortbyangle",
    "page": "Polygons and paths",
    "title": "Luxor.polysortbyangle",
    "category": "Function",
    "text": "Sort the points of a polygon into order. Points are sorted according to the angle they make with a specified point.\n\npolysortbyangle(pointlist::AbstractArray, refpoint=minimum(pointlist))\n\nThe refpoint can be chosen, but the minimum point is usually OK too:\n\npolysortbyangle(parray, polycentroid(parray))\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.polycentroid",
    "page": "Polygons and paths",
    "title": "Luxor.polycentroid",
    "category": "Function",
    "text": "Find the centroid of simple polygon.\n\npolycentroid(pointlist)\n\nReturns a point. This only works for simple (non-intersecting) polygons.\n\nYou could test the point using isinside().\n\n\n\n"
},

{
    "location": "polygons.html#Polygons-1",
    "page": "Polygons and paths",
    "title": "Polygons",
    "category": "section",
    "text": "Use poly() to draw lines connecting the points or just fill the area:using Luxor # hide\nDrawing(600, 250, \"assets/figures/simplepoly.png\") # hide\nbackground(\"white\") # hide\nsrand(42) # hide\norigin() # hide\nsethue(\"orchid4\") # hide\ntiles = Tiler(600, 250, 1, 2, margin=20)\ntile1, tile2 = collect(tiles)\n\nrandompoints = [Point(rand(-100:100), rand(-100:100)) for i in 1:10]\n\ngsave()\ntranslate(tile1[1])\npoly(randompoints, :stroke)\ngrestore()\n\ngsave()\ntranslate(tile2[1])\npoly(randompoints, :fill)\ngrestore()\n\nfinish() # hide\nnothing # hide(Image: simple poly)polyA polygon can contain holes. The reversepath keyword changes the direction of the polygon. The following piece of code uses ngon() to make and draw two paths, the second forming a hole in the first, to make a hexagonal bolt shape:using Luxor # hide\nDrawing(400, 250, \"assets/figures/holes.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsetline(5)\nsethue(\"gold\")\nline(Point(-200, 0), Point(200, 0), :stroke)\nsethue(\"orchid4\")\nngon(0, 0, 60, 6, 0, :path)\nnewsubpath()\nngon(0, 0, 40, 6, 0, :path, reversepath=true)\nfillstroke()\nfinish() # hide\nnothing # hide(Image: holes)The prettypoly() function can place graphics at each vertex of a polygon. After the polygon action, the supplied vertexfunction function is evaluated at each vertex. For example, to mark each vertex of a polygon with a randomly-colored circle:using Luxor # hide\nDrawing(400, 250, \"assets/figures/prettypolybasic.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"steelblue4\") # hide\n\napoly = star(O, 70, 7, 0.6, 0, vertices=true)\nprettypoly(apoly, :fill, () ->\n        begin\n            randomhue()\n            circle(O, 10, :fill)\n        end,\n    close=true)\nfinish() # hide\nnothing # hide(Image: prettypoly)An optional keyword argument vertexlabels lets you pass a function that can number each vertex. The function can use two arguments, the current vertex number, and the total number of points in the polygon:using Luxor # hide\nDrawing(400, 250, \"assets/figures/prettypolyvertex.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"steelblue4\") # hide\n\napoly = star(O, 80, 5, 0.6, 0, vertices=true)\nprettypoly(apoly,\n    :stroke,\n    vertexlabels = (n, l) -> (text(string(n, \" of \", l), halign=:center)),\n    close=true)\nfinish() # hide\nnothing # hide(Image: prettypoly)prettypolyRecursive decoration is possible:using Luxor # hide\nDrawing(400, 260, \"assets/figures/prettypolyrecursive.png\") # hide\nbackground(\"white\") # hide\nsrand(42) # hide\norigin() # hide\nsethue(\"magenta\") # hide\nsetopacity(0.5) # hide\n\ndecorate(pos, p, level) = begin\n    if level < 4\n        randomhue();\n        scale(0.25, 0.25)\n        prettypoly(p, :fill, () -> decorate(pos, p, level+1), close=true)\n    end\nend\n\napoly = star(O, 100, 7, 0.6, 0, vertices=true)\nprettypoly(apoly, :fill, () -> decorate(O, apoly, 1), close=true)\nfinish() # hide\nnothing # hide(Image: prettypoly)Polygons can be simplified using the Douglas-Peucker algorithm (non-recursive version), via simplify().using Luxor # hide\nDrawing(600, 500, \"assets/figures/simplify.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"black\") # hide\nsetline(1) # hide\nfontsize(20) # hide\ntranslate(0, -120) # hide\nsincurve = [Point(6x, 80sin(x)) for x in -5pi:pi/20:5pi]\nprettypoly(collect(sincurve), :stroke,\n    () -> begin\n            sethue(\"red\")\n            circle(O, 3, :fill)\n          end)\ntext(string(\"number of points: \", length(collect(sincurve))), 0, 100)\ntranslate(0, 200)\nsimplercurve = simplify(collect(sincurve), 0.5)\nprettypoly(simplercurve, :stroke,\n    () -> begin\n            sethue(\"red\")\n            circle(O, 3, :fill)\n          end)\ntext(string(\"number of points: \", length(simplercurve)), 0, 100)\nfinish() # hide\nnothing # hide(Image: simplify)simplifyThe isinside() function returns true if a point is inside a polygon.using Luxor # hide\nDrawing(600, 250, \"assets/figures/isinside.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsetline(0.5)\napolygon = star(O, 100, 5, 0.5, 0, vertices=true)\nfor n in 1:10000\n    apoint = randompoint(Point(-200, -150), Point(200, 150))\n    randomhue()\n    isinside(apoint, apolygon) ? circle(apoint, 3, :fill) : circle(apoint, .5, :stroke)\nend\nfinish() # hide\nnothing # hide(Image: isinside)isinsideYou can use randompoint() and randompointarray() to create a random Point or list of Points.using Luxor # hide\nDrawing(400, 250, \"assets/figures/randompoints.png\") # hide\nbackground(\"white\") # hide\nsrand(42) # hide\norigin() # hide\n\npt1 = Point(-100, -100)\npt2 = Point(100, 100)\n\nsethue(\"gray80\")\nmap(pt -> circle(pt, 6, :fill), (pt1, pt2))\nbox(pt1, pt2, :stroke)\n\nsethue(\"red\")\ncircle(randompoint(pt1, pt2), 7, :fill)\n\nsethue(\"blue\")\nmap(pt -> circle(pt, 2, :fill), randompointarray(pt1, pt2, 100))\n\nfinish() # hide\nnothing # hide(Image: isinside)randompoint\nrandompointarrayThere are some experimental polygon functions. These don't work well for polygons that aren't simple or where the sides intersect each other, but they sometimes do a reasonable job. For example, here's polysplit():using Luxor # hide\nDrawing(400, 150, \"assets/figures/polysplit.png\") # hide\norigin() # hide\nsetopacity(0.7) # hide\nsrand(42) # hide\nsethue(\"black\") # hide\ns = squircle(O, 60, 60, vertices=true)\npt1 = Point(0, -120)\npt2 = Point(0, 120)\nline(pt1, pt2, :stroke)\npoly1, poly2 = polysplit(s, pt1, pt2)\nrandomhue()\npoly(poly1, :fill)\nrandomhue()\npoly(poly2, :fill)\nfinish() # hide\nnothing # hide(Image: polysplit)polysplit\npolysortbydistance\npolysortbyangle\npolycentroid"
},

{
    "location": "polygons.html#Luxor.polysmooth",
    "page": "Polygons and paths",
    "title": "Luxor.polysmooth",
    "category": "Function",
    "text": "polysmooth(points, radius, action=:action; debug=false)\n\nMake a closed path from the points and round the corners by making them arcs with the given radius. Execute the action when finished.\n\nThe arcs are sometimes different sizes: if the given radius is bigger than the length of the shortest side, the arc can't be drawn at its full radius and is therefore drawn as large as possible (as large as the shortest side allows).\n\nThe debug option also draws the construction circles at each corner.\n\n\n\n"
},

{
    "location": "polygons.html#Smoothing-polygons-1",
    "page": "Polygons and paths",
    "title": "Smoothing polygons",
    "category": "section",
    "text": "Because polygons can have sharp corners, the experimental polysmooth() function attempts to insert arcs at the corners and draw the result.The original polygon is shown in red; the smoothed polygon is shown on top:using Luxor # hide\nDrawing(600, 250, \"assets/figures/polysmooth.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsetopacity(0.5) # hide\nsrand(42) # hide\nsetline(0.7) # hide\ntiles = Tiler(600, 250, 1, 5, margin=10)\nfor (pos, n) in tiles\n    p = star(pos, tiles.tilewidth/2 - 2, 5, 0.3, 0, vertices=true)\n    setdash(\"dot\")\n    sethue(\"red\")\n    prettypoly(p, close=true, :stroke)\n    setdash(\"solid\")\n    sethue(\"black\")\n    polysmooth(p, n * 2, :fill)\nend\n\nfinish() # hide\nnothing # hide(Image: polysmooth)The final polygon shows that you can get unexpected results if you attempt to smooth corners by more than the possible amount. The debug=true option draws the circles if you want to find out what's going wrong, or if you want to explore the effect in more detail.using Luxor # hide\nDrawing(600, 250, \"assets/figures/polysmooth-pathological.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsetopacity(0.75) # hide\nsrand(42) # hide\nsetline(1) # hide\np = star(O, 60, 5, 0.35, 0, vertices=true)\nsetdash(\"dot\")\nsethue(\"red\")\nprettypoly(p, close=true, :stroke)\nsetdash(\"solid\")\nsethue(\"black\")\npolysmooth(p, 40, :fill, debug=true)\nfinish() # hide\nnothing # hide(Image: polysmooth)polysmooth"
},

{
    "location": "polygons.html#Luxor.offsetpoly",
    "page": "Polygons and paths",
    "title": "Luxor.offsetpoly",
    "category": "Function",
    "text": "offsetpoly(path::AbstractArray{Point, 1}, d)\n\nReturn a polygon that is offset from a polygon by d units.\n\nThe incoming set of points path is treated as a polygon, and another set of points is created, which form a polygon lying d units away from the source poly.\n\nPolygon offsetting is a topic on which people have written PhD theses and published academic papers, so this short brain-dead routine will give good results for simple polygons up to a point (!). There are a number of issues to be aware of:\n\nvery short lines tend to make the algorithm 'flip' and produce larger lines\nsmall polygons that are counterclockwise and larger offsets may make the new polygon appear the wrong side of the original\nvery sharp vertices will produce even sharper offsets, as the calculated intersection point veers off to infinity\nduplicated adjacent points might cause the routine to scratch its head and wonder how to draw a line parallel to them\n\n\n\n"
},

{
    "location": "polygons.html#Offsetting-polygons-1",
    "page": "Polygons and paths",
    "title": "Offsetting polygons",
    "category": "section",
    "text": "The experimental offsetpoly() function constructs an outline polygon outside or inside an existing polygon. In the following example, the dotted red polygon is the original, the black polygons have positive offsets and surround the original, the cyan polygons have negative offsets and run inside the original. Use poly() to draw the result returned by offsetpoly().using Luxor # hide\nDrawing(600, 250, \"assets/figures/polyoffset-simple.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsrand(42) # hide\nsetline(1.5) # hide\n\np = star(O, 45, 5, 0.5, 0, vertices=true)\nsethue(\"red\")\nsetdash(\"dot\")\npoly(p, :stroke, close=true)\nsetdash(\"solid\")\nsethue(\"black\")\n\npoly(offsetpoly(p, 20), :stroke, close=true)\npoly(offsetpoly(p, 25), :stroke, close=true)\npoly(offsetpoly(p, 30), :stroke, close=true)\npoly(offsetpoly(p, 35), :stroke, close=true)\n\nsethue(\"darkcyan\")\n\npoly(offsetpoly(p, -10), :stroke, close=true)\npoly(offsetpoly(p, -15), :stroke, close=true)\npoly(offsetpoly(p, -20), :stroke, close=true)\nfinish() # hide\nnothing # hide(Image: offset poly)The function is intended for simple cases, and it can go wrong if pushed too far. Sometimes the offset distances can be larger than the polygon segments, and things will start to go wrong. In this example, the offset goes so far negative that the polygon overshoots the origin, becomes inverted and starts getting larger again.(Image: offset poly problem)offsetpoly"
},

{
    "location": "polygons.html#Luxor.polyfit",
    "page": "Polygons and paths",
    "title": "Luxor.polyfit",
    "category": "Function",
    "text": "polyfit(plist::AbstractArray, npoints=30)\n\nBuild a polygon that constructs a B-spine approximation to it. The resulting list of points makes a smooth path that runs between the first and last points.\n\n\n\n"
},

{
    "location": "polygons.html#Fitting-splines-1",
    "page": "Polygons and paths",
    "title": "Fitting splines",
    "category": "section",
    "text": "The experimental polyfit() function constructs a B-spline that follows the points approximately.using Luxor # hide\nDrawing(600, 250, \"assets/figures/polyfit.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsrand(42) # hide\n\npts = [Point(x, rand(-100:100)) for x in -280:30:280]\nsetopacity(0.7)\nsethue(\"red\")\nprettypoly(pts, :none, () -> circle(O, 5, :fill))\nsethue(\"darkmagenta\")\npoly(polyfit(pts, 200), :stroke)\n\nfinish() # hide\nnothing # hide(Image: offset poly)polyfit"
},

{
    "location": "polygons.html#Luxor.pathtopoly",
    "page": "Polygons and paths",
    "title": "Luxor.pathtopoly",
    "category": "Function",
    "text": "pathtopoly()\n\nConvert the current path to an array of polygons.\n\nReturns an array of polygons.\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.getpath",
    "page": "Polygons and paths",
    "title": "Luxor.getpath",
    "category": "Function",
    "text": "getpath()\n\nGet the current path and return a CairoPath object, which is an array of element_type and points objects. With the results you can step through and examine each entry:\n\no = getpath()\nfor e in o\n      if e.element_type == Cairo.CAIRO_PATH_MOVE_TO\n          (x, y) = e.points\n          move(x, y)\n      elseif e.element_type == Cairo.CAIRO_PATH_LINE_TO\n          (x, y) = e.points\n          # straight lines\n          line(x, y)\n          strokepath()\n          circle(x, y, 1, :stroke)\n      elseif e.element_type == Cairo.CAIRO_PATH_CURVE_TO\n          (x1, y1, x2, y2, x3, y3) = e.points\n          # Bezier control lines\n          circle(x1, y1, 1, :stroke)\n          circle(x2, y2, 1, :stroke)\n          circle(x3, y3, 1, :stroke)\n          move(x, y)\n          curve(x1, y1, x2, y2, x3, y3)\n          strokepath()\n          (x, y) = (x3, y3) # update current point\n      elseif e.element_type == Cairo.CAIRO_PATH_CLOSE_PATH\n          closepath()\n      else\n          error(\"unknown CairoPathEntry \" * repr(e.element_type))\n          error(\"unknown CairoPathEntry \" * repr(e.points))\n      end\n  end\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.getpathflat",
    "page": "Polygons and paths",
    "title": "Luxor.getpathflat",
    "category": "Function",
    "text": "getpathflat()\n\nGet the current path, like getpath() but flattened so that there are no Bèzier curves.\n\nReturns a CairoPath which is an array of element_type and points objects.\n\n\n\n"
},

{
    "location": "polygons.html#Converting-paths-to-polygons-1",
    "page": "Polygons and paths",
    "title": "Converting paths to polygons",
    "category": "section",
    "text": "You can convert the current path to an array of polygons, using pathtopoly().In the next example, the path consists of a number of paths, some of which are subpaths, which form the holes.using Luxor # hide\nDrawing(800, 300, \"assets/figures/path-to-poly.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nfontsize(60) # hide\ntranslate(-300, -50) # hide\ntextpath(\"get polygons from paths\")\nplist = pathtopoly()\nsetline(0.5) # hide\nfor (n, pgon) in enumerate(plist)\n    randomhue()\n    prettypoly(pgon, :stroke, close=true)\n    gsave()\n    translate(0, 100)\n    poly(polysortbyangle(pgon, polycentroid(pgon)), :stroke, close=true)\n    grestore()\nend\nfinish() # hide\nnothing # hide(Image: path to polygon)The pathtopoly() function calls getpathflat() to convert the current path to an array of polygons, with each curved section flattened to line segments.The getpath() function gets the current path as an array of elements, lines, and unflattened curves.pathtopoly\ngetpath\ngetpathflat"
},

{
    "location": "polygons.html#Luxor.makebezierpath",
    "page": "Polygons and paths",
    "title": "Luxor.makebezierpath",
    "category": "Function",
    "text": "makebezierpath(pgon::AbstractArray{Point, 1}; smoothing=1)\n\nReturn a Bézier path that follows a polygon (an array of points). The Bézier path is an array of tuples; each tuple contains the four points that make up a segment of the Bézier path.\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.drawbezierpath",
    "page": "Polygons and paths",
    "title": "Luxor.drawbezierpath",
    "category": "Function",
    "text": "drawbezierpath(bezierpath, action=:none;\n    close=true)\n\nDraw a Bézier path, and apply the action, such as :none, :stroke, :fill, etc. By default the path is closed.\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.bezierpathtopoly",
    "page": "Polygons and paths",
    "title": "Luxor.bezierpathtopoly",
    "category": "Function",
    "text": "bezierpathtopoly(bezierpath::AbstractArray{NTuple{4,Luxor.Point}}; steps=10)\n\nConvert a Bezier path (an array of Bezier segments, where each segment is a tuple of four points: anchor1, control1, control2, anchor2) to a polygon.\n\nTo make a Bezier path, use makebezierpath() on a polygon.\n\nThe steps optional keyword determines how many line sections are used for each path.\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.beziertopoly",
    "page": "Polygons and paths",
    "title": "Luxor.beziertopoly",
    "category": "Function",
    "text": "beziertopoly(bpseg::NTuple{4,Luxor.Point}; steps=10)\n\nConvert a Bezier segment (a tuple of four points: anchor1, control1, control2, anchor2) to a polygon (an array of points).\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.pathtobezierpaths",
    "page": "Polygons and paths",
    "title": "Luxor.pathtobezierpaths",
    "category": "Function",
    "text": "pathtobezierpaths()\n\nConvert the current path (which may consist of one or more paths) to an array of Bezier paths. Each Bezier path is, in turn, an array of path segments. Each path segment is a tuple of four points. A straight line is converted to a Bezier segment in which the control points are set to be the the same as the end points.\n\nExample\n\nThis code draws the Bezier segments and shows the control points as \"handles\", like a vector-editing program might.\n\n@svg begin\n    fontface(\"MyanmarMN-Bold\")\n    st = \"goo\"\n    thefontsize = 100\n    fontsize(thefontsize)\n    sethue(\"red\")\n    fontsize(thefontsize)\n    textpath(st)\n    nbps = pathtobezierpaths()\n    for nbp in nbps\n        setline(.15)\n        sethue(\"grey50\")\n        drawbezierpath(nbp, :stroke)\n        for p in nbp\n            sethue(\"red\")\n            circle(p[2], 0.16, :fill)\n            circle(p[3], 0.16, :fill)\n            line(p[2], p[1], :stroke)\n            line(p[3], p[4], :stroke)\n            if p[1] != p[4]\n                sethue(\"black\")\n                circle(p[1], 0.26, :fill)\n                circle(p[4], 0.26, :fill)\n            end\n        end\n    end\nend\n\n\n\n"
},

{
    "location": "polygons.html#Polygons-to-Bézier-paths-and-back-again-1",
    "page": "Polygons and paths",
    "title": "Polygons to Bézier paths and back again",
    "category": "section",
    "text": "Use the makebezierpath() and drawbezierpath() functions to make and draw Bézier paths, and pathtobezierpaths() to convert the current path to an array of Bézier paths.  A Bézier path is a sequence of Bézier curve segments; each curve segment is defined by four points: two end points and their control points.NTuple{4,Point}[\n    (Point(-129.904, 75.0),        # start point\n     Point(-162.38, 18.75),        # ^ control point\n     Point(-64.9519, -150.0),      # v control point\n     Point(-2.75546e-14, -150.0)), # end point\n    (Point(-2.75546e-14, -150.0),\n     Point(64.9519, -150.0),\n     Point(162.38, 18.75),\n     Point(129.904, 75.0)),\n    (Point(129.904, 75.0),\n     Point(97.4279, 131.25),\n     Point(-97.4279, 131.25),\n     Point(-129.904, 75.0)\n     ),\n     ...\n     ]Bézier paths are slightly different from ordinary paths in that they don't usually contain straight line segments. (Although by setting the two control points to be the same as their matching start/end points, you create straight line sections.)makebezierpath() takes the points in a polygon and converts each line segment into one Bézier curve. drawbezierpath() draws the resulting sequence.using Luxor # hide\nDrawing(600, 320, \"assets/figures/abezierpath.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsetline(1.5) # hide\nsetgray(0.5) # hide\npts = ngon(O, 150, 3, pi/6, vertices=true)\nbezpath = makebezierpath(pts)\npoly(pts, :stroke)\nfor (p1, c1, c2, p2) in bezpath[1:end-1]\n    circle.([p1, p2], 4, :stroke)\n    circle.([c1, c2], 2, :fill)\n    line(p1, c1, :stroke)\n    line(p2, c2, :stroke)\nend\nsethue(\"black\")\nsetline(3)\ndrawbezierpath(bezpath, :stroke, close=false)\nfinish() # hide\nnothing # hide(Image: path to polygon)using Luxor # hide\nDrawing(600, 320, \"assets/figures/bezierpaths.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsrand(3) # hide\ntiles = Tiler(600, 300, 1, 4, margin=20)\nfor (pos, n) in tiles\n    @layer begin\n        translate(pos)\n        pts = polysortbyangle(\n                randompointarray(\n                    Point(-tiles.tilewidth/2, -tiles.tilewidth/2),\n                    Point(tiles.tilewidth/2, tiles.tilewidth/2),\n                    4))\n        setopacity(0.7)\n        sethue(\"black\")\n        prettypoly(pts, :stroke, close=true)\n        randomhue()\n        drawbezierpath(makebezierpath(pts), :fill)\n    end\nend\nfinish() # hide\nnothing # hide(Image: path to polygon)You can convert a Bézier path to a polygon (an array of points), using the bezierpathtopoly() function. This chops up the curves into a series of straight line segments. An optional steps keyword lets you specify how many line segments are used for each Bézier curve segment.In this example, the original star is drawn in a dotted gray line, then converted to a Bézier path (drawn in orange), then the Bézier path is converted (with low resolution) to a polygon but offset by 20 units before being drawn (in blue).using Luxor # hide\nDrawing(600, 600, \"assets/figures/bezierpathtopoly.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsrand(3) # hide\n\npgon = star(O, 250, 5, 0.6, 0, vertices=true)\n\n@layer begin\n setgrey(0.5)\n setdash(\"dot\")\n poly(pgon, :stroke, close=true)\n setline(5)\nend\n\nsetline(4)\n\nsethue(\"orangered\")\n\nnp = makebezierpath(pgon)    \ndrawbezierpath(np, :stroke)\n\nsethue(\"steelblue\")\np = bezierpathtopoly(np, steps=3)    \n\nq1 = offsetpoly(p, 20)\nprettypoly(q1, :stroke, close=true)\n\nfinish() # hide\nnothing # hide(Image: path to polygon)You can convert the current path to an array of Bézier paths using the pathtobezierpaths() function.In the next example, the letter \"a\" is placed at the current position (set by move()) and then converted to an array of Bézier paths. Each Bézier path is drawn first of all in gray, then each segment is drawn (in orange) showing how the control points affect the curvature of the Bézier segments.using Luxor # hide\nDrawing(600, 400, \"assets/figures/pathtobezierpaths.png\") # hide\nbackground(\"ivory\") # hide\norigin() # hide\nst = \"a\"\nthefontsize = 500\nfontsize(thefontsize)\nsethue(\"red\")\ntex = textextents(st)\nmove(-tex[3]/2, tex[4]/2)\ntextpath(st)\nnbps = pathtobezierpaths()\nsetline(1.5)\nfor nbp in nbps\n    sethue(\"grey80\")\n    drawbezierpath(nbp, :stroke)\n    for p in nbp\n        sethue(\"darkorange\")\n        circle(p[2], 2.0, :fill)\n        circle(p[3], 2.0, :fill)\n        line(p[2], p[1], :stroke)\n        line(p[3], p[4], :stroke)\n        if p[1] != p[4]\n            sethue(\"black\")\n            circle(p[1], 2.0, :fill)\n            circle(p[4], 2.0, :fill)\n        end\n    end\nend\nfinish() # hide\nnothing # hide(Image: path to polygon)makebezierpath\ndrawbezierpath\nbezierpathtopoly\nbeziertopoly\npathtobezierpaths"
},

{
    "location": "polygons.html#Polygon-information-1",
    "page": "Polygons and paths",
    "title": "Polygon information",
    "category": "section",
    "text": "polyperimeter calculates the length of a polygon's perimeter.using Luxor # hide\nDrawing(600, 250, \"assets/figures/polyperimeter.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsrand(42) # hide\nsetline(1.5) # hide\nsethue(\"black\") # hide\nfontsize(20) # hide\np = box(O, 50, 50, vertices=true)\npoly(p, :stroke)\ntext(string(round(polyperimeter(p, closed=false))), O.x, O.y + 60)\n\ntranslate(200, 0)\n\npoly(p, :stroke, close=true)\ntext(string(round(polyperimeter(p, closed=true))), O.x, O.y + 60)\n\nfinish() # hide\nnothing # hide(Image: polyperimeter)polyportion() and polyremainder() return part of a polygon depending on the fraction you supply. For example, polyportion(p, 0.5) returns the first half of polygon p, polyremainder(p, .75) returns the last quarter of it.using Luxor # hide\nDrawing(600, 250, \"assets/figures/polyportion.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsrand(42) # hide\nsetline(1.5) # hide\nsethue(\"black\") # hide\nfontsize(20) # hide\n\np = ngon(O, 100, 7, 0, vertices=true)\npoly(p, :stroke, close=true)\nsetopacity(0.75)\n\nsetline(20)\nsethue(\"red\")\npoly(polyportion(p, 0.25), :stroke)\n\nsetline(10)\nsethue(\"green\")\npoly(polyportion(p, 0.5), :stroke)\n\nsetline(5)\nsethue(\"blue\")\npoly(polyportion(p, 0.75), :stroke)\n\nsetline(1)\ncircle(polyremainder(p, 0.75)[1], 5, :stroke)\n\nfinish() # hide\nnothing # hide(Image: polyportion)polydistances returns an array of the accumulated side lengths of a polygon.julia> p = ngon(O, 100, 7, 0, vertices=true);\njulia> polydistances(p)\n8-element Array{Real,1}:\n   0.0000\n  86.7767\n 173.553\n 260.33\n 347.107\n 433.884\n 520.66\n 607.437nearestindex returns the index of the nearest index value, an array of distances made by polydistances, to the value, and the excess value."
},

{
    "location": "polygons.html#Luxor.polyperimeter",
    "page": "Polygons and paths",
    "title": "Luxor.polyperimeter",
    "category": "Function",
    "text": "polyperimeter(p::AbstractArray{Point, 1}; closed=true)\n\nFind the total length of the sides of polygon p.\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.polyportion",
    "page": "Polygons and paths",
    "title": "Luxor.polyportion",
    "category": "Function",
    "text": "polyportion(p::AbstractArray{Point, 1}, portion=0.5; closed=true, pdist=[])\n\nReturn a portion of a polygon, starting at a value between 0.0 (the beginning) and 1.0 (the end). 0.5 returns the first half of the polygon, 0.25 the first quarter, 0.75 the first three quarters, and so on.\n\nIf you already have a list of the distances between each point in the polygon (the \"polydistances\"), you can pass them in pdist, otherwise they'll be calculated afresh, using polydistances(p, closed=closed).\n\nUse the complementary polyremainder() function to return the other part.\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.polyremainder",
    "page": "Polygons and paths",
    "title": "Luxor.polyremainder",
    "category": "Function",
    "text": "polyremainder(p::AbstractArray{Point, 1}, portion=0.5; closed=true, pdist=[])\n\nReturn the rest of a polygon, starting at a value between 0.0 (the beginning) and 1.0 (the end). 0.5 returns the last half of the polygon, 0.25 the last three quarters, 0.75 the last quarter, and so on.\n\nIf you already have a list of the distances between each point in the polygon (the \"polydistances\"), you can pass them in pdist, otherwise they'll be calculated afresh, using polydistances(p, closed=closed).\n\nUse the complementary polyportion() function to return the other part.\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.polydistances",
    "page": "Polygons and paths",
    "title": "Luxor.polydistances",
    "category": "Function",
    "text": "polydistances(p::AbstractArray{Point, 1}; closed=true)\n\nReturn an array of the cumulative lengths of a polygon.\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.nearestindex",
    "page": "Polygons and paths",
    "title": "Luxor.nearestindex",
    "category": "Function",
    "text": "nearestindex(polydistancearray, value)\n\nReturn a tuple of the index of the largest value in polydistancearray less than value, and the difference value. Array is assumed to be sorted.\n\n(Designed for use with polydistances()).\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.polyarea",
    "page": "Polygons and paths",
    "title": "Luxor.polyarea",
    "category": "Function",
    "text": "polyarea(p::AbstractArray)\n\nFind the area of a simple polygon. It works only for polygons that don't self-intersect.\n\n\n\n"
},

{
    "location": "polygons.html#Area-of-polygon-1",
    "page": "Polygons and paths",
    "title": "Area of polygon",
    "category": "section",
    "text": "Use polyarea() to find the area of a polygon. Of course, this only works for simple polygons; polygons that intersect themselves or have holes are not correctly processed.using Luxor # hide\nDrawing(600, 500, \"assets/figures/polyarea.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nfontsize(12) # hide\n\ng = GridRect(O + (200, -200), 80, 20, 85)\ntext(\"#sides\", nextgridpoint(g), halign=:right)\ntext(\"area\", nextgridpoint(g), halign=:right)\n\nfor i in 20:-1:3\n    sethue(i/20, 0.5, 1 - i/20)\n    ngonside(O, 50, i, 0, :fill)\n    sethue(\"grey40\")\n    ngonside(O, 50, i, 0, :stroke)\n    p = ngonside(O, 50, i, 0, vertices=true)\n    text(string(i), nextgridpoint(g), halign=:right)\n    text(string(round(polyarea(p), 3)), nextgridpoint(g), halign=:right)\nend\nfinish() # hide\nnothing # hide(Image: poly area)polyperimeter\npolyportion\npolyremainder\npolydistances\nnearestindex\npolyarea"
},

{
    "location": "polygons.html#Luxor.polyintersections",
    "page": "Polygons and paths",
    "title": "Luxor.polyintersections",
    "category": "Function",
    "text": "polyintersections(S::AbstractArray{Point, 1}, C::AbstractArray{Point, 1})\n\nReturn an array of the points in polygon S plus the points where polygon S crosses polygon C. Calls intersectlinepoly().\n\n\n\n"
},

{
    "location": "polygons.html#Polygon-intersections-(WIP)-1",
    "page": "Polygons and paths",
    "title": "Polygon intersections (WIP)",
    "category": "section",
    "text": "polyintersections calculates the intersection points of two polygons.using Luxor # hide\nDrawing(600, 550, \"assets/figures/polyintersections.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"grey60\") # hide\nsetopacity(0.8) # hide\npentagon = ngon(O, 250, 5, vertices=true)\nsquare = box(O + (80, 20), 280, 280, vertices=true)\n\npoly(pentagon, :stroke, close=true)\npoly(square, :stroke, close=true)\n\nsethue(\"orange\")\ncircle.(polyintersections(pentagon, square), 8, :fill)\n\nsethue(\"green\")\ncircle.(polyintersections(square, pentagon), 4, :fill)\n\nfinish() # hide\nnothing # hide(Image: polygon intersections)The returned polygon includes all the points in the first (source) polygon plus the points where the source polygon overlaps the target polygon.polyintersections"
},

{
    "location": "text.html#",
    "page": "Text",
    "title": "Text",
    "category": "page",
    "text": ""
},

{
    "location": "text.html#Text-and-fonts-1",
    "page": "Text",
    "title": "Text and fonts",
    "category": "section",
    "text": ""
},

{
    "location": "text.html#A-tale-of-two-APIs-1",
    "page": "Text",
    "title": "A tale of two APIs",
    "category": "section",
    "text": "There are two ways to draw text in Luxor. You can use either the so-called 'toy' API or the 'pro' API.Both have their advantages and disadvantages, and, given that trying to write anything definitive about font usage on three very different operating systems is an impossibility, trial and error will eventually lead to code patterns that work for you, if not other people."
},

{
    "location": "text.html#The-Toy-API-1",
    "page": "Text",
    "title": "The Toy API",
    "category": "section",
    "text": "Use:text(string, [position]) to place text at a position, otherwise at 0/0, and optionally specify the horizontal and vertical alignment\nfontface(fontname) to specify the fontname\nfontsize(fontsize) to specify the fontsize in pointsusing Luxor # hide\nDrawing(600, 100, \"assets/figures/toy-text-example.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"black\") # hide\nfontsize(18)\nfontface(\"Georgia-Bold\")\ntext(\"Georgia: a serif typeface designed in 1993 by Matthew Carter.\", halign=:center)\nfinish() # hide\nnothing # hide(Image: text placement)The label() function also uses the Toy API."
},

{
    "location": "text.html#The-Pro-API-1",
    "page": "Text",
    "title": "The Pro API",
    "category": "section",
    "text": "Use:setfont(fontname, fontsize) to specify the fontname and size in points\nsettext(text, [position]) to place the text at a position, and optionally specify horizontal and vertical alignment, rotation (in degrees counterclockwise), and the presence of any Pango-flavored markup.using Luxor # hide\nDrawing(600, 100, \"assets/figures/pro-text-example.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"black\") # hide\nsetfont(\"Georgia Bold\", 18)\nsettext(\"Georgia: a serif typeface designed in 1993 by Matthew Carter.\", halign=\"center\")\nfinish() # hide\nnothing # hide(Image: text placement)"
},

{
    "location": "text.html#Luxor.fontface",
    "page": "Text",
    "title": "Luxor.fontface",
    "category": "Function",
    "text": "fontface(fontname)\n\nSelect a font to use. (Toy API)\n\n\n\n"
},

{
    "location": "text.html#Luxor.fontsize",
    "page": "Text",
    "title": "Luxor.fontsize",
    "category": "Function",
    "text": "fontsize(n)\n\nSet the font size to n points. The default size is 10 points. (Toy API)\n\n\n\n"
},

{
    "location": "text.html#Specifying-the-font-(\"Toy\"-API)-1",
    "page": "Text",
    "title": "Specifying the font (\"Toy\" API)",
    "category": "section",
    "text": "Use fontface(fontname) to choose a font, and fontsize(n) to set the font size in points.fontface\nfontsize"
},

{
    "location": "text.html#Luxor.setfont",
    "page": "Text",
    "title": "Luxor.setfont",
    "category": "Function",
    "text": "setfont(family, fontsize)\n\nSelect a font and specify the size in points.\n\nExample:\n\nsetfont(\"Helvetica\", 24)\nsettext(\"Hello in Helvetica 24 using the Pro API\", Point(0, 10))\n\n\n\n"
},

{
    "location": "text.html#Specifying-the-font-(\"Pro\"-API)-1",
    "page": "Text",
    "title": "Specifying the font (\"Pro\" API)",
    "category": "section",
    "text": "To select a font in the Pro text API, use setfont() and supply both the font name and a size.setfont"
},

{
    "location": "text.html#Luxor.text",
    "page": "Text",
    "title": "Luxor.text",
    "category": "Function",
    "text": "text(str)\ntext(str, pos)\ntext(str, x, y)\ntext(str, pos, halign=:left)\ntext(str, valign=:baseline)\ntext(str, valign=:baseline, halign=:left)\ntext(str, pos, valign=:baseline, halign=:left)\n\nDraw the text in the string str at x/y or pt, placing the start of the string at the point. If you omit the point, it's placed at the current 0/0. In Luxor, placing text doesn't affect the current point.\n\nHorizontal alignment halign can be :left, :center, (also :centre) or :right.  Vertical alignment valign can be :baseline, :top, :middle, or :bottom.\n\nThe default alignment is :left, :baseline.  \n\n\n\n"
},

{
    "location": "text.html#Placing-text-(\"Toy\"-API)-1",
    "page": "Text",
    "title": "Placing text (\"Toy\" API)",
    "category": "section",
    "text": "Use text() to place text.using Luxor # hide\nDrawing(400, 150, \"assets/figures/text-placement.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nfontsize(80) # hide\nsethue(\"black\") # hide\npt1 = Point(-100, 0)\npt2 = Point(0, 0)\npt3 = Point(100, 0)\nsethue(\"black\")\ntext(\"1\",  pt1, halign=:left,   valign = :bottom)\ntext(\"2\",  pt2, halign=:center, valign = :bottom)\ntext(\"3\",  pt3, halign=:right,  valign = :bottom)\ntext(\"4\",  pt1, halign=:left,   valign = :top)\ntext(\"5 \", pt2, halign=:center, valign = :top)\ntext(\"6\",  pt3, halign=:right,  valign = :top)\nsethue(\"red\")\nmap(p -> circle(p, 4, :fill), [pt1, pt2, pt3])\nfinish() # hide\nnothing # hide(Image: text placement)text"
},

{
    "location": "text.html#Luxor.settext",
    "page": "Text",
    "title": "Luxor.settext",
    "category": "Function",
    "text": "settext(text, pos;\n    halign = \"left\",\n    valign = \"bottom\",\n    angle  = 0,\n    markup = false)\n\nsettext(text;\n    kwargs)\n\nDraw the text at pos (if omitted defaults to 0/0). If no font is specified, on macOS the default font is Times Roman.\n\nTo align the text, use halign, one of \"left\", \"center\", or \"right\", and valign, one of \"top\", \"center\", or \"bottom\".\n\nangle is the rotation - in counterclockwise degrees.\n\nIf markup is true, then the string can contain some HTML-style markup. Supported tags include:\n\n<b>, <i>, <s>, <sub>, <sup>, <small>, <big>, <u>, <tt>, and <span>\n\nThe <span> tag can contains things like this:\n\n<span font='26' background='green' foreground='red'>unreadable text</span>\n\n\n\n"
},

{
    "location": "text.html#Placing-text-(\"Pro\"-API)-1",
    "page": "Text",
    "title": "Placing text (\"Pro\" API)",
    "category": "section",
    "text": "Use settext() to place text. You can include some pseudo-HTML markup.using Luxor # hide\nDrawing(400, 150, \"assets/figures/pro-text-placement.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\naxes()\nsethue(\"black\")\nsettext(\"<span font='26' background ='green' foreground='red'> Hey</span>\n    <i>italic</i> <b>bold</b> <sup>superscript</sup>\n    <tt>monospaced</tt>\",\n    halign=\"center\",\n    markup=true,\n    angle=10)\nfinish() # hide\nnothing # hide(Image: pro text placement)settext"
},

{
    "location": "text.html#Notes-on-fonts-1",
    "page": "Text",
    "title": "Notes on fonts",
    "category": "section",
    "text": "On macOS, the fontname required by the Toy API's fontface() should be the PostScript name of a currently activated font. You can find this out using, for example, the FontBook application.On macOS, a list of currently activated fonts can be found (after a while) with the shell command:system_profiler SPFontsDataTypeFonts currently activated by a Font Manager can be found and used by the Toy API but not by the Pro API (at least on my macOS computer currently).On macOS, you can obtain a list of fonts that fontconfig considers are installed and available for use (via the Pro Text API with setfont()) using the shell command:fc-list | cut -f 2 -d \":\"although typically this lists only those fonts in /System/Library/Fonts and /Library/Fonts, and not ~/Library/Fonts.(There is a Julia interface to fontconfig at Fontconfig.jl.)In the Pro API, the default font is Times Roman (on macOS). In the Toy API, the default font is Helvetica (on macOS).Cairo (and hence Luxor) doesn't support emoji currently. 😢"
},

{
    "location": "text.html#Luxor.textpath",
    "page": "Text",
    "title": "Luxor.textpath",
    "category": "Function",
    "text": "textpath(t)\n\nConvert the text in string t to a new path, for subsequent filling/stroking etc...\n\n\n\n"
},

{
    "location": "text.html#Text-to-paths-1",
    "page": "Text",
    "title": "Text to paths",
    "category": "section",
    "text": "textpath() converts the text into graphic paths suitable for further manipulation.textpath"
},

{
    "location": "text.html#Luxor.textextents",
    "page": "Text",
    "title": "Luxor.textextents",
    "category": "Function",
    "text": "textextents(str)\n\nReturn an array of six Float64s containing the measurements of the string str when set using the current font settings (Toy API):\n\n1 x_bearing\n\n2 y_bearing\n\n3 width\n\n4 height\n\n5 x_advance\n\n6 y_advance\n\nThe x and y bearings are the displacement from the reference point to the upper-left corner of the bounding box. It is often zero or a small positive value for x displacement, but can be negative x for characters like \"j\"; it's almost always a negative value for y displacement.\n\nThe width and height then describe the size of the bounding box. The advance takes you to the suggested reference point for the next letter. Note that bounding boxes for subsequent blocks of text can overlap if the bearing is negative, or the advance is smaller than the width would suggest.\n\nExample:\n\ntextextents(\"R\")\n\nreturns\n\n[1.18652; -9.68335; 8.04199; 9.68335; 9.74927; 0.0]\n\n\n\n"
},

{
    "location": "text.html#Font-dimensions-(\"toy\"-API)-1",
    "page": "Text",
    "title": "Font dimensions (\"toy\" API)",
    "category": "section",
    "text": "The textextents(str) function gets an array of dimensions of the string str, given the current font.(Image: textextents)The green dot is the text placement point and reference point for the font, the yellow circle shows the text block's x and y bearings, and the blue dot shows the advance point where the next character should be placed.textextents"
},

{
    "location": "text.html#Luxor.label",
    "page": "Text",
    "title": "Luxor.label",
    "category": "Function",
    "text": "label(txt::String, alignment::Symbol=:N, pos::Point=O; offset=5)\n\nAdd a text label at a point, positioned relative to that point, for example, :N signifies North and places the text directly above that point.\n\nUse one of :N, :S, :E, :W, :NE, :SE, :SW, :NW to position the label relative to that point.\n\nlabel(\"text\")          # positions text at North (above), relative to the origin\nlabel(\"text\", :S)      # positions text at South (below), relative to the origin\nlabel(\"text\", :S, pt)  # positions text South of pt\nlabel(\"text\", :N, pt, offset=20)  # positions text North of pt, offset by 20\n\nThe default offset is 5 units.\n\n\n\n"
},

{
    "location": "text.html#Labels-1",
    "page": "Text",
    "title": "Labels",
    "category": "section",
    "text": "The label() function places text relative to a specific point, and you can use compass points to indicate where it should be. So :N (for North) places a text label directly above the point.using Luxor # hide\nDrawing(400, 250, \"assets/figures/labels.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"black\")\nfontsize(15)\noctagon = ngon(O, 100, 8, 0, vertices=true)\n\ncompass = [:SE, :S, :SW, :W, :NW, :N, :NE, :E, :SE]\n\nfor i in 1:8\n    circle(octagon[i], 2, :fill)\n    label(string(compass[i]), compass[i], octagon[i])\nend\n\nfinish() # hide\nnothing # hide(Image: labels)label"
},

{
    "location": "text.html#Luxor.textcurve",
    "page": "Text",
    "title": "Luxor.textcurve",
    "category": "Function",
    "text": "Place a string of text on a curve. It can spiral in or out.\n\ntextcurve(the_text, start_angle, start_radius, x_pos = 0, y_pos = 0;\n          # optional keyword arguments:\n          spiral_ring_step = 0,    # step out or in by this amount\n          letter_spacing = 0,      # tracking/space between chars, tighter is (-), looser is (+)\n          spiral_in_out_shift = 0, # + values go outwards, - values spiral inwards\n          clockwise = true\n          )\n\nstart_angle is relative to +ve x-axis, arc/circle is centered on (x_pos,y_pos) with radius start_radius.\n\n\n\n"
},

{
    "location": "text.html#Luxor.textcurvecentered",
    "page": "Text",
    "title": "Luxor.textcurvecentered",
    "category": "Function",
    "text": "textcurvecentered(the_text, the_angle, the_radius, center::Point;\n      clockwise = true,\n      letter_spacing = 0,\n      baselineshift = 0\n\nThis version of the textcurve() function is designed for shorter text strings that need positioning around a circle. (A cheesy effect much beloved of hipster brands and retronauts.)\n\nletter_spacing adjusts the tracking/space between chars, tighter is (-), looser is (+)).  baselineshift moves the text up or down away from the baseline.\n\ntextcurvecentred (UK spelling) is a synonym\n\n\n\n"
},

{
    "location": "text.html#Text-on-a-curve-1",
    "page": "Text",
    "title": "Text on a curve",
    "category": "section",
    "text": "Use textcurve(str) to draw a string str on a circular arc or spiral.(Image: text on a curve or spiral)using Luxor\nDrawing(1800, 1800, \"/tmp/text-spiral.png\")\norigin()\nbackground(\"ivory\")\nfontsize(18)\nfontface(\"LucidaSansUnicode\")\nsethue(\"royalblue4\")\ntextstring = join(names(Base), \" \")\ntextcurve(\"this spiral contains every word in julia names(Base): \" * textstring,\n    -pi/2,\n    800, 0, 0,\n    spiral_in_out_shift = -18.0,\n    letter_spacing = 0,\n    spiral_ring_step = 0)\nfontsize(35)\nfontface(\"Agenda-Black\")\ntextcentered(\"julia names(Base)\", 0, 0)\nfinish()\npreview()For shorter strings, textcurvecentered() tries to place the text on a circular arc by its center point.using Luxor # hide\nDrawing(400, 250, \"assets/figures/text-centered.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nfontface(\"Arial-Black\")\nfontsize(24) # hide\nsethue(\"black\") # hide\nsetdash(\"dot\") # hide\nsetline(0.25) # hide\ncircle(O, 100, :stroke)\ntextcurvecentered(\"hello world\", -pi/2, 100, O;\n    clockwise = true,\n    letter_spacing = 0,\n    baselineshift = -20\n    )\ntextcurvecentered(\"hello world\", pi/2, 100, O;\n    clockwise = false,\n    letter_spacing = 0,\n    baselineshift = 10\n    )\nfinish() # hide\nnothing # hide(Image: text centered on curve)textcurve\ntextcurvecentered"
},

{
    "location": "text.html#Text-clipping-1",
    "page": "Text",
    "title": "Text clipping",
    "category": "section",
    "text": "You can use newly-created text paths as a clipping region - here the text paths are filled with names of randomly chosen Julia functions:(Image: text clipping)using Luxor\n\ncurrentwidth = 1250 # pts\ncurrentheight = 800 # pts\nDrawing(currentwidth, currentheight, \"/tmp/text-path-clipping.png\")\n\norigin()\nbackground(\"darkslategray3\")\n\nfontsize(600)                             # big fontsize to use for clipping\nfontface(\"Agenda-Black\")\nstr = \"julia\"                             # string to be clipped\nw, h = textextents(str)[3:4]              # get width and height\n\ntranslate(-(currentwidth/2) + 50, -(currentheight/2) + h)\n\ntextpath(str)                             # make text into a path\nsetline(3)\nsetcolor(\"black\")\nfillpreserve()                            # fill but keep\nclip()                                    # and use for clipping region\n\nfontface(\"Monaco\")\nfontsize(10)\nnamelist = map(x->string(x), names(Base)) # get list of function names in Base.\n\nx = -20\ny = -h\nwhile y < currentheight\n    sethue(rand(7:10)/10, rand(7:10)/10, rand(7:10)/10)\n    s = namelist[rand(1:end)]\n    text(s, x, y)\n    se = textextents(s)\n    x += se[5]                            # move to the right\n    if x > w\n       x = -20                            # next row\n       y += 10\n    end\nend\n\nfinish()\npreview()"
},

{
    "location": "text.html#Luxor.textwrap",
    "page": "Text",
    "title": "Luxor.textwrap",
    "category": "Function",
    "text": "textwrap(s::String, width::Real, pos::Point; rightgutter=5)\n\nDraw the string in s by splitting it into lines, so that each line is no longer than width units. The text starts at pos such that the first line of text is drawn entirely below a line drawn horizontally through that position. Each line is aligned on the left side, below pos.\n\n\n\ntextwrap(s::String, width::Real, pos::Point, linefunc::Function; rightgutter=5)\n\nDraw the string in s by splitting it into lines, so that each line is no longer than width units. Before each line, run a function linefunc(linenumber, linetext, startpos, lineheight), with arguments linenumber, linetext, startpos, and lineheight of the line that's about to be drawn.\n\n\n\n"
},

{
    "location": "text.html#Luxor.splittext",
    "page": "Text",
    "title": "Luxor.splittext",
    "category": "Function",
    "text": "splittext(s)\n\nSplit the text in string s into an array, but keep all the separators attached to the preceding word.\n\n\n\n"
},

{
    "location": "text.html#Text-wrapping-1",
    "page": "Text",
    "title": "Text wrapping",
    "category": "section",
    "text": "Longer lines of text can be made to wrap inside an imaginary rectangle with textwrap(). Specify the required width of the rectangle, and the location of the top left corner.\n\nusing Luxor # hide\nDrawing(500, 400, \"assets/figures/text-wrapping.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nfontface(\"Georgia\")\nfontsize(12) # hide\nsethue(\"black\") # hide\n\nloremipsum = \"\"\"Lorem ipsum dolor sit amet, consectetur\nadipiscing elit. Nunc placerat lorem ullamcorper,\nsagittis massa et, elementum dui. Sed dictum ipsum vel\ncommodo pellentesque. Aliquam erat volutpat. Nam est\ndolor, vulputate a molestie aliquet, rutrum quis lectus.\nSed lectus mauris, tristique et tempor id, accumsan\npharetra lacus. Donec quam magna, accumsan a quam\nquis, mattis hendrerit nunc. Nullam vehicula leo ac\nleo tristique, a condimentum tortor faucibus.\"\"\"\n\nsetdash(\"dot\")\nbox(O, 200, 200, :stroke)\ntextwrap(loremipsum, 200, O - (200/2, 200/2))\n\nfinish() # hide\nnothing # hide(Image: text wrapping)textwrap() accepts a function that allows you to insert code that responds to the next line's linenumber, contents, position, and height.using Luxor, Colors # hide\nDrawing(500, 400, \"assets/figures/text-wrapping-1.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nfontface(\"Georgia\")\nfontsize(12) # hide\nsethue(\"black\") # hide\n\nloremipsum = \"\"\"Lorem ipsum dolor sit amet, consectetur\nadipiscing elit. Nunc placerat lorem ullamcorper,\nsagittis massa et, elementum dui. Sed dictum ipsum vel\ncommodo pellentesque. Aliquam erat volutpat. Nam est\ndolor, vulputate a molestie aliquet, rutrum quis lectus.\nSed lectus mauris, tristique et tempor id, accumsan\npharetra lacus. Donec quam magna, accumsan a quam\nquis, mattis hendrerit nunc. Nullam vehicula leo ac\nleo tristique, a condimentum tortor faucibus.\"\"\"\n\ntextwrap(loremipsum, 200, O - (200/2, 200/2), \n    (lnumber, str, pt, h) -> begin\n        sethue(Colors.HSB(rescale(lnumber, 1, 15, 0, 360), 1, 1))\n        text(string(\"line \", lnumber), pt - (50, 0))\n    end)\n\nfinish() # hide\nnothing # hide(Image: text wrapped)textwrap\nsplittext"
},

{
    "location": "transforms.html#",
    "page": "Transforms and matrices",
    "title": "Transforms and matrices",
    "category": "page",
    "text": ""
},

{
    "location": "transforms.html#Luxor.scale",
    "page": "Transforms and matrices",
    "title": "Luxor.scale",
    "category": "Function",
    "text": "scale(x, y)\n\nScale workspace by x and y.\n\nExample:\n\nscale(0.2, 0.3)\n\n\n\nscale(f)\n\nScale workspace by f in both x and y.\n\n\n\n"
},

{
    "location": "transforms.html#Luxor.rotate",
    "page": "Transforms and matrices",
    "title": "Luxor.rotate",
    "category": "Function",
    "text": "rotate(a::Float64)\n\nRotate workspace by a radians clockwise (from positive x-axis to positive y-axis).\n\n\n\n"
},

{
    "location": "transforms.html#Luxor.translate",
    "page": "Transforms and matrices",
    "title": "Luxor.translate",
    "category": "Function",
    "text": "translate(x::Real, y::Real)\ntranslate(point)\n\nTranslate the workspace by x and y or by moving the origin to pt.\n\n\n\n"
},

{
    "location": "transforms.html#Transforms-and-matrices-1",
    "page": "Transforms and matrices",
    "title": "Transforms and matrices",
    "category": "section",
    "text": "For basic transformations of the drawing space, use scale(sx, sy), rotate(a), and translate(tx, ty).translate() shifts the current axes by the specified amounts in x and y. It's relative and cumulative, rather than absolute:using Luxor, Colors # hide\nDrawing(600, 200, \"assets/figures/translate.png\") # hide\nbackground(\"white\") # hide\nsrand(1) # hide\nsetline(1) # hide\norigin()\nfor i in range(0, 30, 6)\n    sethue(HSV(i, 1, 1)) # from Colors\n    setopacity(0.5)\n    circle(0, 0, 40, :fillpreserve)\n    setcolor(\"black\")\n    strokepath()\n    translate(50, 0)\nend\nfinish() # hide\nnothing # hide(Image: translate)scale(x, y) or scale(n) scales the current workspace by the specified amounts. Again, it's relative to the current scale, not to the document's original.using Luxor, Colors # hide\nDrawing(400, 200, \"assets/figures/scale.png\") # hide\nbackground(\"white\") # hide\nsrand(1) # hide\nsetline(1) # hide\norigin()\nfor i in range(0, 30, 6)\n    sethue(HSV(i, 1, 1)) # from Colors\n    circle(0, 0, 90, :fillpreserve)\n    setcolor(\"black\")\n    strokepath()\n    scale(0.8, 0.8)\nend\nfinish() # hide\nnothing # hide(Image: scale)rotate() rotates the current workspace by the specifed amount about the current 0/0 point. It's relative to the previous rotation, not to the document's original.using Luxor # hide\nDrawing(400, 200, \"assets/figures/rotate.png\") # hide\nbackground(\"white\") # hide\nsrand(1) # hide\nsetline(1) # hide\norigin()\nsetopacity(0.7) # hide\nfor i in 1:8\n    randomhue()\n    squircle(Point(40, 0), 20, 30, :fillpreserve)\n    sethue(\"black\")\n    strokepath()\n    rotate(pi/4)\nend\nfinish() # hide\nnothing # hide(Image: rotate)scale\nrotate\ntranslateTo return home after many changes, you can use setmatrix([1, 0, 0, 1, 0, 0]) to reset the matrix to the default. origin() resets the matrix then moves the origin to the center of the page."
},

{
    "location": "transforms.html#Luxor.getmatrix",
    "page": "Transforms and matrices",
    "title": "Luxor.getmatrix",
    "category": "Function",
    "text": "getmatrix()\n\nGet the current matrix. Returns an array of six float64 numbers:\n\nxx component of the affine transformation\nyx component of the affine transformation\nxy component of the affine transformation\nyy component of the affine transformation\nx0 translation component of the affine transformation\ny0 translation component of the affine transformation\n\nSome basic matrix transforms:\n\ntranslate\n\ntransform([1, 0, 0, 1, dx, dy]) shifts by dx, dy\n\nscale\n\ntransform([fx 0 0 fy 0 0]) scales by fx and fy\n\nrotate\n\ntransform([cos(a), -sin(a), sin(a), cos(a), 0, 0]) rotates around to a radians\n\nrotate around O: [c -s s c 0 0]\n\nshear\n\ntransform([1 0 a 1 0 0]) shears in x direction by a\n\nshear in y: [1  B 0  1 0 0]\nx-skew\n\ntransform([1, 0, tan(a), 1, 0, 0]) skews in x by a\n\ny-skew\n\ntransform([1, tan(a), 0, 1, 0, 0]) skews in y by a\n\nflip\n\ntransform([fx, 0, 0, fy, centerx * (1 - fx), centery * (fy-1)]) flips with center at centerx/centery\n\nreflect\n\ntransform([1 0 0 -1 0 0]) reflects in xaxis\n\ntransform([-1 0 0 1 0 0]) reflects in yaxis\n\nWhen a drawing is first created, the matrix looks like this:\n\ngetmatrix() = [1.0, 0.0, 0.0, 1.0, 0.0, 0.0]\n\nWhen the origin is moved to 400/400, it looks like this:\n\ngetmatrix() = [1.0, 0.0, 0.0, 1.0, 400.0, 400.0]\n\nTo reset the matrix to the original:\n\nsetmatrix([1.0, 0.0, 0.0, 1.0, 0.0, 0.0])\n\n\n\n"
},

{
    "location": "transforms.html#Luxor.setmatrix",
    "page": "Transforms and matrices",
    "title": "Luxor.setmatrix",
    "category": "Function",
    "text": "setmatrix(m::AbstractArray)\n\nChange the current matrix to matrix m. Use getmatrix() to get the current matrix.\n\n\n\n"
},

{
    "location": "transforms.html#Luxor.transform",
    "page": "Transforms and matrices",
    "title": "Luxor.transform",
    "category": "Function",
    "text": "transform(a::AbstractArray)\n\nModify the current matrix by multiplying it by matrix a.\n\nFor example, to skew the current state by 45 degrees in x and move by 20 in y direction:\n\ntransform([1, 0, tand(45), 1, 0, 20])\n\nUse getmatrix() to get the current matrix.\n\n\n\n"
},

{
    "location": "transforms.html#Luxor.crossproduct",
    "page": "Transforms and matrices",
    "title": "Luxor.crossproduct",
    "category": "Function",
    "text": "crossproduct(p1::Point, p2::Point)\n\nThis is the perp dot product, really, not the crossproduct proper (which is 3D):\n\ndot(p1, perpendicular(p2))\n\n\n\n"
},

{
    "location": "transforms.html#Luxor.blendmatrix",
    "page": "Transforms and matrices",
    "title": "Luxor.blendmatrix",
    "category": "Function",
    "text": "blendmatrix(b::Blend, m)\n\nSet the matrix of a blend.\n\nTo apply a sequence of matrix transforms to a blend:\n\nA = [1 0 0 1 0 0]\nAj = cairotojuliamatrix(A)\nSj = scalingmatrix(2, .2) * Aj\nTj = translationmatrix(10, 0) * Sj\nA1 = juliatocairomatrix(Tj)\nblendmatrix(b, As)\n\n\n\n"
},

{
    "location": "transforms.html#Luxor.rotationmatrix",
    "page": "Transforms and matrices",
    "title": "Luxor.rotationmatrix",
    "category": "Function",
    "text": "rotationmatrix(a)\n\nReturn a 3x3 Julia matrix that will apply a rotation through a radians.\n\n\n\n"
},

{
    "location": "transforms.html#Luxor.scalingmatrix",
    "page": "Transforms and matrices",
    "title": "Luxor.scalingmatrix",
    "category": "Function",
    "text": "scalingmatrix(sx, sy)\n\nReturn a 3x3 Julia matrix that will apply a scaling by sx and sy.\n\n\n\n"
},

{
    "location": "transforms.html#Luxor.translationmatrix",
    "page": "Transforms and matrices",
    "title": "Luxor.translationmatrix",
    "category": "Function",
    "text": "translationmatrix(x, y)\n\nReturn a 3x3 Julia matrix that will apply a translation in x and y.\n\n\n\n"
},

{
    "location": "transforms.html#Luxor.getscale",
    "page": "Transforms and matrices",
    "title": "Luxor.getscale",
    "category": "Function",
    "text": "getscale(R::Matrix)\ngetscale()\n\nGet the current scale of a Julia 3x3 matrix, or the current Luxor scale.\n\nReturns a tuple of x and y values.\n\n\n\n"
},

{
    "location": "transforms.html#Luxor.gettranslation",
    "page": "Transforms and matrices",
    "title": "Luxor.gettranslation",
    "category": "Function",
    "text": "gettranslation(R::Matrix)\ngettranslation()\n\nGet the current translation of a Julia 3x3 matrix, or the current Luxor translation.\n\nReturns a tuple of x and y values.\n\n\n\n"
},

{
    "location": "transforms.html#Luxor.getrotation",
    "page": "Transforms and matrices",
    "title": "Luxor.getrotation",
    "category": "Function",
    "text": "getrotation(R::Matrix)\ngetrotation()\n\nGet the rotation of a Julia 3x3 matrix, or the current Luxor rotation.\n\nR = beginbmatrix\na  b  tx \nc  d  ty \n0  0  1  \nendbmatrix\n\nThe rotation angle is atan2(-b, a) or atan2(c, d).\n\n\n\n"
},

{
    "location": "transforms.html#Luxor.cairotojuliamatrix",
    "page": "Transforms and matrices",
    "title": "Luxor.cairotojuliamatrix",
    "category": "Function",
    "text": "cairotojuliamatrix(c)\n\nReturn a 3x3 Julia matrix that's the equivalent of the six-element matrix in c.\n\n\n\n"
},

{
    "location": "transforms.html#Luxor.juliatocairomatrix",
    "page": "Transforms and matrices",
    "title": "Luxor.juliatocairomatrix",
    "category": "Function",
    "text": "juliatocairomatrix(c)\n\nReturn a six-element matrix that's the equivalent of the 3x3 Julia matrix in c.\n\n\n\n"
},

{
    "location": "transforms.html#Matrices-and-transformations-1",
    "page": "Transforms and matrices",
    "title": "Matrices and transformations",
    "category": "section",
    "text": "In Luxor, there's always a current matrix. It's a six element array:beginbmatrix\n1  0  0 \n0  1  0 \nendbmatrixwhich is usually handled in Julia/Cairo/Luxor as a simple vector/array:julia> getmatrix()\n6-element Array{Float64,1}:\n   1.0\n   0.0\n   0.0\n   1.0\n   0.0\n   0.0transform(a) transforms the current workspace by 'multiplying' the current matrix with matrix a. For example, transform([1, 0, xskew, 1, 50, 0]) skews the current matrix by xskew radians and moves it 50 in x and 0 in y.using Luxor # hide\nfname = \"assets/figures/transform.png\" # hide\npagewidth, pageheight = 450, 100 # hide\nDrawing(pagewidth, pageheight, fname) # hide\norigin() # hide\nbackground(\"white\") # hide\ntranslate(-200, 0) # hide\n\nfunction boxtext(p, t)\n    sethue(\"grey30\")\n    box(p, 30, 50, :fill)\n    sethue(\"white\")\n    textcentered(t, p)\nend\n\nfor i in 0:5\n    xskew = tand(i * 5.0)\n    transform([1, 0, xskew, 1, 50, 0])\n    boxtext(O, string(round(rad2deg(xskew), 1), \"°\"))\nend\n\nfinish() # hide\nnothing # hide(Image: transform)getmatrix() gets the current matrix, setmatrix(a) sets the matrix to array a.getmatrix\nsetmatrix\ntransform\ncrossproduct\nblendmatrix\nrotationmatrix\nscalingmatrix\ntranslationmatrixUse the getscale(), gettranslation(), and getrotation() functions to find the current values of the current matrix. These can also find the values of arbitrary 3x3 matrices.getscale\ngettranslation\ngetrotationYou can convert between the 6-element and 3x3 versions of a transformation matrix using the functions cairotojuliamatrix() and juliatocairomatrix().cairotojuliamatrix\njuliatocairomatrix"
},

{
    "location": "clipping.html#",
    "page": "Clipping",
    "title": "Clipping",
    "category": "page",
    "text": ""
},

{
    "location": "clipping.html#Luxor.clip",
    "page": "Clipping",
    "title": "Luxor.clip",
    "category": "Function",
    "text": "clip()\n\nEstablish a new clipping region by intersecting the current clipping region with the current path and then clearing the current path.\n\n\n\n"
},

{
    "location": "clipping.html#Luxor.clippreserve",
    "page": "Clipping",
    "title": "Luxor.clippreserve",
    "category": "Function",
    "text": "clippreserve()\n\nEstablish a new clipping region by intersecting the current clipping region with the current path, but keep the current path.\n\n\n\n"
},

{
    "location": "clipping.html#Luxor.clipreset",
    "page": "Clipping",
    "title": "Luxor.clipreset",
    "category": "Function",
    "text": "clipreset()\n\nReset the clipping region to the current drawing's extent.\n\n\n\n"
},

{
    "location": "clipping.html#Clipping-1",
    "page": "Clipping",
    "title": "Clipping",
    "category": "section",
    "text": "Use clip() to turn the current path into a clipping region, masking any graphics outside the path. clippreserve() keeps the current path, but also uses it as a clipping region. clipreset() resets it. :clip is also an action for drawing functions like circle().using Luxor # hide\nDrawing(400, 250, \"assets/figures/simpleclip.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsetline(3) # hide\nsethue(\"grey50\")\nsetdash(\"dotted\")\ncircle(O, 100, :stroke)\ncircle(O, 100, :clip)\nsethue(\"magenta\")\nbox(O, 125, 200, :fill)\nfinish() # hide\nnothing # hide(Image: simple clip)clip\nclippreserve\nclipresetThis example uses the built-in function that draws the Julia logo. The clip action lets you use the shapes as a mask for clipping subsequent graphics, which in this example are randomly-colored circles:(Image: julia logo mask)function draw(x, y)\n    foregroundcolors = Colors.diverging_palette(rand(0:360), rand(0:360), 200, s = 0.99, b=0.8)\n    gsave()\n    translate(x-100, y)\n    julialogo(action=:clip)\n    for i in 1:500\n        sethue(foregroundcolors[rand(1:end)])\n        circle(rand(-50:350), rand(0:300), 15, :fill)\n    end\n    grestore()\nend\n\ncurrentwidth = 500 # pts\ncurrentheight = 500 # pts\nDrawing(currentwidth, currentheight, \"/tmp/clipping-tests.pdf\")\norigin()\nbackground(\"white\")\nsetopacity(.4)\ndraw(0, 0)\nfinish()\npreview()"
},

{
    "location": "images.html#",
    "page": "Images",
    "title": "Images",
    "category": "page",
    "text": ""
},

{
    "location": "images.html#Images-1",
    "page": "Images",
    "title": "Images",
    "category": "section",
    "text": ""
},

{
    "location": "images.html#Luxor.readpng",
    "page": "Images",
    "title": "Luxor.readpng",
    "category": "Function",
    "text": "readpng(pathname)\n\nRead a PNG file.\n\nThis returns a image object suitable for placing on the current drawing with placeimage(). You can access its width and height fields:\n\nimage = readpng(\"/tmp/test-image.png\")\nw = image.width\nh = image.height\n\n\n\n"
},

{
    "location": "images.html#Luxor.placeimage",
    "page": "Images",
    "title": "Luxor.placeimage",
    "category": "Function",
    "text": "placeimage(img, xpos, ypos; centered=false)\n\nPlace a PNG image on the drawing at (xpos/ypos). The image img has been previously loaded using readpng().\n\nUse keyword centered=true to place the center of the image at the position.\n\n\n\nplaceimage(img, pos; centered=false)\n\nPlace the top left corner of the PNG image on the drawing at pos.\n\nUse keyword centered=true to place the center of the image at the position.\n\n\n\nplaceimage(img, xpos, ypos, a; centered=false)\n\nPlace a PNG image on the drawing at (xpos/ypos) with transparency a.\n\nUse keyword centered=true to place the center of the image at the position.\n\n\n\nplaceimage(img, pos, a; centered=false)\n\nPlace a PNG image on the drawing at pos with transparency a.\n\nUse keyword centered=true to place the center of the image at the position.\n\n\n\n"
},

{
    "location": "images.html#Placing-images-1",
    "page": "Images",
    "title": "Placing images",
    "category": "section",
    "text": "There is some limited support for placing PNG images on the drawing. First, load a PNG image using readpng(filename).Then use placeimage() to place it by its top left corner at point x/y or pt. Access the image's dimensions with .width and .height.using Luxor # hide\nDrawing(600, 350, \"assets/figures/images.png\") # hide\norigin() # hide\nbackground(\"grey40\") # hide\nimg = readpng(\"assets/figures/julia-logo-mask.png\")\nw = img.width\nh = img.height\naxes()\nscale(0.3, 0.3)\nrotate(pi/4)\nplaceimage(img, -w/2, -h/2, .5)\nsethue(\"red\")\ncircle(-w/2, -h/2, 15, :fill)\nfinish() # hide\nnothing # hide(Image: \"Images\")readpng\nplaceimage"
},

{
    "location": "images.html#Clipping-images-1",
    "page": "Images",
    "title": "Clipping images",
    "category": "section",
    "text": "You can clip images. The following script repeatedly places the image using a circle to define a clipping path:(Image: \"Images\")using Luxor\n\nwidth, height = 4000, 4000\nmargin = 500\n\nfname = \"/tmp/test-image.pdf\"\nDrawing(width, height, fname)\norigin()\nbackground(\"grey25\")\n\nsetline(5)\nsethue(\"green\")\n\nimage = readpng(dirname(@__FILE__) * \"assets/figures/julia-logo-mask.png\")\n\nw = image.width\nh = image.height\n\npagetiles = Tiler(width, height, 7, 9)\ntw = pagetiles.tilewidth/2\nfor (pos, n) in pagetiles\n    circle(pos, tw, :stroke)\n    circle(pos, tw, :clip)\n    gsave()\n    translate(pos)\n    scale(.95, .95)\n    rotate(rand(0.0:pi/8:2pi))\n    placeimage(image, O, centered=true)\n    grestore()\n    clipreset()\nend\n\nfinish()"
},

{
    "location": "images.html#Transforming-images-1",
    "page": "Images",
    "title": "Transforming images",
    "category": "section",
    "text": "You can transform images by setting the current matrix, either with scale() and rotate() and similar, or by modifying it directly. This code skews the image and scales and rotates it in a circle:using Luxor # hide\nDrawing(600, 400, \"assets/figures/transform-images.png\") # hide\norigin() # hide\nimg = readpng(\"assets/figures/clipping-tests.png\")\nw = img.width\nh = img.height\nfor theta in 0:pi/6:2pi\n    gsave()\n        scale(.5, .5)\n        rotate(theta)\n        transform([1, 0, -pi/4, 1, 250, 0])\n        placeimage(img, -w/2, -h/2, .75)\n    grestore()\nend\n\nfinish() # hide\nnothing # hide(Image: transforming images)"
},

{
    "location": "images.html#Drawing-on-images-1",
    "page": "Images",
    "title": "Drawing on images",
    "category": "section",
    "text": "You sometimes want to draw over images, for example to annotate them with text or vector graphics. The things to be aware of are mostly to do with coordinates and transforms.In this example, we'll annotate a PNG file with some text and graphics.using Luxor # hide\n\nimage = readpng(\"assets/figures/julia-logo-mask.png\")\n\nw = image.width\nh = image.height\n\n# create a drawing surface of the same size\n\nfname = \"assets/figures/drawing_on_images.png\"\nDrawing(w, h, fname)\n\n# place the image on the Drawing - it's positioned by its top/left corner\n\nplaceimage(image, 0, 0)\n\n# now you can annotate the image. The (0/0) is at the top left.\n\nsethue(\"red\")\nfontsize(20)\ncircle(5, 5, 2, :fill)\ntext(\"(5/5)\", Point(25, 25), halign=:center)\n\narrow(Point(w/2, 50), Point(0, 50))\narrow(Point(w/2, 50), Point(w, 50))\ntext(\"width $w\", Point(w/2, 70), halign=:center)\n\n# to divide up the image into rectangular areas, temporarily position the axes at the center:\n\ngsave()\nsetline(0.2)\nsethue(\"green\")\nfontsize(12)\ntranslate(w/2, h/2)\ntiles = Tiler(w, h, 16, 10, margin=0)\nfor (pos, n) in tiles\n    box(pos, tiles.tilewidth, tiles.tileheight, :stroke)\n    text(string(n), pos, halign=:center)\nend\ngrestore()\n\n# If you want coordinates to be relative to the bottom left corner of the image, transform:\n\ntranslate(0, h)\n\n# and reflect in the x-axis\n\ntransform([1 0 0 -1 0 0])\n\n# now 0/0 is at the bottom left corner, and 100/100 is up and to the right.\n\nsethue(\"blue\")\narrow(O, Point(100, 100))\n\n# However, don't use text while flipped, because it's reversed:\n\ntext(\"I'm in reverse!\", w/2, h/2)\n\nfinish() # hide\nnothing # hide(Image: drawing on images)"
},

{
    "location": "images.html#Image-compositing-1",
    "page": "Images",
    "title": "Image compositing",
    "category": "section",
    "text": "You should be using Images.jl for most tasks involving image editing. But if you just need to composite images together, you can use the blending modes provided by setmode().using Luxor # hide\nDrawing(600, 400, \"assets/figures/image-compositing.png\") # hide\norigin() # hide\nimg = readpng(\"assets/figures/textcurvecenteredexample.png\")\nw = img.width\nh = img.height\n\nplaceimage(img, -w/2, -h/2, .5)\nsetmode(\"saturate\")\ntranslate(50, 0)\nplaceimage(img, -w/2, -h/2, .5)\n\nfinish() # hide\nnothing # hide(Image: transforming images)"
},

{
    "location": "turtle.html#",
    "page": "Turtle graphics",
    "title": "Turtle graphics",
    "category": "page",
    "text": ""
},

{
    "location": "turtle.html#Luxor.Turtle",
    "page": "Turtle graphics",
    "title": "Luxor.Turtle",
    "category": "Type",
    "text": "Turtle()\nTurtle(O)\nTurtle(0, 0)\nTurtle(O, pendown=true, orientation=0, pencolor=(1.0, 0.25, 0.25))\n\nCreate a Turtle. You can command a turtle to move and draw \"turtle graphics\".\n\nThe commands (unusually for Julia) start with a capital letter, and angles are specified in degrees.\n\nBasic commands are Forward(), Turn(), Pendown(), Penup(), Pencolor(), Penwidth(), Circle(), Orientation(), Rectangle(), and Reposition().\n\nOthers include Push(), Pop(), Message(), HueShift(), Randomize_saturation(), Reposition(), and Pen_opacity_random().\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Forward",
    "page": "Turtle graphics",
    "title": "Luxor.Forward",
    "category": "Function",
    "text": "Forward(t::Turtle, d=1)\n\nMove the turtle forward by d units. The stored position is updated.\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Turn",
    "page": "Turtle graphics",
    "title": "Luxor.Turn",
    "category": "Function",
    "text": "Turn(t::Turtle, r=5.0)\n\nIncrease the turtle's rotation by r degrees. See also Orientation.\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Circle",
    "page": "Turtle graphics",
    "title": "Luxor.Circle",
    "category": "Function",
    "text": "Circle(t::Turtle, radius=1.0)\n\nDraw a filled circle centered at the current position with the given radius.\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.HueShift",
    "page": "Turtle graphics",
    "title": "Luxor.HueShift",
    "category": "Function",
    "text": "HueShift(t::Turtle, inc=1.0)\n\nShift the Hue of the turtle's pen forward by inc. Hue values range between 0 and 360.\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Message",
    "page": "Turtle graphics",
    "title": "Luxor.Message",
    "category": "Function",
    "text": "Message(t::Turtle, txt)\n\nWrite some text at the current position.\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Orientation",
    "page": "Turtle graphics",
    "title": "Luxor.Orientation",
    "category": "Function",
    "text": "Orientation(t::Turtle, r=0.0)\n\nSet the turtle's orientation to r degrees. See also Turn.\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Randomize_saturation",
    "page": "Turtle graphics",
    "title": "Luxor.Randomize_saturation",
    "category": "Function",
    "text": "Randomize_saturation(t::Turtle)\n\nRandomize the saturation of the turtle's pen color.\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Rectangle",
    "page": "Turtle graphics",
    "title": "Luxor.Rectangle",
    "category": "Function",
    "text": "Rectangle(t::Turtle, width=10.0, height=10.0)\n\nDraw a filled rectangle centered at the current position with the given radius.\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Pen_opacity_random",
    "page": "Turtle graphics",
    "title": "Luxor.Pen_opacity_random",
    "category": "Function",
    "text": "Pen_opacity_random(t::Turtle)\n\nChange the opacity of the pen to some value at random.\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Pendown",
    "page": "Turtle graphics",
    "title": "Luxor.Pendown",
    "category": "Function",
    "text": "Pendown(t::Turtle)\n\nPut that pen down and start drawing.\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Penup",
    "page": "Turtle graphics",
    "title": "Luxor.Penup",
    "category": "Function",
    "text": "Penup(t::Turtle)\n\nPick that pen up and stop drawing.\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Pencolor",
    "page": "Turtle graphics",
    "title": "Luxor.Pencolor",
    "category": "Function",
    "text": "Pencolor(t::Turtle, r, g, b)\n\nSet the Red, Green, and Blue colors of the turtle.\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Penwidth",
    "page": "Turtle graphics",
    "title": "Luxor.Penwidth",
    "category": "Function",
    "text": "Penwidth(t::Turtle, w)\n\nSet the width of the line drawn.\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Point",
    "page": "Turtle graphics",
    "title": "Luxor.Point",
    "category": "Type",
    "text": "The Point type holds two coordinates. Currently it's immutable, so remember not try to change the values of the x and y values directly.\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Pop",
    "page": "Turtle graphics",
    "title": "Luxor.Pop",
    "category": "Function",
    "text": "Pop(t::Turtle)\n\nLift the turtle's position and orientation off a stack.\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Push",
    "page": "Turtle graphics",
    "title": "Luxor.Push",
    "category": "Function",
    "text": "Push(t::Turtle)\n\nSave the turtle's position and orientation on a stack.\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Reposition",
    "page": "Turtle graphics",
    "title": "Luxor.Reposition",
    "category": "Function",
    "text": "Reposition(t::Turtle, pos::Point)\nReposition(t::Turtle, x, y)\n\nReposition: pick the turtle up and place it at another position.\n\n\n\n"
},

{
    "location": "turtle.html#Turtle-graphics-1",
    "page": "Turtle graphics",
    "title": "Turtle graphics",
    "category": "section",
    "text": "Some simple \"turtle graphics\" functions are included. Functions to control the turtle begin with a capital letter: Forward, Turn, Circle, Orientation, Rectangle, Pendown, Penup, Pencolor, Penwidth, and Reposition, and so on, and angles are specified in degrees.using Luxor, Colors\nDrawing(600, 400, \"assets/figures/turtles.png\")  \norigin()  \nbackground(\"midnightblue\")  \n\n🐢 = Turtle() # you can type the turtle emoji with \\:turtle:\nPencolor(🐢, \"cyan\")\nPenwidth(🐢, 1.5)\nn = 5\nfor i in 1:400\n    Forward(🐢, n)\n    Turn(🐢, 89.5)\n    HueShift(🐢)\n    n += 0.75\nend\nfontsize(20)\nMessage(🐢, \"finished\")\nfinish()  \nnothing # hide(Image: text placement)The turtle commands expect a reference to a turtle as the first argument (it doesn't have to be a turtle emoji :)), and you can have any number of turtles active at a time.using Luxor, Colors # hide\nDrawing(800, 800, \"assets/figures/manyturtles.png\") # hide\norigin() # hide\nbackground(\"ivory\") # hide\nquantity = 9\nturtles = [Turtle(O, true, 2pi * rand(), (rand(), rand(), 0.5)...) for i in 1:quantity]\nReposition.(turtles, first.(collect(Tiler(800, 800, 3, 3))))\nn = 10\nPenwidth.(turtles, 0.2)\nfor i in 1:200\n    Forward.(turtles, n)\n    HueShift.(turtles)\n    Turn.(turtles, 119)\n    n += 1\nend\nfinish() # hide  \nnothing # hide(Image: text placement)Turtle\nForward\nTurn\nCircle\nHueShift\nMessage\nOrientation\nRandomize_saturation\nRectangle\nPen_opacity_random\nPendown\nPenup\nPencolor\nPenwidth\nPoint\nPop\nPush\nReposition"
},

{
    "location": "animation.html#",
    "page": "Animation",
    "title": "Animation",
    "category": "page",
    "text": ""
},

{
    "location": "animation.html#Animation-helper-functions-1",
    "page": "Animation",
    "title": "Animation helper functions",
    "category": "section",
    "text": "Luxor provides some functions to help you create animations—at least, it provides some assistance in creating lots of individual frames that can later be stitched together to form a moving animation, such as a GIF or MP4.There are four steps to creating an animation.1 Use Movie to create a Movie object which determines the title and dimensions.2 Define some functions that draw the graphics for specific frames.3 Define one or more Scenes that call these functions for specific frames.4 Call the animate(movie::Movie, scenes) function, passing in the scenes. This creates all the frames and saves them in a temporary directory. Optionally, you can ask for ffmpeg (if it's installed) to make an animated GIF for you."
},

{
    "location": "animation.html#Luxor.Movie",
    "page": "Animation",
    "title": "Luxor.Movie",
    "category": "Type",
    "text": "The Movie and Scene types and the animate() function are designed to help you create the frames that can be used to make an animated GIF or movie.\n\n1 Provide width, height, title, and optionally a frame range to the Movie constructor:\n\ndemo = Movie(400, 400, \"test\", 1:500)\n\n2 Define one or more scenes and scene-drawing functions.\n\n3 Run the animate() function, calling those scenes.\n\nExample\n\nbang = Movie(400, 100, \"bang\")\n\nbackdrop(scene, framenumber) =  background(\"black\")\n\nfunction frame1(scene, framenumber)\n    background(\"white\")\n    sethue(\"black\")\n    eased_n = scene.easingfunction(framenumber, 0, 1, scene.framerange.stop)\n    circle(O, 40 * eased_n, :fill)\nend\n\nanimate(bang, [\n    Scene(bang, backdrop, 0:200),\n    Scene(bang, frame1, 0:200, easingfunction=easeinsine)],\n    creategif=true,\n    pathname=\"/tmp/animationtest.gif\")\n\n\n\n\n"
},

{
    "location": "animation.html#Luxor.Scene",
    "page": "Animation",
    "title": "Luxor.Scene",
    "category": "Type",
    "text": "The Scene type defines a function to be used to render a range of frames in a movie.\n\nthe movie created by Movie()\nthe framefunction is a function taking two arguments: the scene and the framenumber.\nthe framerange determines which frames are processed by the function. Defaults to the entire movie.\nthe optional easingfunction can be accessed by the framefunction to vary the transition speed\n\n\n\n"
},

{
    "location": "animation.html#Luxor.animate",
    "page": "Animation",
    "title": "Luxor.animate",
    "category": "Function",
    "text": "animate(movie::Movie, scenelist::AbstractArray{Scene, 1};\n        creategif=false,\n        pathname=\"\"\n        framerate=30)\n\nCreate the movie defined in movie by rendering the frames define in the array of scenes in scenelist.\n\nIf creategif is true, the function tries to call ffmpeg on the resulting frames to build a GIF animation. This will be stored in pathname (an existing file will be overwritten; use a \".gif\" suffix), or in (movietitle).gif in a temporary directory.\n\nExample\n\nanimate(bang, [\n    Scene(bang, backdrop, 0:200),\n    Scene(bang, frame1, 0:200, easingfunction=easeinsine)],\n    creategif=true,\n    pathname=\"/tmp/animationtest.gif\")\n\n\n\nanimate(movie::Movie, scene::Scene; creategif=false, framerate=30)\n\nCreate the movie defined in movie by rendering the frames define in scene.\n\n\n\n"
},

{
    "location": "animation.html#Example-1",
    "page": "Animation",
    "title": "Example",
    "category": "section",
    "text": "using Luxor\n\ndemo = Movie(400, 400, \"test\")\n\nfunction backdrop(scene, framenumber)\n    background(\"black\")\nend\n\nfunction frame(scene, framenumber)\n    sethue(Colors.HSV(framenumber, 1, 1))\n    eased_n = scene.easingfunction(framenumber, 0, 1, scene.framerange.stop)\n    circle(polar(100, -pi/2 - (eased_n * 2pi)), 80, :fill)\n    text(string(\"frame $framenumber of $(scene.framerange.stop)\"),\n        Point(O.x, O.y-190),\n        halign=:center)\nend\n\nanimate(demo, [\n    Scene(demo, backdrop, 0:359),\n    Scene(demo, frame, 0:359, easingfunction=easeinoutcubic)\n    ],\n    creategif=true)(Image: animation example)Movie\nScene\nanimate"
},

{
    "location": "animation.html#Making-the-animation-1",
    "page": "Animation",
    "title": "Making the animation",
    "category": "section",
    "text": "For best results, you'll have to learn how to use something like ffmpeg, with its hundreds of options, which include codec selction, framerate adjustment and color palette tweaking. The creategif option for the animate function makes an attempt at running ffmpeg and assumes that it's installed. Inside animate(), the first pass creates a GIF color palette, the second builds the file:run(`ffmpeg -f image2 -i $(tempdirectory)/%10d.png -vf palettegen -y $(seq.stitle)-palette.png`)\n\nrun(`ffmpeg -framerate 30 -f image2 -i $(tempdirectory)/%10d.png -i $(seq.stitle)-palette.png -lavfi paletteuse -y /tmp/$(seq.stitle).gif`)Many movie editing programs, such as Final Cut Pro, will also let you import sequences of still images into a movie timeline."
},

{
    "location": "animation.html#Using-scenes-1",
    "page": "Animation",
    "title": "Using scenes",
    "category": "section",
    "text": "Sometimes you want to construct an animation that has different components, layers, or scenes. To do this, you can specify scenes that are drawn only for specific frames.As an example, consider a simple example showing the sun for each hour of a 24 hour day.sun24demo = Movie(400, 400, \"sun24\", 0:23)The backgroundfunction() draws a background that's used for all frames:function backgroundfunction(scene::Scene, framenumber)\n    background(\"black\")\nendA nightskyfunction() draws the night sky:function nightskyfunction(scene::Scene, framenumber)\n    sethue(\"midnightblue\")\n    box(O, 400, 400, :fill)\nendA dayskyfunction() draws the daytime sky:function dayskyfunction(scene::Scene, framenumber)\n    sethue(\"skyblue\")\n    box(O, 400, 400, :fill)\nendThe sunfunction() draws a sun at 24 positions during the day:function sunfunction(scene::Scene, framenumber)\n    i = rescale(framenumber, 0, 23, 2pi, 0)\n    gsave()\n    sethue(\"yellow\")\n    circle(polar(150, i), 20, :fill)\n    grestore()\nendFinally a groundfunction() draws the ground:function groundfunction(scene::Scene, framenumber)\n    gsave()\n    sethue(\"brown\")\n    box(Point(O.x, O.y + 100), 400, 200, :fill)\n    grestore()\n    sethue(\"white\")\nendNow define a group of Scenes that make up the movie. The scenes specify which functions are to be used, and for which frames:backdrop  = Scene(sun24demo, backgroundfunction, 0:23)\nnightsky  = Scene(sun24demo, nightskyfunction, 0:6)\nnightsky1 = Scene(sun24demo, nightskyfunction, 17:23)\ndaysky    = Scene(sun24demo, dayskyfunction, 5:19)\nsun       = Scene(sun24demo, sunfunction, 6:18)\nground    = Scene(sun24demo, groundfunction, 0:23)Finally, the animate function scans the scenes in the scenelist for a movie, and calls the functions for each frame to build the animation:animate(sun24demo, [backdrop, nightsky, nightsky1, daysky, sun, ground],\n    framerate=5,\n    creategif=true)(Image: sun24 animation)Notice that for some frames, such as frame 0, 1, or 23, three of the functions are called: for others, such as 7 and 8, four or more functions are called. Also notice that the order of scenes and the use of backgrounds can be important."
},

{
    "location": "animation.html#Easing-functions-1",
    "page": "Animation",
    "title": "Easing functions",
    "category": "section",
    "text": "Transitions for animations often use non-constant and non-linear motions, and these are usually provided by easing functions. Luxor defines some of the basic easing functions and they're listed in the (unexported) array Luxor.easingfunctions. Each scene can have one easing function.Most easing functions have names constructed like this:ease[in|out|inout][expo|circ|quad|cubic|quart|quint]and there's an easingflat() linear transition.One way to use an easing function in a frame-making function is like this: function moveobject(scene, framenumber)\n    background(\"white\")\n    ...\n    easedframenumber = scene.easingfunction(framenumber, 0, 1, scene.framerange.stop)\n    ...This takes the current frame number, compares it with the end frame number of the scene, then adjusts it.In the next example, the purple dot has sinusoidal easing motion, the green has cubic, and the red has quintic. They all traverse the drawing in the same time, but have different accelerations and decelerations.(Image: animation easing example)fastandfurious = Movie(400, 100, \"easingtests\")\nbackdrop(scene, framenumber) =  background(\"black\")\nfunction frame1(scene, framenumber)\n    sethue(\"purple\")\n    eased_n = scene.easingfunction(framenumber, 0, 1, scene.framerange.stop)\n    circle(Point(-180 + (360 * eased_n), -20), 10, :fill)\nend\nfunction frame2(scene, framenumber)\n    sethue(\"green\")\n    eased_n = scene.easingfunction(framenumber, 0, 1, scene.framerange.stop)\n    circle(Point(-180 + (360 * eased_n), 0), 10, :fill)\nend\nfunction frame3(scene, framenumber)\n    sethue(\"red\")\n    eased_n = scene.easingfunction(framenumber, 0, 1, scene.framerange.stop)\n    circle(Point(-180 + (360 * eased_n), 20), 10, :fill)\nend\nanimate(fastandfurious, [\n    Scene(fastandfurious, backdrop, 0:200),\n    Scene(fastandfurious, frame1,   0:200, easingfunction=easeinsine),\n    Scene(fastandfurious, frame2,   0:200, easingfunction=easeinoutcubic),\n    Scene(fastandfurious, frame3,   0:200, easingfunction=easeinoutquint)\n    ],\n    creategif=true)Here's the definition of one of the easing functions:function easeoutquad(t, b, c, d)\n   t /= d\n   return -c * t * (t - 2) + b\nendHere:t is the current time (framenumber) of the transition\nb is the beginning value of the property\nc is the change between the beginning and destination value of the property\nd is the total length of the transition"
},

{
    "location": "moreexamples.html#",
    "page": "More examples",
    "title": "More examples",
    "category": "page",
    "text": "DocTestSetup = quote\n    using Luxor\nend"
},

{
    "location": "moreexamples.html#More-examples-1",
    "page": "More examples",
    "title": "More examples",
    "category": "section",
    "text": "One place to look for examples is the Luxor/test directory.(Image: \"tiled images\")"
},

{
    "location": "moreexamples.html#An-early-test-1",
    "page": "More examples",
    "title": "An early test",
    "category": "section",
    "text": "(Image: Luxor test)using Luxor\nDrawing(1200, 1400, \"basic-test.png\") # or PDF/SVG filename for PDF or SVG\norigin()\nbackground(\"purple\")\nsetopacity(0.7)                      # opacity from 0 to 1\nsethue(0.3,0.7,0.9)                  # sethue sets the color but doesn't change the opacity\nsetline(20)                          # line width\n\nrect(-400,-400,800,800, :fill)       # or :stroke, :fillstroke, :clip\nrandomhue()\ncircle(0, 0, 460, :stroke)\ncircle(0,-200,400,:clip)             # a circular clipping mask above the x axis\nsethue(\"gold\")\nsetopacity(0.7)\nsetline(10)\nfor i in 0:pi/36:2pi - pi/36\n    move(0, 0)\n    line(cos(i) * 600, sin(i) * 600 )\n    strokepath()\nend\nclipreset()                           # finish clipping/masking\nfontsize(60)\nsetcolor(\"turquoise\")\nfontface(\"Optima-ExtraBlack\")\ntextwidth = textextents(\"Luxor\")[5]\ntextcentred(\"Luxor\", 0, currentdrawing.height/2 - 400)\nfontsize(18)\nfontface(\"Avenir-Black\")\n\n# text on curve starting at angle 0 rads centered on origin with radius 550\ntextcurve(\"THIS IS TEXT ON A CURVE \" ^ 14, 0, 550, O)\nfinish()\npreview() # on macOS, opens in Preview"
},

{
    "location": "moreexamples.html#Illustrating-this-document-1",
    "page": "More examples",
    "title": "Illustrating this document",
    "category": "section",
    "text": "This documentation was built with Documenter.jl, which is an amazingly powerful and flexible documentation generator written in Julia. The illustrations are mostly created when the HTML pages are built: the Julia source for the image is stored in the Markdown source document, and the code to create the images runs each time the documentation is generated.The Markdown markup looks like this:```@example\nusing Luxor # hide\nDrawing(600, 250, \"assets/figures/polysmooth-pathological.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsetopacity(0.75) # hide\nsrand(42) # hide\nsetline(1) # hide\np = star(O, 60, 5, 0.35, 0, vertices=true)\nsetdash(\"dot\")\nsethue(\"red\")\nprettypoly(p, close=true, :stroke)\nsetdash(\"solid\")\nsethue(\"black\")\npolysmooth(p, 40, :fill, debug=true)\nfinish() # hide\n```\n\n![polysmooth](assets/figures/polysmooth-pathological.png)and after you run Documenter's build process the HTML output looks like this:using Luxor # hide\nDrawing(600, 250, \"assets/figures/polysmoothy.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsetopacity(0.75) # hide\nsrand(42) # hide\nsetline(1) # hide\np = star(O, 60, 5, 0.35, 0, vertices=true)\nsetdash(\"dot\")\nsethue(\"red\")\nprettypoly(p, close=true, :stroke)\nsetdash(\"solid\")\nsethue(\"black\")\npolysmooth(p, 40, :fill, debug=true)\nfinish() # hide\nnothing # hide(Image: polysmooth)"
},

{
    "location": "moreexamples.html#Why-turtles?-1",
    "page": "More examples",
    "title": "Why turtles?",
    "category": "section",
    "text": "An interesting application for turtle-style graphics is for drawing Lindenmayer systems (l-systems). Here's an example of how a complex pattern can emerge from a simple set of rules, taken from Lindenmayer.jl:(Image: penrose)The definition of this figure is:penrose = LSystem(Dict(\"X\"  =>  \"PM++QM----YM[-PM----XM]++t\",\n                       \"Y\"  => \"+PM--QM[---XM--YM]+t\",\n                       \"P\"  => \"-XM++YM[+++PM++QM]-t\",\n                       \"Q\"  => \"--PM++++XM[+QM++++YM]--YMt\",\n                       \"M\"  => \"F\",\n                       \"F\"  => \"\"),\n                  \"1[Y]++[Y]++[Y]++[Y]++[Y]\")where some of the characters—eg \"F\", \"+\", \"-\", and \"t\"—issue turtle control commands, and others—\"X,\", \"Y\", \"P\", and \"Q\"—refer to specific components of the design. The execution of the l-system involves replacing every occurrence in the drawing code of every dictionary key with the matching values."
},

{
    "location": "moreexamples.html#Strange-1",
    "page": "More examples",
    "title": "Strange",
    "category": "section",
    "text": "It's usually better to draw fractals and similar images using pixels and image processing tools. But just for fun it's an interesting experiment to render a strange attractor image using vector drawing rather than placing pixels. This version uses about 600,000 circular dots (which is why it's better to target PNG rather than SVG or PDF for this example!).using Luxor, Colors, ColorSchemes\nfunction strange(dotsize, w=800.0)\n    xmin = -2.0; xmax = 2.0; ymin= -2.0; ymax = 2.0\n    cs = ColorSchemes.botticelli\n    Drawing(w, w, \"assets/figures/strange-vector.png\")\n    origin()\n    background(\"white\")\n    xinc = w/(xmax - xmin)\n    yinc = w/(ymax - ymin)\n    # control parameters\n    a = 2.24; b = 0.43; c = -0.65; d = -2.43; e1 = 1.0\n    x = y = z = 0.0\n    wover2 = w/2\n    for j in 1:w\n        for i in 1:w\n            xx = sin(a * y) - z  *  cos(b * x)\n            yy = z * sin(c * x) - cos(d * y)\n            zz = e1 * sin(x)\n            x = xx; y = yy; z = zz\n            if xx < xmax && xx > xmin && yy < ymax && yy > ymin\n                xpos = rescale(xx, xmin, xmax, -wover2, wover2) # scale to range\n                ypos = rescale(yy, ymin, ymax, -wover2, wover2) # scale to range\n                col1 = get(cs, rescale(xx, -1, 1, 0.0, .5))\n                col2 = get(cs, rescale(yy, -1, 1, 0.0, .4))\n                col3 = get(cs, rescale(zz, -1, 1, 0.0, .2))\n                sethue(mean([col1, col2, col3]))\n                circle(Point(xpos, ypos), dotsize, :fill)\n            end\n        end\n    end\n    finish()\nend\n\nstrange(.3, 800)\nnothing # hide(Image: strange attractor in vectors)"
},

{
    "location": "moreexamples.html#Hipster-logo:-text-on-curves-1",
    "page": "More examples",
    "title": "Hipster logo: text on curves",
    "category": "section",
    "text": "using Luxor\nfunction hipster(fname, toptext, bottomtext)\n    Drawing(400, 350, fname)\n    origin()\n    rotate(pi/8)\n\n    circle(O, 135, :clip)\n    sethue(\"antiquewhite2\")\n    paint()\n\n    sethue(\"gray20\")\n    setline(3)\n    circle(O, 130, :stroke)\n    circle(O, 135, :stroke)\n    circle(O, 125, :fill)\n\n    sethue(\"antiquewhite2\")\n    circle(O, 85, :fill)\n\n    sethue(\"wheat\")\n    fontsize(20)\n    fontface(\"Helvetica-Bold\")\n    textcurvecentered(toptext, (3pi)/2, 100, O, clockwise=true,  letter_spacing=1, baselineshift = -4)\n    textcurvecentered(bottomtext, pi/2, 100, O, clockwise=false, letter_spacing=2, baselineshift = -15)\n\n    sethue(\"gray20\")\n    map(pt -> star(pt, 40, 3, 0.5, -pi/2, :fill), ngon(O, 40, 3, 0, vertices=true))\n    circle(O.x + 30, O.y - 55, 15, :fill)\n\n    # cheap weathered texture:\n    sethue(\"antiquewhite2\")\n    setline(0.4)\n    setdash(\"dot\")\n    for i in 1:500\n        line(randompoint(Point(-200, -350), Point(200, 350)),\n             randompoint(Point(-200, -350), Point(200, 350)),\n             :stroke)\n    end\n    finish()\nend\n\nhipster(\"assets/figures/textcurvecenteredexample.png\",\n    \"• DRAWN WITH LUXOR • \",\n    \"VECTOR GRAPHICS FOR JULIA\")\n\nnothing # hide(Image: text on a curve)"
},

{
    "location": "functionindex.html#",
    "page": "Index",
    "title": "Index",
    "category": "page",
    "text": ""
},

{
    "location": "functionindex.html#Index-1",
    "page": "Index",
    "title": "Index",
    "category": "section",
    "text": ""
},

]}
