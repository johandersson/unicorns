-- troll_manager.lua
local Troll = require('troll')

local TrollManager = {}
TrollManager.__index = TrollManager

function TrollManager:new(game)
    local obj = {
        game = game,
        trolls = {},
        pool = {},
        base_speed = game.troll_base_speed or 200,
        spawn_timer = 0,
        spawn_interval = game.troll_spawn_interval or 4.0
    }
    setmetatable(obj, self)
    return obj
end

function TrollManager:add(x, y, speed)
    local troll
    if #self.pool > 0 then
        troll = table.remove(self.pool)
        troll:reset(x, y, speed)
    else
        troll = Troll:new(x, y, speed)
    end
    troll.target = self.game.unicorn
    table.insert(self.trolls, {troll = troll, active = true})
end

function TrollManager:update(dt)
    local i = 1
    while i <= #self.trolls do
        local entry = self.trolls[i]
        local t = entry.troll
        if entry.active then
            t:update(dt, self.game.unicorn)
            -- Optimized collision detection (squared distance to avoid sqrt, early exit)
            local dx = self.game.unicorn.x - t.x
            local dy = self.game.unicorn.y - t.y
            -- Use squared distance: 40^2 = 1600 (O(1) comparison vs O(1) with better constants)
            if dx*dx + dy*dy < 1600 then
                table.insert(self.pool, t)
                self.trolls[i] = self.trolls[#self.trolls]
                table.remove(self.trolls)
                self.game.lives = (self.game.lives or 0) - 1
                -- clamp and ensure integer
                self.game.lives = math.max(0, math.floor(self.game.lives))
                if self.game.lives <= 0 then
                    self.game.game_over = true
                else
                    self.game.paused = true
                    self.game.death_timer = 0
                    self.game.flash_alpha = 1
                end
                break
            end
            if t.y > self.game.height + 50 then
                table.insert(self.pool, t)
                self.trolls[i] = self.trolls[#self.trolls]
                table.remove(self.trolls)
            else
                i = i + 1
            end
        else
            self.trolls[i] = self.trolls[#self.trolls]
            table.remove(self.trolls)
        end
    end
    -- optional periodic spawn scaled by game.stage
    self.spawn_timer = self.spawn_timer + dt
    if self.spawn_timer >= self.spawn_interval then
        self.spawn_timer = self.spawn_timer - self.spawn_interval
        local count = (math.random() < math.min(0.25 + self.game.stage * 0.05, 0.8)) and 1 or 0
        for j = 1, count do
            local sx = math.random(0, self.game.width)
            local speed = self.base_speed + math.random(-30, 60)
            self:add(sx, -10, speed)
        end
    end
end

function TrollManager:draw()
    for _, entry in ipairs(self.trolls) do
        if entry.active then
            entry.troll:draw()
        end
    end
end

return TrollManager
