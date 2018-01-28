gamestate = require "hump.gamestate"
Class = require "hump.class"
cpml = require "cpml"

require "util"
fonts = require "fonts"
game = require "game"
ParticleManager = require "particleManager"
ParticleEmitter = require "particleEmitter"
Bubble = require "bubble"

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

function help()
    helpScreen = require "help"
    gamestate.push(helpScreen)
end

function fullscreen()
    if love.window.getFullscreen() then
        love.window.setMode(720, 480, {
            resizable = true,
            centered = true,
            minwidth = 720,
            minheight = 480
        })
    else
        love.window.setFullscreen(true)
    end
end

function audio()
    if love.audio.getVolume() == 0 then
        love.audio.setVolume(1)
    else
        love.audio.setVolume(0)
    end
end

function videoLabel()
    if love.window.getFullscreen() then
        return "windowed"
    else
        return "fullscreen"
    end
end

function audioLabel()
    if love.audio.getVolume() == 1 then
        return "mute audio"
    else
        return "play audio"
    end
end

function menu:enter()
    self.frogEmitter = ParticleEmitter(vec2(0,0), vec2(0,0), 0.25, {255, 255, 255, 255}, 2, 1, 1, 100)
    self.frogEmitter.image = deadFrog
    self.frogEmitter.rotationFactor = 3
    self.frogEmitter.smaller = true
    self.particles = ParticleManager()
    self.raining = false
    self.extra = 0
    self.extraTarget = 0
    self.bubbles = {}
    self.bubbleTimer = 0.5
    local particles = self.particles
    local frogEmitter = self.frogEmitter

    function surprise()
        self.raining = not self.raining
    end

    self.options = {
        {"surprise", surprise},
        {audioLabel, audio},
        {videoLabel, fullscreen},
        {"play", play},
        {"help", help},
        {"credits", splash},
        {"exit", exit}
    }
    self.selected = 4
    self.rotation = (-math.pi / 16) * -3
    self.targetRotation = (-math.pi / 16) * -3

    music:setLooping(true)
    music:play()
end

function menu:leave()
    music:stop()
end

local rgb = love.graphics.setColor

local bgscale = gradient {
    direction = "horizontal";
    {165, 214, 167};
    {102, 187, 106};
}

function menu:draw()
    rgb(165, 214, 167)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    drawinrect(bgscale, 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    for _, bubble in pairs(self.bubbles) do
        bubble:draw()
    end

    rgb(56, 142, 60, 100)
    love.graphics.circle("fill", love.graphics.getWidth() + 300, love.graphics.getHeight() / 2, 600)

    rgb(67, 160, 71, 100)
    love.graphics.circle("line", love.graphics.getWidth() + 300, love.graphics.getHeight() / 2, 600)

    local origin = cpml.vec2.new(love.graphics.getWidth() + 300,  love.graphics.getHeight() / 2)

    for i = 1,#self.options do
        local rot = (-math.pi / 16) * (i - 1) + self.rotation
        local pos = origin + cpml.vec2.new(-590, -16):rotate(rot)

        local lennn = 600 + ((i == self.selected) and self.extra or 0)
        local rot1 = rot + (math.pi / 32)
        local rot2 = rot + (-math.pi / 32)
        local rot1pos = origin + cpml.vec2.new(-lennn, 0):rotate(rot1)
        local rot2pos = origin + cpml.vec2.new(-lennn, 0):rotate(rot2)

        rgb(67, 160, 71, 100)
        love.graphics.line(origin.x, origin.y, rot1pos.x, rot1pos.y)
        love.graphics.line(origin.x, origin.y, rot2pos.x, rot2pos.y)

        rgb(224, 224, 224)

        if i == self.selected then
            rgb(255, 255, 255)
            love.graphics.arc("fill", origin.x, origin.y, lennn, rot1 + math.pi, rot2 + math.pi)

            rgb(33, 33, 33)
        end

        local text = self.options[i][1]
        if type(text) ~= "string" then
            text = text()
        end
        love.graphics.printf(text:lower(), pos.x, pos.y, 300, "left", rot)
    end

    love.graphics.push()
    love.graphics.setColor(255, 255, 255)
    love.graphics.translate(0, love.graphics.getHeight() / 2)
    love.graphics.draw(frogIcon, 32, -48)
    love.graphics.print("kylmäkuljetus", 100, -32)
    love.graphics.pop()

    self.particles:draw()
end

function menu:update(dt)
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

    if self.rotation > self.targetRotation then
        self.rotation = self.rotation - dt
    end
    if self.rotation < self.targetRotation then
        self.rotation = self.rotation + dt
    end

    if self.extra < 20 then
        self.extra = self.extra + dt * 80
    end

    self.particles:update(dt)

    if self.raining then
        self.frogEmitter.position = cpml.vec2.new(love.math.random(love.graphics.getWidth()), -32)
        self.frogEmitter.velocity = cpml.vec2.new(0, 100)
        self.frogEmitter.maxAge = 7
        self.frogEmitter:update(dt, self.particles)
    end
end

function menu:scroll(i)
    self.selected = math.min(#self.options, self.selected - i)
    self.targetRotation = self.targetRotation + (-math.pi / 16) * i
    self.extra = 0
    love.audio.play(menuScrollSound)
end

function menu:keypressed(key)
    if key == "up" and self.selected > 1 then
        self:scroll(1)
    end
    if key == "down" and self.selected < #self.options then
        self:scroll(-1)
    end
end
function menu:keyreleased(key)
    if key == "space" or key == "return" then
        love.audio.play(menuChooseSound)
        self.extra = 0
        self.options[self.selected][2]()
    end
    if key == "escape" then
        exit()
    end
end

return menu
