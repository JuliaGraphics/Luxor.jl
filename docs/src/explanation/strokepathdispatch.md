# Custom behavior for strokepath and fillpath 

If you would like to have some custom behavior for these functions (like say to
extract or modify the path just before drawing etc) `Luxor` provides a way to
do so.

The four functions are basically defined as 

`funcname() = funcname(DISPATCHER[1])`
and 
`funcname(::DefaultLuxor) = -do_some_cairo_things-`

`DISPATCHER[1]` is defined in luxor as an instance of a struct (with no fields)
`DefaultLuxor`. The datatype `DefualtLuxor` is a subtype of `LDispatcher`.
`DISPATCHER` as such is defined as an array of `LDispatcher`. This is to make
it mutable. Only the first element i.e `DISPATCHER[1]` is ever used. 

One can make custom behavior for the functions by the following way.

	- Define a new struct `MyDispatcher <: Luxor.LDispatcher` (it needn't have any fields)
	- Define a function that dispatches on the above struct
	- Change `Luxor.DISPATCHER[1]` to an instance of your struct 


```julia

struct MyDispatcher <:  Luxor.LDispatcher end
Luxor.DISPATCHER[1] = MyDispatcher()

#an example of a strokepath that returns the current path as polys
function Luxor.strokepath(::MyDispatcher)
	polys = pathtopoly()
	Luxor.strokepath(Luxor.DefaultLuxor())
	return polys
end
```

This method now changes the behavior of all calls to  `strokepath` to 
return the current path as polys just before it draws to the canvas.
