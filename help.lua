gamestate = require "hump.gamestate"

require "util"
Bubble = require "bubble"

local help = {}

function help:enter(_, next)
    self.bubbles = {}
    self.bubbleTimer = 0.5
    self.next = next
end

function help:leave()

end

local bgscale = gradient {
    direction = "horizontal";
    {144, 202, 249};
    {66, 165, 245}
}

function help:draw()
    love.graphics.setColor(144, 202, 249)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    drawinrect(bgscale, 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    for _, bubble in pairs(self.bubbles) do
        bubble:draw()
    end

    love.graphics.setColor(255, 255, 255)
    local text = [[
You're an intergalactic frog shipper with a cooling problem. Deliver 20 frogs to each indicated frog-station while dodging the enemy ships and their frog killing missiles. Keep your engines cool as frogs don't enjoy boiling to death.

Control your ship with the arrow keys. Press space to continue.
    ]]
    love.graphics.printf(text, 30, 30, love.graphics.getWidth() - 60)
end

function help:update(dt)
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

function help:keyreleased(key)
    if key == "space" then
        if self.next ~= nil then
            gamestate.switch(self.next)
        else
            gamestate.pop()
        end
    end
end

return help
