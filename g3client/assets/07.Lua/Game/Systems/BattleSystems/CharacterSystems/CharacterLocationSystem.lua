--[[
location系统
]]

CharacterLocationSystem = {}

local self = CharacterLocationSystem

function CharacterLocationSystem.Initialize()
    BlockManager.AddListener({Location}, self.onLocationChanged)
end

function CharacterLocationSystem.Shutdown()
    BlockManager.RemoveListener({Location}, self.onLocationChanged)
end

function CharacterLocationSystem.onLocationChanged(location, k, v)
    if k == 'position' then
        local parent = location.gameObject.transform.parent
        location.gameObject.transform.localPosition = parent and parent:InverseTransformPoint(v.x, v.y, 0) or v
    end
end