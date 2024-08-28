# get current versions of packages from registry
# https://github.com/JuliaLang/Pkg.jl/issues/3926

import Pkg: Pkg, API, Operations, Registry

function search(pkgname; min_version=v"0.0.0", max_version=nothing)
    registries = Registry.reachable_registries()
    reg_ind = findfirst(r -> r.name == "General", registries)
    reg = registries[reg_ind]
    pkguuids_in_registry = collect(keys(reg.pkgs))
    pkgnames_in_registry = [reg.pkgs[key].name for key in pkguuids_in_registry]

    pkgname_ind = findfirst(==(pkgname), pkgnames_in_registry)
    pkguuid = pkguuids_in_registry[pkgname_ind]

    reg_pkg = get(reg, pkguuid, nothing)  # Pkg.Registry.PkgEntry

    info = Registry.registry_info(reg_pkg)
    reg_compat_info = Registry.compat_info(info)
    versions = keys(reg_compat_info)
    versions = Base.filter(v -> !Registry.isyanked(info, v), collect(versions))
    versions_sorted = sort(versions, rev=true)

    # filter between min_version and max_version
    max_version = isnothing(max_version) ? maximum(versions_sorted; init=v"0") : max_version
    filter!(v -> min_version <= v <= max_version, versions_sorted)

    version_list = versions_sorted[1:min(3, length(versions_sorted))]
    pkg_url = info.repo

    # Prints what is shown above
    print("Package '$pkgname' ")
    println("$(join(version_list, ", ")) ... ")
    nothing
end

for pk in ["Aqua",
     #"Base64",
     "Cairo","Colors","DataStructures",
     #"Dates",
     "FFMPEG","FileIO","ImageIO","LaTeXStrings","MathTeXEngine","PolygonAlgorithms","PrecompileTools",
    #"Random",
     "Rsvg",
     #"Test"
     ]

    search(pk)
end 
