gamestate = require "hump.gamestate"

menu = require "menu"

local splashscreen = {}

splashscreen.entrytime = nil
splashscreen.image = love.graphics.newImage("assets/piesome.png")
splashscreen.timeout = 3
splashscreen.brightness = 0
splashscreen.fadeOutTime = 0.2
splashscreen.fadeInTime = 0.2

local function enter()
    gamestate.switch(menu)
end

function splashscreen:enter()
    self.entrytime = love.timer.getTime()
end

function splashscreen:draw()
    love.graphics.push()

    love.graphics.scale(love.graphics.getWidth() / self.image:getWidth(), love.graphics.getHeight() / self.image:getHeight())
    love.graphics.setColor(self.brightness, self.brightness, self.brightness)
    love.graphics.draw(self.image)

    love.graphics.pop()
end

function splashscreen:update(dt)
    if love.timer.getTime() >= self.entrytime + self.timeout then
        if self.brightness <= 0 then
            enter()
        else
            self.brightness = self.brightness - dt * 255/self.fadeOutTime
        end
    else
        if self.brightness < 255 then
            self.brightness = self.brightness + dt * 255/self.fadeInTime
        end
    end
end

function splashscreen:keyreleased(key)
    self.timeout = 0
end

return splashscreen
