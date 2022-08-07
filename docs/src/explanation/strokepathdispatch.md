# Custom behavior for strokepath and fillpath 

There are four functions that "paint" the current path to the drawing:
they are `strokepath` , `strokepreserve` , `fillpath`, and `fillpreserve`.
Other mechanisms to draw on the canvas are `clip` , `clippreserve` and `paint`.
(`text` is another function that draws on the canvas but is not considered here)

If you would like to have some custom behavior for these functions, such as adding a way to extract or modify paths etc.), Luxor provides a way to do so.

These four functions are basically defined as: 

`funcname() = funcname(DISPATCHER[1])`
`funcname(::DefaultLuxor) = {...do_some_graphics_work...}`
`funcname(::LDispatcher) = funcname(DefaultLuxor())`

`DISPATCHER[1]` is defined as an instance of a struct (with no fields) 
`DefaultLuxor`. The datatype `DefaultLuxor` is a subtype of `LDispatcher`.
`DISPATCHER` as such is defined as an array of `LDispatcher`. This is to make
it mutable. Only the first element ie. `DISPATCHER[1]` is ever used. 

You can make custom behavior for the functions in the following way:

1 Define a new struct `MyDispatcher <: Luxor.LDispatcher` (it needn't have any fields).

2 Define a function that dispatches on the above struct.

3 Change `Luxor.DISPATCHER[1]` to an instance of your struct. 

Here's an example of a method that changes the behavior of all calls
to `strokepath()` such that the current color is printed to the terminal as the path is drawn.

```julia
struct MyDispatcher <: Luxor.LDispatcher end
function Luxor.strokepath(::MyDispatcher)
    println("$(Luxor.get_current_color())")
	return Luxor.strokepath(Luxor.DefaultLuxor())
end
Luxor.DISPATCHER[1] = MyDispatcher()

@draw begin
    for i in 1:20
        randomhue()
        star(rand(BoundingBox()), 30, 6, 0.5, action = :stroke)
    end
end
```

Now, all calls to `strokepath()` whether explicitly called or through other
functions (for example, with the :stroke action) will print the current color 
just before the path is stroked.

Similar dispatches can be written for `strokepreserve`, `fillpath`,
`fillpreserve`, `clip`, `clippreserve`, and `paint`. 

Functions which don't have methods defined for the types will default
to calling `funcname(Luxor.DefaultLuxor())`
