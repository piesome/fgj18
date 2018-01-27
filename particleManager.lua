Class = require "hump.class"
cpml = require "cpml"
vec2 = cpml.vec2

ParticleManager = Class{
    init = function(self)
        self.particles = {}
    end,
    draw = function(self)
        for index, particle in ipairs(self.particles) do
            love.graphics.setColor(particle.color)
            love.graphics.circle("line", particle.position.x, particle.position.y, particle.size)
        end
    end,
    update = function(self, dt, target)
        local aliveParticles = {}
        for index, particle in ipairs(self.particles) do
            if particle.age <= particle.maxAge then
                table.insert(aliveParticles, particle)
            end
            particle.position = particle.position + particle.velocity * dt
            particle.age = particle.age + dt
        end
        self.particles = aliveParticles
    end,
    add = function(self, particle)
        table.insert(self.particles, particle)
    end,
}

return ParticleManager
