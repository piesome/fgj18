gamestate = require "hump.gamestate"

local splashScreen = {}

splashScreen.entrytime = nil
splashScreen.image = love.graphics.newImage("assets/piesome.png")

function splashScreen:enter()
    self.entrytime = love.timer.getTime()
    self.timeout = 3
    self.brightness = 0
    self.fadeOutTime = 0.2
    self.fadeInTime = 0.2
end

function splashScreen:draw()
    love.graphics.push()

    love.graphics.scale(love.graphics.getWidth() / self.image:getWidth(), love.graphics.getHeight() / self.image:getHeight())
    love.graphics.setColor(self.brightness, self.brightness, self.brightness)
    love.graphics.draw(self.image)

    love.graphics.pop()
end

function splashScreen:update(dt)
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

function splashScreen:keyreleased(key)
    self.timeout = 0
end

return splashScreen
