-- params
-- Inspiried by Codea
-- Allows a global variable's value to be observed and updated via an on-screen HUD-style overlay. 
-- Multiple such variables can be monitored.

-- This is starting to cry out for a more organized approach to managing the panes, and the areas inside
-- the panes, but I don't want to get too involved in a major windows/ui endeavor here. Maybe later.

require "middleclass"

-- Loaded once, inside setup()
-- Deferring this to ensure that love.graphics is initialized
local paneImage, nibImage, nibNormalQ, nibDraggingQ, defaultFont

-- The namespace to be returned by module
local params = {}

local g = love.graphics
local m = love.mouse

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

   self.nibY = y + SLIDER_VERT_OFFSET
   self.nibX = self.minX + (value - min) * self.pixelIncrement

end

-- Formats the value (a number) as a string to be displayed
-- inside the UI
function Pane:format(value)
   return "NYI"
end

function Pane:draw()

   g.setColorMode("replace")
   g.draw(paneImage, self.x, self.y)

   g.setColorMode("modulate")
   g.setColor(WHITE)

   g.print(self.property, self.x + TEXT_INSET, self.y + TEXT_INSET)

   local value = _G[self.property]
   local valueStr = self:format(value)

   local textWidth = g.getFont():getWidth(valueStr)

   g.setColor(ORANGE)

   g.print(valueStr, self.x + WIDTH - TEXT_INSET - textWidth, self.y + TEXT_INSET)

   -- now the slider

   g.setColor(GREY)
   g.setLineWidth(1)

   g.line(self.nibX + 1, self.nibY, self.maxX, self.nibY)

   g.setColor(WHITE)
   g.setLineWidth(2)
   g.line(self.minX, self.nibY, self.nibX, self.nibY)

   local quad = (self.dragState == "dragging") and nibDraggingQ or nibNormalQ

   g.drawq(nibImage, quad, self.nibX, self.nibY, 0, 1, 1, 8, 8)
end

function Pane:update()

   local clicked = m.isDown("l")

   if not clicked then
      self.dragState = null
      self.dragXOffset = null
      return
   end

   if self.dragState == "dragging" then
      self:dragNib()
      return
   end

   -- If the initial click was not on the nib, then ignore until the release
   if self.dragState == "invalid" then
      return
   end

   if self:isMouseOverNib() then
      self.dragState = "dragging"
      self.dragXOffset = self.nibX - m.getX()
      return
   end

   -- Initial click not on nib
   self.dragState = "invalid"
end

local function inRange(value, min, max)
   return min <= value and value <= max
end

function Pane:isMouseOverNib()
   local mx, my = m.getPosition()

   return inRange(mx, self.nibX - 8, self.nibX + 8) and
      inRange(my, self.nibY - 8, self.nibY + 8)
end

function Pane:normalizeValue(value)
   return value
end

function Pane:dragNib()
   local x = m.getX() + self.dragXOffset

   if x < self.minX then
      x = self.minX
   end

   if x > self.maxX then
      x = self.maxX
   end
   
   self.nibX = x

   local newValue = (x - self.minX) / self.pixelIncrement + self.min

   _G[self.property] = self:normalizeValue(newValue)
end


local FloatPane = Pane:subclass("FloatPane")
local IntPane = Pane:subclass("IntPane")

function FloatPane:format(value)
   return string.format("%.2f", value)
end


function IntPane:format(value)
   return tostring(value)
end

function IntPane:normalizeValue(value)
   return math.floor(value)
end

local function setup()
   if not(paneImage) then
      paneImage = g.newImage "params/param-pane-bezel.png"
      WIDTH = paneImage:getWidth()
      HEIGHT = paneImage:getHeight()

      nibImage = g.newImage "params/param-slider-nib.png"
      nibNormalQ = g.newQuad(0, 0, 16, 16, 32, 16)
      nibDraggingQ = g.newQuad(16, 0, 16, 16, 32, 16)

      defaultFont = g.newFont()
   end
end

local nextPaneY = 2
local panes = {}

local function create(paneClass, property, min, max)
   setup()

   table.insert(panes, paneClass:new(2, nextPaneY, property, min, max))

   nextPaneY = nextPaneY + HEIGHT
end

-- Creates a new standard parameter pane; the parameter value can
-- range across the floating values between min and max
-- This is typically invoked from the love.load() callback
function params.float(property, min, max) 

   create(FloatPane, property, min, max)
end

function params.int(property, min, max)
   create(IntPane, property, min, max)
end

-- Must be called at the end of the love.draw() callback to draw the 
-- parameter panes (above all other graphics).

function params.draw() 
   -- Reset to the default font
   -- We'll set colors, and except that most everything else is in
   -- default state.
   g.setFont(defaultFont)

   for _, pane in pairs(panes) do
      pane:draw()
   end
end

-- Called to handle updates: primarily, checking to see ift he mouse is dragging
-- the slider inside each parameters pane. Should be called from the game's love.update()
-- callback.
function params.update()
   for _, pane in pairs(panes) do
      pane:update()
   end
end

function params.clear()
   panes = {}
   nextPaneY = 2
end

return params
