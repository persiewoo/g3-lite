--[[
渲染排序系统
]]

RenderingSortSystem = {}

local self = RenderingSortSystem

function RenderingSortSystem.Initialize()
    BlockManager.AddListener({Location, Avatar, filter = {Location}}, self.onLocationChanged, {BlockState.added, BlockState.changed})
end

function RenderingSortSystem.Shutdown()
    BlockManager.RemoveListener({Location}, self.onLocationChanged)
end

-- 位置改变，动态更改渲染层次
function RenderingSortSystem.onLocationChanged(block, k, v, state, tuple)
    if k == 'position' then
        tuple.avatar.view:ChangeSortingOrder(1000 - math.ceil(v.y * 10))
    end
end