"""
Draw a line between two points and add an arrowhead at the end. The arrowhead length is the
length of the side of the arrow's tip, and arrow head angle is the angle between the side of
the tip and the shaft of the arrow.

    arrow(startpoint::Point, endpoint::Point; arrowheadlength=10, arrowheadangle=pi/8)

"""
function arrow(startpoint::Point, endpoint::Point; arrowheadlength=10, arrowheadangle=pi/8)
  shaftlength = norm(startpoint, endpoint)
  shaftangle = atan2(startpoint.y - endpoint.y, startpoint.x - endpoint.x)
  arrowheadtopsideangle = shaftangle + arrowheadangle
  gsave()
  # shorten the length so that lines
  # stop before we get to the arrow
  # thus wide shafts won't stick out through the tip of the arrow.
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
