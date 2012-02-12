This is a project to help myself, and others, get up-to speed on Lua
and [Love2d](http://love2d.org).

I'm borrowing an idea from [Codea](http://twolivesleft.com/Codea/): a
uniform UI for interactive editing of global variables:
parameters. This makes it much easier to understand how the many
different options in the love APIs operate.

It's as simple as defining the variable:

	scale = 1
	
and then (inside a setup() function):

	params.float("scale", 1, 100)
	
The parameters are the minimum and maximum value.

In addition, you must add two function calls to your love.update() and
love.draw() callback functions:

	params.update()
	
and

	params.draw()
	
In addition to the code, there's a number of free and open source
sprites, to aid in your prototyping.
