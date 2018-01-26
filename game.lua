gamestate = require "hump.gamestate"

local game = {}

function game:enter()

end

function game:draw()

end

function game:update()

end

function game:keyreleased(key)
    if key == "escape" then
        menu = require "menu"
        gamestate.switch(menu)
    end
end

return game