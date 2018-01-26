Class = require "hump.class"
cpml = require "cpml"
vec2 = cpml.vec2

Asteroid = require "asteroid"

AsteroidField = Class{
    init = function(self)
        self.asteroids = {
            Asteroid(vec2(200, 500), 75),
            Asteroid(vec2(700, 700), 200)
        }
    end,
    draw = function(self)
        for key, asteroid in ipairs(self.asteroids) do
            asteroid:draw()
        end
    end,
}

return AsteroidField