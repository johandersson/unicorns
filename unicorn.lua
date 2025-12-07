-- unicorn.lua
Unicorn = {}

function Unicorn:new(x, y)
    local obj = {
        x = x or 400,
        y = y or 200,
        vx = 0,
        vy = 0,
        speed = 200,
        gravity = 400,  -- Strong gravity for challenge
        width = 40,
        height = 30
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Unicorn:update(dt)
    -- Horizontal movement
    if love.keyboard.isDown('left') then
        self.vx = -self.speed
    elseif love.keyboard.isDown('right') then
        self.vx = self.speed
    else
        self.vx = 0
    end

    -- Vertical movement (flying up only, gravity pulls down)
    if love.keyboard.isDown('up') then
        self.vy = -self.speed
    else
        -- Apply gravity
        self.vy = self.vy + self.gravity * dt
    end

    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    -- Keep in bounds
    if self.x - self.width / 2 < 0 then self.x = self.width / 2 end
    if self.x + self.width / 2 > 800 then self.x = 800 - self.width / 2 end
    if self.y - self.height / 2 < 0 then self.y = self.height / 2 end
    if self.y + self.height / 2 > 550 then
        self.y = 550 - self.height / 2
        -- Game over if touch ground
        return true -- signal game over
    end
    return false
end

function Unicorn:draw()
    drawUnicorn(self.x, self.y)
end

function drawUnicorn(x, y)
    -- Body (horse-like rectangle, facing right)
    love.graphics.setColor(1, 0.7, 0.8)
    love.graphics.rectangle('fill', x - 5, y - 5, 25, 15)

    -- Neck (longer, angled right)
    love.graphics.ellipse('fill', x + 15, y - 15, 6, 18)

    -- Head (oval, facing right)
    love.graphics.ellipse('fill', x + 18, y - 30, 8, 10)

    -- Horn glow (larger yellow behind)
    love.graphics.setColor(1, 1, 0.5, 0.5)
    love.graphics.polygon('fill', x + 23, y - 34, x + 21, y - 34, x + 17, y - 46)

    -- Horn (curved, on the right side)
    love.graphics.setColor(1, 1, 0)
    love.graphics.polygon('fill', x + 22, y - 35, x + 20, y - 35, x + 18, y - 45)

    -- Eyes (on the right side of head)
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle('fill', x + 24, y - 32, 1.5)
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle('fill', x + 23.5, y - 33, 0.5)

    -- Mane (rainbow flowing right)
    love.graphics.setColor(1, 0, 0) -- Red
    love.graphics.arc('fill', x + 25, y - 20, 12, -math.pi/2, math.pi/2)
    love.graphics.setColor(1, 0.5, 0) -- Orange
    love.graphics.arc('fill', x + 24, y - 21, 11, -math.pi/2, math.pi/2)
    love.graphics.setColor(1, 1, 0) -- Yellow
    love.graphics.arc('fill', x + 23, y - 22, 10, -math.pi/2, math.pi/2)
    love.graphics.setColor(0, 1, 0) -- Green
    love.graphics.arc('fill', x + 22, y - 23, 9, -math.pi/2, math.pi/2)
    love.graphics.setColor(0, 0, 1) -- Blue
    love.graphics.arc('fill', x + 21, y - 24, 8, -math.pi/2, math.pi/2)
    love.graphics.setColor(0.5, 0, 1) -- Indigo
    love.graphics.arc('fill', x + 20, y - 25, 7, -math.pi/2, math.pi/2)

    -- Tail (rainbow on the left)
    love.graphics.setColor(1, 0, 0) -- Red
    love.graphics.arc('fill', x - 5, y, 8, math.pi/2, 3*math.pi/2)
    love.graphics.setColor(1, 0.5, 0) -- Orange
    love.graphics.arc('fill', x - 4, y - 1, 7, math.pi/2, 3*math.pi/2)
    love.graphics.setColor(1, 1, 0) -- Yellow
    love.graphics.arc('fill', x - 3, y - 2, 6, math.pi/2, 3*math.pi/2)

    -- Legs (horse-like, positioned accordingly)
    love.graphics.setColor(1, 0.7, 0.8)
    love.graphics.rectangle('fill', x + 18, y + 8, 3, 25)
    love.graphics.rectangle('fill', x + 12, y + 8, 3, 25)
    love.graphics.rectangle('fill', x + 6, y + 8, 3, 25)
    love.graphics.rectangle('fill', x, y + 8, 3, 25)
    -- Hooves (black)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('fill', x + 17, y + 32, 5, 3)
    love.graphics.rectangle('fill', x + 11, y + 32, 5, 3)
    love.graphics.rectangle('fill', x + 5, y + 32, 5, 3)
    love.graphics.rectangle('fill', x - 1, y + 32, 5, 3)

    -- Ears (pointed, on right)
    love.graphics.setColor(1, 0.7, 0.8)
    love.graphics.polygon('fill', x + 26, y - 35, x + 23, y - 40, x + 20, y - 35)

    -- Sparkles (magical effect)
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle('fill', x + 25, y - 40, 1)
    love.graphics.circle('fill', x + 28, y - 38, 0.5)
    love.graphics.circle('fill', x + 20, y - 42, 0.8)
    love.graphics.circle('fill', x + 15, y - 10, 0.6)
    love.graphics.circle('fill', x - 8, y + 5, 0.7)
end

return Unicorn