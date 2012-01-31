local g = love.graphics

local tween = require("tween")

require("middleclass")

local images = {}

local grid = {
   cell = {
      width = 101, -- width of individual cell
      height = 171, -- height of individual cell
      topOverlap = 49,
      bottomOverlap = 40
   },
   frame = {
      top = 40,
      left = 8
   },
   width = 10, -- number of cells across
   height = 8, -- number of cells down
}

local player = {
   gridX = 3,
   gridY = 3,
   moving = false
}

local function toScreenXY(gridX, gridY, isPlayer)
   local c = grid.cell

   local vertOffset = isPlayer and (c.bottomOverlap + c.topOverlap) or c.topOverlap

   return gridX * c.width + grid.frame.left, gridY * (c.height - c.topOverlap - c.bottomOverlap) - vertOffset + grid.frame.top
end

function love.load()
   love.keyboard.setKeyRepeat(10, 200)

   images.boy = g.newImage("planet-cute/Character Boy.png")
   images.stone = g.newImage("planet-cute/Stone Block.png")

   player.screenX, player.screenY = toScreenXY(player.gridX, player.gridY, true)
end

function love.draw()

   g.setBackgroundColor(0, 127, 0)

   -- Draw in the background
   for x = 0, grid.width - 1 do
      for y = 0, grid.height -1 do
         screenX, screenY = toScreenXY(x, y)
         g.draw(images.stone, screenX, screenY)
      end
   end

   g.draw(images.boy, player.screenX, player.screenY)

end

function playerMoveComplete()
   player.moving = false
end

function movePlayer(xoffset, yoffset)

   player.gridX = player.gridX + xoffset
   player.gridY = player.gridY + yoffset

   local target = {}

   target.screenX, target.screenY = toScreenXY(player.gridX, player.gridY, true)

   if xoffset == 0 then target.screenX = null end
   if yoffset == 0 then target.screenY = null end

   player.moving = true

   tween.start(.5, player, target, tween.easing.inOutQuad, playerMoveComplete)
end

function movePlayerUp()
   if player.gridY ~= 0 then movePlayer(0, -1) end
end

function movePlayerLeft()
   if player.gridX ~= 0 then movePlayer(-1, 0) end
end

function movePlayerRight()
   if player.gridX + 1 < grid.width then movePlayer(1, 0) end
end

function movePlayerDown()
   if player.gridY + 1 < grid.height then movePlayer(0, 1) end
end


function love.update(dt)
   tween.update(dt)
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

   if not player.moving then

      if key == "up" then movePlayerUp() return end

      if key == "down" then movePlayerDown() return end

      if key == "right" then movePlayerRight() return end

      if key == "left" then movePlayerLeft() return end
   end


end
