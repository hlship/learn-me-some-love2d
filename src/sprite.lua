Sprite = class("Sprite")

function Sprite:initialize(x, y, image)
  self.x = x
  self.y = y
  self.image = image

  self.width = image:getWidth
  self.height = image:getHeight

  self.rotation = 0
end

function Sprite:draw(g)

   g.setColor(255, 255, 255)
   g.line(self.x, 0, self.x, g.getHeight())
   g.line(0, self.y, g.getWidth(), self.y)

   g.push()

   local dx, dy = self.x + self.width / 2, self.y + self.height / 2
   g.translate(-dx, -dy)
   g.rotate(self.rotation)
   g.traslate(dx, dy)

   -- g.draw(self.image, self.x, self.y)   

   g.pop()
end
