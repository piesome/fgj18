gamestate = require "hump.gamestate"

local help = {}

help.entrytime = nil
help.image = love.graphics.newImage("assets/piesome.png")

function help:enter()
    self.entrytime = love.timer.getTime()
    self.timeout = 90
    self.brightness = 0
    self.fadeOutTime = 0.2
    self.fadeInTime = 0.2
end

function help:draw()
    love.graphics.push()

    love.graphics.scale(love.graphics.getWidth() / self.image:getWidth(), love.graphics.getHeight() / self.image:getHeight())
    love.graphics.setColor(self.brightness, self.brightness, self.brightness)
    love.graphics.draw(self.image)

    love.graphics.pop()
end

function help:update(dt)
    if love.timer.getTime() >= self.entrytime + self.timeout then
        if self.brightness <= 0 then
            gamestate.pop()
        else
            self.brightness = self.brightness - dt * 255/self.fadeOutTime
        end
    else
        if self.brightness < 255 then
            self.brightness = self.brightness + dt * 255/self.fadeInTime
        end
    end
end

function help:keyreleased(key)
    self.timeout = 0
end

return help
