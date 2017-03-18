var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Introduction to Luxor",
    "title": "Introduction to Luxor",
    "category": "page",
    "text": "DocTestSetup = quote\n    using Luxor\n    function get_os()\n           if is_apple()\n               osname = \"macOS\"\n           elseif is_unix()\n               osname = \"UNIX\"\n           elseif is_linux()\n               osname = \"Linux\"\n           elseif is_windows()\n               osname = \"Windows\"\n           else\n               osname = \"unspecified\"\n           end\n           return osname\n       end\nend"
},

{
    "location": "index.html#Introduction-to-Luxor-1",
    "page": "Introduction to Luxor",
    "title": "Introduction to Luxor",
    "category": "section",
    "text": "Luxor provides basic vector drawing functions and utilities for working with shapes, polygons, clipping masks, PNG images, and turtle graphics. It's intended to be an easy interface to Cairo.jl.Please submit issues and pull requests on GitHub."
},

{
    "location": "index.html#Current-status-1",
    "page": "Introduction to Luxor",
    "title": "Current status",
    "category": "section",
    "text": "Luxor currently runs on Julia versions 0.4, 0.5, and 0.6, and uses Cairo.jl and Colors.jl.warning: Deprecations\nThe functions fill() and stroke() are deprecated in this release, and will be removed in a future release. They should be replaced with fillpath() and strokepath() respectively.The change is because fill() clashes with Base.fill(), used to fill arrays."
},

{
    "location": "index.html#Installation-and-basic-usage-1",
    "page": "Introduction to Luxor",
    "title": "Installation and basic usage",
    "category": "section",
    "text": "Install the package as follows:Pkg.add(\"Luxor\")and to use it:using LuxorOriginal version by cormullion."
},

{
    "location": "index.html#Documentation-1",
    "page": "Introduction to Luxor",
    "title": "Documentation",
    "category": "section",
    "text": "The documentation was built using Documenter.jl.function get_os() # hide\n    if is_apple() # hide\n        osname = \"macOS\" # hide\n    elseif is_unix() # hide\n        osname = \"UNIX\" # hide\n    elseif is_linux() # hide\n        osname = \"Linux\" # hide\n    elseif is_windows() # hide\n        osname = \"Windows\" # hide\n    else # hide\n        osname = \"unspecified\" # hide\n    end # hide\n    return osname # hide\nend # hide\nprintln(\"Build date: $(now()), built with Julia $(VERSION) on $(get_os()).\") # hide"
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
    "text": "Here's the \"Hello world\":(Image: \"Hello world\")using Luxor\nDrawing(1000, 1000, \"hello-world.png\")\norigin()\nbackground(\"black\")\nsethue(\"red\")\nfontsize(50)\ntext(\"hello world\")\nfinish()\npreview()Drawing(1000, 1000, \"hello-world.png\") defines the size of the image, and the location and type of the finished image. origin() moves the 0/0 point to the centre of the drawing surface (by default it's at the top left corner). Thanks to Colors.jl we can specify colors by name: background(\"black\") defines the color of the background of the drawing. text(\"helloworld\") draws the text. It's placed at the current 0/0 if you don't specify otherwise. finish() completes the drawing and saves the image in the file. preview() tries to open the saved file using some other application (eg Preview on macOS)."
},

{
    "location": "examples.html#The-Julia-logos-1",
    "page": "A few examples",
    "title": "The Julia logos",
    "category": "section",
    "text": "Luxor contains two functions that draw the Julia logo, either in color or a single color, and the three Julia circles.using Luxor\nDrawing(600, 400, \"assets/figures/julia-logos.png\")\norigin()\nbackground(\"white\")\nfor theta in range(0, pi/8, 16)\n    gsave()\n    scale(0.25, 0.25)\n    rotate(theta)\n    translate(250, 0)\n    randomhue()\n    julialogo(action=:fill, color=false)\n    grestore()\nend\ngsave()\nscale(0.3, 0.3)\njuliacircles()\ngrestore()\ntranslate(200, -150)\nscale(0.3, 0.3)\njulialogo()\nfinish()\nnothing # hide(Image: background)The gsave() function saves the current drawing parameters, and any subsequent changes such as the scale() and rotate() operations are discarded by the next grestore() function.You can change the extension of the file name, for example \"julia-logos.png\" to \"julia-logos.svg\" or \"julia-logos.pdf\" or \"julia-logos.eps\", to produce alternative formats."
},

{
    "location": "examples.html#Something-a-bit-more-complicated:-a-Sierpinski-triangle-1",
    "page": "A few examples",
    "title": "Something a bit more complicated: a Sierpinski triangle",
    "category": "section",
    "text": "Here's a version of the Sierpinski recursive triangle, clipped to a circle. (This and subsequent examples assume that the drawing has been created, the origin and background set.)(Image: Sierpinski)function triangle(points, degree)\n    sethue(cols[degree])\n    poly(points, :fill)\nend\n\nfunction sierpinski(points, degree)\n    triangle(points, degree)\n    if degree > 1\n        p1, p2, p3 = points\n        sierpinski([p1, midpoint(p1, p2),\n                        midpoint(p1, p3)], degree-1)\n        sierpinski([p2, midpoint(p1, p2),\n                        midpoint(p2, p3)], degree-1)\n        sierpinski([p3, midpoint(p3, p2),\n                        midpoint(p1, p3)], degree-1)\n    end\nend\n\nfunction draw(n)\n    circle(O, 75, :clip)\n    my_points = ngon(O, 150, 3, -pi/2, vertices=true)\n    sierpinski(my_points, n)\nend\n\ndepth = 8 # 12 is ok, 20 is right out (on my computer, at least)\ncols = distinguishable_colors(depth)\ndraw(depth)The main type (apart from the Drawing) is the Point, an immutable composite type containing x and y fields."
},

{
    "location": "examples.html#Working-in-Jupyter-1",
    "page": "A few examples",
    "title": "Working in Jupyter",
    "category": "section",
    "text": "If you want to work interactively, you can use an environment such as a Jupyter notebook, and load Luxor at the start of a session. The first drawing will take a few seconds, because the Cairo graphics engine needs to warm up. Subsequent drawings are then much quicker. (This is true of much graphics and plotting work, of course. And if you're working in the REPL, after your first drawing subsequent drawings will be much quicker.)(Image: Jupyter)"
},

{
    "location": "examples.html#More-complex-examples-1",
    "page": "A few examples",
    "title": "More complex examples",
    "category": "section",
    "text": ""
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
    "text": "DocTestSetup = quote\n    using Luxor\n    end"
},

{
    "location": "basics.html#The-basics-1",
    "page": "Basic graphics",
    "title": "The basics",
    "category": "section",
    "text": "The underlying drawing model is that you make shapes, or add points to paths, and these are filled and/or stroked, using the current graphics state, which specifies colors, line thicknesses, and opacity. You can modify the drawing space by transforming/rotating/scaling it, which affects subsequent graphics but not the ones you've already added.Many of the drawing functions have an action argument. This can be :nothing, :fill, :stroke, :fillstroke, :fillpreserve, :strokepreserve, :clip. The default is :nothing.Positions are specified either by x and y coordinates or a Point(x, y). The default origin is at the top left of the drawing area.Angles are mostly supplied in radians, measured starting at the positive x-axis turning towards the positive y-axis (which usually points 'down' the page or canvas, so 'clockwise').Coordinates are interpreted as PostScript points, where a point is 1/72 of an inch.Because Julia allows you to combine numbers and variables directly, you can supply units with dimensions and have them converted to points (assuming the current scale is 1:1):inch (in is unavailable, being used by for syntax)\ncm   (centimeters)\nmm   (millimeters)For example:rect(Point(20mm, 2cm), 5inch, (22/7)inch, :fill)"
},

{
    "location": "basics.html#Types-1",
    "page": "Basic graphics",
    "title": "Types",
    "category": "section",
    "text": "The main defined types are Point, Drawing, and Tiler. The Point type holds two coordinates, x and y:Point(12.0, 13.0)It's immutable, so you want to avoid trying to change the x or y coordinate directly. You can use the letter O as a shortcut to refer to the current Origin, Point(0, 0).Drawing is how you create new drawings. You can divide up the drawing area into tiles, using Tiler, and define grids, using ."
},

{
    "location": "basics.html#Luxor.Drawing",
    "page": "Basic graphics",
    "title": "Luxor.Drawing",
    "category": "Type",
    "text": "Create a new drawing, and optionally specify file type (PNG, PDF, SVG, or EPS) and dimensions.\n\nDrawing()\n\ncreates a drawing, defaulting to PNG format, default filename \"luxor-drawing.png\", default size 800 pixels square.\n\nYou can specify dimensions, and use the default target filename:\n\nDrawing(400, 300)\n\ncreates a drawing 400 pixels wide by 300 pixels high, defaulting to PNG format, default filename \"luxor-drawing.png\".\n\nDrawing(400, 300, \"my-drawing.pdf\")\n\ncreates a PDF drawing in the file \"my-drawing.pdf\", 400 by 300 pixels.\n\nDrawing(1200, 800, \"my-drawing.svg\")`\n\ncreates an SVG drawing in the file \"my-drawing.svg\", 1200 by 800 pixels.\n\nDrawing(1200, 1200/golden, \"my-drawing.eps\")\n\ncreates an EPS drawing in the file \"my-drawing.eps\", 1200 wide by 741.8 pixels (= 1200 ÷ ϕ) high.\n\nDrawing(\"A4\", \"my-drawing.pdf\")\n\ncreates a drawing in ISO A4 size (595 wide by 842 high) in the file \"my-drawing.pdf\". Other sizes available are:  \"A0\", \"A1\", \"A2\", \"A3\", \"A4\", \"A5\", \"A6\", \"Letter\", \"Legal\", \"A\", \"B\", \"C\", \"D\", \"E\". Append \"landscape\" to get the landscape version.\n\nDrawing(\"A4landscape\")\n\ncreates the drawing A4 landscape size.\n\nPDF files default to a white background, but PNG defaults to transparent, unless you specify one using background().\n\n\n\n"
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
    "text": "preview()\n\nIf working in Jupyter (IJUlia), display a PNG file in the notebook. On macOS, open the file, which probably uses the default, Preview.app. On Unix, open the file with xdg-open. On Windows, pass the filename to the shell.\n\n\n\n"
},

{
    "location": "basics.html#Drawings-and-files-1",
    "page": "Basic graphics",
    "title": "Drawings and files",
    "category": "section",
    "text": "To create a drawing, and optionally specify the filename and type, and dimensions, use the Drawing constructor function.DrawingTo finish a drawing and close the file, use finish(), and, to launch an external application to view it, use preview().If you're using Jupyter (IJulia), preview() displays PNG files in the notebook.(Image: jupyter)finish\npreviewThe global variable currentdrawing (of type Drawing) stores some parameters related to the current drawing:julia> fieldnames(currentdrawing)\n10-element Array{Symbol,1}:\n:width\n:height\n:filename\n:surface\n:cr\n:surfacetype\n:redvalue\n:greenvalue\n:bluevalue\n:alpha"
},

{
    "location": "basics.html#Luxor.background",
    "page": "Basic graphics",
    "title": "Luxor.background",
    "category": "Function",
    "text": "background(color)\n\nFill the canvas with a single color. Returns the (red, green, blue, alpha) values.\n\nExamples:\n\nbackground(\"antiquewhite\")\nbackground(\"ivory\")\n\nIf Colors.jl is installed:\n\nbackground(RGB(0, 0, 0))\nbackground(Luv(20, -20, 30))\n\nIf you don't specify a background color for a PNG drawing, the background will be transparent. You can set a partly or completely transparent background for PNG files by passing a color with an alpha value, such as this 'transparent black':\n\nbackground(RGBA(0, 0, 0, 0))\n\n\n\n"
},

{
    "location": "basics.html#Luxor.axes",
    "page": "Basic graphics",
    "title": "Luxor.axes",
    "category": "Function",
    "text": "Draw and label two axes lines starting at O, the current 0/0, and continuing out along the current positive x and y axes.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.origin",
    "page": "Basic graphics",
    "title": "Luxor.origin",
    "category": "Function",
    "text": "origin()\n\nReset the current matrix, and then set the 0/0 origin to the center of the drawing (otherwise it will stay at the top left corner, the default).\n\nYou can refer to the 0/0 point as O. (O = Point(0, 0)),\n\n\n\n"
},

{
    "location": "basics.html#The-drawing-surface-1",
    "page": "Basic graphics",
    "title": "The drawing surface",
    "category": "section",
    "text": "The origin (0/0) starts off at the top left: the x axis runs left to right across the page, and the y axis runs top to bottom down the page.The origin() function moves the 0/0 point to the center of the drawing. It's often convenient to do this at the beginning of a program. You can use functions like scale(), rotate(), and translate() to change the coordinate system.background() fills the drawing with a color, covering any previous contents. By default, PDF drawings have a white background, whereas PNG drawings have no background so that the background appears transparent in other applications. If there is a current clipping region, background() fills just that region. In the next example, the first background() fills the entire drawing with magenta, but the calls in the loop fill only the active clipping region, a tile defined by the Tiler iterator:using Luxor # hide\nDrawing(600, 400, \"assets/figures/backgrounds.png\") # hide\nbackground(\"magenta\")\norigin() # hide\ntiles = Tiler(600, 400, 5, 5, margin=30)\nfor (pos, n) in tiles\n    box(pos, tiles.tilewidth, tiles.tileheight, :clip)\n    background(randomhue()...)\n    clipreset()\nend\nfinish() # hide\nnothing # hide(Image: background)The axes() function draws a couple of lines and text labels in light gray to indicate the position and orientation of the current axes.using Luxor # hide\nDrawing(400, 400, \"assets/figures/axes.png\") # hide\nbackground(\"gray80\")\norigin()\naxes()\nfinish() # hide\nnothing # hide(Image: axes)background\naxes\norigin"
},

{
    "location": "basics.html#Luxor.Tiler",
    "page": "Basic graphics",
    "title": "Luxor.Tiler",
    "category": "Type",
    "text": "tiles = Tiler(areawidth, areaheight, nrows, ncols, margin=20)\n\nA Tiler is an iterator that, for each iteration, returns a tuple of:\n\nthe x/y point of the center of each tile in a set of tiles that divide up a rectangular space such as a page into rows and columns (relative to current 0/0)\nthe number of the tile\n\nareawidth and areaheight are the dimensions of the area to be tiled, nrows/ncols are the number of rows and columns required, and margin is applied to all four edges of the area before the function calculates the tile sizes required.\n\ntiles = Tiler(1000, 800, 4, 5, margin=20)\nfor (pos, n) in tiles\n    # the point pos is the center of the tile\nend\n\nYou can access the calculated tile width and height like this:\n\ntiles = Tiler(1000, 800, 4, 5, margin=20)\nfor (pos, n) in tiles\n    ellipse(pos.x, pos.y, tiles.tilewidth, tiles.tileheight, :fill)\nend\n\nIt's sometimes useful to know which row and column you're currently on:\n\ntiles.currentrow\ntiles.currentcol\n\nshould have that information for you.\n\n\n\n"
},

{
    "location": "basics.html#Tiles-1",
    "page": "Basic graphics",
    "title": "Tiles",
    "category": "section",
    "text": "The drawing area (or any other area) can be divided into rectangular tiles (as rows and columns) using the Tiler iterator, which returns the center point and tile number of each tile in turn.In this example, every third tile is divided up into subtiles and colored:using Luxor # hide\nDrawing(400, 300, \"assets/figures/tiler.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsrand(1) # hide\nfontsize(20) # hide\ntiles = Tiler(400, 300, 4, 5, margin=5)\nfor (pos, n) in tiles\n    randomhue()\n    box(pos, tiles.tilewidth, tiles.tileheight, :fill)\n    if n % 3 == 0\n        gsave()\n        translate(pos)\n        subtiles = Tiler(tiles.tilewidth, tiles.tileheight, 4, 4, margin=5)\n        for (pos1, n1) in subtiles\n            randomhue()\n            box(pos1, subtiles.tilewidth, subtiles.tileheight, :fill)\n        end\n        grestore()\n    end\n    sethue(\"white\")\n    textcentred(string(n), pos + Point(0, 5))\nend\nfinish() # hide\nnothing # hide(Image: tiler)Tiler"
},

{
    "location": "basics.html#Luxor.gsave",
    "page": "Basic graphics",
    "title": "Luxor.gsave",
    "category": "Function",
    "text": "gsave()\n\nSave the current color settings on the stack.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.grestore",
    "page": "Basic graphics",
    "title": "Luxor.grestore",
    "category": "Function",
    "text": "grestore()\n\nReplace the current graphics state with the one on top of the stack.\n\n\n\n"
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
    "text": "Functions for making shapes include rect(), box(), circle(), ellipse(), squircle(), arc(), carc(), curve(), sector(), and pie(). There's also ngon() and star(), listed under Polygons, below."
},

{
    "location": "basics.html#Luxor.rect",
    "page": "Basic graphics",
    "title": "Luxor.rect",
    "category": "Function",
    "text": "rect(xmin, ymin, w, h, action)\n\nCreate a rectangle with one corner at (xmin/ymin) with width w and height h and then do an action.\n\nSee box() for more ways to do similar things, such as supplying two opposite corners, placing by centerpoint and dimensions.\n\n\n\nrect(cornerpoint, w, h, action)\n\nCreate a rectangle with one corner at cornerpoint with width w and height h and do an action.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.box",
    "page": "Basic graphics",
    "title": "Luxor.box",
    "category": "Function",
    "text": "box(cornerpoint1, cornerpoint2, action=:nothing)\n\nCreate a rectangle between two points and do an action.\n\n\n\nbox(points::Array, action=:nothing)\n\nCreate a box/rectangle using the first two points of an array of Points to defined opposite corners.\n\n\n\nbox(pt::Point, width, height, action=:nothing; vertices=false)\n\nCreate a box/rectangle centered at point pt with width and height. Use vertices=true to return an array of the four corner points rather than draw the box.\n\n\n\nbox(x, y, width, height, action=:nothing)\n\nCreate a box/rectangle centered at point x/y with width and height.\n\n\n\n"
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
    "text": "circle(x, y, r, action=:nothing)\n\nMake a circle of radius r centred at x/y.\n\naction is one of the actions applied by do_action, defaulting to :nothing. You can also use ellipse() to draw circles and place them by their centerpoint.\n\n\n\ncircle(pt, r, action)\n\nMake a circle centred at pt.\n\n\n\ncircle(pt1::Point, pt2::Point, action=:nothing)\n\nMake a circle that passes through two points that define the diameter:\n\n\n\n"
},

{
    "location": "basics.html#Luxor.ellipse",
    "page": "Basic graphics",
    "title": "Luxor.ellipse",
    "category": "Function",
    "text": "Make an ellipse, centered at xc/yc, fitting in a box of width w and height h.\n\nellipse(xc, yc, w, h, action=:none)\n\n\n\nMake an ellipse, centered at point c, with width w, and height h.\n\nellipse(cpt, w, h, action=:none)\n\n\n\nellipse(focus1::Point, focus2::Point, k, action=:none;\n         stepvalue=pi/100,\n         vertices=false,\n         reversepath=false)\n\nBuild a polygon approximation to an ellipse, given two points and a distance, k, which is the sum of the distances to the focii of any points on the ellipse (or the shortest length of string required to go from one focus to the perimeter and on to the other focus).\n\n\n\n"
},

{
    "location": "basics.html#Luxor.circlepath",
    "page": "Basic graphics",
    "title": "Luxor.circlepath",
    "category": "Function",
    "text": "circlepath(center::Point, radius, action=:none;\n    reversepath=false,\n    kappa = 0.5522847)\n\nDraw a circle using Bézier curves.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.sector",
    "page": "Basic graphics",
    "title": "Luxor.sector",
    "category": "Function",
    "text": "sector(centerpoint::Point, innerradius, outerradius, startangle, endangle, action:none)\n\nDraw an annular sector centered at centerpoint.\n\n\n\nDraw an annular sector centered at the origin.\n\n\n\nsector(centerpoint::Point, innerradius, outerradius, startangle, endangle, cornerradius, action:none)\n\nDraw an annular sector with rounded corners, basically a bent sausage shape, centered at centerpoint.\n\nTODO: The results aren't 100% accurate at the moment. There are small discontinuities where the curves join.\n\nThe cornerradius is reduced from the supplied value if neceesary to prevent overshoots.\n\n\n\nDraw an annular sector with rounded corners, centered at the current origin.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.pie",
    "page": "Basic graphics",
    "title": "Luxor.pie",
    "category": "Function",
    "text": "pie(x, y, radius, startangle, endangle, action=:none)\n\nDraw a pie shape centered at x/y. Angles start at the positive x-axis and are measured clockwise.\n\n\n\npie(centerpoint, radius, startangle, endangle, action=:none)\n\nDraw a pie shape centered at centerpoint.\n\nAngles start at the positive x-axis and are measured clockwise.\n\n\n\nDraw a pie shape centered at the origin\n\n\n\n"
},

{
    "location": "basics.html#Luxor.squircle",
    "page": "Basic graphics",
    "title": "Luxor.squircle",
    "category": "Function",
    "text": "Make a squircle (basically a rectangle with rounded corners). Specify the center position, horizontal radius (distance from center to a side), and vertical radius (distance from center to top or bottom):\n\nsquircle(center::Point, hradius, vradius, action=:none; rt = 0.5, vertices=false)\n\nThe rt option defaults to 0.5, and gives an intermediate shape. Values less than 0.5 make the shape more square. Values above make the shape more round.\n\n\n\n"
},

{
    "location": "basics.html#Circles,-ellipses,-and-other-curvey-things-1",
    "page": "Basic graphics",
    "title": "Circles, ellipses, and other curvey things",
    "category": "section",
    "text": "There are various ways to make circles, including by center and radius, or passing through two points:using Luxor # hide\nDrawing(400, 200, \"assets/figures/circles.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsetline(2) # hide\np1 = O\np2 = Point(100, 0)\nsethue(\"red\")\ncircle(p1, 40, :fill)\nsethue(\"green\")\ncircle(p1, p2, :stroke)\nsethue(\"black\")\narrow(O, Point(0, -40))\nmap(p -> circle(p, 4, :fill), [p1, p2])\nfinish() # hide\nnothing # hide(Image: circles)Or passing through three points. The center3pts() function returns the center position and radius of a circle passing through three points:using Luxor # hide\nDrawing(400, 200, \"assets/figures/center3.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsetline(3) # hide\nsethue(\"black\")\np1 = Point(0, -50)\np2 = Point(100, 0)\np3 = Point(0, 65)\nmap(p -> circle(p, 4, :fill), [p1, p2, p3])\nsethue(\"orange\") # hide\ncircle(center3pts(p1, p2, p3)..., :stroke)\nfinish() # hide\nnothing # hide(Image: center and radius of 3 points)With ellipse() you can place ellipses (and circles) by defining the center point and the width and height.using Luxor # hide\nDrawing(500, 300, \"assets/figures/ellipses.png\") # hide\nbackground(\"white\") # hide\nfontsize(11) # hide\nsrand(1) # hide\norigin() # hide\ntiles = Tiler(500, 300, 5, 5)\nwidth = 20\nheight = 25\nfor (pos, n) in tiles\n    randomhue()\n    ellipse(pos, width, height, :fill)\n    sethue(\"black\")\n    label = string(round(width/height, 2))\n    textcentered(label, pos.x, pos.y + 25)\n    width += 2\nend\nfinish() # hide\nnothing # hide(Image: ellipses)It's also possible to make polygons that are approximations to ellipses with two focal points and a distance.using Luxor # hide\nDrawing(500, 450, \"assets/figures/ellipses_1.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"gray30\") # hide\nsetline(1) # hide\nf1 = Point(-100, 0)\nf2 = Point(100, 0)\nellipsepoly = ellipse(f1, f2, 170, :none, vertices=true)\n[ begin\n    setgray(rescale(c, 150, 1, 0, 1))\n    poly(offsetpoly(ellipsepoly, c), close=true, :fill);\n    rotate(pi/20)\n  end\n     for c in 150:-10:1 ]\nfinish() # hide\nnothing # hide(Image: more ellipses)circle\nellipsecirclepath() constructs a circular path from Bèzier curves, which allows you to use circles as paths.using Luxor # hide\nDrawing(600, 250, \"assets/figures/circle-path.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"black\") # hide\nsetline(4)\ntiles = Tiler(600, 250, 1, 5)\nfor (pos, n) in tiles\n    randomhue()\n    circlepath(pos, tiles.tilewidth/2, :path)\n    newsubpath()\n    circlepath(pos, rand(5:tiles.tilewidth/2 - 1), :fill, reversepath=true)\nend\nfinish() # hide\nnothing # hide(Image: circles as paths)circlepathA sector (strictly an \"annular sector\") has an inner and outer radius, as well as start and end angles.using Luxor # hide\nDrawing(600, 200, \"assets/figures/sector.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"tomato\")\nsector(50, 90, pi/2, 0, :fill)\nsethue(\"olive\")\nsector(Point(O.x + 200, O.y), 50, 90, 0, pi/2, :fill)\nfinish() # hide\nnothing # hide(Image: sector)You can also supply a value for a corner radius. The same sector is drawn but with rounded corners.using Luxor # hide\nDrawing(600, 200, \"assets/figures/sectorrounded.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"tomato\")\nsector(50, 90, pi/2, 0, 15, :fill)\nsethue(\"olive\")\nsector(Point(O.x + 200, O.y), 50, 90, pi/2, 0, 15, :fill)\nfinish() # hide\nnothing # hide(Image: sector)sectorA pie (or wedge) has start and end angles.using Luxor # hide\nDrawing(400, 300, \"assets/figures/pie.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"magenta\") # hide\npie(0, 0, 100, pi/2, pi, :fill)\nfinish() # hide\nnothing # hide(Image: pie)pieA squircle is a cross between a square and a circle. You can adjust the squariness and circularity of it to taste by supplying a value for keyword rt:using Luxor # hide\nDrawing(600, 250, \"assets/figures/squircle.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nfontsize(20) # hide\nsetline(2)\ntiles = Tiler(600, 250, 1, 3)\nfor (pos, n) in tiles\n    sethue(\"lavender\")\n    squircle(pos, 80, 80, rt=[0.3, 0.5, 0.7][n], :fillpreserve)\n    sethue(\"grey20\")\n    strokepath()\n    textcentered(\"rt = $([0.3, 0.5, 0.7][n])\", pos)\nend\nfinish() # hide\nnothing # hide(Image: squircles)squircleOr for a simple rounded rectangle, smooth the corners of a box, like so:using Luxor # hide\nDrawing(600, 250, \"assets/figures/round-rect.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"black\") # hide\nsetline(4)\npolysmooth(box(O, 200, 150, vertices=true), 10, :stroke)\nfinish() # hide\nnothing # hide(Image: rounded rect)"
},

{
    "location": "basics.html#Luxor.move",
    "page": "Basic graphics",
    "title": "Luxor.move",
    "category": "Function",
    "text": "move(x, y)\nmove(pt)\n\nMove to a point.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.rmove",
    "page": "Basic graphics",
    "title": "Luxor.rmove",
    "category": "Function",
    "text": "rmove(x, y)\n\nMove by an amount from the current point. Move relative to current position by x and y:\n\nMove relative to current position by the pt's x and y:\n\nrmove(pt)\n\n\n\n"
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
    "location": "basics.html#Paths-and-positions-1",
    "page": "Basic graphics",
    "title": "Paths and positions",
    "category": "section",
    "text": "A path is a sequence of lines and curves. You can add lines and curves to the current path, then use closepath() to join the last point to the first.A path can have subpaths, created withnewsubpath(), which can form holes.There is a 'current position' which you can set with move(), and can use implicitly in functions like line(), text(), arc() and curve().move\nrmove\nnewpath\nnewsubpath\nclosepath"
},

{
    "location": "basics.html#Luxor.line",
    "page": "Basic graphics",
    "title": "Luxor.line",
    "category": "Function",
    "text": "line(x, y)\nline(x, y, :action)\nline(pt)\n\nCreate a line from the current position to the x/y position and optionally apply an action:\n\n\n\nline(pt1::Point, pt2::Point, action=:nothing)\n\nMake a line between two points, pt1 and pt2 and do an action.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.rline",
    "page": "Basic graphics",
    "title": "Luxor.rline",
    "category": "Function",
    "text": "rline(x, y)\nrline(x, y, :action)\nrline(pt)\n\nCreate a line relative to the current position to the x/y position and optionally apply an action:\n\n\n\n"
},

{
    "location": "basics.html#Luxor.rule",
    "page": "Basic graphics",
    "title": "Luxor.rule",
    "category": "Function",
    "text": "rule(pos::Point, theta=0.0)\n\nDraw a line across the entire drawing passing through pos, at an angle of theta to the x-axis. Returns the two points.\n\nTODO: I don't know how to calculate the end points exactly, so this just throws two points way outside the current drawing and hopes that it will stay outside.\n\n\n\n"
},

{
    "location": "basics.html#Lines-1",
    "page": "Basic graphics",
    "title": "Lines",
    "category": "section",
    "text": "Use line() and rline() to draw straight lines.line\nrlineYou can use rule() to draw a line across the entire drawing through a point, at an angle to the current x-axis.using Luxor # hide\nDrawing(700, 200, \"assets/figures/rule.png\") # hide\nbackground(\"white\") # hide\nsethue(\"black\") # hide\nsetline(1) # hide\n\ny = 10\nfor x in logspace(0, 2.75, 40)\n    circle(Point(x, y), 2, :fill)\n    rule(Point(x, y), -pi/2)\n    y += 2\nend\n\nfinish() # hide\nnothing # hide(Image: arc)rule"
},

{
    "location": "basics.html#Luxor.arc",
    "page": "Basic graphics",
    "title": "Luxor.arc",
    "category": "Function",
    "text": "Add an arc to the current path from angle1 to angle2 going clockwise.\n\narc(xc, yc, radius, angle1, angle2, action=:nothing)\n\nAngles are defined relative to the x-axis, positive clockwise.\n\n\n\nArc with centerpoint.\n\narc(centerpoint::Point, radius, angle1, angle2, action=:nothing)\n\n\n\n"
},

{
    "location": "basics.html#Luxor.arc2r",
    "page": "Basic graphics",
    "title": "Luxor.arc2r",
    "category": "Function",
    "text": "  arc2r(c1::Point, p2::Point, p3::Point, action=:nothing)\n\nMake a circular arc centered at c1 that starts at p2 and ends at p3, going clockwise.\n\nc1-p2 really determines the radius. If p3 doesn't lie on the circular path, it will be used only as an indication of the arc's length, rather than its position.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.carc",
    "page": "Basic graphics",
    "title": "Luxor.carc",
    "category": "Function",
    "text": "Add an arc to the current path from angle1 to angle2 going counterclockwise.\n\ncarc(xc, yc, radius, angle1, angle2, action=:nothing)\n\nAngles are defined relative to the x-axis, positive clockwise.\n\n\n\nAdd an arc centered at centerpoint to the current path from angle1 to angle2 going counterclockwise.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.carc2r",
    "page": "Basic graphics",
    "title": "Luxor.carc2r",
    "category": "Function",
    "text": "carc2r(c1::Point, p2::Point, p3::Point, action=:nothing)\n\nMake a circular arc centered at c1 that starts at p2 and ends at p3, going counterclockwise.\n\nc1-p2 really determines the radius. If p3 doesn't lie on the circular path, it will be used only as an indication of the arc's length, rather than its position.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.curve",
    "page": "Basic graphics",
    "title": "Luxor.curve",
    "category": "Function",
    "text": "Add a Bézier curve.\n\n curve(x1, y1, x2, y2, x3, y3)\n curve(p1, p2, p3)\n\nThe spline starts at the current position, finishing at x3/y3 (p3), following two  control points x1/y1 (p1) and x2/y2 (p2)\n\n\n\n"
},

{
    "location": "basics.html#Arcs-and-curves-1",
    "page": "Basic graphics",
    "title": "Arcs and curves",
    "category": "section",
    "text": "There are a few standard arc-drawing commands, such as curve(), arc(), carc(), and arc2r().curve() constructs Bèzier curves from control points:using Luxor # hide\nDrawing(500, 275, \"assets/figures/curve.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\n\nsetline(.5)\npt1 = Point(0, -125)\npt2 = Point(200, 125)\npt3 = Point(200, -125)\n\nsethue(\"red\")\nmap(p -> circle(p, 4, :fill), [O, pt1, pt2, pt3])\n\nline(O, pt1, :stroke)\nline(pt2, pt3, :stroke)\n\nsethue(\"black\")\nsetline(3)\n\nmove(O)\ncurve(pt1, pt2, pt3)\nstrokepath()\nfinish()  # hide\nnothing # hide(Image: curve)arc2r() draws a circular arc that joins two points:  using Luxor # hide\nDrawing(700, 200, \"assets/figures/arc2r.png\") # hide\norigin() # hide\nsrand(42) # hide\nbackground(\"white\") # hide\ntiles = Tiler(700, 200, 1, 6)\nfor (pos, n) in tiles\n    c1, pt2, pt3 = ngon(pos, rand(10:50), 3, rand(0:pi/12:2pi), vertices=true)\n    sethue(\"black\")\n    map(pt -> circle(pt, 4, :fill), [c1, pt3])\n    sethue(\"red\")\n    circle(pt2, 4, :fill)\n    randomhue()\n    arc2r(c1, pt2, pt3, :stroke)\nend\nfinish() # hide\nnothing # hide(Image: arc)arc\narc2r\ncarc\ncarc2r\ncurve"
},

{
    "location": "basics.html#Luxor.midpoint",
    "page": "Basic graphics",
    "title": "Luxor.midpoint",
    "category": "Function",
    "text": "midpoint(p1, p2)\n\nFind the midpoint between two points.\n\n\n\nmidpoint(a)\n\nFind midpoint between the first two elements of an array of points.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.between",
    "page": "Basic graphics",
    "title": "Luxor.between",
    "category": "Function",
    "text": "between(p1::Point, p2::Point, x)\nbetween((p1::Point, p2::Point), x)\n\nFind the point between point p1 and point p2 for x, where x is typically between 0 and 1, so these two should be equivalent:\n\nbetween(p1, p2, 0.5)\n\nand\n\nmidpoint(p1, p2)\n\n\n\n"
},

{
    "location": "basics.html#Luxor.center3pts",
    "page": "Basic graphics",
    "title": "Luxor.center3pts",
    "category": "Function",
    "text": "center3pts(a::Point, b::Point, c::Point)\n\nFind the radius and center point for three points lying on a circle.\n\nreturns (centerpoint, radius) of a circle. Then you can use circle() to place a circle, or arc() to draw an arc passing through those points.\n\nIf there's no such circle, then you'll see an error message in the console and the function returns (Point(0,0), 0).\n\n\n\n"
},

{
    "location": "basics.html#Luxor.intersection",
    "page": "Basic graphics",
    "title": "Luxor.intersection",
    "category": "Function",
    "text": "intersection(p1::Point, p2::Point, p3::Point, p4::Point)\n\nFind intersection of two lines p1-p2 and p3-p4\n\nThis returns a tuple: (boolean, point(x, y)).\n\nKeyword options and default values:\n\ncrossingonly = false\n\nreturns (true, Point(x, y)) if the lines intersect somewhere. If crossingonly = true, returns (false, intersectionpoint) if the lines don't cross, but would intersect at intersectionpoint if continued beyond their current endpoints.\n\ncommonendpoints = false\n\nIf commonendpoints= true, will return (false, Point(0, 0)) if the lines share a common end point (because that's not so much an intersection, more a meeting).\n\nFunction returns (false, Point(0, 0)) if the lines are undefined,\n\n\n\n"
},

{
    "location": "basics.html#Luxor.intersection_line_circle",
    "page": "Basic graphics",
    "title": "Luxor.intersection_line_circle",
    "category": "Function",
    "text": "intersection_line_circle(p1::Point, p2::Point, cpoint::Point, r)\n\nFind the intersection points of a line (extended through points p1 and p2) and a circle.\n\nReturn a tuple of (n, pt1, pt2)\n\nwhere\n\nn is the number of intersections, 0, 1, or 2\npt1 is first intersection point, or Point(0, 0) if none\npt2 is the second intersection point, or Point(0, 0) if none\n\nThe calculated intersection points wont necessarily lie on the line segment between p1 and p2.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.getnearestpointonline",
    "page": "Basic graphics",
    "title": "Luxor.getnearestpointonline",
    "category": "Function",
    "text": "getnearestpointonline(pt1::Point, pt2::Point, startpt::Point)\n\nGiven a line from pt1 to pt2, and startpt is the start of a perpendicular heading to meet the line, at what point does it hit the line?\n\n\n\n"
},

{
    "location": "basics.html#Luxor.pointlinedistance",
    "page": "Basic graphics",
    "title": "Luxor.pointlinedistance",
    "category": "Function",
    "text": "pointlinedistance(p::Point, a::Point, b::Point)\n\nFind the distance between a point p and a line between two points a and b.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.slope",
    "page": "Basic graphics",
    "title": "Luxor.slope",
    "category": "Function",
    "text": "slope(pointA::Point, pointB::Point)\n\nFind angle of a line starting at pointA and ending at pointB.\n\nReturn a value between 0 and 2pi. Value will be relative to the current axes.\n\nslope(O, Point(0, 100)) |> rad2deg # y is positive down the page\n90.0\n\nslope(Point(0, 100), O) |> rad2deg\n270.0\n\n\n\n"
},

{
    "location": "basics.html#Luxor.rescale",
    "page": "Basic graphics",
    "title": "Luxor.rescale",
    "category": "Function",
    "text": "rescale(x, from_min, from_max, to_min, to_max)\n\nConvert x from one linear scale (from_min to from_max) to another (to_min to to_max).\n\nThe scales can also be supplied in tuple form:\n\nrescale(x, (from_min, from_max), (to_min, to_max))\n\njulia> rescale(15, 0, 100, 0, 1)\n0.15\n\njulia> rescale(15, (0, 100), (0, 1))\n0.15\n\njulia> rescale(pi/20, 0, 2pi, 0, 1)\n0.025\n\njulia> rescale(pi/20, (0, 2pi), (0, 1))\n0.025\n\njulia> rescale(25, 0, 1, 0, 1.609344)\n40.2336\n\njulia> rescale(15, (0, 100), (1000, 0))\n850.0\n\n\n\n"
},

{
    "location": "basics.html#Luxor.perpendicular",
    "page": "Basic graphics",
    "title": "Luxor.perpendicular",
    "category": "Function",
    "text": "perpendicular(p::Point)\n\nReturns point Point(p.y, -p.x).\n\n\n\n"
},

{
    "location": "basics.html#Luxor.@polar",
    "page": "Basic graphics",
    "title": "Luxor.@polar",
    "category": "Macro",
    "text": "@polar (p)\n\nConvert a tuple of two numbers to a Point of x, y Cartesian coordinates.\n\n@polar (10, pi/4)\n@polar [10, pi/4]\n\nproduces\n\nLuxor.Point(7.0710678118654755,7.071067811865475)\n\n\n\n"
},

{
    "location": "basics.html#Luxor.polar",
    "page": "Basic graphics",
    "title": "Luxor.polar",
    "category": "Function",
    "text": "polar(r, theta)\n\nConvert point in polar form (radius and angle) to a Point.\n\npolar(10, pi/4)                                                                   09:19:38  v5   src\n\nproduces\n\nLuxor.Point(7.071067811865475,7.0710678118654755)\n\n\n\n"
},

{
    "location": "basics.html#Geometry-tools-1",
    "page": "Basic graphics",
    "title": "Geometry tools",
    "category": "section",
    "text": "You can find the midpoint between two points using midpoint().The following code places a small pentagon (using ngon()) at the midpoint of each side of a larger pentagon:using Luxor # hide\nDrawing(700, 220, \"assets/figures/midpoint.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"red\")\nngon(O, 100, 5, 0, :stroke)\n\nsethue(\"darkgreen\")\np5 = ngon(O, 100, 5, 0, vertices=true)\n\nfor i in eachindex(p5)\n    pt1 = p5[mod1(i, 5)]\n    pt2 = p5[mod1(i + 1, 5)]\n    ngon(midpoint(pt1, pt2), 20, 5, 0, :fill)\nend\nfinish() # hide\nnothing # hide(Image: arc)A more general function, between(), finds for a value x between 0 and 1 the corresponding point on a line defined by two points. So midpoint(p1, p2) and between(p1, p2, 0.5) should return the same point.using Luxor # hide\nDrawing(700, 150, \"assets/figures/betweenpoint.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"red\")\np1 = Point(-150, 0)\np2 = Point(150, 40)\nline(p1, p2)\nstrokepath()\nfor i in -0.5:0.1:1.5\n    randomhue()\n    circle(between(p1, p2, i), 5, :fill)\nend\nfinish() # hide\nnothing # hide(Image: arc)Values less than 0.0 and greater than 1.0 appear to work well too, placing the point on the line if extended.midpoint\nbetweencenter3pts() finds the radius and center point of a circle passing through three points which you can then use with functions such as circle() or arc2r().center3ptsintersection() finds the intersection of two lines.using Luxor # hide\nDrawing(700, 220, \"assets/figures/intersection.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"darkmagenta\") # hide\npt1, pt2, pt3, pt4 = ngon(O, 100, 5, vertices=true)\nline(pt1, pt2, :stroke)\nline(pt3, pt4, :stroke)\nflag, ip =  intersection(pt1, pt2, pt3, pt4)\nif flag\n    circle(ip, 5, :fill)\nend\nfinish() # hide\nnothing # hide(Image: arc)intersection_line_circle() finds the intersection of a line and a circle. There can be 0, 1, or 2 intersection points.using Luxor # hide\nDrawing(700, 220, \"assets/figures/intersection_line_circle.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"chocolate2\") # hide\nl1 = Point(-100.0, -75.0)\nl2 = Point(300.0, 100.0)\nrad = 100\ncpoint = Point(0, 0)\nline(l1, l2, :stroke)\nsethue(\"darkgreen\") # hide\ncircle(cpoint, rad, :stroke)\nnints, ip1, ip2 =  intersection_line_circle(l1, l2, cpoint, rad)\nsethue(\"black\")\nif nints == 2\n    circle(ip1, 8, :stroke)\n    circle(ip2, 8, :stroke)\nend\nfinish() # hide\nnothing # hide(Image: arc)intersection\nintersection_line_circlegetnearestpointonline() finds perpendiculars.using Luxor # hide\nDrawing(700, 200, \"assets/figures/perpendicular.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"darkmagenta\") # hide\nend1, end2, pt3 = ngon(O, 100, 3, vertices=true)\nmap(pt -> circle(pt, 5, :fill), [end1, end2, pt3])\nline(end1, end2, :stroke)\narrow(pt3, getnearestpointonline(end1, end2, pt3))\nfinish() # hide\nnothing # hide(Image: arc)getnearestpointonline\npointlinedistance\nslope\nrescale\nperpendicular\n@polar\npolar"
},

{
    "location": "basics.html#Luxor.arrow",
    "page": "Basic graphics",
    "title": "Luxor.arrow",
    "category": "Function",
    "text": "arrow(startpoint::Point, endpoint::Point;\n    linewidth = 1.0,\n    arrowheadlength = 10,\n    arrowheadangle = pi/8)\n\nDraw a line between two points and add an arrowhead at the end. The arrowhead length will be the length of the side of the arrow's head, and the arrowhead angle is the angle between the sloping side of the arrowhead and the arrow's shaft.\n\nArrows don't use the current linewidth setting (setline()), and defaults to 1, but you can specify another value. It doesn't need stroking/filling, the shaft is stroked and the head filled with the current color.\n\n\n\narrow(centerpos::Point, radius, startangle, endangle;\n    linewidth = 1.0,\n    arrowheadlength = 10,\n    arrowheadangle = pi/8)\n\nDraw a curved arrow, an arc centered at centerpos starting at startangle and ending at endangle with an arrowhead at the end. Angles are measured clockwise from the positive x-axis.\n\nArrows don't use the current linewidth setting (setline()); you can specify the linewidth.\n\n\n\n"
},

{
    "location": "basics.html#Arrows-1",
    "page": "Basic graphics",
    "title": "Arrows",
    "category": "section",
    "text": "You can draw lines or arcs with arrows at the end with arrow(). For straight arrows, supply the start and end points. For arrows as circular arcs, you provide center, radius, and start and finish angles. You can optionally provide dimensions for the arrowheadlength and arrowheadangle of the tip of the arrow (angle in radians between side and center). The default line weight is 1.0, equivalent to setline(1)), but you can specify another.using Luxor # hide\nDrawing(400, 250, \"assets/figures/arrow.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"steelblue4\") # hide\nsetline(2) # hide\narrow(O, Point(0, -65))\narrow(O, Point(100, -65), arrowheadlength=20, arrowheadangle=pi/4, linewidth=.3)\narrow(O, 100, pi, pi/2, arrowheadlength=25,   arrowheadangle=pi/12, linewidth=1.25)\nfinish() # hide\nnothing # hide(Image: arrows)arrow"
},

{
    "location": "basics.html#Luxor.julialogo",
    "page": "Basic graphics",
    "title": "Luxor.julialogo",
    "category": "Function",
    "text": "julialogo(;action=:fill, color=true)\n\nDraw the Julia logo. The default action is to fill the logo and use the colors:\n\njulialogo()\n\nIf color is false, the logo will use the current color, and the dots won't be colored in the usual way.\n\nThe logo's dimensions are about 330 wide and 240 high, and the 0/0 point is at the bottom left corner. To place the logo by locating its center, do this:\n\ngsave()\ntranslate(-165, -120)\njulialogo() # locate center at 0/0\ngrestore()\n\nTo use the logo as a clipping mask:\n\njulialogo(action=:clip)\n\n(In this case the color setting is automatically ignored.)\n\n\n\n"
},

{
    "location": "basics.html#Luxor.juliacircles",
    "page": "Basic graphics",
    "title": "Luxor.juliacircles",
    "category": "Function",
    "text": "juliacircles(radius=100)\n\nDraw the three Julia circles in color centered at the origin.\n\nThe distance of the centers of the circles from the origin is radius. The optional keyword arguments outercircleratio (default 0.75) and innercircleratio  (default 0.65) control the radius of the individual colored circles relative to the radius.  So you can get relatively smaller or larger circles by adjusting the ratios.\n\n\n\n"
},

{
    "location": "basics.html#Julia-graphics-1",
    "page": "Basic graphics",
    "title": "Julia graphics",
    "category": "section",
    "text": "A couple of functions in Luxor provide you with instant access to the Julia logo, and the three colored circles:using Luxor # hide\nDrawing(750, 250, \"assets/figures/julia-logo.png\")  # hide\nsrand(42) # hide\norigin()  # hide\nbackground(\"white\") # hide\n\nfor (pos, n) in Tiler(750, 250, 1, 2)\n    gsave()\n    translate(pos - Point(150, 100))\n    if n == 1\n        julialogo()\n    elseif n == 2\n        julialogo(action=:clip)\n        for i in 1:500\n            gsave()\n            translate(rand(0:400), rand(0:250))\n            juliacircles(10)\n            grestore()\n        end\n        clipreset()\n    end\n    grestore()\nend\nfinish() # hide\nnothing # hide(Image: get path)julialogo\njuliacircles"
},

{
    "location": "basics.html#Miscellaneous-1",
    "page": "Basic graphics",
    "title": "Miscellaneous",
    "category": "section",
    "text": ""
},

{
    "location": "basics.html#Luxor.hypotrochoid",
    "page": "Basic graphics",
    "title": "Luxor.hypotrochoid",
    "category": "Function",
    "text": "hypotrochoid(R, r, d, action=:none;\n        stepby=0.01,\n        period=0,\n        vertices=false)\n\nMake a hypotrochoid with short line segments. (Like a Spirograph.) The curve is traced by a point attached to a circle of radius r rolling around the inside  of a fixed circle of radius R, where the point is a distance d from  the center of the interior circle. Things get interesting if you supply non-integral values.\n\nSpecial cases include the hypocycloid, if d = r, and an ellipse, if R = 2r.\n\nstepby, the angular step value, controls the amount of detail, ie the smoothness of the polygon,\n\nIf period is not supplied, or 0, the lowest period is calculated for you.\n\nThe function can return a polygon (a list of points), or draw the points directly using the supplied action. If the points are drawn, the function returns a tuple showing how many points were drawn and what the period was (as a multiple of pi).\n\n\n\n"
},

{
    "location": "basics.html#Hypotrochoids-1",
    "page": "Basic graphics",
    "title": "Hypotrochoids",
    "category": "section",
    "text": "hypotrochoid() makes hypotrochoids. The result is a polygon. You can either draw it directly, or pass it on for further polygon fun, as here, which uses offsetpoly() to trace round it a few times.using Luxor # hide\nDrawing(500, 300, \"assets/figures/hypotrochoid.png\")  # hide\norigin()\nbackground(\"grey15\")\nsethue(\"antiquewhite\")\nsetline(1)\np = hypotrochoid(100, 25, 55, :stroke, stepby=0.01, vertices=true)\nfor i in 0:3:15\n    poly(offsetpoly(p, i), :stroke, close=true)\nend\nfinish() # hide\nnothing # hide(Image: hypotrochoid)hypotrochoid"
},

{
    "location": "basics.html#Luxor.GridRect",
    "page": "Basic graphics",
    "title": "Luxor.GridRect",
    "category": "Type",
    "text": "GridRect(startpoint, xspacing, yspacing, width, height)\n\nDefine a rectangular grid, to start at startpoint and proceed along the x-axis in steps of xspacing, then along the y-axis in steps of yspacing.\n\nGridRect(startpoint, xspacing=100.0, yspacing=100.0, width=1200.0, height=1200.0)\n\nFor a column, set the xspacing to 0:\n\ngrid = GridRect(O, 0, 40)\n\nTo get points from the grid, use nextgridpoint(g::Grid).\n\njulia> grid = GridRect(O, 0, 40);\njulia> nextgridpoint(grid)\nLuxor.Point(0.0,0.0)\n\njulia> nextgridpoint(grid)\nLuxor.Point(0.0,40.0)\n\nWhen you run out of grid points, you'll wrap round and start again.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.GridHex",
    "page": "Basic graphics",
    "title": "Luxor.GridHex",
    "category": "Type",
    "text": "GridHex(startpoint, radius, width=1200.0, height=1200.0)\n\nDefine a hexagonal grid, to start at startpoint and proceed along the x-axis and then along the y-axis, radius is the radius of a circle that encloses each hexagon. The distance in x between the centers of successive hexagons is:\n\nfracsqrt(3) radius2\n\nTo get the next point from the grid, use nextgridpoint(g::Grid).\n\nWhen you run out of grid points, you'll wrap round and start again.\n\n\n\n"
},

{
    "location": "basics.html#Luxor.nextgridpoint",
    "page": "Basic graphics",
    "title": "Luxor.nextgridpoint",
    "category": "Function",
    "text": "nextgridpoint(g::GridRect)\n\nReturns the next available (or even the first) grid point of a grid.\n\n\n\nnextgridpoint(g::GridHex)\n\nReturns the next available grid point of a hexagonal grid.\n\n\n\n"
},

{
    "location": "basics.html#Grids-1",
    "page": "Basic graphics",
    "title": "Grids",
    "category": "section",
    "text": "If you have to position items regularly, you might find a use for a grid. Luxor provides a simple grid utility. Grids are lazy: they'll supply the next point on the grid when you ask for it.Define a rectangular grid with GridRect, and a hexagonal grid with GridHex. Get the next grid point from a grid with nextgridpoint(grid).using Luxor # hide\nDrawing(700, 250, \"assets/figures/grids.png\")  # hide\nbackground(\"white\") # hide\nfontsize(14) # hide\ntranslate(50, 50) # hide\ngrid = GridRect(O, 40, 80, (10 - 1) * 40)\nfor i in 1:20\n    randomhue()\n    p = nextgridpoint(grid)\n    squircle(p, 20, 20, :fill)\n    sethue(\"white\")\n    text(string(i), p, halign=:center)\nend\nfinish() # hide\nnothing # hide(Image: grids)using Luxor # hide\nDrawing(700, 400, \"assets/figures/grid-hex.png\")  # hide\nbackground(\"white\") # hide\nfontsize(22) # hide\ntranslate(100, 100) # hide\nradius = 70\ngrid = GridHex(O, radius, 600)\n\narrow(O, Point(O.x + (sqrt(3) * radius)/2, 0))\n\nfor i in 1:15\n    randomhue()\n    p = nextgridpoint(grid)\n    ngon(p, radius-5, 6, pi/2, :fillstroke)\n    sethue(\"white\")\n    text(string(i), p, halign=:center)\nend\nfinish() # hide\nnothing # hide(Image: grids)GridRect\nGridHex\nnextgridpoint"
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
    "text": "sethue(\"black\")\nsethue(0.3,0.7,0.9)\nsetcolor(sethue(\"red\")..., .2)\n\nSet the color without changing opacity.\n\nsethue() is like setcolor(), but we sometimes want to change the current color without changing alpha/opacity. Using sethue() rather than setcolor() doesn't change the current alpha opacity.\n\n\n\nsethue(col::ColorTypes.Colorant)\n\nSet the color without changing the current alpha/opacity:\n\n\n\nsethue(0.3, 0.7, 0.9)\n\nSet the color's r, g, b values. Use setcolor(r,g,b,a) to set transparent colors.\n\n\n\n"
},

{
    "location": "colors-styles.html#Luxor.setcolor",
    "page": "Colors and styles",
    "title": "Luxor.setcolor",
    "category": "Function",
    "text": "setcolor(\"gold\")\nsetcolor(\"darkturquoise\")\n\nSet the current color to a named color. This use the definitions in Colors.jl to convert a string to RGBA eg setcolor(\"gold\") or \"green\", \"darkturquoise\", \"lavender\", etc. The list is at Colors.color_names.\n\nUse sethue() for changing colors without changing current opacity level.\n\nsethue() and setcolor() return the three or four values that were used:\n\njulia> setcolor(sethue(\"red\")..., .8)\n\n(1.0,0.0,0.0,0.8)\n\njulia> sethue(setcolor(\"red\")[1:3]...)\n\n(1.0,0.0,0.0)\n\n\n\nsetcolor(r, g, b)\nsetcolor(r, g, b, alpha)\nsetcolor(color)\nsetcolor(col::ColorTypes.Colorant)\nsetcolor(sethue(\"red\")..., .2)\n\nSet the current color.\n\nExamples:\n\nsetcolor(convert(Colors.HSV, Colors.RGB(0.5, 1, 1)))\nsetcolor(.2, .3, .4, .5)\nsetcolor(convert(Colors.HSV, Colors.RGB(0.5, 1, 1)))\n\nfor i in 1:15:360\n   setcolor(convert(Colors.RGB, Colors.HSV(i, 1, 1)))\n   ...\nend\n\n\n\n"
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
    "location": "colors-styles.html#Luxor.setblend",
    "page": "Colors and styles",
    "title": "Luxor.setblend",
    "category": "Function",
    "text": "setblend(blend)\n\nStart using the named blend for filling graphics.\n\nThis aligns the original coordinates of the blend definition with the current axes.\n\n\n\n"
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
    "location": "colors-styles.html#Color-and-opacity-1",
    "page": "Colors and styles",
    "title": "Color and opacity",
    "category": "section",
    "text": "For color definitions and conversions, you can use Colors.jl.setcolor() and sethue() apply a single solid or transparent color to shapes. setblend() applies a smooth transition between two or more colors.The difference between the setcolor() and sethue() functions is that sethue() is independent of alpha opacity, so you can change the hue without changing the current opacity value.Named colors, such as \"gold\", or \"lavender\", can be found in Colors.color_names. This code shows the first 625 colors.using Luxor, Colors # hide\nDrawing(800, 500, \"assets/figures/colors.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nfontsize(5) # hide\ncols = collect(Colors.color_names)\ntiles = Tiler(800, 500, 25, 25)\nfor (pos, n) in tiles\n    sethue(cols[n][1])\n    box(pos, tiles.tilewidth, tiles.tileheight, :fill)\n    clab = convert(Lab, parse(Colorant, cols[n][1]))\n    labelbrightness = 100 - clab.l\n    sethue(convert(RGB, Lab(labelbrightness, clab.b, clab.a)))\n    text(string(cols[n][1]), pos, halign=:center)\nend\nfinish() # hide\nnothing # hide(Image: line endings)Some fiddling with Lab colors adjusts the label color to make it stand out against the background.sethue\nsetcolor\nsetgray\nsetopacity\nsetblend\nrandomhue\nrandomcolor"
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
    "text": "addstop(b::Blend, offset, col)\naddstop(b::Blend, offset, (r, g, b, a))\naddstop(b::Blend, offset, string)\n\nAdd a color stop to a blend. The offset specifies the location along the blend's 'control vector', which varies between 0 (beginning of the blend) and 1 (end of the blend). For linear blends, the control vector is from the start point to the end point. For radial blends, the control vector is from any point on the start circle, to the corresponding point on the end circle.\n\nExample:\n\nblendredblue = blend(Point(0, 0), 0, Point(0, 0), 1)\naddstop(blendredblue, 0, setcolor(sethue(\"red\")..., .2))\naddstop(blendredblue, 1, setcolor(sethue(\"blue\")..., .2))\naddstop(blendredblue, 0.5, sethue(randomhue()...))\naddstop(blendredblue, 0.5, setcolor(randomcolor()...))\n\n\n\n"
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
    "text": "A polygon is an array of points. The points can be joined with straight lines."
},

{
    "location": "polygons.html#Luxor.ngon",
    "page": "Polygons",
    "title": "Luxor.ngon",
    "category": "Function",
    "text": "ngon(x, y, radius, sides=5, orientation=0, action=:nothing;\n    vertices=false, reversepath=false)\n\nFind the vertices of a regular n-sided polygon centred at x, y:\n\nngon() draws the shapes: if you just want the raw points, use keyword argument vertices=true, which returns the array of points instead. Compare:\n\nngon(0, 0, 4, 4, 0, vertices=true) # returns the polygon's points:\n\n    4-element Array{Luxor.Point,1}:\n    Luxor.Point(2.4492935982947064e-16,4.0)\n    Luxor.Point(-4.0,4.898587196589413e-16)\n    Luxor.Point(-7.347880794884119e-16,-4.0)\n    Luxor.Point(4.0,-9.797174393178826e-16)\n\nwhereas\n\nngon(0, 0, 4, 4, 0, :close) # draws a polygon\n\n\n\nngon(centerpos, radius, sides=5, orientation=0, action=:nothing;\n    vertices=false,\n    reversepath=false)\n\nDraw a regular polygon centred at point p:\n\n\n\n"
},

{
    "location": "polygons.html#Regular-polygons-(\"ngons\")-1",
    "page": "Polygons",
    "title": "Regular polygons (\"ngons\")",
    "category": "section",
    "text": "You can make regular polygons — from triangles, pentagons, hexagons, septagons, heptagons, octagons, nonagons, decagons, and on-and-on-agons — with ngon().(Image: n-gons)using Luxor, Colors\nDrawing(1200, 1400)\n\norigin()\ncols = diverging_palette(60, 120, 20) # hue 60 to hue 120\nbackground(cols[1])\nsetopacity(0.7)\nsetline(2)\n\nngon(0, 0, 500, 8, 0, :clip)\n\nfor y in -500:50:500\n    for x in -500:50:500\n        setcolor(cols[rand(1:20)])\n        ngon(x, y, rand(20:25), rand(3:12), 0, :fill)\n        setcolor(cols[rand(1:20)])\n        ngon(x, y, rand(10:20), rand(3:12), 0, :stroke)\n    end\nend\n\nfinish()\npreview()ngon"
},

{
    "location": "polygons.html#Luxor.star",
    "page": "Polygons",
    "title": "Luxor.star",
    "category": "Function",
    "text": "star(xcenter, ycenter, radius, npoints=5, ratio=0.5, orientation=0, action=:nothing;\n    vertices = false,\n    reversepath=false)\n\nMake a star.  ratio specifies the height of the smaller radius of the star relative to the larger.\n\nUse vertices=true to return the vertices of a star instead of drawing it.\n\n\n\nstar(center, radius, npoints=5, ratio=0.5, orientation=0, action=:nothing;\n    vertices = false, reversepath=false)\n\nDraw a star centered at a position:\n\n\n\n"
},

{
    "location": "polygons.html#Stars-1",
    "page": "Polygons",
    "title": "Stars",
    "category": "section",
    "text": "Use star() to make a star. You can draw it immediately, or use the points it can create.using Luxor # hide\nDrawing(500, 300, \"assets/figures/stars.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\ntiles = Tiler(400, 300, 4, 6, margin=5)\nfor (pos, n) in tiles\n    randomhue()\n    star(pos, tiles.tilewidth/3, rand(3:8), 0.5, 0, :fill)\nend\nfinish() # hide\nnothing # hide(Image: stars)The ratio determines the length of the inner radius compared with the outer.using Luxor # hide\nDrawing(500, 250, \"assets/figures/star-ratios.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"black\") # hide\nsetline(2) # hide\ntiles = Tiler(500, 250, 1, 6, margin=10)\nfor (pos, n) in tiles\n    star(pos, tiles.tilewidth/2, 5, rescale(n, 1, 6, 1, 0), 0, :stroke)\nend\nfinish() # hide\nnothing # hide(Image: stars)star"
},

{
    "location": "polygons.html#Luxor.poly",
    "page": "Polygons",
    "title": "Luxor.poly",
    "category": "Function",
    "text": "Draw a polygon.\n\npoly(pointlist::Array, action = :nothing;\n    close=false,\n    reversepath=false)\n\nA polygon is an Array of Points. By default poly() doesn't close or fill the polygon, to allow for clipping.\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.prettypoly",
    "page": "Polygons",
    "title": "Luxor.prettypoly",
    "category": "Function",
    "text": "prettypoly(points, action=:nothing, vertexfunction = () -> circle(O, 2, :stroke);\n    close=false,\n    reversepath=false,\n    vertexlabels = (n, l) -> ()\n    )\n\nDraw the polygon defined by points, possibly closing and reversing it, using the current parameters, and then evaluate the vertexfunction function at every vertex of the polygon.\n\nThe default vertexfunction draws a 2 pt radius circle.\n\nTo mark each vertex of a polygon with a randomly colored filled circle:\n\np = star(O, 70, 7, 0.6, 0, vertices=true)\nprettypoly(p, :fill, () ->\n    begin\n        randomhue()\n        circle(O, 10, :fill)\n    end,\n    close=true)\n\nThe optional keyword argument vertexlabels lets you supply a function with two arguments that can access the current vertex number and the total number of vertices at each vertex. For example, you can label the vertices of a triangle \"1 of 3\", \"2 of 3\", and \"3 of 3\" using:\n\nprettypoly(triangle, :stroke,\n    vertexlabels = (n, l) -> (text(string(n, \" of \", l))))\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.simplify",
    "page": "Polygons",
    "title": "Luxor.simplify",
    "category": "Function",
    "text": "Simplify a polygon:\n\nsimplify(pointlist::Array, detail=0.1)\n\ndetail is the smallest permitted distance between two points in pixels.\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.isinside",
    "page": "Polygons",
    "title": "Luxor.isinside",
    "category": "Function",
    "text": "isinside(p, pol)\n\nIs a point p inside a polygon pol? Returns true or false.\n\nThis is an implementation of the Hormann-Agathos (2001) Point in Polygon algorithm\n\n\n\n"
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
    "text": "polysplit(p, p1, p2)\n\nSplit a polygon into two where it intersects with a line. It returns two polygons:\n\n(poly1, poly2)\n\nThis doesn't always work, of course. For example, a polygon the shape of the letter \"E\" might end up being divided into more than two parts.\n\n\n\n"
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
    "text": "Use poly() to draw lines connecting the points or just fill the area:using Luxor # hide\nDrawing(600, 250, \"assets/figures/simplepoly.png\") # hide\nbackground(\"white\") # hide\nsrand(42) # hide\norigin() # hide\nsethue(\"orchid4\") # hide\ntiles = Tiler(600, 250, 1, 2, margin=20)\ntile1, tile2 = collect(tiles)\n\nrandompoints = [Point(rand(-100:100), rand(-100:100)) for i in 1:10]\n\ngsave()\ntranslate(tile1[1])\npoly(randompoints, :stroke)\ngrestore()\n\ngsave()\ntranslate(tile2[1])\npoly(randompoints, :fill)\ngrestore()\n\nfinish() # hide\nnothing # hide(Image: simple poly)polyA polygon can contain holes. The reversepath keyword changes the direction of the polygon. The following piece of code uses ngon() to make and draw two paths, the second forming a hole in the first, to make a hexagonal bolt shape:using Luxor # hide\nDrawing(400, 250, \"assets/figures/holes.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsetline(5)\nsethue(\"gold\")\nline(Point(-200, 0), Point(200, 0), :stroke)\nsethue(\"orchid4\")\nngon(0, 0, 60, 6, 0, :path)\nnewsubpath()\nngon(0, 0, 40, 6, 0, :path, reversepath=true)\nfillstroke()\nfinish() # hide\nnothing # hide(Image: holes)The prettypoly() function can place graphics at each vertex of a polygon. After the polygon action, the supplied vertexfunction function is evaluated at each vertex. For example, to mark each vertex of a polygon with a randomly-colored circle:using Luxor # hide\nDrawing(400, 250, \"assets/figures/prettypolybasic.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"steelblue4\") # hide\n\napoly = star(O, 70, 7, 0.6, 0, vertices=true)\nprettypoly(apoly, :fill, () ->\n        begin\n            randomhue()\n            circle(O, 10, :fill)\n        end,\n    close=true)\nfinish() # hide\nnothing # hide(Image: prettypoly)An optional keyword argument vertexlabels lets you pass a function that can number each vertex. The function can use two arguments, the current vertex number, and the total number of points in the polygon:using Luxor # hide\nDrawing(400, 250, \"assets/figures/prettypolyvertex.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"steelblue4\") # hide\n\napoly = star(O, 80, 5, 0.6, 0, vertices=true)\nprettypoly(apoly,\n    :stroke,  \n    vertexlabels = (n, l) -> (text(string(n, \" of \", l), halign=:center)),\n    close=true)\nfinish() # hide\nnothing # hide(Image: prettypoly)prettypolyRecursive decoration is possible:using Luxor # hide\nDrawing(400, 260, \"assets/figures/prettypolyrecursive.png\") # hide\nbackground(\"white\") # hide\nsrand(42) # hide\norigin() # hide\nsethue(\"magenta\") # hide\nsetopacity(0.5) # hide\n\ndecorate(pos, p, level) = begin\n    if level < 4\n        randomhue();\n        scale(0.25, 0.25)\n        prettypoly(p, :fill, () -> decorate(pos, p, level+1), close=true)\n    end\nend\n\napoly = star(O, 100, 7, 0.6, 0, vertices=true)\nprettypoly(apoly, :fill, () -> decorate(O, apoly, 1), close=true)\nfinish() # hide\nnothing # hide(Image: prettypoly)Polygons can be simplified using the Douglas-Peucker algorithm (non-recursive version), via simplify().using Luxor # hide\nDrawing(600, 500, \"assets/figures/simplify.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsethue(\"black\") # hide\nsetline(1) # hide\nfontsize(20) # hide\ntranslate(0, -120) # hide\nsincurve = [Point(6x, 80sin(x)) for x in -5pi:pi/20:5pi]\nprettypoly(collect(sincurve), :stroke,\n    () -> begin\n            sethue(\"red\")\n            circle(O, 3, :fill)\n          end)\ntext(string(\"number of points: \", length(collect(sincurve))), 0, 100)\ntranslate(0, 200)\nsimplercurve = simplify(collect(sincurve), 0.5)\nprettypoly(simplercurve, :stroke,     \n    () -> begin\n            sethue(\"red\")\n            circle(O, 3, :fill)\n          end)\ntext(string(\"number of points: \", length(simplercurve)), 0, 100)\nfinish() # hide\nnothing # hide(Image: simplify)simplifyThe isinside() function returns true if a point is inside a polygon.using Luxor # hide\nDrawing(600, 250, \"assets/figures/isinside.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nsetline(0.5)\napolygon = star(O, 100, 5, 0.5, 0, vertices=true)\nfor n in 1:10000\n    apoint = randompoint(Point(-200, -150), Point(200, 150))\n    randomhue()\n    isinside(apoint, apolygon) ? circle(apoint, 3, :fill) : circle(apoint, .5, :stroke)\nend\nfinish() # hide\nnothing # hide(Image: isinside)isinsideYou can use randompoint() and randompointarray() to create a random Point or list of Points.using Luxor # hide\nDrawing(400, 250, \"assets/figures/randompoints.png\") # hide\nbackground(\"white\") # hide\nsrand(42) # hide\norigin() # hide\n\npt1 = Point(-100, -100)\npt2 = Point(100, 100)\n\nsethue(\"gray80\")\nmap(pt -> circle(pt, 6, :fill), (pt1, pt2))\nbox(pt1, pt2, :stroke)\n\nsethue(\"red\")\ncircle(randompoint(pt1, pt2), 7, :fill)\n\nsethue(\"blue\")\nmap(pt -> circle(pt, 2, :fill), randompointarray(pt1, pt2, 100))\n\nfinish() # hide\nnothing # hide(Image: isinside)randompoint\nrandompointarrayThere are some experimental polygon functions. These don't work well for polygons that aren't simple or where the sides intersect each other, but they sometimes do a reasonable job. For example, here's polysplit():using Luxor # hide\nDrawing(400, 150, \"assets/figures/polysplit.png\") # hide\norigin() # hide\nsetopacity(0.7) # hide\nsrand(42) # hide\nsethue(\"black\") # hide\ns = squircle(O, 60, 60, vertices=true)\npt1 = Point(0, -120)\npt2 = Point(0, 120)\nline(pt1, pt2, :stroke)\npoly1, poly2 = polysplit(s, pt1, pt2)\nrandomhue()\npoly(poly1, :fill)\nrandomhue()\npoly(poly2, :fill)\nfinish() # hide\nnothing # hide(Image: polysplit)polysplit\npolysortbydistance\npolysortbyangle\npolycentroid"
},

{
    "location": "polygons.html#Luxor.polysmooth",
    "page": "Polygons",
    "title": "Luxor.polysmooth",
    "category": "Function",
    "text": "polysmooth(points, radius, action=:action; debug=false)\n\nMake a closed path from the points and round the corners by making them arcs with the given radius. Execute the action when finished.\n\nThe arcs are sometimes different sizes: if the given radius is bigger than the length of the shortest side, the arc can't be drawn at its full radius and is therefore drawn as large as possible (as large as the shortest side allows).\n\nThe debug option also draws the construction circles at each corner.\n\n\n\n"
},

{
    "location": "polygons.html#Smoothing-polygons-1",
    "page": "Polygons",
    "title": "Smoothing polygons",
    "category": "section",
    "text": "Because polygons can have sharp corners, the experimental polysmooth() function attempts to insert arcs at the corners and draw the result.The original polygon is shown in red; the smoothed polygon is shown on top:using Luxor # hide\nDrawing(600, 250, \"assets/figures/polysmooth.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsetopacity(0.5) # hide\nsrand(42) # hide\nsetline(0.7) # hide\ntiles = Tiler(600, 250, 1, 5, margin=10)\nfor (pos, n) in tiles\n    p = star(pos, tiles.tilewidth/2 - 2, 5, 0.3, 0, vertices=true)\n    setdash(\"dot\")\n    sethue(\"red\")\n    prettypoly(p, close=true, :stroke)\n    setdash(\"solid\")\n    sethue(\"black\")\n    polysmooth(p, n * 2, :fill)\nend\n\nfinish() # hide\nnothing # hide(Image: polysmooth)The final polygon shows that you can get unexpected results if you attempt to smooth corners by more than the possible amount. The debug=true option draws the circles if you want to find out what's going wrong, or if you want to explore the effect in more detail.using Luxor # hide\nDrawing(600, 250, \"assets/figures/polysmooth-pathological.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsetopacity(0.75) # hide\nsrand(42) # hide\nsetline(1) # hide\np = star(O, 60, 5, 0.35, 0, vertices=true)\nsetdash(\"dot\")\nsethue(\"red\")\nprettypoly(p, close=true, :stroke)\nsetdash(\"solid\")\nsethue(\"black\")\npolysmooth(p, 40, :fill, debug=true)\nfinish() # hide\nnothing # hide(Image: polysmooth)polysmooth"
},

{
    "location": "polygons.html#Luxor.offsetpoly",
    "page": "Polygons",
    "title": "Luxor.offsetpoly",
    "category": "Function",
    "text": "offsetpoly(path::Array, d)\n\nReturn a polygon that is offset from a polygon by d units.\n\nThe incoming set of points path is treated as a polygon, and another set of points is created, which form a polygon lying d units away from the source poly.\n\nPolygon offsetting is a topic on which people have written PhD theses and published academic papers, so this short brain-dead routine will give good results for simple polygons up to a point (!). There are a number of issues to be aware of:\n\nvery short lines tend to make the algorithm 'flip' and produce larger lines\nsmall polygons that are counterclockwise and larger offsets may make the new polygon appear the wrong side of the original\nvery sharp vertices will produce even sharper offsets, as the calculated intersection point veers off to infinity\nduplicated adjacent points might cause the routine to scratch its head and wonder how to draw a line parallel to them\n\n\n\n"
},

{
    "location": "polygons.html#Offsetting-polygons-1",
    "page": "Polygons",
    "title": "Offsetting polygons",
    "category": "section",
    "text": "The experimental offsetpoly() function constructs an outline polygon outside or inside an existing polygon. In the following example, the dotted red polygon is the original, the black polygons have positive offsets and surround the original, the cyan polygons have negative offsets and run inside the original. Use poly() to draw the result returned by offsetpoly().using Luxor # hide\nDrawing(600, 250, \"assets/figures/polyoffset-simple.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsrand(42) # hide\nsetline(1.5) # hide\n\np = star(O, 45, 5, 0.5, 0, vertices=true)\nsethue(\"red\")\nsetdash(\"dot\")\npoly(p, :stroke, close=true)\nsetdash(\"solid\")\nsethue(\"black\")\n\npoly(offsetpoly(p, 20), :stroke, close=true)\npoly(offsetpoly(p, 25), :stroke, close=true)\npoly(offsetpoly(p, 30), :stroke, close=true)\npoly(offsetpoly(p, 35), :stroke, close=true)\n\nsethue(\"darkcyan\")\n\npoly(offsetpoly(p, -10), :stroke, close=true)\npoly(offsetpoly(p, -15), :stroke, close=true)\npoly(offsetpoly(p, -20), :stroke, close=true)\nfinish() # hide\nnothing # hide(Image: offset poly)The function is intended for simple cases, and it can go wrong if pushed too far. Sometimes the offset distances can be larger than the polygon segments, and things will start to go wrong. In this example, the offset goes so far negative that the polygon overshoots the origin, becomes inverted and starts getting larger again.(Image: offset poly problem)offsetpoly"
},

{
    "location": "polygons.html#Luxor.polyfit",
    "page": "Polygons",
    "title": "Luxor.polyfit",
    "category": "Function",
    "text": "polyfit(plist::Array, npoints=30)\n\nBuild a polygon that constructs a B-spine approximation to it. The resulting list of points makes a smooth path that runs between the first and last points.\n\n\n\n"
},

{
    "location": "polygons.html#Fitting-splines-1",
    "page": "Polygons",
    "title": "Fitting splines",
    "category": "section",
    "text": "The experimental polyfit() function constructs a B-spline that follows the points approximately.using Luxor # hide\nDrawing(600, 250, \"assets/figures/polyfit.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsrand(42) # hide\n\npts = [Point(x, rand(-100:100)) for x in -280:30:280]\nsetopacity(0.7)\nsethue(\"red\")\nprettypoly(pts, :none, () -> circle(O, 5, :fill))\nsethue(\"darkmagenta\")\npoly(polyfit(pts, 200), :stroke)\n\nfinish() # hide\nnothing # hide(Image: offset poly)polyfit"
},

{
    "location": "polygons.html#Luxor.pathtopoly",
    "page": "Polygons",
    "title": "Luxor.pathtopoly",
    "category": "Function",
    "text": "pathtopoly()\n\nConvert the current path to an array of polygons.\n\nReturns an array of polygons.\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.getpath",
    "page": "Polygons",
    "title": "Luxor.getpath",
    "category": "Function",
    "text": "getpath()\n\nGet the current path and return a CairoPath object, which is an array of element_type and points objects. With the results you can step through and examine each entry:\n\no = getpath()\nfor e in o\n      if e.element_type == Cairo.CAIRO_PATH_MOVE_TO\n          (x, y) = e.points\n          move(x, y)\n      elseif e.element_type == Cairo.CAIRO_PATH_LINE_TO\n          (x, y) = e.points\n          # straight lines\n          line(x, y)\n          strokepath()\n          circle(x, y, 1, :stroke)\n      elseif e.element_type == Cairo.CAIRO_PATH_CURVE_TO\n          (x1, y1, x2, y2, x3, y3) = e.points\n          # Bezier control lines\n          circle(x1, y1, 1, :stroke)\n          circle(x2, y2, 1, :stroke)\n          circle(x3, y3, 1, :stroke)\n          move(x, y)\n          curve(x1, y1, x2, y2, x3, y3)\n          strokepath()\n          (x, y) = (x3, y3) # update current point\n      elseif e.element_type == Cairo.CAIRO_PATH_CLOSE_PATH\n          closepath()\n      else\n          error(\"unknown CairoPathEntry \" * repr(e.element_type))\n          error(\"unknown CairoPathEntry \" * repr(e.points))\n      end\n  end\n\n\n\n"
},

{
    "location": "polygons.html#Luxor.getpathflat",
    "page": "Polygons",
    "title": "Luxor.getpathflat",
    "category": "Function",
    "text": "getpathflat()\n\nGet the current path, like getpath() but flattened so that there are no Bèzier curves.\n\nReturns a CairoPath which is an array of element_type and points objects.\n\n\n\n"
},

{
    "location": "polygons.html#Converting-paths-to-polygons-1",
    "page": "Polygons",
    "title": "Converting paths to polygons",
    "category": "section",
    "text": "You can convert the current path to an array of polygons, using pathtopoly().In the next example, the path consists of a number of paths, some of which are subpaths, which form the holes.using Luxor # hide\nDrawing(800, 300, \"assets/figures/path-to-poly.png\") # hide\nbackground(\"white\") # hide\norigin() # hide\nfontsize(60) # hide\ntranslate(-300, -50) # hide\ntextpath(\"get polygons from paths\")\nplist = pathtopoly()\nsetline(0.5) # hide\nfor (n, pgon) in enumerate(plist)\n    randomhue()\n    prettypoly(pgon, :stroke, close=true)\n    gsave()\n    translate(0, 100)\n    poly(polysortbyangle(pgon, polycentroid(pgon)), :stroke, close=true)\n    grestore()\nend\nfinish() # hide\nnothing # hide(Image: path to polygon)The pathtopoly() function calls getpathflat() to convert the current path to an array of polygons, with each curved section flattened to line segments.The getpath() function gets the current path as an array of elements, lines, and unflattened curves.pathtopoly\ngetpath\ngetpathflat"
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
    "text": "Use:text(string, [position]) to place text at a position, otherwise at 0/0, and optionally specify the horizontal and vertical alignment\nfontface(fontname) to specify the fontname\nfontsize(fontsize) to specify the fontsize in pointsusing Luxor # hide\nDrawing(600, 100, \"assets/figures/toy-text-example.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"black\") # hide\nfontsize(18)\nfontface(\"Georgia-Bold\")\ntext(\"Georgia is a serif typeface designed in 1993 by Matthew Carter.\", halign=:center)\nfinish() # hide\nnothing # hide(Image: text placement)"
},

{
    "location": "text.html#The-Pro-API-1",
    "page": "Text",
    "title": "The Pro API",
    "category": "section",
    "text": "Use:setfont(fontname, fontsize) to specify the fontname and size in points\nsettext(text, [position]) to place the text at a position, and optionally specify horizontal and vertical alignment, rotation (in degrees counterclockwise), and the presence of any Pango-flavored markup.using Luxor # hide\nDrawing(600, 100, \"assets/figures/pro-text-example.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nsethue(\"black\") # hide\nsetfont(\"Georgia Bold\", 18)\nsettext(\"Georgia is a serif typeface designed in 1993 by Matthew Carter.\", halign=\"center\")\nfinish() # hide\nnothing # hide(Image: text placement)"
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
    "text": "text(str)\ntext(str, pos)\ntext(str, x, y)\ntext(str, pos, halign=:left)\ntext(str, valign=:baseline)\ntext(str, valign=:baseline, halign=:left)\ntext(str, pos, valign=:baseline, halign=:left)\n\nDraw the text in the string str at x/y or pt, placing the start of the string at the point. If you omit the point, it's placed at the current 0/0. In Luxor, placing text doesn't affect the current point.\n\nHorizontal alignment halign can be :left, :center, or :right. Vertical alignment valign can be :baseline, :top, :middle, or :bottom.\n\nThe default alignment is :left, :baseline.\n\n\n\n"
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
    "location": "text.html#Luxor.textcurve",
    "page": "Text",
    "title": "Luxor.textcurve",
    "category": "Function",
    "text": "Place a string of text on a curve. It can spiral in or out.\n\ntextcurve(the_text, start_angle, start_radius, x_pos = 0, y_pos = 0;\n          # optional keyword arguments:\n          spiral_ring_step = 0,    # step out or in by this amount\n          letter_spacing = 0,      # tracking/space between chars, tighter is (-), looser is (+)\n          spiral_in_out_shift = 0, # + values go outwards, - values spiral inwards\n          clockwise = true\n          )\n\nstart_angle is relative to +ve x-axis, arc/circle is centred on (x_pos,y_pos) with radius start_radius.\n\n\n\n"
},

{
    "location": "text.html#Luxor.textcurvecentered",
    "page": "Text",
    "title": "Luxor.textcurvecentered",
    "category": "Function",
    "text": "textcurvecentered(the_text, the_angle, the_radius, center::Point;\n      clockwise = true,\n      letter_spacing = 0,\n      baselineshift = 0\n\nThis version of the textcurve() function is designed for shorter text strings that need positioning around a circle. (A cheesy effect much beloved of hipster brands and retronauts.)\n\nletter_spacing adjusts the tracking/space between chars, tighter is (-), looser is (+)). baselineshift moves the text up or down away from the baseline.\n\n\n\n"
},

{
    "location": "text.html#Text-on-a-curve-1",
    "page": "Text",
    "title": "Text on a curve",
    "category": "section",
    "text": "Use textcurve(str) to draw a string str on a circular arc or spiral.(Image: text on a curve or spiral)using Luxor\nDrawing(1800, 1800, \"/tmp/text-spiral.png\")\norigin()\nbackground(\"ivory\")\nfontsize(18)\nfontface(\"LucidaSansUnicode\")\nsethue(\"royalblue4\")\ntextstring = join(names(Base), \" \")\ntextcurve(\"this spiral contains every word in julia names(Base): \" * textstring,\n    -pi/2,\n    800, 0, 0,\n    spiral_in_out_shift = -18.0,\n    letter_spacing = 0,\n    spiral_ring_step = 0)\nfontsize(35)\nfontface(\"Agenda-Black\")\ntextcentred(\"julia names(Base)\", 0, 0)\nfinish()\npreview()For shorter strings, textcurvecentered() tries to place the text on a circular arc by its center point.using Luxor # hide\nDrawing(400, 250, \"assets/figures/text-centered.png\") # hide\norigin() # hide\nbackground(\"white\") # hide\nbackground(\"white\") # hide\nfontface(\"Arial-Black\")\nfontsize(24) # hide\nsethue(\"black\") # hide\nsetdash(\"dot\") # hide\nsetline(0.25) # hide\ncircle(O, 100, :stroke)\ntextcurvecentered(\"hello world\", -pi/2, 100, O;\n    clockwise = true,\n    letter_spacing = 0,\n    baselineshift = -20\n    )\ntextcurvecentered(\"hello world\", pi/2, 100, O;\n    clockwise = false,\n    letter_spacing = 0,\n    baselineshift = 10\n    )\nfinish() # hide\nnothing # hide(Image: text centered on curve)textcurve\ntextcurvecentered"
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
    "text": "scale(x, y)\n\nScale workspace by x and y.\n\nExample:\n\nscale(0.2, 0.3)\n\n\n\n"
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
    "text": "For basic transformations of the drawing space, use scale(sx, sy), rotate(a), and translate(tx, ty).translate() shifts the current axes by the specified amounts in x and y. It's relative and cumulative, rather than absolute:using Luxor, Colors # hide\nDrawing(600, 200, \"assets/figures/translate.png\") # hide\nbackground(\"white\") # hide\nsrand(1) # hide\nsetline(1) # hide\norigin()\nfor i in range(0, 30, 6)\n    sethue(HSV(i, 1, 1)) # from Colors\n    setopacity(0.5)\n    circle(0, 0, 40, :fillpreserve)\n    setcolor(\"black\")\n    strokepath()\n    translate(50, 0)\nend\nfinish() # hide\nnothing # hide(Image: translate)scale() scales the current workspace by the specified amounts in x and y. Again, it's relative to the current scale, not to the document's original.using Luxor, Colors # hide\nDrawing(400, 200, \"assets/figures/scale.png\") # hide\nbackground(\"white\") # hide\nsrand(1) # hide\nsetline(1) # hide\norigin()\nfor i in range(0, 30, 6)\n    sethue(HSV(i, 1, 1)) # from Colors\n    circle(0, 0, 90, :fillpreserve)\n    setcolor(\"black\")\n    strokepath()\n    scale(0.8, 0.8)\nend\nfinish() # hide\nnothing # hide(Image: scale)rotate() rotates the current workspace by the specifed amount about the current 0/0 point. It's relative to the previous rotation, not to the document's original.using Luxor # hide\nDrawing(400, 200, \"assets/figures/rotate.png\") # hide\nbackground(\"white\") # hide\nsrand(1) # hide\nsetline(1) # hide\norigin()\nsetopacity(0.7) # hide\nfor i in 1:8\n    randomhue()\n    squircle(Point(40, 0), 20, 30, :fillpreserve)\n    sethue(\"black\")\n    strokepath()\n    rotate(pi/4)\nend\nfinish() # hide\nnothing # hide(Image: rotate)scale\nrotate\ntranslateTo return home after many changes, you can use setmatrix([1, 0, 0, 1, 0, 0]) to reset the matrix to the default. origin() resets the matrix then moves the origin to the center of the page."
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
    "text": "setmatrix(m::Array)\n\nChange the current matrix to matrix m. Use getmatrix() to get the current matrix.\n\n\n\n"
},

{
    "location": "transforms.html#Luxor.transform",
    "page": "Transforms and matrices",
    "title": "Luxor.transform",
    "category": "Function",
    "text": "transform(a::Array)\n\nModify the current matrix by multiplying it by matrix a.\n\nFor example, to skew the current state by 45 degrees in x and move by 20 in y direction:\n\ntransform([1, 0, tand(45), 1, 0, 20])\n\nUse getmatrix() to get the current matrix.\n\n\n\n"
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
    "text": "In Luxor, there's always a current matrix. It's a six element array:beginbmatrix\n1  0  0 \n0  1  0 \nendbmatrixwhich is usually handled in Julia/Cairo/Luxor as a simple vector/array:julia> getmatrix()\n6-element Array{Float64,1}:\n   1.0\n   0.0\n   0.0\n   1.0\n   0.0\n   0.0transform(a) transforms the current workspace by 'multiplying' the current matrix with matrix a. For example, transform([1, 0, xskew, 1, 50, 0]) skews the current matrix by xskew radians and moves it 50 in x and 0 in y.using Luxor # hide\nfname = \"assets/figures/transform.png\" # hide\npagewidth, pageheight = 450, 100 # hide\nDrawing(pagewidth, pageheight, fname) # hide\norigin() # hide\nbackground(\"white\") # hide\ntranslate(-200, 0) # hide\n\nfunction boxtext(p, t)\n    sethue(\"grey30\")\n    box(p, 30, 50, :fill)\n    sethue(\"white\")\n    textcentred(t, p)\nend\n\nfor i in 0:5\n    xskew = tand(i * 5.0)\n    transform([1, 0, xskew, 1, 50, 0])\n    boxtext(O, string(round(rad2deg(xskew), 1), \"°\"))\nend\n\nfinish() # hide\nnothing # hide(Image: transform)getmatrix() gets the current matrix, setmatrix(a) sets the matrix to array a.getmatrix\nsetmatrix\ntransform\ncrossproduct\nblendmatrix\nrotationmatrix\nscalingmatrix\ntranslationmatrixUse the getscale(), gettranslation(), and getrotation() functions to find the current values of the current matrix. These can also find the values of arbitrary 3x3 matrices.getscale\ngettranslation\ngetrotationYou can convert between the 6-element and 3x3 versions of a transformation matrix using the functions cairotojuliamatrix() and juliatocairomatrix().cairotojuliamatrix\njuliatocairomatrix"
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
    "text": "placeimage(img, xpos, ypos)\n\nPlace a PNG image on the drawing at (xpos/ypos). The image img has been previously loaded using readpng().\n\n\n\nplaceimage(img, pos)\n\nPlace a PNG image on the drawing at pos.\n\n\n\nplaceimage(img, xpos, ypos, a)\n\nPlace a PNG image on the drawing at (xpos/ypos) with transparency a.\n\n\n\nplaceimage(img, pos, a)\n\nPlace a PNG image on the drawing at pos with transparency a.\n\n\n\n"
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
    "text": "You can clip images. The following script repeatedly places the image using a circle to define a clipping path:(Image: \"Images\")using Luxor\n\nwidth, height = 4000, 4000\nmargin = 500\n\nfname = \"/tmp/test-image.pdf\"\nDrawing(width, height, fname)\norigin()\nbackground(\"grey25\")\n\nsetline(5)\nsethue(\"green\")\n\nimage = readpng(dirname(@__FILE__) * \"assets/figures/julia-logo-mask.png\")\n\nw = image.width\nh = image.height\n\npagetiles = Tiler(width, height, 7, 9)\ntw = pagetiles.tilewidth/2\nfor (pos, n) in pagetiles\n    circle(pos, tw, :stroke)\n    circle(pos, tw, :clip)\n    gsave()\n    translate(pos)\n    scale(.95, .95)\n    rotate(rand(0.0:pi/8:2pi))\n    placeimage(image, -w/2, -h/2)\n    grestore()\n    clipreset()\nend\n\nfinish()"
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
    "text": "Turtle(xpos=0, ypos=0, pendown=true, orientation=0, pencolor=(1.0, 0.25, 0.25))\n\nWith a Turtle you can command a turtle to move and draw: turtle graphics.\n\nThe functions that start with a capital letter are: Forward, Turn, Circle, Orientation, Rectangle, Pendown, Penup, Pencolor, Penwidth, and Reposition.\n\nThere are also some other functions. To see how they might be used, see Lindenmayer.jl.\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Forward",
    "page": "Turtle graphics",
    "title": "Luxor.Forward",
    "category": "Function",
    "text": "Forward(t::Turtle, d)\n\nMove the turtle forward by d units. The stored position is updated.\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Turn",
    "page": "Turtle graphics",
    "title": "Luxor.Turn",
    "category": "Function",
    "text": "Turn(t::Turtle, r)\n\nIncrease the turtle's rotation by r degrees. See also Orientation.\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Circle",
    "page": "Turtle graphics",
    "title": "Luxor.Circle",
    "category": "Function",
    "text": "Circle(t::Turtle, radius)\n\nDraw a filled circle centred at the current position with the given radius.\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.HueShift",
    "page": "Turtle graphics",
    "title": "Luxor.HueShift",
    "category": "Function",
    "text": "HueShift(t::Turtle, inc = 1)\n\nShift the Hue of the turtle's pen forward by inc.\n\n\n\n"
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
    "text": "Orientation(t::Turtle, r)\n\nSet the turtle's orientation to r degrees. See also Turn.\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Randomize_saturation",
    "page": "Turtle graphics",
    "title": "Luxor.Randomize_saturation",
    "category": "Function",
    "text": "Randomize_saturation(t::Turtle)\n\nRandomize saturation of the turtle's pen color.\n\n\n\n"
},

{
    "location": "turtle.html#Luxor.Rectangle",
    "page": "Turtle graphics",
    "title": "Luxor.Rectangle",
    "category": "Function",
    "text": "Rectangle(t::Turtle, width, height)\n\nDraw a filled rectangle centred at the current position with the given radius.\n\n\n\n"
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
    "text": "Reposition(t::Turtle, x, y)\n\nReposition: pick the turtle up and place it at another position.\n\n\n\n"
},

{
    "location": "turtle.html#Turtle-graphics-1",
    "page": "Turtle graphics",
    "title": "Turtle graphics",
    "category": "section",
    "text": "Some simple \"turtle graphics\" functions are included. Functions to control the turtle begin with a capital letter: Forward, Turn, Circle, Orientation, Rectangle, Pendown, Penup, Pencolor, Penwidth, and Reposition.(Image: Turtle)using Luxor\n\nDrawing(1200, 1200, \"/tmp/turtles.png\")\norigin()\nbackground(\"black\")\n\n# let's have two turtles\nraphael = Turtle(0, 0, true, 0, (1.0, 0.25, 0.25)) ; michaelangelo = Turtle(0, 0, true, 0, (1.0, 0.25, 0.25))\n\nsetopacity(0.95)\nsetline(6)\n\nPencolor(raphael, 1.0, 0.4, 0.2);       Pencolor(michaelangelo, 0.2, 0.9, 1.0)\nReposition(raphael, 500, -200);         Reposition(michaelangelo, 500, 200)\nMessage(raphael, \"Raphael\");            Message(michaelangelo, \"Michaelangelo\")\nReposition(raphael, 0, -200);           Reposition(michaelangelo, 0, 200)\n\npace = 10\nfor i in 1:5:400\n    for turtle in [raphael, michaelangelo]\n        Circle(turtle, 3)\n        HueShift(turtle, rand())\n        Forward(turtle, pace)\n        Turn(turtle, 30 - rand())\n        Message(turtle, string(i))\n        pace += 1\n    end\nend\n\nfinish()\npreview()Turtle\nForward\nTurn\nCircle\nHueShift\nMessage\nOrientation\nRandomize_saturation\nRectangle\nPen_opacity_random\nPendown\nPenup\nPencolor\nPenwidth\nPoint\nPop\nPush\nReposition"
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
    "text": "Luxor provides some functions to help you create animations—at least, it provides some assistance in creating lots of individual frames that can later be stitched together to form a moving animation, such as a GIF or MP4.There are four steps to creating an animation.1 Use Sequence to create a Sequence object which determines the title and dimensions.2 Define a suitable backdrop(seq::Sequence, framenumber, framerange) function that contains graphics functions that are used on every frame of an animation sequence. For example, this is a good place to define a constant background color.3 Define a suitable frame(seq::Sequence, framenumber, framerange) function that constructs the contents of the frame numbered framenumber. The total framerange is available for possible reference inside the function.4 Call the animate(seq::Sequence, framerange, backdrop, frame) function, passing in your two functions (which don't have to be called anything special, but which should have the arguments shown above). This creates all the frames in the given framerange and saves them in a temporary directory."
},

{
    "location": "animation.html#Luxor.Sequence",
    "page": "Animation",
    "title": "Luxor.Sequence",
    "category": "Type",
    "text": "The Sequence type and the animate() function are designed to help you create the frames that can be used to make an animated GIF or movie.\n\nProvide width, height, and a title to the Sequence constructor:\n\ndemo = Sequence(400, 400, \"test\")\n\nThen define suitable backdrop and frame functions.\n\nFinally run the animate() function, calling those functions.\n\n\n\n"
},

{
    "location": "animation.html#Luxor.animate",
    "page": "Animation",
    "title": "Luxor.animate",
    "category": "Function",
    "text": "animate(seq::Sequence, frames::Range, backdrop_func, frame_func;\n        createanimation = true)\n\nCreate frames in the range frames, using a backdrop function and a frame function.\n\nThe backdrop function is called for every frame.\n\nfunction backdropf(demo, framenumber, framerange)\n...\nend\n\nThe frame generating function draws the graphics for a single frame.\n\nfunction framef(demo, framenumber, framerange)\n...\nend\n\nThen call animate() like this:\n\nanimate(demo, 1:100, backdropf, framef)\n\nIf createanimation is true, the function tries to call ffmpeg on the resulting frames to build the animation.\n\n\n\n"
},

{
    "location": "animation.html#Example-1",
    "page": "Animation",
    "title": "Example",
    "category": "section",
    "text": "using Luxor\n\ndemo = Sequence(400, 400, \"test\")\n\nfunction backdropf(demo, framenumber, framerange)\n    background(\"black\")\nend\n\nfunction framef(demo, framenumber, framerange)\n    xpos = 100 * cos(framenumber/100)\n    ypos = 100 * sin(framenumber/100)\n    sethue(Colors.HSV(rescale(framenumber, 0, length(framerange), 0, 360), 1, 1))\n    circle(xpos, ypos, 90, :stroke)\n    gsave()\n    translate(xpos, ypos)\n    juliacircles(50)\n    grestore()\n    text(string(\"frame $framenumber of $(length(framerange))\"), O)\nend\n\nanimate(demo, 1:630, backdropf, framef, createanimation=true)(Image: animation example)Sequence\nanimate"
},

{
    "location": "animation.html#Making-the-animation-1",
    "page": "Animation",
    "title": "Making the animation",
    "category": "section",
    "text": "Building an animation such as a GIF or MOV file is best done outside Julia, using something like ffmpeg, with its thousands of options, which include frame-rate adjustment and color palette tweaking. The animate function has a go at running it on Unix platforms, and assumes that ffmpeg is installed. Inside animate(), the first pass creates a color palette, the second builds the file:run(`ffmpeg -f image2 -i $(tempdirectory)/%10d.png -vf palettegen -y $(seq.stitle)-palette.png`)\n\nrun(`ffmpeg -framerate 30 -f image2 -i $(tempdirectory)/%10d.png -i $(seq.stitle)-palette.png -lavfi paletteuse -y /tmp/$(seq.stitle).gif`)"
},

{
    "location": "animation.html#Passing-information-to-later-frames-1",
    "page": "Animation",
    "title": "Passing information to later frames",
    "category": "section",
    "text": "Sometimes you want some information to be passed from frame to frame, such as the updated position of a graphical shape. Currently, the only way to do this is to store things in the sequence's parameters dictionary.For example, for a \"bouncing ball\" animation, you can store the current position and direction of the ball in the Sequence.parameters dictionary at the end of a frame, and then recall them at the start of the next frame.function frameF(seq::Sequence, framenumber, framerange)\n    pos          = seq.parameters[\"pos\"]\n    direction    = seq.parameters[\"direction\"]\n    spriteradius = seq.parameters[\"spriteradius\"]\n\n    # ... code to modify position, direction, and radius\n\n    seq.parameters[\"pos\"]          = newpos\n    seq.parameters[\"direction\"]    = newdirection\n    seq.parameters[\"spriteradius\"] = spriteradius\nend(Image: bouncing ball)"
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
