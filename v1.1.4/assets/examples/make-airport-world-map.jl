#!/usr/bin/env julia

using Shapefile, Luxor

include(joinpath(dirname(pathof(Luxor)), "readshapefiles.jl"))

function drawairportmap(outputfilename, countryoutlines, airportdata)
    Drawing(4000, 2000, outputfilename)
    origin()
    scale(10, 10)
    setline(1.0)
    fontsize(0.075)
    gsave()
    setopacity(0.25)
    for shape in countryoutlines.shapes
        randomhue()
        pgons, bbox = convert(Array{Luxor.Point, 1}, shape)
        for pgon in pgons
            poly(pgon, :fill)
        end
    end
    grestore()
    sethue("black")
    for airport in airportdata
        city, country, lat, long = split(chomp(airport), ",")
        location = Point(Meta.parse(long), -Meta.parse(lat)) # flip y-coordinate
        circle(location, .01, :fill)
        text(string(city), location.x, location.y - 0.02)
    end
    finish()
    preview()
end

worldshapefile = joinpath(dirname(pathof(Luxor)), "../docs/src/assets/examples/outlines-of-world-countries.shp")

airportdata = readlines(joinpath(dirname(pathof(Luxor)), "../docs/src/assets/examples/airports.csv"))

worldshapes = open(worldshapefile) do f
    read(f, Shapefile.Handle)
end

drawairportmap("/tmp/airport-map.pdf", worldshapes, airportdata)
