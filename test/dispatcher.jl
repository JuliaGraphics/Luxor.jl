using Luxor
import Luxor:strokepath,fillpath,strokepreserve,fillpreserve
using Test

struct NewDispatcher <: Luxor.LDispatcher end

function strokepath(::NewDispatcher)
    return "new strokepath"
end
function fillpath(::NewDispatcher)
    return "new fillpath"
end
function strokepreserve(::NewDispatcher)
    return "new strokepreserve"
end
function fillpreserve(::NewDispatcher)
    return "new fillpreserve"
end


Luxor.DISPATCHER[1] = NewDispatcher()

@test Luxor.strokepath() == "new strokepath"
@test Luxor.fillpath() == "new fillpath"
@test Luxor.fillpreserve() == "new fillpreserve"
@test Luxor.strokepreserve() == "new strokepreserve"

#check if setting back gets default behavior
Luxor.DISPATCHER[1] = Luxor.DefaultLuxor()

function drawthings(fname)
    Drawing(1000,1000,fname)
    circle(O,100,:fillpreserve)
    sethue("red")
    circle(O,200,:stroke)
    circle(O+200,100,:strokepreserve)
    sethue("red")
    fillpath()
    @test finish() == true
    println("... finished dispatcher test , saved in $(fname)")
end

fname = "dispatcher_test.png"
drawthings(fname)
