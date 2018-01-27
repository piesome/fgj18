Class = require "hump.class"
cpml = require "cpml"
vec2 = cpml.vec2

ParticleEmitter = require "particleEmitter"

effects = {}

function effects:explosion(particles, position, velocity)
    local emitter = ParticleEmitter(position, velocity / 2, 5, {255, 127, 0, 64}, 0.5, 1.7, 0.6, 20)
    emitter:update(1, particles)
end

return effects
