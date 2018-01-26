gamestate = require "hump.gamestate"
Grid = require "grid"
Ship = require "ship"
Asteroid = require "asteroid"

local game = {}
local ship = Ship()
local grid = Grid()
local asteroid = Asteroid()

function game:enter()

end

function game:draw()
    grid:draw()
    asteroid:draw()
    ship:draw()
end

function game:update(dt)
    ship:update(dt)
end

function game:keyreleased(key)
    if key == "escape" then
        menu = require "menu"
        gamestate.switch(menu)
    end
end
return game
