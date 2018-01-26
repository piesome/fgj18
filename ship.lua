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
    velocityVector = cpml.vec2.new(0, 0)
    if love.keyboard.isDown("left") then
        velocityVector = velocityVector - cpml.vec2.new(1, 0)
    end
    if love.keyboard.isDown("right") then
        velocityVector = velocityVector - cpml.vec2.new(-1, 0)
    end
    if love.keyboard.isDown("up") then
        velocityVector = velocityVector - cpml.vec2.new(0, 1)
    end
    if love.keyboard.isDown("down") then
        velocityVector = velocityVector - cpml.vec2.new(0, -1)
    end
    self.position = self.position + velocityVector
end

return Ship
