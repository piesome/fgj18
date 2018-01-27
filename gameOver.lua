gamestate = require "hump.gamestate"

local gameOver = {}

function gameOver:enter()

end

function gameOver:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("game over", 100, 100)
end

function gameOver:keyreleased()
    menu = require "menu"
    gamestate.switch(menu)
end

return gameOver
