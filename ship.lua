Class = require "hump.class"
cpml = require "cpml"

Ship = Class
    { position = cpml.vec2.new(100, 100)
    }

function Ship:init()
    return self
end

function Ship:draw()
    love.graphics.print("@", self.position.x, self.position.y)
end

function Ship:update(dt)
    velocityVector = cpml.vec2.new(1, 0)
    self.position = self.position + velocityVector
end

return Ship
