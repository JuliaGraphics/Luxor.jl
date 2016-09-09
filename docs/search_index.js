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
    "text": "Luxor provides basic vector drawing functions and utilities for working with shapes, polygons, clipping masks, PNG images, and turtle graphics.The idea of Luxor is that it's easier to use than Cairo.jl, with shorter names, fewer underscores, default contexts, utilities, and simplified functions. It's for when you just want to draw something without too much ceremony.Colors.jl provides excellent color definitions."
},

{
    "location": "index.html#Current-status-1",
    "page": "Introduction to Luxor",
    "title": "Current status",
    "category": "section",
    "text": "Luxor currently runs on Julia version 0.5, using Cairo.jl and Colors.jl.Please submit issues and pull requests on github!"
},

{
    "location": "index.html#Installation-and-basic-usage-1",
    "page": "Introduction to Luxor",
    "title": "Installation and basic usage",
    "category": "section",
    "text": "Since the package is currently unregistered, install it as follows:Pkg.clone(\"https://github.com/cormullion/Luxor.jl\")and to use it:using LuxorIn most of the examples in this documentation, it's assumed that you have added:using Luxor, Colorsbefore the graphics commands."
},

{
    "location": "examples.html#",
    "page": "A few examples",
    "title": "A few examples",
    "category": "page",
    "text": ""
},

{
    "location": "examples.html#The-obligatory-\"Hello-World\"-1",
    "page": "A few examples",
    "title": "The obligatory \"Hello World\"",
    "category": "section",
    "text": "Here's the \"Hello world\":(Image: \"Hello world\")using Luxor, Colors\nDrawing(1000, 1000, \"hello-world.png\")\norigin()\nsethue(\"red\")\nfontsize(50)\ntext(\"hello world\")\nfinish()\npreview()The Drawing(1000, 1000, \"hello-world.png\") line defines the size of the image and the location of the finished image when it's saved. origin() moves the 0/0 point to the centre of the drawing surface (by default it's at the top left corner). Because we're using Colors.jl, we can specify colors by name. text() places text. It's placed at the current 0/0 if you don't specify otherwise. finish() completes the drawing and saves the image in the file. preview() tries to open the saved file using some other application (eg on MacOS X, Preview)."
},

{
    "location": "examples.html#More-examples-1",
    "page": "A few examples",
    "title": "More examples",
    "category": "section",
    "text": "Here are a few more examples."
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
    "text": "The two main defined types are the Point and the Drawing. The Point type holds two coordinates, the x and y:Point(12.0, 13.0)It's immutable, so you want to avoid trying to change the x or y coordinate directly.The other is Drawing, which is how you create new drawings."
},

{
    "location": "basics.html#Luxor.Drawing",
    "page": "Basic graphics",
    "title": "Luxor.Drawing",
    "category": "Type",
    "text": "Create a new drawing, and optionally specify file type (PNG, PDF, SVG, etc) and dimensions.\n\nDrawing()\n\ncreates a drawing, defaulting to PNG format, default filename \"luxor-drawing.png\", default size 800 pixels square.\n\nYou can specify dimensions, and use the default target filename:\n\nDrawing(300,300)\n\ncreates a drawing 300 by 300 pixels, defaulting to PNG format, default filename \"/tmp/luxor-drawing.png\".\n\nDrawing(300,300, \"my-drawing.pdf\")\n\ncreates a PDF drawing in the file \"my-drawing.pdf\", 300 by 300 pixels.\n\nDrawing(800,800, \"my-drawing.svg\")`\n\ncreates an SVG drawing in the file \"my-drawing.svg\", 800 by 800 pixels.\n\nDrawing(800,800, \"my-drawing.eps\")\n\ncreates an EPS drawing in the file \"my-drawing.eps\", 800 by 800 pixels.\n\nDrawing(\"A4\", \"my-drawing.pdf\")\n\ncreates a drawing in ISO A4 size in the file \"my-drawing.pdf\". Other sizes available are:  \"A0\", \"A1\", \"A2\", \"A3\", \"A4\", \"A5\", \"A6\", \"Letter\", \"Legal\", \"A\", \"B\", \"C\", \"D\", \"E\". Append \"landscape\" to get the landscape version.\n\nDrawing(\"A4landscape\")\n\nCreate the drawing A4 landscape size.\n\nNote that PDF files seem to default to a white background, but PNG defaults to black. Might be a bug here somewhere...\n\n\n\n"
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
    "location": "basics.html#Luxor.Tiler",
    "page": "Basic graphics",
    "title": "Luxor.Tiler",
    "category": "Type",
    "text": "A Tiler is an iterator that returns the x/y point of the center of each tile in a set of tiles that divide up a rectangular space such as a page into rows and columns.\n\ntiles = Tiler(areawidth, areaheight, nrows, ncols, margin=20)\n\nwhere width, height is the dimensions of the area to be tiled, nrows/ncols is the number of rows and columns required, and margin is applied to all four edges of the area before the function calculates the tile sizes required.\n\ntiles = Tiler(1000, 800, 4, 5, margin=20)\nfor (pos, n) in tiles\n# the point pos is the center of the tile\nend\n\nYou can access the calculated tile width and height like this:\n\ntiles = Tiler(1000, 800, 4, 5, margin=20)\nfor (pos, n) in tiles\n  ellipse(pos.x, pos.y, tiles.tilewidth, tiles.tileheight, :fill)\nend\n\n\n\n"
},

{
    "location": "basics.html#Drawings-and-files-1",
    "page": "Basic graphics",
    "title": "Drawings and files",
    "category": "section",
    "text": "To create a drawing, and optionally specify the filename and type, and dimensions, use the Drawing function to create a Drawing.DrawingTo finish a drawing and close the file, use finish(), and, to launch an external application to view it, use preview().finish\npreviewThe global variable currentdrawing of type Drawing holds a few parameters which are occasionaly useful:julia> fieldnames(currentdrawing)\n10-element Array{Symbol,1}:\n:width\n:height\n:filename\n:surface\n:cr\n:surfacetype\n:redvalue\n:greenvalue\n:bluevalue\n:alphaThe drawing area (or any other area) can be divided into tiles (rows and columns) using the Tiler iterator.using Luxor, Colors # hide\nDrawing(400, 300, \"../figures/tiler.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsrand(1) # hide\nfontsize(20)\ntiles = Tiler(400, 300, 4, 5, margin=5)\nfor (pos, n) in tiles\n  randomhue()\n  box(pos, tiles.tilewidth, tiles.tileheight, :fillstroke)\n  sethue(\"white\")\n  textcentred(string(n), pos + Point(0, 5))\nend\nfinish() # hide(Image: )Tiler"
},

{
    "location": "basics.html#Luxor.background",
    "page": "Basic graphics",
    "title": "Luxor.background",
    "category": "Function",
    "text": "background(color)\n\nFill the canvas (or the current clipping region, if there is one) with a single color.\n\nExamples:\n\nbackground(\"antiquewhite\")\nbackground(\"ivory\")\nbackground(Colors.RGB(0, 0, 0))\nbackground(Colors.Luv(20, -20, 30))\n\n\n\n"
},

{
    "location": "basics.html#Luxor.axes",
    "page": "Basic graphics",
    "title": "Luxor.axes",
    "category": "Function",
    "text": "Draw two axes lines starting at the current 0/0 and continuing out along the current positive x and y axes.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.origin",
    "page": "Basic graphics",
    "title": "Luxor.origin",
    "category": "Function",
    "text": "origin()\n\nSet the 0/0 origin to the center of the drawing (otherwise it will stay at the top left corner, the default).\n\n\n\n"
},

{
    "location": "basics.html#Axes-and-backgrounds-1",
    "page": "Basic graphics",
    "title": "Axes and backgrounds",
    "category": "section",
    "text": "The origin (0/0) starts off at the top left: the x axis runs left to right, and the y axis runs top to bottom.The origin() function moves the 0/0 point to the center of the drawing. It's often convenient to do this at the beginning of a program.The axes() function draws a couple of lines and text labels in light gray to indicate the position and orientation of the current axes.background() fills the entire image with a color, covering any previous contents.using Luxor, Colors # hide\nDrawing(400, 400, \"../figures/axes.png\") # hide\nbackground(\"gray20\")\norigin()\naxes()\nfinish() # hide(Image: )background\naxes\norigin"
},

{
    "location": "basics.html#Simple-shapes-1",
    "page": "Basic graphics",
    "title": "Simple shapes",
    "category": "section",
    "text": "Functions for making shapes include circle(), ellipse(), squircle(), arc(), carc(), curve(), sector(), rect(), pie(), and box()."
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
    "text": "Create a rectangle between two points and do an action.\n\nbox(cornerpoint1, cornerpoint2, action=:nothing)\n\n\n\nCreate a box/rectangle using the first two points of an array of Points to defined opposite corners.\n\nbox(points::Array, action=:nothing)\n\n\n\nCreate a box/rectangle centered at point pt with width and height.\n\nbox(pt::Point, width, height, action=:nothing)\n\n\n\nCreate a box/rectangle centered at point x/y with width and height.\n\nbox(x, y, width, height, action=:nothing)\n\n\n\n"
},

{
    "location": "basics.html#Rectangles-and-boxes-1",
    "page": "Basic graphics",
    "title": "Rectangles and boxes",
    "category": "section",
    "text": "rect\nbox"
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
    "text": "There are various ways to make circles, including by center and radius, through two points, or passing through three points. You can place ellipses (and circles) by defining centerpoint and width and height.using Luxor, Colors # hide\nDrawing(400, 200, \"../figures/center3.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsetline(3) # hide\nsethue(\"black\")\np1 = Point(0, -50)\np2 = Point(100, 0)\np3 = Point(0, 65)\nmap(p -> circle(p, 4, :fill), [p1, p2, p3])\nsethue(\"orange\") # hide\ncircle(center3pts(p1, p2, p3)..., :stroke)\nfinish() # hide(Image: )circle\nellipseA sector (strictly an \"annular sector\") has an inner and outer radius, as well as start and end angles.using Luxor, Colors # hide\nDrawing(400, 200, \"../figures/sector.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"cyan\") # hide\nsector(50, 90, pi/2, 0, :fill)\nfinish() # hidesector(Image: )A pie (or wedge) has start and end angles.using Luxor, Colors # hide\nDrawing(400, 300, \"../figures/pie.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"magenta\") # hide\npie(0, 0, 100, pi/2, pi, :fill)\nfinish() # hide(Image: )pieA squircle is a cross between a square and a circle. You can adjust the squariness and circularity of it to taste:using Luxor, Colors # hide\nDrawing(600, 400, \"../figures/squircle.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nfontsize(20) # hide\nsetline(2)\ntiles = Tiler(600, 300, 1, 3)\nfor (pos, n) in tiles\n    sethue(\"lavender\")\n    squircle(pos, 80, 80, rt=[0.3, 0.5, 0.7][n], :fillpreserve)\n    sethue(\"grey20\")\n    stroke()\n    textcentered(\"rt = $([0.3, 0.5, 0.7][n])\", pos)\nend\nfinish() # hide(Image: )squircle"
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
    "text": "Add an arc to the current path from angle1 to angle2 going clockwise.\n\narc(xc, yc, radius, angle1, angle2, action=:nothing)\n\nAngles are defined relative to the x-axis, positive clockwise.\n\nTODO: Point versions\n\n\n\n"
},

{
    "location": "basics.html#Luxor.carc",
    "page": "Basic graphics",
    "title": "Luxor.carc",
    "category": "Function",
    "text": "Add an arc to the current path from angle1 to angle2 going counterclockwise.\n\ncarc(xc, yc, radius, angle1, angle2, action=:nothing)\n\nAngles are defined relative to the x-axis, positive clockwise.\n\nTODO: Point versions\n\n\n\n"
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
    "text": "There is a 'current position' which you can set with move(), and can use implicitly in functions like line() and text().move\nrmove\nline\nrline\narc\ncarc\ncurve"
},

{
    "location": "basics.html#Luxor.arrow",
    "page": "Basic graphics",
    "title": "Luxor.arrow",
    "category": "Function",
    "text": "Place a line between two points and add an arrowhead at the end. The arrowhead length is the length of the side of the arrow's head, and arrow head angle is the angle between the side of the head and the shaft of the arrow.\n\narrow(startpoint::Point, endpoint::Point; arrowheadlength=10, arrowheadangle=pi/8)\n\nIt doesn't need stroking/filling, the shaft is stroke()d and the head fill()ed. Quiet at the back of the class.\n\n\n\nPlace a curved arrow, an arc centered at centerpos starting at startangle and ending at endangle with an arrowhead at the end. Angles are measured clockwise from the positive x-axis.\n\narrow(centerpos::Point, radius, startangle, endangle; arrowheadlength=10, arrowheadangle=pi/8)\n\n\n\n"
},

{
    "location": "basics.html#Arrows-1",
    "page": "Basic graphics",
    "title": "Arrows",
    "category": "section",
    "text": "You can draw lines or arcs with arrows at the end with arrow(). For straight arrows, supply the start and end points. For arrows as circular arcs, you provide center, radius, start and finish angles. You can optionally provide dimensions for the arrowheadlength and angle of the tip of the arrow.using Luxor, Colors # hide\nDrawing(400, 250, \"../figures/arrow.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"steelblue4\") # hide\nsetline(2)\narrow(Point(0, 0), Point(0, -65))\narrow(Point(0, 0), Point(100, -65), arrowheadlength=20, arrowheadangle=pi/4)\narrow(Point(0, 0), 100, pi, pi/2, arrowheadlength=25,   arrowheadangle=pi/12)\nfinish() # hide(Image: )arrow"
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
    "location": "basics.html#Luxor.sethue",
    "page": "Basic graphics",
    "title": "Luxor.sethue",
    "category": "Function",
    "text": "Set the color. sethue() is like setcolor(), but (like Mathematica) we sometimes want to change the current 'color' without changing alpha/opacity. Using sethue() rather than setcolor() doesn't change the current alpha opacity.\n\nsethue(\"black\")\nsethue(0.3,0.7,0.9)\n\n\n\nsethue(\"red\")\n\n\n\nsethue(0.3, 0.7, 0.9)\n\nUse setcolor(r,g,b,a) to set transparent colors.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.setcolor",
    "page": "Basic graphics",
    "title": "Luxor.setcolor",
    "category": "Function",
    "text": "setcolor(col::String)\n\nSet the current color to a named color. This relies on Colors.jl to convert a string to RGBA eg setcolor(\"gold\") # or \"green\", \"darkturquoise\", \"lavender\" or what have you. The list is at Colors.color_names.\n\nsetcolor(\"gold\")\nsetcolor(\"darkturquoise\")\n\nUse sethue() for changing colors without changing current opacity level.\n\n\n\nSet the current color.\n\nsetcolor(r, g, b)\nsetcolor(r, g, b, alpha)\nsetcolor(color)\nsetcolor(col::ColorTypes.Colorant)\n\nExamples:\n\nsetcolor(convert(Colors.HSV, Colors.RGB(0.5, 1, 1)))\nsetcolor(.2, .3, .4, .5)\nsetcolor(convert(Color.HSV, Color.RGB(0.5, 1, 1)))\n\nfor i in 1:15:360\n   setcolor(convert(Color.RGB, Color.HSV(i, 1, 1)))\n   ...\nend\n\n\n\n"
},

{
    "location": "basics.html#Luxor.randomhue",
    "page": "Basic graphics",
    "title": "Luxor.randomhue",
    "category": "Function",
    "text": "Set a random hue.\n\nrandomhue()\n\nChoose a random color without changing the current alpha opacity.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.randomcolor",
    "page": "Basic graphics",
    "title": "Luxor.randomcolor",
    "category": "Function",
    "text": "Set a random color.\n\nrandomcolor()\n\nThis probably changes the current alpha opacity too.\n\n\n\n"
},

{
    "location": "basics.html#Color-and-opacity-1",
    "page": "Basic graphics",
    "title": "Color and opacity",
    "category": "section",
    "text": "For color definitions and conversions, use Colors.jl.The difference between the setcolor() and sethue() functions is that sethue() is independent of alpha opacity, so you can change the hue without changing the current opacity value.sethue\nsetcolor\nrandomhue\nrandomcolor"
},

{
    "location": "basics.html#Luxor.setline",
    "page": "Basic graphics",
    "title": "Luxor.setline",
    "category": "Function",
    "text": "Set the line width.\n\nsetline(n)\n\n\n\n"
},

{
    "location": "basics.html#Luxor.setlinecap",
    "page": "Basic graphics",
    "title": "Luxor.setlinecap",
    "category": "Function",
    "text": "Set the line ends. s can be \"butt\" (the default), \"square\", or \"round\".\n\nsetlinecap(s)\n\nsetlinecap(\"round\")\n\n\n\n"
},

{
    "location": "basics.html#Luxor.setlinejoin",
    "page": "Basic graphics",
    "title": "Luxor.setlinejoin",
    "category": "Function",
    "text": "Set the line join, or how to render the junction of two lines when stroking.\n\nsetlinejoin(\"round\")\nsetlinejoin(\"miter\")\nsetlinejoin(\"bevel\")\n\n\n\n"
},

{
    "location": "basics.html#Luxor.setdash",
    "page": "Basic graphics",
    "title": "Luxor.setdash",
    "category": "Function",
    "text": "Set the dash pattern to one of: \"solid\", \"dotted\", \"dot\", \"dotdashed\", \"longdashed\", \"shortdashed\", \"dash\", \"dashed\", \"dotdotdashed\", \"dotdotdotdashed\"\n\nsetlinedash(\"dot\")\n\n\n\n"
},

{
    "location": "basics.html#Luxor.fillstroke",
    "page": "Basic graphics",
    "title": "Luxor.fillstroke",
    "category": "Function",
    "text": "Fill and stroke the current path.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.stroke",
    "page": "Basic graphics",
    "title": "Luxor.stroke",
    "category": "Function",
    "text": "Stroke the current path with the current line width, line join, line cap, and dash settings. The current path is then cleared.\n\nstroke()\n\n\n\n"
},

{
    "location": "basics.html#Base.fill",
    "page": "Basic graphics",
    "title": "Base.fill",
    "category": "Function",
    "text": "Fill the current path with current settings. The current path is then cleared.\n\nfill()\n\n\n\n"
},

{
    "location": "basics.html#Luxor.strokepreserve",
    "page": "Basic graphics",
    "title": "Luxor.strokepreserve",
    "category": "Function",
    "text": "Stroke the current path with current line width, line join, line cap, and dash settings, but then keep the path current.\n\nstrokepreserve()\n\n\n\n"
},

{
    "location": "basics.html#Luxor.fillpreserve",
    "page": "Basic graphics",
    "title": "Luxor.fillpreserve",
    "category": "Function",
    "text": "Fill the current path with current settings, but then keep the path current.\n\nfillpreserve()\n\n\n\n"
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
    "location": "basics.html#Styles-1",
    "page": "Basic graphics",
    "title": "Styles",
    "category": "section",
    "text": "The set- functions control the width, end shapes, join behavior and dash pattern:using Luxor, Colors # hide\nDrawing(400, 250, \"../figures/line-ends.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\ntranslate(-100, -60) # hide\nfontsize(18) # hide\nfor l in 1:3\n  sethue(\"black\")\n  setline(20)\n  setlinecap([\"butt\", \"square\", \"round\"][l])\n  textcentred([\"butt\", \"square\", \"round\"][l], 80l, 80)\n  setlinejoin([\"round\", \"miter\", \"bevel\"][l])\n  textcentred([\"round\", \"miter\", \"bevel\"][l], 80l, 120)\n  poly(ngon(Point(80l, 0), 20, 3, 0, vertices=true), :strokepreserve, close=false)\n  sethue(\"white\")\n  setline(1)\n  stroke()\nend\nfinish() # hide(Image: )using Luxor, Colors # hide\nDrawing(400, 250, \"../figures/dashes.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nfontsize(14) # hide\nsethue(\"black\") # hide\nsetline(12)\npatterns = \"solid\", \"dotted\", \"dot\", \"dotdashed\", \"longdashed\", \"shortdashed\", \"dash\", \"dashed\", \"dotdotdashed\", \"dotdotdotdashed\"\ntiles =  Tiler(400, 250, 10, 1, margin=10)\nfor (pos, n) in tiles\n  setdash(patterns[n])\n  textright(patterns[n], pos.x - 20, pos.y + 4)\n  line(pos, Point(pos.x + 250, pos.y), :stroke)\nend\nfinish() # hide(Image: )setline\nsetlinecap\nsetlinejoin\nsetdash\nfillstroke\nstroke\nfill\nstrokepreserve\nfillpreservegsave() saves a copy of the current graphics settings (current axis rotation, position, scale, line and text settings, and so on). When the next grestore() is called, all changes you've made to the graphics settings will be discarded, and they'll return to how they were when you used gsave(). gsave() and grestore() should always be balanced in pairs.gsave\ngrestore"
},

{
    "location": "basics.html#Polygons-and-shapes-1",
    "page": "Basic graphics",
    "title": "Polygons and shapes",
    "category": "section",
    "text": ""
},

{
    "location": "basics.html#Shapes-1",
    "page": "Basic graphics",
    "title": "Shapes",
    "category": "section",
    "text": ""
},

{
    "location": "basics.html#Luxor.ngon",
    "page": "Basic graphics",
    "title": "Luxor.ngon",
    "category": "Function",
    "text": "Find the vertices of a regular n-sided polygon centred at x, y:\n\nngon(x, y, radius, sides=5, orientation=0, action=:nothing; vertices=false, reversepath=false)\n\nngon() draws the shapes: if you just want the raw points, use keyword argument vertices=false, which returns the array of points instead. Compare:\n\nngon(0, 0, 4, 4, 0, vertices=false) # returns the polygon's points:\n\n    4-element Array{Luxor.Point,1}:\n    Luxor.Point(2.4492935982947064e-16,4.0)\n    Luxor.Point(-4.0,4.898587196589413e-16)\n    Luxor.Point(-7.347880794884119e-16,-4.0)\n    Luxor.Point(4.0,-9.797174393178826e-16)\n\nwhereas\n\nngon(0, 0, 4, 4, 0, :close) # draws a polygon\n\n\n\nDraw a regular polygon centred at point p:\n\nngon(centerpos, radius, sides=5, orientation=0, action=:nothing; vertices=false, reversepath=false)\n\n\n\n"
},

{
    "location": "basics.html#Regular-polygons-(\"ngons\")-1",
    "page": "Basic graphics",
    "title": "Regular polygons (\"ngons\")",
    "category": "section",
    "text": "You can make regular polygons — from triangles, pentagons, hexagons, septagons, heptagons, octagons, nonagons, decagons, and on-and-on-agons — with ngon().(Image: n-gons)using Luxor, Colors\nDrawing(1200, 1400)\n\norigin()\ncols = diverging_palette(60, 120, 20) # hue 60 to hue 120\nbackground(cols[1])\nsetopacity(0.7)\nsetline(2)\n\nngon(0, 0, 500, 8, 0, :clip)\n\nfor y in -500:50:500\n  for x in -500:50:500\n    setcolor(cols[rand(1:20)])\n    ngon(x, y, rand(20:25), rand(3:12), 0, :fill)\n    setcolor(cols[rand(1:20)])\n    ngon(x, y, rand(10:20), rand(3:12), 0, :stroke)\n  end\nend\n\nfinish()\npreview()ngon"
},

{
    "location": "basics.html#Luxor.prettypoly",
    "page": "Basic graphics",
    "title": "Luxor.prettypoly",
    "category": "Function",
    "text": "Draw the polygon defined by points in pl, possibly closing and reversing it, using the current parameters, and then evaluate (using eval, shudder) the expression at every vertex of the polygon. For example, you can mark each vertex of a polygon with a circle scaled to 0.1.\n\nprettypoly(pointlist::Array,\n  action = :nothing,\n  vertex_action::Expr = :(circle(0, 0, 1, :fill));\n  close=false,\n  reversepath=false)\n\nExample:\n\nprettypoly(pl, :fill, :(scale(0.1, 0.1);\n                        circle(0, 0, 10, :fill)\n                       ),\n          close=false)\n\nThe expression can't use definitions that are not in scope, eg you can't pass a variable in from the calling function and expect this function to know about it. Yes, not tidy...\n\n\n\n"
},

{
    "location": "basics.html#Luxor.simplify",
    "page": "Basic graphics",
    "title": "Luxor.simplify",
    "category": "Function",
    "text": "Simplify a polygon:\n\nsimplify(pointlist::Array, detail=0.1)\n\ndetail is probably the smallest permitted distance between two points in pixels.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.isinside",
    "page": "Basic graphics",
    "title": "Luxor.isinside",
    "category": "Function",
    "text": "Is a point p inside a polygon pol?\n\nisinside(p, pol)\n\nReturns true or false.\n\nThis is an implementation of the Hormann-Agathos (2001) Point in Polygon algorithm\n\n\n\n"
},

{
    "location": "basics.html#Luxor.polysplit",
    "page": "Basic graphics",
    "title": "Luxor.polysplit",
    "category": "Function",
    "text": "Split a polygon into two where it intersects with a line:\n\npolysplit(p, p1, p2)\n\nThis doesn't always work, of course. (Tell me you're not surprised.) For example, a polygon the shape of the letter \"E\" might end up being divided into more than two parts.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.polysortbydistance",
    "page": "Basic graphics",
    "title": "Luxor.polysortbydistance",
    "category": "Function",
    "text": "Sort a polygon by finding the nearest point to the starting point, then the nearest point to that, and so on.\n\npolysortbydistance(p, starting::Point)\n\nYou can end up with convex (self-intersecting) polygons, unfortunately.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.polysortbyangle",
    "page": "Basic graphics",
    "title": "Luxor.polysortbyangle",
    "category": "Function",
    "text": "Sort the points of a polygon into order. Points are sorted according to the angle they make with a specified point.\n\npolysortbyangle(pointlist::Array, refpoint=minimum(pointlist))\n\nThe refpoint can be chosen, but the minimum point is usually OK too:\n\npolysortbyangle(parray, polycentroid(parray))\n\n\n\n"
},

{
    "location": "basics.html#Luxor.polycentroid",
    "page": "Basic graphics",
    "title": "Luxor.polycentroid",
    "category": "Function",
    "text": "Find the centroid of simple polygon.\n\npolycentroid(pointlist)\n\nReturns a point. This only works for simple (non-intersecting) polygons.\n\nYou could test the point using isinside().\n\n\n\n"
},

{
    "location": "basics.html#Luxor.polybbox",
    "page": "Basic graphics",
    "title": "Luxor.polybbox",
    "category": "Function",
    "text": "Find the bounding box of a polygon (array of points).\n\npolybbox(pointlist::Array)\n\nReturn the two opposite corners (suitable for box(), for example).\n\n\n\n"
},

{
    "location": "basics.html#Polygons-1",
    "page": "Basic graphics",
    "title": "Polygons",
    "category": "section",
    "text": "A polygon is an array of Points. Use poly() to add them, or randompointarray() to create a random list of Points.Polygons can contain holes. The reversepath keyword changes the direction of the polygon. The following piece of code uses ngon() to make two polygons, the second forming a hole in the first, to make a hexagonal bolt shape:using Luxor, Colors # hide\nDrawing(400, 250, \"../figures/holes.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"orchid4\") # hide\nngon(0, 0, 60, 6, 0, :path)\nnewsubpath()\nngon(0, 0, 40, 6, 0, :path, reversepath=true)\nfillstroke()\nfinish() # hide(Image: )The prettypoly() function can place graphics at each vertex of a polygon. After the polygon action, the vertex_action is evaluated at each vertex. For example, to mark each vertex of a polygon with a randomly-colored circle:using Luxor, Colors\nDrawing(400, 250, \"../figures/prettypoly.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"steelblue4\") # hide\nsetline(4)\npoly1 = ngon(0, 0, 100, 6, 0, vertices=true)\nprettypoly(poly1, :stroke, :(\n  randomhue();\n  scale(0.5, 0.5);\n  circle(0, 0, 15, :stroke)\n  ),\nclose=true)\nfinish() # hide(Image: )prettypolyPolygons can be simplified using the Douglas-Peucker algorithm (non-recursive version), via simplify().using Luxor, Colors # hide\nDrawing(600, 500, \"../figures/simplify.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"black\") # hide\nsetline(1) # hide\nfontsize(20) # hide\ntranslate(0, -120) # hide\nsincurve =  (Point(6x, 80sin(x)) for x in -5pi:pi/20:5pi)\nprettypoly(collect(sincurve), :stroke, :(sethue(\"red\"); circle(0, 0, 3, :fill)))\ntext(string(\"number of points: \", length(collect(sincurve))), 0, 100)\ntranslate(0, 200)\nsimplercurve = simplify(collect(sincurve), 0.5)\nprettypoly(simplercurve, :stroke, :(sethue(\"red\"); circle(0, 0, 3, :fill)))\ntext(string(\"number of points: \", length(simplercurve)), 0, 100)\nfinish() # hide(Image: )simplifyThe isinside() function returns true if a point is inside a polygon.using Luxor, Colors # hide\nDrawing(400, 250, \"../figures/isinside.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsetopacity(0.5)\napolygon = star(Point(0,0), 100, 5, 0.5, 0, vertices=true)\nfor n in 1:10000\n  apoint = randompoint(Point(-200, -150), Point(200, 150))\n  randomhue()\n  isinside(apoint, apolygon) && circle(apoint, 3, :fill)\nend\nfinish() # hide\npreview() # hide(Image: )isinsideThere are some experimental polygon functions. These don't work well for polygons that aren't simple or where the sides intersect each other, but they sometimes do the job. For example, here's polysplit():using Luxor, Colors # hide\nDrawing(400, 150, \"../figures/polysplit.pdf\") # hide\norigin()\nsetopacity(0.8)\nsethue(\"black\")\ns = squircle(Point(0,0), 60, 60, vertices=true)\npt1 = Point(0, -120)\npt2 = Point(0, 120)\nline(pt1, pt2, :stroke)\npoly1, poly2 = polysplit(s, pt1, pt2)\nrandomhue()\npoly(poly1, :fill)\nrandomhue()\npoly(poly2, :fill)\nfinish() # hide(Image: )polysplit\npolysortbydistance\npolysortbyangle\npolycentroid\npolybbox"
},

{
    "location": "basics.html#Luxor.star",
    "page": "Basic graphics",
    "title": "Luxor.star",
    "category": "Function",
    "text": "Make a star:\n\nstar(xcenter, ycenter, radius, npoints=5, ratio=0.5, orientation=0, action=:nothing; vertices = false, reversepath=false)\n\nUse vertices=true to return the vertices of a star instead of drawing it.\n\n\n\nDraw a star centered at a position:\n\nstar(center, radius, npoints=5, ratio=0.5, orientation=0, action=:nothing; vertices = false, reversepath=false)\n\n\n\n"
},

{
    "location": "basics.html#Stars-1",
    "page": "Basic graphics",
    "title": "Stars",
    "category": "section",
    "text": "Use star() to make a star.using Luxor, Colors # hide\nDrawing(500, 300, \"../figures/stars.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\ntiles = Tiler(400, 300, 4, 6, margin=5)\nfor (pos, n) in tiles\n  randomhue()\n  star(pos, tiles.tilewidth/3, rand(3:8), 0.5, 0, :fill)\nend\nfinish() # hide(Image: stars)star"
},

{
    "location": "basics.html#Text-and-fonts-1",
    "page": "Basic graphics",
    "title": "Text and fonts",
    "category": "section",
    "text": ""
},

{
    "location": "basics.html#Luxor.text",
    "page": "Basic graphics",
    "title": "Luxor.text",
    "category": "Function",
    "text": "text(str)\ntext(str, x, y)\ntext(str, pt)\n\nDraw the text in the string str at x/y or pt, placing the start of the string at the point. If you omit the point, it's placed at 0/0.\n\nIn Luxor, placing text doesn't affect the current point.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.textcentred",
    "page": "Basic graphics",
    "title": "Luxor.textcentred",
    "category": "Function",
    "text": "textcentred(str)\ntextcentred(str, x, y)\ntextcentred(str, pt)\n\nDraw text in the string str centered at x/y or pt. If you omit the point, it's placed at 0/0.\n\nText doesn't affect the current point!\n\n\n\n"
},

{
    "location": "basics.html#Luxor.textright",
    "page": "Basic graphics",
    "title": "Luxor.textright",
    "category": "Function",
    "text": "textright(str)\ntextright(str, x, y)\ntextright(str, pt)\n\nDraw text in the string str right-aligned at x/y or pt. If you omit the point, it's placed at 0/0.\n\nText doesn't affect the current point!\n\n\n\n"
},

{
    "location": "basics.html#Luxor.textpath",
    "page": "Basic graphics",
    "title": "Luxor.textpath",
    "category": "Function",
    "text": "textpath(t)\n\nConvert the text in string t to a new path, for subsequent filling/stroking etc...\n\n\n\n"
},

{
    "location": "basics.html#Placing-text-1",
    "page": "Basic graphics",
    "title": "Placing text",
    "category": "section",
    "text": "Use text(), textcentred(), and textright() to place text. textpath() converts the text into  a graphic path suitable for further manipulations.text\ntextcentred\ntextright\ntextpath"
},

{
    "location": "basics.html#Luxor.fontface",
    "page": "Basic graphics",
    "title": "Luxor.fontface",
    "category": "Function",
    "text": "fontface(fontname)\n\nSelect a font to use. If the font is unavailable, it defaults to Helvetica/San Francisco (on macOS).\n\n\n\n"
},

{
    "location": "basics.html#Luxor.fontsize",
    "page": "Basic graphics",
    "title": "Luxor.fontsize",
    "category": "Function",
    "text": "fontsize(n)\n\nSet the font size to n points. Default is 10pt.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.textextents",
    "page": "Basic graphics",
    "title": "Luxor.textextents",
    "category": "Function",
    "text": "textextents(str)\n\nReturn the measurements of the string str when set using the current font settings:\n\nx_bearing\ny_bearing\nwidth\nheight\nx_advance\ny_advance\n\nThe bearing is the displacement from the reference point to the upper-left corner of the bounding box. It is often zero or a small positive value for x displacement, but can be negative x for characters like j; it's almost always a negative value for y displacement.\n\nThe width and height then describe the size of the bounding box. The advance takes you to the suggested reference point for the next letter. Note that bounding boxes for subsequent blocks of text can overlap if the bearing is negative, or the advance is smaller than the width would suggest.\n\nExample:\n\ntextextents(\"R\")\n\nreturns\n\n[1.18652; -9.68335; 8.04199; 9.68335; 9.74927; 0.0]\n\n\n\n"
},

{
    "location": "basics.html#Fonts-1",
    "page": "Basic graphics",
    "title": "Fonts",
    "category": "section",
    "text": "Use fontface(fontname) to choose a font, and fontsize(n) to set font size in points.The textextents(str) function gets an array of dimensions of the string str, given the current font.fontface\nfontsize\ntextextents"
},

{
    "location": "basics.html#Luxor.textcurve",
    "page": "Basic graphics",
    "title": "Luxor.textcurve",
    "category": "Function",
    "text": "Place a string of text on a curve. It can spiral in or out.\n\ntextcurve(the_text,\n          start_angle,\n          start_radius,\n          x_pos = 0,\n          y_pos = 0;\n          # optional keyword arguments:\n          spiral_ring_step = 0,   # step out or in by this amount\n          letter_spacing = 0,     # tracking/space between chars, tighter is (-), looser is (+)\n          spiral_in_out_shift = 0 # + values go outwards, - values spiral inwards\n          )\n\nstart_angle is relative to +ve x-axis, arc/circle is centred on (x_pos,y_pos) with radius start_radius.\n\n\n\n"
},

{
    "location": "basics.html#Text-on-a-curve-1",
    "page": "Basic graphics",
    "title": "Text on a curve",
    "category": "section",
    "text": "Use textcurve(str) to draw a string str on a circular arc or spiral.(Image: text on a curve or spiral)  using Luxor, Colors\n  Drawing(1800, 1800, \"/tmp/text-spiral.png\")\n  fontsize(18)\n  fontface(\"LucidaSansUnicode\")\n  origin()\n  background(\"ivory\")\n  sethue(\"royalblue4\")\n  textstring = join(names(Base), \" \")\n  textcurve(\"this spiral contains every word in julia names(Base): \" * textstring, -pi/2,\n    800, 0, 0,\n    spiral_in_out_shift = -18.0,\n    letter_spacing = 0,\n    spiral_ring_step = 0)\n\n  fontsize(35)\n  fontface(\"Agenda-Black\")\n  textcentred(\"julia names(Base)\", 0, 0)\n  finish()\n  preview()textcurve"
},

{
    "location": "basics.html#Text-clipping-1",
    "page": "Basic graphics",
    "title": "Text clipping",
    "category": "section",
    "text": "You can use newly-created text paths as a clipping region - here the text paths are 'filled' with names of randomly chosen Julia functions:(Image: text clipping)    using Luxor, Colors\n\n    currentwidth = 1250 # pts\n    currentheight = 800 # pts\n    Drawing(currentwidth, currentheight, \"/tmp/text-path-clipping.png\")\n\n    origin()\n    background(\"darkslategray3\")\n\n    fontsize(600)                             # big fontsize to use for clipping\n    fontface(\"Agenda-Black\")\n    str = \"julia\"                             # string to be clipped\n    w, h = textextents(str)[3:4]              # get width and height\n\n    translate(-(currentwidth/2) + 50, -(currentheight/2) + h)\n\n    textpath(str)                             # make text into a path\n    setline(3)\n    setcolor(\"black\")\n    fillpreserve()                            # fill but keep\n    clip()                                    # and use for clipping region\n\n    fontface(\"Monaco\")\n    fontsize(10)\n    namelist = map(x->string(x), names(Base)) # get list of function names in Base.\n\n    x = -20\n    y = -h\n    while y < currentheight\n        sethue(rand(7:10)/10, rand(7:10)/10, rand(7:10)/10)\n        s = namelist[rand(1:end)]\n        text(s, x, y)\n        se = textextents(s)\n        x += se[5]                            # move to the right\n        if x > w\n           x = -20                            # next row\n           y += 10\n        end\n    end\n\n    finish()\n    preview()"
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
    "text": "Get the current matrix.\n\ngetmatrix()\n\nReturn current Cairo matrix as an array. In Cairo and Luxor, a matrix is an array of 6 float64 numbers:\n\nxx component of the affine transformation\nyx component of the affine transformation\nxy component of the affine transformation\nyy component of the affine transformation\nx0 translation component of the affine transformation\ny0 translation component of the affine transformation\n\nSome basic matrix transforms:\n\ntranslate(dx,dy) =	  transform([1,  0, 0,  1, dx, dy])                 shift by\nscale(fx, fy)    =    transform([fx, 0, 0, fy,  0, 0])                  scale by\nrotate(A)        =    transform([c, s, -c, c,   0, 0])                  rotate to A radians\nx-skew(a)        =    transform([1,  0, tan(a), 1,   0, 0])             xskew by A\ny-skew(a)        =    transform([1, tan(a), 0, 1, 0, 0])                yskew by A\nflip HV          =    transform([fx, 0, 0, fy, cx(1-fx), cy (fy-1)])  flip\n\nWhen a drawing is first created, the matrix looks like this:\n\ngetmatrix() = [1.0, 0.0, 0.0, 1.0, 0.0, 0.0]\n\nWhen the origin is moved to 400/400, it looks like this:\n\ngetmatrix() = [1.0, 0.0, 0.0, 1.0, 400.0, 400.0]\n\nTo reset the matrix to the original:\n\nsetmatrix([1.0, 0.0, 0.0, 1.0, 0.0, 0.0])\n\n\n\n"
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
    "text": "For basic transformations of the drawing space, use scale(sx, sy), rotate(a), and translate(tx, ty).scale\nrotate\ntranslateThe current matrix is a six element array, perhaps like this:[1, 0, 0, 1, 0, 0]getmatrix() gets the current matrix, setmatrix(a) sets the matrix to array a, and  transform(a) transforms the current matrix by 'multiplying' it with matrix a.getmatrix\nsetmatrix\ntransform"
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
    "text": "Use clip() to turn the current path into a clipping region, masking any graphics outside the path. clippreserve() keeps the current path, but also uses it as a clipping region. clipreset() resets it. :clip is also an action for drawing functions like circle().clip\nclippreserve\nclipresetThis example loads a file containing a function that draws the Julia logo. It can create paths but doesn't necessarily apply an action to them; they can therefore be used as a mask for clipping subsequent graphics, which in this example are mainly randomly-colored circles:(Image: julia logo mask)# load functions to draw the Julia logo\ninclude(\"../test/julia-logo.jl\")\n\ncurrentwidth = 500 # pts\ncurrentheight = 500 # pts\nDrawing(currentwidth, currentheight, \"/tmp/clipping-tests.pdf\")\n\nfunction draw(x, y)\n    foregroundcolors = diverging_palette(rand(0:360), rand(0:360), 200, s = 0.99, b=0.8)\n    gsave()\n    translate(x-100, y)\n    julialogo(false, true)      # add paths for logo\n    clip()                      # use paths for clipping\n    for i in 1:500\n        sethue(foregroundcolors[rand(1:end)])\n        circle(rand(-50:350), rand(0:300), 15, :fill)\n    end\n    grestore()\nend\n\norigin()\nbackground(\"white\")\nsetopacity(.4)\ndraw(0, 0)\n\nfinish()\npreview()"
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
    "text": "Read a PNG file into Cairo.\n\nreadpng(pathname)\n\nThis returns a image object suitable for placing on the current drawing with placeimage(). You can access its width and height properties.\n\nimage = readpng(\"/tmp/test-image.png\")\nw = image.width\nh = image.height\n\n\n\n"
},

{
    "location": "images.html#Luxor.placeimage",
    "page": "Images",
    "title": "Luxor.placeimage",
    "category": "Function",
    "text": "Place a PNG image on the drawing.\n\nplaceimage(img, xpos, ypos)\n\nThe image img has been previously loaded using readpng().\n\n\n\nPlace a PNG image on the drawing using alpha transparency.\n\nplaceimage(img, xpos, ypos, a)\n\nThe image img has been previously loaded using readpng().\n\n\n\nPlace a PNG image on the drawing.\n\nplaceimage(img, pos, a)\n\nThe image img has been previously loaded using readpng().\n\n\n\nPlace a PNG image on the drawing using alpha transparency.\n\n  placeimage(img, pos, a)\n\nThe image img has been previously loaded using readpng().\n\n\n\n"
},

{
    "location": "images.html#Images-1",
    "page": "Images",
    "title": "Images",
    "category": "section",
    "text": "There is some limited support for placing PNG images on the drawing. First, load a PNG image using readpng(filename).readpngThen use placeimage() to place a loaded PNG image by its top left corner at point x/y or pt.placeimageimg = readpng(filename)\nplaceimage(img, xpos, ypos)\nplaceimage(img, pt::Point)\nplaceimage(img, xpos, ypos, 0.5) # use alpha transparency of 0.5\nplaceimage(img, pt::Point, 0.5)\n\nimg = readpng(\"figures/julia-logo-mask.png\")\nw = img.width\nh = img.height\nplaceimage(img, -w/2, -h/2) # centered at pointYou can clip images. The following script repeatedly places an image using a circle to define a clipping path:(Image: \"Images\")using Luxor\n\nwidth, height = 4000, 4000\nmargin = 500\n\nDrawing(width, height, \"/tmp/cairo-image.pdf\")\norigin()\nbackground(\"grey25\")\n\nsetline(5)\nsethue(\"green\")\n\nimage = readpng(\"figures/julia-logo-mask.png\")\nw = image.width\nh = image.height\n\nx = (-width/2) + margin\ny = (-height/2) + margin\n\nfor i in 1:36\n    circle(x, y, 250, :stroke)\n    circle(x, y, 250, :clip)\n    gsave()\n    translate(x, y)\n    scale(.95, .95)\n    rotate(rand(0.0:pi/8:2pi))\n\n    placeimage(image, -w/2, -h/2)\n\n    grestore()\n    clipreset()\n    x += 600\n    if x > width/2\n        x = (-width/2) + margin\n        y += 600\n    end\nend\n\nfinish()\npreview()"
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
    "location": "turtle.html#Luxor.Orientation",
    "page": "Turtle graphics",
    "title": "Luxor.Orientation",
    "category": "Function",
    "text": "Set the turtle's orientation to r radians. See also Turn.\n\nOrientation(t::Turtle, r)\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Rectangle",
    "page": "Turtle graphics",
    "title": "Luxor.Rectangle",
    "category": "Function",
    "text": "Draw a filled rectangle centred at the current position with the given radius.\n\nRectangle(t::Turtle, width, height)\n\n\n\n"
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
    "text": "Some simple \"turtle graphics\" functions are included. Functions to control the turtle begin with a capital letter: Forward, Turn, Circle, Orientation, Rectangle, Pendown, Penup, Pencolor, Penwidth, and Reposition.(Image: Turtle)using Luxor, Colors\n\nDrawing(1200, 1200, \"/tmp/turtles.png\")\norigin()\nbackground(\"black\")\n\n# let's have two turtles\nraphael = Turtle(0, 0, true, 0, (1.0, 0.25, 0.25)) ; michaelangelo = Turtle(0, 0, true, 0, (1.0, 0.25, 0.25))\n\nsetopacity(0.95)\nsetline(6)\n\nPencolor(raphael, 1.0, 0.4, 0.2);       Pencolor(michaelangelo, 0.2, 0.9, 1.0)\nReposition(raphael, 500, -200);         Reposition(michaelangelo, 500, 200)\nMessage(raphael, \"Raphael\");            Message(michaelangelo, \"Michaelangelo\")\nReposition(raphael, 0, -200);           Reposition(michaelangelo, 0, 200)\n\npace = 10\nfor i in 1:5:400\n    for turtle in [raphael, michaelangelo]\n        Circle(turtle, 3)\n        HueShift(turtle, rand())\n        Forward(turtle, pace)\n        Turn(turtle, 30 - rand())\n        Message(turtle, string(i))\n        pace += 1\n    end\nend\n\nfinish()\npreview()Turtle\nForward\nTurn\nCircle\nOrientation\nRectangle\nPendown\nPenup\nPencolor\nPenwidth\nReposition"
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
    "text": "(Image: Luxor test)using Luxor, Colors\nDrawing(1200, 1400, \"basic-test.png\") # or PDF/SVG filename for PDF or SVG\n\norigin()\nbackground(\"purple\")\n\nsetopacity(0.7)                      # opacity from 0 to 1\nsethue(0.3,0.7,0.9)                  # sethue sets the color but doesn't change the opacity\nsetline(20)                          # line width\n\nrect(-400,-400,800,800, :fill)       # or :stroke, :fillstroke, :clip\nrandomhue()\ncircle(0, 0, 460, :stroke)\ncircle(0,-200,400,:clip)             # a circular clipping mask above the x axis\nsethue(\"gold\")\nsetopacity(0.7)\nsetline(10)\nfor i in 0:pi/36:2pi - pi/36\n  move(0, 0)\n  line(cos(i) * 600, sin(i) * 600 )\n  stroke()\nend\nclipreset()                           # finish clipping/masking\nfontsize(60)\nsetcolor(\"turquoise\")\nfontface(\"Optima-ExtraBlack\")\ntextwidth = textextents(\"Luxor\")[5]\ntextcentred(\"Luxor\", 0, currentdrawing.height/2 - 400)\nfontsize(18)\nfontface(\"Avenir-Black\")\n\n# text on curve starting at angle 0 rads centered on origin with radius 550\ntextcurve(\"THIS IS TEXT ON A CURVE \" ^ 14, 0, 550, Point(0, 0))\nfinish()\npreview() # on macOS, opens in Preview"
},

{
    "location": "moreexamples.html#Sierpinski-triangle-1",
    "page": "More examples",
    "title": "Sierpinski triangle",
    "category": "section",
    "text": "The main type is the Point, an immutable composite type containing x and y fields.(Image: Sierpinski)using Luxor, Colors\n\nfunction triangle(points::Array{Point}, degree::Int64)\n    global counter, cols\n    setcolor(cols[degree+1])\n    poly(points, :fill)\n    counter += 1\nend\n\nfunction sierpinski(points::Array{Point}, degree::Int64)\n    triangle(points, degree)\n    if degree > 0\n        p1, p2, p3 = points\n        sierpinski([p1, midpoint(p1, p2),\n                        midpoint(p1, p3)], degree-1)\n        sierpinski([p2, midpoint(p1, p2),\n                        midpoint(p2, p3)], degree-1)\n        sierpinski([p3, midpoint(p3, p2),\n                        midpoint(p1, p3)], degree-1)\n    end\nend\n\n@time begin\n    depth = 8 # 12 is ok, 20 is right out\n    cols = distinguishable_colors(depth + 1)\n    Drawing(400, 400, \"/tmp/sierpinski.svg\")\n    origin()\n    setopacity(0.5)\n    counter = 0\n    my_points = [Point(-100, -50), Point(0, 100), Point(100.0, -50.0)]\n    sierpinski(my_points, depth)\n    println(\"drew $counter triangles\")\nend\n\nfinish()\npreview()\n\n# drew 9841 triangles\n# elapsed time: 1.738649452 seconds (118966484 bytes allocated, 2.20% gc time)"
},

{
    "location": "moreexamples.html#Luxor-logo-1",
    "page": "More examples",
    "title": "Luxor logo",
    "category": "section",
    "text": "In this example, the color scheme is mirrored so that the lighter colors are at the top of the circle.(Image: logo)using Luxor, Colors, ColorSchemes\n\nwidth = 225  # pts\nheight = 225 # pts\nDrawing(width, height, \"/tmp/logo.png\")\n\nfunction spiral(colscheme)\n  circle(0, 0, 90, :clip)\n  for theta in pi/2 - pi/8:pi/8: (19 * pi)/8 # start at the bottom\n    sethue(colorscheme(colscheme, rescale(theta, pi/2, (19 * pi)/8, 0, 1)))\n    gsave()\n    rotate(theta)\n    move(5,0)\n    curve(Point(40, 40), Point(50, -40), Point(80, 30))\n    closepath()\n    fill()\n    grestore()\n  end\n  clipreset()\nend\n\norigin()\nbackground(\"white\")\nscale(1.3, 1.3)\ncolscheme = loadcolorscheme(\"solarcolors\")\ncolschememirror = vcat(colscheme, reverse(colscheme))\nspiral(colschememirror)\nfinish()\npreview()"
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
