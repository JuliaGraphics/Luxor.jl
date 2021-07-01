## How can you contribute?

If you _know any geometry_ you probably know more than me, so there are plenty of improvements to algorithms waiting to be made. There are some _TODO_ comments sprinkled through the code, but plenty more opportunities for improvement.

_Update the code_, most of which was written for Julia versions 0.2, v0.3 and 0.4 (remember when broadcasting wasn't a thing?) so there are probably many areas where the code could take more advantage of version 1.

There can always be _more tests_, as the present tests are mainly visual, showing that something works, but there should be much more testing of things that shouldn't work - inappropriate input, overlapping polygons, coincident or collinear points, anticlockwise polygons, etc.

More _systematic error-handling_ particularly of geometry errors would be a good idea, rather than sprinkling `throw(error())`s around when things look wrong.
