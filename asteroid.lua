Class = require "hump.class"
cpml = require "cpml"
vec2 = cpml.vec2

Asteroid = Class{
    init = function(self, position, radius)
        self.position = position
        self.radius = radius
        self.color = {255, 255, 255, 255}
        self.segmentCount = math.min(13, (radius / 3))
        self.points = {}
        each = ((math.pi * 2) / self.segmentCount)
        for i=1, self.segmentCount do
            rad = (each * i)
            pos = vec2.rotate(vec2.new(0, radius + love.math.random(-radius / 8, radius / 8)), rad)
            table.insert(self.points, self.position.x + pos.x)
            table.insert(self.points, self.position.y + pos.y)
        end
    end,
    draw = function(self)
        love.graphics.setColor(self.color)
        love.graphics.polygon("fill", self.points)
    end,
}

return Asteroid
