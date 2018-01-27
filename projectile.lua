Class = require "hump.class"
cpml = require "cpml"
vec2 = cpml.vec2

ParticleEmitter = require "particleEmitter"
ParticleEffects = require "particleEffects"

local missileImage = love.graphics.newImage("assets/graphics/missile.png")

Projectile = Class{
    init = function(self, position)
        self.position = position
        self.width = 5
        self.length = 15
        self.direction = vec2(1, 1)
        self.color = {255, 255, 255, 255}
        self.explosionRadius = 30

        self.velocity = vec2(0, 0)
        self.acceleration = 200
        self.friction = 0.3
        self.correctionFactor = 0.1
        self.turnSpeed = 1.5
        self.dead = false

        self.emitter = ParticleEmitter(self.position, self.direction, 5, {255, 127, 0, 127}, 0.1, 1, 0.3, 60)
    end,
    draw = function(self)
        if self.dead then
            return
        end

        love.graphics.push()

        love.graphics.setColor(self.color)       
        love.graphics.translate(self.position.x, self.position.y)
        love.graphics.rotate(math.pi / 2 + math.atan2(self.direction.y, self.direction.x))

        love.graphics.draw(missileImage, 0, 0, 0, 1, 1, missileImage:getWidth() / 2, missileImage:getHeight() / 2)

        love.graphics.pop()
    end,
    update = function(self, dt, target, particles)     
        if self.dead then
            return
        end

        local targetDirection = ((target - self.position):normalize() - self.velocity:normalize() * 0.5):normalize()
        local targetAngle = math.atan2(targetDirection.y, targetDirection.x)
        local currentAngle = math.atan2(self.direction.y, self.direction.x)

        local rotationDirection = 0
        if targetAngle < currentAngle then
            if math.abs(targetAngle-currentAngle) < math.pi then
                rotationDirection = -1
            else
                rotationDirection = 1
            end
        else 
            if math.abs(targetAngle-currentAngle) < math.pi then
                rotationDirection = 1
            else
                rotationDirection = -1
            end
        end  
        
        local nextAngle = currentAngle + dt * rotationDirection * self.turnSpeed
        self.direction = vec2(math.cos(nextAngle), math.sin(nextAngle))
        local velocityMult = (1 - self.friction * dt)
        self.velocity = self.velocity * (1 - self.friction * dt) + self.direction * dt * self.acceleration
        self.position = self.position + self.velocity * dt
        
        self.emitter.position = self.position - self.direction * self.length
        self.emitter.velocity = self.direction * -1 * self.acceleration + self.velocity
        self.emitter:update(dt, particles)

        if (target - self.position):len() <= self.explosionRadius then
            self.dead = true
            ParticleEffects:explosion(particles, self.position, self.velocity)
        end
    end,
}

return Projectile
