gamestate = require "hump.gamestate"

fonts = require "fonts"
game = require "game"

local music = love.audio.newSource("assets/music/untitled.ogg", "stream")

local menu = {}

function play()
    gamestate.switch(game)
end

function exit()
    love.event.push("quit")
end

function menu:enter()
    self.options = {{"Play", play}, {"Exit", exit}}
    self.selected = 1

    music:setLooping(true)
    music:play()
end

function menu:leave()
    music:stop()
end

function menu:draw()
    for i = 1,#self.options do
        if i == self.selected then
            love.graphics.setColor(200, 200, 200)
        else
            love.graphics.setColor(100, 100, 100)
        end
        love.graphics.print(self.options[i][1], 100, 200 + (i * 96))
    end

    love.graphics.setColor(255, 255, 255)
    love.graphics.print("kylmäkuljetus", 100, 100)
end

function menu:update()

end

function menu:keyreleased(key)
    if key == "up" then
        self.selected = math.max(1, self.selected-1)
    end
    if key == "down" then
        self.selected = math.min(#self.options, self.selected+1)
    end
    if key == "space" or key == "return" then
        self.options[self.selected][2]()
    end
    if key == "escape" then
        exit()
    end
end

return menu
