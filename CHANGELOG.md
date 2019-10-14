# Changelog

## [v1.7.0] - 14 October 2019

### Added

- @draw (thanks hr0m m3m0ry!)

### Changed

- initnoise() is correctly seedable
- center3pts() changed
- use of realpath() in test removed - it seems error-prone
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
