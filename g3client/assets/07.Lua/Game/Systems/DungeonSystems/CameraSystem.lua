--[[
摄像机系统
]]

CameraSystem = {}

local self = CameraSystem

self.co = nil

function CameraSystem.Initialize()
    self.co = Coroutine.Start(self.update)
end

function CameraSystem.Shutdown()
    if self.co then
        Coroutine.Stop(self.co)
        self.co = nil
    end
end

function CameraSystem.update()
    while true do
        local tuples = BlockManager.GetMatchedTuples({Controllable, Location, Moving})
        if tuples and #tuples > 0 then
            local target = tuples[1]
            local position = target.location.position

            Camera.main.transform.position = Vector3(position.x, position.y, Camera.main.transform.position.z)
        end
        Coroutine.Step()
    end
end