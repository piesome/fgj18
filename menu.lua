gamestate = require "hump.gamestate"
cpml = require "cpml"

fonts = require "fonts"
game = require "game"
ParticleManager = require "particleManager"
ParticleEmitter = require "particleEmitter"

local music = love.audio.newSource("assets/music/untitled.ogg", "stream")
local frogIcon = love.graphics.newImage("assets/graphics/drugfrog.png")
local deadFrog = love.graphics.newImage("assets/graphics/deadfrog.png")

local menuScrollSound = love.audio.newSource("assets/sfx/menu_scroll.wav", "static")
local menuChooseSound = love.audio.newSource("assets/sfx/menu_choose.wav", "static")

local menu = {}

function play()
    gamestate.switch(game)
end

function exit()
    love.event.push("quit")
end

function splash()
    splashScreen = require "splashScreen"
    gamestate.push(splashScreen)
end

function menu:enter()
    self.frogEmitter = ParticleEmitter(vec2(0,0), vec2(0,0), 0.25, {255, 255, 255, 255}, 2, 1, 1, 100)
    self.frogEmitter.image = deadFrog
    self.frogEmitter.rotationFactor = 3
    self.frogEmitter.smaller = true
    self.particles = ParticleManager()
    self.raining = false
    local particles = self.particles
    local frogEmitter = self.frogEmitter

    function suprise()
        self.raining = not self.raining
    end

    self.options = {{"play", play}, {"help", exit}, {"credits", splash}, {"suprise", suprise}, {"exit", exit}}
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
    end

    love.graphics.push()
    love.graphics.setColor(255, 255, 255)
    love.graphics.translate(0, love.graphics.getHeight() / 2)
    love.graphics.draw(frogIcon, 32, -32)
    love.graphics.print("kylmäkuljetus", 100, -32)
    love.graphics.pop()

    self.particles:draw()
end

function menu:update(dt)
    if self.rotation > self.targetRotation then
        self.rotation = self.rotation - dt
    end
    if self.rotation < self.targetRotation then
        self.rotation = self.rotation + dt
    end

    self.particles:update(dt)

    if self.raining then
        self.frogEmitter.position = cpml.vec2.new(love.math.random(love.graphics.getWidth()), -32)
        self.frogEmitter.velocity = cpml.vec2.new(0, 100)
        self.frogEmitter.maxAge = 7
        self.frogEmitter:update(dt, self.particles)
    end
end

function menu:keypressed(key)
    function scroll(i)
        self.selected = math.min(#self.options, self.selected - i)
        self.targetRotation = self.targetRotation + (-math.pi / 16) * i
        love.audio.play(menuScrollSound)
    end
    if key == "up" and self.selected > 1 then
        scroll(1)
    end
    if key == "down" and self.selected < #self.options then
        scroll(-1)
    end
end
function menu:keyreleased(key)
    if key == "space" or key == "return" then
        love.audio.play(menuChooseSound)
        self.options[self.selected][2]()
    end
    if key == "escape" then
        exit()
    end
end

return menu
