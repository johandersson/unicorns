describe("Rainbow", function()
    it("should create with empty segments", function()
        local r = Rainbow:new()
        assert.are.equal(0, #r.segments)
        assert.are.equal(1, r.index)
    end)

    it("should add segment after interval", function()
        local r = Rainbow:new()
        r:addSegment(100, 200, 0.15) -- More than 0.1
        assert.are.equal(1, #r.segments)
        assert.are.equal(100, r.segments[1].x)
        assert.are.equal(200, r.segments[1].y)
    end)

    it("should not add segment before interval", function()
        local r = Rainbow:new()
        r:addSegment(100, 200, 0.05) -- Less than 0.1
        assert.are.equal(0, #r.segments)
    end)

    it("should cycle colors", function()
        local r = Rainbow:new()
        for i = 1, 7 do
            r:addSegment(100, 200, 0.15)
        end
        assert.are.equal(7, #r.segments)
        assert.are.equal(1, r.index) -- Back to 1
    end)

    it("should be complete after 7 segments", function()
        local r = Rainbow:new()
        for i = 1, 7 do
            r:addSegment(100, 200, 0.15)
        end
        assert.is_true(r:isComplete())
    end)

    it("should reset properly", function()
        local r = Rainbow:new()
        for i = 1, 7 do
            r:addSegment(100, 200, 0.15)
        end
        r:reset()
        assert.are.equal(0, #r.segments)
        assert.are.equal(1, r.index)
    end)
end)