-- params
-- Inspiried by Codea
-- Allows a global variable's value to be observed and updated via an on-screen HUD-style overlay. 
-- Multiple such variables can be monitored.

require "middleclass"

-- Loaded once, inside setup()
-- Deferring this to ensure that love.graphics is initialized
local paneImage, nibImage, nibNormalQ, nibDraggingQ

-- The namespace to be returned by module
local params = {}

local g = love.graphics

-- Still working out the best way to create modules in Lua.  

local Pane = class "Pane"

local WIDTH -- Overall width of a pane
local HEIGHT -- Height of a pane
local TEXT_INSET = 10 -- Inset for the text
local SLIDER_INSET = 18 -- Inset for the slider control
local SLIDER_VERT_OFFSET = 40

local WHITE = {255, 255, 255}
local ORANGE = {255, 138, 0}
local GREY = {128, 128, 128}

function Pane:initialize(x, y, property, min, max)
   self.x, self.y = x, y
   self.property = property

   self.min, self.max = min, max

   self.minX = x + SLIDER_INSET
   self.maxX = x + WIDTH - SLIDER_INSET

   self.pixelIncrement = (self.maxX - self.minX) / (max - min)

   local value = _G[self.property]

   self.nibY = y - 60
   self.nibX = self.minX + (value - min) * self.pixelIncrement
end


function Pane:draw()

   g.setColor(WHITE)

   g.draw(paneImage, self.x, self.y)

   g.print(self.property, self.x + TEXT_INSET, self.y + TEXT_INSET)

   local value = _G[self.property]
   local valueStr = tostring(value)

   local textWidth = g.getFont():getWidth(value)

   g.setColor(ORANGE)

   g.print(value, self.x + WIDTH - TEXT_INSET - textWidth, self.y + TEXT_INSET)

   -- now the slider

   g.setColor(GREY)
   g.setLineWidth(1)

   local sliderY = self.y + SLIDER_VERT_OFFSET
   local nibPos = self.minX + (value - self.min) * self.pixelIncrement

   g.line(nibPos + 1, sliderY, self.maxX, sliderY)

   g.setColor(WHITE)
   g.setLineWidth(2)
   g.line(self.minX, sliderY, nibPos, sliderY)


   g.drawq(nibImage, nibNormalQ, nibPos, sliderY, 0, 1, 1, 8, 8)

end

local function setup()
   if not(paneImage) then
      paneImage = g.newImage "params/param-pane-bezel.png"
      WIDTH = paneImage:getWidth()
      HEIGHT = paneImage:getHeight()

      nibImage = g.newImage "params/param-slider-nib.png"
      nibNormalQ = g.newQuad(0, 0, 16, 16, 32, 16)
      nibDraggingQ = g.newQuad(16, 0, 16, 16, 32, 16)
   end
end

local nextPaneY = 2
local panes = {}

-- Creates a new standard parameter pane; the parameter value can
-- range across the floating values between min and max
-- This is typically invoked from the love.load() callback
function params.param(property, min, max) 

   setup()

   table.insert(panes, Pane:new(2, nextPaneY, property, min, max))

   nextPaneY = nextPaneY + HEIGHT
end

-- Must be called at the end of the love.draw() callback to draw the 
-- parameter panes (above all other graphics).

function params.draw() 
   for _, pane in pairs(panes) do
      pane:draw()
   end
end

return params
