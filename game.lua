gamestate = require "hump.gamestate"
Camera = require "hump.camera"
cpml = require "cpml"

constants = require "constants"
Grid = require "grid"
Ship = require "ship"
Enemy = require "enemy"
AsteroidField = require "asteroidField"
TargetManager = require "targetManager"
ProjectileManager = require "projectileManager"
Starmap = require "starmap"
ParticleManager = require "particleManager"

local game = {}

local camera = Camera(0, 0)
camera.smoother = Camera.smooth.none()

local music = love.audio.newSource("assets/music/untitled2.ogg", "stream")
local level, enemies, grid, asteroids, targets, starmap, projectiles, particles

function game:enter()
    self:loadLevel("level1")
    music:setLooping(true)
    music:play()
end

function game:leave()
    music:stop()
end

function game:loadLevel(name)
    level = require(name)

    grid = Grid(level.width, level.height)
    starmap = Starmap(level.width, level.height)
    ship = Ship(cpml.vec2.new(level.ship))
    asteroids = AsteroidField(level.asteroids)
    targets = TargetManager(level.targets)
    projectiles = ProjectileManager()
    particles = ParticleManager()

    enemies = {}
    for _, data in pairs(level.enemies) do
        table.insert(enemies, Enemy(cpml.vec2.new(data)))
    end
end

function draw()
    grid:draw()
    ship:draw()
    targets:draw()
    asteroids:draw()
    projectiles:draw()
    particles:draw()

    for _, enemy in pairs(enemies) do
        enemy:draw()
    end

    asteroids:drawShadowMap(ship.position)
end

function game:lookAtPlayer()
    camera:lockPosition(ship.position.x, ship.position.y)
end

function game:draw()
    starmap:draw(ship.position)
    camera:draw(draw)
    targets:drawHud(ship.position)
    ship:drawHud()
end

function game:update(dt)
    particles:update(dt)
    ship:update(dt, particles)
    ship.position = cpml.vec2.new(cpml.utils.clamp(ship.position.x, 0, level.width), cpml.utils.clamp(ship.position.y, 0, level.height))
    targets:update(dt)
    local ret = targets:checkTargets(ship.position)
    if ret ~= nil and ship.frogs >= ret[2] then
        for i=1, ret[2] do ship:loseFrog(particles) end
        targets:removeTarget(ret[1])
    end
    projectiles:update(dt, ship, particles)

    for _, enemy in pairs(enemies) do
        enemy:update(dt, ship, particles, projectiles)
    end
    self:lookAtPlayer()

    if targets.done then
        if level.nextLevel == nil then
            menu = require "menu"
            gamestate.switch(menu)
            return
        end
        self:loadLevel(level.nextLevel)
    end
end

function game:keyreleased(key)
    if key == "escape" then
        menu = require "menu"
        gamestate.switch(menu)
    end
end

return game
