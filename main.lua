gamestate = require "hump.gamestate"
menu = require "menu"

function love.load()
    gamestate.registerEvents()
    gamestate.switch(menu)
end
