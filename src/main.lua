local g = love.graphics

local tween = require "tween"

local params = require "params"

xpos = 87
ypos = 23
min = 1
max = 100

local WHITE = { 255, 255, 255 }
local GREY = { 100, 100, 100 }
local BLUE = {0, 0, 255 }

local demos = {}

for _, name in ipairs({ "demos/draw-image", "demos/draw-font"}) do
   local demo = require(name)
   table.insert(demos, demo)
end

local demox

local function demo()
   return demos[demox]
end

local function setupDemo(newDemox)

   -- TODO: Do a cleanup on the previous demo

   demox = newDemox

   params.clear()
   -- Tweens, too?

   -- Invoke demo's setup, if available
   local setup = demo().setup

   if setup then setup() end
end

function love.load()
   setupDemo(1)
end

function love.update(dt)

   local update = demo().update

   if update then update(dt) end
   
   tween.update(dt)
   params.update()
end

function love.draw()

   g.setBackgroundColor(WHITE)

   drawGrid()

   -- Assume each demo will have a draw()

   demo().draw()

   params.draw() -- always last

   g.setColor(BLUE)
   g.setColorMode("modulate")

   local title = demo().title or string.format("Untitled Demo #%d", demox)
   g.print(title, g.getWidth() / 2 - g.getFont():getWidth(title) / 2, 0)

   local fps = string.format("FPS: %.2d", love.timer.getFPS())
   g.print(fps, g.getWidth() - g.getFont():getWidth(fps), 0)
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

   if key == "n" then
      demox = demox + 1
      if (demox > #demos) then demox = 1 end
      setupDemo(demox)
      return
   end

   if key == "p" then
      demox = demox - 1
      if (demox < 1) then demox = #demos end
      setupDemo(demox)
      return
   end
end
