var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Current status",
    "title": "Current status",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#Luxor-1",
    "page": "Current status",
    "title": "Luxor",
    "category": "section",
    "text": "Luxor is the lightest dusting of syntactic sugar on Julia's Cairo graphics package (which should also be installed). It provides some basic vector drawing commands, and a few utilities for working with polygons, clipping masks, PNG images, and turtle graphics.(Image: )The idea of Luxor is that it's slightly easier to use than Cairo.jl, with shorter names, fewer underscores, default contexts, and simplified functions. It's for when you just want to draw something without too much ceremony. If you've ever hacked on a PostScript file, you should feel right at home (only without the reverse Polish notation, obviously).For a much more powerful graphics environment, try Compose.jl. Also worth looking at is Andrew Cooke's Drawing.jl package.Colors.jl provides excellent color definitions and is also required.I've only tried this on MacOS X. It will need some changes to work on Windows (but I can't test it)."
},

{
    "location": "index.html#Current-status-1",
    "page": "Current status",
    "title": "Current status",
    "category": "section",
    "text": "It's been updated for Julia version 0.5 and for the new Colors.jl. SVG rendering currently seems unreliable — text placement generates segmentation faults."
},

{
    "location": "index.html#Installation-and-basic-usage-1",
    "page": "Current status",
    "title": "Installation and basic usage",
    "category": "section",
    "text": "To install:Pkg.clone(\"https://github.com/cormullion/Luxor.jl\")and to use:using Luxor"
},

{
    "location": "index.html#The-basic-\"Hello-World\"-1",
    "page": "Current status",
    "title": "The basic \"Hello World\"",
    "category": "section",
    "text": "Here's a simple \"Hello world\":(Image: \"Hello world\")using Luxor, Colors\nDrawing(1000, 1000, \"/tmp/hello-world.png\")\norigin()\nsethue(\"red\")\nfontsize(50)\ntext(\"hello world\")\nfinish()\npreview()The Drawing(1000, 1000, \"/tmp/hello-world.png\") line defines the size of the image and the location of the finished image when it's saved.origin() moves the 0/0 point to the centre of the drawing surface (by default it's at the top left corner). Because we're using Colors.jl, we can specify colors by name.text() places text. It's placed at 0/0 if you don't specify otherwise.finish() completes the drawing and saves the image in the file. preview() tries to open the saved file using some other application (eg on MacOS X, Preview)."
},

{
    "location": "index.html#A-slightly-more-interesting-image-1",
    "page": "Current status",
    "title": "A slightly more interesting image",
    "category": "section",
    "text": "(Image: Luxor test)using Luxor, Colors\nDrawing(1200, 1400, \"/tmp/basic-test.png\") # or PDF/SVG filename for PDF or SVG\n\norigin()\nbackground(\"purple\")\n\nsetopacity(0.7)                      # opacity from 0 to 1\nsethue(0.3,0.7,0.9)                  # sethue sets the color but doesn't change the opacity\nsetline(20)                          # line width\n\nrect(-400,-400,800,800, :fill)       # or :stroke, :fillstroke, :clip\nrandomhue()\ncircle(0, 0, 460, :stroke)\n\ncircle(0,-200,400,:clip)             # a circular clipping mask above the x axis\nsethue(\"gold\")\nsetopacity(0.7)\nsetline(10)\n\nfor i in 0:pi/36:2pi - pi/36\n    move(0, 0)\n    line(cos(i) * 600, sin(i) * 600 )\n    stroke()\nend\n\nclipreset()                           # finish masking\n\nfontsize(60)\nsetcolor(\"turquoise\")\nfontface(\"Optima-ExtraBlack\")\ntextwidth = textextents(\"Luxor\")[5]\n\n# move the text by half the width\ntextcentred(\"Luxor\", -textwidth/2, currentdrawing.height/2 - 400)\n\nfontsize(18)\nfontface(\"Avenir-Black\")\n\n# text on curve starting at angle 0 rads centered on origin with radius 550\ntextcurve(\"THIS IS TEXT ON A CURVE \" ^ 14, 0, 550, Point(0, 0))\n\nfinish()\npreview() # on Mac OS X, opens in Preview"
},

{
    "location": "index.html#Types-1",
    "page": "Current status",
    "title": "Types",
    "category": "section",
    "text": "The two main defined types are the Point and the Drawing. The Point type holds two coordinates, the x and y:`Point(12.0, 13.0)`"
},

{
    "location": "index.html#Luxor.Drawing",
    "page": "Current status",
    "title": "Luxor.Drawing",
    "category": "Type",
    "text": "Create a new drawing, optionally specify file type and dimensions.\n\nDrawing()\n\ncreates a drawing, defaulting to PNG format, default filename \"/tmp/luxor-drawing.png\", default size 800 pixels square.\n\nDrawing(300,300)\n\ncreates a drawing 300 by 300 pixels, defaulting to PNG format, default filename \"/tmp/luxor-drawing.png\".\n\nDrawing(300,300, \"/tmp/my-drawing.pdf\")\n\ncreates a PDF drawing in the file \"/tmp/my-drawing.pdf\", 300 by 300 pixels.\n\nDrawing(800,800, \"/tmp/my-drawing.svg\")`\n\ncreates an SVG drawing in the file \"/tmp/my-drawing.svg\", 800 by 800 pixels.\n\nDrawing(800,800, \"/tmp/my-drawing.eps\")\n\ncreates an EPS drawing in the file \"/tmp/my-drawing.eps\", 800 by 800 pixels.\n\nDrawing(\"A4\", \"/tmp/my-drawing.pdf\")\n\ncreates a drawing in ISO A4 size in the file \"/tmp/my-drawing.pdf\". Other sizes available are:  \"A0\", \"A1\", \"A2\", \"A3\", \"A4\", \"A5\", \"A6\", \"Letter\", \"Legal\", \"A\", \"B\", \"C\", \"D\", \"E\". Append \"landscape\" to get the landscape version.\n\nDrawing(\"A4landscape\")\n\nCreate the drawing A4 landscape size.\n\nNote that PDF files seem to default to a white background, but PNG defaults to black. Might be a bug here somewhere...\n\n\n\n"
},

{
    "location": "index.html#Luxor.finish",
    "page": "Current status",
    "title": "Luxor.finish",
    "category": "Function",
    "text": "finish()\n\nFinish the drawing, and close the file. The filename is still available in currentdrawing.filename, and you may be able to open it using preview().\n\n\n\n"
},

{
    "location": "index.html#Luxor.preview",
    "page": "Current status",
    "title": "Luxor.preview",
    "category": "Function",
    "text": "preview()\n\nOn macOS, opens the file, which probably uses the default, Preview.app. On Unix, open the file with xdg-open. On Windows, pass the filename to the shell.\n\n\n\n"
},

{
    "location": "index.html#Drawings-and-files-1",
    "page": "Current status",
    "title": "Drawings and files",
    "category": "section",
    "text": "To create a drawing, and optionally specify the file name and type, and dimensions, use the Drawing function.DrawingTo finish a drawing and close the file, use finish(), and, to launch an external application to view it, use preview().finish\npreviewThe global variable currentdrawing holds a few parameters:julia> fieldnames(currentdrawing)\n10-element Array{Symbol,1}:\n:width\n:height\n:filename\n:surface\n:cr\n:surfacetype\n:redvalue\n:greenvalue\n:bluevalue\n:alpha"
},

{
    "location": "index.html#Luxor.background",
    "page": "Current status",
    "title": "Luxor.background",
    "category": "Function",
    "text": "background(color)\n\nFill the canvas with color. It's useful to have Colors.jl installed.\n\nExamples:\n\nbackground(\"antiquewhite\")\nbackground(\"ivory\")\nbackground(Colors.RGB(0, 0, 0))\nbackground(Colors.Luv(20, -20, 30))\n\n\n\n"
},

{
    "location": "index.html#Luxor.axes",
    "page": "Current status",
    "title": "Luxor.axes",
    "category": "Function",
    "text": "Draw two axes lines starting at 0/0 and continuing out along the current positive x and y axes.\n\n\n\n"
},

{
    "location": "index.html#Luxor.origin",
    "page": "Current status",
    "title": "Luxor.origin",
    "category": "Function",
    "text": "origin()\n\nSet the 0/0 origin at the center of the drawing (otherwise it will stay at the top left corner).\n\n\n\n"
},

{
    "location": "index.html#Axes-and-backgrounds-1",
    "page": "Current status",
    "title": "Axes and backgrounds",
    "category": "section",
    "text": "The origin (0/0) is at the top left, x axis runs left to right, y axis runs top to bottom.The origin() function moves the 0/0 point. The axes() function draws a couple of lines to indicate the current axes. background() fills the entire image with a color.background\naxes\norigin"
},

{
    "location": "index.html#Basic-drawing-1",
    "page": "Current status",
    "title": "Basic drawing",
    "category": "section",
    "text": "The underlying Cairo drawing model is similar to PostScript: paths can be filled and/or stroked, using the current graphics state, which specifies colors, line thicknesses and patterns, and opacity.Many drawing functions have an action argument. This can be :nothing, :fill, :stroke, :fillstroke, :fillpreserve, :strokepreserve, :clip. The default is :nothing.Positions are usually specified either by x and y coordinates or a Point(x, y). Angles are usually measured from the positive x-axis to the positive y-axis (which points 'down' the page or canvas) in radians, clockwise."
},

{
    "location": "index.html#Luxor.circle",
    "page": "Current status",
    "title": "Luxor.circle",
    "category": "Function",
    "text": "Draw a circle centred at x/y.\n\ncircle(x, y, r, action)\n\naction is one of the actions applied by do_action.\n\n\n\nDraw a circle centred at pt.\n\ncircle(pt, r, action)\n\n\n\n"
},

{
    "location": "index.html#Luxor.arc",
    "page": "Current status",
    "title": "Luxor.arc",
    "category": "Function",
    "text": "Add an arc to the current path from angle1 to angle2 going clockwise.\n\narc(xc, yc, radius, angle1, angle2, action=:nothing)\n\nAngles are defined relative to the x-axis, positive clockwise.\n\n\n\n"
},

{
    "location": "index.html#Luxor.carc",
    "page": "Current status",
    "title": "Luxor.carc",
    "category": "Function",
    "text": "Add an arc to the current path from angle1 to angle2 going counterclockwise.\n\ncarc(xc, yc, radius, angle1, angle2, action=:nothing)\n\nAngles are defined relative to the x-axis, positive clockwise.\n\n\n\n"
},

{
    "location": "index.html#Luxor.curve",
    "page": "Current status",
    "title": "Luxor.curve",
    "category": "Function",
    "text": "Create a cubic Bézier spline curve.\n\ncurve(x1, y1, x2, y2, x3, y3)\n\ncurve(p1, p2, p3)\n\nThe spline starts at the current position, finishing at x3/y3 (p3), following two control points x1/y1 (p1) and x2/y2 (p2)\n\n\n\n"
},

{
    "location": "index.html#Luxor.sector",
    "page": "Current status",
    "title": "Luxor.sector",
    "category": "Function",
    "text": "sector(innerradius, outerradius, startangle, endangle, action=:none)\n\nDraw a track/sector based at 0/0.\n\n\n\n"
},

{
    "location": "index.html#Luxor.rect",
    "page": "Current status",
    "title": "Luxor.rect",
    "category": "Function",
    "text": "Create a rectangle with one corner at (xmin/ymin) with width w and height h and do an action.\n\nrect(xmin, ymin, w, h, action)\n\n\n\nCreate a rectangle with one corner at cornerpoint with width w and height h and do an action.\n\nrect(cornerpoint, w, h, action)\n\n\n\n"
},

{
    "location": "index.html#Luxor.box",
    "page": "Current status",
    "title": "Luxor.box",
    "category": "Function",
    "text": "Create a rectangle between two points and do an action.\n\nbox(cornerpoint1, cornerpoint2, action=:nothing)\n\n\n\nCreate a rectangle between the first two points of an array of Points.\n\nbox(points::Array, action=:nothing)\n\n\n\n"
},

{
    "location": "index.html#Simple-shapes-1",
    "page": "Current status",
    "title": "Simple shapes",
    "category": "section",
    "text": "Functions for drawing shapes include circle(), arc(), carc(), curve(), sector(), rect(), and box().circle\narc\ncarc\ncurve\nsector\nrect\nbox"
},

{
    "location": "index.html#Luxor.move",
    "page": "Current status",
    "title": "Luxor.move",
    "category": "Function",
    "text": "Move to a point.\n\n- `move(x, y)`\n- `move(pt)`\n\n\n\n"
},

{
    "location": "index.html#Luxor.rmove",
    "page": "Current status",
    "title": "Luxor.rmove",
    "category": "Function",
    "text": "Move by an amount from the current point. Move relative to current position by x and y:\n\nrmove(x, y)\n\nMove relative to current position by the pt's x and y:\n\nrmove(pt)\n\n\n\n"
},

{
    "location": "index.html#Luxor.line",
    "page": "Current status",
    "title": "Luxor.line",
    "category": "Function",
    "text": "Create a line from the current position to the x/y position and optionally apply an action:\n\nline(x, y)\n\nline(x, y, :action)\n\nline(pt)\n\n\n\nMake a line between two points, pt1 and pt2.\n\nline(pt1::Point, pt2::Point, action=:nothing)\n\n\n\n"
},

{
    "location": "index.html#Luxor.rline",
    "page": "Current status",
    "title": "Luxor.rline",
    "category": "Function",
    "text": "Create a line relative to the current position to the x/y position and optionally apply an action:\n\nrline(x, y)\n\nrline(x, y, :action)\n\nrline(pt)\n\n\n\n"
},

{
    "location": "index.html#Lines-and-arcs-1",
    "page": "Current status",
    "title": "Lines and arcs",
    "category": "section",
    "text": "There is a 'current position' which you can set with move(), and use implicitly in functions like line() and text().move\nrmove\nline\nrline"
},

{
    "location": "index.html#Luxor.newpath",
    "page": "Current status",
    "title": "Luxor.newpath",
    "category": "Function",
    "text": "newpath()\n\nCreate a new path. This is Cairo's new_path() function.\n\n\n\n"
},

{
    "location": "index.html#Luxor.newsubpath",
    "page": "Current status",
    "title": "Luxor.newsubpath",
    "category": "Function",
    "text": "newsubpath()\n\nCreate a new subpath of the current path. This is Cairo's new_sub_path() function. It can be used, for example, to make holes in shapes.\n\n\n\n"
},

{
    "location": "index.html#Luxor.closepath",
    "page": "Current status",
    "title": "Luxor.closepath",
    "category": "Function",
    "text": "closepath()\n\nClose the current path. This is Cairo's close_path() function.\n\n\n\n"
},

{
    "location": "index.html#Paths-1",
    "page": "Current status",
    "title": "Paths",
    "category": "section",
    "text": "A path is a group of points. A path can have subpaths (which can form holes).newpath\nnewsubpath\nclosepathThe getpath() function get the current Cairo path as an array of element types and points. getpathflat() gets the current path as an array of type/points with curves flattened to line segments."
},

{
    "location": "index.html#Color-and-opacity-1",
    "page": "Current status",
    "title": "Color and opacity",
    "category": "section",
    "text": "For color definitions and conversions, we use Colors.jl. The difference between the setcolor() and sethue() functions is that sethue() is independent of alpha opacity, so you can change the hue without changing the current opacity value (this is similar to Mathematica)."
},

{
    "location": "index.html#Luxor.setline",
    "page": "Current status",
    "title": "Luxor.setline",
    "category": "Function",
    "text": "Set the line width.\n\nsetline(n)\n\n\n\n"
},

{
    "location": "index.html#Luxor.setlinecap",
    "page": "Current status",
    "title": "Luxor.setlinecap",
    "category": "Function",
    "text": "Set the line ends. s can be \"butt\" (default), \"square\", or \"round\".\n\nsetlinecap(s)\n\nsetlinecap(\"round\")\n\n\n\n"
},

{
    "location": "index.html#Luxor.setlinejoin",
    "page": "Current status",
    "title": "Luxor.setlinejoin",
    "category": "Function",
    "text": "Set the line join, i.e. how to render the junction of two lines when stroking.\n\nsetlinejoin(\"round\")\nsetlinejoin(\"miter\")\nsetlinejoin(\"bevel\")\n\n\n\n"
},

{
    "location": "index.html#Luxor.setdash",
    "page": "Current status",
    "title": "Luxor.setdash",
    "category": "Function",
    "text": "Set the dash pattern to one of: \"solid\", \"dotted\", \"dot\", \"dotdashed\", \"longdashed\", \"shortdashed\", \"dash\", \"dashed\", \"dotdotdashed\", \"dotdotdotdashed\"\n\nsetlinedash(\"dot\")\n\n\n\n"
},

{
    "location": "index.html#Luxor.fillstroke",
    "page": "Current status",
    "title": "Luxor.fillstroke",
    "category": "Function",
    "text": "Fill and stroke the current path.\n\n\n\n"
},

{
    "location": "index.html#Luxor.stroke",
    "page": "Current status",
    "title": "Luxor.stroke",
    "category": "Function",
    "text": "Stroke the current path with the current line width, line join, line cap, and dash settings. The current path is then cleared.\n\nstroke()\n\n\n\n"
},

{
    "location": "index.html#Base.fill",
    "page": "Current status",
    "title": "Base.fill",
    "category": "Function",
    "text": "Fill the current path with current settings. The current path is then cleared.\n\nfill()\n\n\n\n"
},

{
    "location": "index.html#Luxor.strokepreserve",
    "page": "Current status",
    "title": "Luxor.strokepreserve",
    "category": "Function",
    "text": "Stroke the current path with current line width, line join, line cap, and dash settings, but then keep the path current.\n\nstrokepreserve()\n\n\n\n"
},

{
    "location": "index.html#Luxor.fillpreserve",
    "page": "Current status",
    "title": "Luxor.fillpreserve",
    "category": "Function",
    "text": "Fill the current path with current settings, but then keep the path current.\n\nfillpreserve()\n\n\n\n"
},

{
    "location": "index.html#Luxor.gsave",
    "page": "Current status",
    "title": "Luxor.gsave",
    "category": "Function",
    "text": "Save the current graphics state on the stack.\n\n\n\n"
},

{
    "location": "index.html#Luxor.grestore",
    "page": "Current status",
    "title": "Luxor.grestore",
    "category": "Function",
    "text": "Replace the current graphics state with the one on top of the stack.\n\n\n\n"
},

{
    "location": "index.html#Styles-1",
    "page": "Current status",
    "title": "Styles",
    "category": "section",
    "text": "The set- commands control the width, end shapes, join behaviour and dash pattern:setline\nsetlinecap\nsetlinejoin\nsetdash\nfillstroke\nstroke\nfill\nstrokepreserve\nfillpreservegsave() and grestore() should always be balanced in pairs. gsave() saves a copy of the current graphics settings (current axis rotation, position, scale, line and text settings, and so on). When the next grestore() is called, all changes you've made to the graphics settings will be discarded, and they'll return to how they were when you used gsave().gsave\ngrestore"
},

{
    "location": "index.html#Polygons-and-such-1",
    "page": "Current status",
    "title": "Polygons and such",
    "category": "section",
    "text": ""
},

{
    "location": "index.html#Luxor.ngon",
    "page": "Current status",
    "title": "Luxor.ngon",
    "category": "Function",
    "text": "Draw a regular polygon centred at x, y:\n\nngon(x, y,      radius, sides, orientation, action; close=true, reversepath=false)\n\nUse ngonv() to return the points of a polygon.\n\n\n\nDraw a regular polygon centred at p:\n\nngon(centerpos, radius, sides, orientation, action; close=true, reversepath=false)\n\n\n\n"
},

{
    "location": "index.html#Luxor.ngonv",
    "page": "Current status",
    "title": "Luxor.ngonv",
    "category": "Function",
    "text": "Return the vertices of a regular n-sided polygon centred at x, y:\n\nngonv(x, y, radius, sides, orientation)\n\nngon() uses the shapes: if you just want the raw points, use ngonv, which returns an array of points instead. Compare:\n\nngonv(0, 0, 4, 4, 0) # returns the polygon's points\n\n4-element Array{Luxor.Point,1}:\nLuxor.Point(2.4492935982947064e-16,4.0)\nLuxor.Point(-4.0,4.898587196589413e-16)\nLuxor.Point(-7.347880794884119e-16,-4.0)\nLuxor.Point(4.0,-9.797174393178826e-16)\n\nngon(0, 0, 4, 4, 0, :close) # draws a polygon\n\n\n\nReturn the vertices of a regular polygon centred at p:\n\nngonv(p, radius, sides, orientation)\n\n\n\n"
},

{
    "location": "index.html#Regular-polygons-(\"ngons\")-1",
    "page": "Current status",
    "title": "Regular polygons (\"ngons\")",
    "category": "section",
    "text": "You can make regular polygons — from triangles, pentagons, hexagons, septagons, heptagons, octagons, nonagons, decagons, and on-and-on-agons — with ngon() and ngonv(). ngon() uses the shapes: if you just want the raw points, use ngonv, which returns an array of points instead:(Image: n-gons)using Luxor, Colors\nDrawing(1200, 1400)\n\norigin()\ncols = diverging_palette(60,120, 20) # hue 60 to hue 120\nbackground(cols[1])\nsetopacity(0.7)\nsetline(2)\n\nngon(0, 0, 500, 8, 0, :clip)\n\nfor y in -500:50:500\n  for x in -500:50:500\n    setcolor(cols[rand(1:20)])\n    ngon(x, y, rand(20:25), rand(3:12), 0, :fill)\n    setcolor(cols[rand(1:20)])\n    ngon(x, y, rand(10:20), rand(3:12), 0, :stroke)\n  end\nend\n\nfinish()\npreview()ngon\nngonv"
},

{
    "location": "index.html#Luxor.simplify",
    "page": "Current status",
    "title": "Luxor.simplify",
    "category": "Function",
    "text": "Simplify a polygon:\n\nsimplify(pointlist::Array, detail)\n\ndetail is probably the smallest permitted distance between two points.\n\n\n\n"
},

{
    "location": "index.html#Luxor.polysplit",
    "page": "Current status",
    "title": "Luxor.polysplit",
    "category": "Function",
    "text": "Split a polygon into two where it intersects with a line:\n\npolysplit(p, p1, p2)\n\nThis doesn't always work, of course. (Tell me you're not surprised.) For example, a polygon the shape of the letter \"E\" might end up being divided into more than two parts.\n\n\n\n"
},

{
    "location": "index.html#Luxor.polysortbydistance",
    "page": "Current status",
    "title": "Luxor.polysortbydistance",
    "category": "Function",
    "text": "Sort a polygon by finding the nearest point to the starting point, then the nearest point to that, and so on.\n\npolysortbydistance(p, starting::Point)\n\nYou can end up with convex (self-intersecting) polygons, unfortunately.\n\n\n\n"
},

{
    "location": "index.html#Luxor.polysortbyangle",
    "page": "Current status",
    "title": "Luxor.polysortbyangle",
    "category": "Function",
    "text": "Sort the points of a polygon into order. Points are sorted according to the angle they make with a specified point.\n\npolysortbyangle(parray, parray[1])\n\nThe refpoint can be chosen, minimum point is usually OK:\n\npolysortbyangle(parray, polycentroid(parray))\n\n\n\n"
},

{
    "location": "index.html#Luxor.polycentroid",
    "page": "Current status",
    "title": "Luxor.polycentroid",
    "category": "Function",
    "text": "Find the centroid of simple polygon.\n\npolycentroid(pointlist)\n\nOnly works for simple (non-intersecting) polygons. Come on, this isn't a CAD system...! :)\n\nReturns a point.\n\n\n\n"
},

{
    "location": "index.html#Luxor.polybbox",
    "page": "Current status",
    "title": "Luxor.polybbox",
    "category": "Function",
    "text": "Find the bounding box of a polygon (array of points).\n\npolybbox(pointlist::Array)\n\nReturn the two opposite corners (suitable for box, for example).\n\n\n\n"
},

{
    "location": "index.html#Polygons-1",
    "page": "Current status",
    "title": "Polygons",
    "category": "section",
    "text": "A polygon is an array of Points. Use poly() to add them, or randompointarray() to create a random list of Points. Polygons can contain holes. The reversepath keyword changes the direction of the polygon. This uses ngon() to make two polygons, one forming a hole in another to make a hexagonal bolt shape:ngon(0, 0, 60, 6, 0, :path)\nnewsubpath()\nngon(0, 0, 40, 6, 0, :path, reversepath=true)\nfillstroke()Polygons can be simplified using the Douglas-Peucker algorithm (non-recursive version), using simplify().simplifyThere are some experimental polygon functions. These don't work well for polygons that aren't simple or where the sides intersect each other.polysplit\npolysortbydistance\npolysortbyangle\npolycentroid\npolybboxThe prettypoly() function can place graphics at each vertex of a polygon. After the poly action, the vertex_action is evaluated at each vertex. For example, to mark each vertex of a polygon with a circle scaled to 0.1.prettypoly(pl, :fill, :(\n                        scale(0.1, 0.1);\n                        circle(0, 0, 10, :fill)\n                       ),\n           close=false)The vertex_action expression can't use definitions that are not in scope, eg you can't pass a variable in from the calling function and expect the polygon-drawing function to know about it."
},

{
    "location": "index.html#Luxor.starv",
    "page": "Current status",
    "title": "Luxor.starv",
    "category": "Function",
    "text": "Make a star, returning its vertices:\n\nstarv(xcenter, ycenter, radius, npoints, ratio=0.5, orientation=0, close=true, reversepath=false)\n\nUse star() to draw a star.\n\n\n\n"
},

{
    "location": "index.html#Luxor.star",
    "page": "Current status",
    "title": "Luxor.star",
    "category": "Function",
    "text": "Draw a star:\n\nstar(xcenter, ycenter, radius, npoints, ratio=0.5, orientation=0, action=:nothing, close=true, reversepath=false)\n\nUse starv() to return the vertices of a star.\n\n\n\nDraw a star:\n\nstar(centerpos, radius, npoints, ratio=0.5, orientation=0, action=:nothing, close=true, reversepath=false)\n\nUse starv() to return the vertices of a star.\n\n\n\n"
},

{
    "location": "index.html#Stars-1",
    "page": "Current status",
    "title": "Stars",
    "category": "section",
    "text": "Use starv() to return the vertices of a star, and star() to make a star.(Image: stars)using Luxor, Colors\nw, h = 600, 600\nDrawing(w, h, \"/tmp/stars.png\")\norigin()\ncols = [RGB(rand(3)...) for i in 1:50]\nbackground(\"grey20\")\nx = -w/2\nfor y in 100 * randn(h, 1)\n    setcolor(cols[rand(1:end)])\n    star(x, y, 10, rand(4:7), rand(3:7)/10, 0, :fill)\n    x += 2\nend\nfinish()\npreview()starv\nstar"
},

{
    "location": "index.html#Text-and-fonts-1",
    "page": "Current status",
    "title": "Text and fonts",
    "category": "section",
    "text": ""
},

{
    "location": "index.html#Luxor.text",
    "page": "Current status",
    "title": "Luxor.text",
    "category": "Function",
    "text": "text(str, x, y)\ntext(str, pt)\n\nDraw the text in the string str at x/y or pt, placing the start of the string at the point. If you omit the point, it's placed at 0/0.\n\nIn Luxor, placing text doesn't affect the current point!\n\n\n\n"
},

{
    "location": "index.html#Luxor.textcentred",
    "page": "Current status",
    "title": "Luxor.textcentred",
    "category": "Function",
    "text": "textcentred(str, x, y)\ntextcentred(str, pt)\n\nDraw text in the string str centered at x/y or pt. If you omit the point, it's placed at 0/0.\n\nText doesn't affect the current point!\n\n\n\n"
},

{
    "location": "index.html#Luxor.textpath",
    "page": "Current status",
    "title": "Luxor.textpath",
    "category": "Function",
    "text": "textpath(t)\n\nConvert the text in string t to a new path, for subsequent filling/stroking etc...\n\n\n\n"
},

{
    "location": "index.html#Placing-text-1",
    "page": "Current status",
    "title": "Placing text",
    "category": "section",
    "text": "Use text() and textcentred() to place text. textpath() converts the text into  a graphic path suitable for further manipulations.text\ntextcentred\ntextpath"
},

{
    "location": "index.html#Luxor.fontface",
    "page": "Current status",
    "title": "Luxor.fontface",
    "category": "Function",
    "text": "fontface(fontname)\n\nSelect a font to use. If the font is unavailable, it defaults to Helvetica/San Francisco (on macOS).\n\n\n\n"
},

{
    "location": "index.html#Luxor.fontsize",
    "page": "Current status",
    "title": "Luxor.fontsize",
    "category": "Function",
    "text": "fontsize(n)\n\nSet the font size to n points. Default is 10pt.\n\n\n\n"
},

{
    "location": "index.html#Luxor.textextents",
    "page": "Current status",
    "title": "Luxor.textextents",
    "category": "Function",
    "text": "textextents(str)\n\nReturn the measurements of the string str when set using the current font settings:\n\nx_bearing\ny_bearing\nwidth\nheight\nx_advance\ny_advance\n\nThe bearing is the displacement from the reference point to the upper-left corner of the bounding box. It is often zero or a small positive value for x displacement, but can be negative x for characters like j; it's almost always a negative value for y displacement.\n\nThe width and height then describe the size of the bounding box. The advance takes you to the suggested reference point for the next letter. Note that bounding boxes for subsequent blocks of text can overlap if the bearing is negative, or the advance is smaller than the width would suggest.\n\nExample:\n\ntextextents(\"R\")\n\nreturns\n\n[1.18652; -9.68335; 8.04199; 9.68335; 9.74927; 0.0]\n\n\n\n"
},

{
    "location": "index.html#Fonts-1",
    "page": "Current status",
    "title": "Fonts",
    "category": "section",
    "text": "Use fontface(fontname) to choose a font, and fontsize(n) to set font size in points.The textextents(str) function gets array of dimensions of the string str, given current font.fontface\nfontsize\ntextextents"
},

{
    "location": "index.html#Luxor.textcurve",
    "page": "Current status",
    "title": "Luxor.textcurve",
    "category": "Function",
    "text": "Place a string of text on a curve. It can spiral in or out.\n\ntextcurve(the_text,\n          start_angle,\n          start_radius,\n          x_pos,\n          y_pos;\n          # optional keyword arguments:\n          spiral_ring_step = 0,   # step out or in by this amount\n          letter_spacing = 0,     # tracking/space between chars, tighter is (-), looser is (+)\n          spiral_in_out_shift = 0 # + values go outwards, - values spiral inwards\n          )\n\nstart_angle is relative to +ve x-axis, arc/circle is centred on (x_pos,y_pos) with radius start_radius.\n\n\n\n"
},

{
    "location": "index.html#Text-on-a-curve-1",
    "page": "Current status",
    "title": "Text on a curve",
    "category": "section",
    "text": "Use textcurve(str) to draw a string str on an arc.(Image: text on a curve or spiral)  using Luxor, Colors\n  Drawing(1800, 1800, \"/tmp/text-spiral.png\")\n  fontsize(18)\n  fontface(\"LucidaSansUnicode\")\n  origin()\n  background(\"ivory\")\n  sethue(\"royalblue4\")\n  textstring = join(names(Base), \" \")\n  textcurve(\"this spiral contains every word in julia names(Base): \" * textstring, -pi/2,\n    800, 0, 0,\n    spiral_in_out_shift = -18.0,\n    letter_spacing = 0,\n    spiral_ring_step = 0)\n\n  fontsize(35)\n  fontface(\"Agenda-Black\")\n  textcentred(\"julia names(Base)\", 0, 0)\n  finish()\n  preview()textcurve"
},

{
    "location": "index.html#Text-clipping-1",
    "page": "Current status",
    "title": "Text clipping",
    "category": "section",
    "text": "You can use newly-created text paths as a clipping region - here the text paths are 'filled' with names of randomly chosen Julia functions.(Image: text clipping)    using Luxor, Colors\n\n    currentwidth = 1250 # pts\n    currentheight = 800 # pts\n    Drawing(currentwidth, currentheight, \"/tmp/text-path-clipping.png\")\n\n    origin()\n    background(\"darkslategray3\")\n\n    fontsize(600)                             # big fontsize to use for clipping\n    fontface(\"Agenda-Black\")\n    str = \"julia\"                             # string to be clipped\n    w, h = textextents(str)[3:4]              # get width and height\n\n    translate(-(currentwidth/2) + 50, -(currentheight/2) + h)\n\n    textpath(str)                             # make text into a path\n    setline(3)\n    setcolor(\"black\")\n    fillpreserve()                            # fill but keep\n    clip()                                    # and use for clipping region\n\n    fontface(\"Monaco\")\n    fontsize(10)\n    namelist = map(x->string(x), names(Base)) # get list of function names in Base.\n\n    x = -20\n    y = -h\n    while y < currentheight\n        sethue(rand(7:10)/10, rand(7:10)/10, rand(7:10)/10)\n        s = namelist[rand(1:end)]\n        text(s, x, y)\n        se = textextents(s)\n        x += se[5]                            # move to the right\n        if x > w\n           x = -20                            # next row\n           y += 10\n        end\n    end\n\n    finish()\n    preview()"
},

{
    "location": "index.html#Base.scale",
    "page": "Current status",
    "title": "Base.scale",
    "category": "Function",
    "text": "Scale subsequent drawing in x and y.\n\nExample:\n\nscale(0.2, 0.3)\n\n\n\n"
},

{
    "location": "index.html#Luxor.rotate",
    "page": "Current status",
    "title": "Luxor.rotate",
    "category": "Function",
    "text": "Rotate subsequent drawing by a radians clockwise.\n\nrotate(a)\n\n\n\n"
},

{
    "location": "index.html#Luxor.translate",
    "page": "Current status",
    "title": "Luxor.translate",
    "category": "Function",
    "text": "Translate to new location.\n\ntranslate(x, y)\n\nor\n\ntranslate(point)\n\n\n\n"
},

{
    "location": "index.html#Luxor.getmatrix",
    "page": "Current status",
    "title": "Luxor.getmatrix",
    "category": "Function",
    "text": "Get the current matrix.\n\ngetmatrix()\n\nReturn current Cairo matrix as an array. In Cairo and Luxor, a matrix is an array of 6 float64 numbers:\n\nxx component of the affine transformation\nyx component of the affine transformation\nxy component of the affine transformation\nyy component of the affine transformation\nx0 translation component of the affine transformation\ny0 translation component of the affine transformation\n\nSome basic matrix transforms:\n\ntranslate(dx,dy) =	  transform([1,  0, 0,  1, dx, dy])                 shift by scale(fx, fy)    =    transform([fx, 0, 0, fy,  0, 0])                  scale by rotate(A)        =    transform([c, s, -c, c,   0, 0])                  rotate to A radians x-skew(a)        =    transform([1,  0, tan(a), 1,   0, 0])             xskew by A y-skew(a)        =    transform([1, tan(a), 0, 1, 0, 0])                yskew by A flip HV          =    transform([fx, 0, 0, fy, cx(1-fx), cy (fy-1)])  flip\n\n\n\n"
},

{
    "location": "index.html#Luxor.setmatrix",
    "page": "Current status",
    "title": "Luxor.setmatrix",
    "category": "Function",
    "text": "Change the current Cairo matrix to matrix m.\n\nsetmatrix(m::Array)\n\nUse getmatrix() to get the current matrix.\n\n\n\n"
},

{
    "location": "index.html#Luxor.transform",
    "page": "Current status",
    "title": "Luxor.transform",
    "category": "Function",
    "text": "Modify the current matrix by multiplying it by matrix a.\n\ntransform(a::Array)\n\nFor example, to skew the current state by 45 degrees in x and move by 20 in y direction:\n\ntransform([1, 0, tand(45), 1, 0, 20])\n\nUse getmatrix() to get the current matrix.\n\n\n\n"
},

{
    "location": "index.html#Transforms-and-matrices-1",
    "page": "Current status",
    "title": "Transforms and matrices",
    "category": "section",
    "text": "For basic transformations of the drawing space, use scale(sx, sy), rotate(a), and translate(tx, ty).scale\nrotate\ntranslateThe current matrix is a six number array, perhaps like this:[1, 0, 0, 1, 0, 0]getmatrix() gets the current matrix, setmatrix(a) sets the matrix to array a, and  transform(a) transforms the current matrix by 'multiplying' it with matrix a.getmatrix\nsetmatrix\ntransform"
},

{
    "location": "index.html#Luxor.clip",
    "page": "Current status",
    "title": "Luxor.clip",
    "category": "Function",
    "text": "Establish a new clip region by intersecting the current clip region with the current path and then clearing the current path.\n\nclip()\n\n\n\n"
},

{
    "location": "index.html#Luxor.clippreserve",
    "page": "Current status",
    "title": "Luxor.clippreserve",
    "category": "Function",
    "text": "Establishes a new clip region by intersecting the current clip region with the current path, but keep the current path.\n\nclippreserve()\n\n\n\n"
},

{
    "location": "index.html#Luxor.clipreset",
    "page": "Current status",
    "title": "Luxor.clipreset",
    "category": "Function",
    "text": "Reset the clip region to the current drawing's extent.\n\nclipreset()\n\n\n\n"
},

{
    "location": "index.html#Clipping-1",
    "page": "Current status",
    "title": "Clipping",
    "category": "section",
    "text": "Use clip() to turn the current path into a clipping region, masking any graphics outside the path. clippreserve() keep the current path, but also use it as a clipping region. clipreset() resets it. :clip is also an action for drawing commands like circle().clip\nclippreserve\nclipresetThis example loads a file containing a function that draws the Julia logo. It can create paths but doesn't necessarily apply an action them; they can therefore be used as a mask for clipping subsequent graphics:(Image: julia logo mask)# load functions to draw the Julia logo\ninclude(\"../test/julia-logo.jl\")\n\ncurrentwidth = 500 # pts\ncurrentheight = 500 # pts\nDrawing(currentwidth, currentheight, \"/tmp/clipping-tests.pdf\")\n\nfunction draw(x, y)\n    foregroundcolors = diverging_palette(rand(0:360), rand(0:360), 200, s = 0.99, b=0.8)\n    gsave()\n    translate(x-100, y)\n    julialogo(false, true)      # add paths for logo\n    clip()                      # use paths for clipping\n    for i in 1:500\n        sethue(foregroundcolors[rand(1:end)])\n        circle(rand(-50:350), rand(0:300), 15, :fill)\n    end\n    grestore()\nend\n\norigin()\nbackground(\"white\")\nsetopacity(.4)\ndraw(0, 0)\n\nfinish()\npreview()"
},

{
    "location": "index.html#Luxor.readpng",
    "page": "Current status",
    "title": "Luxor.readpng",
    "category": "Function",
    "text": "Read a PNG file into Cairo.\n\nreadpng(pathname)\n\nThis returns a Cairo.CairoSurface, suitable for placing on the current drawing with placeimage(). You can access its width and height properties.\n\nimage = readpng(\"/tmp/test-image.png\")\nw = image.width\nh = image.height\n\n\n\n"
},

{
    "location": "index.html#Luxor.placeimage",
    "page": "Current status",
    "title": "Luxor.placeimage",
    "category": "Function",
    "text": "Place a PNG image on the drawing.\n\nplaceimage(img, xpos, ypos)\n\nPlace an image previously loaded using readpng().\n\n\n\nPlace a PNG image on the drawing using alpha transparency.\n\nplaceimage(img, xpos, ypos, 0.5) # alpha\n\nPlace an image previously loaded using readpng().\n\n\n\n"
},

{
    "location": "index.html#Images-1",
    "page": "Current status",
    "title": "Images",
    "category": "section",
    "text": "There is some limited support for placing PNG images on the drawing. First, load a PNG image using readpng(filename).readpngThen use placeimage() to place a loaded PNG image by its top left corner at point x/y or pt.placeimage(Image: \"Images\")img = readpng(filename)\nplaceimage(img, xpos, ypos)\nplaceimage(img, pt::Point)\nplaceimage(img, xpos, ypos, 0.5) # use alpha transparency of 0.5\nplaceimage(img, pt::Point, 0.5)\n\nimg = readpng(\"examples/julia-logo-mask.png\")\nw = img.width\nh = img.height\nplaceimage(img, -w/2, -h/2) # centered at pointImage clipping is possible:using Luxor\n\nwidth, height = 4000, 4000\nmargin = 500\n\nDrawing(width, height, \"/tmp/cairo-image.pdf\")\norigin()\nbackground(\"grey25\")\n\nsetline(5)\nsethue(\"green\")\n\nimage = readpng(\"examples/julia-logo-mask.png\")\nw = image.width\nh = image.height\n\nx = (-width/2) + margin\ny = (-height/2) + margin\n\nfor i in 1:36\n    circle(x, y, 250, :stroke)\n    circle(x, y, 250, :clip)\n    gsave()\n    translate(x, y)\n    scale(.95, .95)\n    rotate(rand(0.0:pi/8:2pi))\n\n    placeimage(image, -w/2, -h/2)\n\n    grestore()\n    clipreset()\n    x += 600\n    if x > width/2\n        x = (-width/2) + margin\n        y += 600\n    end\nend\n\nfinish()\npreview()"
},

{
    "location": "index.html#Luxor.Turtle",
    "page": "Current status",
    "title": "Luxor.Turtle",
    "category": "Type",
    "text": "Turtle lets you run a turtle doing turtle graphics.\n\nOnce created, you can command it using the functions Forward, Turn, Circle, Orientation, Rectangle, Pendown, Penup, Pencolor, Penwidth, and Reposition.\n\nThere are also some other functions. To see how they might be used, see Lindenmayer.jl.\n\n\n\n"
},

{
    "location": "index.html#Luxor.Forward",
    "page": "Current status",
    "title": "Luxor.Forward",
    "category": "Function",
    "text": "Forward: the turtle moves forward by d units. The stored position is updated.\n\nForward(t::Turtle, d)\n\n\n\n"
},

{
    "location": "index.html#Luxor.Turn",
    "page": "Current status",
    "title": "Luxor.Turn",
    "category": "Function",
    "text": "Turn: increase the turtle's rotation by r radians. See also Orientation.\n\nTurn(t::Turtle, r)\n\n\n\n"
},

{
    "location": "index.html#Luxor.Circle",
    "page": "Current status",
    "title": "Luxor.Circle",
    "category": "Function",
    "text": "Circle: draw a filled circle centred at the current position with the given radius.\n\nCircle(t::Turtle, radius)\n\n\n\n"
},

{
    "location": "index.html#Luxor.Orientation",
    "page": "Current status",
    "title": "Luxor.Orientation",
    "category": "Function",
    "text": "Orientation: set the turtle's orientation to r radians. See also Turn.\n\nOrientation(t::Turtle, r)\n\n\n\n"
},

{
    "location": "index.html#Luxor.Rectangle",
    "page": "Current status",
    "title": "Luxor.Rectangle",
    "category": "Function",
    "text": "Rectangle: draw a filled rectangle centred at the current position with the given radius.\n\nRectangle(t::Turtle, width, height)\n\n\n\n"
},

{
    "location": "index.html#Luxor.Pendown",
    "page": "Current status",
    "title": "Luxor.Pendown",
    "category": "Function",
    "text": "Pendown. Put that pen down and start drawing.\n\nPendown(t::Turtle)\n\n\n\n"
},

{
    "location": "index.html#Luxor.Penup",
    "page": "Current status",
    "title": "Luxor.Penup",
    "category": "Function",
    "text": "Penup. Pick that pen up and stop drawing.\n\nPenup(t::Turtle)\n\n\n\n"
},

{
    "location": "index.html#Luxor.Pencolor",
    "page": "Current status",
    "title": "Luxor.Pencolor",
    "category": "Function",
    "text": "Pencolor: Set the Red, Green, and Blue colors of the turtle:\n\nPencolor(t::Turtle, r, g, b)\n\n\n\n"
},

{
    "location": "index.html#Luxor.Penwidth",
    "page": "Current status",
    "title": "Luxor.Penwidth",
    "category": "Function",
    "text": "Penwidth: set the width of the line.\n\nPenwidth(t::Turtle, w)\n\n\n\n"
},

{
    "location": "index.html#Luxor.Reposition",
    "page": "Current status",
    "title": "Luxor.Reposition",
    "category": "Function",
    "text": "Reposition: pick the turtle up and place it at another position:\n\nReposition(t::Turtle, x, y)\n\n\n\n"
},

{
    "location": "index.html#Turtle-graphics-1",
    "page": "Current status",
    "title": "Turtle graphics",
    "category": "section",
    "text": "Some simple \"turtle graphics\" commands are included. Functions to control the turtle begin with a capital letter: Forward, Turn, Circle, Orientation, Rectangle, Pendown, Penup, Pencolor, Penwidth, and Reposition.(Image: Turtle)using Luxor, Colors\n\nDrawing(1200, 1200, \"/tmp/turtles.png\")\norigin()\nbackground(\"black\")\n\n# let's have two turtles\nraphael = Turtle(0, 0, true, 0, (1.0, 0.25, 0.25)) ; michaelangelo = Turtle(0, 0, true, 0, (1.0, 0.25, 0.25))\n\nsetopacity(0.95)\nsetline(6)\n\nPencolor(raphael, 1.0, 0.4, 0.2);       Pencolor(michaelangelo, 0.2, 0.9, 1.0)\nReposition(raphael, 500, -200);         Reposition(michaelangelo, 500, 200)\nMessage(raphael, \"Raphael\");            Message(michaelangelo, \"Michaelangelo\")\nReposition(raphael, 0, -200);           Reposition(michaelangelo, 0, 200)\n\npace = 10\nfor i in 1:5:400\n    for turtle in [raphael, michaelangelo]\n        Circle(turtle, 3)\n        HueShift(turtle, rand())\n        Forward(turtle, pace)\n        Turn(turtle, 30 - rand())\n        Message(turtle, string(i))\n        pace += 1\n    end\nend\n\nfinish()\npreview()Turtle\nForward\nTurn\nCircle\nOrientation\nRectangle\nPendown\nPenup\nPencolor\nPenwidth\nReposition"
},

{
    "location": "index.html#More-examples-1",
    "page": "Current status",
    "title": "More examples",
    "category": "section",
    "text": ""
},

{
    "location": "index.html#Sierpinski-triangle-1",
    "page": "Current status",
    "title": "Sierpinski triangle",
    "category": "section",
    "text": "(Image: Sierpinski)using Luxor, Colors\n\nfunction triangle(points::Array{Point}, degree::Int64)\n    global counter, cols\n    setcolor(cols[degree+1])\n    poly(points, :fill)\n    counter += 1\nend\n\nfunction sierpinski(points::Array{Point}, degree::Int64)\n    triangle(points, degree)\n    if degree > 0\n        p1, p2, p3 = points\n        sierpinski([p1, midpoint(p1, p2),\n                        midpoint(p1, p3)], degree-1)\n        sierpinski([p2, midpoint(p1, p2),\n                        midpoint(p2, p3)], degree-1)\n        sierpinski([p3, midpoint(p3, p2),\n                        midpoint(p1, p3)], degree-1)\n    end\nend\n\n@time begin\n    depth = 8 # 12 is ok, 20 is right out\n    cols = distinguishable_colors(depth+1)\n    Drawing(400, 400, \"/tmp/sierpinski.svg\")\n    origin()\n    setopacity(0.5)\n    counter = 0\n    my_points = [Point(-100,-50), Point(0,100), Point(100.0,-50.0)]\n    sierpinski(my_points, depth)\n    println(\"drew $counter triangles\")\nend\n\nfinish()\npreview()\n\n# drew 9841 triangles\n# elapsed time: 1.738649452 seconds (118966484 bytes allocated, 2.20% gc time)"
},

]}
