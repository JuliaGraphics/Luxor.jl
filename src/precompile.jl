function _precompile_()
    precompile(Drawing, (String, String))
    precompile(Drawing, (Int, Int))
    precompile(Drawing, (Int, Int, String))
    precompile(Drawing, (Float64, Float64, String))
    precompile(Drawing, (Float64, Float64))
end
