
-- Globals

local p = require "params"
local g = love.graphics

local image

local demo = {
   name = "Draw Image"
}

local YELLOW = {255, 255, 0}

function demo.setup() 
   x, y, r, sx, sy, ox, oy = 400, 300, 0, 1, 1, 58, 65

   p.iparam("x", 0, g.getWidth())
   p.iparam("y", 0, g.getHeight())
   p.param("r", - math.pi, math.pi)
   p.param("sx", -10, 10)
   p.param("sy", -10, 10)
   p.iparam("ox", -200, 200)
   p.iparam("oy", -200, 200)

   image = image or g.newImage("tyrian-remastered/Boss D.png")

end

function demo.draw() 
   g.setColorMode("replace")
   g.draw(image, x, y, r, sx, sy, ox, oy)

   -- And a yellow line on top, to identify the x,y position
   g.setColor(YELLOW)
   g.setLineWidth(1)
   g.line(0, y, g.getWidth(), y)
   g.line(x, 0, x, g.getHeight())
end

return demo



