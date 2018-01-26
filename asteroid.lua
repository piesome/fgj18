Class = require "hump.class"
cpml = require "cpml"
vec2 = cpml.vec2

Asteroid = Class{
    init = function(self)
        self.pos = vec2(500, 200)
        self.rasius = 100
        self.color = {255, 100, 100, 255}
    end,
    draw = function(self)
        love.graphics.setColor(self.color)       
        love.graphics.circle("line", self.pos.x, self.pos.y, self.rasius)
    end,
}

return Asteroid