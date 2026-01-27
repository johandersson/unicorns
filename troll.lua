Troll = {}

local troll_canvas = nil
local TROLL_SIZE = 40

-- Pre-render troll graphic once
if not troll_canvas then
    troll_canvas = love.graphics.newCanvas(TROLL_SIZE, TROLL_SIZE)
    love.graphics.setCanvas(troll_canvas)
    love.graphics.clear(0,0,0,0)
    love.graphics.setColor(0, 0.8, 0) -- green body
    love.graphics.circle('fill', TROLL_SIZE/2, TROLL_SIZE/2, 20)
    love.graphics.setColor(1, 0, 0) -- red eyes
    love.graphics.circle('fill', TROLL_SIZE/2 - 6, TROLL_SIZE/2 - 6, 4)
    love.graphics.circle('fill', TROLL_SIZE/2 + 6, TROLL_SIZE/2 - 6, 4)
    love.graphics.setColor(0, 0, 0) -- black pupils
    love.graphics.circle('fill', TROLL_SIZE/2 - 6, TROLL_SIZE/2 - 6, 2)
    love.graphics.circle('fill', TROLL_SIZE/2 + 6, TROLL_SIZE/2 - 6, 2)
    love.graphics.setCanvas()
end

function Troll:new(x, y, speed)
    local obj = {
        x = x,
        y = y,
        speed = speed
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Troll:reset(x, y, speed)
    self.x = x
    self.y = y
    self.speed = speed
end

function Troll:update(dt, target)
    -- vertical movement
    self.y = self.y + self.speed * dt
    -- horizontal homing towards target if provided (makes trolls harder to escape)
    if target and target.x then
        local dx = target.x - self.x
        -- horizontal homing speed (pixels per second)
        local hspeed = 120
        -- move proportionally but clamp to hspeed*dt
        local move = math.max(-hspeed * dt, math.min(hspeed * dt, dx))
        self.x = self.x + move
    end
end

function Troll:draw()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(troll_canvas, self.x - TROLL_SIZE/2, self.y - TROLL_SIZE/2)
end

return Troll