Class = require "hump.class"

Target = Class{}

function Target:init(number, position)
    self.number = number
    self.position = position
end

function Target:draw()
    love.graphics.print(tostring(self.number), self.position.x, self.position.y)
end

return Target
