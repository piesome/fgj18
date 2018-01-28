Class = require "hump.class"

local Starmap = Class{}

function Starmap:init(width, height)
    self.width = math.max(width, love.graphics.getWidth() + 200)
    self.height = math.max(height, love.graphics.getHeight() + 200)
    self.canvases = {}
    for i=1, 10 do
        table.insert(self.canvases, self:level())
    end
end

function Starmap:level()
    canvas = love.graphics.newCanvas(self.width, self.height)
    love.graphics.setCanvas(canvas)

    for i=1, 64 do
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.circle("fill", love.math.random(0, self.width), love.math.random(0, self.height), love.math.random(1, 3))
    end

    love.graphics.setCanvas()

    return canvas
end

function Starmap:draw(pos)
    for i, canvas in pairs(self.canvases) do
        love.graphics.push()
        love.graphics.setColor(255, 255, 255, 255 - (255 / i))
        love.graphics.setBlendMode("alpha")
        love.graphics.translate(-pos.x / (i + 2), -pos.y / (i + 2))
        love.graphics.draw(canvas)
        love.graphics.pop()
    end
end

return Starmap
