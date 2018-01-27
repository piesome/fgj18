Class = require "hump.class"
cpml = require "cpml"
vec2 = cpml.vec2

Asteroid = require "asteroid"

AsteroidField = Class{
    init = function(self, data)
        self.asteroids = {}
        for _, datum in pairs(data) do
            table.insert(self.asteroids, Asteroid(vec2.new(datum[1], datum[2]), datum[3]))
        end
    end,
    draw = function(self)
        for key, asteroid in ipairs(self.asteroids) do
            asteroid:draw()
        end
    end,
}

return AsteroidField
