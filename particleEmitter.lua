Class = require "hump.class"
cpml = require "cpml"
vec2 = cpml.vec2

ParticleEmitter = Class{
    init = function(self, position, velocity, size, color, maxAge, velocityAngleVariation, velocityVariation, speed)
        self.position = position
        self.velocity = velocity
        self.size = size
        self.color = color
        self.maxAge = maxAge
        self.velocityAngleVariation = velocityAngleVariation
        self.velocityVariation = velocityAngleVariation
        self.counter = 0
        self.speed = speed
    end,
    update = function(self, dt, particles)
        self.counter = self.counter + dt
        while self.counter >= (1 / self.speed) do
            self.counter = self.counter - (1 / self.speed)
            particle = {}
            particle.position = self.position
            particle.velocity = self.velocity:rotate(self.velocityAngleVariation * (math.random() - 0.5)) * (1 - self.velocityVariation * (math.random() - 0.5))
            particle.size = self.size
            particle.color = self.color
            particle.age = 0
            particle.maxAge = self.maxAge
            particle.color = self.color

            particles:add(particle)
        end
    end,
}

return ParticleEmitter
