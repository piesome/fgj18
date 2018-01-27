gamestate = require "hump.gamestate"
splashScreen = require "splashScreen"
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
    if key == "m" then
        if love.audio.getVolume() == 0 then
            love.audio.setVolume(1)
        else
            love.audio.setVolume(0)
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
    gamestate.push(menu)
    gamestate.push(splashScreen)
end
