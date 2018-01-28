gamestate = require "hump.gamestate"

local music = love.audio.newSource("assets/music/gameover.ogg", "stream")

local gameOver = {}

function gameOver:enter(_, endStyle)
    self.endStyle = endStyle
    music:setLooping(false)
    music:play()

    if endStyle == "win" then
        self.text = [[
Congratulations! You successfully delivered the delirium-inducing frogs to the
local population centers, worsening the drug epidemic.
]]
    elseif endStyle == "lose" then
        self.text = [[
You ran out of frogs! Try to not kill them with your engine - stop accelerating
to cool down.
]]
    elseif endStyle == "meh" then
        self.text = [[
You tried to deliver frogs, but you didn't have enough. The angry mob destroyed
your ship, and you're now stranded at the station.
]]
    end
end

function gameOver:leave()
    music:stop()
end

function gameOver:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("Game over!", 100, 100)
    love.graphics.printf(self.text:gsub("\n", " "), 100, 200, love.graphics.getWidth() - 200)
end

function gameOver:keyreleased()
    menu = require "menu"
    gamestate.switch(menu)
end

return gameOver
