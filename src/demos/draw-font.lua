-- Globals

local p = require "params"
local g = love.graphics

local RED = {255, 0, 0, 200}
local GREEN = {0, 255, 0, 200 }
local BLUE = {0, 0, 255, 200 }

local time = 0

local font

local message = "You Control The Color And Alpha"

local demo = {
   name = "Draw Image"
}

demo.title = "Display Font"

function demo.setup() 
   time = 0

   red, green, blue, alpha = 100, 100, 100, 255

   p.int("red", 0, 255)
   p.int("green", 0, 255)
   p.int("blue", 0, 255)
   p.int("alpha", 0, 255)

   font = font or g.newFont(40)

end

function demo.update(dt)
   time = time + dt
end

function demo.draw() 

   g.push()
   g.translate(g.getWidth() / 2, g.getHeight() / 2)
   g.rotate(math.pi * time * .5)

   g.push()
   g.translate(0, -100)
   g.rotate(math.pi * .3 * time) 
   g.setColor(RED)
   g.rectangle("fill", -150, -150, 300, 300)
   g.pop()

   g.rotate(math.pi * .67)

   g.push()
   g.translate(0, -100)
   g.rotate(math.pi * .4 * time)
   g.scale(1, .6)
   g.setColor(GREEN)
   g.circle("fill", 0, 0, 200, 30)
   g.pop()

   g.rotate(math.pi * .67)

   g.push()
   g.translate(0, -100)
   g.rotate(math.pi * .6 * time)
   g.setColor(BLUE)
   g.triangle("fill", 0, -150, 150, 75, -150, 75)
   g.pop()

   g.pop()

   g.setFont(font)
   g.setColor(red, green, blue, alpha)

   local width = font:getWidth(message)

   g.print(message, g.getWidth() / 2 - width / 2, g.getHeight() / 2 - font:getHeight() / 2)

end

return demo 



