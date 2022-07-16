# Custom behavior for strokepath and fillpath 

If you would like to have some custom behavior for these functions (like say to
extract or modify the path just before drawing etc) `Luxor` provides a way to
do so.

The four functions `strokepath`,`strokepreserve`,`fillpath`,`fillpreserve`, are
basically defined as 

`funcname() = funcname(DISPATCHER[1])`
and 
`funcname(::DefaultLuxor) = -do_some_cairo_things-`

`DISPATCHER[1]` is defined in luxor as an instance of a struct (with no fields)
`DefaultLuxor`. The datatype `DefualtLuxor` is a subtype of `LDispatcher`.
`DISPATCHER` as such is defined as an array of `LDispatcher`. This is to make
it mutable. Only the first element i.e `DISPATCHER[1]` is ever used. 

One can make custom behavior for the functions by the following way.

	- Define a new struct `MyDispatcher <: Luxor.LDispatcher` (it needn't have
	  any fields)
	- Define a function that dispatches on the above struct
	- Change `Luxor.DISPATCHER[1]` to an instance of your struct 


The following is an example of a that changes the behavior of all calls to
`strokepath()` to return the current path as polys just before it draws to the
canvas.

```julia

struct MyDispatcher <:  Luxor.LDispatcher end

function Luxor.strokepath(::MyDispatcher)
	polys = pathtopoly()
	Luxor.strokepath(Luxor.DefaultLuxor())
	return polys
end

Luxor.DISPATCHER[1] = MyDispatcher()
```
