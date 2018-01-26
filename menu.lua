gamestate = require "hump.gamestate"

fonts = require "fonts"

local menu = {}

function menu:enter()
    love.graphics.setFont(fonts.menu)
end

function menu:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.printf("fgj18", 100, 100, 100, "right")
end

function menu:update()

end

return menu
