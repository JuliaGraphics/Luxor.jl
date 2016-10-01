var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Introduction to Luxor",
    "title": "Introduction to Luxor",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#Introduction-to-Luxor-1",
    "page": "Introduction to Luxor",
    "title": "Introduction to Luxor",
    "category": "section",
    "text": "Luxor provides basic vector drawing functions and utilities for working with shapes, polygons, clipping masks, PNG images, and turtle graphics. It's intended to be an easy interface to Cairo.jl."
},

{
    "location": "index.html#Current-status-1",
    "page": "Introduction to Luxor",
    "title": "Current status",
    "category": "section",
    "text": "Luxor currently runs on Julia versions 0.4 and 0.5, and uses Cairo.jl and Colors.jl.Please submit issues and pull requests on github!"
},

{
    "location": "index.html#Installation-and-basic-usage-1",
    "page": "Introduction to Luxor",
    "title": "Installation and basic usage",
    "category": "section",
    "text": "Install the package as follows:Pkg.add(\"Luxor\")and to use it:using Luxor"
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
    "text": "Here's the \"Hello world\":(Image: \"Hello world\")using Luxor\nDrawing(1000, 1000, \"hello-world.png\")\norigin()\nbackground(\"black\")\nsethue(\"red\")\nfontsize(50)\ntext(\"hello world\")\nfinish()\npreview()The Drawing(1000, 1000, \"hello-world.png\") line defines the size of the image and the location and type of the finished image when it's saved. origin() moves the 0/0 point to the centre of the drawing surface (by default it's at the top left corner). Because we're using Colors.jl, we can specify colors by name: background(\"black\") defines the color of the background of the drawing. text(\"helloworld\") draws the text. It's placed at the current 0/0 if you don't specify otherwise. finish() completes the drawing and saves the image in the file. preview() tries to open the saved file using some other application (eg on MacOS X, Preview)."
},

{
    "location": "examples.html#A-slightly-more-complicated-example:-a-Sierpinski-triangle-1",
    "page": "A few examples",
    "title": "A slightly more complicated example: a Sierpinski triangle",
    "category": "section",
    "text": "Here's a version of the Sierpinski recursive triangle, clipped to a circle.(Image: Sierpinski)using Luxor\n\nfunction triangle(points, degree)\n    sethue(cols[degree])\n    poly(points, :fill)\nend\n\nfunction sierpinski(points, degree)\n    triangle(points, degree)\n    if degree > 1\n        p1, p2, p3 = points\n        sierpinski([p1, midpoint(p1, p2),\n                        midpoint(p1, p3)], degree-1)\n        sierpinski([p2, midpoint(p1, p2),\n                        midpoint(p2, p3)], degree-1)\n        sierpinski([p3, midpoint(p3, p2),\n                        midpoint(p1, p3)], degree-1)\n    end\nend\n\nfunction draw(n)\n  Drawing(200, 200, \"/tmp/sierpinski.pdf\")\n  origin()\n  background(\"ivory\")\n  circle(O, 75, :clip)\n  my_points = ngon(O, 150, 3, -pi/2, vertices=true)\n  sierpinski(my_points, n)\n  finish()\n  preview()\nend\n\ndepth = 8 # 12 is ok, 20 is right out (on my computer, at least)\ncols = distinguishable_colors(depth)\ndraw(depth)You can change \"sierpinski.pdf\" to \"sierpinski.svg\" or \"sierpinski.png\" or \"sierpinski.eps\" to produce alternative formats.The main type (apart from the Drawing) is the Point, an immutable composite type containing x and y fields."
},

{
    "location": "examples.html#How-I-use-Luxor-1",
    "page": "A few examples",
    "title": "How I use Luxor",
    "category": "section",
    "text": "Here are some examples of how I use Luxor."
},

{
    "location": "examples.html#Sector-chart-1",
    "page": "A few examples",
    "title": "Sector chart",
    "category": "section",
    "text": "(Image: \"benchmark sector chart\")Sector charts look cool but they aren't always good at their job. This chart takes the raw benchmark scores from the Julia website and tries to render them literally as radiating sectors. The larger the sector, the slower the performance, so it's difficult to see the Julia scores sometimes...!link to PDF original | link to Julia source"
},

{
    "location": "examples.html#Star-chart-1",
    "page": "A few examples",
    "title": "Star chart",
    "category": "section",
    "text": "Looking further afield, here's a straightforward chart rendering stars from the Astronexus HYG database catalog available on github and read into a DataFrame. There are a lot of challenges with representing so many stars—sizes, colors, constellation boundaries. It takes about 4 seconds to load the data, and 7 seconds to draw it— about 120,000 stars, using still-to-be-optimized code.A small detail:(Image: \"benchmark sector chart\")A more complete version:(Image: \"benchmark sector chart\")link to PDF original | link to Julia source"
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
    "location": "basics.html#",
    "page": "Basic graphics",
    "title": "Basic graphics",
    "category": "page",
    "text": ""
},

{
    "location": "basics.html#The-basics-1",
    "page": "Basic graphics",
    "title": "The basics",
    "category": "section",
    "text": "The underlying drawing model is that points are added to paths, then the paths can be filled and/or stroked, using the current graphics state, which specifies colors, line thicknesses and patterns, and opacity. You can modify the drawing space by transforming/rotating/scaling it before you add graphics.Many of the drawing functions have an action argument. This can be :nothing, :fill, :stroke, :fillstroke, :fillpreserve, :strokepreserve, :clip. The default is :nothing.Positions are usually specified either by x and y coordinates or a Point(x, y). Angles are usually measured starting at the positive x-axis going towards the positive y-axis (which usually points 'down' the page or canvas) in radians. Or 'clockwise'."
},

{
    "location": "basics.html#Types-1",
    "page": "Basic graphics",
    "title": "Types",
    "category": "section",
    "text": "The two main defined types are the Point and the Drawing. The Point type holds two coordinates, x and y:Point(12.0, 13.0)It's immutable, so you want to avoid trying to change the x or y coordinate directly. You can use the letter O as a shortcut to refer to the current Origin, Point(0, 0).The other is Drawing, which is how you create new drawings."
},

{
    "location": "basics.html#Luxor.Drawing",
    "page": "Basic graphics",
    "title": "Luxor.Drawing",
    "category": "Type",
    "text": "Create a new drawing, and optionally specify file type (PNG, PDF, SVG, etc) and dimensions.\n\nDrawing()\n\ncreates a drawing, defaulting to PNG format, default filename \"luxor-drawing.png\", default size 800 pixels square.\n\nYou can specify dimensions, and use the default target filename:\n\nDrawing(400, 300)\n\ncreates a drawing 400 pixels wide by 300 pixels high, defaulting to PNG format, default filename \"/tmp/luxor-drawing.png\".\n\nDrawing(400, 300, \"my-drawing.pdf\")\n\ncreates a PDF drawing in the file \"my-drawing.pdf\", 400 by 300 pixels.\n\nDrawing(1200, 800, \"my-drawing.svg\")`\n\ncreates an SVG drawing in the file \"my-drawing.svg\", 1200 by 800 pixels.\n\nDrawing(1200, 1200/golden, \"my-drawing.eps\")\n\ncreates an EPS drawing in the file \"my-drawing.eps\", 1200 wide by 741.8 pixels (= 1200 ÷ ϕ) high.\n\nDrawing(\"A4\", \"my-drawing.pdf\")\n\ncreates a drawing in ISO A4 size (595 wide by 842 high) in the file \"my-drawing.pdf\". Other sizes available are:  \"A0\", \"A1\", \"A2\", \"A3\", \"A4\", \"A5\", \"A6\", \"Letter\", \"Legal\", \"A\", \"B\", \"C\", \"D\", \"E\". Append \"landscape\" to get the landscape version.\n\nDrawing(\"A4landscape\")\n\ncreates the drawing A4 landscape size.\n\nPDF files default to a white background, but PNG defaults to transparent, unless you specify one using background().\n\n\n\n"
},

{
    "location": "basics.html#Luxor.finish",
    "page": "Basic graphics",
    "title": "Luxor.finish",
    "category": "Function",
    "text": "finish()\n\nFinish the drawing, and close the file. You may be able to open it in an external viewer application with preview().\n\n\n\n"
},

{
    "location": "basics.html#Luxor.preview",
    "page": "Basic graphics",
    "title": "Luxor.preview",
    "category": "Function",
    "text": "preview()\n\nOn macOS, open the file, which probably uses the default, Preview.app. On Unix, open the file with xdg-open. On Windows, pass the filename to the shell.\n\n\n\n"
},

{
    "location": "basics.html#Drawings-and-files-1",
    "page": "Basic graphics",
    "title": "Drawings and files",
    "category": "section",
    "text": "To create a drawing, and optionally specify the filename and type, and dimensions, use the Drawing constructor function.DrawingTo finish a drawing and close the file, use finish(), and, to launch an external application to view it, use preview().finish\npreviewThe global variable currentdrawing (of type Drawing) holds a few parameters which are occasionally useful:julia> fieldnames(currentdrawing)\n10-element Array{Symbol,1}:\n:width\n:height\n:filename\n:surface\n:cr\n:surfacetype\n:redvalue\n:greenvalue\n:bluevalue\n:alpha"
},

{
    "location": "basics.html#Luxor.background",
    "page": "Basic graphics",
    "title": "Luxor.background",
    "category": "Function",
    "text": "background(color)\n\nFill the canvas with a single color. Returns the (red, green, blue, alpha) values.\n\nExamples:\n\nbackground(\"antiquewhite\")\nbackground(\"ivory\")\nbackground(RGB(0, 0, 0))       # if Colors.jl is installed\nbackground(Luv(20, -20, 30))\n\nIf you don't specify a background color for a PNG drawing, the background will be transparent. You can set a partly or completely transparent background for PNG files by passing a color with an alpha value, such as this 'transparent black':\n\nbackground(RGBA(0, 0, 0, 0))\n\n\n\n"
},

{
    "location": "basics.html#Luxor.axes",
    "page": "Basic graphics",
    "title": "Luxor.axes",
    "category": "Function",
    "text": "Draw two axes lines starting at O, the current 0/0, and continuing out along the current positive x and y axes.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.origin",
    "page": "Basic graphics",
    "title": "Luxor.origin",
    "category": "Function",
    "text": "origin()\n\nReset the current matrix, and then set the 0/0 origin to the center of the drawing (otherwise it will stay at the top left corner, the default).\n\nYou can refer to the 0/0 point as O. (O = Point(0, 0)),\n\n\n\n"
},

{
    "location": "basics.html#The-drawing-area-1",
    "page": "Basic graphics",
    "title": "The drawing area",
    "category": "section",
    "text": "The origin (0/0) starts off at the top left: the x axis runs left to right, and the y axis runs top to bottom.The origin() function moves the 0/0 point to the center of the drawing. It's often convenient to do this at the beginning of a program. You can use functions like scale(), rotate(), and translate() to change the coordinate system.background() fills the image with a color, covering any previous contents. By default, PDF files have a white background, whereas PNG drawings have no background, so the background appears transparent in other applications. If there is a current clipping region, background() fills just that region. Here, the first background() filled the entire drawing; the calls in the loop fill only the active clipping region:using Luxor # hide\nDrawing(600, 400, \"../figures/backgrounds.png\") # hide\nbackground(\"magenta\")\norigin() # hide\ntiles = Tiler(600, 400, 5, 5, margin=30)\nfor (pos, n) in tiles\n  box(pos, tiles.tilewidth, tiles.tileheight, :clip)\n  background(randomhue()...)\n  clipreset()\nend\nfinish() # hide(Image: background)The axes() function draws a couple of lines and text labels in light gray to indicate the position and orientation of the current axes.using Luxor # hide\nDrawing(400, 400, \"../figures/axes.png\") # hide\nbackground(\"gray80\")\norigin()\naxes()\nfinish() # hide(Image: axes)background\naxes\norigin"
},

{
    "location": "basics.html#Luxor.Tiler",
    "page": "Basic graphics",
    "title": "Luxor.Tiler",
    "category": "Type",
    "text": "tiles = Tiler(areawidth, areaheight, nrows, ncols, margin=20)\n\nA Tiler is an iterator that, for each iteration, returns a tuple of:\n\nthe x/y point of the center of each tile in a set of tiles that divide up a rectangular space such as a page into rows and columns (relative to current 0/0)\nthe number of the tile\n\nareawidth and areaheight are the dimensions of the area to be tiled, nrows/ncols are the number of rows and columns required, and margin is applied to all four edges of the area before the function calculates the tile sizes required.\n\ntiles = Tiler(1000, 800, 4, 5, margin=20)\nfor (pos, n) in tiles\n# the point pos is the center of the tile\nend\n\nYou can access the calculated tile width and height like this:\n\ntiles = Tiler(1000, 800, 4, 5, margin=20)\nfor (pos, n) in tiles\n  ellipse(pos.x, pos.y, tiles.tilewidth, tiles.tileheight, :fill)\nend\n\n\n\n"
},

{
    "location": "basics.html#Tiles-1",
    "page": "Basic graphics",
    "title": "Tiles",
    "category": "section",
    "text": "The drawing area (or any other area) can be divided into rectangular tiles (as rows and columns) using the Tiler iterator, which returns the center point and tile number of each tile.In this example, every third tile is divided up into subtiles and colored:using Luxor # hide\nDrawing(400, 300, \"../figures/tiler.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsrand(1) # hide\nfontsize(20) # hide\ntiles = Tiler(400, 300, 4, 5, margin=5)\nfor (pos, n) in tiles\nrandomhue()\nbox(pos, tiles.tilewidth, tiles.tileheight, :fill)\nif n % 3 == 0\ngsave()\ntranslate(pos)\nsubtiles = Tiler(tiles.tilewidth, tiles.tileheight, 4, 4, margin=5)\nfor (pos1, n1) in subtiles\nrandomhue()\nbox(pos1, subtiles.tilewidth, subtiles.tileheight, :fill)\nend\ngrestore()\nend\nsethue(\"white\")\ntextcentred(string(n), pos + Point(0, 5))\nend\nfinish() # hide(Image: tiler)Tiler"
},

{
    "location": "basics.html#Luxor.gsave",
    "page": "Basic graphics",
    "title": "Luxor.gsave",
    "category": "Function",
    "text": "Save the current graphics state on the stack.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.grestore",
    "page": "Basic graphics",
    "title": "Luxor.grestore",
    "category": "Function",
    "text": "Replace the current graphics state with the one on top of the stack.\n\n\n\n"
},

{
    "location": "basics.html#Save-and-restore-1",
    "page": "Basic graphics",
    "title": "Save and restore",
    "category": "section",
    "text": "gsave() saves a copy of the current graphics settings (current axis rotation, position, scale, line and text settings, color, and so on). When the next grestore() is called, all changes you've made to the graphics settings will be discarded, and they'll return to how they were when you last used gsave(). gsave() and grestore() should always be balanced in pairs.gsave\ngrestore"
},

{
    "location": "basics.html#Simple-shapes-1",
    "page": "Basic graphics",
    "title": "Simple shapes",
    "category": "section",
    "text": "Functions for making shapes include circle(), ellipse(), squircle(), arc(), carc(), curve(), sector(), rect(), pie(), and box(). There's also ngon() and star(), listed under Polygons, below."
},

{
    "location": "basics.html#Luxor.rect",
    "page": "Basic graphics",
    "title": "Luxor.rect",
    "category": "Function",
    "text": "Create a rectangle with one corner at (xmin/ymin) with width w and height h and do an action.\n\nrect(xmin, ymin, w, h, action)\n\nSee box() for more ways to do similar things, such as supplying two opposite corners, placing by centerpoint and dimensions.\n\n\n\nCreate a rectangle with one corner at cornerpoint with width w and height h and do an action.\n\nrect(cornerpoint, w, h, action)\n\n\n\n"
},

{
    "location": "basics.html#Luxor.box",
    "page": "Basic graphics",
    "title": "Luxor.box",
    "category": "Function",
    "text": "Create a rectangle between two points and do an action.\n\nbox(cornerpoint1, cornerpoint2, action=:nothing)\n\n\n\nCreate a box/rectangle using the first two points of an array of Points to defined opposite corners.\n\nbox(points::Array, action=:nothing)\n\n\n\nCreate a box/rectangle centered at point pt with width and height.\n\nbox(pt::Point, width, height, action=:nothing; vertices=false)\n\n\n\nCreate a box/rectangle centered at point x/y with width and height.\n\nbox(x, y, width, height, action=:nothing)\n\n\n\n"
},

{
    "location": "basics.html#Luxor.polybbox",
    "page": "Basic graphics",
    "title": "Luxor.polybbox",
    "category": "Function",
    "text": "Find the bounding box of a polygon (array of points).\n\npolybbox(pointlist::Array)\n\nReturn the two opposite corners (suitable for box(), for example).\n\n\n\n"
},

{
    "location": "basics.html#Rectangles-and-boxes-1",
    "page": "Basic graphics",
    "title": "Rectangles and boxes",
    "category": "section",
    "text": "(Image: rects)rect\nbox\npolybbox"
},

{
    "location": "basics.html#Luxor.circle",
    "page": "Basic graphics",
    "title": "Luxor.circle",
    "category": "Function",
    "text": "Make a circle of radius r centred at x/y.\n\ncircle(x, y, r, action=:nothing)\n\naction is one of the actions applied by do_action, defaulting to :nothing. You can also use ellipse() to draw circles and place them by their centerpoint.\n\n\n\nMake a circle centred at pt.\n\ncircle(pt, r, action)\n\n\n\nMake a circle that passes through two points that define the diameter:\n\ncircle(pt1::Point, pt2::Point, action=:nothing)\n\n\n\n"
},

{
    "location": "basics.html#Luxor.ellipse",
    "page": "Basic graphics",
    "title": "Luxor.ellipse",
    "category": "Function",
    "text": "Make an ellipse, centered at xc/yc, fitting in a box of width w and height h.\n\nellipse(xc, yc, w, h, action=:none)\n\n\n\nMake an ellipse, centered at point c, with width w, and height h.\n\nellipse(cpt, w, h, action=:none)\n\n\n\n"
},

{
    "location": "basics.html#Luxor.sector",
    "page": "Basic graphics",
    "title": "Luxor.sector",
    "category": "Function",
    "text": "sector(innerradius, outerradius, startangle, endangle, action=:none)\n\nMake an annular sector centered at the current 0/0 point.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.pie",
    "page": "Basic graphics",
    "title": "Luxor.pie",
    "category": "Function",
    "text": "pie(x, y, radius, startangle, endangle, action=:none)\n\nMake a pie shape centered at x/y. Angles start at the positive x-axis and are measured clockwise.\n\n\n\npie(centerpoint, radius, startangle, endangle, action=:none)\n\nMake a pie shape centered at centerpoint.\n\nAngles start at the positive x-axis and are measured clockwise.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.squircle",
    "page": "Basic graphics",
    "title": "Luxor.squircle",
    "category": "Function",
    "text": "Make a squircle (basically a rectangle with rounded corners). Specify the center position, horizontal radius (distance from center to a side), and vertical radius (distance from center to top or bottom):\n\nsquircle(center::Point, hradius, vradius, action=:none; rt = 0.5, vertices=false)\n\nThe rt option defaults to 0.5, and gives an intermediate shape. Values less than 0.5 make the shape more square. Values above make the shape more round.\n\n\n\n"
},

{
    "location": "basics.html#Circles,-ellipses,-and-the-like-1",
    "page": "Basic graphics",
    "title": "Circles, ellipses, and the like",
    "category": "section",
    "text": "There are various ways to make circles, including by center and radius, through two points, or passing through three points.using Luxor # hide\nDrawing(400, 200, \"../figures/circles.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsetline(2) # hide\np1 = O\np2 = Point(100, 0)\nsethue(\"red\")\ncircle(p1, 40, :fill)\nsethue(\"green\")\ncircle(p1, p2, :stroke)\nsethue(\"black\")\narrow(O, Point(0, -40))\nmap(p -> circle(p, 4, :fill), [p1, p2])\nfinish() # hide(Image: circles)using Luxor # hide\nDrawing(400, 200, \"../figures/center3.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsetline(3) # hide\nsethue(\"black\")\np1 = Point(0, -50)\np2 = Point(100, 0)\np3 = Point(0, 65)\nmap(p -> circle(p, 4, :fill), [p1, p2, p3])\nsethue(\"orange\") # hide\ncircle(center3pts(p1, p2, p3)..., :stroke)\nfinish() # hide(Image: center and radius of 3 points)With ellipse() you can place ellipses (and circles) by defining the center point and the width and height.using Luxor # hide\nDrawing(500, 300, \"../figures/ellipses.png\") # hide\nbackground(\"white\") # hide\nfontsize(11) # hide\nsrand(1) # hide\norigin() # hide\ntiles = Tiler(500, 300, 5, 5)\nwidth = 20\nheight = 25\nfor (pos, n) in tiles\n  randomhue()\n  ellipse(pos, width, height, :fill)\n  sethue(\"black\")\n  label = string(round(width/height, 2))\n  textcentered(label, pos.x, pos.y + 25)\n  width += 2\nend\nfinish() # hide(Image: ellipses)circle\nellipseA sector (strictly an \"annular sector\") has an inner and outer radius, as well as start and end angles.using Luxor # hide\nDrawing(400, 200, \"../figures/sector.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"cyan\") # hide\nsector(50, 90, pi/2, 0, :fill)\nfinish() # hide(Image: sector)sectorA pie (or wedge) has start and end angles.using Luxor # hide\nDrawing(400, 300, \"../figures/pie.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"magenta\") # hide\npie(0, 0, 100, pi/2, pi, :fill)\nfinish() # hide(Image: pie)pieA squircle is a cross between a square and a circle. You can adjust the squariness and circularity of it to taste:using Luxor # hide\nDrawing(600, 250, \"../figures/squircle.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nfontsize(20) # hide\nsetline(2)\ntiles = Tiler(600, 250, 1, 3)\nfor (pos, n) in tiles\n    sethue(\"lavender\")\n    squircle(pos, 80, 80, rt=[0.3, 0.5, 0.7][n], :fillpreserve)\n    sethue(\"grey20\")\n    stroke()\n    textcentered(\"rt = $([0.3, 0.5, 0.7][n])\", pos)\nend\nfinish() # hide(Image: squircles)squircleFor a simple rounded rectangle, smooth the corners of a box, like so:using Luxor # hide\nDrawing(600, 250, \"../figures/round-rect.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"black\") # hide\nsetline(4)\npolysmooth(box(O, 200, 150, vertices=true), 10, :stroke)\nfinish() # hide(Image: rounded rect)"
},

{
    "location": "basics.html#Luxor.move",
    "page": "Basic graphics",
    "title": "Luxor.move",
    "category": "Function",
    "text": "Move to a point.\n\nmove(x, y)\nmove(pt)\n\n\n\n"
},

{
    "location": "basics.html#Luxor.rmove",
    "page": "Basic graphics",
    "title": "Luxor.rmove",
    "category": "Function",
    "text": "Move by an amount from the current point. Move relative to current position by x and y:\n\nrmove(x, y)\n\nMove relative to current position by the pt's x and y:\n\nrmove(pt)\n\n\n\n"
},

{
    "location": "basics.html#Luxor.line",
    "page": "Basic graphics",
    "title": "Luxor.line",
    "category": "Function",
    "text": "Create a line from the current position to the x/y position and optionally apply an action:\n\nline(x, y)\nline(x, y, :action)\nline(pt)\n\n\n\nMake a line between two points, pt1 and pt2.\n\nline(pt1::Point, pt2::Point, action=:nothing)\n\n\n\n"
},

{
    "location": "basics.html#Luxor.rline",
    "page": "Basic graphics",
    "title": "Luxor.rline",
    "category": "Function",
    "text": "Create a line relative to the current position to the x/y position and optionally apply an action:\n\nrline(x, y)\nrline(x, y, :action)\nrline(pt)\n\n\n\n"
},

{
    "location": "basics.html#Luxor.arc",
    "page": "Basic graphics",
    "title": "Luxor.arc",
    "category": "Function",
    "text": "Add an arc to the current path from angle1 to angle2 going clockwise.\n\narc(xc, yc, radius, angle1, angle2, action=:nothing)\n\nAngles are defined relative to the x-axis, positive clockwise.\n\n\n\nAdd an arc to the current path from angle1 to angle2 going clockwise.\n\narc(centerpoint::Point, radius, angle1, angle2, action=:nothing)\n\n\n\n"
},

{
    "location": "basics.html#Luxor.arc2r",
    "page": "Basic graphics",
    "title": "Luxor.arc2r",
    "category": "Function",
    "text": "  arc2r(c1, p2, p3, action=:nothing)\n\nMake a circular arc centered at c1 that starts at p2 and ends at p3, going clockwise.\n\nc1-p2 really determines the radius. If p3 doesn't lie on the circular path, it will be used only as an indication of the arc's length, rather than its position.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.carc",
    "page": "Basic graphics",
    "title": "Luxor.carc",
    "category": "Function",
    "text": "Add an arc to the current path from angle1 to angle2 going counterclockwise.\n\ncarc(xc, yc, radius, angle1, angle2, action=:nothing)\n\nAngles are defined relative to the x-axis, positive clockwise.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.curve",
    "page": "Basic graphics",
    "title": "Luxor.curve",
    "category": "Function",
    "text": "Create a cubic Bézier spline curve.\n\ncurve(x1, y1, x2, y2, x3, y3)\ncurve(p1, p2, p3)\n\nThe spline starts at the current position, finishing at x3/y3 (p3), following two control points x1/y1 (p1) and x2/y2 (p2)\n\n\n\n"
},

{
    "location": "basics.html#Lines,-arcs,-and-curves-1",
    "page": "Basic graphics",
    "title": "Lines, arcs, and curves",
    "category": "section",
    "text": "There is a 'current position' which you can set with move(), and can use implicitly in functions like line(), text(), and curve().curve() constructs Bèzier curves from control points:using Luxor # hide\nDrawing(500, 275, \"../figures/curve.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\n\nsetline(.5)\npt1 = Point(0, -125)\npt2 = Point(200, 125)\npt3 = Point(200, -125)\n\nsethue(\"red\")\nforeach(p -> circle(p, 4, :fill), [O, pt1, pt2, pt3])\n\nline(O, pt1, :stroke)\nline(pt2, pt3, :stroke)\n\nsethue(\"black\")\nsetline(3)\n\nmove(O)\ncurve(pt1, pt2, pt3)\nstroke()\nfinish()  # hide(Image: curve)There are a few arc-drawing commands, such as arc(), carc(), and arc2r(). arc2r() draws a circular arc that joins two points:  using Luxor # hide\nDrawing(700, 200, \"../figures/arc2r.png\") # hide\norigin() # hide\nsrand(42) # hide\nbackground(\"white\") # hide\ntiles = Tiler(700, 200, 1, 6)\nfor (pos, n) in tiles\n    c1, pt2, pt3 = ngon(pos, rand(10:50), 3, rand(0:pi/12:2pi), vertices=true)\n    sethue(\"black\")\n    map(pt -> circle(pt, 4, :fill), [c1, pt3])\n    sethue(\"red\")\n    circle(pt2, 4, :fill)\n    randomhue()\n    arc2r(c1, pt2, pt3, :stroke)\nend\nfinish() # hide(Image: arc)move\nrmove\nline\nrline\narc\narc2r\ncarc\ncurve"
},

{
    "location": "basics.html#Luxor.midpoint",
    "page": "Basic graphics",
    "title": "Luxor.midpoint",
    "category": "Function",
    "text": "midpoint(p1, p2)\n\nFind the midpoint between two points.\n\n\n\nFind midpoint between the first two elements of an array of points.\n\nmidpoint(a)\n\n\n\n"
},

{
    "location": "basics.html#Luxor.intersection",
    "page": "Basic graphics",
    "title": "Luxor.intersection",
    "category": "Function",
    "text": "Find intersection of two lines p1-p2 and p3-p4\n\nintersection(p1, p2, p3, p4)\n\nThis returns a tuple: (false, Point(0, 0)) or (true, intersectionoint).\n\n\n\n"
},

{
    "location": "basics.html#Luxor.center3pts",
    "page": "Basic graphics",
    "title": "Luxor.center3pts",
    "category": "Function",
    "text": "Find the radius and center point for three points lying on a circle.\n\ncenter3pts(a::Point, b::Point, c::Point)\n\nreturns (centerpoint, radius) of a circle. Then you can use circle() to place a circle, or arc() to draw an arc passing through those points.\n\nIf there's no such circle, then you'll see an error message in the console and the function returns (Point(0,0), 0).\n\n\n\n"
},

{
    "location": "basics.html#Geometry-tools-1",
    "page": "Basic graphics",
    "title": "Geometry tools",
    "category": "section",
    "text": "You can find the midpoint between two points using midpoint(). intersection() finds the intersection of two lines. center3pts() finds the radius and center point of a circle passing through three points which you can then use with functions such as circle() or arc2r().midpoint\nintersection\ncenter3pts"
},

{
    "location": "basics.html#Luxor.arrow",
    "page": "Basic graphics",
    "title": "Luxor.arrow",
    "category": "Function",
    "text": "Draw a line between two points and add an arrowhead at the end. The arrowhead length will be the length of the side of the arrow's head, and the arrowhead angle is the angle between the sloping side of the arrowhead and the arrow's shaft.\n\narrow(startpoint::Point, endpoint::Point; linewidth=1.0, arrowheadlength=10, arrowheadangle=pi/8)\n\nArrows don't use the current linewidth setting (setline()); you can specify the linewidth.\n\nIt doesn't need stroking/filling, the shaft is stroke()d and the head fill()ed with the current color.\n\n\n\nDraw a curved arrow, an arc centered at centerpos starting at startangle and ending at endangle with an arrowhead at the end. Angles are measured clockwise from the positive x-axis.\n\nArrows don't use the current linewidth setting (setline()); you can specify the linewidth.\n\narrow(centerpos::Point, radius, startangle, endangle; linewidth=1.0, arrowheadlength=10, arrowheadangle=pi/8)\n\n\n\n"
},

{
    "location": "basics.html#Arrows-1",
    "page": "Basic graphics",
    "title": "Arrows",
    "category": "section",
    "text": "You can draw lines or arcs with arrows at the end with arrow(). For straight arrows, supply the start and end points. For arrows as circular arcs, you provide center, radius, and start and finish angles. You can optionally provide dimensions for the arrowheadlength and angle of the tip of the arrow. The default line weight is 1.0, equivalent to setline(1)), but you can specify another.using Luxor # hide\nDrawing(400, 250, \"../figures/arrow.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"steelblue4\") # hide\nsetline(2) # hide\narrow(O, Point(0, -65))\narrow(O, Point(100, -65), arrowheadlength=20, arrowheadangle=pi/4, linewidth=.3)\narrow(O, 100, pi, pi/2, arrowheadlength=25,   arrowheadangle=pi/12, linewidth=1.25)\nfinish() # hide(Image: arrows)arrow"
},

{
    "location": "basics.html#Luxor.newpath",
    "page": "Basic graphics",
    "title": "Luxor.newpath",
    "category": "Function",
    "text": "newpath()\n\nCreate a new path. This is Cairo's new_path() function.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.newsubpath",
    "page": "Basic graphics",
    "title": "Luxor.newsubpath",
    "category": "Function",
    "text": "newsubpath()\n\nAdd a new subpath to the current path. This is Cairo's new_sub_path() function. It can be used for example to make holes in shapes.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.closepath",
    "page": "Basic graphics",
    "title": "Luxor.closepath",
    "category": "Function",
    "text": "closepath()\n\nClose the current path. This is Cairo's close_path() function.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.getpath",
    "page": "Basic graphics",
    "title": "Luxor.getpath",
    "category": "Function",
    "text": "Get the current path (thanks Andreas Lobinger!)\n\nReturns a CairoPath which is an array of .element_type and .points. With the results you could typically step through and examine each entry:\n\no = getpath()\nfor e in o\n      if e.element_type == Cairo.CAIRO_PATH_MOVE_TO\n          (x, y) = e.points\n          move(x, y)\n      elseif e.element_type == Cairo.CAIRO_PATH_LINE_TO\n          (x, y) = e.points\n          # straight lines\n          line(x, y)\n          stroke()\n          circle(x, y, 1, :stroke)\n      elseif e.element_type == Cairo.CAIRO_PATH_CURVE_TO\n          (x1, y1, x2, y2, x3, y3) = e.points\n          # Bezier control lines\n          circle(x1, y1, 1, :stroke)\n          circle(x2, y2, 1, :stroke)\n          circle(x3, y3, 1, :stroke)\n          move(x, y)\n          curve(x1, y1, x2, y2, x3, y3)\n          stroke()\n          (x, y) = (x3, y3) # update current point\n      elseif e.element_type == Cairo.CAIRO_PATH_CLOSE_PATH\n          closepath()\n      else\n          error(\"unknown CairoPathEntry \" * repr(e.element_type))\n          error(\"unknown CairoPathEntry \" * repr(e.points))\n      end\n  end\n\n\n\n"
},

{
    "location": "basics.html#Luxor.getpathflat",
    "page": "Basic graphics",
    "title": "Luxor.getpathflat",
    "category": "Function",
    "text": "Get the current path, like getpath() but flattened so that there are no Bezier curves.\n\nReturns a CairoPath which is an array of .element_type and .points.\n\n\n\n"
},

{
    "location": "basics.html#Paths-1",
    "page": "Basic graphics",
    "title": "Paths",
    "category": "section",
    "text": "A path is a group of points. A path can have subpaths (which can form holes).The getpath() function gets the current Cairo path as an array of element types and points. getpathflat() gets the current path as an array of type/points with curves flattened to line segments.newpath\nnewsubpath\nclosepath\ngetpath\ngetpathflat"
},

{
    "location": "styling.html#",
    "page": "Styling",
    "title": "Styling",
    "category": "page",
    "text": ""
},

{
    "location": "styling.html#Styling-1",
    "page": "Styling",
    "title": "Styling",
    "category": "section",
    "text": ""
},

{
    "location": "styling.html#Luxor.sethue",
    "page": "Styling",
    "title": "Luxor.sethue",
    "category": "Function",
    "text": "Set the color. sethue() is like setcolor(), but (like Mathematica) we sometimes want to change the current 'color' without changing alpha/opacity. Using sethue() rather than setcolor() doesn't change the current alpha opacity.\n\nsethue(\"black\")\nsethue(0.3,0.7,0.9)\n\n\n\nSet the color to a named color:\n\nsethue(\"red\")\n\n\n\nSet the color's r, g, b values:\n\nsethue(0.3, 0.7, 0.9)\n\nUse setcolor(r,g,b,a) to set transparent colors.\n\n\n\n"
},

{
    "location": "styling.html#Luxor.setcolor",
    "page": "Styling",
    "title": "Luxor.setcolor",
    "category": "Function",
    "text": "setcolor(col::String)\n\nSet the current color to a named color. This relies on Colors.jl to convert a string to RGBA eg setcolor(\"gold\") # or \"green\", \"darkturquoise\", \"lavender\" or what have you. The list is at Colors.color_names.\n\nsetcolor(\"gold\")\nsetcolor(\"darkturquoise\")\n\nUse sethue() for changing colors without changing current opacity level.\n\n\n\nSet the current color.\n\nsetcolor(r, g, b)\nsetcolor(r, g, b, alpha)\nsetcolor(color)\nsetcolor(col::ColorTypes.Colorant)\n\nExamples:\n\nsetcolor(convert(Colors.HSV, Colors.RGB(0.5, 1, 1)))\nsetcolor(.2, .3, .4, .5)\nsetcolor(convert(Colors.HSV, Colors.RGB(0.5, 1, 1)))\n\nfor i in 1:15:360\n   setcolor(convert(Colors.RGB, Colors.HSV(i, 1, 1)))\n   ...\nend\n\n\n\n"
},

{
    "location": "styling.html#Luxor.setblend",
    "page": "Styling",
    "title": "Luxor.setblend",
    "category": "Function",
    "text": "setblend(blend)\n\nStart using the named blend for filling graphics.\n\nI think this aligns the original coordinates of the blend definition with the current axes.\n\n\n\n"
},

{
    "location": "styling.html#Luxor.setopacity",
    "page": "Styling",
    "title": "Luxor.setopacity",
    "category": "Function",
    "text": "Set the current opacity to a value between 0 and 1.\n\nsetopacity(alpha)\n\nThis modifies the alpha value of the current color.\n\n\n\n"
},

{
    "location": "styling.html#Luxor.randomhue",
    "page": "Styling",
    "title": "Luxor.randomhue",
    "category": "Function",
    "text": "Set a random hue.\n\nrandomhue()\n\nChoose a random color without changing the current alpha opacity.\n\n\n\n"
},

{
    "location": "styling.html#Luxor.randomcolor",
    "page": "Styling",
    "title": "Luxor.randomcolor",
    "category": "Function",
    "text": "Set a random color.\n\nrandomcolor()\n\nThis probably changes the current alpha opacity too.\n\n\n\n"
},

{
    "location": "styling.html#Color-and-opacity-1",
    "page": "Styling",
    "title": "Color and opacity",
    "category": "section",
    "text": "For color definitions and conversions, use Colors.jl.setcolor() and sethue() apply a single solid or transparent color to shapes. setblend() applies a smooth transition between two or more colors.The difference between the setcolor() and sethue() functions is that sethue() is independent of alpha opacity, so you can change the hue without changing the current opacity value.sethue\nsetcolor\nsetblend\nsetopacity\nrandomhue\nrandomcolor"
},

{
    "location": "styling.html#Luxor.setline",
    "page": "Styling",
    "title": "Luxor.setline",
    "category": "Function",
    "text": "Set the line width.\n\nsetline(n)\n\n\n\n"
},

{
    "location": "styling.html#Luxor.setlinecap",
    "page": "Styling",
    "title": "Luxor.setlinecap",
    "category": "Function",
    "text": "Set the line ends. s can be \"butt\" (the default), \"square\", or \"round\".\n\nsetlinecap(s)\n\nsetlinecap(\"round\")\n\n\n\n"
},

{
    "location": "styling.html#Luxor.setlinejoin",
    "page": "Styling",
    "title": "Luxor.setlinejoin",
    "category": "Function",
    "text": "Set the line join, or how to render the junction of two lines when stroking.\n\nsetlinejoin(\"round\")\nsetlinejoin(\"miter\")\nsetlinejoin(\"bevel\")\n\n\n\n"
},

{
    "location": "styling.html#Luxor.setdash",
    "page": "Styling",
    "title": "Luxor.setdash",
    "category": "Function",
    "text": "Set the dash pattern to one of: \"solid\", \"dotted\", \"dot\", \"dotdashed\", \"longdashed\", \"shortdashed\", \"dash\", \"dashed\", \"dotdotdashed\", \"dotdotdotdashed\"\n\nsetlinedash(\"dot\")\n\n\n\n"
},

{
    "location": "styling.html#Luxor.fillstroke",
    "page": "Styling",
    "title": "Luxor.fillstroke",
    "category": "Function",
    "text": "Fill and stroke the current path.\n\n\n\n"
},

{
    "location": "styling.html#Luxor.stroke",
    "page": "Styling",
    "title": "Luxor.stroke",
    "category": "Function",
    "text": "Stroke the current path with the current line width, line join, line cap, and dash settings. The current path is then cleared.\n\nstroke()\n\n\n\n"
},

{
    "location": "styling.html#Base.fill",
    "page": "Styling",
    "title": "Base.fill",
    "category": "Function",
    "text": "Fill the current path with current settings. The current path is then cleared.\n\nfill()\n\n\n\n"
},

{
    "location": "styling.html#Luxor.strokepreserve",
    "page": "Styling",
    "title": "Luxor.strokepreserve",
    "category": "Function",
    "text": "Stroke the current path with current line width, line join, line cap, and dash settings, but then keep the path current.\n\nstrokepreserve()\n\n\n\n"
},

{
    "location": "styling.html#Luxor.fillpreserve",
    "page": "Styling",
    "title": "Luxor.fillpreserve",
    "category": "Function",
    "text": "Fill the current path with current settings, but then keep the path current.\n\nfillpreserve()\n\n\n\n"
},

{
    "location": "styling.html#Luxor.paint",
    "page": "Styling",
    "title": "Luxor.paint",
    "category": "Function",
    "text": "Paint the current clip region with the current settings.\n\npaint()\n\n\n\n"
},

{
    "location": "styling.html#Luxor.do_action",
    "page": "Styling",
    "title": "Luxor.do_action",
    "category": "Function",
    "text": "do_action(action)\n\nThis is usually called by other graphics functions. Actions for graphics commands include :fill, :stroke, :clip, :fillstroke, :fillpreserve, :strokepreserve and :path.\n\n\n\n"
},

{
    "location": "styling.html#Styles-1",
    "page": "Styling",
    "title": "Styles",
    "category": "section",
    "text": "The set- functions control subsequent lines' width, end shapes, join behavior, and dash pattern:using Luxor # hide\nDrawing(400, 250, \"../figures/line-ends.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\ntranslate(-100, -60) # hide\nfontsize(18) # hide\nfor l in 1:3\n  sethue(\"black\")\n  setline(20)\n  setlinecap([\"butt\", \"square\", \"round\"][l])\n  textcentred([\"butt\", \"square\", \"round\"][l], 80l, 80)\n  setlinejoin([\"round\", \"miter\", \"bevel\"][l])\n  textcentred([\"round\", \"miter\", \"bevel\"][l], 80l, 120)\n  poly(ngon(Point(80l, 0), 20, 3, 0, vertices=true), :strokepreserve, close=false)\n  sethue(\"white\")\n  setline(1)\n  stroke()\nend\nfinish() # hide(Image: line endings)using Luxor # hide\nDrawing(600, 250, \"../figures/dashes.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nfontsize(14) # hide\nsethue(\"black\") # hide\nsetline(12)\npatterns = [\"solid\", \"dotted\", \"dot\", \"dotdashed\", \"longdashed\",\n  \"shortdashed\", \"dash\", \"dashed\", \"dotdotdashed\", \"dotdotdotdashed\"]\ntiles =  Tiler(400, 250, 10, 1, margin=10)\nfor (pos, n) in tiles\n  setdash(patterns[n])\n  textright(patterns[n], pos.x - 20, pos.y + 4)\n  line(pos, Point(400, pos.y), :stroke)\nend\nfinish() # hide(Image: dashes)setline\nsetlinecap\nsetlinejoin\nsetdash\nfillstroke\nstroke\nfill\nstrokepreserve\nfillpreserve\npaint\ndo_action"
},

{
    "location": "styling.html#Luxor.blend",
    "page": "Styling",
    "title": "Luxor.blend",
    "category": "Function",
    "text": "blend(from::Point, to::Point)\n\nCreate a linear blend.\n\nA blend is a specification of how one color changes into another. Linear blends are defined by two points: parallel lines through these points define the start and stop locations of the blend. The blend is defined relative to the current axes origin. This means that you should be aware of the current axes when you define blends, and when you use them.\n\nA new blend is empty. To add colors, use addstop().\n\n\n\nblend(centerpos1, rad1, centerpos2, rad2, color1, color2)\n\nCreate a radial blend.\n\nExample:\n\nredblue = blend(     pos, 0,     pos, tiles.tilewidth/2,     \"red\",     \"blue\"     )\n\n\n\nblend(from::Point, startradius, to::Point, endradius)\n\nCreate an empty radial blend.\n\nRadial blends are defined by two circles that define the start and stop locations. The first point is the center of the start circle, the first radius is the radius of the first circle.\n\nA new blend is empty. To add colors, use addstop().\n\n\n\n"
},

{
    "location": "styling.html#Blends-1",
    "page": "Styling",
    "title": "Blends",
    "category": "section",
    "text": "A blend is a color gradient. Use setblend() to select a blend in the same way that you'd use setcolor() and sethue() to select a solid color.You can make linear or radial blends. Use blend() in either case.To create a simple linear blend between two colors, supply two points and two colors to blend():using Luxor # hide\nDrawing(600, 200, \"../figures/color-blends-basic.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\norangeblue = blend(Point(-200, 0), Point(200, 0), \"orange\", \"blue\")\nsetblend(orangeblue)\nbox(O, 400, 100, :fill)\nfinish() # hide(Image: linear blend)And for a radial blend, provide two point/radius pairs, and two colors:using Luxor # hide\nDrawing(600, 200, \"../figures/color-blends-radial.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\ngreenmagenta = blend(Point(0, 0), 5, Point(0, 0), 150, \"green\", \"magenta\")\nsetblend(greenmagenta)\nbox(O, 400, 200, :fill)\nfinish() # hide(Image: radial blends)You can also use blend() to create an empty blend. Then you use addstop() to define the locations of specific colors along the blend, where 0 is the start, and 1 is the end.using Luxor # hide\nDrawing(600, 200, \"../figures/color-blends-scratch.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\ngoldblend = blend(Point(-200, 0), Point(200, 0))\naddstop(goldblend, 0.0,   \"gold4\")\naddstop(goldblend, 0.25,  \"gold1\")\naddstop(goldblend, 0.5,   \"gold3\")\naddstop(goldblend, 0.75,  \"darkgoldenrod4\")\naddstop(goldblend, 1.0,  \"gold2\")\nsetblend(goldblend)\nbox(O, 400, 200, :fill)\nfinish() # hide(Image: blends from scratch)When you define blends, the location of the axes (eg the current workspace as defined by translate(), etc.), is important. In the first of the two following examples, the blend is selected before the axes are moved with translate(pos). The blend 'samples' the original location of the blend's definition.using Luxor # hide\nDrawing(600, 200, \"../figures/color-blends-translate-1.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\ngoldblend = blend(Point(0, 0), Point(200, 0))\naddstop(goldblend, 0.0,   \"gold4\")\naddstop(goldblend, 0.25,  \"gold1\")\naddstop(goldblend, 0.5,   \"gold3\")\naddstop(goldblend, 0.75,  \"darkgoldenrod4\")\naddstop(goldblend, 1.0,  \"gold2\")\nsetblend(goldblend)\ntiles = Tiler(600, 200, 1, 5, margin=10)\nfor (pos, n) in tiles\n    gsave()\n    setblend(goldblend)\n    translate(pos)\n    ellipse(O, tiles.tilewidth, tiles.tilewidth, :fill)\n    grestore()\nend\nfinish() # hide(Image: blends 1)Outside the range of the original blend's definition, the same color is used, no matter how far away from the origin you go. But in the next example, the blend is relocated to the current axes, which have just been moved to the center of the tile. The blend refers to 0/0 each time, which is at the center of shape.using Luxor # hide\nDrawing(600, 200, \"../figures/color-blends-translate-2.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\ngoldblend = blend(Point(0, 0), Point(200, 0))\naddstop(goldblend, 0.0,   \"gold4\")\naddstop(goldblend, 0.25,  \"gold1\")\naddstop(goldblend, 0.5,   \"gold3\")\naddstop(goldblend, 0.75,  \"darkgoldenrod4\")\naddstop(goldblend, 1.0,  \"gold2\")\nsetblend(goldblend)\ntiles = Tiler(600, 200, 1, 5, margin=10)\nfor (pos, n) in tiles\n    gsave()\n    translate(pos)\n    setblend(goldblend)\n    ellipse(O, tiles.tilewidth, tiles.tilewidth, :fill)\n    grestore()\nend\nfinish() # hide(Image: blends 2)blend"
},

{
    "location": "polygons.html#",
    "page": "Polygons",
    "title": "Polygons",
    "category": "page",
    "text": ""
},

{
    "location": "polygons.html#Polygons-and-shapes-1",
    "page": "Polygons",
    "title": "Polygons and shapes",
    "category": "section",
    "text": ""
},

{
    "location": "polygons.html#Luxor.ngon",
    "page": "Polygons",
    "title": "Luxor.ngon",
    "category": "Function",
    "text": "Find the vertices of a regular n-sided polygon centred at x, y:\n\nngon(x, y, radius, sides=5, orientation=0, action=:nothing; vertices=false, reversepath=false)\n\nngon() draws the shapes: if you just want the raw points, use keyword argument vertices=true, which returns the array of points instead. Compare:\n\nngon(0, 0, 4, 4, 0, vertices=true) # returns the polygon's points:\n\n    4-element Array{Luxor.Point,1}:\n    Luxor.Point(2.4492935982947064e-16,4.0)\n    Luxor.Point(-4.0,4.898587196589413e-16)\n    Luxor.Point(-7.347880794884119e-16,-4.0)\n    Luxor.Point(4.0,-9.797174393178826e-16)\n\nwhereas\n\nngon(0, 0, 4, 4, 0, :close) # draws a polygon\n\n\n\nDraw a regular polygon centred at point p:\n\nngon(centerpos, radius, sides=5, orientation=0, action=:nothing; vertices=false, reversepath=false)\n\n\n\n"
},

{
    "location": "polygons.html#Regular-polygons-(\"ngons\")-1",
    "page": "Polygons",
    "title": "Regular polygons (\"ngons\")",
    "category": "section",
    "text": "You can make regular polygons — from triangles, pentagons, hexagons, septagons, heptagons, octagons, nonagons, decagons, and on-and-on-agons — with ngon().(Image: n-gons)using Luxor\nDrawing(1200, 1400)\n\norigin()\ncols = diverging_palette(60, 120, 20) # hue 60 to hue 120\nbackground(cols[1])\nsetopacity(0.7)\nsetline(2)\n\nngon(0, 0, 500, 8, 0, :clip)\n\nfor y in -500:50:500\n  for x in -500:50:500\n    setcolor(cols[rand(1:20)])\n    ngon(x, y, rand(20:25), rand(3:12), 0, :fill)\n    setcolor(cols[rand(1:20)])\n    ngon(x, y, rand(10:20), rand(3:12), 0, :stroke)\n  end\nend\n\nfinish()\npreview()ngon"
},

{
    "location": "polygons.html#Luxor.star",
    "page": "Polygons",
    "title": "Luxor.star",
    "category": "Function",
    "text": "Make a star:\n\nstar(xcenter, ycenter, radius, npoints=5, ratio=0.5, orientation=0, action=:nothing; vertices = false, reversepath=false)\n\nratio specifies the height of the smaller radius of the star relative to the larger.\n\nUse vertices=true to return the vertices of a star instead of drawing it.\n\n\n\nDraw a star centered at a position:\n\nstar(center, radius, npoints=5, ratio=0.5, orientation=0, action=:nothing; vertices = false, reversepath=false)\n\n\n\n"
},

{
    "location": "polygons.html#Stars-1",
    "page": "Polygons",
    "title": "Stars",
    "category": "section",
    "text": "Use star() to make a star.using Luxor # hide\nDrawing(500, 300, \"../figures/stars.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\ntiles = Tiler(400, 300, 4, 6, margin=5)\nfor (pos, n) in tiles\n  randomhue()\n  star(pos, tiles.tilewidth/3, rand(3:8), 0.5, 0, :fill)\nend\nfinish() # hide(Image: stars)The ratio determines the length of the inner radius compared with the outer.using Luxor # hide\nDrawing(500, 250, \"../figures/star-ratios.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"black\") # hide\nsetline(2) # hide\ntiles = Tiler(500, 250, 1, 6, margin=10)\nfor (pos, n) in tiles\n    star(pos, tiles.tilewidth/2, 5, rescale(n, 1, 6, 1, 0), 0, :stroke)\nend\nfinish() # hide(Image: stars)star"
},

{
    "location": "polygons.html#Luxor.poly",
    "page": "Polygons",
    "title": "Luxor.poly",
    "category": "Function",
    "text": "Draw a polygon.\n\npoly(pointlist::Array, action = :nothing; close=false, reversepath=false)\n\nA polygon is an Array of Points. By default poly() doesn't close or fill the polygon, to allow for clipping.\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.prettypoly",
    "page": "Polygons",
    "title": "Luxor.prettypoly",
    "category": "Function",
    "text": "prettypoly(points, action=:nothing, vertex_action=() -> circle(O, 1, :fill); close=false, reversepath=false)\n\nDraw the polygon defined by points, possibly closing and reversing it, using the current parameters, and then evaluate the function at every vertex of the polygon. For example, you can mark each vertex of a polygon with a randomly colored filled circle.\n\np = star(O, 70, 7, 0.6, 0, vertices=true)\nprettypoly(p, :fill, () ->\n    begin\n        randomhue()\n        circle(O, 10, :fill)\n    end,\n    close=true)\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.simplify",
    "page": "Polygons",
    "title": "Luxor.simplify",
    "category": "Function",
    "text": "Simplify a polygon:\n\nsimplify(pointlist::Array, detail=0.1)\n\ndetail is probably the smallest permitted distance between two points in pixels.\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.isinside",
    "page": "Polygons",
    "title": "Luxor.isinside",
    "category": "Function",
    "text": "Is a point p inside a polygon pol?\n\nisinside(p, pol)\n\nReturns true or false.\n\nThis is an implementation of the Hormann-Agathos (2001) Point in Polygon algorithm\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.randompoint",
    "page": "Polygons",
    "title": "Luxor.randompoint",
    "category": "Function",
    "text": "randompoint(lowpt, highpt)\n\nReturn a random point somewhere inside the rectangle defined by the two points.\n\n\n\nrandompoint(lowx, lowy, highx, highy)\n\nReturn a random point somewhere inside a rectangle defined by the four values.\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.randompointarray",
    "page": "Polygons",
    "title": "Luxor.randompointarray",
    "category": "Function",
    "text": "randompointarray(lowpt, highpt, n)\n\nReturn an array of n random points somewhere inside the rectangle defined by two points.\n\n\n\nrandompointarray(lowx, lowy, highx, highy, n)\n\nReturn an array of n random points somewhere inside the rectangle defined by the four coordinates.\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.polysplit",
    "page": "Polygons",
    "title": "Luxor.polysplit",
    "category": "Function",
    "text": "Split a polygon into two where it intersects with a line:\n\npolysplit(p, p1, p2)\n\nThis doesn't always work, of course. (Tell me you're not surprised.) For example, a polygon the shape of the letter \"E\" might end up being divided into more than two parts.\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.polysortbydistance",
    "page": "Polygons",
    "title": "Luxor.polysortbydistance",
    "category": "Function",
    "text": "Sort a polygon by finding the nearest point to the starting point, then the nearest point to that, and so on.\n\npolysortbydistance(p, starting::Point)\n\nYou can end up with convex (self-intersecting) polygons, unfortunately.\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.polysortbyangle",
    "page": "Polygons",
    "title": "Luxor.polysortbyangle",
    "category": "Function",
    "text": "Sort the points of a polygon into order. Points are sorted according to the angle they make with a specified point.\n\npolysortbyangle(pointlist::Array, refpoint=minimum(pointlist))\n\nThe refpoint can be chosen, but the minimum point is usually OK too:\n\npolysortbyangle(parray, polycentroid(parray))\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.polycentroid",
    "page": "Polygons",
    "title": "Luxor.polycentroid",
    "category": "Function",
    "text": "Find the centroid of simple polygon.\n\npolycentroid(pointlist)\n\nReturns a point. This only works for simple (non-intersecting) polygons.\n\nYou could test the point using isinside().\n\n\n\n"
},

{
    "location": "polygons.html#Polygons-1",
    "page": "Polygons",
    "title": "Polygons",
    "category": "section",
    "text": "A polygon is an array of Points. Use poly() to draw lines connecting the points:using Luxor # hide\nDrawing(400, 250, \"../figures/simplepoly.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"orchid4\")\npoly([Point(rand(-150:150), rand(-100:100)) for i in 1:20], :fill)\nfinish() # hide(Image: simple poly)polyA polygon can contain holes. The reversepath keyword changes the direction of the polygon. The following piece of code uses ngon() to make two paths, the second forming a hole in the first, to make a hexagonal bolt shape:using Luxor # hide\nDrawing(400, 250, \"../figures/holes.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"orchid4\") # hide\nngon(0, 0, 60, 6, 0, :path)\nnewsubpath()\nngon(0, 0, 40, 6, 0, :path, reversepath=true)\nfillstroke()\nfinish() # hide(Image: holes)The prettypoly() function can place graphics at each vertex of a polygon. After the polygon action, the vertex_action expression is evaluated at each vertex. For example, to mark each vertex of a polygon with a randomly-colored circle:using Luxor\nDrawing(400, 250, \"../figures/prettypolybasic.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"steelblue4\") # hide\n\napoly = star(O, 70, 7, 0.6, 0, vertices=true)\nprettypoly(apoly, :fill, () ->\n        begin\n            randomhue()\n            circle(O, 10, :fill)\n        end,\n    close=true)\nfinish() # hide(Image: prettypoly)prettypolyRecursive decoration is possible:using Luxor # hide\nDrawing(400, 250, \"../figures/prettypolyrecursive.png\") # hide\nbackground(\"white\") # hide\nsrand(42) # hide\norigin() # hide\nsethue(\"magenta\") # hide\nsetopacity(0.5) # hide\n\ndecorate(pos, p, level) = begin\n    if level < 4\n        randomhue();\n        scale(0.25, 0.25)\n        prettypoly(p, :fill, () -> decorate(pos, p, level+1), close=true)\n    end\nend\n\napoly = star(O, 100, 7, 0.6, 0, vertices=true)\nprettypoly(apoly, :fill, () ->\n        begin\n            decorate(O, apoly, 1)\n        end,\n    close=true)\nfinish() # hide(Image: prettypoly)Polygons can be simplified using the Douglas-Peucker algorithm (non-recursive version), via simplify().using Luxor # hide\nDrawing(600, 500, \"../figures/simplify.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"black\") # hide\nsetline(1) # hide\nfontsize(20) # hide\ntranslate(0, -120) # hide\nsincurve =  (Point(6x, 80sin(x)) for x in -5pi:pi/20:5pi)\nprettypoly(collect(sincurve), :stroke,\n    () -> begin\n            sethue(\"red\")\n            circle(O, 3, :fill)\n          end)\ntext(string(\"number of points: \", length(collect(sincurve))), 0, 100)\ntranslate(0, 200)\nsimplercurve = simplify(collect(sincurve), 0.5)\nprettypoly(simplercurve, :stroke,     () -> begin\n            sethue(\"red\")\n            circle(O, 3, :fill)\n          end)\ntext(string(\"number of points: \", length(simplercurve)), 0, 100)\nfinish() # hide(Image: simplify)simplifyThe isinside() function returns true if a point is inside a polygon.using Luxor # hide\nDrawing(400, 250, \"../figures/isinside.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsetopacity(0.5)\napolygon = star(O, 100, 5, 0.5, 0, vertices=true)\nfor n in 1:10000\n  apoint = randompoint(Point(-200, -150), Point(200, 150))\n  randomhue()\n  isinside(apoint, apolygon) && circle(apoint, 3, :fill)\nend\nfinish() # hide(Image: isinside)isinsideYou can use randompoint() and randompointarray() to create a random Point or list of Points.using Luxor # hide\nDrawing(400, 250, \"../figures/randompoints.png\") # hide\nbackground(\"white\") # hide\nsrand(42) # hide\norigin() # hide\n\npt1 = Point(-100, -100)\npt2 = Point(100, 100)\n\nsethue(\"gray80\")\nmap(pt -> circle(pt, 6, :fill), (pt1, pt2))\nbox(pt1, pt2, :stroke)\n\nsethue(\"red\")\ncircle(randompoint(pt1, pt2), 7, :fill)\n\nsethue(\"blue\")\nmap(pt -> circle(pt, 2, :fill), randompointarray(pt1, pt2, 100))\n\nfinish() # hide(Image: isinside)randompoint\nrandompointarrayThere are some experimental polygon functions. These don't work well for polygons that aren't simple or where the sides intersect each other, but they sometimes do a reasonable job. For example, here's polysplit():using Luxor # hide\nDrawing(400, 150, \"../figures/polysplit.png\") # hide\norigin() # hide\nsetopacity(0.7) # hide\nsrand(42) # hide\nsethue(\"black\") # hide\ns = squircle(O, 60, 60, vertices=true)\npt1 = Point(0, -120)\npt2 = Point(0, 120)\nline(pt1, pt2, :stroke)\npoly1, poly2 = polysplit(s, pt1, pt2)\nrandomhue()\npoly(poly1, :fill)\nrandomhue()\npoly(poly2, :fill)\nfinish() # hide(Image: polysplit)polysplit\npolysortbydistance\npolysortbyangle\npolycentroid"
},

{
    "location": "polygons.html#Luxor.polysmooth",
    "page": "Polygons",
    "title": "Luxor.polysmooth",
    "category": "Function",
    "text": "polysmooth(points, radius, action=:action; debug=false)\n\nMake a polygon from points, but round any sharp corners by making them arcs with the given radius.\n\nIn fact, the arcs are sometimes different sizes: if the given radius is bigger than the length of the shortest side, the arc can't be drawn at its full radius and is therefore drawn as large as possible (as large as the shortest side allows).\n\nThe debug option draws the construction circles at each corner.\n\n\n\n"
},

{
    "location": "polygons.html#Smoothing-polygons-1",
    "page": "Polygons",
    "title": "Smoothing polygons",
    "category": "section",
    "text": "Because polygons can have sharp corners, the polysmooth() function can attempt to insert arcs at the corners.The original polygon is shown in red; the smoothed polygon is drawn on top:using Luxor # hide\nDrawing(600, 250, \"../figures/polysmooth.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsetopacity(0.5) # hide\nsrand(42) # hide\nsetline(0.7) # hide\ntiles = Tiler(600, 250, 1, 5, margin=10)\nfor (pos, n) in tiles\n    p = star(pos, tiles.tilewidth/2 - 2, 5, 0.3, 0, vertices=true)\n    setdash(\"dot\")\n    sethue(\"red\")\n    prettypoly(p, close=true, :stroke)\n    setdash(\"solid\")\n    sethue(\"black\")\n    polysmooth(p, n * 2, :fill)\nend\n\nfinish() # hide(Image: polysmooth)The final polygon shows that  you can get unexpected results if you attempt to smooth corners by more than the possible amount. The debug=true option draws the circles if you want to find out what's going wrong, or if you want to explore the effect in more detail.using Luxor # hide\nDrawing(600, 250, \"../figures/polysmooth-pathological.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsetopacity(0.75) # hide\nsrand(42) # hide\nsetline(1) # hide\np = star(O, 60, 5, 0.35, 0, vertices=true)\nsetdash(\"dot\")\nsethue(\"red\")\nprettypoly(p, close=true, :stroke)\nsetdash(\"solid\")\nsethue(\"black\")\npolysmooth(p, 40, :fill, debug=true)\nfinish() # hide(Image: polysmooth)polysmooth"
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
    "location": "text.html#Luxor.text",
    "page": "Text",
    "title": "Luxor.text",
    "category": "Function",
    "text": "text(str)\ntext(str, pos)\ntext(str, x, y)\ntext(str, pos, halign=:left)\ntext(str, valign=:baseline)\ntext(str, valign=:baseline, halign=:left)\ntext(str, pos, valign=:baseline, halign=:left)\n\nDraw the text in the string str at x/y or pt, placing the start of the string at the point. If you omit the point, it's placed at the current 0/0. In Luxor, placing text doesn't affect the current point.\n\n:halign can be :left, :center, or :right. :valign can be :baseline, :top, :middle, or :bottom.\n\nHowever, the :valign doesn't work properly because we're using Cairo's so-called \"toy\" interface... :(\n\n\n\n"
},

{
    "location": "text.html#Luxor.textpath",
    "page": "Text",
    "title": "Luxor.textpath",
    "category": "Function",
    "text": "textpath(t)\n\nConvert the text in string t to a new path, for subsequent filling/stroking etc...\n\n\n\n"
},

{
    "location": "text.html#Placing-text-1",
    "page": "Text",
    "title": "Placing text",
    "category": "section",
    "text": "Use text() to place text.using Luxor # hide\nDrawing(400, 150, \"../figures/text-placement.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nfontsize(24) # hide\nsethue(\"black\") # hide\npt1 = Point(-100, 0)\npt2 = Point(0, 0)\npt3 = Point(100, 0)\nsethue(\"red\")\nmap(p -> circle(p, 4, :fill), [pt1, pt2, pt3])\nsethue(\"black\")\ntext(\"text 1\",  pt1, halign=:left,   valign = :bottom)\ntext(\"text 2\",  pt2, halign=:center, valign = :bottom)\ntext(\"text 3\",  pt3, halign=:right,  valign = :bottom)\ntext(\"text 4\",  pt1, halign=:left,   valign = :top)\ntext(\"text 5 \", pt2, halign=:center, valign = :top)\ntext(\"text 6\",  pt3, halign=:right,  valign = :top)\nfinish() # hide(Image: text placement)texttextpath() converts the text into a graphic path suitable for further styling.textpath"
},

{
    "location": "text.html#Luxor.fontface",
    "page": "Text",
    "title": "Luxor.fontface",
    "category": "Function",
    "text": "fontface(fontname)\n\nSelect a font to use. If the font is unavailable, it defaults to Helvetica/San Francisco (on macOS).\n\n\n\n"
},

{
    "location": "text.html#Luxor.fontsize",
    "page": "Text",
    "title": "Luxor.fontsize",
    "category": "Function",
    "text": "fontsize(n)\n\nSet the font size to n points. Default is 10pt.\n\n\n\n"
},

{
    "location": "text.html#Luxor.textextents",
    "page": "Text",
    "title": "Luxor.textextents",
    "category": "Function",
    "text": "textextents(str)\n\nReturn the measurements of the string str when set using the current font settings:\n\nx_bearing\ny_bearing\nwidth\nheight\nx_advance\ny_advance\n\nThe bearing is the displacement from the reference point to the upper-left corner of the bounding box. It is often zero or a small positive value for x displacement, but can be negative x for characters like j; it's almost always a negative value for y displacement.\n\nThe width and height then describe the size of the bounding box. The advance takes you to the suggested reference point for the next letter. Note that bounding boxes for subsequent blocks of text can overlap if the bearing is negative, or the advance is smaller than the width would suggest.\n\nExample:\n\ntextextents(\"R\")\n\nreturns\n\n[1.18652; -9.68335; 8.04199; 9.68335; 9.74927; 0.0]\n\n\n\n"
},

{
    "location": "text.html#Fonts-1",
    "page": "Text",
    "title": "Fonts",
    "category": "section",
    "text": "Use fontface(fontname) to choose a font, and fontsize(n) to set the font size in points.The textextents(str) function gets an array of dimensions of the string str, given the current font.(Image: textextents)The green dot is the text placement point and reference point for the font, the yellow circle shows the text block's x and y bearings, and the blue dot shows the advance point where the next character should be placed.fontface\nfontsize\ntextextents"
},

{
    "location": "text.html#Luxor.textcurve",
    "page": "Text",
    "title": "Luxor.textcurve",
    "category": "Function",
    "text": "Place a string of text on a curve. It can spiral in or out.\n\ntextcurve(the_text,\n          start_angle,\n          start_radius,\n          x_pos = 0,\n          y_pos = 0;\n          # optional keyword arguments:\n          spiral_ring_step = 0,    # step out or in by this amount\n          letter_spacing = 0,      # tracking/space between chars, tighter is (-), looser is (+)\n          spiral_in_out_shift = 0, # + values go outwards, - values spiral inwards\n          clockwise = true         #\n          )\n\nstart_angle is relative to +ve x-axis, arc/circle is centred on (x_pos,y_pos) with radius start_radius.\n\n\n\n"
},

{
    "location": "text.html#Text-on-a-curve-1",
    "page": "Text",
    "title": "Text on a curve",
    "category": "section",
    "text": "Use textcurve(str) to draw a string str on a circular arc or spiral.(Image: text on a curve or spiral)using Luxor\nDrawing(1800, 1800, \"/tmp/text-spiral.png\")\norigin()\nbackground(\"ivory\")\nfontsize(18)\nfontface(\"LucidaSansUnicode\")\nsethue(\"royalblue4\")\ntextstring = join(names(Base), \" \")\ntextcurve(\"this spiral contains every word in julia names(Base): \" * textstring, -pi/2,\n  800, 0, 0,\n  spiral_in_out_shift = -18.0,\n  letter_spacing = 0,\n  spiral_ring_step = 0)\n\nfontsize(35)\nfontface(\"Agenda-Black\")\ntextcentred(\"julia names(Base)\", 0, 0)\nfinish()\npreview()textcurve"
},

{
    "location": "text.html#Text-clipping-1",
    "page": "Text",
    "title": "Text clipping",
    "category": "section",
    "text": "You can use newly-created text paths as a clipping region - here the text paths are filled with names of randomly chosen Julia functions:(Image: text clipping)using Luxor\n\ncurrentwidth = 1250 # pts\ncurrentheight = 800 # pts\nDrawing(currentwidth, currentheight, \"/tmp/text-path-clipping.png\")\n\norigin()\nbackground(\"darkslategray3\")\n\nfontsize(600)                             # big fontsize to use for clipping\nfontface(\"Agenda-Black\")\nstr = \"julia\"                             # string to be clipped\nw, h = textextents(str)[3:4]              # get width and height\n\ntranslate(-(currentwidth/2) + 50, -(currentheight/2) + h)\n\ntextpath(str)                             # make text into a path\nsetline(3)\nsetcolor(\"black\")\nfillpreserve()                            # fill but keep\nclip()                                    # and use for clipping region\n\nfontface(\"Monaco\")\nfontsize(10)\nnamelist = map(x->string(x), names(Base)) # get list of function names in Base.\n\nx = -20\ny = -h\nwhile y < currentheight\n    sethue(rand(7:10)/10, rand(7:10)/10, rand(7:10)/10)\n    s = namelist[rand(1:end)]\n    text(s, x, y)\n    se = textextents(s)\n    x += se[5]                            # move to the right\n    if x > w\n       x = -20                            # next row\n       y += 10\n    end\nend\n\nfinish()\npreview()"
},

{
    "location": "transforms.html#",
    "page": "Transforms and matrices",
    "title": "Transforms and matrices",
    "category": "page",
    "text": ""
},

{
    "location": "transforms.html#Base.scale",
    "page": "Transforms and matrices",
    "title": "Base.scale",
    "category": "Function",
    "text": "Scale subsequent drawing in x and y.\n\nExample:\n\nscale(0.2, 0.3)\n\n\n\n"
},

{
    "location": "transforms.html#Luxor.rotate",
    "page": "Transforms and matrices",
    "title": "Luxor.rotate",
    "category": "Function",
    "text": "Rotate subsequent drawing by a radians clockwise.\n\nrotate(a)\n\n\n\n"
},

{
    "location": "transforms.html#Luxor.translate",
    "page": "Transforms and matrices",
    "title": "Luxor.translate",
    "category": "Function",
    "text": "Translate to new location.\n\ntranslate(x, y)\n\nor\n\ntranslate(point)\n\n\n\n"
},

{
    "location": "transforms.html#Luxor.getmatrix",
    "page": "Transforms and matrices",
    "title": "Luxor.getmatrix",
    "category": "Function",
    "text": "Get the current matrix.\n\ngetmatrix()\n\nReturns the current Cairo matrix as an array. In Cairo/Luxor, a matrix is an array of six float64 numbers:\n\nxx component of the affine transformation\nyx component of the affine transformation\nxy component of the affine transformation\nyy component of the affine transformation\nx0 translation component of the affine transformation\ny0 translation component of the affine transformation\n\nSome basic matrix transforms:\n\ntranslate transform([1, 0, 0, 1, dx, dy]) => shift by dx, dy\nscale transform([fx, 0, 0, fy,  0, 0]) => scale by fx, fy\nrotate transform([cos(a), -sin(a), sin(a), cos(a), 0, 0]) => rotate to a radians\nx-skew transform([1, 0, tan(a), 1, 0, 0]) => xskew by a\ny-skew transform([1, tan(a), 0, 1, 0, 0]) => yskew by a\nflip transform([fx, 0, 0, fy, centerx * (1 - fx), centery * (fy-1)]) => flip with center at centerx/centery\n\nWhen a drawing is first created, the matrix looks like this:\n\ngetmatrix() = [1.0, 0.0, 0.0, 1.0, 0.0, 0.0]\n\nWhen the origin is moved to 400/400, it looks like this:\n\ngetmatrix() = [1.0, 0.0, 0.0, 1.0, 400.0, 400.0]\n\nTo reset the matrix to the original:\n\nsetmatrix([1.0, 0.0, 0.0, 1.0, 0.0, 0.0])\n\ntranslate:      [1  0 0  1 X Y] scale O:        [W  0 0  H 0 0] rotate O:       [c -s s  c 0 0] shear in x:     [1  0 A  1 0 0] shear in y:     [1  B 0  1 0 0] reflect O:      [-1 0 0 -1 0 0] reflect xaxis:  [1  0 0 -1 0 0] reflect yaxis:  [-1 0 0  1 0 0]\n\n\n\n"
},

{
    "location": "transforms.html#Luxor.setmatrix",
    "page": "Transforms and matrices",
    "title": "Luxor.setmatrix",
    "category": "Function",
    "text": "Change the current Cairo matrix to matrix m.\n\nsetmatrix(m::Array)\n\nUse getmatrix() to get the current matrix.\n\n\n\n"
},

{
    "location": "transforms.html#Luxor.transform",
    "page": "Transforms and matrices",
    "title": "Luxor.transform",
    "category": "Function",
    "text": "Modify the current matrix by multiplying it by matrix a.\n\ntransform(a::Array)\n\nFor example, to skew the current state by 45 degrees in x and move by 20 in y direction:\n\ntransform([1, 0, tand(45), 1, 0, 20])\n\nUse getmatrix() to get the current matrix.\n\n\n\n"
},

{
    "location": "transforms.html#Transforms-and-matrices-1",
    "page": "Transforms and matrices",
    "title": "Transforms and matrices",
    "category": "section",
    "text": "For basic transformations of the drawing space, use scale(sx, sy), rotate(a), and translate(tx, ty). You can use axes() to return to the document's original state, with the axes in the center.translate() shifts the current 0/0 point by the specified amounts in x and y. It's relative and cumulative, rather than absolute:using Luxor, Colors # hide\nDrawing(400, 200, \"../figures/translate.png\") # hide\nbackground(\"white\") # hide\nsrand(1) # hide\nsetline(1) # hide\norigin()\nfor i in range(0, 30, 6)\n  sethue(HSV(i, 1, 1)) # from Colors\n  setopacity(0.5)\n  circle(0, 0, 20, :fillpreserve)\n  setcolor(\"black\")\n  stroke()\n  translate(25, 0)\nend\nfinish() # hide(Image: translate)scale() scales the current workspace by the specified amounts in x and y. Again, it's relative to the current scale, not to the document's original.using Luxor, Colors # hide\nDrawing(400, 200, \"../figures/scale.png\") # hide\nbackground(\"white\") # hide\nsrand(1) # hide\nsetline(1) # hide\norigin()\nfor i in range(0, 30, 6)\n  sethue(HSV(i, 1, 1)) # from Colors\n  circle(0, 0, 90, :fillpreserve)\n  setcolor(\"black\")\n  stroke()\n  scale(0.8, 0.8)\nend\nfinish() # hide(Image: scale)rotate() rotates the current workspace by the specifed amount about the current 0/0 point. It's relative to the previous rotation, not to the document's original.using Luxor # hide\nDrawing(400, 200, \"../figures/rotate.png\") # hide\nbackground(\"white\") # hide\nsrand(1) # hide\nsetline(1) # hide\norigin()\nsetopacity(0.7) # hide\nfor i in 1:8\n  randomhue()\n  squircle(Point(40, 0), 20, 30, :fillpreserve)\n  sethue(\"black\")\n  stroke()\n  rotate(pi/4)\nend\nfinish() # hide(Image: rotate)scale\nrotate\ntranslateThe current matrix is a six element array, perhaps like this:[1, 0, 0, 1, 0, 0]transform(a) transforms the current workspace by 'multiplying' the current matrix with matrix a. For example, transform([1, 0, xskew, 1, 50, 0]) skews the current matrix by xskew radians and moves it 50 in x and 0 in y.using Luxor # hide\nfname = \"../figures/transform.png\" # hide\npagewidth, pageheight = 450, 100 # hide\nDrawing(pagewidth, pageheight, fname) # hide\norigin() # hide\nbackground(\"white\") # hide\ntranslate(-200, 0) # hide\n\nfunction boxtext(p, t)\n  sethue(\"grey30\")\n  box(p, 30, 50, :fill)\n  sethue(\"white\")\n  textcentred(t, p)\nend\n\nfor i in 0:5\n  xskew = tand(i * 5.0)\n  transform([1, 0, xskew, 1, 50, 0])\n  boxtext(O, string(round(rad2deg(xskew), 1), \"°\"))\nend\n\nfinish() # hide(Image: transform)getmatrix() gets the current matrix, setmatrix(a) sets the matrix to array a.getmatrix\nsetmatrix\ntransform"
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
    "text": "Establish a new clipping region by intersecting the current clipping region with the current path and then clearing the current path.\n\nclip()\n\n\n\n"
},

{
    "location": "clipping.html#Luxor.clippreserve",
    "page": "Clipping",
    "title": "Luxor.clippreserve",
    "category": "Function",
    "text": "Establish a new clipping region by intersecting the current clipping region with the current path, but keep the current path.\n\nclippreserve()\n\n\n\n"
},

{
    "location": "clipping.html#Luxor.clipreset",
    "page": "Clipping",
    "title": "Luxor.clipreset",
    "category": "Function",
    "text": "Reset the clipping region to the current drawing's extent.\n\nclipreset()\n\n\n\n"
},

{
    "location": "clipping.html#Clipping-1",
    "page": "Clipping",
    "title": "Clipping",
    "category": "section",
    "text": "Use clip() to turn the current path into a clipping region, masking any graphics outside the path. clippreserve() keeps the current path, but also uses it as a clipping region. clipreset() resets it. :clip is also an action for drawing functions like circle().using Luxor # hide\nDrawing(400, 250, \"../figures/simpleclip.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"grey50\")\nsetdash(\"dotted\")\ncircle(O, 100, :stroke)\nsethue(\"magenta\")\ncircle(O, 100, :clip)\nbox(O, 125, 200, :fill)\nfinish() # hide(Image: simple clip)clip\nclippreserve\nclipresetThis example loads a file containing a function that draws the Julia logo. It can create paths but doesn't necessarily apply an action to them; they can therefore be used as a mask for clipping subsequent graphics, which in this example are  randomly-colored circles:(Image: julia logo mask)# load functions to draw the Julia logo\ninclude(\"../test/julia-logo.jl\")\n\nfunction draw(x, y)\n    foregroundcolors = diverging_palette(rand(0:360), rand(0:360), 200, s = 0.99, b=0.8)\n    gsave()\n    translate(x-100, y)\n    julialogo(false, true)      # add paths for logo\n    clip()                      # use paths for clipping\n    for i in 1:500\n        sethue(foregroundcolors[rand(1:end)])\n        circle(rand(-50:350), rand(0:300), 15, :fill)\n    end\n    grestore()\nend\n\ncurrentwidth = 500 # pts\ncurrentheight = 500 # pts\nDrawing(currentwidth, currentheight, \"/tmp/clipping-tests.pdf\")\norigin()\nbackground(\"white\")\nsetopacity(.4)\ndraw(0, 0)\n\nfinish()\npreview()"
},

{
    "location": "images.html#",
    "page": "Images",
    "title": "Images",
    "category": "page",
    "text": ""
},

{
    "location": "images.html#Luxor.readpng",
    "page": "Images",
    "title": "Luxor.readpng",
    "category": "Function",
    "text": "readpng(pathname)\n\nRead a PNG file into Cairo.\n\nThis returns a image object suitable for placing on the current drawing with placeimage(). You can access its width and height properties:\n\nimage = readpng(\"/tmp/test-image.png\")\nw = image.width\nh = image.height\n\n\n\n"
},

{
    "location": "images.html#Luxor.placeimage",
    "page": "Images",
    "title": "Luxor.placeimage",
    "category": "Function",
    "text": "Place a PNG image on the drawing.\n\nplaceimage(img, xpos, ypos)\n\nThe image img has been previously loaded using readpng().\n\n\n\nPlace a PNG image on the drawing.\n\nplaceimage(img, pos)\n\n\n\nPlace a PNG image on the drawing using alpha transparency.\n\nplaceimage(img, xpos, ypos, a)\n\n\n\nPlace a PNG image on the drawing using alpha transparency.\n\nplaceimage(img, pos, a)\n\n\n\n"
},

{
    "location": "images.html#Images-1",
    "page": "Images",
    "title": "Images",
    "category": "section",
    "text": "There is some limited support for placing PNG images on the drawing. First, load a PNG image using readpng(filename).Then use placeimage() to place a loaded PNG image by its top left corner at point x/y or pt.img = readpng(\"figures/julia-logo-mask.png\")\nw = img.width\nh = img.height\nplaceimage(img, -w/2, -h/2) # centered at pointreadpng\nplaceimageYou can clip images. The following script repeatedly places the image using a circle to define a clipping path:(Image: \"Images\")using Luxor\n\nwidth, height = 4000, 4000\nmargin = 500\n\nfname = \"/tmp/test-image.pdf\"\nDrawing(width, height, fname)\norigin()\nbackground(\"grey25\")\n\nsetline(5)\nsethue(\"green\")\n\nimage = readpng(dirname(@__FILE__) * \"/../docs/figures/julia-logo-mask.png\")\n\nw = image.width\nh = image.height\n\npagetiles = Tiler(width, height, 7, 9)\ntw = pagetiles.tilewidth/2\nfor (pos, n) in pagetiles\n    circle(pos, tw, :stroke)\n    circle(pos, tw, :clip)\n    gsave()\n    translate(pos)\n    scale(.95, .95)\n    rotate(rand(0.0:pi/8:2pi))\n    placeimage(image, -w/2, -h/2)\n    grestore()\n    clipreset()\nend\n\nfinish()"
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
    "text": "With a Turtle you can command a turtle to move and draw: turtle graphics.\n\nThe functions that start with a capital letter are: Forward, Turn, Circle, Orientation, Rectangle, Pendown, Penup, Pencolor, Penwidth, and Reposition.\n\nThere are also some other functions. To see how they might be used, see Lindenmayer.jl.\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Forward",
    "page": "Turtle graphics",
    "title": "Luxor.Forward",
    "category": "Function",
    "text": "Move the turtle forward by d units. The stored position is updated.\n\nForward(t::Turtle, d)\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Turn",
    "page": "Turtle graphics",
    "title": "Luxor.Turn",
    "category": "Function",
    "text": "Increase the turtle's rotation by r radians. See also Orientation.\n\nTurn(t::Turtle, r)\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Circle",
    "page": "Turtle graphics",
    "title": "Luxor.Circle",
    "category": "Function",
    "text": "Draw a filled circle centred at the current position with the given radius.\n\nCircle(t::Turtle, radius)\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.HueShift",
    "page": "Turtle graphics",
    "title": "Luxor.HueShift",
    "category": "Function",
    "text": "Shift the Hue of the turtle's pen forward by inc\n\nHueShift(t::Turtle, inc = 1)\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Message",
    "page": "Turtle graphics",
    "title": "Luxor.Message",
    "category": "Function",
    "text": "Write some text at the current position.\n\nMessage(t::Turtle, txt)\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Orientation",
    "page": "Turtle graphics",
    "title": "Luxor.Orientation",
    "category": "Function",
    "text": "Set the turtle's orientation to r radians. See also Turn.\n\nOrientation(t::Turtle, r)\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Randomize_saturation",
    "page": "Turtle graphics",
    "title": "Luxor.Randomize_saturation",
    "category": "Function",
    "text": "Randomize saturation of the turtle's pen color.\n\nRandomize_saturation(t::Turtle)\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Rectangle",
    "page": "Turtle graphics",
    "title": "Luxor.Rectangle",
    "category": "Function",
    "text": "Draw a filled rectangle centred at the current position with the given radius.\n\nRectangle(t::Turtle, width, height)\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Pen_opacity_random",
    "page": "Turtle graphics",
    "title": "Luxor.Pen_opacity_random",
    "category": "Function",
    "text": "Change the opacity of the pen to some value at random.\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Pendown",
    "page": "Turtle graphics",
    "title": "Luxor.Pendown",
    "category": "Function",
    "text": "Put that pen down and start drawing.\n\nPendown(t::Turtle)\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Penup",
    "page": "Turtle graphics",
    "title": "Luxor.Penup",
    "category": "Function",
    "text": "Pick that pen up and stop drawing.\n\nPenup(t::Turtle)\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Pencolor",
    "page": "Turtle graphics",
    "title": "Luxor.Pencolor",
    "category": "Function",
    "text": "Set the Red, Green, and Blue colors of the turtle:\n\nPencolor(t::Turtle, r, g, b)\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Penwidth",
    "page": "Turtle graphics",
    "title": "Luxor.Penwidth",
    "category": "Function",
    "text": "Set the width of the line drawn.\n\nPenwidth(t::Turtle, w)\n\n\n\n"
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
    "text": "Lift the turtle's position and orientation off a stack.\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Push",
    "page": "Turtle graphics",
    "title": "Luxor.Push",
    "category": "Function",
    "text": "Save the turtle's position and orientation on a stack.\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Reposition",
    "page": "Turtle graphics",
    "title": "Luxor.Reposition",
    "category": "Function",
    "text": "Reposition: pick the turtle up and place it at another position:\n\nReposition(t::Turtle, x, y)\n\n\n\n"
},

{
    "location": "turtle.html#Turtle-graphics-1",
    "page": "Turtle graphics",
    "title": "Turtle graphics",
    "category": "section",
    "text": "Some simple \"turtle graphics\" functions are included. Functions to control the turtle begin with a capital letter: Forward, Turn, Circle, Orientation, Rectangle, Pendown, Penup, Pencolor, Penwidth, and Reposition.(Image: Turtle)using Luxor\n\nDrawing(1200, 1200, \"/tmp/turtles.png\")\norigin()\nbackground(\"black\")\n\n# let's have two turtles\nraphael = Turtle(0, 0, true, 0, (1.0, 0.25, 0.25)) ; michaelangelo = Turtle(0, 0, true, 0, (1.0, 0.25, 0.25))\n\nsetopacity(0.95)\nsetline(6)\n\nPencolor(raphael, 1.0, 0.4, 0.2);       Pencolor(michaelangelo, 0.2, 0.9, 1.0)\nReposition(raphael, 500, -200);         Reposition(michaelangelo, 500, 200)\nMessage(raphael, \"Raphael\");            Message(michaelangelo, \"Michaelangelo\")\nReposition(raphael, 0, -200);           Reposition(michaelangelo, 0, 200)\n\npace = 10\nfor i in 1:5:400\n    for turtle in [raphael, michaelangelo]\n        Circle(turtle, 3)\n        HueShift(turtle, rand())\n        Forward(turtle, pace)\n        Turn(turtle, 30 - rand())\n        Message(turtle, string(i))\n        pace += 1\n    end\nend\n\nfinish()\npreview()Turtle\nForward\nTurn\nCircle\nHueShift\nMessage\nOrientation\nRandomize_saturation\nRectangle\nPen_opacity_random\nPendown\nPenup\nPencolor\nPenwidth\nPoint\nPop\nPush\nReposition"
},

{
    "location": "moreexamples.html#",
    "page": "More examples",
    "title": "More examples",
    "category": "page",
    "text": ""
},

{
    "location": "moreexamples.html#More-examples-1",
    "page": "More examples",
    "title": "More examples",
    "category": "section",
    "text": "A good place to look for examples (sometimes not very exciting or well-written examples, I'll admit), is in the Luxor/test directory.(Image: \"tiled images\")"
},

{
    "location": "moreexamples.html#An-early-test-1",
    "page": "More examples",
    "title": "An early test",
    "category": "section",
    "text": "(Image: Luxor test)using Luxor\nDrawing(1200, 1400, \"basic-test.png\") # or PDF/SVG filename for PDF or SVG\norigin()\nbackground(\"purple\")\nsetopacity(0.7)                      # opacity from 0 to 1\nsethue(0.3,0.7,0.9)                  # sethue sets the color but doesn't change the opacity\nsetline(20)                          # line width\n\nrect(-400,-400,800,800, :fill)       # or :stroke, :fillstroke, :clip\nrandomhue()\ncircle(0, 0, 460, :stroke)\ncircle(0,-200,400,:clip)             # a circular clipping mask above the x axis\nsethue(\"gold\")\nsetopacity(0.7)\nsetline(10)\nfor i in 0:pi/36:2pi - pi/36\n    move(0, 0)\n    line(cos(i) * 600, sin(i) * 600 )\n    stroke()\nend\nclipreset()                           # finish clipping/masking\nfontsize(60)\nsetcolor(\"turquoise\")\nfontface(\"Optima-ExtraBlack\")\ntextwidth = textextents(\"Luxor\")[5]\ntextcentred(\"Luxor\", 0, currentdrawing.height/2 - 400)\nfontsize(18)\nfontface(\"Avenir-Black\")\n\n# text on curve starting at angle 0 rads centered on origin with radius 550\ntextcurve(\"THIS IS TEXT ON A CURVE \" ^ 14, 0, 550, O)\nfinish()\npreview() # on macOS, opens in Preview"
},

{
    "location": "moreexamples.html#Luxor-logo-1",
    "page": "More examples",
    "title": "Luxor logo",
    "category": "section",
    "text": "In this example, the color scheme is mirrored so that the lighter colors are at the top of the circle.(Image: logo)using Luxor, ColorSchemes\n\nfunction spiral(colscheme)\n  circle(0, 0, 90, :clip)\n  for theta in pi/2 - pi/8:pi/8: (19 * pi)/8 # start at the bottom\n    sethue(colorscheme(colscheme, rescale(theta, pi/2, (19 * pi)/8, 0, 1)))\n    gsave()\n    rotate(theta)\n    move(5,0)\n    curve(Point(40, 40), Point(50, -40), Point(80, 30))\n    closepath()\n    fill()\n    grestore()\n  end\n  clipreset()\nend\n\nwidth = 225  # pts\nheight = 225 # pts\nDrawing(width, height, \"/tmp/logo.png\")\norigin()\nbackground(\"white\")\nscale(1.3, 1.3)\ncolscheme = loadcolorscheme(\"solarcolors\")\ncolschememirror = vcat(colscheme, reverse(colscheme))\nspiral(colschememirror)\nfinish()\npreview()"
},

{
    "location": "moreexamples.html#Why-turtles?-1",
    "page": "More examples",
    "title": "Why turtles?",
    "category": "section",
    "text": "An interesting application for turtle-style graphics is for drawing Lindenmayer systems (l-systems). Here's an example of how a complex pattern can emerge from a simple set of rules, taken from Lindenmayer.jl:(Image: penrose)The definition of this figure is:penrose = LSystem(Dict(\"X\"  =>  \"PM++QM----YM[-PM----XM]++t\",\n                       \"Y\"  => \"+PM--QM[---XM--YM]+t\",\n                       \"P\"  => \"-XM++YM[+++PM++QM]-t\",\n                       \"Q\"  => \"--PM++++XM[+QM++++YM]--YMt\",\n                       \"M\"  => \"F\",\n                       \"F\"  => \"\"),\n                  \"1[Y]++[Y]++[Y]++[Y]++[Y]\")where some of the characters—eg \"F\", \"+\", \"-\", and \"t\"—issue turtle control commands, and others—\"X,\", \"Y\", \"P\", and \"Q\"—refer to specific components of the design. The execution of the l-system involves replacing every occurrence in the drawing code of every dictionary key with the matching values."
},

{
    "location": "moreexamples.html#Illustrating-this-document-1",
    "page": "More examples",
    "title": "Illustrating this document",
    "category": "section",
    "text": "This documentation was built with Documenter.jl, which is an amazingly powerful and flexible documentation generator written in Julia. The illustrations are mostly created when the documentation is generated, the source of the image being stored in the Markdown document and processed on the fly:The Markdown markup looks like this:@example using Luxor # hide Drawing(600, 250, \"../figures/polysmooth-pathological.png\") # hide origin() # hide background(\"white\") # hide setopacity(0.75) # hide srand(42) # hide setline(1) # hide p = star(O, 60, 5, 0.35, 0, vertices=true) setdash(\"dot\") sethue(\"red\") prettypoly(p, close=true, :stroke) setdash(\"solid\") sethue(\"black\") polysmooth(p, 40, :fill, debug=true) finish() # hide\n![polysmooth](figures/polysmooth-pathological.png)and it looks like this in the final document:using Luxor # hide\nDrawing(600, 250, \"../figures/polysmoothy.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsetopacity(0.75) # hide\nsrand(42) # hide\nsetline(1) # hide\np = star(O, 60, 5, 0.35, 0, vertices=true)\nsetdash(\"dot\")\nsethue(\"red\")\nprettypoly(p, close=true, :stroke)\nsetdash(\"solid\")\nsethue(\"black\")\npolysmooth(p, 40, :fill, debug=true)\nfinish() # hide(Image: polysmooth)"
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
