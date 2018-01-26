gamestate = require "hump.gamestate"
splashscreen = require "splashscreen"
game = require "game"

function love.load()
    love.graphics.setFont(fonts.menu)
    
    gamestate.registerEvents()
    gamestate.switch(game)
end
