Class = require "hump.class"
cpml = require "cpml"
vec2 = cpml.vec2

require "util"
require "rayCasting"

Asteroid = Class{
    init = function(self, position, radius)
        self.position = position
        self.radius = radius
        self.color = {180, 120, 19, 255}
        self.segmentCount = math.min(13, (radius / 3))
        self.points = {}
        self.pointVectors = {}
        self.edges = {9999999, 9999999, -9999999, -9999999}
        function emax(i, p)
            if self.edges[i] < p then
                self.edges[i] = p
            end
        end
        function emin(i, p)
            if self.edges[i] > p then
                self.edges[i] = p
            end
        end
        self.boundingRadius = 0 -- larger than optimally tight bounding sphere

        each = ((math.pi * 2) / self.segmentCount)
        for i=1, self.segmentCount do
            rad = (each * i)
            local randomRadius = radius + love.math.random(-radius / 4, radius / 4)
            self.boundingRadius = math.max(self.boundingRadius, randomRadius)
            pos = vec2.rotate(vec2.new(0,randomRadius), rad)
            point = self.position + pos
            table.insert(self.points, point.x)
            table.insert(self.points, point.y)
            table.insert(self.pointVectors, point)

            emin(1, point.x)
            emin(2, point.y)
            emax(3, point.x)
            emax(4, point.y)
        end

        self.convexHullVectors = convexHull(self.pointVectors)
        self.convexHull = {}

        for i, vec in next, self.convexHullVectors do
            table.insert(self.convexHull, vec.x)
            table.insert(self.convexHull, vec.y)
        end

        local twidth = self.edges[3] - self.edges[1]
        local theight = self.edges[4] - self.edges[2]

        local canvas = love.graphics.newCanvas(twidth, theight)
        love.graphics.setCanvas(canvas)

        love.graphics.push()
        love.graphics.translate(-self.edges[1], -self.edges[2])
        love.graphics.setColor(255, 255, 255)
        love.graphics.polygon("fill", self.points)
        love.graphics.pop()

        love.graphics.setCanvas()
        local xx = self.edges[1]
        local yy = self.edges[2]

        function gen(x, y, r, g, b, a)
            if r + g + b == 0 then
                return 0, 0, 0, 0
            end

            local value = ((love.math.noise(xx + x / 32, yy + y / 32) * (love.math.noise(xx + x / 18, yy + y / 18)) * 2) - 1) * 0.15
            return HSL(32 / 360 * 255, 0.15 * 255, math.floor(((0.3 + value) * 16) + 0.5) * 16, 255)
        end

        local id = canvas:newImageData()
        id:mapPixel(gen)

        self.image = love.graphics.newImage(id)
    end,
    draw = function(self)
        love.graphics.draw(self.image, self.edges[1], self.edges[2])
        --love.graphics.setColor(self.color)
        --love.graphics.polygon("fill", self.points)

        -- debug hull
        --love.graphics.setColor(255,0,255)
        --love.graphics.polygon("line", self.convexHull)
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
