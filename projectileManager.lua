Class = require "hump.class"
cpml = require "cpml"
vec2 = cpml.vec2

Projectile = require "projectile"

ProjectileManager = Class{
    init = function(self, width, height)
        self.projectiles = {Projectile(vec2(200, 200))}
    end,
    draw = function(self)
        for index, projectile in ipairs(self.projectiles) do
            projectile:draw()
        end
    end,
    update = function(self, dt, target)
        for index, projectile in ipairs(self.projectiles) do
            projectile:update(dt, target.position)
        end
    end,
}

return ProjectileManager
