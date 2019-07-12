--[[
entity对象销毁
]]

DestroySystem = {}

local self = DestroySystem

function DestroySystem.Initialize()
    BlockManager.AddDestroyListener({}, self.onDestroyed)
end

function DestroySystem.Shutdown()
    BlockManager.RemoveDestroyListener({}, self.onDestroyed)
end

function DestroySystem.onDestroyed(entity, block)
    print('entity ' .. entity.name .. ' has delete by ' .. (block and ('block ' .. block.blockName) or 'entity self'))
    entity:Destroy()
end