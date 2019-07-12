--[[
行为树系统
]]

BehaviorTreeSystem = {}

local self = BehaviorTreeSystem

function BehaviorTreeSystem.Initialize()
    BlockManager.AddListener({AIBT}, self.onBtChanged)
end

function BehaviorTreeSystem.Shutdown()
    BlockManager.RemoveListener({AIBT}, self.onBtChanged)
end

function BehaviorTreeSystem.onBtChanged(aibt, k, v, state)
    if aibt.enable then
        aibt.view:Run()
    else
        aibt.view:Stop()
    end
end