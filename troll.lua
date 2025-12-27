Troll = {}

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

function Troll:update(dt)
    self.y = self.y + self.speed * dt
end

function Troll:draw()
    love.graphics.setColor(0, 0.8, 0) -- green body
    love.graphics.circle('fill', self.x, self.y, 20)
    love.graphics.setColor(1, 0, 0) -- red eyes
    love.graphics.circle('fill', self.x - 6, self.y - 6, 4)
    love.graphics.circle('fill', self.x + 6, self.y - 6, 4)
    love.graphics.setColor(0, 0, 0) -- black pupils
    love.graphics.circle('fill', self.x - 6, self.y - 6, 2)
    love.graphics.circle('fill', self.x + 6, self.y - 6, 2)
end

return Troll