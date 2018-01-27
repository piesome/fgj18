Class = require "hump.class"
cpml = require "cpml"
vec2 = cpml.vec2

Asteroid = require "asteroid"
RayCasting = require "rayCasting"

AsteroidField = Class{
    init = function(self, data)
        self.asteroids = {}
        for _, datum in pairs(data) do
            table.insert(self.asteroids, Asteroid(vec2.new(datum[1], datum[2]), datum[3]))
        end
    end,
    draw = function(self)
        for _, asteroid in ipairs(self.asteroids) do
            asteroid:draw()
        end
    end,
    drawShadowMap = function(self, position)
        for _, asteroid in ipairs(self.asteroids) do
            local vertices = {}
            for _, point in ipairs(asteroid.pointVectors) do
                local direction = (point - position) * 2
                local result = RayCasting.test2DRayPolygons(position, direction, {asteroid.pointVectors})
                if result then
                    table.insert(vertices, result[2])
                    --table.insert(vertices, result[2] + direction)
                end
            end
            local center = vec2()
            local count = 0
            for _, vertex in ipairs(vertices) do
                center = center + vertex
                count = count + 1
            end
            center = center / count
            local verticesWithAngles = {}
            for _, vertex in ipairs(vertices) do
                local pair = {}
                pair.angle = math.atan2(vertex.y - center.y, vertex.x - center.x)
                pair.pos = vertex
                table.insert(verticesWithAngles, pair)
            end
            --table.sort(verticesWithAngles, function(vertA, vertB) return vertA.angle > vertB.angle end)
            local vertexData = {}
            for _, pair in ipairs(verticesWithAngles) do
                table.insert(vertexData, pair.pos.x)
                table.insert(vertexData, pair.pos.y)
            end
            love.graphics.push()
            love.graphics.translate(0, 0)
            love.graphics.polygon("line", vertexData)    
            love.graphics.pop()
        end
    end,
}

return AsteroidField
