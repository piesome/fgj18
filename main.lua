gamestate = require "hump.gamestate"
splashscreen = require "splashscreen"

function love.load()
    gamestate.registerEvents()
    gamestate.switch(splashscreen)
end
