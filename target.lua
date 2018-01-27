Class = require "hump.class"
cpml = require "cpml"

local targetImage = love.graphics.newImage("assets/graphics/drugfrog.png")

Target = Class{}

function Target:init(number, position)
    self.number = number
    self.position = position
    self.rotation = 0
    self.frogRequirement = 20
end

function Target:update(dt)
    self.rotation = self.rotation + dt
end

function Target:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(targetImage, self.position.x, self.position.y, 0, 1, 1, targetImage:getWidth() / 2, targetImage:getHeight() / 2)
    textpos = self.position + cpml.vec2.rotate(cpml.vec2.new(0, 40), self.rotation)
    love.graphics.print(tostring(self.number), textpos.x, textpos.y, self.rotation - (math.pi), 1, 1, 16, 16)
end

return Target
