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
            self:spawnMissile(vec2(0, 0), vec2(0, 0), vec2(-1, -1))
        end

        local aliveProjectiles = {}

        for index, projectile in ipairs(self.projectiles) do
            if projectile:update(dt, target.position, particles) then
                for i=1,5 do target:loseFrog(particles) end
            end
            if projectile.dead then
            else
                table.insert(aliveProjectiles, projectile)
            end
        end
        self.projectiles = aliveProjectiles
    end,
    spawnMissile = function(self, position, velocity, direction)
        table.insert(self.projectiles, Projectile(position, velocity, direction))
    end,
}

return ProjectileManager
