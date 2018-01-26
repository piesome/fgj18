gamestate = require "hump.gamestate"
Camera = require "hump.camera"
cpml = require "cpml"

constants = require "constants"
Grid = require "grid"
Ship = require "ship"
Enemy = require "enemy"
AsteroidField = require "asteroidField"
TargetManager = require "targetManager"

local game = {}
local ship = Ship()
local enemies = {}
local camera = Camera(0, 0)

local grid = Grid()
local asteroids = AsteroidField()
local targets = TargetManager()

function game:enter()
    ship = Ship()
    camera:lookAt(ship.position.x, ship.position.y)
    for i=1, 4 do
        table.insert(enemies, Enemy(cpml.vec2.new(love.math.random(constants.WIDTH), love.math.random(constants.HEIGHT))))
    end
end

function draw()
    grid:draw()
    asteroids:draw()
    ship:draw()
    targets:draw()

    for _, enemy in pairs(enemies) do
        enemy:draw()
    end
end

function game:draw()
    camera:draw(draw)
end

function game:update(dt)
    ship:update(dt)
    ship.position = cpml.vec2.new(cpml.utils.clamp(ship.position.x, 0, constants.WIDTH), cpml.utils.clamp(ship.position.y, 0, constants.HEIGHT))
    targets:checkTargets(ship.position)

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
