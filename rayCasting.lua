cpml = require "cpml"
vec2 = cpml.vec2
-- input vec2
-- returns positive if c is on the left side of line a b, else negative
-- denominator = normal * (B - A)
function orient2D(a, b, c)
    local d = a - c
    local e = b - c
    return d.x * e.y - d.y * e.x
end


function test2DRayPolygons(origin, dir, polygons, exitOnFirstHit)
    local minResult = {1.0, nil} -- max tracing distance

    for j, poly in next, polygons do
        segC = poly[#poly]
        for i=1,#poly do
            segD = poly[i]

            result = test2DRaySegment(origin, dir, segC, segD)
            if result ~= nil then
                if result[1] < minResult[1] then
                    if exitOnFirstHit then
                        return result
                    else
                        result[3] = segD - segC -- normal
                        result[4] = i           -- i th polygon
                        minResult = result
                    end
                end
            end
            segC = segD
        end
    end
    if minResult[2] ~= nil then
        return minResult
    else
        return nil
    end
end

--function test2DRayPolygons(origin, dir, polygons)
--    local segA = origin
--    local segB = origin + dir * 10000 -- max tracing distance
--    return test2DSegmentPolygons(segA, segB, polygons)
--end
--
--function test2DSegmentPolygons(segA, segB, polygons)
--    local minResult = {10000, nil} -- max tracing distance
--
--    for j, poly in next, polygons do
--        segC = poly[#poly]
--        for i=1,#poly do
--            segD = poly[i]
--
--            v = (segD - segC):normalize() * 0.002
--            segC = segC - v
--            segD = segD + v
--
--            result = test2DSegmentSegment(segA,segB,segC,segD)
--            if result ~= nil then
--                if result[1] < minResult[1] then
--                    minResult = result
--                end
--            end
--            segC = segD
--        end
--    end
--    if minResult[2] ~= nil then
--        return minResult
--    else
--        return nil
--    end
--end


-- Test if segments ab and cd overlap. If they do, compute and return
-- intersection t value along ab and intersection position p
-- Reference: Real-Time Collision detection book
function test2DSegmentSegment(a,b,c,d)
    -- Sign of areas correspond to which side of ab points c and d are
    local a1 = orient2D(a, b, d) -- Compute winding of abd (+ or -)
    local a2 = orient2D(a, b, c) -- To intersect, must have sign opposite of a1

    -- If c and d are on different sides of ab, areas have different signs
    if (a1 * a2 < 0.0) then
        -- Compute signs for a and b with respect to segment cd
        local a3 = orient2D(c, d, a) -- Compute winding of cda (+ or -)
        -- Since area is constant a1 - a2 = a3 - a4, or a4 = a3 + a2 - a1
        local a4 = orient2D(c, d, b) -- Must have opposite sign of a3
        local a4 = a3 + a2 - a1
        -- Points a and b on different sides of cd if areas have different signs
        if (a3 * a4 < 0.0) then
            -- Segments intersect. Find intersection point along L(t) = a + t * (b - a).
            -- Given height h1 of an over cd and height h2 of b over cd,
            -- t = h1 / (h1 - h2) = (b*h1/2) / (b*h1/2 - b*h2/2) = a3 / (a3 - a4),
            -- where b (the base of the triangles cda and cdb, i.e., the length
            -- of cd) cancels out.
            local t = a3 / (a3 - a4)
            local p = a + (b - a) * t
            return {t, p}
        end
    end
    -- Segments not intersecting (or collinear)
    return nil
end

-- https://rootllama.wordpress.com/2014/06/20/ray-line-segment-intersection-test-in-2d/
function test2DRaySegment(origin, dir, a, b)
    local v1 = origin - a
    local v2 = b - a
    local v3 = dir:perpendicular()
    local x = v2:dot(v3)
    local t2 = v1:dot(v3) / x
    if t2 < 1.001 and t2 > -0.001 then
        local t1 = -v1:cross(v2) / x
        if t1 > -0.001 then
            return {t1, origin + dir*t1}
        else
            return nil
        end
    else
        return nil
    end
end

-- Test if ray r = p + td intersects sphere with center c and radius r
-- returns boolean
function testRaySphere(p, d, c, r)
    m = p - c;
    c = vec2.dot(m, m) - r * r
    -- If there is definitely at least one real root, there must be an intersection
    if c <= 0.0 then return true end
    b = vec2.dot(m, d)
    -- Early exit if ray origin outside sphere and ray pointing away from sphere
    if b > 0.0 then return false end
    disc = b*b - c
    -- A negative discriminant corresponds to ray missing sphere
    if disc < 0.0 then return false end
    -- Now ray must hit sphere
    return true
end

return
    { test2DRayPolygons = test2DRayPolygons
    }
