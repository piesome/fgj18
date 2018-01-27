Class = require "hump.class"
cpml = require "cpml"

local enemyImage = love.graphics.newImage("assets/graphics/enemyfighter.png")


Enemy = Class
    { position = cpml.vec2.new(100, 100)
    }

function Enemy:init(position)
    self.position = position
    return self
end

function Enemy:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(enemyImage, self.position.x, self.position.y, 0, 1, 1, enemyImage:getWidth() / 2, enemyImage:getHeight() / 2)
end

function Enemy:update(dt)
end

return Enemy
