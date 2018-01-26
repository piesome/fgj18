Class = require "hump.class"

Grid = Class{
    init = function(self)
        self.spacing = 50
        self.size = 1000
        self.color = {255, 255, 255, 100}
    end,
    draw = function(self)
        love.graphics.setColor(self.color)       
        for i = 0, self.size, self.spacing 
        do
            love.graphics.line(i, 0, i, self.size)
            love.graphics.line(0, i, self.size, i)
        end
    end,
}

return Grid