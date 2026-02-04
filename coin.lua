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
    -- Optimized circle-rectangle collision (cache calculations, early exit)
    local ux = unicorn.x or 0
    local uy = unicorn.y or 0
    
    -- Pre-calculate half dimensions (avoid repeated division)
    local half_uw = (unicorn.width or 0) * 0.5
    local half_uh = (unicorn.height or 0) * 0.5
    local left = ux - half_uw
    local right = ux + half_uw
    local top = uy - half_uh
    local bottom = uy + half_uh

    local cx = self.x or 0
    local cy = self.y or 0
    
    -- Find closest point on rectangle to circle center
    local closestX = math.max(left, math.min(cx, right))
    local closestY = math.max(top, math.min(cy, bottom))
    local dx = cx - closestX
    local dy = cy - closestY
    
    -- Squared distance comparison (avoid sqrt, pre-calculate squared radius)
    local r_tol = self.radius + 1
    return (dx*dx + dy*dy) <= (r_tol * r_tol)
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
