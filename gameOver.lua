gamestate = require "hump.gamestate"

local music = love.audio.newSource("assets/music/gameover.ogg", "stream")

local gameOver = {}

function gameOver:enter(_, endStyle)
    self.endStyle = endStyle
    music:setLooping(false)
    music:play()
end

function gameOver:leave()
    music:stop()
end

function gameOver:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("game over " .. self.endStyle, 100, 100)
end

function gameOver:keyreleased()
    menu = require "menu"
    gamestate.switch(menu)
end

return gameOver
