Class = require "hump.class"
cpml = require "cpml"

Enemy = Class
    { position = cpml.vec2.new(100, 100)
    }

function Enemy:init(position)
    self.position = position
    return self
end

function Enemy:draw()
    love.graphics.print("X", self.position.x, self.position.y)
end

function Enemy:update(dt)
end

return Enemy
