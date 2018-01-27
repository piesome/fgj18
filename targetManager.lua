Class = require "hump.class"
cpml = require "cpml"

constants = require "constants"
Target = require "target"

TargetManager = Class{}

function TargetManager:init(data)
    self.targets = {}
    self.targetCount = #data
    self.nextTarget = 1
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

function TargetManager:checkTargets(playerPosition)
    for i=#self.targets, 1, -1 do
        target = self.targets[i]
        if cpml.vec2.dist2(target.position, playerPosition) < 30 then
            if target.number == self.nextTarget then
                self.nextTarget = self.nextTarget + 1
                if self.nextTarget >= self.targetCount then
                    self.done = true
                end

                table.remove(self.targets, i)
            end
        end
    end
end

return TargetManager
