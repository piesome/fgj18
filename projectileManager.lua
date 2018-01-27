Class = require "hump.class"
cpml = require "cpml"
vec2 = cpml.vec2

Projectile = require "projectile"

ProjectileManager = Class{
    init = function(self, width, height)
        self.projectiles = {}
    end,
    draw = function(self)
        for index, projectile in ipairs(self.projectiles) do
            projectile:draw()
        end
    end,
    update = function(self, dt, target, particles)
        if love.keyboard.isDown("0") then
            table.insert(self.projectiles, Projectile(vec2(0, 0)))
        end

        local aliveProjectiles = {}

        for index, projectile in ipairs(self.projectiles) do
            projectile:update(dt, target.position, particles)
            if projectile.dead then
            else
                table.insert(aliveProjectiles, projectile)
            end
        end
        self.projectiles = aliveProjectiles
    end,
}

return ProjectileManager
