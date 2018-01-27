Class = require "hump.class"
cpml = require "cpml"
vec2 = cpml.vec2

heatRenderer = Class {}

function heatRenderer:init()
    local pixelcode = [[
        extern Image shadows;
        extern vec2 screen_size;
        varying vec4 vpos;
        extern vec2 ship_pos;
        extern float heat_radiation_output;
        vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
        {
            vec4 texcolor = Texel(shadows, screen_coords / screen_size);
            float d = length(ship_pos - vpos);
            float radiationP = clamp(0.0, 0.5, heat_radiation_output / pow(d - 30, 2) * 200);

            float c = radiationP;
            return texcolor * vec4(c,c,c,c) * vec4(1.0, 0.0, 0.0, 1.0);
        }
    ]]
    local vertexcode = [[
        varying vec4 vpos;
        vec4 position( mat4 transform_projection, vec4 vertex_position )
        {
            vpos = vertex_position;
            return transform_projection * vertex_position;
        }
    ]]
    self.shader = love.graphics.newShader(pixelcode, vertexcode)
end

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

function heatRenderer:preDraw(asteroids, ship)
    if (not self.canvas) or (self.canvas:getWidth() ~= love.graphics.getWidth() or self.canvas:getHeight() ~= love.graphics.getHeight()) then
        self.canvas = love.graphics.newCanvas()
    end

    love.graphics.push()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear(255, 255, 255, 255)
    asteroids:drawShadowMap(ship.position)
    love.graphics.setCanvas()
    love.graphics.pop()
end

function heatRenderer:draw(ship)
    local radius = ship.shipRadius + 10 + 50*50/5.5

    love.graphics.setShader(self.shader)
    self.shader:send("shadows", self.canvas)
    self.shader:send("screen_size", {love.graphics.getWidth(), love.graphics.getHeight()})
    self.shader:send("ship_pos", {ship.position.x, ship.position.y})
    self.shader:send("heat_radiation_output", ship.heatRadiationOutput)
    local segments = 8
    for i=1, segments, 1 do
        local angleStep = math.pi * 2 / segments
        local angleA = i * angleStep
        local angleB = (i + 1) * angleStep
        local vertices =
            { ship.position.x, ship.position.y
            , ship.position.x + math.cos(angleA) * radius, ship.position.y  + math.sin(angleA) * radius
            , ship.position.x + math.cos(angleB) * radius, ship.position.y  + math.sin(angleB) * radius
            }
        love.graphics.polygon("fill", vertices)
    end
    love.graphics.setShader()

end

return heatRenderer
