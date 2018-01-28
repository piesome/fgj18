Class = require "hump.class"
cpml = require "cpml"
vec2 = cpml.vec2

Asteroid = require "asteroid"
RayCasting = require "rayCasting"

AsteroidField = Class{
    init = function(self, level)
        self.asteroids = {}

        for i=0,level.asteroids do
            local x = love.math.random(0, level.width)
            local y = love.math.random(0, level.height)
            local size = love.math.random(40, 150)
            local size2 = size*size
            local pos = vec2.new(x, y)
            local vecs = {}

            for _,v in ipairs(level.targets) do table.insert(vecs, vec2.new(v[1], v[2])) end
            for _,v in ipairs(level.enemies) do table.insert(vecs, vec2.new(v[1], v[2])) end
            table.insert(vecs, vec2.new(level.ship[1], level.ship[2]))

            for _,v in ipairs(vecs) do
                local delta = pos:sub(v)
                if delta:len2() < size2 + 10000 then
                    goto cont
                end
            end
            table.insert(self.asteroids, Asteroid(pos, size))
            ::cont::
        end
    end,
    draw = function(self)
        love.graphics.setColor(255, 255, 255)
        for _, asteroid in ipairs(self.asteroids) do
            asteroid:draw()
        end
    end,
    drawShadowMap = function(self, position, a)
        for _, asteroid in ipairs(self.asteroids) do
            local vertices = {}
            for _, point in ipairs(asteroid.pointVectors) do
                local direction = (point - position)*1.001
                if direction:len() > love.graphics.getWidth() then
                    break
                end
                local result = RayCasting.test2DRayPolygons(position, direction, {asteroid.pointVectors})
                if result then
                    table.insert(vertices, result[2] + direction:normalize() * 20)
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
                --love.graphics.setBlendMode("replace")
                love.graphics.translate(0, 0)
                love.graphics.setColor(a, a, a, a)
                love.graphics.polygon("fill", vertexData)
                --love.graphics.setBlendMode("alpha")
                love.graphics.pop()
            end
        end
    end,
    testRay = function(self, origin, dir, exitOnFirstHit)
        local polys = {}
        local boundingCircles = {}
        for _, a in next, self.asteroids do
            -- Bounding check
            if testRaySphere(origin, dir, a.position, a.boundingRadius) then
                table.insert(polys, a.convexHullVectors)
            end
        end

        return test2DRayPolygons(origin, dir, polys, exitOnFirstHit)
    end
}

return AsteroidField
