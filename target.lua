Class = require "hump.class"
cpml = require "cpml"

local targetImage = love.graphics.newImage("assets/graphics/station.png")

Target = Class{}

function Target:init(number, position)
    self.number = number
    self.position = position
    self.rotation = 0
    self.frogRequirement = 20
    self.frame = 0
    self.frameCounter = 0.5
end

function Target:update(dt)
    self.rotation = self.rotation + (dt * 0.25)
    self.frameCounter = self.frameCounter - dt
    if self.frameCounter < 0 then
        self.frame = self.frame + 1
        self.frameCounter = 0.5
        if self.frame > 2 then
            self.frame = 0
        end
    end
end

function Target:draw()
    love.graphics.setColor(255, 255, 255)
    quad = love.graphics.newQuad(self.frame * (targetImage:getWidth() / 3), 0, (targetImage:getWidth() / 3), targetImage:getHeight(), targetImage:getWidth(), targetImage:getHeight())
    love.graphics.draw(targetImage, quad, self.position.x, self.position.y, self.rotation, 1, 1, targetImage:getWidth() / 6, targetImage:getHeight() / 2)
end

return Target
