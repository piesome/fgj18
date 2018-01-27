gamestate = require "hump.gamestate"
Camera = require "hump.camera"
cpml = require "cpml"

constants = require "constants"
Grid = require "grid"
Ship = require "ship"
Enemy = require "enemy"
AsteroidField = require "asteroidField"
TargetManager = require "targetManager"
Projectile = require "projectile"

local game = {}

local camera = Camera(0, 0)
camera.smoother = Camera.smooth.none()

local level, enemies, grid, asteroids, targets

function game:enter()
    self:loadLevel("level1")
end

function game:loadLevel(name)
    level = require(name)

    grid = Grid(level.width, level.height)
    ship = Ship(cpml.vec2.new(level.ship))
    asteroids = AsteroidField(level.asteroids)
    targets = TargetManager(level.targets)

    enemies = {}
    for _, data in pairs(level.enemies) do
        table.insert(enemies, Enemy(cpml.vec2.new(data)))
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

function game:lookAtPlayer()
    camera:lockPosition(ship.position.x, ship.position.y)
end

function game:draw()
    camera:draw(draw)
end

function game:update(dt)
    ship:update(dt)
    ship.position = cpml.vec2.new(cpml.utils.clamp(ship.position.x, 0, level.width), cpml.utils.clamp(ship.position.y, 0, level.height))
    targets:update(dt)
    targets:checkTargets(ship.position)

    for _, enemy in pairs(enemies) do
        enemy:update(dt)
    end
    self:lookAtPlayer()
end

function game:keyreleased(key)
    if key == "escape" then
        menu = require "menu"
        gamestate.switch(menu)
    end
end

return game
