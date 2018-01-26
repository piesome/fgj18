gamestate = require "hump.gamestate"
Grid = require "grid"

local game = {}

local grid = Grid()

function game:enter()

end

function game:draw()
    grid:draw()
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
