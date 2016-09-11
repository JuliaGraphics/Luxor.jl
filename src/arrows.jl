"""
Draw a line between two points and add an arrowhead at the end. The arrowhead length is the
length of the side of the arrow's head, and arrow head angle is the angle between the side of
the head and the shaft of the arrow.

    arrow(startpoint::Point, endpoint::Point; arrowheadlength=10, arrowheadangle=pi/8)

It doesn't need stroking/filling, the shaft is `stroke()`d and the head `fill()`ed.
"""
function arrow(startpoint::Point, endpoint::Point; arrowheadlength=10, arrowheadangle=pi/8)
  shaftlength = norm(startpoint, endpoint)
  shaftangle = atan2(startpoint.y - endpoint.y, startpoint.x - endpoint.x)
  arrowheadtopsideangle = shaftangle + arrowheadangle
  gsave()
  # shorten the length so that lines
  # stop before we get to the arrow
  # thus wide shafts won't stick out through the head of the arrow.
  ratio = (shaftlength - cos(arrowheadangle) * arrowheadlength) / shaftlength
  tox = startpoint.x + (endpoint.x - startpoint.x) * ratio
  toy = startpoint.y + (endpoint.y - startpoint.y) * ratio

  # to do the same for the start, in case we have to do  start arrows:
  #    tox=endpoint.x
  #    toy=endpoint.y
  #    fromx = startpoint.x + (endpoint.x  - startpoint.x) * (1-ratio)
  #    fromy = startpoint.y + (endpoint.y - startpoint.y) *  (1-ratio)

  fromx=startpoint.x
  fromy=startpoint.y

  # Draw the shaft of the arrow
  newpath()
  move(fromx,fromy)
  line(tox,toy)
  stroke()

  # draw the arrowhead
  # this is a bit boring, isn't it
  topx = endpoint.x + cos(arrowheadtopsideangle) * arrowheadlength
  topy = endpoint.y + sin(arrowheadtopsideangle) * arrowheadlength
  arrowheadbottomsideangle = shaftangle - arrowheadangle
  botx = endpoint.x + cos(arrowheadbottomsideangle) * arrowheadlength
  boty = endpoint.y + sin(arrowheadbottomsideangle) * arrowheadlength
  poly([Point(topx,topy), endpoint, Point(botx,boty)], :fill)
  grestore()
end

"""
Draw a curved arrow, an arc centered at `centerpos` starting at `startangle` and ending at
`endangle` with an arrowhead at the end. Angles are measured clockwise from the positive
x-axis.

    arrow(centerpos::Point, radius, startangle, endangle; arrowheadlength=10, arrowheadangle=pi/8)

"""
function arrow(centerpos::Point, radius, startangle, endangle; arrowheadlength=10, arrowheadangle=pi/8)
  # shorten the length so that lines
  # stop before we get to the arrow
  # thus wide shafts won't stick out through the head of the arrow.
  # TODO this still has numerous small errors,so the algor and magic numbers need fixing

  if startangle > endangle
      startangle, endangle = endangle, startangle
  end
  # don't bother with them if theyre too small
  if isapprox(startangle, endangle, rtol = 0.1)
    return
  end
  startpoint = Point(radius * cos(startangle), radius * sin(startangle))
  endpoint   = Point(radius * cos(endangle), radius * sin(endangle))
  arclength = radius * mod2pi(endangle - startangle)
  arrowheadlength1 = cos(arrowheadangle) * arrowheadlength

  ratio = arrowheadlength1/arclength
  newendangle = endangle - (ratio/5 * endangle) # <-- what's this 5 doing? ------------------
  gsave()
  translate(centerpos)
  newpath()
  move(radius * cos(startangle), radius * sin(startangle))
  arc(0, 0, radius, startangle, newendangle, :stroke)
  closepath()

  shaftangle = mod2pi(-pi/2 + atan2(0 - endpoint.y, 0 - endpoint.x))
  arrowheadtopsideangle = shaftangle + pi + arrowheadangle
  topx = endpoint.x + cos(arrowheadtopsideangle) * arrowheadlength
  topy = endpoint.y + sin(arrowheadtopsideangle) * arrowheadlength
  arrowheadbottomsideangle = shaftangle + pi - arrowheadangle
  botx = endpoint.x + cos(arrowheadbottomsideangle) * arrowheadlength
  boty = endpoint.y + sin(arrowheadbottomsideangle) * arrowheadlength
  poly([Point(topx,topy), Point(endpoint.x, endpoint.y), Point(botx,boty)], :fill)
  grestore()
end
