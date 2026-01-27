-- coin.lua
local Coin = {}
Coin.__index = Coin

function Coin:new(x, y, lifetime, radius)
    local obj = {
        x = x or 0,
        y = y or 0,
        t = lifetime or 20,
        radius = radius or 12
    }
    setmetatable(obj, self)
    return obj
end

function Coin:reset(x, y, lifetime, radius)
    self.x = x or self.x
    self.y = y or self.y
    self.t = lifetime or self.t
    self.radius = radius or self.radius
end

function Coin:update(dt)
    self.t = self.t - dt
end

function Coin:isCollectedBy(unicorn)
    -- Treat unicorn as an axis-aligned rectangle and coin as a circle.
    -- This checks whether the circle intersects the rectangle, which
    -- ensures collection when the unicorn "enters" the coin from any direction.
    local ux = unicorn.x or 0
    local uy = unicorn.y or 0
    local uw = unicorn.width or 0
    local uh = unicorn.height or 0
    local left = ux - uw / 2
    local right = ux + uw / 2
    local top = uy - uh / 2
    local bottom = uy + uh / 2

    local cx = self.x or 0
    local cy = self.y or 0
    -- Find closest point on rectangle to circle center
    local closestX = math.max(left, math.min(cx, right))
    local closestY = math.max(top, math.min(cy, bottom))
    local dx = cx - closestX
    local dy = cy - closestY
    local tol = 1 -- small epsilon to avoid strict off-by-one misses
    local rr = (self.radius or 0) + tol
    return (dx*dx + dy*dy) <= (rr * rr)
end

function Coin:draw()
    love.graphics.setColor(1, 0.85, 0)
    love.graphics.circle('fill', self.x, self.y, self.radius)
    love.graphics.setColor(1, 1, 0.6)
    love.graphics.circle('fill', self.x - 4, self.y - 4, self.radius * 0.5)
    love.graphics.setColor(0.8, 0.6, 0)
    love.graphics.circle('line', self.x, self.y, self.radius)
end

return Coin
