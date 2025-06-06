# Changelog

## [v4.3] - 2025-05-17

### Added

- `text(ts::TypstString, pos::Point)` and 
  `render_typst_document(ts::TypstString)` use Typstry.jl for text typesetting.

### Changed

- Julia 1.10+ 

### Removed

### Deprecated

# ───────────────────────────────────────────────────

## [v4.2] - 2025-02-21

### Added

- `polyxor()`, `polydifference()`, `polyunion()`

### Changed

### Removed

### Deprecated

# ───────────────────────────────────────────────────

## [v4.1] - 2024-07-31

### Added

- triangular grids
- `squirclepath()`
- `rule(pt1, pt2)`
- `polysidelengths()`

### Changed

### Removed

### Deprecated

# ───────────────────────────────────────────────────

## [v4.0] - 2024-04-15

### This is a breaking release compared with v3.8

Some 'invalid' `Point` methods have been removed:

- Broadcasting on xy-elements like `Point(x, y) .+ n` are no longer valid. Use `Point(x, y) + Point(n, n)`.

- `Point`-`Real` arithmetic operations such as `Point(x, y) + n` are also no longer valid.

LaTeX support is still under development. 
See https://github.com/JuliaGraphics/Cairo.jl/pull/357.

### Added

- `textformat()`
- `polysmooth()` has `close` option
- `markcells()` and `getcells()`
- use package extension for LaTeX support
- add CompatHelper git workflow
- add Aqua.jl testing
- `createmovie` option for `animate` to make MKV and MP4 videos
- `polybspline` draws bspline polygons

### Changed

- minimum Julia version 1.9
- fixes for `drawpath(p, f)` to do the Bezier curve truncation better
- added dependency PolygonAlgorithms.jl and replace poly intersection routines with new ones
- Aqua says TOML deps must be in alphabetical order :) 
- remove @assert statements
- documents now built to https://github.com/JuliaGraphics/LuxorManual
- fixed bug in `box(pt, w, h, cr, :path)` (don't create new path)
- removed some invalid Point methods (#294)
- `between` has more methods for ranges and arrays

### Removed

- invalid `Point` methods such as `Point(1, 3) + 6` or `Point(1, 3) .+ 4`

### Deprecated

# ───────────────────────────────────────────────────

## [v3.8.0] - 2023-09-08

LaTeX support is still under development. 
See https://github.com/JuliaGraphics/Cairo.jl/pull/357.

### Added

- `setfillrule()`, access Cairo's fill rule parameter
- `getfillrule()` ...
- `circlering()`, creates ring of circles inside a circle
- `polysuper()`, creates superellipse-based polygons
- `tidysvg(fromfile, tofile)`, munge those SVG glyphs
- `placeeps()`, place EPS files
- dependency on DataStructures.jl added 

### Changed

- rejigged benchmarks folder a bit
- `circle()` constructed more carefully with four arcs (thanks @hyrodium) #268
- Point arithmetic fix #270 (thanks @j-maffe)

### Removed

### Deprecated

# ───────────────────────────────────────────────────

## [v3.7.0] - 2023-02-04

LaTeX support is still under development. 
See https://github.com/JuliaGraphics/Cairo.jl/pull/357.

### Added

- code to handle svg backgrounds (thanks @oheil and @hustf!) 
  https://github.com/JuliaGraphics/Luxor.jl/issues/150

- `getline()` gets current line width

- `getcolor()` gets current color

-  multiply Point by 3×3 matrix using `*`

### Changed

- added more information to doc strings and tutorials

### Removed

### Deprecated

# ───────────────────────────────────────────────────

## [v3.6.0] - 2022-12-11

LaTeX support is still under development. 
See https://github.com/JuliaGraphics/Cairo.jl/pull/357.

### Added

- `bezigon()`
- the `Base.show(f::IO, ::MIME"image/svg+xml")` method that displays SVGs in notebooks modifies the glyph ids to avoid the familiar "Jupyter cells leak" problem (described [here](https://github.com/MakieOrg/Makie.jl/issues/952#issuecomment-842413678))
- `polyclip()` clips one poly with another convex polygon
- `ispointonleftonline()` used by ↑
- `rotatepoint()` is better name for `rotate_point_around_point()` (thanks @gantz-giraffe !)

### Changed

- changed precompile.jl to use SnoopPrecompile
- `hexspiral()` now counts from 1 not 0 (or 2)
- fixed positioning bug in `textpath()`
- placing images now uses premultiplied alpha value
- fixed bug in `pointcrossesboundingbox()`

### Removed

### Deprecated

- `rotate_point_around_point()` is now `rotatepoint()`
# ───────────────────────────────────────────────────

## [v3.5.0] - 2022-07-28 10:15

### Added

- drawing image buffer and drawing indices (thanks @oheil!)

- thread safety (thanks @oheil!)

- action dispatcher (thanks @ArbitRandomUser!)

### Changed

- fixed hexspiral to work on v1.7 and earlier

- some work to adapt to changes made in MathTeXEngine release 0.5.0

### Removed

### Deprecated

# ───────────────────────────────────────────────────

## [v3.4.0] - 2022-07-13 09:01:18

### Added

- BoundingBox() can be used on Tables and table cells (needs tests)

- hexagon constructors 

### Changed

- fix `drawpath()` straight lines (thanks @jules for spotting this!)

- add return values for some path functions

- fixed obscure bug in `polyportion()` if polygons were closed

### Removed

- some old unused stuff

### Deprecated

# ───────────────────────────────────────────────────

## [v3.3.0] - 2022-06-01 11:28:44

### Added

### Changed

- `textfit()` algorithm revisited; it's quicker, at least....
- `polymorph()` keywords changed
- `polymorph()` can now also morph between open polygons
- minimum Julia version is now 1.6
- there are still bugs/edgecases in `polyhull()` which I can't find/fix
- docs now built on Linux (for LaTeX purposes)

### Removed

- support for Julia v1.3, minimum version is now Julia 1.6.

### Deprecated

# ───────────────────────────────────────────────────
## [v3.2.0] - 2022-04-05 09:41:54

### Added

- first attempt at `polymorph()`
- `hcat()` and `vcat()` can join SVG drawings (thanks @davibarreira!)
- yet another method for `perpendicular()`

### Changed

- check for dodgy corners in `polysmooth()` (thanks @arbitrandomuser!)
- even more LaTeX characters (thanks @davibarreira!)
- bug in ngon()-vertices-reversepath fixed
- `BoundingBox(path)` calculates boundingbox more precisely (fixes #213)

### Removed

### Deprecated

# ───────────────────────────────────────────────────

## [v3.1.1] - 2022-03-06

### Added

### Changed

- imports in latex.jl

### Removed

### Deprecated

# ───────────────────────────────────────────────────

## [v3.1.0] - 2022-02-26

### Added

- drawpath() progressive path drawing
- trimbezier() and splitbezier()
- pathsample() like polysample() for paths, but different
- more LaTeX characters (thanks @davibarreira!)
- AbstractPoint (thanks Giovanni @gpucce!)

### Changed

- docs now forcepush to gh-pages
- latex text strings can also be paths (except the new LaTeX characters)
- Bezier arrows are now a bit tidier might fix #200

### Removed

### Deprecated

# ───────────────────────────────────────────────────

## [v3.0.0] -  2022-01-23

### Added

- dependency on LatexStrings

- `Luxor.get_current_hue()` and `Luxor.get_current_color()`

### Changed

- the shape-making functions such as
  `circle`/`ellipse`/`rect` now return 'useful' values
  instead of Booleans. These values can usually be used as
  arguments to `BoundingBox()`. (for @TheCedarPrince :))

- switched to Graham Scan algorithm for `polyhull()`

- allow user to change tolerance for `isapprox()`

- export `determinant3()`

### Removed

### Deprecated

# ───────────────────────────────────────────────────

## [v2.19.0] - 2022-01-03

### Added

- LaTeX strings for `text()` - amazing work by @davibarreira, @Kolaru, and @TheCedarPrince - Thanks!

- leading option for `textfit()`

- `BoundingBox()` for stored Path objects

- `textonpoly()` can put text on the route of a polygon

### Changed

### Removed

### Deprecated

# ───────────────────────────────────────────────────
## [v2.18.0] - 2021-12-18

### Added

- code to support VSCode

- textfit() fits text inside bounding box, first attempt

- polyhull() - @thecedarprince (Hi Jacob!) convinced me it was useful :)

### Changed

- method for `arc(0, 0, action)` fixes #184

- bug in simplify() #186 (thanks Ole @Wikunia!)

### Removed

- support for 32-bit Windows - (r)svg doesn't work

### Deprecated

# ───────────────────────────────────────────────────

## [v2.17.0] - 2021-11-05

### Added

- Path type to hold a Cairo Path; `makepath`(), `drawpath`(), `polytopath`(), `bezierpathtopath`()

### Changed

- squircle() rt keyword default bug fixed
- textpath() method has action and alignment options
- prettypoly() fix action keyword arg
- pointcrossesboundingbox() fix bug (thanks @hustf!)
- beziersegmentangles() attend to special cases

### Removed

- dependency on ImageMagick

### Deprecated

# ───────────────────────────────────────────────────

## [v2.16.0] - 2021-10-07

### Added

### Changed

- many functions can now accept `action=` keyword arguments as well as positional ones
- offsetpoly(... function) algorithm altered (it still sucks, though :))
- `include_first` kwarg added to `polysample()`
- texttrack() rewritten so that the alignment works

### Removed

### Deprecated

# ───────────────────────────────────────────────────

## [v2.15.0] - 2021-08-20

### Added

- added method to randompointarray() to generate Poisson-disk-sampled points
- initnoise() can use other RNG (thanks @JeffreyPalmer!)
- add_mesh_patch() to add more patches to a mesh
- setblendextend() to allow set blend (pattern) extend modes

### Changed

- small change in hyphenation code in textwrap(), still not perfect though
- box(pt, w, h, radii) - can specify different radii for each corner
- rect() and box() have reversepath options
- Base.getindex(p::Point, i) = (p.x, p.y)[i]
- arrow(pt, radius...) - heads are hopefully better aligned to the shaft
- box-[top|middle|bottom]-[left|center|right]() functions default to using the drawing's bbox.

### Removed

### Deprecated

# ───────────────────────────────────────────────────

## [v2.14.0] - 2021-07-20

### Added

- setstrokescale() - enable/disable stroke scaling
- ispointonpoly() - true if point lies on polygon (default atol=10e-5)
- tickline() - spaced points
- rotate_point_around_point()

### Changed

- Drawing() takes a boolean named argument `strokescale` to enable/disable stroke scaling (thanks @JeffreyPalmer!)

### Removed

### Deprecated

# ───────────────────────────────────────────────────

## [v2.13.0] - 2021-07-06

### Added

- crescent()
- anticlockwise arrows
- custom arrowheads

### Changed

- `polyportion()`/`polyremainder()` now throw error for single-point polys (duh)
- BoundingBox() no longer fails if there's no drawing (returns a default value)
- documentation restructured along divio ("grand unified theory of documentation" lines

### Removed

### Deprecated

# ───────────────────────────────────────────────────

## [v2.12.0] - 2021-06-12

### Added

- Allow alpha settings for image matrix (thanks @Sov-trotter!)
- add dependency on FFMPEG.jl
- add @drawsvg @savesvg
- add `svgstring()` to obtain the SVG source of a finished SVG drawing as a string

### Changed

- FFMPEG code changed to run bundled version from FFMPEG.jl
- changed a test that used random numbers and failed on v1.7

### Removed

### Deprecated

# ───────────────────────────────────────────────────

## [v2.11.0] - 2021-04-06

### Added

- recording (`:rec` and `snapshot()`) (thanks @hustf!)

### Changed

- CI now ci.yml rather than travis
- texttrack() switch to textoutlines()
- beziersegmentangles() bug fixed
- bug in isarcclockwise() fixed (thanks @johannes-fischer!)

### Removed

### Deprecated

# ───────────────────────────────────────────────────

## [v2.10.0] - 2021-03-08

### Added

### Changed

- ispolyconvex() test changed to work properly
- anglethreepoints() changed to work up to 360° properly
- `textoutlines()` :center-ed alignments brought into line with 2.9.0 text() fix
- more macros allow variables (thanks Mateusz!)

### Removed

### Deprecated

# ───────────────────────────────────────────────────

## [v2.9.0] - 2021-02-18

### Added

- ellipseinquad() ellipse bounded by quadrilateral
- anglethreepoints() find angle formed by three points
- ispolyconvex() test if polygon is convex
- beziersegmentangles() construct Bézier using in out angled handles

### Changed

- bug in randompointarray() fixed
- `text()` :center-ed alignments are now more carefully
  calculated, allowing for various xadvance values. So there
  may be a few instances where text is positioned a few
  pixels further left compared with earlier Luxor versions.
- BASE64 added (thanks @fonsp!)

### Removed

### Deprecated

# ───────────────────────────────────────────────────

## [v2.8.0] - 2021-02-02

### Added

- Rsvg support: readsvg()

### Changed

- placeimage() now also accepts SVG files and SVG code (thanks guo-yong-zhi, schneiderfelipe)
- placeimage() now also accepts a matrix of UInt32
- minimum Julia version is 1.3
- juliacircles() has keyword options to allow stroke/clip actions
- algorithm for cener3pts fixed (thanks hyrodium)

### Removed

- support for Julia 1.0, 1.1, 1.2

### Deprecated

# ───────────────────────────────────────────────────

## [v2.7.0] - January 7 2021

### Added

- triangle functions
- perpendicular() bisector
- macros allow variables (thanks Mason!)

### Changed

- fixed text rotation/alignment issue (#122)

### Removed

### Deprecated

# ───────────────────────────────────────────────────

## [v2.6.0] - 12 November 2020

### Added

- additional methods for `offsetpoly()` for open polylines
- image_as_matrix!() - reusable buffer

### Changed

### Removed

### Deprecated

# ───────────────────────────────────────────────────

## [v2.5.1] - September 8 2020

### Added

### Changed

- image_as_matrix(): reverted accidental flip of xy coordinates introduced at 2.5.0 (sorry everyone!)

### Removed

### Deprecated

# ───────────────────────────────────────────────────

## [v2.5.0] - September 6 2020

### Added

- getworldposition()
- polycross()

### Changed

- docs use JuliaMono
- in a few functions (eg `sector`, `box`) a `:clip` action didn't work, because it was applied within a
`gsave()`/`grestore()` block. `:clip` actions should now work, as they're applied after.

### Removed

- some old deprecations finally gone

### Deprecated

# ───────────────────────────────────────────────────

## [v2.4.0] - August 13 2020

### Added

- get_fontsize() - thanks Ole!
- currentdrawing() function to return the current drawing if there is one

### Changed

- show() fixed for new Drawing() eg in REPL
- background() preserves graphics state
- imagematrix() bugs in alpha fixed hopefully

### Removed

### Deprecated

# ───────────────────────────────────────────────────

## [v2.3.0] - August 1 2020

### Added

### Changed

- imagematrix functions return the permuted matrix now

- pointlinedistance() now returns the correct results (thanks Paul!)

### Removed

### Deprecated

# ───────────────────────────────────────────────────

## [v2.2.1] - patch 14 July 2020

### Added

- precompile()

### Changed

- fix circlecircleinnertangents() edge case

### Removed

### Deprecated

# ───────────────────────────────────────────────────

## [v2.2.0] - 2 July 2020

### Added

- `currentpoint()`, `has_current_point()`
- `pointcircletangent()`
- `circlecircleoutertangents()`
- `circlecircleinnertangents()`

### Changed

### Removed

### Deprecated

# ───────────────────────────────────────────────────

## [v2.1.0] - 2020 June 18

### Added

- `julialogo()` centered option
- `tidysvg()` function to hack glyphnames in SVG files
  (probably a temporary thing)
- support for Pluto

### Changed

- document handling code (cf Pluto support)
- `julialogo()` tweaks to allow :path action
- @svg rendering modified (eg no glyphname hacking done)

### Removed

### Deprecated

# ───────────────────────────────────────────────────

## [v2.0.0] - 2020 May 30

### Added

- arrow decorations
- :image type, image_as_matrix(), @imagematrix to convert current vector drawing to matrix

### Changed

- some `:nothing`s replaced with `:none`s
- fixed some `box` bugs, when they were drawn when they shouldn't have been

### Removed

### Deprecated

- `bars()` - use `barchart()`

# ───────────────────────────────────────────────────

## [v1.12.0] - 2020 May 4

### Added

- `startnewpath` option for `textoutlines()`
- `unique` defined for Points
- Travis/Appveyor cache
- GIFs preview in Juno

### Changed

- attempt to make arrow shafts not stick out of arrow heads
- internals of rule doesn't use sets any more

### Removed

### Deprecated

# ───────────────────────────────────────────────────

## [v1.11.0] - 2020 February 18

- changed compatibility versions in Project.toml (Colors/Cairo)

### Added

- add/subtract Point to
