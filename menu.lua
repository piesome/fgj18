gamestate = require "hump.gamestate"
cpml = require "cpml"

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
    self.options = {{"play", play}, {"help", exit}, {"credits", exit}, {"suprise", exit}, {"exit", exit}}
    self.selected = 1
    self.rotation = 0
    self.targetRotation = 0

    music:setLooping(true)
    music:play()
end

function menu:leave()
    music:stop()
end

function menu:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.circle("line", love.graphics.getWidth() + 200, love.graphics.getHeight() / 2, 400)

    for i = 1,#self.options do
        if i == self.selected then
            love.graphics.setColor(200, 200, 200)
        else
            love.graphics.setColor(100, 100, 100)
        end
        love.graphics.push()

        local rot = (-math.pi / 16) * (i - 1) + self.rotation
        local origin = cpml.vec2.new(love.graphics.getWidth() + 200,  love.graphics.getHeight() / 2)
        local pos = origin + cpml.vec2.new(-390, -16):rotate(rot)
        love.graphics.printf(self.options[i][1]:upper(), pos.x, pos.y, 200, "left", rot)

        local rot1 = rot + (math.pi / 32)
        local rot2 = rot + (-math.pi / 32)
        local rot1pos = origin + cpml.vec2.new(-400, 0):rotate(rot1)
        local rot2pos = origin + cpml.vec2.new(-400, 0):rotate(rot2)
        love.graphics.setColor(200, 200, 200)
        love.graphics.line(origin.x, origin.y, rot1pos.x, rot1pos.y)
        love.graphics.line(origin.x, origin.y, rot2pos.x, rot2pos.y)


        love.graphics.pop()
    end

    love.graphics.setColor(255, 255, 255)
    love.graphics.print("kylmäkuljetus", 100, 100)
end

function menu:update(dt)
    if self.rotation > self.targetRotation then
        self.rotation = self.rotation - dt
    end
    if self.rotation < self.targetRotation then
        self.rotation = self.rotation + dt
    end
end

function menu:keypressed(key)
    if key == "up" and self.selected > 1 then
        self.selected = math.max(1, self.selected-1)
        self.targetRotation = self.targetRotation + (-math.pi / 16)
    end
    if key == "down" and self.selected < #self.options then
        self.selected = math.min(#self.options, self.selected+1)
        self.targetRotation = self.targetRotation - (-math.pi / 16)
    end
    if key == "space" or key == "return" then
        self.options[self.selected][2]()
    end
    if key == "escape" then
        exit()
    end
end

return menu
