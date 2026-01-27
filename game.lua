-- game.lua
Game = {}

function Game:new()
    local obj = {
        width = love.graphics.getWidth(),
        height = love.graphics.getHeight(),
        unicorn = nil,
        coins = 100,
        game_over = false,
        ground = 0,
        stage = 1,
        sun_x = 0,
        sun_y = 50,
        lives = 3,
        trolls = {},
        troll_pool = {},
        paused = false,
        death_timer = 0,
        respawn_delay = 1.2,
        flash_alpha = 0
    }
    obj.ground = obj.height - 50
    obj.sun_x = obj.width / 2

    -- Create background canvas
    obj.background_canvas = love.graphics.newCanvas(obj.width, obj.height)
    love.graphics.setCanvas(obj.background_canvas)

    -- Draw rainbow background
    local rainbow_colors = {
        {1, 0, 0},     -- red
        {1, 0.5, 0},   -- orange
        {1, 1, 0},     -- yellow
        {0, 1, 0},     -- green
        {0, 0, 1},     -- blue
        {0.3, 0, 0.5}, -- indigo
        {0.5, 0, 0.5}  -- violet
    }
    for i = 1, 7 do
        love.graphics.setColor(unpack(rainbow_colors[i]))
        love.graphics.arc('fill', obj.width / 2, obj.height, (8 - i) * 50, math.pi, 2 * math.pi)
    end

    -- Draw sun
    love.graphics.setColor(1, 1, 0)
    love.graphics.circle('fill', obj.sun_x, obj.sun_y, 40)

    -- Draw ground
    love.graphics.setColor(0.2, 0.8, 0.2)
    love.graphics.rectangle('fill', 0, obj.ground, obj.width, 50)

    -- Draw flowers
    love.graphics.setColor(0, 0.5, 0) -- green stems
    for i = 1, 3 do
        local x = obj.width * (i / 4)
        love.graphics.line(x, obj.ground, x, obj.ground - 20)
    end
    love.graphics.setColor(1, 0, 0) -- red petals
    for i = 1, 3 do
        local x = obj.width * (i / 4)
        love.graphics.circle('fill', x, obj.ground - 20, 5)
        love.graphics.circle('fill', x - 5, obj.ground - 25, 5)
        love.graphics.circle('fill', x + 5, obj.ground - 25, 5)
    end
    love.graphics.setColor(1, 1, 0) -- yellow centers
    for i = 1, 3 do
        local x = obj.width * (i / 4)
        love.graphics.circle('fill', x, obj.ground - 20, 2)
    end

    love.graphics.setCanvas() -- back to default

    obj.unicorn = require('unicorn'):new(obj.width / 2, obj.height / 2, obj.ground, obj.width)
    setmetatable(obj, self)
    self.__index = self
    obj:addTroll(math.random(0, obj.width), -10, 200)
    return obj
end

function Game:addTroll(x, y, speed)
    local troll
    if #self.troll_pool > 0 then
        troll = table.remove(self.troll_pool)
        troll:reset(x, y, speed)
    else
        troll = require('troll'):new(x, y, speed)
    end
    troll.target = self.unicorn
    table.insert(self.trolls, {troll = troll, active = true})
end

function Game:update(dt)
    if self.game_over then return end

    local hit_ground = self.unicorn:update(dt)
    if hit_ground then
        self.lives = self.lives - 1
        if self.lives <= 0 then
            self.game_over = true
            return
        else
            -- pause and show death message, then respawn after delay
            self.paused = true
            self.death_timer = 0
            self.flash_alpha = 1
        end
    end

    -- If paused due to death, advance death timer and respawn when ready
    if self.paused then
        self.death_timer = self.death_timer + dt
        self.flash_alpha = math.max(0, 1 - (self.death_timer / self.respawn_delay))
        if self.death_timer >= self.respawn_delay then
            self.paused = false
            -- respawn unicorn
            self.unicorn = require('unicorn'):new(self.width / 2, self.height / 2, self.ground, self.width)
            -- update troll targets to the new unicorn
            for _, entry in ipairs(self.trolls) do
                entry.troll.target = self.unicorn
                entry.active = true
            end
        end
        return
    end

    -- Update trolls (swap-remove loop to avoid O(N) shifts)
    local i = 1
    while i <= #self.trolls do
        local entry = self.trolls[i]
        local t = entry.troll
        if entry.active then
            t:update(dt, self.unicorn)
            -- collision with unicorn
            if math.abs(self.unicorn.x - t.x) < 40 and math.abs(self.unicorn.y - t.y) < 40 then
                -- recycle troll into pool
                table.insert(self.troll_pool, t)
                -- swap-remove current entry
                self.trolls[i] = self.trolls[#self.trolls]
                table.remove(self.trolls)
                -- handle lives and start death pause
                self.lives = self.lives - 1
                if self.lives <= 0 then
                    self.game_over = true
                else
                    self.paused = true
                    self.death_timer = 0
                    self.flash_alpha = 1
                end
                break
            end

            -- recycle trolls that fall off bottom
            if t.y > self.height + 50 then
                table.insert(self.troll_pool, t)
                self.trolls[i] = self.trolls[#self.trolls]
                table.remove(self.trolls)
            else
                i = i + 1
            end
        else
            -- remove any inactive entries defensively
            self.trolls[i] = self.trolls[#self.trolls]
            table.remove(self.trolls)
        end
    end

    -- Check if reached the sun
    if self.unicorn.y < self.sun_y + 40 and math.abs(self.unicorn.x - self.sun_x) < 40 then
        self.coins = self.coins + 20
        self.stage = self.stage + 1
        self.unicorn = require('unicorn'):new(self.width / 2, self.height / 2, self.ground, self.width)
        self:addTroll(math.random(0, self.width), -10, 200)
    end
end

function Game:draw()
    -- Draw background canvas
    love.graphics.draw(self.background_canvas, 0, 0)

    -- Draw unicorn
    self.unicorn:draw()

    -- Draw trolls
    for _, entry in ipairs(self.trolls) do
        if entry.active then
            entry.troll:draw()
        end
    end

    -- Draw UI
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Coins: " .. self.coins, 10, 10)
    love.graphics.print("Stage: " .. self.stage, 10, 30)
    love.graphics.print("Lives: " .. self.lives, 10, 50)

    -- Draw game over
    if self.game_over then
        love.graphics.setColor(1, 0, 0)
        love.graphics.printf("Game Over! Press R to restart", 0, self.height / 2, self.width, 'center')
    end

    -- Death flash / message when paused
    if self.paused and not self.game_over then
        -- semi-transparent overlay
        love.graphics.setColor(0, 0, 0, 0.4 * self.flash_alpha)
        love.graphics.rectangle('fill', 0, 0, self.width, self.height)

        love.graphics.setColor(1, 1, 1)
        local msg = "You died! Lives left: " .. self.lives
        love.graphics.setFont(love.graphics.newFont(28))
        love.graphics.printf(msg, 0, self.height / 2 - 20, self.width, 'center')

        love.graphics.setFont(love.graphics.newFont(12))
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Respawning...", 0, self.height / 2 + 20, self.width, 'center')
    end
end

function Game:resize(w, h)
    self.width = w
    self.height = h
    self.ground = h - 50
    self.sun_x = w / 2

    -- Recreate background canvas
    self.background_canvas = love.graphics.newCanvas(w, h)
    love.graphics.setCanvas(self.background_canvas)

    -- Draw rainbow background
    local rainbow_colors = {
        {1, 0, 0},     -- red
        {1, 0.5, 0},   -- orange
        {1, 1, 0},     -- yellow
        {0, 1, 0},     -- green
        {0, 0, 1},     -- blue
        {0.3, 0, 0.5}, -- indigo
        {0.5, 0, 0.5}  -- violet
    }
    for i = 1, 7 do
        love.graphics.setColor(unpack(rainbow_colors[i]))
        love.graphics.arc('fill', w / 2, h, (8 - i) * 50, math.pi, 2 * math.pi)
    end

    -- Draw sun
    love.graphics.setColor(1, 1, 0)
    love.graphics.circle('fill', self.sun_x, self.sun_y, 40)

    -- Draw ground
    love.graphics.setColor(0.2, 0.8, 0.2)
    love.graphics.rectangle('fill', 0, self.ground, w, 50)

    -- Draw flowers
    love.graphics.setColor(0, 0.5, 0) -- green stems
    for i = 1, 3 do
        local x = w * (i / 4)
        love.graphics.line(x, self.ground, x, self.ground - 20)
    end
    love.graphics.setColor(1, 0, 0) -- red petals
    for i = 1, 3 do
        local x = w * (i / 4)
        love.graphics.circle('fill', x, self.ground - 20, 5)
        love.graphics.circle('fill', x - 5, self.ground - 25, 5)
        love.graphics.circle('fill', x + 5, self.ground - 25, 5)
    end
    love.graphics.setColor(1, 1, 0) -- yellow centers
    for i = 1, 3 do
        local x = w * (i / 4)
        love.graphics.circle('fill', x, self.ground - 20, 2)
    end

    love.graphics.setCanvas() -- back to default
end

function Game:keypressed(key)
    if self.game_over and key == 'r' then
        -- Restart
        self.unicorn = require('unicorn'):new(self.width / 2, self.height / 2, self.ground, self.width)
        self.coins = 100
        self.game_over = false
        self.stage = 1
        self.lives = 3
        self.trolls = {}
        self.troll_pool = {}
        self:addTroll(math.random(0, self.width), -10, 200)
    end
end

return Game