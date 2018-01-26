gamestate = require "hump.gamestate"
Camera = require "hump.camera"
cpml = require "cpml"

Asteroid = require "asteroid"
Grid = require "grid"
Ship = require "ship"
Enemy = require "enemy"

local WIDTH = 2048
local HEIGHT = 2048

local game = {}
local ship = Ship()
local enemies = {}
local camera = Camera(0, 0)

local grid = Grid()
local asteroid = Asteroid()

function game:enter()
    ship = Ship()
    camera:lookAt(ship.position.x, ship.position.y)
    for i=1, 4 do
        table.insert(enemies, Enemy(cpml.vec2.new(love.math.random(WIDTH), love.math.random(HEIGHT))))
    end
end

function draw()
    grid:draw()
    asteroid:draw()
    ship:draw()

    for _, enemy in pairs(enemies) do
        enemy:draw()
    end
end

function game:draw()
    camera:draw(draw)
end

function game:update(dt)
    ship:update(dt)

    for _, enemy in pairs(enemies) do
        enemy:update(dt)
    end
    camera:lookAt(ship.position.x, ship.position.y)
end

function game:keyreleased(key)
    if key == "escape" then
        menu = require "menu"
        gamestate.switch(menu)
    end
end
return game
