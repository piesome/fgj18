Class = require "hump.class"
cpml = require "cpml"
vec2 = cpml.vec2

Asteroid = Class{
    init = function(self, pos, radius)
        self.pos = pos
        self.radius = radius
        self.color = {255, 100, 100, 255}
    end,
    draw = function(self)
        love.graphics.setColor(self.color)       
        love.graphics.circle("line", self.pos.x, self.pos.y, self.radius)
    end,
}

return Asteroid