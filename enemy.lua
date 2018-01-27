Class = require "hump.class"
cpml = require "cpml"

local enemyImage = love.graphics.newImage("assets/graphics/enemyfighter.png")


Enemy = Class
    { position = cpml.vec2.new(100, 100)
    , velocity = cpml.vec2.new(0,0)
    , rotation = 0
    , angularVelocity = 0
    , sensorSensitivity = 0.0009 -- heat detection thereshold
    , thrust = 200
    , emitter = ParticleEmitter(vec2(0,0), vec2(0,0), 5, {255, 127, 0, 127}, 0.3, vec2(150, 150), 120)
    }

function Enemy:init(position)
    self.position = position
    return self
end

function Enemy:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(enemyImage, self.position.x, self.position.y, self.rotation, 1, 1, enemyImage:getWidth() / 2, enemyImage:getHeight() / 2)
end

function cpml.vec2.angle_between2(a, b)
    cross = a.x*b.y - a.y*b.x
    dot = a.x*b.x + a.y*b.y
    return math.atan2(cross, dot)
end

function Enemy:update(dt, ship, particles)
    toPlayerVec = ship.position - self.position
    playerHeatDetected = ship:radiationAtDistance(toPlayerVec:len())
    --print(playerHeatDetected)

    orientationVec = cpml.vec2(0,-1):rotate(self.rotation)
    if playerHeatDetected > self.sensorSensitivity then
        -- rotate and accelerate to player
        angleToPlayer = cpml.vec2.angle_between2(orientationVec, toPlayerVec)

        self.angularVelocity = self.angularVelocity + angleToPlayer * dt
        if angleToPlayer < math.pi/6 then
            acceleration = cpml.vec2.new(0, -self.thrust):rotate(self.rotation)
            self.velocity = self.velocity + acceleration * dt
        end
    end
    self.angularVelocity = self.angularVelocity - self.angularVelocity * dt
    self.rotation = self.rotation + self.angularVelocity * dt
    self.position = self.position + self.velocity * dt
    self.velocity = self.velocity - (self.velocity * dt * 0.8)

    self.emitter.position = self.position - cpml.vec2.rotate(cpml.vec2(0, -1), self.rotation) * enemyImage:getWidth() / 2
    self.emitter.velocity = self.velocity + cpml.vec2.rotate(cpml.vec2.normalize(velocityVector), self.rotation):normalize() * -200
    self.emitter:update(dt, particles)
end

return Enemy
