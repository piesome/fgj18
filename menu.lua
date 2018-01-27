gamestate = require "hump.gamestate"

fonts = require "fonts"
game = require "game"

local music = love.audio.newSource("assets/music/untitled.ogg", "stream")

local menu = {}

function menu:enter()
    music:setLooping(true)
    music:play()
end

function menu:leave()
    music:stop()
end

function menu:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("kylmäkuljetus", 100, 100)
end

function menu:update()

end

function menu:keyreleased(key)
    if key == "space" then
        gamestate.switch(game)
    end
end

return menu
