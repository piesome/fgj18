gamestate = require "hump.gamestate"

fonts = require "fonts"
game = require "game"

local menu = {}

function menu:enter()
    love.graphics.setFont(fonts.menu)
end

function menu:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("fgj18", 100, 100)
end

function menu:update()

end

function menu:keyreleased(key)
    if key == "space" then
        gamestate.switch(game)
    end
end

return menu
