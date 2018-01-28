Class = require "hump.class"
cpml = require "cpml"
vec2 = cpml.vec2

Asteroid = require "asteroid"
RayCasting = require "rayCasting"

AsteroidField = Class{
    init = function(self, level)
        self.asteroids = {}

        for i=0,level.asteroids do
            x = love.math.random(0, level.width)
            y = love.math.random(0, level.height)
            size = love.math.random(40, 150)
            table.insert(self.asteroids, Asteroid(vec2.new(x, y), size))
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
                local direction = (point - position)*2
                local result = RayCasting.test2DRayPolygons(position, direction, {asteroid.pointVectors})
                if result then
                    table.insert(vertices, result[2])
                    table.insert(vertices, result[2] + direction:normalize() * 1000)
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
            table.sort(verticesWithAngles, function(vertA, vertB) return vertA.angle > vertB.angle end)
            local vertexData = {}
            for _, pair in ipairs(verticesWithAngles) do
                table.insert(vertexData, pair.pos.x)
                table.insert(vertexData, pair.pos.y)
            end
            if #vertexData > 6 then
                love.graphics.push()
                love.graphics.setBlendMode("replace")
                love.graphics.translate(0, 0)
                love.graphics.setColor(0,0,0,0)
                love.graphics.polygon("fill", vertexData)
                love.graphics.setBlendMode("alpha")
                love.graphics.pop()
            end
        end
    end,
    testRay = function(self, origin, dir, exitOnFirstHit)
        polys = {}
        for _, a in next, self.asteroids do
            table.insert(polys, a.convexHullVectors)
        end
        return test2DRayPolygons(origin, dir, polys, exitOnFirstHit)
    end
}

return AsteroidField
