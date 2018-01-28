gamestate = require "hump.gamestate"

require "util"
Bubble = require "bubble"

local music = love.audio.newSource("assets/music/gameover.ogg", "stream")

local gameOver = {}

function gameOver:enter(_, endStyle)
    self.endStyle = endStyle
    self.bubbles = {}
    self.bubbleTimer = 0.5
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

local bgscale = gradient {
    direction = "horizontal";
    {239, 154, 154};
    {239, 83, 80}
}

function gameOver:draw()
    love.graphics.setColor(239, 154, 154)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    drawinrect(bgscale, 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    for _, bubble in pairs(self.bubbles) do
        bubble:draw()
    end

    love.graphics.setColor(255, 255, 255)
    love.graphics.print("Game over!", 100, 100)
    love.graphics.printf(self.text:gsub("\n", " "), 100, 200, love.graphics.getWidth() - 200)
end

function gameOver:update(dt)
    self.bubbleTimer = self.bubbleTimer - dt
    if self.bubbleTimer <= 0 then
        table.insert(self.bubbles, Bubble())
        self.bubbleTimer = 0.5
    end

    for i=#self.bubbles, 1, -1 do
        if self.bubbles[i]:update(dt) then
            table.remove(self.bubbles, i)
        end
    end
end

function gameOver:keyreleased()
    menu = require "menu"
    gamestate.switch(menu)
end

return gameOver
