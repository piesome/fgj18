Class = require "hump.class"
cpml = require "cpml"

constants = require "constants"
Target = require "target"

TargetManager = Class{}

local colors = {
    {0, 255, 0},
    {255, 0, 0},
    {0, 0, 255},
    {255, 255, 0},
    {0, 255, 255},
    {255, 255, 255}
}

function TargetManager:init(data)
    self.targets = {}
    self.targetCount = #data
    self.done = false

    for i, datum in pairs(data) do
        table.insert(self.targets, Target(i, cpml.vec2.new(datum)))
    end
end

function TargetManager:draw()
    for _, target in pairs(self.targets) do
        target:draw()
    end
end

function TargetManager:drawHud(playerPosition)
    for i, target in pairs(self.targets) do
        local nextPosition = target.position
        local radius = math.min(playerPosition:dist(nextPosition), math.min(love.graphics.getWidth(), love.graphics.getHeight()) / 2)
        local targetDirection = (playerPosition - nextPosition):normalize()
        local targetAngle = math.atan2(targetDirection.y, targetDirection.x)
        local origin = cpml.vec2.new(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
        local size = 13

        local point1 = origin + cpml.vec2.new(0, radius):rotate(targetAngle + (math.pi / 2))
        local point2 = origin + cpml.vec2.new(size/3, radius - size):rotate(targetAngle + (math.pi / 2))
        local point3 = origin + cpml.vec2.new(-size/3, radius - size):rotate(targetAngle + (math.pi / 2))

        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.polygon("line", point1.x, point1.y, point2.x, point2.y, point3.x, point3.y)

        love.graphics.setColor(colors[target.number])
        love.graphics.polygon("fill", point1.x, point1.y, point2.x, point2.y, point3.x, point3.y)
    end
end

function TargetManager:update(dt)
    for _, target in pairs(self.targets) do
        target:update(dt)
    end
end

function TargetManager:checkTargets(playerPosition)
    for i=#self.targets, 1, -1 do
        local target = self.targets[i]
        if cpml.vec2.dist(target.position, playerPosition) < 70 then
            return {target.number, target.frogRequirement}
        end
    end
    return nil
end

function TargetManager:removeTarget(number)
    for i=#self.targets, 1, -1 do
        local target = self.targets[i]
        if target.number == number then
            table.remove(self.targets, i)
            break
        end
    end

    if #self.targets == 0 then
        self.done = true
    end
end

return TargetManager
