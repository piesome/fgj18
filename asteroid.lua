Class = require "hump.class"
cpml = require "cpml"
vec2 = cpml.vec2

Asteroid = Class{
    init = function(self, position, radius)
        self.position = position
        self.radius = radius
        self.color = {255, 100, 100, 255}
    end,
    draw = function(self)
        love.graphics.setColor(self.color)       
        love.graphics.circle("line", self.position.x, self.position.y, self.radius)
    end,
}

return Asteroid
