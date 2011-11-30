local g = love.graphics

local tween = require("tween")

local images = {}

local grid = {
   cell = {
      width = 101, -- width of individual cell
      height = 171, -- height of individual cell
      topOverlap = 49,
      bottomOverlap = 40
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

   local vertOffset

   if isPlayer then vertOffset = c.bottomOverlap +  c.topOverlap else vertOffset = c.topOverlap end

   return gridX * c.width, gridY * (c.height - c.topOverlap - c.bottomOverlap) - vertOffset
end

function love.load()
   love.keyboard.setKeyRepeat(10, 200)

   images.boy = g.newImage("Character Boy.png")
   images.stone = g.newImage("Stone Block.png")

   player.screenX, player.screenY = toScreenXY(player.gridX, player.gridY, true)
end

function love.draw()

   g.setColorMode("replace")

   for x = 0, grid.width - 1 do
      for y = 0, grid.height -1 do
         screenX, screenY = toScreenXY(x, y)
         g.draw(images.stone, screenX, screenY)
      end
   end
   
   g.setColor(255, 0, 0)
   g.rectangle("fill", player.screenX, player.screenY, grid.cell.width, grid.cell.height)
--   g.setColor(0, 0, 0, 255)

   g.draw(images.boy, player.screenX, player.screenY)


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

end
