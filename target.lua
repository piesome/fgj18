Class = require "hump.class"

local targetImage = love.graphics.newImage("assets/graphics/waypoint.png")

Target = Class{}

function Target:init(number, position)
    self.number = number
    self.position = position
end

function Target:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(targetImage, self.position.x, self.position.y, 0, 1, 1, targetImage:getWidth() / 2, targetImage:getHeight() / 2)
    love.graphics.print(tostring(self.number), self.position.x, self.position.y)
end

return Target
