-- params
-- Inspiried by Codea
-- Allows a global variable's value to be observed and updated via an on-screen HUD-style overlay. 
-- Multiple such variables can be monitored.

require("middleclass")

-- The namespace to be returned by module
local params = {}

local g = love.graphics

-- Still working out the best way to create modules in Lua.  

local Pane = class('Pane')

local WIDTH = 200 -- Overall width of a pane
local HEIGHT = 100 -- Height of a pane
local INSET = 20 -- Inset for the drag control

function Pane:initialize(x, y, property, min, max)
   self.x, self.y = x, y
   self.property = property

   self.min, self.max = min, max

   self.minX = x + INSET
   self.maxX = x + WIDTH - INSET

   self.pixelIncrement = (self.maxX - self.minX) / (max - min)

   local value = _G[self.property]

   self.nibY = y - 60
   self.nibX = self.minX + (value - min) * self.pixelIncrement
end

function Pane:draw()
   g.setColor (0, 0, 0, 190) -- 75% opacity
   g.rectangle("fill", self.x, self.y, WIDTH, HEIGHT)
   g.setColor(255, 255, 255)
   g.setLineWidth(2)
   g.rectangle("line", self.x, self.y, WIDTH, HEIGHT)

   g.print(self.property, self.x + 5, self.y + 5)

   local value = tostring(_G[self.property])

   local textWidth = g.getFont():getWidth(value)

   g.setColor(255, 138, 0)
   g.print(value, self.x + WIDTH - 5 - textWidth, self.y + 6)

end


local nextPaneY = 2
local panes = {}

-- Creates a new standard parameter pane; the parameter value can
-- range across the floating values between min and max
-- This is typically invoked from the love.load() callback
function params.param(property, min, max) 
   table.insert(panes, Pane:new(2, nextPaneY, property, min, max))

   nextPaneY = nextPaneY - HEIGHT + 10
end

-- Must be called at the end of the love.draw() callback to draw the 
-- parameter panes (above all other graphics).

function params.draw() 
   for _, pane in pairs(panes) do
      pane:draw()
   end
end

return params
