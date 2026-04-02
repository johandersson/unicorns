--[[
  Rainbow Quest - Unicorn Flight with Math
  Copyright (C) 2026 Johan Andersson

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program. If not, see <https://www.gnu.org/licenses/>.
--]]

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
    -- AABB collision using actual unicorn dimensions + generous pickup padding
    local ux = unicorn.x or 0
    local uy = unicorn.y or 0

    -- Unicorn collection area: true half-size + generous pickup margin
    local uni_half_w = (unicorn.width or 40) * 0.5 + 25
    local uni_half_h = (unicorn.height or 30) * 0.5 + 25

    -- Coin collection extent
    local coin_extent = self.radius + 5

    -- Collect when unicorn area overlaps coin area
    return math.abs(ux - self.x) < (uni_half_w + coin_extent) and
           math.abs(uy - self.y) < (uni_half_h + coin_extent)
end

function Coin:draw()
    local time = love.timer.getTime()
    local pulse = math.sin(time * 4) * 0.1 + 1  -- Pulsing effect
    local glow_size = self.radius * pulse * 1.3
    
    -- Outer glow (like Super Mario coins)
    love.graphics.setColor(1, 1, 0.5, 0.3)
    love.graphics.circle('fill', self.x, self.y, glow_size)
    
    -- Main coin body (golden)
    love.graphics.setColor(1, 0.84, 0)
    love.graphics.circle('fill', self.x, self.y, self.radius)
    
    -- Inner bright center (shiny)
    love.graphics.setColor(1, 1, 0.6)
    love.graphics.circle('fill', self.x - self.radius * 0.2, self.y - self.radius * 0.2, self.radius * 0.4)
    
    -- Edge highlight (top-left shine)
    love.graphics.setColor(1, 1, 0.9, 0.8)
    love.graphics.circle('fill', self.x - self.radius * 0.3, self.y - self.radius * 0.3, self.radius * 0.25)
    
    -- Darker outline for definition
    love.graphics.setColor(0.7, 0.55, 0)
    love.graphics.setLineWidth(2)
    love.graphics.circle('line', self.x, self.y, self.radius)
    
    -- Inner detail ring
    love.graphics.setColor(1, 0.9, 0.3, 0.6)
    love.graphics.setLineWidth(1)
    love.graphics.circle('line', self.x, self.y, self.radius * 0.7)
end

return Coin
