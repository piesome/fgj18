Class = require "hump.class"
cpml = require "cpml"
vec2 = cpml.vec2

ParticleEmitter = require "particleEmitter"

effects = {}

function effects:explosion(particles, position, velocity)
    local emitter = ParticleEmitter(position, velocity / 5, 5, {255, 127, 0, 64}, 1, vec2(100, 100), 100)
    emitter:update(1, particles)
end

return effects
