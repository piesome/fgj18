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
            if particle.image then
                if particle.smaller then
                    size = particle.size - (particle.size * (particle.age / particle.maxAge))
                else
                    size = particle.size
                end
                love.graphics.draw(particle.image, particle.position.x, particle.position.y, particle.rotationFactor * particle.rotation, size, size)
            else
                love.graphics.circle("line", particle.position.x, particle.position.y, particle.size)
            end
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
            particle.rotation = particle.rotation + dt
        end
        self.particles = aliveParticles
    end,
    add = function(self, particle)
        table.insert(self.particles, particle)
    end,
}

return ParticleManager
