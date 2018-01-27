Class = require "hump.class"
cpml = require "cpml"
vec2 = cpml.vec2
require "rayCasting"

Asteroid = Class{
    init = function(self, position, radius)
        self.position = position
        self.radius = radius
        self.color = {180, 120, 19, 255}
        self.segmentCount = math.min(13, (radius / 3))
        self.points = {}
        self.pointVectors = {}
        each = ((math.pi * 2) / self.segmentCount)
        for i=1, self.segmentCount do
            rad = (each * i)
            pos = vec2.rotate(vec2.new(0, radius + love.math.random(-radius / 4, radius / 4)), rad)
            point = self.position + pos
            table.insert(self.points, point.x)
            table.insert(self.points, point.y)
            table.insert(self.pointVectors, point)
        end
        self.convexHullVectors = convexHull(self.pointVectors)
        self.convexHull = {}
        for i, vec in next, self.convexHullVectors do
            table.insert(self.convexHull, vec.x)
            table.insert(self.convexHull, vec.y)
        end
    end,
    draw = function(self)
        love.graphics.setColor(self.color)
        love.graphics.polygon("fill", self.points)

        -- debug hull
        love.graphics.setColor(255,0,255)
        love.graphics.polygon("line", self.convexHull)
    end,
}


-- Andrew's algorithm
function convexHull(points)
    -- clone
    p = {}
    for index, value in next, points do
        table.insert(p, value:clone())
    end

    -- sort
    table.sort(p, function(vecA, vecB) return vecA.x < vecB.x end)

    -- upper chain
    uc = {p[1]}
    cIx = 1 -- index

    i = 2
    while i <= #p do
        x = p[i]
        if #uc < 2 or orient2D(uc[cIx-1], uc[cIx], x) < 0 then -- right: tentatively part of hull
            cIx = cIx + 1
            uc[cIx] = x
            i = i + 1
        else -- left: previous point was an error
            table.remove(uc)
            cIx = cIx - 1
        end
    end

    -- lower chain
    lc = {p[1]}
    cIx = 1 -- index

    i = 2
    while i <= #p do
        x = p[i]
        if #lc < 2 or orient2D(lc[cIx-1], lc[cIx], x) > 0 then -- left:  tentatively part of hull
            cIx = cIx + 1
            lc[cIx] = x
            i = i + 1
        else -- right: previous point was an error
            table.remove(lc)
            cIx = cIx - 1
        end
    end

    result = uc
    -- reverse other chain
    for i=#lc -1, 2, -1 do
        table.insert(result, lc[i])
    end

    return result
end


return Asteroid
