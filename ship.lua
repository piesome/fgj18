Class = require "hump.class"
cpml = require "cpml"

ParticleEmitter = require "particleEmitter"

local shipImage = love.graphics.newImage("assets/graphics/playership.png")

-- Converts HSL to RGB. (input and output range: 0 - 255)
function HSL(h, s, l, a)
	if s<=0 then return l,l,l,a end
	h, s, l = h/256*6, s/255, l/255
	local c = (1-math.abs(2*l-1))*s
	local x = (1-math.abs(h%2-1))*c
	local m,r,g,b = (l-.5*c), 0,0,0
	if     h < 1 then r,g,b = c,x,0
	elseif h < 2 then r,g,b = x,c,0
	elseif h < 3 then r,g,b = 0,c,x
	elseif h < 4 then r,g,b = 0,x,c
	elseif h < 5 then r,g,b = x,0,c
	else              r,g,b = c,0,x
	end return (r+m)*255,(g+m)*255,(b+m)*255,a
end

Ship = Class
    { position = cpml.vec2.new(100, 100)
    , velocity = cpml.vec2.new(0, 0)
    , rotation = math.pi
    , heatGeneration = 0      -- Current heat increase per second
    --, heatStored = 0        -- heat stored inside the ship
    , surfaceHeat = 100       -- heat stored on the surface
    , heatRadiationOutput = 0 -- calculated in heatUpdate
    , emissivity = 0.0001     -- how fast heat is radiated
    , thrusterHeat = 400      -- amount of heat generated by one thruster per second
    , shipRadius = 25         -- Used for heat calc and visuals
    , emitter = ParticleEmitter(vec2(0,0), vec2(0,0), 5, {255, 127, 0, 127}, 0.3, vec2(150, 150), 120)
    }

function Ship:init(position)
    self.position = position
    return self
end

function Ship:heatCircle(heatPercentage, radius)
    brightness = math.max(0.0, math.min(1.0, heatPercentage))*255
    love.graphics.setColor(HSL(0, 255, brightness, brightness))
    love.graphics.circle("fill", self.position.x, self.position.y, radius)
end

function Ship:draw()
    for x=1,50 do
        r = self.shipRadius + 10 + x*x/5.5
        visualHeat = self:radiationAtDistance(r*2) * 200
        self:heatCircle(visualHeat, r)
    end

    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(shipImage, self.position.x, self.position.y, self.rotation, 1, 1, shipImage:getWidth() / 2, shipImage:getHeight() / 2)
end

function Ship:radiationAtDistance(d)
    d = math.max(1.0, d - self.shipRadius + 5)
    return self.heatRadiationOutput / (d*d)  -- exponential falloff: 1 / r^2
end

function Ship:heatUpdate(dt)
    self.surfaceHeat = self.surfaceHeat + self.heatGeneration

    self.heatRadiationOutput = math.pow(self.surfaceHeat,2) * self.emissivity
    heatTransmission = self.heatRadiationOutput * dt
    self.surfaceHeat = self.surfaceHeat - heatTransmission

    --print(self.surfaceHeat, self.heatRadiationOutput)
end

function Ship:update(dt, particles)
    self.heatGeneration = 0
    velocityVector = cpml.vec2.new(0, 0)

    function move(thrust)
        velocityVector = velocityVector - cpml.vec2.new(0, thrust)
        self.heatGeneration = self.heatGeneration + self.thrusterHeat * dt

        self.emitter.position = self.position - cpml.vec2.rotate(cpml.vec2(0, -1), self.rotation) * shipImage:getWidth() / 2
        self.emitter.velocity = cpml.vec2.rotate(cpml.vec2.normalize(velocityVector), self.rotation):normalize() * -200
        self.emitter:update(dt, particles)
    end

    function rotate(rad)
        self.rotation = self.rotation + rad
    end

    if love.keyboard.isDown("left") then
        rotate(-1 * dt)
    end
    if love.keyboard.isDown("right") then
        rotate(1 * dt)
    end
    if love.keyboard.isDown("up") then
        move(1 * dt)
    end
    if love.keyboard.isDown("down") then
        move(-1 * dt)
    end
    self.velocity = self.velocity + cpml.vec2.rotate(cpml.vec2.normalize(velocityVector), self.rotation)
    self.position = self.position + self.velocity * dt
    self.velocity = self.velocity - (self.velocity * dt * 0.1)

    self:heatUpdate(dt)
end

return Ship
