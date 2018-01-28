Class = require "hump.class"
cpml = require "cpml"

local Bubble = Class{
    init = function(self)
        self.size = love.math.random(20, 50)
        self.opacity = love.math.random(5, 25)
        self.position = cpml.vec2.new(love.math.random(-25, love.graphics.getWidth() + 25), love.graphics.getHeight() + self.size)
        self.speed = love.math.random(30, 75)
    end,
    draw = function(self)
        love.graphics.setColor(0, 0, 0, self.opacity)
        love.graphics.circle("fill", self.position.x, self.position.y, self.size / 2)
    end,
    update = function(self, dt)
        self.position = self.position - cpml.vec2.new(0, dt * self.speed)
        if self.position.y < -self.size then
            return true
        end

        return false
    end
}

return Bubble
