gamestate = require "hump.gamestate"
splashscreen = require "splashscreen"
menu = require "menu"

function love.keypressed(key)
    if key == "f" then
        if love.window.getFullscreen() then
            love.window.setMode(720, 480, {
                resizable = true,
                centered = true,
                minwidth = 720,
                minheight = 480
            })
        else
            love.window.setFullscreen(true)
        end
    end
end

function love.load()
    love.graphics.setFont(fonts.menu)
    love.window.setMode(720, 480, {
        resizable = true,
        centered = true,
        minwidth = 720,
        minheight = 480
    })
    
    gamestate.registerEvents()
    gamestate.switch(menu)
end
