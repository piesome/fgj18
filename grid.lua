Class = require "hump.class"

constants = require "constants"

Grid = Class{
    init = function(self)
        self.spacing = 50
        self.color = {255, 255, 255, 100}
    end,
    draw = function(self)
        love.graphics.setColor(self.color)       
        for i = 0, constants.HEIGHT, self.spacing
        do
            love.graphics.line(i, 0, i, constants.HEIGHT)
            love.graphics.line(0, i, constants.WIDTH, i)
        end
    end,
}

return Grid
