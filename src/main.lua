local g = love.graphics

local tween = require "tween"

local params = require "params"

myParam = 87

function love.load()
   params.param("myParam", 1, 100)
end

function love.update(dt)
   tween.update(dt)
end

function love.draw()

   g.setBackgroundColor(0, 200, 0)

   drawGrid()

   params.draw() -- always last
end

function drawGrid()
   g.setColor(0, 0, 0)
   g.setLineWidth(2)

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
      require("main")
      love.load()
      return
   end

end
