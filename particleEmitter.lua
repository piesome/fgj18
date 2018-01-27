Class = require "hump.class"
cpml = require "cpml"
vec2 = cpml.vec2

ParticleEmitter = Class{
    init = function(self, position, velocity, size, color, maxAge, velocityVariation, speed)
        self.position = position
        self.velocity = velocity
        self.size = size
        self.color = color
        self.maxAge = maxAge
        self.velocityVariation = velocityVariation
        self.counter = 0
        self.speed = speed
    end,
    update = function(self, dt, particles)
        self.counter = self.counter + dt
        while self.counter >= (1 / self.speed) do
            self.counter = self.counter - (1 / self.speed)
            local velocity = self.velocity + self.velocityVariation * vec2(math.random() - 0.5, math.random() - 0.5)
            particles:add(self.position, velocity, self.size, self.color, self.maxAge)
        end
    end,
}

return ParticleEmitter
