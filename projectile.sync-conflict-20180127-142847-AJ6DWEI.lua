Class = require "hump.class"
cpml = require "cpml"
vec2 = cpml.vec2
vec3 = cpml.vec3
quat = cpml.quat

Projectile = Class{
    init = function(self, position, target)
        self.position = position
        self.target = target

        self.width = 5
        self.length = 15
        self.color = {100, 100, 255, 255}
        self.turnSpeed = 3
        self.speed = 100
        self.acceleration = 200
        self.friction = 0.5
        
        self.direction = vec2(1, 0)
        self.velocity = vec2(0.0001, 0)
    end,
    draw = function(self)
        love.graphics.push()

        love.graphics.setColor(self.color)       
        love.graphics.translate(self.position.x, self.position.y)
        love.graphics.rotate(math.pi / 2 - math.atan2(self.direction.x, self.direction.y))

        love.graphics.ellipse("line", 0, 0, self.length, self.width)

        love.graphics.pop()
    end,
    update = function(self, dt)        
        local targetDirection = ((self.target.position - self.position):normalize() - self.velocity:normalize() * 0.5):normalize()
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
        self.position = self.position + vec2(dt, dt) * self.velocity
        --self.position = self.position + vec2(dt * self.speed, dt * self.speed) * self.direction
    end,
}

return Projectile
