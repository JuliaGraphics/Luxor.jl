# Changelog

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

## [v2.10.0] - 2021-03-08

### Added

### Changed

- ispolyconvex() test changed to work properly
- anglethreepoints() changed to work up to 360° properly
- `textoutlines()` :center-ed alignments brought into line with 2.9.0 text() fix
- more macros allow variables (thanks Mateusz!)

### Removed

### Deprecated

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

## [v2.7.0] - January 7 2021

### Added

- triangle functions
- perpendicular() bisector
- macros allow variables (thanks Mason!)

### Changed

- fixed text rotation/alignment issue (#122)

### Removed

### Deprecated

## [v2.6.0] - 12 November 2020

### Added

- additional methods for `offsetpoly()` for open polylines
- image_as_matrix!() - reusable buffer

### Changed

### Removed

### Deprecated

## [v2.5.1] - September 8 2020

### Added

### Changed

- image_as_matrix(): reverted accidental flip of xy coordinates introduced at 2.5.0 (sorry everyone!)

### Removed

### Deprecated

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

## [v2.3.0] - August 1 2020

### Added

### Changed

- imagematrix functions return the permuted matrix now

- pointlinedistance() now returns the correct results (thanks Paul!)

### Removed

### Deprecated

## [v2.2.1] - patch 14 July 2020

### Added

- precompile()

### Changed

- fix circlecircleinnertangents() edge case

### Removed

### Deprecated

## [v2.2.0] - 2 July 2020

### Added

- `currentpoint()`, `has_current_point()`
- `pointcircletangent()`
- `circlecircleoutertangents()`
- `circlecircleinnertangents()`

### Changed

### Removed

### Deprecated

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

## [v1.11.0] - 2020 February 18

- changed compatibility versions in Project.toml (Colors/Cairo)

### Added

- add/subtract Point to BoundingBox to shift it by that amount
- `strokefunction` argument added to `brush()`
- error checking for `readpng()` #81 (thanks Avik!)

### Changed

- operation of @pdf/svg/png/eps macros should now hopefully allow string interpolation in filenames, if my macro-fu has worked. So this should work:

    for i in 1:10
        @png begin
            circle(O, i, :fill)
        end 300 300 "/tmp/circle-$(i).png"
    end

- intersection2circles domain errors and negative output fixed (thanks casey & Júlio) 😊

### Removed

### Deprecated

## [v1.10.0] - January 2020

- changed compatibility versions in Project.toml (Colors/Cairo)

### Added

### Changed

### Removed

### Deprecated

## [v1.9.0] - December 2019

- changed compatibility versions in Project.toml

### Added

- Bezier `arrow()`s can also be defined by height of box

### Changed

### Removed

### Deprecated

## [v1.8.0] - 17 November 2019

### Added

- `arrow()` arrows can have decoration (arbitrary graphics) drawn at a location along the shaft

### Changed

- `pathtopoly()` revised
- generating docs on macOS again, now that Travis/Cairo/macOS is back to normal
- some `arrowhead` options renamed to be more consistent
- bug fixed in `box()` with rounded corners (Thanks Anthony!)
- mktempdir()

### Removed

### Deprecated

## [v1.7.0] - 14 October 2019

### Added

- @draw (thanks hr0m m3m0ry!)

### Changed

- initnoise() is correctly seedable
- center3pts() changed
- use of realpath() in test removed - it seems error-prone on recent macOS systems
- testing OpenType fonts in docs

### Removed

- seednoise()

### Deprecated

## [v1.6.0] - 19 August 2019

### Added

- polyintersect()
- polytriangulate()
- rand(bb::BoundingBox)
- in(pt, bb) aliases isinside(pt, bb)
- texttrack() does line-spacing
- @eps macro

### Changed

### Removed

### Deprecated

- polytriangulate!() -> polytriangulate()

## [v1.5.0] - July 25 2019

### Added

- `polyreflect!()`

- `polyscale!()` now can do scaling in h and v separately

- `pointcrossesboundingbox()` does something

- `mask()` does rectangular areas too

- `textbox()` and `textwrap()` return a position

- `rule()` has `vertices` option to return points rather than draw lines

### Changed

- `textwrap()` no longer inserts a blank line at the top

### Removed

### Deprecated

## [v1.4.0] - May 28 2019

### Added

- another method for `ellipse()` that takes three points
- `insertvertices!(pgon)` inserts a vertex into every edge of a polygon
- `julialogo()` option `bodycolor` to make light-colored logo for dark modes
- `mask()` does simple circular mask calculation

### Changed

- fixed bug in `ellipse()` (thanks @Ryngetsu!)
- fixed `polysortbyangle()`, `tan()` problems
- `julialogo()` and `juliacircles()` now produce new 3-color rather than 6-color circles

### Removed

### Deprecated

## [v1.3.0] - April 28 2019

### Added

- use Project.toml

- dimension() for dimensioning

- polymove!(), polyrotate!(), polyscale!() for really changing polygons

- intersectionlines() replaces intersection()

- animate() has new option to choose ffmpeg command

- Bezier (bidirectional) `arrow` method added

- Bezier easing function, `easeinoutbezier()` takes two normalized control points to control easing when animating

- arc2sagitta()/carc2sagitta() functions added

- isarcclockwise() added

- pointinverse() added

### Changed

- functions that used intersection() now use intersectionlines()

- more functions return points or arrays (or true) rather than unions of Booleans/points or nothing

- rescale(x, a, b) defaults to rescale(x, a, b, 0.0, 1.0)

- the `@pdf`, `@png`, and `@svg` macros allow you to omit the suffix/file extension

- All the noise-related code has been replaced. I discovered that the algorithm was patent-encumbered, so I've switched over to the OpenSimplexNoise algorithm. The advantage is that there's now 4D simplex noise. The disadvantages are that the new code is currently a bit slower, and (obviously) all the actual noise values produced for a specific set of inputs will be slightly different from v1.2.0. The file `src/patentednoise.jl` contains the old noise code.

### Removed

- much noise-related code

- polyselfintersections() removed, it didn't work at all

- REQUIRE

### Deprecated

- intersection() is deprecated, in favour of intersectionlines(). It should be
more reliable, and has fewer options/special cases for collinearity.

- seednoise() has changed

## [v1.2.0] - 2019-02-18

### Added

- more box functions take vertices=true/false
- added setdash(dashes)
- miscellaneous polygon functions tho they're largely untested and needing improvements
- eachindex for Table
- feature gallery illustration

### Changed

- tried to fix bugs in `rule()`
- settext() now rescales from 96dpi to 72dpi

### Removed

- Luxor.juliacolorsceheme, it's no longer compatible with ColorSchemes.jl

### Deprecated

-

## [v1.1.4] - 2019-01-12

### Added

- highlightcells()
- textoutlines()
- additional option for Scene to pass information

### Changed

- fixed bug in single cell tables
- shapefiles convert now has typed array declaration (oops)
- off-by-one bug in table iterator fixed (yikes!)
- logo and readme image

### Removed

-

### Deprecated

-

## [v1.1.3] - 2018-11-07

### Added

- BoundingBox access functions: boxtopleft(), boxtopcenter(),
  boxtopright(), boxmiddleleft(), boxmiddlecenter(),
  boxmiddleright(), boxbottomleft(), boxbottomcenter(),
  boxbottomright()

### Changed

- duplicate definition in tiler removed
- documenter support is now at 0.20
- use AbstractString rather than String

### Removed

-

### Deprecated

-

## [v1.1.2] - 2018-10-31

### Added

-

### Changed

- use eachindex more
- docs use more svg images
- changed preview() in Windows again

### Removed

-

### Deprecated

-

## [v1.1.1] - 2018-10-06

### Added

-

### Changed

- fixed display code to work in Jupyter
- rand() in all tests is seeded in advance to produce predictable output
- internal changes to fix type stability

### Removed

-

### Deprecated

-

## [v1.1.0] - 2018-10-04

### Added

- Luxor.initnoise()
- seednoise()

### Changed

- noise implementation revised

### Removed

### Deprecated

## [v1.0.0] - 2018-09-24

### Added

- circle/tangent functions
- noise

### Changed

- Travis documentation stage

### Removed

### Deprecated

## [v0.12.0] - 2018-08-17

- new version number for better compatibility with julia v1.0

### Added

- option for tempdirectory in `animate()`

### Changed

- `polysample()` has closed option restored
- .travis.yml tweaks - the saga continues
- `setcolor(colorant)` no longer drops the alpha if supplied
- `endof` replaced with `lastindex`
- `rule()` now draws lines across boundingbox, default to the drawing's boundingbox

### Removed

- `scale` is no longer in Base, so we don't need to import it

### Deprecated

## [v0.11.2] - 2018-08-04

### Added

- `polysample()`
- `Dates` prefix where required
- `midpoint()` and `between()` work on BoundingBoxes

### Changed

- `srand` to `Random.seed!`
- replaced Appveyor script from https://github.com/JuliaCI/Appveyor.jl
- adjusted with imports from Cairo in test scripts
- `end` in `mod1()`
- Point is `broadcastable`
- `preview()` now returns name of new file, unless in Juno/Jupyter

### Removed

- `fill()` removed, use fillpath
- `stroke()` removed, use strokepath
- `polybbox()` removed, use  boundingbox
- `bboxesintersect()` removed, use  boundingboxesintersect
- `norm()` removed, use  distance
- `dot()` removed, use  dotproduct
- `axes()` removed, use rulers

### Deprecated


## [v0.11.1] - 2018-07-29

### Added

- `boxmap()`

### Changed

- `mimewritable` to `showable`

### Removed

- Juno-specific code in "atom.jl"

### Deprecated


## [v0.11.0] - 2018-06-27

V0.7 release (first version)

### Added

- `rulers()`

### Changed
- iterators are now v0.7-style
- this version works only with Julia v0.7.0+

### Removed
- dropped LinearAlgebra dependency
- dropped Julia v0.6...

### Deprecated

- `norm(pt1::Point, pt2::Point)`` is now deprecated, to be replaced with `distance(pt1::Point, pt2::Point)``

- `dot(pt1::Point, pt2::Point)`` is now deprecated, to be replaced with `dotproduct(pt1::Point, pt2::Point)`

- `axes()` is now deprecated, to be replaced with `rulers()`

## [v0.10.6] - 2018-06-08

Misc updates and bug fixes for v0.6. Final release for v0.6, master is now v0.7 only.

### Added

- Bezier-handling functions
- `boxtop()`, `boxbottom()`

### Changed
- timestamped output files for @svg etc macros
- fixed premature close in `pathtobezierpaths()`

### Removed
-

## [v0.10.5] - 2018-04-09

Updates

### Added

- bounding boxes and related changes
- add polybbox()
- text() gets angle keyword
- label() gets rotation option)
### Changed
- table row/height types fixed
-

### Removed
-

## [v0.10.4] - 2018-03-01

Updates (still v0.6.2)

### Added

- added tables
- `textwrap()` gets leading option

### Changed
-

### Removed
-

## [v0.10.3] - 2018-02-08

Update for Cairo v0.5

### Added

- `squircle()` gets `stepby` option

### Changed
- `circle()` uses Cairo arcs now, not circles

### Removed
-

## [v0.10.2] - 2018-01-05

Bug fixes

Mostly bug fixes, including hopefully a fix for IJulia world age issue (#17)

### Added
-

### Changed
- IJulia preview code

### Removed
-

## [v0.9.3] - 2017-12-09

Bug fixes for Julia v0.5

### Added
-

### Changed
-

### Removed
-

## [v0.10.1] - 2017-11-24

More updates and bug fixes

### Added

- `textwrap()`/`textbox()`
- `textwrap()` function takes `linenumber` argument
- Bezier meshes

### Changed
- some bugs fixed eg turtle, polyremainder, mesh
- turtle tweaked

### Removed
-

## [v0.10.0] - 2017-10-24

Misc updates and bug fixes

### Added

- in-memory drawings (thanks, @barche)
- path to Bezierpath conversions
- tutorial in docs

### Changed
- minimum version is now Julia v0.6
- misc bugs fixed and added...

### Removed
-

## [v0.9.2] - 2017-09-26

Miscellaneous changes and documentation improvements

### Added
-

### Changed
- better type usage
- fix offsetpoly() bugs
- fix isinside() bugs

### Removed
-

## [v0.9.1] - 2017-08-29

### Added
-

### Changed
- Bug fixes backported from master for v0.6

### Removed
-

## [v0.9.0] - 2017-07-27

Final Julia v0.6 release (but it wasn't really)

### Added

- @pdf @svg and @pdf macros
- `polyarea()`
- `ngonside()`
- circle intersection: `intersection2circles()`
- polygon to Bezier path conversion
- bars()

### Changed

### Removed

- drop support for v0.4

## [v0.8.6] - 2017-06-19

ready for Julia v0.6

### Added

- box rounded corners
- spiral()

### Changed
- origin takes pos

### Removed
-

## [v0.8.5] - 2017-05-17

Support for Juno preview

### Added

- preview in Juno's PlotPane.
- scale single value
- epitrochoids

### Changed
-

### Removed
-

## [v0.8.4] - 2017-05-03

Animation and polygon additions

### Added

- `cropmarks()`
- `polyperimeter()`, `polydistances()`, `polyportion()`, `nearestindex()`
- try to display SVG in Jupyter

### Changed
- bug fixes

### Removed
-

## [v0.8.3] - 2017-03-30

patch for preview() function in Windows

### Added

- pathtopoly()
- perimeter utilities
- cropmarks()

### Changed
- This changes the preview() function to run better code for Windows.

### Removed
-

## [v0.8.2] - 2017-03-10

Julia v0.6 pre-release

### Added
-

### Changed
-

### Removed

### Deprecated
- fill()

## [v0.8.1] - 2017-03-06

Fixes for 0.5.1  and 0.6.x

### Added

- `rule()`

### Changed
- hex grids
- sector methods
- grids

### Removed
-

## [v0.8.0] - 2017-02-17

compositing and misc additions, some changes for v0.6

### Added

- compositing with `setmode()`
- grids

### Changed
-

### Removed
-

## [v0.7.5] - 2017-01-26

Tests pass on Windows

### Added

- hypotrochoids
- another ellipse method
- intersect()
- intersectionlinecircle()
- rounded sectors

### Changed
-

### Removed
-

## [v0.7.1] - 2017-01-05

-Make docs on Travis the way they should have been made
-Move to JuliaGraphics organization

### Added
-

### Changed
- the docs have been moved into the gh-pages branch

### Removed
-

## [v0.7.0] - 2016-12-12

v0.7.0 Documentation updates

### Added

- Jupyter preview PNG
- get_scale
- get_translation
- get_rotation
- between

### Changed
- prettypoly() has vertex labels

### Removed
-

## [v0.6.0] - 2016-10-31


### Added

- animation

### Changed
-

### Removed
-

## [v0.5.0] - 2016-10-12

### Added

- polyfit()
- circle() (path)
- offsetpoly()
- blend()
- blendadjust()

### Changed
-

### Removed
-

## [v0.4.0] - 2016-10-03

### Added

- arc2r()
- polysmooth()

### Changed
-

### Removed
-

## [v0.3.0] - 2016-09-20


### Added

- O shortcut

### Changed
- PNG files are transparent if no background
- origin() resets CTM

### Removed
-

## [v0.2.0] - 2016-09-09


### Added

- documentation, squircle(), arrow(), pie()

### Changed
- Tiler (was PageTiler)
- ngon() star() keyword arguments
- Point is immutable

### Removed
-

## [v0.1.0] - 2016-08-22

First release

### Added

- Drawing, currentdrawing, rescale, finish, preview, origin, axes, background,
  newpath, closepath, newsubpath, circle, rect, box, setantialias, setline,
  setlinecap, setlinejoin, setdash, move, rmove, line, rline, curve, arc, carc,
  ngon, ngonv, sector, do_action, stroke, fill, paint, paint_with_alpha,
  fillstroke,  poly, simplify, polybbox, polycentroid, polysortbyangle,
  polysortbydistance, midpoint, prettypoly,  star, starv, intersection,
  polysplit, strokepreserve, fillpreserve, gsave, grestore, scale, rotate, translate, clip, clippreserve, clipreset, isinside, getpath, getpathflat, pattern_create_radial, pattern_create_linear, pattern_add_color_stop_rgb, pattern_add_color_stop_rgba, pattern_set_filter, pattern_set_extend, fontface, fontsize, text, textpath, textextents, textcurve, textcentred, setcolor, setopacity, sethue, randomhue, randomcolor, @setcolor_str, getmatrix, setmatrix, transform, readpng, placeimage

### Changed
-

### Removed
-
