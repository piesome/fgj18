Class = require "hump.class"
cpml = require "cpml"
vec2 = cpml.vec2

Projectile = Class{
    init = function(self, position, target)
        self.position = position
        self.target = target
        self.width = 5
        self.length = 15
        self.direction = vec2(1, 1)
        self.speed = 100
        self.color = {100, 100, 255, 255}
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
        local targetDirection = vec2.normalize(self.target.position - self.position)

        self.direction = targetDirection
        self.position = self.position + vec2(dt * self.speed, dt * self.speed) * self.direction
    end,
}

return Projectile
