local g = love.graphics

local tween = require "tween"

local params = require "params"

xpos = 87
ypos = 23
min = 1
max = 100

local WHITE = { 255, 255, 255 }
local GREY = { 100, 100, 100 }

function love.load()
   params.param("xpos", 1, 100)
   params.param("ypos", 1, 100)
   params.param("min", 1, 100)
   params.param("max", 1, 100)
end

function love.update(dt)
   tween.update(dt)
end

function love.draw()

   g.setBackgroundColor(WHITE)

   drawGrid()

   params.draw() -- always last
end

function drawGrid()
   g.setColor(GREY)
   g.setLineWidth(1)

   local width, height = g.getWidth(), g.getHeight()

   for x = 0, width, 25 do
      g.line(x, 0, x, height)
   end

   for y = 0, height, 25 do
      g.line(0, y, width, y)
   end
end

function love.keypressed(key, unicode)
   if key == "escape" or key == "q" then
      love.event.push("q") -- "q" is a special event name to quit the game immediately and cleanly
      return
   end

   if key == "f" then
      g.toggleFullscreen()
      return
   end
   
   if key == "r" then
      package.loaded.main = null
      require "main"
      love.load()
      return
   end

end
