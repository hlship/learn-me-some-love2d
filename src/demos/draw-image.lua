
-- Globals

local p = require "params"
local g = love.graphics

local image

local demo = {
   name = "Draw Image"
}

local RED = {255, 0, 0}

demo.title = "Display/Scale/Rotate Image"

function demo.setup() 
   x, y, r, sx, sy, ox, oy = 400, 300, 0, 1, 1, 58, 65

   p.int("x", 0, g.getWidth())
   p.int("y", 0, g.getHeight())
   p.float("r", - math.pi, math.pi)
   p.float("sx", -10, 10)
   p.float("sy", -10, 10)
   p.int("ox", -200, 200)
   p.int("oy", -200, 200)

   image = image or g.newImage("tyrian-remastered/Boss D.png")

end

function demo.draw() 
   g.setColorMode("replace")
   g.draw(image, x, y, r, sx, sy, ox, oy)

   -- And a line on top, to identify the x,y position
   g.setColor(RED)
   g.setLineWidth(1)
   g.line(0, y, g.getWidth(), y)
   g.line(x, 0, x, g.getHeight())
end

return demo 



