Class = require "hump.class"

Grid = Class{
    init = function(self, width, height)
        self.spacing = 250
        self.color = {255, 255, 255, 50}
        self.width = width
        self.height = height
    end,
    draw = function(self)
        love.graphics.setColor(self.color)

        for i = 0, self.height, self.spacing do
            love.graphics.line(i, 0, i, self.height)
        end

        for i = 0, self.width, self.spacing do
            love.graphics.line(0, i, self.width, i)
        end
    end,
}

return Grid
