# Changelog

## [v4.6] - forthcoming

### Added
- `movepath()`
- `scalepath()`
- additional alignment options for `text()`: `hoffset`, `voffset`, `toffset`, and `noffset`

### Changed

- Fixed method ambiguities that Julia nightly 1.14.0-DEV.2604 introduced, and that Aqua started finding.
- small modifications to Typst support to keep up with Typstry.jl changes
- PolygonAlgorithms to version 0.5

---

## [v4.5] - 2026-04-09

### Added
- Easing functions for `rescale()`

### Changed
- Compat entry for PolygonAlgorithms 0.4

---

## [v4.4.1] - 2026-01-25

### Changed
- Compat entry for PolygonAlgorithms
- Colorant parsing in `mesh.jl`

---

## [v4.4] - 2025-11-08

### Added
- `roundcorner()`

### Changed
- Compat entries

---

## [v4.3] - 2025-05-17

### Added
- `text(ts::TypstString, pos::Point)` and `render_typst_document(ts::TypstString)`, using Typstry.jl for text typesetting

### Changed
- Minimum Julia version raised to 1.10+

---

## [v4.2] - 2025-02-21

### Added
- `polyxor()`, `polydifference()`, `polyunion()`

---

## [v4.1] - 2024-07-31

### Added
- Triangular grids
- `squirclepath()`
- `rule(pt1, pt2)`
- `polysidelengths()`

---

## [v4.0] - 2024-04-15

**Breaking release compared with v3.8.**

Some "invalid" `Point` methods have been removed:
- Broadcasting on xy-elements like `Point(x, y) .+ n` is no longer valid. Use `Point(x, y) + Point(n, n)`.
- `Point`-`Real` arithmetic operations such as `Point(x, y) + n` are also no longer valid.

LaTeX support is still under development. See [JuliaGraphics/Cairo.jl#357](https://github.com/JuliaGraphics/Cairo.jl/pull/357).

### Added
- `textformat()`
- `polysmooth()` has a `close` option
- `markcells()` and `getcells()`
- Package extension used for LaTeX support
- CompatHelper GitHub workflow added
- Aqua.jl testing added
- `createmovie` option for `animate` to make MKV and MP4 videos
- `polybspline` draws bspline polygons

### Changed
- Minimum Julia version 1.9
- Fixes for `drawpath(p, f)` to do Bezier curve truncation better
- Added dependency on PolygonAlgorithms.jl and replaced poly intersection routines
- TOML deps reordered alphabetically per Aqua
- Removed `@assert` statements
- Documentation now built at [JuliaGraphics/LuxorManual](https://github.com/JuliaGraphics/LuxorManual)
- Fixed bug in `box(pt, w, h, cr, :path)` (no longer creates a new path)
- Removed some invalid `Point` methods (#294)
- `between` has more methods for ranges and arrays

### Removed
- Invalid `Point` methods such as `Point(1, 3) + 6` or `Point(1, 3) .+ 4`

---

## [v3.8.0] - 2023-09-08

LaTeX support is still under development. See [JuliaGraphics/Cairo.jl#357](https://github.com/JuliaGraphics/Cairo.jl/pull/357).

### Added
- `setfillrule()` / `getfillrule()`, access Cairo's fill rule parameter
- `circlering()`, creates a ring of circles inside a circle
- `polysuper()`, creates superellipse-based polygons
- `tidysvg(fromfile, tofile)`, munges SVG glyphs
- `placeeps()`, place EPS files
- Dependency on DataStructures.jl added

### Changed
- Reorganized the benchmarks folder
- `circle()` constructed more carefully with four arcs (thanks @hyrodium, #268)
- Point arithmetic fix (thanks @j-maffe, #270)

---

## [v3.7.0] - 2023-02-04

LaTeX support is still under development. See [JuliaGraphics/Cairo.jl#357](https://github.com/JuliaGraphics/Cairo.jl/pull/357).

### Added
- Code to handle SVG backgrounds (thanks @oheil and @hustf, [#150](https://github.com/JuliaGraphics/Luxor.jl/issues/150))
- `getline()` gets current line width
- `getcolor()` gets current color
- Multiply `Point` by a 3×3 matrix using `*`

### Changed
- Added more information to docstrings and tutorials

---

## [v3.6.0] - 2022-12-11

LaTeX support is still under development. See [JuliaGraphics/Cairo.jl#357](https://github.com/JuliaGraphics/Cairo.jl/pull/357).

### Added
- `bezigon()`
- `Base.show(f::IO, ::MIME"image/svg+xml")` modifies glyph ids in notebooks to avoid the "Jupyter cells leak" problem ([details](https://github.com/MakieOrg/Makie.jl/issues/952#issuecomment-842413678))
- `polyclip()`, clips one polygon with another convex polygon
- `ispointonleftonline()`
- `rotatepoint()` as a clearer name for `rotate_point_around_point()` (thanks @gantz-giraffe)

### Changed
- `precompile.jl` switched to use SnoopPrecompile
- `hexspiral()` now counts from 1, not 0 or 2
- Fixed positioning bug in `textpath()`
- Placing images now uses premultiplied alpha value
- Fixed bug in `pointcrossesboundingbox()`

### Deprecated
- `rotate_point_around_point()` — use `rotatepoint()` instead

---

## [v3.5.0] - 2022-07-28

### Added
- Drawing image buffer and drawing indices (thanks @oheil)
- Thread safety (thanks @oheil)
- Action dispatcher (thanks @ArbitRandomUser)

### Changed
- Fixed `hexspiral` to work on v1.7 and earlier
- Adapted to changes made in MathTeXEngine release 0.5.0

---

## [v3.4.0] - 2022-07-13

### Added
- `BoundingBox()` can be used on Tables and table cells (needs tests)
- Hexagon constructors

### Changed
- Fixed `drawpath()` straight lines (thanks @jules)
- Added return values for some path functions
- Fixed obscure bug in `polyportion()` for closed polygons

### Removed
- Some old unused code

---

## [v3.3.0] - 2022-06-01

### Changed
- `textfit()` algorithm revisited; quicker now
- `polymorph()` keywords changed
- `polymorph()` can now also morph between open polygons
- Minimum Julia version is now 1.6
- Docs now built on Linux (for LaTeX purposes)

### Removed
- Support for Julia v1.3; minimum version is now Julia 1.6

---

## [v3.2.0] - 2022-04-05

### Added
- First attempt at `polymorph()`
- `hcat()` and `vcat()` can join SVG drawings (thanks @davibarreira)
- Another method for `perpendicular()`

### Changed
- Check for problematic corners in `polysmooth()` (thanks @arbitrandomuser)
- More LaTeX characters supported (thanks @davibarreira)
- Fixed bug in `ngon()`-vertices-reversepath
- `BoundingBox(path)` calculates more precisely (fixes #213)

---

## [v3.1.1] - 2022-03-06

### Changed
- Fixed imports in `latex.jl`

---

## [v3.1.0] - 2022-02-26

### Added
- `drawpath()` progressive path drawing
- `trimbezier()` and `splitbezier()`
- `pathsample()`, like `polysample()` but for paths
- More LaTeX characters (thanks @davibarreira)
- `AbstractPoint` (thanks @gpucce)

### Changed
- Docs now force-push to gh-pages
- LaTeX text strings can also be paths (except new LaTeX characters)
- Tidier Bezier arrows; may fix #200

---

## [v3.0.0] - 2022-01-23

### Added
- Dependency on LatexStrings
- `Luxor.get_current_hue()` and `Luxor.get_current_color()`

### Changed
- Shape-making functions such as `circle`/`ellipse`/`rect` now return useful values instead of Booleans, usable as arguments to `BoundingBox()` (for @TheCedarPrince)
- Switched to the Graham Scan algorithm for `polyhull()`
- Allow user to change tolerance for `isapprox()`
- Exported `determinant3()`

---

## [v2.19.0] - 2022-01-03

### Added
- LaTeX strings for `text()` — work by @davibarreira, @Kolaru, and @TheCedarPrince
- Leading option for `textfit()`
- `BoundingBox()` for stored Path objects
- `textonpoly()` places text along a polygon's route

---

## [v2.18.0] - 2021-12-18

### Added
- Support for VSCode
- `textfit()` fits text inside a bounding box (first attempt)
- `polyhull()` (thanks @thecedarprince)

### Changed
- Method for `arc(0, 0, action)` fixes #184
- Fixed bug in `simplify()` #186 (thanks @Wikunia)

### Removed
- Support for 32-bit Windows, since (r)svg doesn't work there

---

## [v2.17.0] - 2021-11-05

### Added
- `Path` type to hold a Cairo path; `makepath()`, `drawpath()`, `polytopath()`, `bezierpathtopath()`

### Changed
- Fixed `squircle()` `rt` keyword default bug
- `textpath()` gained action and alignment options
- Fixed `prettypoly()` action keyword argument
- Fixed `pointcrossesboundingbox()` bug (thanks @hustf)
- `beziersegmentangles()` handles special cases

### Removed
- Dependency on ImageMagick

---

## [v2.16.0] - 2021-10-07

### Changed
- Many functions now accept `action=` keyword arguments as well as positional ones
- Adjusted `offsetpoly(... function)` algorithm
- Added `include_first` kwarg to `polysample()`
- Rewrote `texttrack()` so alignment works correctly

---

## [v2.15.0] - 2021-08-20

### Added
- Method for `randompointarray()` to generate Poisson-disk-sampled points
- `initnoise()` can use another RNG (thanks @JeffreyPalmer)
- `add_mesh_patch()` to add more patches to a mesh
- `setblendextend()` to set blend (pattern) extend modes

### Changed
- Small hyphenation fix in `textwrap()`
- `box(pt, w, h, radii)` can specify different radii per corner
- `rect()` and `box()` gained reversepath options
- Added `Base.getindex(p::Point, i) = (p.x, p.y)[i]`
- `arrow(pt, radius...)` heads better aligned to the shaft
- `box-[top|middle|bottom]-[left|center|right]()` functions default to the drawing's bounding box

---

## [v2.14.0] - 2021-07-20

### Added
- `setstrokescale()` to enable/disable stroke scaling
- `ispointonpoly()` — true if a point lies on a polygon (default atol=10e-5)
- `tickline()` — spaced points
- `rotate_point_around_point()`

### Changed
- `Drawing()` takes a boolean `strokescale` argument to enable/disable stroke scaling (thanks @JeffreyPalmer)

---

## [v2.13.0] - 2021-07-06

### Added
- `crescent()`
- Anticlockwise arrows
- Custom arrowheads

### Changed
- `polyportion()`/`polyremainder()` now throw an error for single-point polygons
- `BoundingBox()` no longer fails without a drawing (returns a default value)
- Documentation restructured along Divio's documentation framework

---

## [v2.12.0] - 2021-06-12

### Added
- Alpha settings for image matrix (thanks @Sov-trotter)
- Dependency on FFMPEG.jl
- `@drawsvg`, `@savesvg`
- `svgstring()` to obtain the SVG source of a finished drawing as a string

### Changed
- FFMPEG code now runs the bundled version from FFMPEG.jl
- Fixed a test relying on random numbers that failed on v1.7

---

## [v2.11.0] - 2021-04-06

### Added
- Recording support (`:rec` and `snapshot()`) (thanks @hustf)

### Changed
- CI switched from Travis to `ci.yml`
- `texttrack()` switched to `textoutlines()`
- Fixed `beziersegmentangles()` bug
- Fixed bug in `isarcclockwise()` (thanks @johannes-fischer)

---

## [v2.10.0] - 2021-03-08

### Changed
- Fixed `ispolyconvex()` test
- Fixed `anglethreepoints()` to work correctly up to 360°
- `textoutlines()` `:center`-ed alignment brought in line with the 2.9.0 `text()` fix
- More macros allow variables (thanks Mateusz)

---

## [v2.9.0] - 2021-02-18

### Added
- `ellipseinquad()`, ellipse bounded by a quadrilateral
- `anglethreepoints()`, find the angle formed by three points
- `ispolyconvex()`, test if a polygon is convex
- `beziersegmentangles()`, construct Bézier using in/out angled handles

### Changed
- Fixed bug in `randompointarray()`
- `text()` `:center`-ed alignment calculated more carefully, accounting for various xadvance values (text may shift slightly left vs. earlier versions)
- BASE64 support added (thanks @fonsp)

---

## [v2.8.0] - 2021-02-02

### Added
- Rsvg support: `readsvg()`

### Changed
- `placeimage()` now accepts SVG files and SVG code (thanks @guo-yong-zhi, @schneiderfelipe)
- `placeimage()` now accepts a matrix of UInt32
- Minimum Julia version is 1.3
- `juliacircles()` gained stroke/clip action options
- Fixed algorithm for `center3pts` (thanks @hyrodium)

### Removed
- Support for Julia 1.0, 1.1, 1.2

---

## [v2.7.0] - 2021-01-07

### Added
- Triangle functions
- `perpendicular()` bisector
- Macros allow variables (thanks Mason)

### Changed
- Fixed text rotation/alignment issue (#122)

---

## [v2.6.0] - 2020-11-12

### Added
- Additional `offsetpoly()` methods for open polylines
- `image_as_matrix!()`, a reusable buffer variant

---

## [v2.5.1] - 2020-09-08

### Changed
- `image_as_matrix()`: reverted an accidental xy coordinate flip introduced in 2.5.0

---

## [v2.5.0] - 2020-09-06

### Added
- `getworldposition()`
- `polycross()`

### Changed
- Docs use JuliaMono
- Fixed `:clip` action in functions like `sector`/`box` that previously failed inside a `gsave()`/`grestore()` block; `:clip` actions now applied after

### Removed
- Some old deprecations

---

## [v2.4.0] - 2020-08-13

### Added
- `get_fontsize()`
- `currentdrawing()` to return the current drawing, if any

### Changed
- Fixed `show()` for new `Drawing()` (e.g. in the REPL)
- `background()` now preserves graphics state
- Fixed alpha bugs in `imagematrix()`

---

## [v2.3.0] - 2020-08-01

### Changed
- Imagematrix functions now return the permuted matrix
- Fixed `pointlinedistance()` to return correct results (thanks Paul)

---

## [v2.2.1] - 2020-07-14

### Added
- `precompile()`

### Changed
- Fixed `circlecircleinnertangents()` edge case

---

## [v2.2.0] - 2020-07-02

### Added
- `currentpoint()`, `has_current_point()`
- `pointcircletangent()`
- `circlecircleoutertangents()`
- `circlecircleinnertangents()`

---

## [v2.1.0] - 2020-06-18

### Added
- Centered option for `julialogo()`
- `tidysvg()` to hack glyph names in SVG files (probably temporary)
- Support for Pluto

### Changed
- Document handling code (for Pluto support)
- `julialogo()` tweaks to allow `:path` action
- `@svg` rendering modified (no glyphname hacking)

---

## [v2.0.0] - 2020-05-30

### Added
- Arrow decorations
- `:image` type, `image_as_matrix()`, `@imagematrix` to convert the current vector drawing to a matrix

### Changed
- Some `:nothing`s replaced with `:none`s
- Fixed `box` bugs where boxes were drawn when they shouldn't be

### Deprecated
- `bars()` — use `barchart()` instead

---

## [v1.12.0] - 2020-05-04

### Added
- `startnewpath` option for `textoutlines()`
- `unique` defined for Points
- Travis/Appveyor caching
- GIF preview in Juno

### Changed
- Attempted to keep arrow shafts from sticking out of arrowheads
- Internals of `rule` no longer use sets

---

## [v1.11.0] - 2020-02-18

### Added
- Add/subtract `Point` and related arithmetic improvements

### Changed
- Changed compatibility versions in Project.toml (Colors/Cairo)

---

## [v0.8.0] - 2017-02-17

- Compositing and miscellaneous additions
- Some changes for v0.6

---

## [v0.7.5] - 2017-01-26

- Tests pass on Windows
- Minor additions, e.g. hypotrochoids, another ellipse method

---

## [v0.7.1] - 2017-01-05

- Fixed docs on Travis to build the way they should have been

---

## [v0.7.0] - 2016-12-12

- Documentation updates

---

## [Unreleased] - 2014-11-24

- First commit
