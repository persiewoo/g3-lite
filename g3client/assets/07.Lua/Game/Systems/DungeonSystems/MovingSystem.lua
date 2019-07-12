--[[
移动系统
]]

MovingSystem = {}

local self = MovingSystem

self.co = nil

function MovingSystem.Initialize()
    self.co = Coroutine.Start(self.update)
end

function MovingSystem.Shutdown()
    if self.co then
        Coroutine.Stop(self.co)
        self.co = nil
    end
end

function MovingSystem.update()
    while true do
        local tuples = BlockManager.GetMatchedTuples({Location, Moving, Body2d}) or {}

        for i = 1, #tuples do
            local target = tuples[i]
            local moving = target.moving
            local co = moving.co
            local speed = moving.speed
            local dir = moving.dir

            if speed > 0 and dir.magnitude > 0 then
                local to = target.location.position + moving.dir * moving.speed * TimeManager.interval
                to = target.body2d.view:MoveTo(to)
                target.location.position = to
            end
        end

        Coroutine.Step()
    end
end