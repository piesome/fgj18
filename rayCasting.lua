
-- input vec2
-- returns positive if c is on the left side of line a b, else negative
-- denominator = normal * (B - A)
function orient2D(a, b, c)
    local d = a - c
    local e = b - c
    return d.x * e.y - d.y * e.x
end


function test2DRayPolygons(origin, dir, polygons)
    local segA = origin
    local segB = origin + dir * 10000 --
    for j, poly in next, polygons do
        for i=2,#poly do
            segC = poly[i-1]
            segD = poly[i]

            result = test2DSegmentSegment(segA,segB,segC,segD)

        end
    end
end


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


