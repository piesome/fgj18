gamestate = require "hump.gamestate"
Camera = require "hump.camera"
cpml = require "cpml"

fonts = require "fonts"
constants = require "constants"
Grid = require "grid"
Ship = require "ship"
Enemy = require "enemy"
AsteroidField = require "asteroidField"
TargetManager = require "targetManager"
ProjectileManager = require "projectileManager"
Starmap = require "starmap"
ParticleManager = require "particleManager"
HeatRenderer = require "heatRenderer"
gameOver = require "gameOver"

local game = {}

local camera = Camera(0, 0)
camera.smoother = Camera.smooth.none()

local music = love.audio.newSource("assets/music/untitled2.ogg", "stream")
local level, enemies, grid, asteroids, targets, starmap, projectiles, particles, heatRenderer

-- HeatRenderer.init allocates resources
heatRenderer = HeatRenderer()

function game:enter()
    self.playing = true
    self.deathTimeout = 3
    self.gameOverType = "lose"
    self.warnings = {}
    self.warnLoop = 0
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
    asteroids = AsteroidField(level)
    targets = TargetManager(level.targets)
    projectiles = ProjectileManager()
    particles = ParticleManager()

    enemies = {}
    for _, data in pairs(level.enemies) do
        table.insert(enemies, Enemy(cpml.vec2.new(data)))
    end
end

function preDraw()
    heatRenderer:preDraw(asteroids, ship)
end

function draw()
    grid:draw()
    heatRenderer:draw(ship)
    ship:draw()
    targets:draw()
    asteroids:draw()
    projectiles:draw()
    particles:draw()

    for _, enemy in pairs(enemies) do
        enemy:draw()
    end
end

function game:lookAtPlayer()
    camera:lockPosition(ship.position.x, ship.position.y)
end

function game:draw()
    camera:draw(preDraw)

    starmap:draw(ship.position)
    camera:draw(draw)

    self:drawWarnings()

    targets:drawHud(ship.position)
    ship:drawHud()
end

function game:drawWarnings()
    for i, warn in pairs(self.warnings) do
        love.graphics.setFont(fonts.small)
        local red = 160 + ((i * 30 + (self.warnLoop * 160)) % 95)
        --love.graphics.setColor(red, 0, 0, 255)
        love.graphics.setColor(255, 255, 255, 255)
        local width = 400
        local texts = {
            {255, 255, 255, 255},
            "/",
            {red, 0, 0, 255},
            "!",
            {255, 255, 255, 255},
            "\\ ",
            {red, 0, 0, 255},
            warn.msg,
            {255, 255, 255, 255},
            " /",
            {red, 0, 0, 255},
            "!",
            {255, 255, 255, 255},
            "\\"
        }
        love.graphics.printf(texts, (love.graphics.getWidth() / 2) - (width / 2), 24 + (32 * (i - 1)), width, "center")
    end
end

function game:warn(msg)
    for i, warn in pairs(self.warnings) do
        if warn.msg == msg then
            warn.iat = love.timer.getTime()
            return
        end
    end

    table.insert(self.warnings, {msg=msg, iat=love.timer.getTime()})
end

WARN = function (msg) game:warn(msg) end

function game:clampShip(dt)
    local border = 100
    function force(x, y)
        ship.velocity = ship.velocity + cpml.vec2.new(x, y) * dt
    end

    if ship.position.x < border then
        force(border - ship.position.x, 0)
    end
    if ship.position.y < border then
        force(0, border - ship.position.y)
    end
    if ship.position.x > level.width - border then
        force((level.width - border) - ship.position.x, 0)
    end
    if ship.position.y > level.height - border then
        force(0, (level.height - border) - ship.position.y)
    end
end

function game:over(type)
    self.playing = false
    self.gameOverType = type
end

function game:update(dt)
    particles:update(dt)

    self.warnLoop = (self.warnLoop + dt) % 0.6

    if not self.playing then
        self.deathTimeout = self.deathTimeout - dt

        if self.deathTimeout < 0 then
            if type == "win" and level.nextLevel ~= nil then
                self:loadLevel(level.nextLevel)

                return
            end

            gamestate.switch(gameOver, self.gameOverType)
        end

        return
    end

    for i=#self.warnings, 1, -1 do
        local warn = self.warnings[i]
        if warn.iat + 4 < love.timer.getTime() then
            table.remove(self.warnings, i)
        end
    end

    ship:update(dt, particles)
    self:clampShip(dt)
    targets:update(dt)
    local ret = targets:checkTargets(ship.position)
    if ret ~= nil then
        if ship.frogs < ret[2] then
            self:over("meh")
            return
        end
        for i=1, ret[2] do ship:loseFrog(particles) end
        targets:removeTarget(ret[1])
    end
    projectiles:update(dt, ship, particles, asteroids)

    for _, enemy in pairs(enemies) do
        enemy:update(dt, ship, particles, projectiles, asteroids)
    end
    self:lookAtPlayer()

    if targets.done then
        self:over("win")
        return
    end

    if ship.frogs <= 0 then
        self:over("lose")
    end
end

function game:keyreleased(key)
    if key == "escape" then
        menu = require "menu"
        gamestate.switch(menu)
    end
end

return game
