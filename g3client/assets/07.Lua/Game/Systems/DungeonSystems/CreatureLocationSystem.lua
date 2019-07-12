--[[
角色位置系统
]]

CreatureLocationSystem = {}

local self = CreatureLocationSystem

function CreatureLocationSystem.Initialize()
    BlockManager.AddListener({Location}, self.onLocationChanged)
end

function CreatureLocationSystem.Shutdown()
    BlockManager.RemoveListener({Location}, self.onLocationChanged)
end

-- 位置改变
function CreatureLocationSystem.onLocationChanged(location, k, v)
    if location.manual and k == 'position' then
        local parent = location.gameObject.transform.parent
        location.gameObject.transform.localPosition = parent and parent:InverseTransformPoint(v.x, v.y, 0) or v
    end
end