gamestate = require "hump.gamestate"
menu = require "menu"

function love.load()
    gamestate.switch(menu)
end
