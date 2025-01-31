module luxorgraphtools
    export CanvasConfig
    export PlottingArea
    export lit_defaultcolorpalette
    export lit_convert_x_imagecoor_to_cartesiancoor
    export lit_convert_y_imagecoor_to_cartesiancoor
    export lit_convert_xy_imagecoor_to_cartesiancoor
    export lit_convert_x_cartesiancoor_to_imagecoor
    export lit_convert_y_cartesiancoor_to_imagecoor
    export lit_convert_xy_cartesiancoor_to_imagecoor
    export lit_convert_cartesianpoint_to_imagepoint_noncenter
    export lit_convert_cartesianpoint_to_imagepoint_center
    export lit_convert_cartesianpoint_to_imagepoint_noncenter_as_center
    export lit_cartesianpoint_noncenter
    export lit_cartesianpoint_center
    export lit_cartesianpoint_noncenter_as_center
    export lit_RotationMatrix2D
    export lit_ScaleMatrix2D
    export lit_TranslationMatrix2D
    export lit_CartTranslationMatrix2D
    export lit_ReflectXaxisMatrix2D
    export lit_ReflectYaxisMatrix2D
    export lit_SetFakeCartesianSystem
    export lit_FakeCartesianSystemMatrix2D
    export lit_CalcPlottingArea
    export lit_CalcInternalPlottingArea
    export lit_ConvertInternalPlottingAreaToCartesian
    export lit_calc_physical_y_in_graph
    export lit_graphfuncplot
    export lit_graphseriesplot
    export lit_SetInternalPlottingAreaMatrix
    export lit_create_graph_xticks
    export lit_create_graph_yticks
    export lit_create_graph_title
    export lit_create_X_axis_title
    export lit_create_Y_axis_title
    export lit_convert_graph_xvalue_to_image_xcoor
    export lit_convert_graph_xvalue_to_cart_xcoor
    export lit_convert_graph_yvalue_to_image_ycoor
    export lit_convert_graph_yvalue_to_cart_ycoor
    export lit_graph_arrow_text_cart
    export lit_graph_arrow_text_cart_NE
    export lit_graph_arrow_text_cart_SE
    export lit_graph_arrow_text_cart_W
    export lit_graph_arrow_text_cart_NW
    export lit_graph_arrow_text_cart_SW


    using Luxor, Images

    struct CanvasConfig
        width::Int64
        height::Int64
    end

    struct PlottingArea
        # All coordinates below are Image Coordinates
        xtopleft::Float64
        ytopleft::Float64
        xtopright::Float64
        ytopright::Float64
        xbotleft::Float64
        ybotleft::Float64
        xbotright::Float64
        ybotright::Float64
    end

    lit_defaultcolorpalette = [
        RGB{Float64}(0.0, 0.6056031611752245, 0.9786801175696073),
        RGB{Float64}(0.8888735002725198, 0.43564919034818994, 0.2781229361419438),
        RGB{Float64}(0.2422242978521988, 0.6432750931576305, 0.3044486515341153),
        RGB{Float64}(0.7644401754934356, 0.4441117794687767, 0.8242975359232758),
        RGB{Float64}(0.6755439572114057, 0.5556623322045815, 0.09423433626639477),
        RGB{Float64}(4.821181644776295e-7, 0.6657589812923561, 0.6809969518707945),
        RGB{Float64}(0.930767491919665, 0.3674771896571412, 0.5757699667547829),
        RGB{Float64}(0.7769816661712932, 0.5097431319944513, 0.1464252569555497),
        RGB{Float64}(3.8077343661790943e-7, 0.6642678029460116, 0.5529508754522481),
        RGB{Float64}(0.558464964115081, 0.5934846564332882, 0.11748125233232104),
        RGB{Float64}(5.947623898072685e-7, 0.6608785231434254, 0.7981787608414297),
        RGB{Float64}(0.6096707676128648, 0.49918492100827777, 0.9117812665042642),
        RGB{Float64}(0.3800016049820351, 0.5510532724353506, 0.9665056985227146),
        RGB{Float64}(0.942181647954218, 0.37516423354097583, 0.4518168202944593),
        RGB{Float64}(0.8684020893043971, 0.3959893639954845, 0.7135147524811879),
        RGB{Float64}(0.42314674364630817, 0.6224954944199981, 0.19877060252130468)
    ]

    function lit_convert_x_imagecoor_to_cartesiancoor(canvasconfig::CanvasConfig, x)
        local x_cart
        x_cart = x
        return x_cart
    end

    function lit_convert_y_imagecoor_to_cartesiancoor(canvasconfig::CanvasConfig, y)
        local y_cart
        y_cart = (canvasconfig.height - 1) - y
        return y_cart
    end

    function lit_convert_xy_imagecoor_to_cartesiancoor(canvasconfig::CanvasConfig, x, y)
        return (lit_convert_x_imagecoor_to_cartesiancoor(canvasconfig, x),
            lit_convert_y_imagecoor_to_cartesiancoor(canvasconfig, y)
        )
    end

    function lit_convert_x_cartesiancoor_to_imagecoor(canvasconfig::CanvasConfig, x)
        local x_image
        x_image = x
        return x_image
    end

    function lit_convert_y_cartesiancoor_to_imagecoor(canvasconfig::CanvasConfig, y)
        local y_image
        y_image = (canvasconfig.height - 1) - y
        return y_image
    end

    function lit_convert_xy_cartesiancoor_to_imagecoor(canvasconfig::CanvasConfig, x, y)
        return (lit_convert_x_cartesiancoor_to_imagecoor(canvasconfig, x),
            lit_convert_y_cartesiancoor_to_imagecoor(canvasconfig, y)
        )
    end

    function lit_convert_cartesianpoint_to_imagepoint_noncenter(canvasconfig::CanvasConfig, p)
        return Point(
            lit_convert_xy_cartesiancoor_to_imagecoor(canvasconfig, p[1], p[2])...
        )
    end

    function lit_convert_cartesianpoint_to_imagepoint_center(canvasconfig::CanvasConfig, p)
        return Point(p[1], -1 * p[2])
    end

    function lit_convert_cartesianpoint_to_imagepoint_noncenter_as_center(canvasconfig::CanvasConfig, p)
        local xcenter = div(canvasconfig.width, 2)
        local ycenter = div(canvasconfig.height, 2)
        return Point(p[1] + xcenter, -1 * p[2] + ycenter)
    end

    function lit_cartesianpoint_noncenter(canvasconfig::CanvasConfig, x, y)
        return Point(lit_convert_xy_cartesiancoor_to_imagecoor(canvasconfig, x, y)...)
    end

    function lit_cartesianpoint_center(canvasconfig, x, y)
        return Point(x, -y)
    end

    function lit_cartesianpoint_noncenter_as_center(canvasconfig::CanvasConfig, x, y)
        local xcenter = div(canvasconfig.width, 2)
        local ycenter = div(canvasconfig.height, 2)
        return Point(x + xcenter, (-y) + ycenter)
    end

    function lit_RotationMatrix2D(theta_radian)
        local θ = Float64(theta_radian)
        return [cos(θ) -sin(θ) 0.0
            sin(θ) cos(θ) 0.0
            0.0 0.0 1.0]
    end

    function lit_ScaleMatrix2D(ScaleX, ScaleY)
        local scalex = Float64(ScaleX)
        local scaley = Float64(ScaleY)
        return [scalex 0.0 0.0
            0.0 scaley 0.0
            0.0 0.0 1.0]
    end

    function lit_TranslationMatrix2D(TransX, TransY)
        local transx = Float64(TransX)
        local transy = Float64(TransY)
        return [1.0 0.0 transx
            0.0 1.0 transy
            0.0 0.0 1.0]
    end

    function lit_CartTranslationMatrix2D(TransX, TransY)
        local transx = Float64(TransX)
        local transy = -1.0 * Float64(TransY)
        return [1.0 0.0 transx
            0.0 1.0 transy
            0.0 0.0 1.0]
    end

    function lit_ReflectXaxisMatrix2D()
        return [1.0 0.0 0.0
            0.0 -1.0 0.0
            0.0 0.0 1.0]
    end

    function lit_ReflectYaxisMatrix2D()
        return [-1.0 0.0 0.0
            0.0 1.0 0.0
            0.0 0.0 1.0]
    end

    function lit_SetFakeCartesianSystem(canvasconfig::CanvasConfig)
        local f_matrix = lit_ReflectXaxisMatrix2D()
        local t_matrix = lit_TranslationMatrix2D(0.0, canvasconfig.height - 1)

        local total_matrix = t_matrix * f_matrix
        local cm = juliatocairomatrix(total_matrix)
        setmatrix(cm)
    end

    function lit_FakeCartesianSystemMatrix2D(canvasconfig::CanvasConfig)
        local f_matrix = lit_ReflectXaxisMatrix2D()
        local t_matrix = lit_TranslationMatrix2D(0.0, canvasconfig.height - 1)

        local total_matrix = t_matrix * f_matrix
        return total_matrix
    end

    function lit_CalcPlottingArea(canvasconfig::CanvasConfig)
        # All coordinates below are Image Coordinates
        local xtopleft = round(65 / 600 * canvasconfig.width)
        local ytopleft = round(30 / 400 * canvasconfig.height)
        local xtopright = round(585 / 600 * canvasconfig.width)
        local ytopright = round(30 / 400 * canvasconfig.height)
        local xbotleft = round(65 / 600 * canvasconfig.width)
        local ybotleft = round(355 / 400 * canvasconfig.height)
        local xbotright = round(585 / 600 * canvasconfig.width)
        local ybotright = round(355 / 400 * canvasconfig.height)
        return PlottingArea(xtopleft, ytopleft, xtopright, ytopright,
            xbotleft, ybotleft, xbotright, ybotright)
    end

    function lit_CalcInternalPlottingArea(plottingarea::PlottingArea)
        # All coordinates below are Image Coordinates
        local xtopleft = plottingarea.xtopleft + 1.0
        local ytopleft = plottingarea.ytopleft + 1.0
        local xtopright = plottingarea.xtopright - 1.0
        local ytopright = plottingarea.ytopright + 1.0
        local xbotleft = plottingarea.xbotleft + 1.0
        local ybotleft = plottingarea.ybotleft - 1.0
        local xbotright = plottingarea.xbotright - 1.0
        local ybotright = plottingarea.ybotright - 1.0
        return PlottingArea(xtopleft, ytopleft, xtopright, ytopright,
            xbotleft, ybotleft, xbotright, ybotright)
    end

    function lit_ConvertInternalPlottingAreaToCartesian(
        canvasconfig::CanvasConfig,
        plottingarea::PlottingArea)
        local xtopleft = plottingarea.xtopleft
        local ytopleft = lit_convert_y_imagecoor_to_cartesiancoor(canvasconfig, plottingarea.ytopleft)
        local xtopright = plottingarea.xtopright
        local ytopright = lit_convert_y_imagecoor_to_cartesiancoor(canvasconfig, plottingarea.ytopright)
        local xbotleft = plottingarea.xbotleft
        local ybotleft = lit_convert_y_imagecoor_to_cartesiancoor(canvasconfig, plottingarea.ybotleft)
        local xbotright = plottingarea.xbotright
        local ybotright = lit_convert_y_imagecoor_to_cartesiancoor(canvasconfig, plottingarea.ybotright)
        return PlottingArea(xtopleft, ytopleft, xtopright, ytopright,
            xbotleft, ybotleft, xbotright, ybotright)
    end

    function lit_calc_physical_y_in_graph(yval, ylimits, physicalheight)
        local y_val_bot = ylimits[1]
        local y_val_range = ylimits[2] - ylimits[1]
        local y_ratio = (yval - y_val_bot) / y_val_range
        local y = y_ratio * physicalheight
        return y
    end

    function lit_graphfuncplot(func, xlims, ylims, internalcartPA)
        local x_val_range = xlims[2] - xlims[1]
        local x_prev, x_val_prev, x_val
        local y_prev, y_physical_prev, y, y_physical
        local physicalheight = internalcartPA.ytopleft - internalcartPA.ybotleft
        local physicalwidth = internalcartPA.xtopright - internalcartPA.xtopleft
        box(Point(0, 0), Point(physicalwidth, physicalheight), :clip)
        for x_pixel = 1:physicalwidth
            x_prev = x_pixel - 1
            x_val_prev = xlims[1] + (x_prev / physicalwidth) * x_val_range
            y_prev = func(x_val_prev)
            y_physical_prev = lit_calc_physical_y_in_graph(y_prev, ylims, physicalheight)

            x_val = xlims[1] + (x_pixel / physicalwidth) * x_val_range
            y = func(x_val)
            y_physical = lit_calc_physical_y_in_graph(y, ylims, physicalheight)

            line(Point(x_prev, y_physical_prev), Point(x_pixel, y_physical), :stroke)
        end
        clipreset()
    end

    function lit_graphseriesplot(x::AbstractArray, y::AbstractArray, xlims, ylims, internalcartPA)
        local x_val_range = xlims[2] - xlims[1]
        local y_val_range = ylims[2] - ylims[1]
        local len_x = length(x)
        local len_y = length(y)
        local physicalheight = internalcartPA.ytopleft - internalcartPA.ybotleft
        local physicalwidth = internalcartPA.xbotright - internalcartPA.xbotleft
        # Sanity check: Make sure x and y have the same length
        if len_x != len_y
            println("Error in lit_graphseriesplot : len_x != len_y")
            return nothing
        end
        box(Point(0, 0), Point(physicalwidth, physicalheight), :clip)
        # Figure out points
        mypoints = Point[]

        local count = 0
        while count < len_x
            x_value = x[begin+count]

            x_proportion = (x_value - xlims[1]) / x_val_range
            x_pixel = x_proportion * physicalwidth

            y_value = y[begin+count]

            y_proportion = (y_value - ylims[1]) / y_val_range
            y_pixel = y_proportion * physicalheight

            # Push Point into mypoints
            push!(mypoints, Point(x_pixel, y_pixel))
            # Increment countX
            count += 1
        end
        # Plot points
        for count = 2:length(mypoints)
            line(mypoints[count-1], mypoints[count], :stroke)
        end

        # Finish plotting
        clipreset()
    end

    function lit_SetInternalPlottingAreaMatrix(canvasconfig, internalcartPA)
        local matrix = lit_FakeCartesianSystemMatrix2D(canvasconfig)
        local total_matrix = lit_CartTranslationMatrix2D(internalcartPA.xbotleft, internalcartPA.ybotleft) * matrix
        local cm = juliatocairomatrix(total_matrix)
        setmatrix(cm)
    end

    function lit_create_graph_xticks(majortick::Integer,xlims,plottingarea;
                                     font="Courier",fontsize=12,
                                     ticklength=10,textoffset=25,debug=false,
                                     minortick=false,minortickdivisions=4)
        local numofdivisions = majortick + 1.0
        local physicalwidth = (plottingarea.xbotright - 0.5) - (plottingarea.xbotleft + 0.5)
        local hstep = physicalwidth / numofdivisions
        local stepamount = (xlims[2] - xlims[1])/numofdivisions
        for loopcounter in 0:numofdivisions
            p = Point((plottingarea.xbotleft + 0.5) + loopcounter * hstep,plottingarea.ybotleft)
            line(p,Point(p[1],p[2]+ticklength),:stroke)
            setfont(font,fontsize)
            settext("$(round(xlims[1] + loopcounter * stepamount, digits=2))",p + (0,textoffset), halign="center",valign="bottom")
        end
        if minortick == false
            return
        end
        # Code for minor ticks
        local arr = xlims[1]:((xlims[2]-xlims[1])/numofdivisions):xlims[2]
        local tickdist = arr[2]-arr[1]
        local minortickdist = tickdist / (minortickdivisions + 1)
        local minortickarr = []
        # get all the x values of the minorticks
        for k = 1:length(arr)-1 , c = 1:minortickdivisions
            push!(minortickarr,arr[k]+c*minortickdist)
        end
        # Add the pre and post minor ticks
        for c = 1:minortickdivisions
            # Add the pre minorticks (The ones before the first major tick)
            push!(minortickarr,arr[1]   -  c*minortickdist)
            # Add the post minorticks (The ones after the last major tick)
            push!(minortickarr,arr[end] +  c*minortickdist)
        end
        # Now draw all the minor ticks
        for minortick in minortickarr
            x_proportion = (minortick - xlims[1])/(xlims[2]-xlims[1])
            if 0.0 <= x_proportion <= 1.0
                p = Point((plottingarea.xbotleft+0.5) + x_proportion * physicalwidth,plottingarea.ybotleft)
                line(p,Point(p[1],p[2]+ticklength/2),:stroke)
            else
                if debug
                    println("Minortick Point out of range of bottom axis")
                end
            end
        end
    end

    function lit_create_graph_xticks(arr::Union{AbstractArray,StepRange{T,T} where T <: Number},
        xlims,plottingarea;font="Courier",fontsize=12,ticklength=10,textoffset=25,debug=false,
        minortick=false,minortickdivisions=4)
        local physicalwidth = (plottingarea.xbotright - 0.5) - (plottingarea.xbotleft + 0.5)
        local x_proportion
        for tick in arr
            x_proportion = (tick - xlims[1])/(xlims[2]-xlims[1])
            if 0.0 <= x_proportion <= 1.0
                p = Point((plottingarea.xbotleft+0.5) + x_proportion * physicalwidth,plottingarea.ybotleft)
                line(p,Point(p[1],p[2]+ticklength),:stroke)
                setfont(font,fontsize)
                settext("$(round(tick, digits=2))",p + (0,textoffset), halign="center",valign="bottom")
            else
                if debug
                    println("Tick Point out of range of bottom axis")
                end
            end
        end
        if minortick == false
            return
        end
        # Code for minor ticks
        local tickdist = arr[2]-arr[1]
        local minortickdist = tickdist / (minortickdivisions + 1)
        local minortickarr = []
        # get all the x values of the minorticks
        for k = 1:length(arr)-1 , c = 1:minortickdivisions
            push!(minortickarr,arr[k]+c*minortickdist)
        end
        # Add the pre and post minor ticks
        for c = 1:minortickdivisions
            # Add the pre minorticks (The ones before the first major tick)
            push!(minortickarr,arr[1]   -  c*minortickdist)
            # Add the post minorticks (The ones after the last major tick)
            push!(minortickarr,arr[end] +  c*minortickdist)
        end
        # Now draw all the minor ticks
        for minortick in minortickarr
            x_proportion = (minortick - xlims[1])/(xlims[2]-xlims[1])
            if 0.0 <= x_proportion <= 1.0
                p = Point((plottingarea.xbotleft+0.5) + x_proportion * physicalwidth,plottingarea.ybotleft)
                line(p,Point(p[1],p[2]+ticklength/2),:stroke)
            else
                if debug
                    println("Minortick Point out of range of bottom axis")
                end
            end
        end
    end

    function lit_create_graph_yticks(majortick,ylims,plottingarea;
                                     font="Courier",fontsize=12,
                                     ticklength=10,textoffset=20,debug=false,
                                     minortick=false,minortickdivisions=4)
        local numofdivisions = majortick + 1.0
        local physicalheight = (plottingarea.ybotleft - 0.5) - (plottingarea.ytopleft + 0.5)
        local stepamount = (ylims[2] - ylims[1])/numofdivisions
        vstep = physicalheight / numofdivisions
        for loopcounter in 0:numofdivisions
            p = Point(plottingarea.xbotleft,(plottingarea.ytopleft + 0.5) + loopcounter * vstep)
            line(Point(p[1]-ticklength,p[2]),p,:stroke)
            setfont(font,fontsize)
            settext("$(round(ylims[2] - loopcounter * stepamount, digits=2))",p + (-1 * textoffset,0), halign="right",valign="center")
        end
        if minortick == false
            return
        end
        # Code for minor ticks
        local arr = ylims[1]:((ylims[2]-ylims[1])/numofdivisions):ylims[2]
        local tickdist = arr[2]-arr[1]
        local minortickdist = tickdist / (minortickdivisions + 1)
        local minortickarr = []
        # get all the x values of the minorticks
        for k = 1:length(arr)-1 , c = 1:minortickdivisions
            push!(minortickarr,arr[k]+c*minortickdist)
        end
        # Add the pre and post minor ticks
        for c = 1:minortickdivisions
            # Add the pre minorticks (The ones before the first major tick)
            push!(minortickarr,arr[1]   -  c*minortickdist)
            # Add the post minorticks (The ones after the last major tick)
            push!(minortickarr,arr[end] +  c*minortickdist)
        end
        # Now draw all the minor ticks
        for minortick in minortickarr
            y_proportion = (minortick - ylims[1])/(ylims[2]-ylims[1])
            if 0.0 <= y_proportion <= 1.0
                p = Point(plottingarea.xbotleft,
                           (plottingarea.ybotleft-0.5) - y_proportion * physicalheight)
                line(Point(p[1]-ticklength/2,p[2]),p,:stroke)
            else
                if debug
                    println("Minortick Point out of range of vertical axis")
                end
            end
        end

    end

    function lit_create_graph_yticks(arr::Union{AbstractArray,StepRange{T,T} where T <: Number},
        ylims,plottingarea;font="Courier",fontsize=12,ticklength=10,textoffset=25,debug=false,
        minortick=false,minortickdivisions=4)
        local physicalheight = (plottingarea.ybotright - 0.5) - (plottingarea.ytopright + 0.5)
        local y_proportion
        for tick in arr
            y_proportion = (tick - ylims[1])/(ylims[2]-ylims[1])
            if 0.0 <= y_proportion <= 1.0
                p = Point(plottingarea.xbotleft,
                           (plottingarea.ybotleft-0.5) - y_proportion * physicalheight)
                line(Point(p[1]-ticklength,p[2]),p,:stroke)
                setfont(font,fontsize)
                settext("$(round(tick, digits=2))",p + (-1 * textoffset,0), halign="right",valign="center")
            else
                if debug
                    println("Tick Point out of range of vertical axis")
                end
            end
        end
        if minortick == false
            return
        end
        # Code for minor ticks
        local tickdist = arr[2]-arr[1]
        local minortickdist = tickdist / (minortickdivisions + 1)
        local minortickarr = []
        # get all the x values of the minorticks
        for k = 1:length(arr)-1 , c = 1:minortickdivisions
            push!(minortickarr,arr[k]+c*minortickdist)
        end
        # Add the pre and post minor ticks
        for c = 1:minortickdivisions
            # Add the pre minorticks (The ones before the first major tick)
            push!(minortickarr,arr[1]   -  c*minortickdist)
            # Add the post minorticks (The ones after the last major tick)
            push!(minortickarr,arr[end] +  c*minortickdist)
        end
        # Now draw all the minor ticks
        for minortick in minortickarr
            y_proportion = (minortick - ylims[1])/(ylims[2]-ylims[1])
            if 0.0 <= y_proportion <= 1.0
                p = Point(plottingarea.xbotleft,
                           (plottingarea.ybotleft-0.5) - y_proportion * physicalheight)
                line(Point(p[1]-ticklength/2,p[2]),p,:stroke)
            else
                if debug
                    println("Minortick Point out of range of vertical axis")
                end
            end
        end
    end

    function lit_create_graph_title(canvasconfig, plottingarea, title; font="Times", fontsize=30, debug=false)
        p = Point((plottingarea.xtopleft + plottingarea.xtopright) / 2.0, plottingarea.ytopleft / 2.0)
        setfont(font, fontsize)
        settext(title, p + (0, 0), halign="center", valign="center")
    end

    function lit_create_X_axis_title(canvasconfig, plottingarea, title; font="Helvetica", fontsize=18, debug=false)
        p = Point((plottingarea.xbotleft + plottingarea.xbotright) / 2.0, plottingarea.ybotleft)
        setfont(font, fontsize)
        settext(title, p + (0, (40 / 63) * (canvasconfig.height - plottingarea.ybotleft)), halign="center", valign="center")
    end

    function lit_create_Y_axis_title(canvasconfig, plottingarea, title; font="Helvetica", fontsize=18, debug=false)
        p = Point(plottingarea.xbotleft, (plottingarea.ytopleft + plottingarea.ybotleft) / 2.0)
        setfont(font, fontsize)
        settext(title, p + (-1 * (46 / 63) * plottingarea.xbotleft, 0), halign="center", valign="center", angle=90)
    end

    function lit_convert_graph_xvalue_to_image_xcoor(xvalue, xlims, plottingarea)
        local physicalwidth = (plottingarea.xbotright - 1) - (plottingarea.xbotleft + 1)
        local x_proportion
        x_proportion = (xvalue - xlims[1]) / (xlims[2] - xlims[1])
        return (plottingarea.xbotleft) + x_proportion * physicalwidth - 0.5
    end

    function lit_convert_graph_xvalue_to_cart_xcoor(canvasconfig, xvalue, xlims, plottingarea)
        local xcoor_image = lit_convert_graph_xvalue_to_image_xcoor(xvalue, xlims, plottingarea)
        local xcoor_image2 = xcoor_image - plottingarea.xbotleft
        return lit_convert_x_imagecoor_to_cartesiancoor(canvasconfig, xcoor_image2)
    end

    function lit_convert_graph_yvalue_to_image_ycoor(yvalue, ylims, plottingarea)
        local physicalheight = (plottingarea.ybotright - 1) - (plottingarea.ytopright + 1)
        local y_proportion
        y_proportion = (yvalue - ylims[1]) / (ylims[2] - ylims[1])
        return (plottingarea.ybotleft) - y_proportion * physicalheight - 0.5
    end

    function lit_convert_graph_yvalue_to_cart_ycoor(canvasconfig, yvalue, ylims, plottingarea)
        local ycoor_image = lit_convert_graph_yvalue_to_image_ycoor(yvalue, ylims, plottingarea)
        return lit_convert_y_imagecoor_to_cartesiancoor(canvasconfig, ycoor_image) - (canvasconfig.height - plottingarea.ybotleft)
    end

    function lit_graph_arrow_text_cart(
        text, x, y; arrow_length=50, arrowgap=2, blankgap=5,
        text_shiftup=1, headangle=pi / 10,
        font="Courier", fontsize=12)
        arrow(Point(x + arrow_length, y), Point(x + arrowgap, y), arrowheadlength=12, arrowheadangle=headangle, linewidth=2)
        setfont(font, fontsize)
        settext(text, Point(x, y) + (arrow_length + blankgap, text_shiftup), halign="left", valign="center")
    end

    function lit_graph_arrow_text_cart_NE(
        text, x, y; arrow_length=50, arrowgap=2, blankgap=5,
        text_shiftup=1, headangle=pi / 10, horizontal_length=40,
        font="Courier", fontsize=12)
        local diagonal_length = arrow_length / 1.4142135623730951
        arrow(Point(x + diagonal_length, y + diagonal_length), Point(x + arrowgap, y), arrowheadlength=12, arrowheadangle=headangle, linewidth=2)
        line(Point(x + diagonal_length, y + diagonal_length),
            Point(x + diagonal_length + horizontal_length, y + diagonal_length), :stroke)
        setfont(font, fontsize)
        settext(text, Point(x, y) +
                      (diagonal_length + horizontal_length + blankgap, diagonal_length + text_shiftup), halign="left", valign="center")
    end

    function lit_graph_arrow_text_cart_SE(
        text, x, y; arrow_length=50, arrowgap=2, blankgap=5,
        text_shiftup=1, headangle=pi / 10, horizontal_length=40,
        font="Courier", fontsize=12)
        local diagonal_length = arrow_length / 1.4142135623730951
        arrow(Point(x + diagonal_length, y - diagonal_length), Point(x + arrowgap, y), arrowheadlength=12, arrowheadangle=headangle, linewidth=2)
        line(Point(x + diagonal_length, y - diagonal_length),
            Point(x + diagonal_length + horizontal_length, y - diagonal_length), :stroke)
        setfont(font, fontsize)
        settext(text, Point(x, y) +
                      (diagonal_length + horizontal_length + blankgap, -1 * diagonal_length + text_shiftup), halign="left", valign="center")
    end

    function lit_graph_arrow_text_cart_W(
            text,x,y;arrow_length=50,arrowgap=1,blankgap=5,
            text_shiftup=1,headangle=pi/10,
            font="Menlo Bold",fontsize=12)
        arrow(Point(x - arrow_length,y), Point(x-arrowgap, y), arrowheadlength=12, arrowheadangle=headangle, linewidth=2)
        setfont(font, fontsize)
        settext(text,Point(x,y) + (-1*(arrow_length+blankgap),text_shiftup), halign="right",valign="center")
    end

    function lit_graph_arrow_text_cart_NW(
            text,x,y;arrow_length=50,arrowgap=1,blankgap=5,
            text_shiftup=1,headangle=pi/10,horizontal_length=40,
            font="Menlo Bold",fontsize=12)
        local diagonal_length = arrow_length/1.4142135623730951
        arrow(Point(x - diagonal_length,y + diagonal_length), Point(x-arrowgap, y), arrowheadlength=12, arrowheadangle=headangle, linewidth=2)
        line(Point(x - diagonal_length,y + diagonal_length),
             Point(x - (diagonal_length + horizontal_length),y + diagonal_length)
             ,:stroke)
        setfont(font, fontsize)
        settext(text,Point(x,y) +
            (-1*(diagonal_length + horizontal_length+blankgap),diagonal_length + text_shiftup), halign="right",valign="center")
    end

    function lit_graph_arrow_text_cart_SW(
            text,x,y;arrow_length=50,arrowgap=1,blankgap=5,
            text_shiftup=1,headangle=pi/10,horizontal_length=40,
            font="Menlo Bold",fontsize=12)
        local diagonal_length = arrow_length/1.4142135623730951
        arrow(Point(x - diagonal_length,y - diagonal_length), Point(x-arrowgap, y), arrowheadlength=12, arrowheadangle=headangle, linewidth=2)
        line(Point(x - diagonal_length,y - diagonal_length),
             Point(x - (diagonal_length + horizontal_length),y - diagonal_length)
             ,:stroke)
        setfont(font, fontsize)
        settext(text,Point(x,y) +
            (-1*(diagonal_length + horizontal_length+blankgap),-1*diagonal_length + text_shiftup), halign="right",valign="center")
    end

end









"""
     I originally used the font "Menlo Bold" but since it is not a popular font
     I have changed it to "Courier"

     The Fonts used in this source code are
     1) Times
     2) Helvetica
     3) Courier
"""

using .luxorgraphtools

function plotfigure(fname)
    println("running plotfigure()")

    widthheight = (840, 560)
    Drawing(widthheight..., fname)
    canvasconfig = CanvasConfig(widthheight...)
    background("white")
    sethue("red")

    # Start with coordinates transformation back to Normal
    setmatrix([1, 0, 0, 1, 0, 0])

    myplottingarea = lit_CalcPlottingArea(canvasconfig)
    myinternalPA = lit_CalcInternalPlottingArea(myplottingarea)
    myinternalcartPA = lit_ConvertInternalPlottingAreaToCartesian(canvasconfig, myinternalPA)

    sethue("grey30")
    setline(1)
    """ Draw the outline of the graph box """
    points = [Point(myplottingarea.xtopleft, myplottingarea.ytopleft),
        Point(myplottingarea.xbotleft, myplottingarea.ybotleft),
        Point(myplottingarea.xbotright, myplottingarea.ybotright)]
    poly(points, :stroke, close=false)
    setline(2)

    # Now prepare to plot sine, cosine and multi-trig graph
    xlims = (0.0, 2.0 * pi)
    ylims = (-1.1, 1.1)

    # Set the coordinates to Cartesian which is inside the
    # Plotting Area of the graph
    lit_SetInternalPlottingAreaMatrix(canvasconfig, myinternalcartPA)

    x = range(0, 2π, length=100)
    y1 = sin.(x)
    y2 = cos.(x)
    y3 = -1 .* (sin.(2x) .+ cos.(π * x)) .* exp.(-0.2x)

    # Now plot Series Y1
    sethue(colorant"darkblue")
    lit_graphseriesplot(x, y1, xlims, ylims, myinternalcartPA)

    # Now plot the Cosine series
    sethue(colorant"purple")
    #
    #  lit_graphseriesplot(x,y2,xlims,ylims,myinternalcartPA)
    #
    """
            Instead of using x and y2 series
            We can just plot the cosine series using
            the Cosine function directly
    """
    lit_graphfuncplot(cos, xlims, ylims, myinternalcartPA)

    # Now plot Series Y3
    sethue(colorant"deeppink")
    lit_graphseriesplot(x, y3, xlims, ylims, myinternalcartPA)

    # Now draw the arrows as you please
    sethue(colorant"black")
    """ Draw Arrow for Series Y1 """
    xvalue = 0.95
    xcoor = lit_convert_graph_xvalue_to_cart_xcoor(canvasconfig, xvalue, xlims, myplottingarea)
    yvalue = sin(xvalue)
    ycoor = lit_convert_graph_yvalue_to_cart_ycoor(canvasconfig, yvalue, ylims, myplottingarea)
    lit_graph_arrow_text_cart("Series Y1", xcoor, ycoor, arrow_length=40)

    """ Draw Arrow for Series Y2 """
    xvalue = 1.0
    xcoor = lit_convert_graph_xvalue_to_cart_xcoor(canvasconfig, xvalue, xlims, myplottingarea)
    yvalue = cos(xvalue)
    ycoor = lit_convert_graph_yvalue_to_cart_ycoor(canvasconfig, yvalue, ylims, myplottingarea)
    lit_graph_arrow_text_cart("Series Y2", xcoor, ycoor, arrow_length=40)

    """ Draw Arrow for Series Y3 """
    xvalue = 0.7
    xcoor = lit_convert_graph_xvalue_to_cart_xcoor(canvasconfig, xvalue, xlims, myplottingarea)
    yvalue = -1 * (sin(2 * xvalue) + cos(pi * xvalue)) * exp(-0.2 * xvalue)
    ycoor = lit_convert_graph_yvalue_to_cart_ycoor(canvasconfig, yvalue, ylims, myplottingarea)
    lit_graph_arrow_text_cart("Series Y3", xcoor, ycoor)

    """ Draw Arrow for Sine Function """
    xvalue = 2.7
    xcoor = lit_convert_graph_xvalue_to_cart_xcoor(canvasconfig, xvalue, xlims, myplottingarea)
    yvalue = sin(xvalue)
    ycoor = lit_convert_graph_yvalue_to_cart_ycoor(canvasconfig, yvalue, ylims, myplottingarea)
    lit_graph_arrow_text_cart_NE("Sine Function", xcoor, ycoor, arrow_length=40)

    """ Draw Arrow for Cosine Function """
    xvalue = 4.05
    xcoor = lit_convert_graph_xvalue_to_cart_xcoor(canvasconfig, xvalue, xlims, myplottingarea)
    yvalue = cos(xvalue)
    ycoor = lit_convert_graph_yvalue_to_cart_ycoor(canvasconfig, yvalue, ylims, myplottingarea)
    lit_graph_arrow_text_cart_SE("Cosine Function", xcoor, ycoor, arrow_length=40, horizontal_length=10)

    """ Draw Arrow for (cos(π x) - sin(2x)) exp(-0.2x) """
    xvalue = 3.6
    xcoor = lit_convert_graph_xvalue_to_cart_xcoor(canvasconfig,xvalue,xlims,myplottingarea)
    yvalue = -1 * (sin(2 * xvalue) + cos(pi * xvalue)) * exp(-0.2 * xvalue)
    ycoor = lit_convert_graph_yvalue_to_cart_ycoor(canvasconfig,yvalue,ylims,myplottingarea)
    lit_graph_arrow_text_cart_W("(cos(π x) - sin(2x)) exp(-0.2x)",xcoor,ycoor)

    """ Draw Arrow for cos(x) """
    xvalue = 4.9
    xcoor = lit_convert_graph_xvalue_to_cart_xcoor(canvasconfig,xvalue,xlims,myplottingarea)
    yvalue = cos(xvalue)
    ycoor = lit_convert_graph_yvalue_to_cart_ycoor(canvasconfig,yvalue,ylims,myplottingarea)
    lit_graph_arrow_text_cart_NW("cos(x)",xcoor,ycoor,arrow_length=40)

    """ Draw Arrow for sin(x) """
    xvalue = 3.1
    xcoor = lit_convert_graph_xvalue_to_cart_xcoor(canvasconfig,xvalue,xlims,myplottingarea)
    yvalue = sin(xvalue)
    ycoor = lit_convert_graph_yvalue_to_cart_ycoor(canvasconfig,yvalue,ylims,myplottingarea)
    lit_graph_arrow_text_cart_SW("sin(x)",xcoor,ycoor,arrow_length=40,horizontal_length=20)

    # Set coordinates transformation back to Normal
    setmatrix([1, 0, 0, 1, 0, 0])

    # Now produce a tickline
    """ X ticklines """
    sethue(colorant"darkblue")
    lit_create_graph_xticks(0:1:6,xlims,myplottingarea,minortick=true)

    """ Y ticklines """
    sethue(colorant"midnightblue")
    lit_create_graph_yticks(-1.2:0.2:1.2,ylims,myplottingarea,minortick=true)

    """ Graph Title """
    sethue(colorant"black")
    lit_create_graph_title(canvasconfig, myplottingarea, "Trigonometry curves", font="Times")

    """ X-axis title """
    lit_create_X_axis_title(canvasconfig, myplottingarea, "X-axis : rotational angle in radians")

    """ Y-axis title """
    lit_create_Y_axis_title(canvasconfig, myplottingarea, "Y-axis : voltage in volts")

    # finish off the picture
    finish()
    preview()
    # The end
end

fname = dirname(dirname(pathof(Luxor))) * "/docs/src/assets/figures/graphdemo.svg"
plotfigure(fname)
